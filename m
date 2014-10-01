From: Hans de Goede <hdegoede@redhat.com>
Subject: uas breakage when using scsi_mod.blk_mq=Y
Date: Wed, 01 Oct 2014 10:17:41 +0200
Message-ID: <542BB8A5.4000308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaJAISH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 04:18:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

Hi Christoph,

Douglas Gilbert (in the CC), has been testing uas with
scsi_mod.blk_mq=Y and this fails. When it fails the following
messages appear in dmesg:

kernel: scsi host8: uas
kernel: blk-mq: reduced tag depth to 10240
mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:14.0/usb2/2-1"
mtp-probe: bus: 2, device: 3 was not an MTP device
kernel: scsi 8:0:0:0: Direct-Access     INTEL SS DSA2M080G2GC     2CV1 PQ: 0 ANSI: 6
kernel: sd 8:0:0:0: [sdb] 156301484 512-byte logical blocks: (80.0 GB/74.5 GiB)
kernel: sd 8:0:0:0: Attached scsi generic sg1 type 0
kernel: sd 8:0:0:0: [sdb] Write Protect is off
kernel: sd 8:0:0:0: [sdb] Mode Sense: 31 00 00 00
kernel: sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kernel: sdb: sdb1 sdb2
kernel: sd 8:0:0:0: [sdb] Attached SCSI disk
kernel: xhci_hcd 0000:00:14.0: WARN: Slot ID 8, ep index 14 has stream IDs 1 to 32 allocated, but stream ID 33 is requested.
kernel: sd 8:0:0:0: [sdb] sense submit err -22 tag 33 inflight: s-st a-in s-in a-cmd s-cmd
kernel: sd 8:0:0:0: [sdb] CDB:
kernel: Read(10): 28 00 00 00 01 6c 00 00 04 00

The problematic part here, which I believe is caused by scsi_mod.blk_mq=Y,
is the tag number 33. uas.c does the following in slave_configure:

	scsi_activate_tcq(sdev, devinfo->qdepth - 2);

Where qdepth is 32, so 30 gets passed in. uas.c stranslates scsi tags
to uas stream ids, which means it adds 2 (stream ids start at 1 not 0,
and 1 is reserved for untagged commands).

So the tag 33 above, means that the scsi subsys has called uas.c with
a tagged command with a tag of 31, which should not happen when using
scsi_activate_tcq(sdev, 30).

So should the uas.c code do something different with blk-mq to tell
it to only use tags 0-29, or is this a blk-mq bug ?

Regards,

Hans
