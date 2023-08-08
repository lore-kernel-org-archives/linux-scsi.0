Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA95C04E69
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 21:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbjHHVIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 17:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbjHHVIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 17:08:02 -0400
Received: from mail.hugovil.com (mail.hugovil.com [162.243.120.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0637E5A69;
        Tue,  8 Aug 2023 13:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hugovil.com
        ; s=x; h=Subject:Content-Transfer-Encoding:Mime-Version:Message-Id:Cc:To:From
        :Date:subject:date:message-id:reply-to;
        bh=5I3ARFB3ZlH4m4HRqWi5eYmGenJa2WJgy9folBuUU4w=; b=oduTdsObD0JpHoVqfalNSLjxSm
        xUTafpp4fA6pMSwmRwHkOP24fR5tRyTPtPWYyEAMB/sbhTUQIRH4Rrd/mioDXgFRw1r9yTWQCCEM1
        bpowduIgcsGB2I2A5U7sWdceV6zO2i46PbpoeigmdJ6Zui/ie0dnuxZGWsAySyOOFSH8=;
Received: from modemcable061.19-161-184.mc.videotron.ca ([184.161.19.61]:59142 helo=pettiford)
        by mail.hugovil.com with esmtpa (Exim 4.92)
        (envelope-from <hugo@hugovil.com>)
        id 1qTTKc-0004rm-0X; Tue, 08 Aug 2023 16:29:30 -0400
Date:   Tue, 8 Aug 2023 16:29:29 -0400
From:   Hugo Villeneuve <hugo@hugovil.com>
To:     Brian Masney <bmasney@redhat.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20230808162929.a1b784ad42bd346cd87747b9@hugovil.com>
In-Reply-To: <20230808142650.1713432-2-bmasney@redhat.com>
References: <20230808142650.1713432-1-bmasney@redhat.com>
        <20230808142650.1713432-2-bmasney@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 184.161.19.61
X-SA-Exim-Mail-From: hugo@hugovil.com
Subject: Re: [PATCH 1/2] scsi: ufs: core: convert to dev_err_probe() in
 hba_init
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.hugovil.com)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue,  8 Aug 2023 10:26:49 -0400
Brian Masney <bmasney@redhat.com> wrote:

> Convert ufshcd_variant_hba_init() over to use dev_err_probe() to avoid
> log messages like the following on bootup:
> 
>     ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
>         failed err -517
> 
> While changes are being made here, let's go ahead and clean up the rest
> of that function.

Hi,
you should not combine code cleanup and fixes/improvements in the same
patch, split them.

Hugo Villeneuve


> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  drivers/ufs/core/ufshcd.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 129446775796..90d87cf5e25e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9228,17 +9228,18 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
>  
>  static int ufshcd_variant_hba_init(struct ufs_hba *hba)
>  {
> -	int err = 0;
> +	int ret;
>  
>  	if (!hba->vops)
> -		goto out;
> +		return 0;
>  
> -	err = ufshcd_vops_init(hba);
> -	if (err)
> -		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
> -			__func__, ufshcd_get_var_name(hba), err);
> -out:
> -	return err;
> +	ret = ufshcd_vops_init(hba);
> +	if (ret)
> +		dev_err_probe(hba->dev, ret,
> +			      "%s: variant %s init failed with error %d\n",
> +			      __func__, ufshcd_get_var_name(hba), ret);
> +
> +	return ret;
>  }
>  
>  static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
> -- 
> 2.41.0
> 
