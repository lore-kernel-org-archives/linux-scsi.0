From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination.
Date: Sun, 30 Oct 2016 19:43:04 +0100
Message-ID: <2179ecb8-183f-a500-4d65-10f64f0f43cc@suse.de>
References: <1477831417-25655-1-git-send-email-andrey2805@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B9AC4891C615F5DAD18AC976"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477831417-25655-1-git-send-email-andrey2805@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Andrey Grodzovsky <andrey2805@gmail.com>, MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------B9AC4891C615F5DAD18AC976
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

On 10/30/2016 01:43 PM, Andrey Grodzovsky wrote:
> Problem:
> This is a work around for a bug with LSI Fusion MPT SAS2 when
> pefroming secure erase. Due to the very long time the operation
> takes commands issued during the erase will time out and will trigger
> execution of abort hook. Even though the abort hook is called for
> the specifc command which timed out this leads to entire device halt
> (scsi_state terminated) and premature termination of the secured erase.
>
Actually, it is _not_ the erase command which times out, it's the 
successive commands which time out, as the controller is unable to 
process them while erase is running.
I suspect a bug in the SAT-layer from the mpt3sas firmware, which simply 
does not return 'busy' for additional commands when erase is in progress.
That being said, this issue was obscured prior to implementing 
asynchronous aborts, as originally a timeout would be invoking SCSI EH, 
which would wait for all outstanding commands to complete.
So by the time SCSI EH was invoked the erase command was already 
completed, allowing for a successful retry of the failing command.
With asynchronous aborts we don't have this option, as the abort will 
succeed, but the command cannot be retried as the original erase command 
is still running.

In the light of the above I guess we need something like the attached 
patch. I'm not utterly proud of if, but I guess it's the best we can do 
for the moment.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------B9AC4891C615F5DAD18AC976
Content-Type: text/x-patch;
 name="0001-mpt3sas-hack-disable-concurrent-commands-for-ATA_16-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mpt3sas-hack-disable-concurrent-commands-for-ATA_16-.pa";
 filename*1="tch"

>From 1556746987c3b4c1a1a4705625280b1136554f89 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Sun, 30 Oct 2016 14:24:44 +0100
Subject: [PATCH] mpt3sas: hack: disable concurrent commands for ATA_16/ATA_12

There's a bug in the mpt3sas driver/firmware which would not return
BUSY if it's busy processing requests (eg 'erase') and cannot
respond to other commands. Hence these commands will timeout
and eventually start the error handler.
This patch disallows request processing whenever an ATA_12 or
ATA_16 command is received, thereby avoiding this problem.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 97987e7..18b9f09 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4096,6 +4096,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	    sas_device_priv_data->block)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
+	/*
+	 * Hack: block the device for any ATA_12/ATA_16 command
+	 */
+	if (scmd->cmnd[0] == 0xa1 || scmd->cmnd[0] == 0x85) {
+		sas_device_priv_data = scmd->device->hostdata;
+		_scsih_internal_device_block(scmd->device, sas_device_priv_data);
+	}
 	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 		mpi_control = MPI2_SCSIIO_CONTROL_READ;
 	else if (scmd->sc_data_direction == DMA_TO_DEVICE)
@@ -4835,6 +4842,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 
  out:
 
+	if (scmd->cmnd[0] == 0xa1 || scmd->cmnd[0] == 0x85) {
+		sas_device_priv_data = scmd->device->hostdata;
+		_scsih_internal_device_unblock(scmd->device, sas_device_priv_data);
+	}
 	scsi_dma_unmap(scmd);
 
 	scmd->scsi_done(scmd);
-- 
2.6.6


--------------B9AC4891C615F5DAD18AC976--
