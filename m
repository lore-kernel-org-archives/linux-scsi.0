From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH+RFC] Cdev support for SCSI tapes, first try
Date: Sun, 9 Nov 2003 23:02:16 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0311092245530.2506@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-1680063783-1068410842=:2506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:21137 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262781AbTKIVCT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2003 16:02:19 -0500
Content-ID: <Pine.LNX.4.58.0311092247400.2506@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dougg@torque.net>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811327-1680063783-1068410842=:2506
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.58.0311092247401.2506@kai.makisara.local>

The attached patch adds support for cdevs to the st driver in 2.6.0-test9.
The changes are based on Doug Gilbert's corresponding changes to the sg
driver. Using cdevs has the following advantanges:
- support for many drives, currently the maximum is set to 128; the minor
  number assignment is explained in the patch
- the tape devices appear in /sys/cdev/major/st*, as an example here are
  the entries for the first drive (4 modes, rewind and non-rewind
  devices):
  /sys/cdev/major/st0m0   /sys/cdev/major/st0m1   /sys/cdev/major/st0m2
  /sys/cdev/major/st0m3
  /sys/cdev/major/st0m0n  /sys/cdev/major/st0m1n  /sys/cdev/major/st0m2n
  /sys/cdev/major/st0m3n

The code has been tested and seems to work. I added 40 fake drives using a
modified scsi_debug host plus one real drive. The real drive (st40) did
work properly. Inserting and removing the st module did not crash the
system. Your mileage may vary :-)

The patch does not yet add any attributes to the devices. This is planned
for a future version.

-- 
Kai
---1463811327-1680063783-1068410842=:2506
Content-Type: APPLICATION/X-GUNZIP; NAME="st260-cdev.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0311092247220.2506@kai.makisara.local>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="st260-cdev.diff.gz"

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

---1463811327-1680063783-1068410842=:2506--
