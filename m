From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ch: fix ch_remove oops
Date: Sat, 26 Jul 2008 23:25:43 +0900
Message-ID: <20080726231344U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:47402 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYGZOZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 10:25:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, gregkh@suse.de

The latest git and 2.6.26 needs this fix.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ch: fix ch_remove oops

The following commit causes ch_remove oops:

commit 24b42566c3fcbb5a9011d1446783d0f5844ccd45
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Fri May 16 17:55:12 2008 -0700

    SCSI: fix race in device_create

    There is a race from when a device is created with device_create() and
    then the drvdata is set with a call to dev_set_drvdata() in which a
    sysfs file could be open, yet the drvdata will be NULL, causing all
    sorts of bad things to happen.

    This patch fixes the problem by using the new function,
    device_create_drvdata().  It fixes the problem in all of the scsi
    drivers that need it.

    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Cc: Doug Gilbert <dgilbert@interlog.com>
    Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

The problem is ch_probe stores ch's private data at a wrong place.

We need to store it at scsi_device->sdev_gendev but the above patch
stores it at device struct that device_create_drvdata returns. So we
hit an oops when ch_remove accesses
scsi_device->sdev_gendev->driver_data, which is NULL.

Actually, there wasn't a race because ch doesn't create sysfs files
with device struct that device_create returns. This patch puts back
dev_set_drvdata() to set ch's private data properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index aa2011b..3c257fe 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -930,6 +930,7 @@ static int ch_probe(struct device *dev)
 	if (init)
 		ch_init_elem(ch);
 
+	dev_set_drvdata(dev, ch);
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
 	return 0;
-- 
1.5.4.2

