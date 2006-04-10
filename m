From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patch] libata scsi eh fixed to use transport class
Date: Mon, 10 Apr 2006 14:58:45 -0400
Message-ID: <443AAAE5.2020208@garzik.org>
References: <20060410185039.GA32027@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020001030408040004000904"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060410185039.GA32027@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020001030408040004000904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> diff --git a/drivers/scsi/sata_mv.c b/drivers/scsi/sata_mv.c
> index fa901fd..0ebf136 100644
> --- a/drivers/scsi/sata_mv.c
> +++ b/drivers/scsi/sata_mv.c
> @@ -378,8 +378,6 @@ static struct scsi_host_template mv_sht 
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
>  	.queuecommand		= ata_scsi_queuecmd,
> -	.eh_strategy_handler	= ata_scsi_error,
> -	.can_queue		= MV_USE_Q_DEPTH,
>  	.this_id		= ATA_SHT_THIS_ID,
>  	.sg_tablesize		= MV_MAX_SG_CT / 2,
>  	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,

And the obvious patch (attached) was just checked in, to fix the above 
deletion that was in Christoph's original patch, subsequently merged.

	Jeff



--------------020001030408040004000904
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

commit 1b72373491a061be6d456d219a4e2d054ac2aaad
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Apr 10 14:56:39 2006 -0400

    [libata] sata_mv: fix can_queue line accidentally removed in scsi-eh patch

1b72373491a061be6d456d219a4e2d054ac2aaad
diff --git a/drivers/scsi/sata_mv.c b/drivers/scsi/sata_mv.c
index 0ebf136..b64b077 100644
--- a/drivers/scsi/sata_mv.c
+++ b/drivers/scsi/sata_mv.c
@@ -378,6 +378,7 @@ static struct scsi_host_template mv_sht 
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= MV_USE_Q_DEPTH,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,

--------------020001030408040004000904--
