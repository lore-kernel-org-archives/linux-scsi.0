From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: pulling failover out of qla2xxx
Date: Thu, 15 Jan 2004 17:36:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E32@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:37722 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265218AbUAPBgD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 20:36:03 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>, Christoph Hellwig <hch@lst.de>

On Thursday, January 15, 2004 2:16 PM, James Bottomley wrote:

> I think the best way to maintain this is to add #ifdef
> CONFIG_SCSI_QLA2XXX_FAILOVER around all this code that was taken out
> of the main routines (so it really is compiled out when failover
> isn't defined) in your vendor tree. 
> 
> Then, to prepare kernel patches, you can run the vendor tree through
> unifdef to remove the failover code...and we can keep the
> non-failover code bases in sync. 
> 

Ok, I've uploaded a rather large patch to the SourceForge site:

	http://sourceforge.net/projects/linux-qla2xxx/

The file qla2xxx-resync_bk-v8.00.00b9.diff.bz2 available from the
download page will resync the qla2xxx driver in scsi-misc-2.7 with the
latest 8.00.00b9 release driver done yesterday -- of course, without
any FO/IOCTL pieces.

The patch weights in at a hefty 360K bzipped, where the bulk of the
diff is due to the updated ql2300_fw.c file and the three firmware
files for the newly supported ISP types (ISP2322, ISP6312, and
ISP6322).  The residuals weigh-in at ~70K of uncompressed diffs with
the core of the b8 -> b9 changes at around ~40K (the down_timeout
update mentioned below is around 30K).

Other changes include:

	o Remerge Christoph's down_timeout() update for mailbox
	  commands -- use a common and simpler variant of the down
	  with timeout scheme.  (this was appearantly dropped during
	  the bk update).

And again, the changes from 8.00.00b8 to 8.00.00b9:

	o Minimize device_id checks in register access functions
	  (IS_QLA23XX(), ISP_*_Q_*(), ...), emphasis on
	  non-ISP2[12]00 chips.
	o Add initial ISP6312/ISP6322 definitions and checks during
	  board configuration.
	o Only retrieve firmware version and resource counts if
	  we've successfully initialized the firmware.
	o Ensure the driver is logged into the SNS port before
	  performing any registrations.
	o Always use MMIO for chip register accesses.
	  - Remove MEMORY_MAPPED_IO define.
	o Address FLASH deficiencies with ISP2312 v2 chips.
	o Fix more PCI posting issues.
	o Wait for at most MAX_LOOP_TIMEOUT in
	  qla2x00_wait_for_hba_online().
	o Generalize descriptive name used for the driver
	  (i.e. QLogic ISP2xxx FC Driver --> QLogic FC Driver).
	o Remove unused debug routines (ENTER/LEAVE(), etc.).
	o Add new 2300/2322 IPX and 6312/6322 FLX firmwares (3.02.20):
	  - Remove 2300 TPX firmware from distribution.

In the future, now that we (I) have the process down and the driver is
in fact in the tree in some form, reasonbly sized patches will follow
after 8.00.00b9.

James:  I'll also pass this email onto linux-scsi.

Thanks again,
Andrew Vasquez
