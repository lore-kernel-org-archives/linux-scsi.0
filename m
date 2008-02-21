From: Finn Thain <fthain@telegraphics.com.au>
Subject: mac_esp and PIO, was Re: [PATCH 1/1] Remove of old NCR53C9x/esp
 family of drivers
Date: Thu, 21 Feb 2008 18:59:00 +1100 (EST)
Message-ID: <Pine.LNX.4.64.0802211743280.26027@loopy.telegraphics.com.au>
References: <20080103.150204.101269827.davem@davemloft.net>
 <Pine.LNX.4.64.0801041054130.27528@anakin> <Pine.LNX.4.64.0801042143001.17406@loopy.telegraphics.com.au>
 <20080104.034958.179163488.davem@davemloft.net>
 <Pine.LNX.4.64.0801051327430.24730@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:47375 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYBUIVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2008 03:21:14 -0500
In-Reply-To: <Pine.LNX.4.64.0801051327430.24730@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org


Hi All,

At the end of this message is the replacement mac_esp driver I've been 
working on. It isn't finished but it works fine.

The only remaining concerns I have are some of the changes to esp_scsi: 
firstly I'm hoping that there's a better way to negotiate async transfers, 
and secondly I'm unsure about exporting esp_dma_length_limit (perhaps it 
would be better just to add an integer to struct esp for that value? The 
other front-ends could leave it zeroed for the original behaviour.)

David, some more discussion of the asynch problem follows...

On Sat, 5 Jan 2008, I wrote:
> 
> On Fri, 4 Jan 2008, David Miller wrote:
> 
> > From: Finn Thain <fthain@telegraphics.com.au>
> > Date: Fri, 4 Jan 2008 22:05:20 +1100 (EST)
> > 
> > > I have a partially written replacement for mac_esp. Unlike the other 
> > > NCR53C9x drivers it needs PIO or pseudo DMA depending on the machine 
> > > -- so it is not as straight-forward as jazz_esp. The new esp_scsi 
> > > core assumes DMA and doesn't support asynch transfers. But I'll try 
> > > to get it finished before 2.6.25 is released.
> > 
> > It does actually support such things.
> 
> Does it? When I looked at this around 2.6.22, I found that esp_scsi 
> would always negotiate sync transfers if the target supported that. PIO 
> cannot do sync transfers, so I had to modify esp_scsi in order that the 
> chip's Synchronous Offset register was set to zero (asynch).

I think it would be better to bypass Domain Validation for PIO. The hack I 
used (ESP_FLAG_DISABLE_SYNC) is a bit messy because it seems to confuse 
domain validation. For example, here's the log from probing the bus:

mac_esp: using PIO for controller 0
esp: esp0, regs[50f18000:0] irq[19]
esp: esp0 is a ESP236, 25 MHz (ccf=5), SCSI ID 7
scsi0 : esp
scsi 0:0:3:0: CD-ROM            MATSHITA CD-ROM CR-8004   1.0p PQ: 0
ANSI: 2
 target0:0:3: Beginning Domain Validation
 target0:0:3: asynchronous
mac_esp: FIFO is empty (sreg 81).
esp: esp0: DMA length is zero!
esp: esp0: cur adr[0050e048] len[00000000]
 target0:0:3: Domain Validation detected failure, dropping back
 target0:0:3: asynchronous
 target0:0:3: Domain Validation skipping write tests
 target0:0:3: Ending Domain Validation
scsi 0:0:6:0: Direct-Access     QUANTUM  LPS540S          590S PQ: 0
ANSI: 2 CCS
 target0:0:6: Beginning Domain Validation
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81).
esp: esp0: DMA length is zero!
esp: esp0: cur adr[0050e104] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81).
esp: esp0: DMA length is zero!
esp: esp0: cur adr[0050e104] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81).
esp: esp0: DMA length is zero!
esp: esp0: cur adr[0050e104] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81).
esp: esp0: DMA length is zero!
esp: esp0: cur adr[0050e104] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81).
esp: esp0: DMA length is zero!
esp: esp0: cur adr[0050e104] len[00000000]
 target0:0:6: Domain Validation Failure, dropping back to Asynchronous
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
sd 0:0:6:0: [sda] 1057616 512-byte hardware sectors (541 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: 93 00 00 08
sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:6:0: [sda] 1057616 512-byte hardware sectors (541 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: 93 00 00 08
sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6
 sda: p6 exceeds device capacity
sd 0:0:6:0: [sda] Attached SCSI disk


...which may be inefficient but it is a lot quicker than waiting for 
command timeouts, which is what happens without my hack:

[snipped first part of validation and half a dozen command timeouts]

 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: FAST-5 SCSI 1.5 MB/s ST (672 ns, offset 8)
mac_esp: IRQ timeout (sreg 01).
esp: esp0: Aborting command [0045ccb0:12]
esp: esp0: Current command [0045ccb0:12]
esp: esp0: Active command [0045ccb0:12]
esp: esp0: Dumping command log
esp: esp0: ent[3] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[4] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[5] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[6] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[7] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[8] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[9] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[10] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[11] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[12] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[13] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[14] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[15] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[16] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[17] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[18] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[19] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[20] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[21] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[22] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[23] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[24] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[25] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[26] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[27] EVENT val[01] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[28] CMD val[01] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[01]
esp: esp0: ent[29] CMD val[10] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[01]
esp: esp0: ent[30] EVENT val[02] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[01]
esp: esp0: ent[31] EVENT val[0d] sreg[81] seqreg[01] sreg2[00] ireg[10] ss[00] event[02]
esp: esp0: ent[0] EVENT val[03] sreg[81] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[1] CMD val[10] sreg[81] seqreg[01] sreg2[00] ireg[10] ss[00] event[03]
esp: esp0: ent[2] EVENT val[05] sreg[01] seqreg[01] sreg2[00] ireg[10] ss[00] event[03]
 target0:0:6: FAST-5 SCSI 1.5 MB/s ST (672 ns, offset 8)
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: FAST-5 SCSI 1.0 MB/s ST (1008 ns, offset 8)
mac_esp: IRQ timeout (sreg 01).
esp: esp0: Aborting command [0045ccb0:12]
esp: esp0: Current command [0045ccb0:12]
esp: esp0: Active command [0045ccb0:12]
esp: esp0: Dumping command log
esp: esp0: ent[1] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[2] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[3] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[4] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[5] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[6] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[7] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[8] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[9] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[10] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[11] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[12] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[13] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[14] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[15] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[16] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[17] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[18] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[19] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[20] EVENT val[06] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[21] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[22] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[23] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[24] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[25] EVENT val[01] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[26] CMD val[01] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[01]
esp: esp0: ent[27] CMD val[10] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[01]
esp: esp0: ent[28] EVENT val[02] sreg[82] seqreg[01] sreg2[00] ireg[10] ss[00] event[01]
esp: esp0: ent[29] EVENT val[0d] sreg[81] seqreg[01] sreg2[00] ireg[10] ss[00] event[02]
esp: esp0: ent[30] EVENT val[03] sreg[81] seqreg[01] sreg2[00] ireg[10] ss[00] event[0d]
esp: esp0: ent[31] CMD val[10] sreg[81] seqreg[01] sreg2[00] ireg[10] ss[00] event[03]
esp: esp0: ent[0] EVENT val[05] sreg[01] seqreg[01] sreg2[00] ireg[10] ss[00] event[03]
 target0:0:6: FAST-5 SCSI 1.0 MB/s ST (1008 ns, offset 8)
 target0:0:6: Domain Validation Failure, dropping back to Asynchronous
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
 target0:0:6: asynchronous

> 
> > You can hide it completely your ->irq_pending() handler.  Process any 
> > pending pseudo DMA and return 0 until there is a pseudo DMA error or 
> > the pseudo DMA is complete and the ESP is signalling an IRQ.
> 
> I didn't attempt any processing in irq_pending. I'll look into it.

Well, I've looked into it. It turns out that I can't report an error from 
irq_pending() because it is never called. What happens is that the domain 
validation algorithm will issue a synchronous command (like a 36 byte read 
from the CDROM drive) but, given only PIO, the chip raises no interrupt:

mac_esp: using PIO for controller 0
esp: esp0, regs[50f18000:0] irq[19]
esp: esp0 is a ESP236, 25 MHz (ccf=5), SCSI ID 7
scsi0 : esp
>write 0, cmd 0xC2, fifo 0, esp_count 7
>write 0, cmd 0xC2, fifo 7, esp_count 7
>write 0, cmd 0xC2, fifo 7, esp_count 7
>write 0, cmd 0xC2, fifo 7, esp_count 7
>write 1, cmd 0x90, fifo 0, esp_count 36
scsi 0:0:3:0: CD-ROM            MATSHITA CD-ROM CR-8004   1.0p PQ: 0 ANSI: 2
 target0:0:3: Beginning Domain Validation
>write 0, cmd 0xC2, fifo 0, esp_count 7
>write 1, cmd 0x90, fifo 0, esp_count 36
>write 0, cmd 0xC2, fifo 0, esp_count 7
>write 1, cmd 0x90, fifo 0, esp_count 36
>write 0, cmd 0xC2, fifo 0, esp_count 7
>write 1, cmd 0x90, fifo 0, esp_count 36
>write 0, cmd 0xC2, fifo 0, esp_count 7
>write 1, cmd 0x90, fifo 0, esp_count 36
>write 0, cmd 0xC3, fifo 0, esp_count 1
>write 0, cmd 0x90, fifo 0, esp_count 5
 target0:0:3: FAST-5 SCSI 2.1 MB/s ST (472 ns, offset 8)
>write 0, cmd 0x90, fifo 0, esp_count 6
>write 1, cmd 0x90, fifo 0, esp_count 36
mac_esp: IRQ timeout (sreg 01).
esp: esp0: Aborting command [004e0cb0:12]
esp: esp0: Current command [004e0cb0:12]
esp: esp0: Active command [004e0cb0:12]
esp: esp0: Dumping command log
...

Hence the ESP_FLAG_DISABLE_SYNC hack... but I have to wonder, is there no 
better way to short circuit domain validation?

Cheers,
Finn



---
 drivers/scsi/Makefile    |    1 
 drivers/scsi/esp_scsi.c  |   27 +
 drivers/scsi/esp_scsi.h  |    9 
 drivers/scsi/jazz_esp.c  |   25 -
 drivers/scsi/mac_esp.c   |  650 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sun_esp.c   |   25 -
 drivers/scsi/sun3x_esp.c |   25 -
 6 files changed, 700 insertions(+), 37 deletions(-)

Index: linux-2.6.22/drivers/scsi/esp_scsi.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/esp_scsi.c	2008-02-21 14:49:48.000000000 +1100
+++ linux-2.6.22/drivers/scsi/esp_scsi.c	2008-02-21 14:49:48.000000000 +1100
@@ -477,7 +477,7 @@ static void esp_write_tgt_sync(struct es
 	}
 }
 
-static u32 esp_dma_length_limit(struct esp *esp, u32 dma_addr, u32 dma_len)
+u32 esp_dma_length_limit(struct esp *esp, u32 dma_addr, u32 dma_len)
 {
 	if (esp->rev == FASHME) {
 		/* Arbitrary segment boundaries, 24-bit counts.  */
@@ -506,6 +506,7 @@ static u32 esp_dma_length_limit(struct e
 	}
 	return dma_len;
 }
+EXPORT_SYMBOL(esp_dma_length_limit);
 
 static int esp_need_to_nego_wide(struct esp_target_data *tp)
 {
@@ -982,7 +983,7 @@ static int esp_check_spur_intr(struct es
 			 */
 			if (!esp->ops->dma_error(esp)) {
 				printk(KERN_ERR PFX "esp%d: Spurious irq, "
-				       "sreg=%x.\n",
+				       "sreg=%02x.\n",
 				       esp->host->unique_id, esp->sreg);
 				return -1;
 			}
@@ -1451,6 +1452,9 @@ static void esp_msgin_sdtr(struct esp *e
 	if (offset > 15)
 		goto do_reject;
 
+	if (esp->flags & ESP_FLAG_DISABLE_SYNC)
+		offset = 0;
+
 	if (offset) {
 		int rounded_up, one_clock;
 
@@ -1701,7 +1705,7 @@ again:
 		else
 			ent->flags &= ~ESP_CMD_FLAG_WRITE;
 
-		dma_len = esp_dma_length_limit(esp, dma_addr, dma_len);
+		dma_len = esp->ops->dma_length_limit(esp, dma_addr, dma_len);
 		esp->data_dma_len = dma_len;
 
 		if (!dma_len) {
@@ -1765,7 +1769,6 @@ again:
 		esp_advance_dma(esp, ent, cmd, bytes_sent);
 		esp_event(esp, ESP_EVENT_CHECK_PHASE);
 		goto again;
-		break;
 	}
 
 	case ESP_EVENT_STATUS: {
@@ -2239,7 +2242,7 @@ static void esp_bootup_reset(struct esp 
 
 static void __devinit esp_set_clock_params(struct esp *esp)
 {
-	int fmhz;
+	int fhz;
 	u8 ccf;
 
 	/* This is getting messy but it has to be done correctly or else
@@ -2274,9 +2277,9 @@ static void __devinit esp_set_clock_para
 	 *    This entails the smallest and largest sync period we could ever
 	 *    handle on this ESP.
 	 */
-	fmhz = esp->cfreq;
+	fhz = esp->cfreq;
 
-	ccf = ((fmhz / 1000000) + 4) / 5;
+	ccf = ((fhz / 1000000) + 4) / 5;
 	if (ccf == 1)
 		ccf = 2;
 
@@ -2285,16 +2288,16 @@ static void __devinit esp_set_clock_para
 	 * been unable to find the clock-frequency PROM property.  All
 	 * other machines provide useful values it seems.
 	 */
-	if (fmhz <= 5000000 || ccf < 1 || ccf > 8) {
-		fmhz = 20000000;
+	if (fhz <= 5000000 || ccf < 1 || ccf > 8) {
+		fhz = 20000000;
 		ccf = 4;
 	}
 
 	esp->cfact = (ccf == 8 ? 0 : ccf);
-	esp->cfreq = fmhz;
-	esp->ccycle = ESP_MHZ_TO_CYCLE(fmhz);
+	esp->cfreq = fhz;
+	esp->ccycle = ESP_HZ_TO_CYCLE(fhz);
 	esp->ctick = ESP_TICK(ccf, esp->ccycle);
-	esp->neg_defp = ESP_NEG_DEFP(fmhz, ccf);
+	esp->neg_defp = ESP_NEG_DEFP(fhz, ccf);
 	esp->sync_defp = SYNC_DEFP_SLOW;
 }
 
Index: linux-2.6.22/drivers/scsi/esp_scsi.h
===================================================================
--- linux-2.6.22.orig/drivers/scsi/esp_scsi.h	2008-02-21 14:49:27.000000000 +1100
+++ linux-2.6.22/drivers/scsi/esp_scsi.h	2008-02-21 14:49:48.000000000 +1100
@@ -224,7 +224,7 @@
 #define ESP_TIMEO_CONST       8192
 #define ESP_NEG_DEFP(mhz, cfact) \
         ((ESP_BUS_TIMEOUT * ((mhz) / 1000)) / (8192 * (cfact)))
-#define ESP_MHZ_TO_CYCLE(mhertz)  ((1000000000) / ((mhertz) / 1000))
+#define ESP_HZ_TO_CYCLE(hertz)  ((1000000000) / ((hertz) / 1000))
 #define ESP_TICK(ccf, cycle)  ((7682 * (ccf) * (cycle) / 1000))
 
 /* For slow to medium speed input clock rates we shoot for 5mb/s, but for high
@@ -368,6 +368,12 @@ struct esp_driver_ops {
 	 */
 	int (*irq_pending)(struct esp *esp);
 
+	/* Return the maximum allowable size of a DMA transfer for a
+	 * given buffer.
+	 */
+	u32 (*dma_length_limit)(struct esp *esp, u32 dma_addr,
+	                        u32 dma_len);
+
 	/* Reset the DMA engine entirely.  On return, ESP interrupts
 	 * should be enabled.  Often the interrupt enabling is
 	 * controlled in the DMA engine.
@@ -471,6 +477,7 @@ struct esp {
 #define ESP_FLAG_DOING_SLOWCMD	0x00000004
 #define ESP_FLAG_WIDE_CAPABLE	0x00000008
 #define ESP_FLAG_QUICKIRQ_CHECK	0x00000010
+#define ESP_FLAG_DISABLE_SYNC	0x00000020
 
 	u8			select_state;
 #define ESP_SELECT_NONE		0x00 /* Not selecting */
Index: linux-2.6.22/drivers/scsi/Makefile
===================================================================
--- linux-2.6.22.orig/drivers/scsi/Makefile	2008-02-21 14:49:48.000000000 +1100
+++ linux-2.6.22/drivers/scsi/Makefile	2008-02-21 14:49:48.000000000 +1100
@@ -52,6 +52,7 @@ obj-$(CONFIG_FASTLANE_SCSI)	+= NCR53C9x.
 obj-$(CONFIG_OKTAGON_SCSI)	+= NCR53C9x.o	oktagon_esp_mod.o
 obj-$(CONFIG_ATARI_SCSI)	+= atari_scsi.o
 obj-$(CONFIG_MAC_SCSI)		+= mac_scsi.o
+obj-$(CONFIG_SCSI_MAC_ESP)	+= esp_scsi.o	mac_esp.o
 obj-$(CONFIG_SUN3_SCSI)		+= sun3_scsi.o  sun3_scsi_vme.o
 obj-$(CONFIG_MVME16x_SCSI)	+= 53c700.o	mvme16x_scsi.o
 obj-$(CONFIG_BVME6000_SCSI)	+= 53c700.o	bvme6000_scsi.o
Index: linux-2.6.22/drivers/scsi/mac_esp.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22/drivers/scsi/mac_esp.c	2008-02-21 17:08:13.000000000 +1100
@@ -0,0 +1,653 @@
+/* mac_esp.c: ESP front-end for Macintosh Quadra systems.
+ *
+ * Adapted from jazz_esp.c and the old mac_esp.c.
+ *
+ * The pseudo DMA algorithm is based on the one used in NetBSD.
+ * See sys/arch/mac68k/obio/esp.c for some background information.
+ *
+ * Copyright (C) 2007-2008 Finn Thain
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/delay.h>
+
+#include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/dma.h>
+
+#include <asm/nubus.h>
+#include <asm/macints.h>
+#include <asm/macintosh.h>
+
+#include <scsi/scsi_host.h>
+
+#include "esp_scsi.h"
+
+#define DRV_MODULE_NAME     "mac_esp"
+#define PFX                 DRV_MODULE_NAME ": "
+#define DRV_VERSION         "1.000"
+#define DRV_MODULE_RELDATE  "Sept 15, 2007"
+
+#define MAC_ESP_IO_BASE          0x50F00000
+#define MAC_ESP_REGS_QUADRA      (MAC_ESP_IO_BASE + 0x10000)
+#define MAC_ESP_REGS_QUADRA2     (MAC_ESP_IO_BASE + 0xF000)
+#define MAC_ESP_REGS_QUADRA3     (MAC_ESP_IO_BASE + 0x18000)
+#define MAC_ESP_REGS_SPACING     0x402
+#define MAC_ESP_PDMA_REG         0xF9800024
+#define MAC_ESP_PDMA_REG_SPACING 0x4
+#define MAC_ESP_PDMA_IO_OFFSET   0x100
+
+#define esp_read8(REG)      mac_esp_read8(esp, REG)
+#define esp_write8(VAL,REG) mac_esp_write8(esp, VAL, REG)
+
+struct mac_esp_priv {
+	struct esp *esp;
+	void __iomem *pdma_regs;
+	void __iomem *pdma_io;
+	int error;
+};
+static struct platform_device *internal_esp, *external_esp;
+
+#define MAC_ESP_GET_PRIV(esp) ((struct mac_esp_priv *) \
+                               platform_get_drvdata((struct platform_device *) \
+			                            (esp->dev)))
+
+static inline void mac_esp_write8(struct esp *esp, u8 val, unsigned long reg)
+{
+	nubus_writeb(val, esp->regs + reg * 16);
+}
+
+static inline u8 mac_esp_read8(struct esp *esp, unsigned long reg)
+{
+	return nubus_readb(esp->regs + reg * 16);
+}
+
+/* For pseudo DMA and PIO we need the virtual address
+ * so this address mapping is the identity mapping.
+ */
+
+static dma_addr_t mac_esp_map_single(struct esp *esp, void *buf,
+                                     size_t sz, int dir)
+{
+	return (dma_addr_t)buf;
+}
+
+static int mac_esp_map_sg(struct esp *esp, struct scatterlist *sg,
+                          int num_sg, int dir)
+{
+	int i;
+
+	for (i = 0; i < num_sg; i++)
+		sg[i].dma_address = (u32)page_address(sg[i].page) + sg[i].offset;
+	return num_sg;
+}
+
+static void mac_esp_unmap_single(struct esp *esp, dma_addr_t addr,
+                                 size_t sz, int dir)
+{
+	/* Nothing to do. */
+}
+
+static void mac_esp_unmap_sg(struct esp *esp, struct scatterlist *sg,
+                             int num_sg, int dir)
+{
+	/* Nothing to do. */
+}
+
+static void mac_esp_reset_dma(struct esp *esp)
+{
+	/* Nothing to do. */
+}
+
+static void mac_esp_dma_drain(struct esp *esp)
+{
+	/* Nothing to do. */
+}
+
+static void mac_esp_dma_invalidate(struct esp *esp)
+{
+	/* Nothing to do. */
+}
+
+static int mac_esp_dma_error(struct esp *esp)
+{
+	return MAC_ESP_GET_PRIV(esp)->error;
+}
+
+static inline int mac_esp_wait_for_empty_fifo(struct esp *esp)
+{
+	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
+	int i = 500000;
+
+	do {
+		if (!(esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES))
+			return 0;
+
+		if (esp_read8(ESP_STATUS) & ESP_STAT_INTR)
+			return 1;
+
+		udelay(2);
+	} while (--i);
+
+	printk(KERN_ERR PFX "FIFO is not empty (sreg %02x).\n",
+	       esp_read8(ESP_STATUS));
+	mep->error = 1;
+	return 1;
+}
+
+static inline int mac_esp_wait_for_dreq(struct esp *esp)
+{
+	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
+	int i = 500000;
+
+	do {
+		if (mep->pdma_regs == NULL) {
+			if (mac_irq_pending(IRQ_MAC_SCSIDRQ))
+				return 0;
+		} else {
+			if (nubus_readl(mep->pdma_regs) & 0x200)
+				return 0;
+		}
+
+		if (esp_read8(ESP_STATUS) & ESP_STAT_INTR)
+			return 1;
+
+		udelay(2);
+	} while (--i);
+
+	printk(KERN_ERR PFX "PDMA timeout (sreg %02x).\n",
+	       esp_read8(ESP_STATUS));
+	mep->error = 1;
+	return 1;
+}
+
+#define MAC_ESP_PDMA_LOOP(operands) \
+	asm volatile ( \
+	     "       tstw %2                   \n" \
+	     "       jbeq 20f                  \n" \
+	     "1:     movew " operands "        \n" \
+	     "2:     movew " operands "        \n" \
+	     "3:     movew " operands "        \n" \
+	     "4:     movew " operands "        \n" \
+	     "5:     movew " operands "        \n" \
+	     "6:     movew " operands "        \n" \
+	     "7:     movew " operands "        \n" \
+	     "8:     movew " operands "        \n" \
+	     "9:     movew " operands "        \n" \
+	     "10:    movew " operands "        \n" \
+	     "11:    movew " operands "        \n" \
+	     "12:    movew " operands "        \n" \
+	     "13:    movew " operands "        \n" \
+	     "14:    movew " operands "        \n" \
+	     "15:    movew " operands "        \n" \
+	     "16:    movew " operands "        \n" \
+	     "       subqw #1,%2               \n" \
+	     "       jbne 1b                   \n" \
+	     "20:    tstw %3                   \n" \
+	     "       jbeq 30f                  \n" \
+	     "21:    movew " operands "        \n" \
+	     "       subqw #1,%3               \n" \
+	     "       jbne 21b                  \n" \
+	     "30:    tstw %4                   \n" \
+	     "       jbeq 40f                  \n" \
+	     "31:    moveb " operands "        \n" \
+	     "32:    nop                       \n" \
+	     "40:                              \n" \
+	     "                                 \n" \
+	     "       .section __ex_table,\"a\" \n" \
+	     "       .align  4                 \n" \
+	     "       .long   1b,40b            \n" \
+	     "       .long   2b,40b            \n" \
+	     "       .long   3b,40b            \n" \
+	     "       .long   4b,40b            \n" \
+	     "       .long   5b,40b            \n" \
+	     "       .long   6b,40b            \n" \
+	     "       .long   7b,40b            \n" \
+	     "       .long   8b,40b            \n" \
+	     "       .long   9b,40b            \n" \
+	     "       .long  10b,40b            \n" \
+	     "       .long  11b,40b            \n" \
+	     "       .long  12b,40b            \n" \
+	     "       .long  13b,40b            \n" \
+	     "       .long  14b,40b            \n" \
+	     "       .long  15b,40b            \n" \
+	     "       .long  16b,40b            \n" \
+	     "       .long  21b,40b            \n" \
+	     "       .long  31b,40b            \n" \
+	     "       .long  32b,40b            \n" \
+	     "       .previous                 \n" \
+	     : "+a" (addr) \
+	     : "a" (mep->pdma_io), "r" (count32), "r" (count2), "g" (esp_count))
+
+static void mac_esp_send_pdma_cmd(struct esp *esp, u32 addr, u32 esp_count,
+                                  u32 dma_count, int write, u8 cmd)
+{
+	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	mep->error = 0;
+
+	if (!write)
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+
+	esp_write8((esp_count >> 0) & 0xFF, ESP_TCLOW);
+	esp_write8((esp_count >> 8) & 0xFF, ESP_TCMED);
+
+	scsi_esp_cmd(esp, cmd);
+
+	do {
+		unsigned int count32 = esp_count >> 5;
+		unsigned int count2 = (esp_count & 0x1F) >> 1;
+		unsigned int start_addr = addr;
+
+		if (mac_esp_wait_for_dreq(esp))
+			break;
+
+		if (write) {
+			MAC_ESP_PDMA_LOOP("%1@,%0@+");
+
+			esp_count -= addr - start_addr;
+		} else {
+			unsigned int n;
+
+			MAC_ESP_PDMA_LOOP("%0@+,%1@");
+
+			if (mac_esp_wait_for_empty_fifo(esp))
+				break;
+
+			n = (esp_read8(ESP_TCMED) << 8) + esp_read8(ESP_TCLOW);
+			addr = start_addr + esp_count - n;
+			esp_count = n;
+		}
+	} while (esp_count);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Programmed IO routines follow.
+ */
+
+static inline int mac_esp_wait_for_fifo(struct esp *esp)
+{
+	int i = 500000;
+
+	do {
+		if (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES)
+			return 0;
+
+		udelay(2);
+	} while (--i);
+
+	printk(KERN_ERR PFX "FIFO is empty (sreg %02x).\n",
+	       esp_read8(ESP_STATUS));
+	return 1;
+}
+
+static inline int mac_esp_wait_for_intr(struct esp *esp)
+{
+	int i = 500000;
+
+	do {
+		esp->sreg = esp_read8(ESP_STATUS);
+		if (esp->sreg & ESP_STAT_INTR)
+			return 0;
+
+		udelay(2);
+	} while (--i);
+
+	printk(KERN_ERR PFX "IRQ timeout (sreg %02x).\n", esp->sreg);
+	return 1;
+}
+
+#define MAC_ESP_PIO_LOOP(operands, reg1) \
+	asm volatile ( \
+	     "1:     moveb " operands " \n" \
+	     "       subqw #1,%1        \n" \
+	     "       jbne 1b            \n" \
+	     : "+a" (addr), "+r" (reg1) \
+	     : "a" (fifo))
+
+#define MAC_ESP_PIO_FILL(operands, reg1) \
+	asm volatile ( \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       moveb " operands " \n" \
+	     "       subqw #8,%1        \n" \
+	     "       subqw #8,%1        \n" \
+	     : "+a" (addr), "+r" (reg1) \
+	     : "a" (fifo))
+
+#define MAC_ESP_FIFO_SIZE 16
+
+static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
+                                 u32 dma_count, int write, u8 cmd)
+{
+	unsigned long flags;
+	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
+	u8 *fifo = esp->regs + ESP_FDATA * 16;
+//printk(">write %d, cmd 0x%02X, fifo %d, esp_count %d\n", write, cmd,esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES, esp_count);
+
+	local_irq_save(flags);
+
+	cmd &= ~ESP_CMD_DMA;
+	mep->error = 0;
+
+	if (write) {
+		scsi_esp_cmd(esp, cmd);
+
+		if (!mac_esp_wait_for_intr(esp)) {
+			if (mac_esp_wait_for_fifo(esp))
+				esp_count = 0;
+		} else
+			esp_count = 0;
+	} else {
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+
+		if (esp_count >= MAC_ESP_FIFO_SIZE)
+			MAC_ESP_PIO_FILL("%0@+,%2@", esp_count);
+		else
+			MAC_ESP_PIO_LOOP("%0@+,%2@", esp_count);
+
+		scsi_esp_cmd(esp, cmd);
+	}
+
+	while (esp_count) {
+		unsigned int n;
+
+		if (mac_esp_wait_for_intr(esp)) {
+			mep->error = 1;
+			break;
+		}
+
+		if (esp->sreg & ESP_STAT_SPAM) {
+			printk(KERN_ERR PFX "gross error.\n");
+			mep->error = 1;
+			break;
+		}
+
+		n = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
+
+		if (write) {
+			if (n > esp_count)
+				n = esp_count;
+			esp_count -= n;
+
+			MAC_ESP_PIO_LOOP("%2@,%0@+", n);
+
+			if ((esp->sreg & ESP_STAT_PMASK) == ESP_STATP)
+				break;
+
+			if (esp_count) {
+				esp->ireg = esp_read8(ESP_INTRPT);
+				if (esp->ireg & ESP_INTR_DC)
+					break;
+
+				scsi_esp_cmd(esp, ESP_CMD_TI);
+			}
+		} else {
+			esp->ireg = esp_read8(ESP_INTRPT);
+			if (esp->ireg & ESP_INTR_DC)
+				break;
+
+			n = MAC_ESP_FIFO_SIZE - n;
+			if (esp_count < n)
+				n = esp_count;
+
+			if (n == MAC_ESP_FIFO_SIZE) {
+				MAC_ESP_PIO_FILL("%0@+,%2@", esp_count);
+			} else {
+				esp_count -= n;
+				MAC_ESP_PIO_LOOP("%0@+,%2@", n);
+			}
+
+			scsi_esp_cmd(esp, ESP_CMD_TI);
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+static int mac_esp_irq_pending(struct esp *esp)
+{
+	if (esp_read8(ESP_STATUS) & ESP_STAT_INTR)
+		return 1;
+	return 0;
+}
+
+static u32 mac_esp_dma_length_limit(struct esp *esp, u32 dma_addr, u32 dma_len)
+{
+	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
+}
+
+static struct esp_driver_ops mac_esp_ops = {
+	.esp_write8       = mac_esp_write8,
+	.esp_read8        = mac_esp_read8,
+	.map_single       = mac_esp_map_single,
+	.map_sg           = mac_esp_map_sg,
+	.unmap_single     = mac_esp_unmap_single,
+	.unmap_sg         = mac_esp_unmap_sg,
+	.irq_pending      = mac_esp_irq_pending,
+	.dma_length_limit = mac_esp_dma_length_limit,
+	.reset_dma        = mac_esp_reset_dma,
+	.dma_drain        = mac_esp_dma_drain,
+	.dma_invalidate   = mac_esp_dma_invalidate,
+	.send_dma_cmd     = mac_esp_send_pdma_cmd,
+	.dma_error        = mac_esp_dma_error,
+};
+
+static int __devinit esp_mac_probe(struct platform_device *dev)
+{
+	struct scsi_host_template *tpnt = &scsi_esp_template;
+	struct Scsi_Host *host;
+	struct esp *esp;
+	int err;
+	int chips_present;
+	struct mac_esp_priv *mep;
+
+	switch (macintosh_config->scsi_type) {
+	case MAC_SCSI_QUADRA:
+	case MAC_SCSI_QUADRA3:
+		chips_present = 1;
+		break;
+	case MAC_SCSI_QUADRA2:
+		if ((macintosh_config->ident == MAC_MODEL_Q900) ||
+		    (macintosh_config->ident == MAC_MODEL_Q950))
+			chips_present = 2;
+		else
+			chips_present = 1;
+		break;
+	default:
+		chips_present = 0;
+	}
+
+	if (dev->id + 1 > chips_present)
+		return -ENODEV;
+
+	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+
+	err = -ENOMEM;
+	if (!host)
+		goto fail;
+
+	host->max_id = 8;
+	host->use_clustering = DISABLE_CLUSTERING;
+	esp = host_to_esp(host);
+
+	esp->host = host;
+	esp->dev = dev;
+
+	esp->command_block = kzalloc(16, GFP_KERNEL);
+	if (!esp->command_block)
+		goto fail_unlink;
+	esp->command_block_dma = (dma_addr_t)esp->command_block;
+
+	esp->scsi_id = 7;
+	host->this_id = esp->scsi_id;
+	esp->scsi_id_mask = 1 << esp->scsi_id;
+
+	mep = kzalloc(sizeof(struct mac_esp_priv), GFP_KERNEL);
+	if (!mep)
+		goto fail_free_command_block;
+	mep->esp = esp;
+	platform_set_drvdata(dev, mep);
+
+	switch (macintosh_config->scsi_type) {
+	case MAC_SCSI_QUADRA:
+		esp->cfreq     = 16500000;
+		esp->regs      = (void __iomem *)MAC_ESP_REGS_QUADRA;
+		mep->pdma_io   = esp->regs + MAC_ESP_PDMA_IO_OFFSET;
+		mep->pdma_regs = NULL;
+		break;
+	case MAC_SCSI_QUADRA2:
+		esp->cfreq     = 25000000;
+		esp->regs      = (void __iomem *)(MAC_ESP_REGS_QUADRA2 +
+		                 dev->id * MAC_ESP_REGS_SPACING);
+		mep->pdma_io   = esp->regs + MAC_ESP_PDMA_IO_OFFSET;
+		mep->pdma_regs = (void __iomem *)(MAC_ESP_PDMA_REG +
+		                 dev->id * MAC_ESP_PDMA_REG_SPACING);
+		nubus_writel(0x1d1, mep->pdma_regs);
+		break;
+	case MAC_SCSI_QUADRA3:
+		/* These quadras have a real DMA controller (the PSC) but we
+		 * don't know how to drive it so we must use PIO instead.
+		 */
+		esp->cfreq     = 25000000;
+		esp->regs      = (void __iomem *)MAC_ESP_REGS_QUADRA3;
+		mep->pdma_io   = NULL;
+		mep->pdma_regs = NULL;
+		break;
+	}
+
+	esp->ops = &mac_esp_ops;
+	if (mep->pdma_io == NULL) {
+		printk(KERN_INFO PFX "using PIO for controller %d\n", dev->id);
+		esp_write8(0, ESP_TCLOW);
+		esp_write8(0, ESP_TCMED);
+		esp->flags = ESP_FLAG_DISABLE_SYNC;
+		mac_esp_ops.send_dma_cmd = mac_esp_send_pio_cmd;
+	} else {
+		printk(KERN_INFO PFX "using PDMA for controller %d\n", dev->id);
+	}
+
+	host->irq = IRQ_MAC_SCSI;
+	err = request_irq(host->irq, scsi_esp_intr,
+	                  IRQF_SHARED, "Mac ESP", esp);
+	if (err < 0)
+		goto fail_free_priv;
+
+	err = scsi_esp_register(esp, &dev->dev);
+	if (err)
+		goto fail_free_irq;
+
+	return 0;
+
+fail_free_irq:
+	free_irq(host->irq, esp);
+fail_free_priv:
+	kfree(mep);
+fail_free_command_block:
+	kfree(esp->command_block);
+fail_unlink:
+	scsi_host_put(host);
+fail:
+	return err;
+}
+
+static int __devexit esp_mac_remove(struct platform_device *dev)
+{
+	struct mac_esp_priv *mep = platform_get_drvdata(dev);
+	struct esp *esp = mep->esp;
+	unsigned int irq = esp->host->irq;
+
+	scsi_esp_unregister(esp);
+
+	free_irq(irq, esp);
+
+	kfree(esp->command_block);
+
+	scsi_host_put(esp->host);
+
+	kfree(mep);
+
+	return 0;
+}
+
+static struct platform_driver esp_mac_driver = {
+	.probe    = esp_mac_probe,
+	.remove   = __devexit_p(esp_mac_remove),
+	.driver   = {
+		.name     = DRV_MODULE_NAME,
+	},
+};
+
+static int __init mac_esp_init(void)
+{
+	int err;
+
+	if ((err = platform_driver_register(&esp_mac_driver)))
+		return err;
+
+	internal_esp = platform_device_alloc(DRV_MODULE_NAME, 0);
+	if (internal_esp && platform_device_add(internal_esp)) {
+		platform_device_put(internal_esp);
+		internal_esp = NULL;
+	}
+
+	external_esp = platform_device_alloc(DRV_MODULE_NAME, 1);
+	if (external_esp && platform_device_add(external_esp)) {
+		platform_device_put(external_esp);
+		external_esp = NULL;
+	}
+
+	if (internal_esp || external_esp) {
+		return 0;
+	} else {
+		platform_driver_unregister(&esp_mac_driver);
+		return -ENOMEM;
+	}
+}
+
+static void __exit mac_esp_exit(void)
+{
+	platform_driver_unregister(&esp_mac_driver);
+
+	if (internal_esp) {
+		platform_device_unregister(internal_esp);
+		internal_esp = NULL;
+	}
+	if (external_esp) {
+		platform_device_unregister(external_esp);
+		external_esp = NULL;
+	}
+}
+
+MODULE_DESCRIPTION("Mac ESP SCSI driver");
+MODULE_AUTHOR("Finn Thain <fthain@telegraphics.com.au>");
+MODULE_LICENSE("GPLv2");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(mac_esp_init);
+module_exit(mac_esp_exit);
Index: linux-2.6.22/drivers/scsi/sun_esp.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/sun_esp.c	2008-02-21 14:49:27.000000000 +1100
+++ linux-2.6.22/drivers/scsi/sun_esp.c	2008-02-21 14:49:48.000000000 +1100
@@ -461,18 +461,19 @@ static int sbus_esp_dma_error(struct esp
 }
 
 static const struct esp_driver_ops sbus_esp_ops = {
-	.esp_write8	=	sbus_esp_write8,
-	.esp_read8	=	sbus_esp_read8,
-	.map_single	=	sbus_esp_map_single,
-	.map_sg		=	sbus_esp_map_sg,
-	.unmap_single	=	sbus_esp_unmap_single,
-	.unmap_sg	=	sbus_esp_unmap_sg,
-	.irq_pending	=	sbus_esp_irq_pending,
-	.reset_dma	=	sbus_esp_reset_dma,
-	.dma_drain	=	sbus_esp_dma_drain,
-	.dma_invalidate	=	sbus_esp_dma_invalidate,
-	.send_dma_cmd	=	sbus_esp_send_dma_cmd,
-	.dma_error	=	sbus_esp_dma_error,
+	.esp_write8       =	sbus_esp_write8,
+	.esp_read8        =	sbus_esp_read8,
+	.map_single       =	sbus_esp_map_single,
+	.map_sg           =	sbus_esp_map_sg,
+	.unmap_single     =	sbus_esp_unmap_single,
+	.unmap_sg         =	sbus_esp_unmap_sg,
+	.irq_pending      =	sbus_esp_irq_pending,
+	.dma_length_limit =	esp_dma_length_limit,
+	.reset_dma        =	sbus_esp_reset_dma,
+	.dma_drain        =	sbus_esp_dma_drain,
+	.dma_invalidate   =	sbus_esp_dma_invalidate,
+	.send_dma_cmd     =	sbus_esp_send_dma_cmd,
+	.dma_error        =	sbus_esp_dma_error,
 };
 
 static int __devinit esp_sbus_probe_one(struct device *dev,
Index: linux-2.6.22/drivers/scsi/jazz_esp.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/jazz_esp.c	2008-02-21 14:49:27.000000000 +1100
+++ linux-2.6.22/drivers/scsi/jazz_esp.c	2008-02-21 14:49:48.000000000 +1100
@@ -114,18 +114,19 @@ static int jazz_esp_dma_error(struct esp
 }
 
 static const struct esp_driver_ops jazz_esp_ops = {
-	.esp_write8	=	jazz_esp_write8,
-	.esp_read8	=	jazz_esp_read8,
-	.map_single	=	jazz_esp_map_single,
-	.map_sg		=	jazz_esp_map_sg,
-	.unmap_single	=	jazz_esp_unmap_single,
-	.unmap_sg	=	jazz_esp_unmap_sg,
-	.irq_pending	=	jazz_esp_irq_pending,
-	.reset_dma	=	jazz_esp_reset_dma,
-	.dma_drain	=	jazz_esp_dma_drain,
-	.dma_invalidate	=	jazz_esp_dma_invalidate,
-	.send_dma_cmd	=	jazz_esp_send_dma_cmd,
-	.dma_error	=	jazz_esp_dma_error,
+	.esp_write8       =	jazz_esp_write8,
+	.esp_read8        =	jazz_esp_read8,
+	.map_single       =	jazz_esp_map_single,
+	.map_sg           =	jazz_esp_map_sg,
+	.unmap_single     =	jazz_esp_unmap_single,
+	.unmap_sg         =	jazz_esp_unmap_sg,
+	.irq_pending      =	jazz_esp_irq_pending,
+	.dma_length_limit =	esp_dma_length_limit,
+	.reset_dma        =	jazz_esp_reset_dma,
+	.dma_drain        =	jazz_esp_dma_drain,
+	.dma_invalidate   =	jazz_esp_dma_invalidate,
+	.send_dma_cmd     =	jazz_esp_send_dma_cmd,
+	.dma_error        =	jazz_esp_dma_error,
 };
 
 static int __devinit esp_jazz_probe(struct platform_device *dev)
Index: linux/drivers/scsi/sun3x_esp.c
===================================================================
--- linux.orig/drivers/scsi/sun3x_esp.c	2008-02-21 14:33:43.000000000 +1100
+++ linux/drivers/scsi/sun3x_esp.c	2008-02-21 14:36:38.000000000 +1100
@@ -179,18 +179,19 @@ static int sun3x_esp_dma_error(struct es
 }
 
 static const struct esp_driver_ops sun3x_esp_ops = {
-	.esp_write8	=	sun3x_esp_write8,
-	.esp_read8	=	sun3x_esp_read8,
-	.map_single	=	sun3x_esp_map_single,
-	.map_sg		=	sun3x_esp_map_sg,
-	.unmap_single	=	sun3x_esp_unmap_single,
-	.unmap_sg	=	sun3x_esp_unmap_sg,
-	.irq_pending	=	sun3x_esp_irq_pending,
-	.reset_dma	=	sun3x_esp_reset_dma,
-	.dma_drain	=	sun3x_esp_dma_drain,
-	.dma_invalidate	=	sun3x_esp_dma_invalidate,
-	.send_dma_cmd	=	sun3x_esp_send_dma_cmd,
-	.dma_error	=	sun3x_esp_dma_error,
+	.esp_write8       =	sun3x_esp_write8,
+	.esp_read8        =	sun3x_esp_read8,
+	.map_single       =	sun3x_esp_map_single,
+	.map_sg           =	sun3x_esp_map_sg,
+	.unmap_single     =	sun3x_esp_unmap_single,
+	.unmap_sg         =	sun3x_esp_unmap_sg,
+	.irq_pending      =	sun3x_esp_irq_pending,
+	.dma_length_limit =	esp_dma_length_limit,
+	.reset_dma        =	sun3x_esp_reset_dma,
+	.dma_drain        =	sun3x_esp_dma_drain,
+	.dma_invalidate   =	sun3x_esp_dma_invalidate,
+	.send_dma_cmd     =	sun3x_esp_send_dma_cmd,
+	.dma_error        =	sun3x_esp_dma_error,
 };
 
 static int __devinit esp_sun3x_probe(struct platform_device *dev)
