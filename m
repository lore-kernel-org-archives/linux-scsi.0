From: Stephen Cameron <steve.cameron@hp.com>
Subject: [PATCH] 2.5.65, cciss_scsi, scsi error handling
Date: Tue, 18 Mar 2003 16:06:58 +0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030318100658.GA997@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hmmm, with 2.5.65, I get this:

>[root@zuul root]# echo engage scsi > /proc/driver/cciss/cciss1
>ERROR: SCSI host `cciss1' has no error handling
>ERROR: This is not a safe way to run your SCSI host
>ERROR: The error handling must be added to this driver
>Call Trace:
> [<c027984b>] scsi_register+0x2eb/0x2f0
> [<c0279872>] scsi_register_host+0x22/0xc0
> [<c024d583>] cciss_engage_scsi+0x93/0xa0
> [<c024d861>] cciss_proc_write+0x91/0x110
> [<c0118b00>] do_page_fault+0x90/0x4e4
> [<c01610a9>] locate_fd+0xa9/0x130
> [<c014f732>] dentry_open+0xe2/0x200
> [<c017ea30>] proc_file_write+0x40/0x50
> [<c01506c8>] vfs_write+0xb8/0x180
> [<c014fbd9>] filp_close+0x99/0xd0
> [<c015082c>] sys_write+0x3c/0x60
> [<c0109563>] syscall_call+0x7/0xb
>
>scsi0 : cciss1
>  Vendor: COMPAQ    Model: SDX-500C          Rev: 1.08
>  Type:   Sequential-Access                  ANSI SCSI revision: 02
>Attached scsi tape st0 at scsi0, channel 0, id 0, lun 0
>st0: try direct i/o: yes, max page reachable by HBA 65532

At least the tape drive still works.  The only scsi devices the
cciss driver will present to linux are tape drives and medium changers.
(especially not disks.)

Is it really accurate in this case to say

  "ERROR: This is not a safe way to run your SCSI host
   ERROR: The error handling must be added to this driver"

when the only things the error handlers can do 
is try to abort commands or try to reset devices or buses...

Well, feel free to educate my brains out if I'm being an idiot.

So anyway, I'm thinking about shooshing it this way....

-- steve

--- lx2565/drivers/block/cciss_scsi.c~cciss_scsi_error	2003-03-18 15:47:17.000000000 +0600
+++ lx2565-root/drivers/block/cciss_scsi.c	2003-03-18 15:47:17.000000000 +0600
@@ -64,14 +64,8 @@ int cciss_scsi_proc_info(
 		int func);	   /* 0 == read, 1 == write */
 
 int cciss_scsi_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *));
-#if 0
-int cciss_scsi_abort(Scsi_Cmnd *cmd);
-#if defined SCSI_RESET_SYNCHRONOUS && defined SCSI_RESET_ASYNCHRONOUS
-int cciss_scsi_reset(Scsi_Cmnd *cmd, unsigned int reset_flags);
-#else
-int cciss_scsi_reset(Scsi_Cmnd *cmd);
-#endif
-#endif
+static int cciss_eh_bus_reset_handler(Scsi_Cmnd *);
+static int cciss_eh_host_reset_handler(Scsi_Cmnd *);
 
 static struct cciss_scsi_hba_t ccissscsi[MAX_CTLR] = {
 	{ .name = "cciss0", .ndevices = 0 },
@@ -1393,6 +1387,8 @@ init_driver_template(int ctlr)
 	driver_template[ctlr].queuecommand = cciss_scsi_queue_command;
 	driver_template[ctlr].eh_abort_handler = NULL;
 	driver_template[ctlr].eh_device_reset_handler = NULL;
+	driver_template[ctlr].eh_bus_reset_handler = cciss_eh_bus_reset_handler;
+	driver_template[ctlr].eh_host_reset_handler = cciss_eh_host_reset_handler;
 	driver_template[ctlr].can_queue = SCSI_CCISS_CAN_QUEUE;
 	driver_template[ctlr].this_id = 7;
 	driver_template[ctlr].sg_tablesize = MAXSGENTRIES;
@@ -1502,6 +1498,24 @@ cciss_proc_tape_report(int ctlr, unsigne
 	*pos += size; *len += size;
 }
 
+/* Need at least one of these 2 to keep ../scsi/hosts.c from complaining.
+ * It might be possible to implement the device reset and command aborting
+ * ones in a real way, but host/bus reset can't do anything meaningful. */
+static int cciss_eh_bus_reset_handler(Scsi_Cmnd *notused)
+{
+	/* The bus in question is fabricated by this driver.
+	 * The real busses are behind the array controller, and the
+	 * firmware is taking care of it, be it SCSI, or something else.  
+	 * Resetting THAT from here is DEFINITELY not desirable. */
+	return FAILED;
+}
+static int cciss_eh_host_reset_handler(Scsi_Cmnd *notused)
+{
+	/* This is an array controller, not just a dumb scsi controller,
+	 * resetting the HBA would be extremely bad. */
+	return FAILED;
+}
+
 #else /* no CONFIG_CISS_SCSI_TAPE */
 
 /* If no tape support, then these become defined out of existence */
--- lx2565/drivers/block/cciss_scsi.h~cciss_scsi_error	2003-03-18 15:47:17.000000000 +0600
+++ lx2565-root/drivers/block/cciss_scsi.h	2003-03-18 15:47:17.000000000 +0600
@@ -48,6 +48,8 @@
 	release:        	cciss_scsi_release,		\
 	proc_info:           	cciss_scsi_proc_info,		\
 	queuecommand:   	cciss_scsi_queue_command,	\
+	eh_bus_reset_handler:	cciss_eh_bus_reset_handler,	\
+	eh_host_reset_handler:	cciss_eh_host_reset_handler,	\
 	can_queue:      	SCSI_CCISS_CAN_QUEUE,		\
 	this_id:        	7,				\
 	sg_tablesize:   	MAXSGENTRIES, 			\

_
