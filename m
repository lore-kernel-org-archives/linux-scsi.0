Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3475C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB0E217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="S4eVyQXE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgAWGuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 01:50:21 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:40886 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgAWGuV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 01:50:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579762220; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=bswcAiv/CdeJKAnXJ38wrotIhNQOHnYzuVA95WQWG8w=;
 b=S4eVyQXEJ/J6HSCVIMXtlztI/IBMMsD5ESfnYNz3GnX1dMyy9qJxzcOe9+pWPSo6tdWINac2
 b4GXtLO0rLwlY4O9lElstksCLSi/ud2F9eN/OxD21I/OCEEJdeaW2o+rpbfnMWv6MWu+dcl1
 343X4cSw8+PJiTu8tYwM+CUcrfs=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e29422b.7feba64c59d0-smtp-out-n02;
 Thu, 23 Jan 2020 06:50:19 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 939F9C433A2; Thu, 23 Jan 2020 06:50:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A5249C43383;
        Thu, 23 Jan 2020 06:50:16 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jan 2020 14:50:16 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] scsi: ufs: Fix ufshcd_hold() caused scheduling
 while atomic
In-Reply-To: <1579759946-5448-6-git-send-email-cang@codeaurora.org>
References: <1579759946-5448-1-git-send-email-cang@codeaurora.org>
 <1579759946-5448-6-git-send-email-cang@codeaurora.org>
Message-ID: <8b8347dbb9a32c71ba2e6992f30a974c@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can,

On 2020-01-23 14:12, Can Guo wrote:
> The async version of ufshcd_hold(async == true), which is only called
> in queuecommand path as for now, is expected to work in atomic context,
> thus it should not sleep or schedule out. When it runs into the 
> condition
> that clocks are ON but link is still in hibern8 state, it should bail 
> out
> without flushing the clock ungate work.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4dfd705..c316a07 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1542,6 +1542,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  		 */
>  		if (ufshcd_can_hibern8_during_gating(hba) &&
>  		    ufshcd_is_link_hibern8(hba)) {
> +			if (async) {
> +				rc = -EAGAIN;
> +				hba->clk_gating.active_reqs--;
> +				break;
> +			}
>  			spin_unlock_irqrestore(hba->host->host_lock, flags);
>  			flush_work(&hba->clk_gating.ungate_work);
>  			spin_lock_irqsave(hba->host->host_lock, flags);

It looks good to me.

Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
