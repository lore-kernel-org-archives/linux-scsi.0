From: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request  OOPS]
Date: Wed, 25 May 2011 14:44:45 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DDCB1C8.7040708@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 25 May 2011, Jens Axboe wrote:

> While this will fix your particular oops, I don't think it's quite
> right. It's fixing one particular piece of fall out from attempting to
> talk to a removed device, it's not necessarily fixing the full class of
> them. The other checks in scsi_set_medium_removal() aren't related to a
> changing state of the device, they are capability checks.

Below patch pushes the check down to ioctl functions and hopefully should 
cover more ioctl-on-gone-device cases by returning -ENXIO if an attempt 
was made to submit request to a non-running device.

With this patch in place - instead of oopsing I now get a proper I/O error 
on resume.

AFAICT from my limited SCSI layer knowledge - these seem to be the right 
places to check. Would be interested in knowing if there are better/more 
complete ways to handle this but if they are going to take time IMHO it 
certainly doesn't hurt to keep the below patch in.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index d9564fb..c32cade 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -91,6 +91,10 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	int result;
 	struct scsi_sense_hdr sshdr;
 
+	if (!sdev || sdev->sdev_state == SDEV_DEL 
+		|| sdev->sdev_state > SDEV_QUIESCE)
+		return -ENXIO;
+
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
@@ -195,8 +199,9 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
 
-	/* No idea how this happens.... */
-	if (!sdev)
+	/* No idea how !sdev happens.... */
+	if (!sdev || sdev->sdev_state == SDEV_DEL 
+		|| sdev->sdev_state > SDEV_QUIESCE)
 		return -ENXIO;
 
 	/*
@@ -288,6 +293,10 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 {
 	int val, result;
 
+	if (!sdev || sdev->sdev_state == SDEV_DEL 
+		|| sdev->sdev_state > SDEV_QUIESCE) 
+		return -ENXIO;
+
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
 	 * non-blocking */
