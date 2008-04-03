From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 12/17] ips.c: fix build warning
Date: Thu, 03 Apr 2008 12:28:20 -0500
Message-ID: <1207243700.3048.52.camel@localhost.localdomain>
References: <200803282148.m2SLmeDg012249@imap1.linux-foundation.org>
	 <1206896842.4224.46.camel@localhost.localdomain>
	 <20080331085730T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52807 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbYDCR2Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 13:28:24 -0400
In-Reply-To: <20080331085730T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, aacraid@adaptec.com, jeff@garzik.org

On Mon, 2008-03-31 at 08:57 +0900, FUJITA Tomonori wrote:
> On Sun, 30 Mar 2008 12:07:22 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > 
> > > powerpc:
> > > 
> > > drivers/scsi/ips.c: In function 'ips_issue_copperhead':
> > > drivers/scsi/ips.c:5436: warning: large integer implicitly truncated to unsigned type
> > > 
> > > it doesn't seem necessary to do outw(cpu_to_le32(...), ...) anyway.
> > 
> > Actually, it's not only not necessary ... it's an actual bug on BE
> > platforms.  Both writeX and outX/inX automatically convert from native
> > to bus endian (usually simply to LE since the bus is PCI).  Therefore if
> > you add a cpu_to_leX, you actually write the wrong value on a BE system.
> > 
> > Mark, it looks like the correct fix is simply to strip all of these ...
> > has this driver actually been tested on a BE platform (like parisc or
> > PPC)?
> 
> I guess that it hasn't. ips.c includes:
> 
> #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
> #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
> #endif

At least it only warns, it doesn't #error

OK, does this look like the roughly correct fix (I suppose there's no
chance of finding someone to actually test it on a BE platform?).

James

---

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index c450194..7c615c7 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2377,7 +2377,7 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 			if (inb(ha->io_addr + IPS_REG_FLDP) != 0x55)
 				return;
 
-			outl(cpu_to_le32(1), ha->io_addr + IPS_REG_FLAP);
+			outl(1, ha->io_addr + IPS_REG_FLAP);
 			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
@@ -2385,21 +2385,21 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 				return;
 
 			/* Get Major version */
-			outl(cpu_to_le32(0x1FF), ha->io_addr + IPS_REG_FLAP);
+			outl(0x1FF, ha->io_addr + IPS_REG_FLAP);
 			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			major = inb(ha->io_addr + IPS_REG_FLDP);
 
 			/* Get Minor version */
-			outl(cpu_to_le32(0x1FE), ha->io_addr + IPS_REG_FLAP);
+			outl(0x1FE, ha->io_addr + IPS_REG_FLAP);
 			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			minor = inb(ha->io_addr + IPS_REG_FLDP);
 
 			/* Get SubMinor version */
-			outl(cpu_to_le32(0x1FD), ha->io_addr + IPS_REG_FLAP);
+			outl(0x1FD, ha->io_addr + IPS_REG_FLAP);
 			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
@@ -4852,7 +4852,7 @@ ips_init_copperhead(ips_ha_t * ha)
 		return (0);
 
 	/* setup CCCR */
-	outl(cpu_to_le32(0x1010), ha->io_addr + IPS_REG_CCCR);
+	outl(0x1010, ha->io_addr + IPS_REG_CCCR);
 
 	/* Enable busmastering */
 	outb(IPS_BIT_EBM, ha->io_addr + IPS_REG_SCPR);
@@ -5234,12 +5234,12 @@ ips_statinit(ips_ha_t * ha)
 	ha->adapt->p_status_tail = ha->adapt->status;
 
 	phys_status_start = ha->adapt->hw_status_start;
-	outl(cpu_to_le32(phys_status_start), ha->io_addr + IPS_REG_SQSR);
-	outl(cpu_to_le32(phys_status_start + IPS_STATUS_Q_SIZE),
+	outl(phys_status_start, ha->io_addr + IPS_REG_SQSR);
+	outl(phys_status_start + IPS_STATUS_Q_SIZE,
 	     ha->io_addr + IPS_REG_SQER);
-	outl(cpu_to_le32(phys_status_start + IPS_STATUS_SIZE),
+	outl(phys_status_start + IPS_STATUS_SIZE,
 	     ha->io_addr + IPS_REG_SQHR);
-	outl(cpu_to_le32(phys_status_start), ha->io_addr + IPS_REG_SQTR);
+	outl(phys_status_start, ha->io_addr + IPS_REG_SQTR);
 
 	ha->adapt->hw_status_tail = phys_status_start;
 }
@@ -5296,7 +5296,7 @@ ips_statupd_copperhead(ips_ha_t * ha)
 		ha->adapt->hw_status_tail = ha->adapt->hw_status_start;
 	}
 
-	outl(cpu_to_le32(ha->adapt->hw_status_tail),
+	outl(ha->adapt->hw_status_tail,
 	     ha->io_addr + IPS_REG_SQTR);
 
 	return (ha->adapt->p_status_tail->value);
@@ -5398,8 +5398,8 @@ ips_issue_copperhead(ips_ha_t * ha, ips_scb_t * scb)
 		}		/* end if */
 	}			/* end while */
 
-	outl(cpu_to_le32(scb->scb_busaddr), ha->io_addr + IPS_REG_CCSAR);
-	outw(cpu_to_le32(IPS_BIT_START_CMD), ha->io_addr + IPS_REG_CCCR);
+	outl(scb->scb_busaddr, ha->io_addr + IPS_REG_CCSAR);
+	outw(IPS_BIT_START_CMD, ha->io_addr + IPS_REG_CCCR);
 
 	return (IPS_SUCCESS);
 }
@@ -5484,7 +5484,7 @@ ips_issue_i2o(ips_ha_t * ha, ips_scb_t * scb)
 			  ips_name, ha->host_num, scb->cmd.basic_io.command_id);
 	}
 
-	outl(cpu_to_le32(scb->scb_busaddr), ha->io_addr + IPS_REG_I2O_INMSGQ);
+	outl(scb->scb_busaddr, ha->io_addr + IPS_REG_I2O_INMSGQ);
 
 	return (IPS_SUCCESS);
 }
@@ -6376,7 +6376,7 @@ ips_program_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 
 	for (i = 0; i < buffersize; i++) {
 		/* write a byte */
-		outl(cpu_to_le32(i + offset), ha->io_addr + IPS_REG_FLAP);
+		outl(i + offset, ha->io_addr + IPS_REG_FLAP);
 		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
@@ -6561,7 +6561,7 @@ ips_verify_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	if (inb(ha->io_addr + IPS_REG_FLDP) != 0x55)
 		return (1);
 
-	outl(cpu_to_le32(1), ha->io_addr + IPS_REG_FLAP);
+	outl(1, ha->io_addr + IPS_REG_FLAP);
 	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 	if (inb(ha->io_addr + IPS_REG_FLDP) != 0xAA)
@@ -6570,7 +6570,7 @@ ips_verify_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	checksum = 0xff;
 	for (i = 2; i < buffersize; i++) {
 
-		outl(cpu_to_le32(i + offset), ha->io_addr + IPS_REG_FLAP);
+		outl(i + offset, ha->io_addr + IPS_REG_FLAP);
 		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 


