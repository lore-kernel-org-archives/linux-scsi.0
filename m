From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Tue, 9 Mar 2004 08:40:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309164033.GA21648@praka.local.home>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org>
Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:16592 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261959AbUCIRCA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 12:02:00 -0500
Content-Disposition: inline
In-Reply-To: <20040305172147.GB17305@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, 05 Mar 2004, Grant Grundler wrote:
> On Thu, Mar 04, 2004 at 11:17:21PM -0800, Andrew Vasquez wrote:
> ...
> > In the interim, could you just enable a couple of
> > debug settings in the driver and rerun against the volitile fabric
> > (just a short period, say 30 seconds), then send the /var/log/messages
> > file.
> ...
> 
> Mar  5 08:03:21 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
> Mar  5 08:03:21 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
> Mar  5 08:03:22 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
> Mar  5 08:03:22 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
> Mar  5 08:03:24 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
> Mar  5 08:03:24 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
> Mar  5 08:03:25 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
> Mar  5 08:03:25 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.

Ok, the driver is being flodded with RSCNs from the switch due to the
JBOD hanging off of 0b10xx.  

There are three places where the driver could fall into stuck case of
handling RSCNs.  The attached patch introduces behaviour consistent
with what we have for several of our other platform drivers.  The end
result is the will be 1) The driver will not hang during
init/post-init due to the stream of RSCNs.  2) The driver after init,
will *not* present any devices to the mid-layer due to the volatility
within the fabric.

This flodding behaviour also opens-up different handling qualities of
the Asynchronous RSCN handling (performed by the driver post-init).
I need to set up something locally which simulates this behaviour to
test out that logic, but, in the interim, this patch should be
sufficient.

Thanks for you patience.

Andrew Vasquez

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rscn_handling-v8.00.00b10_2.diff"

===== drivers/scsi/qla2xxx/qla_init.c 1.6 vs edited =====
--- 1.6/drivers/scsi/qla2xxx/qla_init.c	Sun Feb  8 07:15:50 2004
+++ edited/drivers/scsi/qla2xxx/qla_init.c	Tue Mar  9 08:19:11 2004
@@ -105,6 +105,7 @@
 	uint8_t	isp_init = 0;
 	uint8_t	restart_risc = 0;
 	uint8_t	retry;
+	uint32_t wait_time;
 
 	/* Clear adapter flags. */
 	ha->flags.online = FALSE;
@@ -184,9 +185,10 @@
 				clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 
 				/*
-				 * Go setup flash database devices with proper
-				 * Loop ID's.
+				 * Wait at most MAX_TARGET RSCNs for a stable
+				 * link.
 				 */
+				wait_time = 256;
 				do {
 					clear_bit(LOOP_RESYNC_NEEDED,
 					    &ha->dpc_flags);
@@ -209,8 +211,10 @@
 					    LOOP_DOWN && retry--) {
 						goto check_fw_ready_again;
 					}
+					wait_time--;
 				} while (!atomic_read(&ha->loop_down_timer) &&
 				    retry &&
+				    wait_time &&
 				    (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 			}
 
@@ -3054,6 +3058,7 @@
 qla2x00_loop_resync(scsi_qla_host_t *ha) 
 {
 	int   rval;
+	uint32_t wait_time;
 
 	rval = QLA_SUCCESS;
 
@@ -3062,6 +3067,8 @@
 	clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 	if (ha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(ha))) {
+			/* Wait at most MAX_TARGET RSCNs for a stable link. */
+			wait_time = 256;
 			do {
 				/* v2.19.05b6 */
 				atomic_set(&ha->loop_state, LOOP_UPDATE);
@@ -3076,9 +3083,10 @@
 				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 
 				qla2x00_configure_loop(ha);
-
+				wait_time--;
 			} while (!atomic_read(&ha->loop_down_timer) &&
 				!(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) &&
+				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
 		qla2x00_restart_queues(ha,TRUE);
@@ -4197,6 +4205,7 @@
 	uint8_t		status = 0;
 	device_reg_t	*reg;
 	unsigned long	flags = 0;
+	uint32_t wait_time;
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
@@ -4240,11 +4249,15 @@
 					__func__,
 					status);)
 			ha->flags.online = TRUE;
+			/* Wait at most MAX_TARGET RSCNs for a stable link. */
+			wait_time = 256;
 			do {
 				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 				qla2x00_configure_loop(ha);
+				wait_time--;
 			} while (!atomic_read(&ha->loop_down_timer) &&
 				!(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) &&
+				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
 

--Dxnq1zWXvFF0Q93v--
