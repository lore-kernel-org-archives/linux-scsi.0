From: Michael Tokarev <mjt@tls.msk.ru>
Subject: why disk info gets printk'ed twice?
Date: Tue, 23 Oct 2007 01:37:28 +0400
Message-ID: <471D1818.3070509@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:22270 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXJVVpj (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2007 17:45:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

Every dmesg users provide contains double info
about identification of [scsi,ata,..] disk drives
found in the system.  Here's mine:

scsi 2:0:0:0: Direct-Access     ATA      ST3808110AS      n/a  PQ: 0 ANSI: 5
loading module sd_mod
sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 2:0:0:0: [sda] Attached SCSI disk

Why the lines beginning with "sd 2:0:0:0:" gets duplicated?
Can this be fixed somehow?

All the messages are in drivers/scsi/sd_mod.c, printed out by
functions called from within sd_revalidate_disk().  This routine
gets called from two contexts:
 sd_store_cache_type(), which is a sysfs thing, it seems, and
 sd_probe(), which gets called from .probe method of scsi_driver

So it seems to me that scsi_driver.probe() method gets called
twice for some reason...

This question has been asked several times, but I don't recall
any answers to it.

Thanks.

/mjt
