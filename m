From: Stephen Hemminger <shemminger@osdl.org>
Subject: Something wrong with latest adaptec aic driver
Date: Wed, 9 Mar 2005 17:18:43 -0800
Message-ID: <20050309171843.04708e19@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:62410 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262622AbVCJBS2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 20:18:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

(Found out not to put aic7xxx in subject line because of spam filter...)

Running with latest 2.6.11 bk tree, one of my machines takes for ever to boot.
The driver is builtin (not a module).  It worked fine until today, and works
fine with 2.6.11 or earlier.  Looks like it is going into some probing fallback
unwind code mess... This is the current driver not the old driver.

The scsi controller is:

0000:03:01.0 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
	Subsystem: IBM: Unknown device 00cf
	Flags: bus master, 66Mhz, medium devsel, latency 32, IRQ 20
	BIST result: 00
	I/O ports at 9000 [disabled]
	Memory at f2006000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2

0000:03:01.1 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
	Subsystem: IBM: Unknown device 00cf
	Flags: bus master, 66Mhz, medium devsel, latency 32, IRQ 20
	BIST result: 00
	I/O ports at 9400 [disabled]
	Memory at f2005000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2

During boot up the console output is...

ACPI: PCI interrupt 0000:03:01.1[B] -> GSI 20 (level, low) -> IRQ 20
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
(scsi0:A:0): 80.000MB/s transfers (40.000MHz DT, offset 63, 16bit)
(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
ahc_intr: HOST_MSG_LOOP bad phase 0x0
(scsi0:A:0): 40.000MB/s transfers (40.000MHz, offset 63)
(scsi0:A:0): 66.006MB/s transfers (33.003MHz DT, offset 63, 16bit)
(scsi0:A:0): 66.006MB/s transfers (33.003MHz, offset 63, 16bit)
(scsi0:A:0): 40.000MB/s transfers (20.000MHz DT, offset 63, 16bit)
(scsi0:A:0): 40.000MB/s transfers (20.000MHz, offset 63, 16bit)
(scsi0:A:0): 33.003MB/s transfers (33.003MHz, offset 63)
(scsi0:A:0): 20.000MB/s transfers (20.000MHz, offset 63)
(scsi0:A:0): 38.460MB/s transfers (19.230MHz DT, offset 63, 16bit)
(scsi0:A:0): 38.460MB/s transfers (19.230MHz, offset 63, 16bit)
(scsi0:A:0): 35.714MB/s transfers (17.857MHz DT, offset 63, 16bit)
(scsi0:A:0): 35.714MB/s transfers (17.857MHz, offset 63, 16bit)
(scsi0:A:0): 33.332MB/s transfers (16.666MHz DT, offset 63, 16bit)
(scsi0:A:0): 33.332MB/s transfers (16.666MHz, offset 63, 16bit)
(scsi0:A:0): 31.250MB/s transfers (15.625MHz DT, offset 63, 16bit)
(scsi0:A:0): 31.250MB/s transfers (15.625MHz, offset 63, 16bit)
(scsi0:A:0): 29.410MB/s transfers (14.705MHz DT, offset 63, 16bit)
(scsi0:A:0): 29.410MB/s transfers (14.705MHz, offset 63, 16bit)
(scsi0:A:0): 27.776MB/s transfers (13.888MHz DT, offset 63, 16bit)
(scsi0:A:0): 27.776MB/s transfers (13.888MHz, offset 63, 16bit)
(scsi0:A:0): 26.314MB/s transfers (13.157MHz DT, offset 63, 16bit)
(scsi0:A:0): 26.314MB/s transfers (13.157MHz, offset 63, 16bit)
(scsi0:A:0): 25.000MB/s transfers (12.500MHz DT, offset 63, 16bit)
(scsi0:A:0): 25.000MB/s transfers (12.500MHz, offset 63, 16bit)
(scsi0:A:0): 23.808MB/s transfers (11.904MHz DT, offset 63, 16bit)
(scsi0:A:0): 23.808MB/s transfers (11.904MHz, offset 63, 16bit)
(scsi0:A:0): 22.726MB/s transfers (11.363MHz DT, offset 63, 16bit)
(scsi0:A:0): 22.726MB/s transfers (11.363MHz, offset 63, 16bit)
(scsi0:A:0): 21.738MB/s transfers (10.869MHz DT, offset 63, 16bit)
(scsi0:A:0): 21.738MB/s transfers (10.869MHz, offset 63, 16bit)
(scsi0:A:0): 20.832MB/s transfers (10.416MHz DT, offset 63, 16bit)
(scsi0:A:0): 20.832MB/s transfers (10.416MHz, offset 63, 16bit)
(scsi0:A:0): 20.000MB/s transfers (10.000MHz DT, offset 63, 16bit)
(scsi0:A:0): 20.000MB/s transfers (10.000MHz, offset 63, 16bit)
(scsi0:A:0): 19.230MB/s transfers (9.615MHz, offset 63, 16bit)
(scsi0:A:0): 18.518MB/s transfers (9.259MHz, offset 63, 16bit)
(scsi0:A:0): 17.856MB/s transfers (8.928MHz, offset 63, 16bit)
(scsi0:A:0): 17.240MB/s transfers (8.620MHz, offset 63, 16bit)
(scsi0:A:0): 16.666MB/s transfers (8.333MHz, offset 63, 16bit)
(scsi0:A:0): 16.128MB/s transfers (8.064MHz, offset 63, 16bit)
(scsi0:A:0): 15.624MB/s transfers (7.812MHz, offset 63, 16bit)
(scsi0:A:0): 15.150MB/s transfers (7.575MHz, offset 63, 16bit)
(scsi0:A:0): 14.704MB/s transfers (7.352MHz, offset 63, 16bit)
(scsi0:A:0): 14.284MB/s transfers (7.142MHz, offset 63, 16bit)
(scsi0:A:0): 13.888MB/s transfers (6.944MHz, offset 63, 16bit)
(scsi0:A:0): 13.512MB/s transfers (6.756MHz, offset 63, 16bit)
(scsi0:A:0): 13.156MB/s transfers (6.578MHz, offset 63, 16bit)
(scsi0:A:0): 12.820MB/s transfers (6.410MHz, offset 63, 16bit)
(scsi0:A:0): 12.500MB/s transfers (6.250MHz, offset 63, 16bit)
(scsi0:A:0): 12.194MB/s transfers (6.097MHz, offset 63, 16bit)
(scsi0:A:0): 11.904MB/s transfers (5.952MHz, offset 63, 16bit)
(scsi0:A:0): 11.626MB/s transfers (5.813MHz, offset 63, 16bit)
(scsi0:A:0): 11.362MB/s transfers (5.681MHz, offset 63, 16bit)
(scsi0:A:0): 11.110MB/s transfers (5.555MHz, offset 63, 16bit)
(scsi0:A:0): 10.868MB/s transfers (5.434MHz, offset 63, 16bit)
(scsi0:A:0): 10.638MB/s transfers (5.319MHz, offset 63, 16bit)
(scsi0:A:0): 10.416MB/s transfers (5.208MHz, offset 63, 16bit)
(scsi0:A:0): 10.204MB/s transfers (5.102MHz, offset 63, 16bit)
(scsi0:A:0): 10.000MB/s transfers (5.000MHz, offset 63, 16bit)
(scsi0:A:0): 6.600MB/s transfers (16bit)
(scsi0:A:0): 19.230MB/s transfers (19.230MHz, offset 63)
  Vendor: IBM-ESXS  Model: ST336607LW    FN<7>Losing some ticks... checking if CPU frequency changed.
  Rev: B25H
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
mice: PS/2 mouse device common for all mice
