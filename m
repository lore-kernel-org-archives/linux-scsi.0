From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination
 (v3)
Date: Thu, 10 Nov 2016 14:54:43 +0100
Message-ID: <20161110135443.GA28767@kroah.com>
References: <CAK=zhgqeRBcMHgvmeQSgRmpC+JBx8vAYoy3Jr8jh6VkV02UFSg@mail.gmail.com>
 <1478785372-5261-1-git-send-email-andrey2805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46108 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932862AbcKJNye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 08:54:34 -0500
Content-Disposition: inline
In-Reply-To: <1478785372-5261-1-git-send-email-andrey2805@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Grodzovsky <andrey2805@gmail.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, igor@media-clone.com, ezra@media-clone.com, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org

On Thu, Nov 10, 2016 at 08:42:52AM -0500, Andrey Grodzovsky wrote:
> Problem:
> This is a work around for a bug with LSI Fusion MPT SAS2 when
> pefroming secure erase. Due to the very long time the operation
> takes commands issued during the erase will time out and will trigger
> execution of abort hook. Even though the abort hook is called for
> the specifc command which timed out this leads to entire device halt
> (scsi_state terminated) and premature termination of the secured erase.
> 
> Fix:
> Set device state to busy while erase in progress to reject any incoming
> commands until the erase is done. The device is blocked any way during
> this time and cannot execute any other command.
> More data and logs can be found here -
> https://drive.google.com/file/d/0B9ocOHYHbbS1Q3VMdkkzeWFkTjg/view
> 
> v2: Update according to example patch by Hannes Reinecke to apply
> the blocking logic to any ATA 12/16 command.
> 
> v3: Use SCSI commands opcodes definitions instead of value and
> correct identation.
> 
> Signed-off-by: Andrey Grodzovsky <andrey2805@gmail.com>
> Cc: <linux-scsi@vger.kernel.org>
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 5a97e32..320f16c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3500,6 +3500,10 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>  	    SAM_STAT_CHECK_CONDITION;
>  }
>  
> +static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
> +{
> +   return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
> +}

Please always run your patches through checkpatch.pl so you don't get a
grumpy maintainer emailing you and telling you to run your patches
through checkpatch.pl...

