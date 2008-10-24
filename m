From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command,
	waited 22s
Date: Fri, 24 Oct 2008 13:06:27 -0500
Message-ID: <1224871587.3307.19.camel@localhost.localdomain>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-10-24 at 19:57 +0200, Maciej Rutecki wrote:
> During boot I have this message:
> 
> ata_piix 0000:00:1f.1: version 2.12
> ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ata_piix 0000:00:1f.1: setting latency timer to 64
> scsi4 : ata_piix
> scsi5 : ata_piix
> ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
> ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
> ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
> ata5.00: configured for MWDMA2
> ata6: port disabled. ignoring.
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> 	ata5: WARNING: synchronous SCSI scan failed without making any progress,
>                   switching to async
> 
> DVD drive doesn't work. Under 2.6.27 (stable and -rc) works OK.
> 
> Dmesg ang config:
> http://unixy.pl/maciek/download/kernel/2.6.28-rc1/

You need this patch:

James

---

commit e013e13bf605b9e6b702adffbe2853cfc60e7806
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Oct 24 09:22:42 2008 +0200

    libata: fix bug with non-ncq devices
    
    The recent commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e ("libata:
    switch to using block layer tagging support") to enable support for
    block layer tagging in libata was broken for non-NCQ devices
    
    The block layer initializes the tag field to -1 to detect invalid uses
    of a tag, and if the libata devices does NOT support NCQ, we just used
    that field to index the internal command list.  So we need to check for
    -1 first and only use the tag field if it's valid.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
    Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
    Tested-by: Paul Mundt <lethal@linux-sh.org>
    Tested-by: Dave Young <hidave.darkstar@gmail.com>
    Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d5b9b72..4b95c43 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -708,7 +708,11 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev, cmd->request->tag);
+	if (cmd->request->tag != -1)
+		qc = ata_qc_new_init(dev, cmd->request->tag);
+	else
+		qc = ata_qc_new_init(dev, 0);
+
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = done;


