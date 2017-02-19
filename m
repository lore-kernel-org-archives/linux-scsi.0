From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: g_NCR5380 PDMA, was Re: [PATCH 0/6] ncr5380: Miscellaneous minor patches
Date: Sun, 19 Feb 2017 12:19:47 +0100
Message-ID: <201702191219.48554.linux@rainbow-software.org>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <201702181210.08593.linux@rainbow-software.org> <alpine.LNX.2.00.1702191026310.7094@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1702191026310.7094@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday 19 February 2017 00:27:55 Finn Thain wrote:
> On Sat, 18 Feb 2017, Ondrej Zary wrote:
> > On Friday 17 February 2017 23:38:12 Finn Thain wrote:
> > > On Thu, 16 Feb 2017, Ondrej Zary wrote:
> > > > On Tuesday 31 January 2017 02:31:45 Finn Thain wrote:
> > > > [...]
> > > >
> > > > > Are you trying to figure out which commands are going to
> > > > > disconnect during a transfer? This is really a function of the
> > > > > firmware in the target; there are no good heuristics AFAICT, so
> > > > > the PDMA algorithm has to be robust. mac_scsi has to cope with
> > > > > this too.
> > > > >
> > > > > Does the problem go away when you assign no IRQ? When
> > > > > instance->irq == NO_IRQ, the core driver will inhibit disconnect
> > > > > privileges.
> > > >
> > > > Yes, it seems to run fine with IRQ/disconnect disabled. With IRQ
> > > > enabled, "dd if=/dev/sr0 of=anything" stops after a while.
> > >
> > > When you say "stops", do you mean an infinite loop in
> > > generic_NCR5380_pread or does the loop complete (which would
> > > presumably leave the target stuck in DATA IN phase, and a scsi command
> > > timeout would probably follow after 30 seconds...)
> >
> > I've added timeouts to the possibly-infinite loops. It times out waiting
> > for the host buffer to become ready.
>
> In mac_scsi you'll find that the PDMA loop exploits the 15ms poll_politely
> time limit to give the target device time to catch up. You might want to
> do something similar.
>
> > Then everything breaks. Now I found why: pread() returns without waiting
> > for the 53C80 registers to be ready.
>
> Ouch! You can't return control to the core driver when the 53C80 core is
> unavailable. That would need special handling: the core driver would have
> to fail the scsi command and reset the device (and bus), based on the
> result you return from NCR5380_dma_recv_setup/NCR5380_dma_send_setup.
>
> > Adding the wait allows to continue in PIO mode with "tag#0 switching to
> > slow handshake".
>
> I don't think this is the code path you want. The target isn't really
> broken. But yes, we could use PIO as a slow workaround for fragile PDMA
> logic.

Yes, we don't want that.

> > > > I get gated 53C80 IRQ, BASR=0x10, MODE=0x0e, STATUS=0x7c.
> > >
> > > You can use NCR5380_print() to get a decoded register dump.
> > >
> > > When I decode the above values I get,
> > >
> > > BASR   = 0x10 = BASR_IRQ
> > > MODE   = 0x0e = MR_ENABLE_EOP_INTR | MR_MONITOR_BSY | MR_DMA_MODE
> > > STATUS = 0x7c = SR_BSY | SR_REQ | SR_MSG | SR_CD | SR_IO
> > >
> > > Since BASR_PHASE_MATCH is not set, the interrupt is almost certainly a
> > > phase mismatch. The new phase is SR_MSG | SR_CD | SR_IO = PHASE_MSGIN,
> > > which shows that the target has given up on the DATA IN phase and is
> > > presumably trying to send a DISCONNECT message.
> >
> > Looks you're right. The transfersize is 4096, i.e. 2 CD-ROM sectors.
> > When the 2nd sector is not ready in the drive internal buffer, the drive
> > probably disconnects which breaks the fragile pdma transfer. When the
> > transfersize is limited to 2048 bytes, the problem goes away.
>
> OK.
>
> > The problem also went away with enabled interrupts because I had some
> > debug printks added which were slowing down the transfer enough for the
> > drive (SONY CDU-55S) to keep up and not disconnect. Got the same result
> > by inserting udelay(100) after each 128 byte block trasnferred in
> > pread().
>
> Well, yeah, if you change the timing and omit to mention that, as well as
> changing the spinlock_irq_save/restore pairs, then it's going to be
> difficult for me to make sense of your results. Anyway, I'm glad that you
> got to the bottom of this mystery.
>
> > > > When I enable interrupts during PDMA (like the removed UNSAFE macro
> > > > did), the problems go away. I see an IRQ after each pread call.

These two patches are enough to make PDMA work with CD-ROM drives on
53C400(A), with IRQ enabled or not. They even improve transfer rates with
HDDs because of bigger block size.

But DTC436 breaks with CDU-55S, immediately after modprobe.
1) Seems that IRQ timing is slightly different so I rewrote the wait for
the host buffer to include check for CSR_GATED_53C80_IRQ. This allows some
data to be transferred but
2) DTC436 likes to hang (return only 0xff from all registers - like it's
not even present on the bus) on repeating CSR register reads and maybe some
other actions too. This problem already appeared before in pwrite() where
I added the udelay(4) workaround. Now I added udelay(100) to the waits but
it still crashes sometimes (randomly after tenths or hundreds of MB).

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 6f9665d..9d0cfd4 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -585,26 +585,20 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 	return 0;
 }
 
+#define G_NCR5380_DMA_MAX_SIZE	32768
 static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                         struct scsi_cmnd *cmd)
 {
-	int transfersize = cmd->transfersize;
+	int transfersize = cmd->SCp.this_residual;
 
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
 		return 0;
 
-	/* Limit transfers to 32K, for xx400 & xx406
-	 * pseudoDMA that transfers in 128 bytes blocks.
-	 */
-	if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
-	    !(cmd->SCp.this_residual % transfersize))
-		transfersize = 32 * 1024;
-
 	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
 	if (transfersize % 128)
 		transfersize = 0;
 
-	return transfersize;
+	return min(transfersize, G_NCR5380_DMA_MAX_SIZE);
 }
 
 /*

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 9d0cfd4..797115e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -453,15 +453,15 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 	int blocks = len / 128;
 	int start = 0;
 
+	hostdata->pdma_residual = 0;
+
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
 	NCR5380_write(hostdata->c400_blk_cnt, blocks);
 	while (1) {
 		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
 			break;
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
-			printk(KERN_ERR "53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
-			return -1;
-		}
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
+			goto out_wait;
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; /* FIXME - no timeout */
 
@@ -499,13 +499,13 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 
 	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		printk("53C400r: no 53C80 gated irq after transfer");
-
+out_wait:
 	/* wait for 53C80 registers to be available */
 	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
 		;
 
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
-		printk(KERN_ERR "53C400r: no end dma signal\n");
+		hostdata->pdma_residual = blocks * 128;
 		
 	return 0;
 }
@@ -526,13 +526,13 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 	int blocks = len / 128;
 	int start = 0;
 
+	hostdata->pdma_residual = 0;
+
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 	NCR5380_write(hostdata->c400_blk_cnt, blocks);
 	while (1) {
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
-			printk(KERN_ERR "53C400w: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
-			return -1;
-		}
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
+			goto out_wait;
 
 		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
 			break;
@@ -569,16 +569,15 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 		start += 128;
 		blocks--;
 	}
-
+out_wait:
 	/* wait for 53C80 registers to be available */
 	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
 		udelay(4); /* DTC436 chip hangs without this */
 		/* FIXME - no timeout */
 	}
 
-	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
-		printk(KERN_ERR "53C400w: no end dma signal\n");
-	}
+	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
+		hostdata->pdma_residual = blocks * 128;
 
 	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
 		; 	// TIMEOUT
@@ -601,6 +600,11 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 	return min(transfersize, G_NCR5380_DMA_MAX_SIZE);
 }
 
+static int generic_NCR5380_dma_residual(struct NCR5380_hostdata *hostdata)
+{
+	return hostdata->pdma_residual;
+}
+
 /*
  *	Include the NCR5380 core code that we build our driver around	
  */
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index 81b22d9..08c91b7 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -26,7 +26,8 @@
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
 	int c400_host_buf; \
-	int io_width;
+	int io_width; \
+	int pdma_residual;
 
 #define NCR53C400_mem_base 0x3880
 #define NCR53C400_host_buffer 0x3900
@@ -35,7 +36,7 @@
 #define NCR5380_dma_xfer_len		generic_NCR5380_dma_xfer_len
 #define NCR5380_dma_recv_setup		generic_NCR5380_pread
 #define NCR5380_dma_send_setup		generic_NCR5380_pwrite
-#define NCR5380_dma_residual		NCR5380_dma_residual_none
+#define NCR5380_dma_residual		generic_NCR5380_dma_residual
 
 #define NCR5380_intr generic_NCR5380_intr
 #define NCR5380_queue_command generic_NCR5380_queue_command


-- 
Ondrej Zary
