From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 5268] New: aic79xx scsi driver causing
	system to hang
Date: Fri, 16 Sep 2005 17:02:58 -0400
Message-ID: <1126904578.4631.2.camel@mulgrave>
References: <20050916120313.7f8969ba.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61589 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751115AbVIQPQL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 11:16:11 -0400
In-Reply-To: <20050916120313.7f8969ba.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-09-16 at 12:03 -0700, Andrew Morton wrote:
> This one's a bit strange.
> 
> It's a post-2.6.12 regression.

Yes, strange to me too.  The changes that went in to aic79xx between
2.6.12 and 2.6.13 were tiny:

 aic79xx_osm.c |   18 +++++++++---------
 aic79xx_osm.h |   17 -----------------
 aic79xx_pci.c |    2 +-
 3 files changed, 10 insertions(+), 27 deletions(-)

I've also attached them below, but I think they were

1) #if -> #ifdef changes
2) removal of the duplicated ENDIAN macros
3) ahd_midlayer_entrypoint_lock/unlock -> ahd_lock/unlock

I can't see how anything in these could produce the shown behaviour.

James

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1505,23 +1505,23 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 	memset(recovery_cmd, 0, sizeof(struct scsi_cmnd));
 	recovery_cmd->device = cmd->device;
 	recovery_cmd->scsi_done = ahd_linux_dev_reset_complete;
-#if AHD_DEBUG
+#ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
 		printf("%s:%d:%d:%d: Device reset called for cmd %p\n",
 		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
 		       cmd->device->lun, cmd);
 #endif
-	ahd_midlayer_entrypoint_lock(ahd, &s);
+	ahd_lock(ahd, &s);
 
 	dev = ahd_linux_get_device(ahd, cmd->device->channel, cmd->device->id,
 				   cmd->device->lun, /*alloc*/FALSE);
 	if (dev == NULL) {
-		ahd_midlayer_entrypoint_unlock(ahd, &s);
+		ahd_unlock(ahd, &s);
 		kfree(recovery_cmd);
 		return (FAILED);
 	}
 	if ((scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX)) == NULL) {
-		ahd_midlayer_entrypoint_unlock(ahd, &s);
+		ahd_unlock(ahd, &s);
 		kfree(recovery_cmd);
 		return (FAILED);
 	}
@@ -1553,7 +1553,7 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 	ahd_queue_scb(ahd, scb);
 
 	scb->platform_data->flags |= AHD_SCB_UP_EH_SEM;
-	spin_unlock_irq(&ahd->platform_data->spin_lock);
+	ahd_unlock(ahd, &s);
 	init_timer(&timer);
 	timer.data = (u_long)scb;
 	timer.expires = jiffies + (5 * HZ);
@@ -1567,10 +1567,10 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 		printf("Timer Expired\n");
 		retval = FAILED;
 	}
-	spin_lock_irq(&ahd->platform_data->spin_lock);
+	ahd_lock(ahd, &s);
 	ahd_schedule_runq(ahd);
 	ahd_linux_run_complete_queue(ahd);
-	ahd_midlayer_entrypoint_unlock(ahd, &s);
+	ahd_unlock(ahd, &s);
 	printf("%s: Device reset returning 0x%x\n", ahd_name(ahd), retval);
 	return (retval);
 }
@@ -1591,11 +1591,11 @@ ahd_linux_bus_reset(Scsi_Cmnd *cmd)
 		printf("%s: Bus reset called for cmd %p\n",
 		       ahd_name(ahd), cmd);
 #endif
-	ahd_midlayer_entrypoint_lock(ahd, &s);
+	ahd_lock(ahd, &s);
 	found = ahd_reset_channel(ahd, cmd->device->channel + 'A',
 				  /*initiate reset*/TRUE);
 	ahd_linux_run_complete_queue(ahd);
-	ahd_midlayer_entrypoint_unlock(ahd, &s);
+	ahd_unlock(ahd, &s);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -112,23 +112,6 @@ typedef Scsi_Cmnd      *ahd_io_ctx_t;
 #define ahd_le32toh(x)	le32_to_cpu(x)
 #define ahd_le64toh(x)	le64_to_cpu(x)
 
-#ifndef LITTLE_ENDIAN
-#define LITTLE_ENDIAN 1234
-#endif
-
-#ifndef BIG_ENDIAN
-#define BIG_ENDIAN 4321
-#endif
-
-#ifndef BYTE_ORDER
-#if defined(__BIG_ENDIAN)
-#define BYTE_ORDER BIG_ENDIAN
-#endif
-#if defined(__LITTLE_ENDIAN)
-#define BYTE_ORDER LITTLE_ENDIAN
-#endif
-#endif /* BYTE_ORDER */
-
 /************************* Configuration Data *********************************/
 extern uint32_t aic79xx_allow_memio;
 extern int aic79xx_detect_complete;
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -582,7 +582,7 @@ ahd_check_extport(struct ahd_softc *ahd)
 		}
 	}
 
-#if AHD_DEBUG
+#ifdef AHD_DEBUG
 	if (have_seeprom != 0
 	 && (ahd_debug & AHD_DUMP_SEEPROM) != 0) {
 		uint16_t *sc_data;


