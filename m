From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 2/3] m68k/atari - atari_scsi: change abort/reset return codes
Date: Sat,  1 Mar 2014 20:51:04 +1300
Message-ID: <1393660265-19384-3-git-send-email-schmitz@debian.org>
References: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1393660265-19384-1-git-send-email-schmitz@debian.org>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de, Michael Schmitz <schmitz@debian.org>
List-Id: linux-scsi@vger.kernel.org

The abort/reset lowlevel return codes had changed with the new
error SCSI handling - update Atari NCR5380 driver to reflect this.

Change reset handling to clear queues only, do not attempt to
call done() on each command aborted by the reset. The EH code
should do that for us.
Queues _must_ be cleared, otherwise atari_scsi_bus_reset will not
release the ST-DMA lock, deadlocking further error recovery.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_NCR5380.c |   29 ++++++++++++++++++-----------
 drivers/scsi/atari_scsi.c    |    2 +-
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 0f3cdbc..465e63d 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2683,11 +2683,11 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			local_irq_restore(flags);
 			cmd->scsi_done(cmd);
 			falcon_release_lock_if_possible(hostdata);
-			return SCSI_ABORT_SUCCESS;
+			return SUCCESS;
 		} else {
 /*			local_irq_restore(flags); */
 			printk("scsi%d: abort of connected command failed!\n", HOSTNO);
-			return SCSI_ABORT_ERROR;
+			return FAILED;
 		}
 	}
 #endif
@@ -2711,7 +2711,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			 * yet... */
 			tmp->scsi_done(tmp);
 			falcon_release_lock_if_possible(hostdata);
-			return SCSI_ABORT_SUCCESS;
+			return SUCCESS;
 		}
 	}
 
@@ -2729,7 +2729,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	if (hostdata->connected) {
 		local_irq_restore(flags);
 		ABRT_PRINTK("scsi%d: abort failed, command connected.\n", HOSTNO);
-		return SCSI_ABORT_SNOOZE;
+		return FAILED;
 	}
 
 	/*
@@ -2764,7 +2764,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			ABRT_PRINTK("scsi%d: aborting disconnected command.\n", HOSTNO);
 
 			if (NCR5380_select(instance, cmd, (int)cmd->tag))
-				return SCSI_ABORT_BUSY;
+				return FAILED;
 
 			ABRT_PRINTK("scsi%d: nexus reestablished.\n", HOSTNO);
 
@@ -2791,7 +2791,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 					local_irq_restore(flags);
 					tmp->scsi_done(tmp);
 					falcon_release_lock_if_possible(hostdata);
-					return SCSI_ABORT_SUCCESS;
+					return SUCCESS;
 				}
 			}
 		}
@@ -2816,7 +2816,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	 */
 	falcon_release_lock_if_possible(hostdata);
 
-	return SCSI_ABORT_NOT_RUNNING;
+	return FAILED;
 }
 
 
@@ -2834,7 +2834,7 @@ static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
 	SETUP_HOSTDATA(cmd->device->host);
 	int i;
 	unsigned long flags;
-#if 1
+#if defined(RESET_RUN_DONE)
 	Scsi_Cmnd *connected, *disconnected_queue;
 #endif
 
@@ -2859,7 +2859,14 @@ static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
 	 * through anymore ... */
 	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-#if 1	/* XXX Should now be done by midlevel code, but it's broken XXX */
+	/* MSch 20140115 - looking at the generic NCR5380 driver, all of this
+	 * should go.
+	 * Catch-22: if we don't clear all queues, the SCSI driver lock will
+	 * not be reset by atari_scsi_reset()!
+	 */
+
+#if defined(RESET_RUN_DONE)
+	/* XXX Should now be done by midlevel code, but it's broken XXX */
 	/* XXX see below                                            XXX */
 
 	/* MSch: old-style reset: actually abort all command processing here */
@@ -2915,7 +2922,7 @@ static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
 	 * the midlevel code that the reset was SUCCESSFUL, and there is no
 	 * need to 'wake up' the commands by a request_sense
 	 */
-	return SCSI_RESET_SUCCESS | SCSI_RESET_BUS_RESET;
+	return SUCCESS;
 #else /* 1 */
 
 	/* MSch: new-style reset handling: let the mid-level do what it can */
@@ -2963,6 +2970,6 @@ static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
 	local_irq_restore(flags);
 
 	/* we did no complete reset of all commands, so a wakeup is required */
-	return SCSI_RESET_WAKEUP | SCSI_RESET_BUS_RESET;
+	return SUCCESS;
 #endif /* 1 */
 }
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 296c936..4ae0c1a 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -827,7 +827,7 @@ static int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
 	} else {
 		atari_turnon_irq(IRQ_MFP_FSCSI);
 	}
-	if ((rv & SCSI_RESET_ACTION) == SCSI_RESET_SUCCESS)
+	if (rv == SUCCESS)
 		falcon_release_lock_if_possible(hostdata);
 
 	return rv;
-- 
1.7.0.4
