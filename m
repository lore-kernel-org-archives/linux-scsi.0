From: "Petri T. Koistinen" <petri.koistinen@iki.fi>
Subject: [PATCH] drivers/scsi/aic7xxx/aic79xx_osm.c: ahd_linux_dev_reset:
 add check for malloc failure
Date: Sun, 2 May 2004 17:25:25 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0405021721030.5347@dsl-prvgw1cc4.dial.inet.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep15.inet.fi ([194.251.242.213]:58300 "EHLO fep15.inet.fi")
	by vger.kernel.org with ESMTP id S263100AbUEBOZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 May 2004 10:25:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Trivial Patch Collection <trivial@rustcorp.com.au>, linux-scsi@vger.kernel.org

Hi!

Malloc can fail, so here check for it. I hope this is correct fix.
Bug info from http://linuxbugs.coverity.com/ site.

Best regards,
Petri Koistinen

--- linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c.orig	2004-05-02 17:07:25.000000000 +0300
+++ linux-2.5/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-05-02 17:09:59.000000000 +0300
@@ -1548,40 +1548,42 @@ ahd_linux_dev_reset_complete(Scsi_Cmnd *

 /*
  * Attempt to send a target reset message to the device that timed out.
  */
 static int
 ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 {
 	struct	ahd_softc *ahd;
 	struct	scsi_cmnd *recovery_cmd;
 	struct	ahd_linux_device *dev;
 	struct	ahd_initiator_tinfo *tinfo;
 	struct	ahd_tmode_tstate *tstate;
 	struct	scb *scb;
 	struct	hardware_scb *hscb;
 	u_long	s;
 	struct	timer_list timer;
 	int	retval;

 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 	recovery_cmd = malloc(sizeof(struct scsi_cmnd), M_DEVBUF, M_WAITOK);
+	if (recovery_cmd == NULL)
+		return (FAILED);
 	memset(recovery_cmd, 0, sizeof(struct scsi_cmnd));
 	recovery_cmd->device = cmd->device;
 	recovery_cmd->scsi_done = ahd_linux_dev_reset_complete;
 #if AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
 		printf("%s:%d:%d:%d: Device reset called for cmd %p\n",
 		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
 		       cmd->device->lun, cmd);
 #endif
 	ahd_midlayer_entrypoint_lock(ahd, &s);

 	dev = ahd_linux_get_device(ahd, cmd->device->channel, cmd->device->id,
 				   cmd->device->lun, /*alloc*/FALSE);
 	if (dev == NULL) {
 		ahd_midlayer_entrypoint_unlock(ahd, &s);
 		return (FAILED);
 	}
 	if ((scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX)) == NULL) {
 		ahd_midlayer_entrypoint_unlock(ahd, &s);
 		return (FAILED);
