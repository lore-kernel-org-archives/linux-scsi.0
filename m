From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 04/17] be2iscsi: Fix to synchronize tag allocation
 using spin_lock
Date: Mon, 11 Jan 2016 15:06:39 -0600
Message-ID: <5694195F.6060501@cs.wisc.edu>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com> <1450859676-22025-5-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42857 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759133AbcAKVGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2016 16:06:46 -0500
In-Reply-To: <1450859676-22025-5-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org

On 12/23/2015 02:34 AM, Jitendra Bhivare wrote:
> alloc_mcc_tag/free_mcc_tag is now done under mcc_lock spin_lock
> 
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index 1913e9e..502c9b6 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -121,6 +121,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
>  {
>  	unsigned int tag = 0;
>  
> +	spin_lock_bh(&phba->ctrl.mcc_lock);
>  	if (phba->ctrl.mcc_tag_available) {
>  		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
>  		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0;
> @@ -134,6 +135,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
>  		else
>  			phba->ctrl.mcc_alloc_index++;
>  	}
> +	spin_unlock_bh(&phba->ctrl.mcc_lock);
>  	return tag;
>  }
>  
> @@ -254,7 +256,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>  
>  void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
>  {
> -	spin_lock(&ctrl->mbox_lock);
> +	spin_lock_bh(&ctrl->mcc_lock);
>  	tag = tag & 0x000000FF;
>  	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
>  	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
> @@ -262,7 +264,7 @@ void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
>  	else
>  		ctrl->mcc_free_index++;
>  	ctrl->mcc_tag_available++;
> -	spin_unlock(&ctrl->mbox_lock);
> +	spin_unlock_bh(&ctrl->mcc_lock);
>  }
>  

What was the _bh change for?

