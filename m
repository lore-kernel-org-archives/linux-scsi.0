From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] mac_esp: fix PIO mode
Date: Fri, 4 Dec 2009 23:58:05 +1100 (EST)
Message-ID: <alpine.OSX.2.00.0912042321220.596@localhost>
References: <alpine.OSX.2.00.0911231452300.468@localhost> <20091202.154045.142858043.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20091202.154045.142858043.davem@davemloft.net>
Sender: linux-m68k-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2 Dec 2009, David Miller wrote:

...
> 
> Can you explain why the esp_slave_configure() part of your patch is 
> necessary?
> 
> > Index: linux-2.6.31/drivers/scsi/esp_scsi.c
> > ===================================================================
> > --- linux-2.6.31.orig/drivers/scsi/esp_scsi.c	2009-11-23 12:52:45.000000000 +1100
> > +++ linux-2.6.31/drivers/scsi/esp_scsi.c	2009-11-23 12:53:30.000000000 +1100
> > @@ -2405,12 +2405,6 @@ static int esp_slave_configure(struct sc
> >  	struct esp_target_data *tp = &esp->target[dev->id];
> >  	int goal_tags, queue_depth;
> >  
> > -	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
> > -		/* Bypass async domain validation */
> > -		dev->ppr  = 0;
> > -		dev->sdtr = 0;
> > -	}
> > -
> >  	goal_tags = 0;
> >  
> >  	if (dev->tagged_supported) {
> > @@ -2433,6 +2427,11 @@ static int esp_slave_configure(struct sc
> >  	}
> >  	tp->flags |= ESP_TGT_DISCONNECT;
> >  
> > +	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
> > +		dev->wdtr = spi_support_wide(dev->sdev_target) = 0;
> > +		dev->sdtr = spi_support_sync(dev->sdev_target) = 0;
> > +	}
> > +
> >  	if (!spi_initial_dv(dev->sdev_target))
> >  		spi_dv_device(dev);
> >  

The aim is that domain validation will not test for sync when we know it 
can't work (in PIO mode). This is the result:

mac_esp: using PIO for controller 0
esp: esp0, regs[50f18000:(null)] irq[19]
esp: esp0 is a ESP236, 25 MHz (ccf=5), SCSI ID 7
scsi0 : esp
scsi 0:0:6:0: Direct-Access     QUANTUM  LPS540S          590S PQ: 0 ANSI: 2 CCS
 target0:0:6: Beginning Domain Validation
 target0:0:6: Ending Domain Validation
sd 0:0:6:0: [sda] 1057616 512-byte logical blocks: (541 MB/516 MiB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Whereas, without the esp_slave_configure() code, I get this:

scsi0 : esp
scsi 0:0:6:0: Direct-Access     QUANTUM  LPS540S          590S PQ: 0 ANSI: 2 CCS
 target0:0:6: Beginning Domain Validation
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81)
esp: esp0: DMA length is zero!
esp: esp0: cur adr[010eb082] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81)
esp: esp0: DMA length is zero!
esp: esp0: cur adr[010eb082] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81)
esp: esp0: DMA length is zero!
esp: esp0: cur adr[010eb082] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81)
esp: esp0: DMA length is zero!
esp: esp0: cur adr[010eb082] len[00000000]
 target0:0:6: Domain Validation detected failure, dropping back
 target0:0:6: asynchronous
mac_esp: FIFO is empty (sreg 81)
esp: esp0: DMA length is zero!
esp: esp0: cur adr[010eb082] len[00000000]
 target0:0:6: Domain Validation Failure, dropping back to Asynchronous
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
sd 0:0:6:0: [sda] 1057616 512-byte logical blocks: (541 MB/516 MiB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Which takes longer but gives the same result. The CDROM drive is worse 
however:

scsi0 : esp
scsi 0:0:4:0: CD-ROM            TOSHIBA  CD-ROM XM-5401TA 1036 PQ: 0 ANSI: 2
 target0:0:4: Beginning Domain Validation
 target0:0:4: asynchronous
mac_esp: FIFO is empty (sreg 01)
esp: esp0: Aborting command [010dc940:12]
esp: esp0: Current command [010dc940:12]
esp: esp0: Active command [010dc940:12]
esp: esp0: Dumping command log
esp: esp0: ent[27] CMD val[01] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[28] CMD val[10] sreg[87] seqreg[01] sreg2[00] ireg[10] ss[00] event[06]
esp: esp0: ent[29] CMD val[12] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
esp: esp0: ent[30] EVENT val[0d] sreg[87] seqreg[01] sreg2[00] ireg[08] ss[00] event[06]
...

So the esp driver then retries the aborted command a few times, with 
delays. Multiply those retries by the five domain validation iterations. 
Then, IIRC, the CDROM finally gets offlined at the end of that slow 
process.

I did a quick test, and this works too:

@@ -2405,12 +2405,6 @@ static int esp_slave_configure(struct sc
 	struct esp_target_data *tp = &esp->target[dev->id];
 	int goal_tags, queue_depth;
 
-	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
-		/* Bypass async domain validation */
-		dev->ppr  = 0;
-		dev->sdtr = 0;
-	}
-
 	goal_tags = 0;
 
 	if (dev->tagged_supported) {  
@@ -2433,6 +2427,9 @@ static int esp_slave_configure(struct sc
 	}
 	tp->flags |= ESP_TGT_DISCONNECT;
 
+	if (esp->flags & ESP_FLAG_DISABLE_SYNC)
+		spi_support_sync(dev->sdev_target) = 0;
+
 	if (!spi_initial_dv(dev->sdev_target))
 		spi_dv_device(dev);
 
I will resubmit the patch like so if you wish. Or you could go ahead and 
make the change.

Finn
