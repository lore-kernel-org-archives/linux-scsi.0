Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDF3C761A6
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 12:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6556E20801
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 12:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="fhviTp3O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgBQM6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 07:58:23 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:41042 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727991AbgBQM6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Feb 2020 07:58:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581944302; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=F6hhLqoUemqMuF73oXb4UEU9cz/dkxAFWWHo7Eh0TSQ=;
 b=fhviTp3OMMKGR2AzKrTdH5LrYCbzzTByM+/LK+kEinEzN2W32rG3dQUdvGaN73FOwfqPqQLi
 jrKnbRcaYst99vH78ASM0XdYKjKGvl9vYfOX87qLChPIQoXeEybND0xjx1B9EykSi1UzzJ9k
 ynyPrnPnKcPviXxoCGaWQAdEKrg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4a8ded.7f4a1e1257d8-smtp-out-n01;
 Mon, 17 Feb 2020 12:58:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C827CC447A2; Mon, 17 Feb 2020 12:58:21 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E5411C4479D;
        Mon, 17 Feb 2020 12:58:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Feb 2020 20:58:20 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
In-Reply-To: <20200217093559.16830-2-stanley.chu@mediatek.com>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
 <20200217093559.16830-2-stanley.chu@mediatek.com>
Message-ID: <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-17 17:35, Stanley Chu wrote:
> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime 
> defines
> the minimum time for which the reference clock is required by device 
> during
> transition to LS-MODE or HIBERN8 state.
> 
> Currently this time is detected and stored in
> hba->dev_info.clk_gating_wait_us but applied to vendor implementatios 
> only.
> Make it applied to reference clock named as "ref_clk" in device tree in
> common path.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 744b8254220c..7f60721f54d1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7417,8 +7417,10 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  	struct ufs_clk_info *clki;
>  	struct list_head *head = &hba->clk_list_head;
>  	unsigned long flags;
> +	unsigned long wait_us;
>  	ktime_t start = ktime_get();
>  	bool clk_state_changed = false;
> +	bool ref_clk;
> 
>  	if (list_empty(head))
>  		goto out;
> @@ -7436,7 +7438,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
> 
>  	list_for_each_entry(clki, head, list) {
>  		if (!IS_ERR_OR_NULL(clki->clk)) {
> -			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
> +			ref_clk = !strcmp(clki->name, "ref_clk") ? true : false;
> +			if (skip_ref_clk && ref_clk)
>  				continue;
> 
>  			clk_state_changed = on ^ clki->enabled;
> @@ -7449,6 +7452,9 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  				}
>  			} else if (!on && clki->enabled) {
>  				clk_disable_unprepare(clki->clk);
> +				wait_us = hba->dev_info.clk_gating_wait_us;
> +				if (ref_clk && wait_us)
> +					usleep_range(wait_us, wait_us + 10);

Hi Stanley,

If wait_us is 1us, it would be inappropriate to use usleep_range() here.
You have checks of the delay in patch #2, but why it is not needed here?

Thanks,
Can Guo.

>  			}
>  			clki->enabled = on;
>  			dev_dbg(hba->dev, "%s: clk: %s %sabled\n", __func__,
