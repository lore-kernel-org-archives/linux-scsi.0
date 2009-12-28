From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [patch] off by one in FlashPoint.c
Date: Mon, 28 Dec 2009 12:14:39 -0500
Message-ID: <4B38E77F.2070201@cisco.com>
References: <20091227131446.GI6075@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:16427 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZL1ROk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2009 12:14:40 -0500
In-Reply-To: <20091227131446.GI6075@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org



Dan Carpenter wrote:
> The check should be >= instead of > or we could go past the end of the
> array.

What about the LUN check?   I'm not sure either way, but usually MAX LUN
is the max number of LUNs, not the max LU number, although that's been
in flux lately.

> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> --- orig/drivers/scsi/FlashPoint.c	2009-12-27 11:35:58.000000000 +0200
> +++ devel/drivers/scsi/FlashPoint.c	2009-12-27 11:36:19.000000000 +0200
> @@ -3924,7 +3924,7 @@
>  {
>  	struct sccb_mgr_tar_info *currTar_Info;
>  
> -	if ((p_sccb->TargID > MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
> +	if ((p_sccb->TargID >= MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
>  		return;
>  	}
>  	currTar_Info = &FPT_sccbMgrTbl[p_card][p_sccb->TargID];
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
