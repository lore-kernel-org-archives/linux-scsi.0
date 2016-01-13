From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: RE: [PATCH v3 04/17] be2iscsi: Fix to synchronize tag allocation
 using spin_lock
Date: Wed, 13 Jan 2016 08:38:02 +0530
Message-ID: <07f50d49647a69bfaa4ba2454dd099dc@mail.gmail.com>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450859676-22025-5-git-send-email-jitendra.bhivare@avagotech.com> <5694195F.6060501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36231 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbcAMDIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2016 22:08:04 -0500
Received: by mail-yk0-f175.google.com with SMTP id v14so381195707ykd.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2016 19:08:04 -0800 (PST)
In-Reply-To: <5694195F.6060501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Thanks Mike.

It is not needed, will send the updated diff.

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
Sent: Tuesday, January 12, 2016 2:37 AM
To: Jitendra Bhivare; linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 04/17] be2iscsi: Fix to synchronize tag allocation
using spin_lock

On 12/23/2015 02:34 AM, Jitendra Bhivare wrote:
> alloc_mcc_tag/free_mcc_tag is now done under mcc_lock spin_lock
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c
> b/drivers/scsi/be2iscsi/be_cmds.c index 1913e9e..502c9b6 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -121,6 +121,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba
> *phba)  {
>  	unsigned int tag = 0;
>
> +	spin_lock_bh(&phba->ctrl.mcc_lock);
>  	if (phba->ctrl.mcc_tag_available) {
>  		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
>  		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0; @@
-134,6
> +135,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
>  		else
>  			phba->ctrl.mcc_alloc_index++;
>  	}
> +	spin_unlock_bh(&phba->ctrl.mcc_lock);
>  	return tag;
>  }
>
> @@ -254,7 +256,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>
>  void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)  {
> -	spin_lock(&ctrl->mbox_lock);
> +	spin_lock_bh(&ctrl->mcc_lock);
>  	tag = tag & 0x000000FF;
>  	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
>  	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1)) @@ -262,7 +264,7 @@

> void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
>  	else
>  		ctrl->mcc_free_index++;
>  	ctrl->mcc_tag_available++;
> -	spin_unlock(&ctrl->mbox_lock);
> +	spin_unlock_bh(&ctrl->mcc_lock);
>  }
>

What was the _bh change for?
