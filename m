Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460A7C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9AC214AF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:43:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="dRQxNzgo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgAMSnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:43:45 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:39048 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgAMSno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 13:43:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578941024; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=n++fX84s76rSeZguThu1VU/fYy13LRbB/w5RZWTUErQ=;
 b=dRQxNzgovuVLrk9Fa6O9mMLlVvE8/Mv3yAIFXUlZSrb47xVTryOCIsxValgMnoftlKbo2qEy
 igyEZ+OwRoxmYthSqcZH1eZhkOFA9DB8e8/HikEflBk8tX5A/3kOKAA1l5PW+V0b7ZnIob1k
 jPbdZpfTjp/x19Jk9iVaXzJdISw=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1cba5d.7f6eb1a466c0-smtp-out-n01;
 Mon, 13 Jan 2020 18:43:41 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB415C447A6; Mon, 13 Jan 2020 18:43:40 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1868EC43383;
        Mon, 13 Jan 2020 18:43:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jan 2020 10:43:40 -0800
From:   asutoshd@codeaurora.org
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: ufs: add max_lu_supported in struct
 ufs_dev_info
In-Reply-To: <20200110183606.10102-2-huobean@gmail.com>
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-2-huobean@gmail.com>
Message-ID: <268bea279e84715f2a3d39ab1edb406d@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-10 10:36, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Add one new parameter max_lu_supported in struct ufs_dev_info,
> which will be used to express exactly how many general LUs being
> supported by UFS device.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index c89f21698629..5ca7ea4f223e 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -530,6 +530,8 @@ struct ufs_dev_info {
>  	bool f_power_on_wp_en;
>  	/* Keeps information if any of the LU is power on write protected */
>  	bool is_lu_power_on_wp;
> +	/* Maximum number of general LU supported by the UFS device */
> +	u8 max_lu_supported;
>  };
> 
>  #define MAX_MODEL_LEN 16

Looks good to me.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
