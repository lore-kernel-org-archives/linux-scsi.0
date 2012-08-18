From: jeffm@suse.de (Jeff Mahoney)
Subject: [patch 0/5] st: Clean up and raise max device limit (v4)
Date: Sat, 18 Aug 2012 15:20:36 -0400
Message-ID: <20120818192036.751334179@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab2HRTVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2012 15:21:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Lee Duncan <lduncan@suse.com>, Rob Evers <revers@redhat.com>

This patchset cleans up the SCSI tape device handling code and leverages it
to lift the limitation of the number of tape drives from the previous
arbitrary limit of 128 to the maximum supported by a device node that
creates 8 character devices per physical device. Since minors are 20 bits,
that means 2^17 tape drives can be supported.

Changed in this version: A previous revision introduced a regression where
tape drives would not be shown as tape devices in lsscsi. This was due to
the missing "tape" symlink in sysfs. That issue has been addressed and
lsscsi works properly again. Also, it passes checkpatch with no errors.

Please apply.

