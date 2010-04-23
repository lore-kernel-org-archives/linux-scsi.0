From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 10/21] m68k/scsi: a2091 - Kill ugly DMA() macro
Date: Fri, 23 Apr 2010 10:40:19 +0200
Message-ID: <s2z10f740e81004230140xd60ac9dbv8c904a3aa365edad@mail.gmail.com>
References: <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
	 <20100405062529.GA28950@infradead.org>
	 <s2o10f740e81004051242r27951fcftefe2ca3d1425ff66@mail.gmail.com>
	 <i2h10f740e81004230137oc7c5f464w164786cd7f13f589@mail.gmail.com>
	 <n2o10f740e81004230138j67eb7e51k8920e49766fa4a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <n2o10f740e81004230138j67eb7e51k8920e49766fa4a4@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 23, 2010 at 10:38, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Apr 23, 2010 at 10:37, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Mon, Apr 5, 2010 at 21:42, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Mon, Apr 5, 2010 at 08:25, Christoph Hellwig <hch@infradead.org> wrote:
>>>> Instead of abusing the ScsiHost base field I'd prefer if you stick
>>>
>>> I wouldn't call it abuse: it's a (MM)IO base address anyway.
>>> But I see that field was indeed marked `legacy crap' in an otherwise
>>> innocent looking
>>> commit to split the SCSI include files... by you ;-)
>>>
>>>> a properly typed pointer into the device specific host data.
>>>
>>> You mean shost_priv()? That field already contains a pointer to the
>>> struct WD33C93_hostdata.
>>>
>>> But I'll create a new a2091_hostdata struct that contains both the
>>> WD33C93_hostdata and the a2091_scsiregs pointer (and do the same
>>> for gvp11.c and a3000.c). It's a bit similar to what sgiwd93.c does, albeit that
>>> one also uses the legacy base field.
>>
>> As I want to avoid introducing bugs by respinning the complicated
>> parts (the zorro
>> driver and platform driver conversion patches), I made this change on
>> top of the 2
>> whole patch series.

A3000 part (on top of today's Amiga platform conversion patch series)

>From 6dca8f7534f9db10613b7034b895c0f56a433d07 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 12 Apr 2010 21:55:15 +0200
Subject: [PATCH] m68k/scsi: a3000 - Do not use legacy Scsi_Host.base

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |   76 +++++++++++++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 7f09d89..d946802 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -17,11 +17,16 @@
 #include "a3000.h"


+struct a3000_hostdata {
+	struct WD33C93_hostdata wh;
+	struct a3000_scsiregs *regs;
+};
+
 static irqreturn_t a3000_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
-	unsigned int status = regs->ISTR;
+	struct a3000_hostdata *hdata = shost_priv(instance);
+	unsigned int status = hdata->regs->ISTR;
 	unsigned long flags;

 	if (!(status & ISTR_INT_P))
@@ -39,8 +44,9 @@ static irqreturn_t a3000_intr(int irq, void *data)
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct a3000_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct a3000_scsiregs *regs = hdata->regs;
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);

@@ -51,23 +57,23 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	 * buffer
 	 */
 	if (addr & A3000_XFER_MASK) {
-		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
-		hdata->dma_bounce_buffer = kmalloc(hdata->dma_bounce_len,
-						   GFP_KERNEL);
+		wh->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+		wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
+						GFP_KERNEL);

 		/* can't allocate memory; use PIO */
-		if (!hdata->dma_bounce_buffer) {
-			hdata->dma_bounce_len = 0;
+		if (!wh->dma_bounce_buffer) {
+			wh->dma_bounce_len = 0;
 			return 1;
 		}

 		if (!dir_in) {
 			/* copy to bounce buffer for a write */
-			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
 			       cmd->SCp.this_residual);
 		}

-		addr = virt_to_bus(hdata->dma_bounce_buffer);
+		addr = virt_to_bus(wh->dma_bounce_buffer);
 	}

 	/* setup dma direction */
@@ -75,7 +81,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cntr |= CNTR_DDIR;

 	/* remember direction */
-	hdata->dma_dir = dir_in;
+	wh->dma_dir = dir_in;

 	regs->CNTR = cntr;

@@ -102,20 +108,21 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct a3000_hostdata *hdata = shost_priv(instance);
+	struct WD33C93_hostdata *wh = &hdata->wh;
+	struct a3000_scsiregs *regs = hdata->regs;

 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;

-	if (!hdata->dma_dir)
+	if (!wh->dma_dir)
 		cntr |= CNTR_DDIR;

 	regs->CNTR = cntr;
 	mb();			/* make sure CNTR is updated before next IO */

 	/* flush if we were reading */
-	if (hdata->dma_dir) {
+	if (wh->dma_dir) {
 		regs->FLUSH = 1;
 		mb();		/* don't allow prefetch */
 		while (!(regs->ISTR & ISTR_FE_FLG))
@@ -138,19 +145,18 @@ static void dma_stop(struct Scsi_Host *instance,
struct scsi_cmnd *SCpnt,
 	mb();			/* make sure CNTR is updated before next IO */

 	/* copy from a bounce buffer, if necessary */
-	if (status && hdata->dma_bounce_buffer) {
+	if (status && wh->dma_bounce_buffer) {
 		if (SCpnt) {
-			if (hdata->dma_dir && SCpnt)
-				memcpy(SCpnt->SCp.ptr,
-				       hdata->dma_bounce_buffer,
+			if (wh->dma_dir && SCpnt)
+				memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
 				       SCpnt->SCp.this_residual);
-			kfree(hdata->dma_bounce_buffer);
-			hdata->dma_bounce_buffer = NULL;
-			hdata->dma_bounce_len = 0;
+			kfree(wh->dma_bounce_buffer);
+			wh->dma_bounce_buffer = NULL;
+			wh->dma_bounce_len = 0;
 		} else {
-			kfree(hdata->dma_bounce_buffer);
-			hdata->dma_bounce_buffer = NULL;
-			hdata->dma_bounce_len = 0;
+			kfree(wh->dma_bounce_buffer);
+			wh->dma_bounce_buffer = NULL;
+			wh->dma_bounce_len = 0;
 		}
 	}
 }
@@ -194,7 +200,7 @@ static int __init amiga_a3000_scsi_probe(struct
platform_device *pdev)
 	int error;
 	struct a3000_scsiregs *regs;
 	wd33c93_regs wdregs;
-	struct WD33C93_hostdata *hdata;
+	struct a3000_hostdata *hdata;

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -204,25 +210,25 @@ static int __init amiga_a3000_scsi_probe(struct
platform_device *pdev)
 		return -EBUSY;

 	instance = scsi_host_alloc(&amiga_a3000_scsi_template,
-				   sizeof(struct WD33C93_hostdata));
+				   sizeof(struct a3000_hostdata));
 	if (!instance) {
 		error = -ENOMEM;
 		goto fail_alloc;
 	}

-	instance->base = ZTWO_VADDR(res->start);
 	instance->irq = IRQ_AMIGA_PORTS;

-	regs = (struct a3000_scsiregs *)(instance->base);
+	regs = (struct a3000_scsiregs *)ZTWO_VADDR(res->start);
 	regs->DAWR = DAWR_A3000;

 	wdregs.SASR = &regs->SASR;
 	wdregs.SCMD = &regs->SCMD;

 	hdata = shost_priv(instance);
-	hdata->no_sync = 0xff;
-	hdata->fast = 0;
-	hdata->dma_mode = CTRL_DMA;
+	hdata->wh.no_sync = 0xff;
+	hdata->wh.fast = 0;
+	hdata->wh.dma_mode = CTRL_DMA;
+	hdata->regs = regs;

 	wd33c93_init(instance, wdregs, dma_setup, dma_stop, WD33C93_FS_12_15);
 	error = request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED,
@@ -253,10 +259,10 @@ fail_alloc:
 static int __exit amiga_a3000_scsi_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *instance = platform_get_drvdata(pdev);
-	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
+	struct a3000_hostdata *hdata = shost_priv(instance);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

-	regs->CNTR = 0;
+	hdata->regs->CNTR = 0;
 	scsi_remove_host(instance);
 	free_irq(IRQ_AMIGA_PORTS, instance);
 	scsi_host_put(instance);
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
