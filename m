From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH 04/24] libsas: remove unused ata_task_resp fields
Date: Mon, 19 Dec 2011 09:38:27 +0800
Message-ID: <B5A3BAC491294D0192E63F91DA163B8B@usish.com.cn>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6> <20111217023328.15036.65227.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37670 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1LSBjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2011 20:39:12 -0500
In-Reply-To: <20111217023328.15036.65227.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

> 

[Jack Wang] 
Thanks for looking for this, looks OK for me.
Acked-by: Jack Wang <jack_wang@usish.com>
> Commit 1e34c838 removed the routines to fake the presence of the sata
> control registers, now remove the unused data structure fields to kill
> any remaining confusion.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_ata.c |    4 ----
>  include/scsi/libsas.h         |    7 -------
>  2 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index db9238f..83118d0 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -121,10 +121,6 @@ static void sas_ata_task_done(struct sas_task *task)
>  			if (unlikely(link->eh_info.err_mask))
>  				qc->flags |= ATA_QCFLAG_FAILED;
>  		}
> -
> -		dev->sata_dev.sstatus = resp->sstatus;
> -		dev->sata_dev.serror = resp->serror;
> -		dev->sata_dev.scontrol = resp->scontrol;
>  	} else {
>  		ac = sas_to_ata_err(stat);
>  		if (ac) {
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 6a308d4..6e64b03 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -171,9 +171,6 @@ struct sata_device {
>  	struct ata_port *ap;
>  	struct ata_host ata_host;
>  	struct ata_taskfile tf;
> -	u32 sstatus;
> -	u32 serror;
> -	u32 scontrol;
>  };
> 
>  /* ---------- Domain device ---------- */
> @@ -487,10 +484,6 @@ enum exec_status {
>  struct ata_task_resp {
>  	u16  frame_len;
>  	u8   ending_fis[24];	  /* dev to host or data-in */
> -	u32  sstatus;
> -	u32  serror;
> -	u32  scontrol;
> -	u32  sactive;
>  };
> 
>  #define SAS_STATUS_BUF_SIZE 96
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

