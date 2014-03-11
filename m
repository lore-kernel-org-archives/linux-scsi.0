From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 2/3] m68k/atari - atari_scsi: change abort/reset return
 codes
Date: Tue, 11 Mar 2014 19:21:38 +1100 (EST)
Message-ID: <alpine.LNX.2.00.1403111852390.15749@nippy.intranet>
References: <1393660265-19384-1-git-send-email-schmitz@debian.org> <1393660265-19384-3-git-send-email-schmitz@debian.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1393660265-19384-3-git-send-email-schmitz@debian.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-m68k@vger.kernel.org, geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de, Michael Schmitz <schmitz@debian.org>
List-Id: linux-scsi@vger.kernel.org


This is a larger version of Michael's patch. It takes care of the header 
files and comments and it addresses sun3_NCR5380 as well as atari_NCR5380. 
This means that the initio.h include (!) can be dropped from sun3_scsi.h.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

--- 

Michael, I'm assuming that your patch hasn't been merged already (I didn't 
find it in any of the likely repos). Please go ahead and add your sign-off 
on this version if it is satisfactory. I didn't test this patch: I presume 
that sun3_NCR5380 would need the same abort/reset fixes that atari_NCR5380 
needed...


diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 0f3cdbc..e4aaf9a 100644
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
 
 
@@ -2825,7 +2825,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
  *
  * Purpose : reset the SCSI bus.
  *
- * Returns : SCSI_RESET_WAKEUP
+ * Returns : SUCCESS or FAILURE
  *
  */
 
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
index a3e6c8a..3ed39e5 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -821,7 +821,7 @@ static int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
 	} else {
 		atari_turnon_irq(IRQ_MFP_FSCSI);
 	}
-	if ((rv & SCSI_RESET_ACTION) == SCSI_RESET_SUCCESS)
+	if (rv == SUCCESS)
 		falcon_release_lock_if_possible(hostdata);
 
 	return rv;
diff --git a/drivers/scsi/atari_scsi.h b/drivers/scsi/atari_scsi.h
index 11c624b..ae559f4 100644
--- a/drivers/scsi/atari_scsi.h
+++ b/drivers/scsi/atari_scsi.h
@@ -54,32 +54,6 @@
 #define	NCR5380_dma_xfer_len(i,cmd,phase) \
 	atari_dma_xfer_len(cmd->SCp.this_residual,cmd,((phase) & SR_IO) ? 0 : 1)
 
-/* former generic SCSI error handling stuff */
-
-#define SCSI_ABORT_SNOOZE 0
-#define SCSI_ABORT_SUCCESS 1
-#define SCSI_ABORT_PENDING 2
-#define SCSI_ABORT_BUSY 3
-#define SCSI_ABORT_NOT_RUNNING 4
-#define SCSI_ABORT_ERROR 5
-
-#define SCSI_RESET_SNOOZE 0
-#define SCSI_RESET_PUNT 1
-#define SCSI_RESET_SUCCESS 2
-#define SCSI_RESET_PENDING 3
-#define SCSI_RESET_WAKEUP 4
-#define SCSI_RESET_NOT_RUNNING 5
-#define SCSI_RESET_ERROR 6
-
-#define SCSI_RESET_SYNCHRONOUS		0x01
-#define SCSI_RESET_ASYNCHRONOUS		0x02
-#define SCSI_RESET_SUGGEST_BUS_RESET	0x04
-#define SCSI_RESET_SUGGEST_HOST_RESET	0x08
-
-#define SCSI_RESET_BUS_RESET 0x100
-#define SCSI_RESET_HOST_RESET 0x200
-#define SCSI_RESET_ACTION   0xff
-
 /* Debugging printk definitions:
  *
  *  ARB  -> arbitration
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 636bbe0..455b1f0 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2664,11 +2664,11 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 #endif
 	  local_irq_restore(flags);
 	  cmd->scsi_done(cmd);
-	  return SCSI_ABORT_SUCCESS;
+	  return SUCCESS;
 	} else {
 /*	  local_irq_restore(flags); */
 	  printk("scsi%d: abort of connected command failed!\n", HOSTNO);
-	  return SCSI_ABORT_ERROR;
+	  return FAILED;
 	} 
    }
 #endif
@@ -2691,7 +2691,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	    /* Tagged queuing note: no tag to free here, hasn't been assigned
 	     * yet... */
 	    tmp->scsi_done(tmp);
-	    return SCSI_ABORT_SUCCESS;
+	    return SUCCESS;
 	}
 
 /* 
@@ -2708,7 +2708,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
     if (hostdata->connected) {
 	local_irq_restore(flags);
 	ABRT_PRINTK("scsi%d: abort failed, command connected.\n", HOSTNO);
-        return SCSI_ABORT_SNOOZE;
+        return FAILED;
     }
 
 /*
@@ -2743,7 +2743,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	    ABRT_PRINTK("scsi%d: aborting disconnected command.\n", HOSTNO);
   
             if (NCR5380_select (instance, cmd, (int) cmd->tag)) 
-		return SCSI_ABORT_BUSY;
+		return FAILED;
 
 	    ABRT_PRINTK("scsi%d: nexus reestablished.\n", HOSTNO);
 
@@ -2769,7 +2769,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 #endif
 		    local_irq_restore(flags);
 		    tmp->scsi_done(tmp);
-		    return SCSI_ABORT_SUCCESS;
+		    return SUCCESS;
 		}
 	}
 
@@ -2786,7 +2786,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
     local_irq_restore(flags);
     printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully before abortion\n", HOSTNO); 
 
-    return SCSI_ABORT_NOT_RUNNING;
+    return FAILED;
 }
 
 
@@ -2795,7 +2795,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
  * 
  * Purpose : reset the SCSI bus.
  *
- * Returns : SCSI_RESET_WAKEUP
+ * Returns : SUCCESS or FAILURE
  *
  */ 
 
@@ -2804,7 +2804,7 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
     SETUP_HOSTDATA(cmd->device->host);
     int           i;
     unsigned long flags;
-#if 1
+#if defined(RESET_RUN_DONE)
     struct scsi_cmnd *connected, *disconnected_queue;
 #endif
 
@@ -2826,8 +2826,15 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
      * through anymore ... */
     (void)NCR5380_read( RESET_PARITY_INTERRUPT_REG );
 
-#if 1 /* XXX Should now be done by midlevel code, but it's broken XXX */
-      /* XXX see below                                            XXX */
+	/* MSch 20140115 - looking at the generic NCR5380 driver, all of this
+	 * should go.
+	 * Catch-22: if we don't clear all queues, the SCSI driver lock will
+	 * not be reset by atari_scsi_reset()!
+	 */
+
+#if defined(RESET_RUN_DONE)
+	/* XXX Should now be done by midlevel code, but it's broken XXX */
+	/* XXX see below                                            XXX */
 
     /* MSch: old-style reset: actually abort all command processing here */
 
@@ -2876,7 +2883,7 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
      * the midlevel code that the reset was SUCCESSFUL, and there is no 
      * need to 'wake up' the commands by a request_sense
      */
-    return SCSI_RESET_SUCCESS | SCSI_RESET_BUS_RESET;
+    return SUCCESS;
 #else /* 1 */
 
     /* MSch: new-style reset handling: let the mid-level do what it can */
@@ -2924,7 +2931,7 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
     local_irq_restore(flags);
 
     /* we did no complete reset of all commands, so a wakeup is required */
-    return SCSI_RESET_WAKEUP | SCSI_RESET_BUS_RESET;
+    return SUCCESS;
 #endif /* 1 */
 }
 
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index e2c009b..0cfa542 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -79,7 +79,6 @@
 #define REAL_DMA
 
 #include "scsi.h"
-#include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 
