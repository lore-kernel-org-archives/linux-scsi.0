From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: Tape device =?utf-8?b?cmVxdWVzdF9xdWV1ZQ==?= kref accounting bug causes slab corruption
Date: Sat, 15 Sep 2012 01:13:41 +0000 (UTC)
Message-ID: <loom.20120915T031005-365@post.gmane.org>
References: <loom.20120914T233602-37@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53029 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2IOBNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 21:13:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1TCgxI-00054s-Pl
	for linux-scsi@vger.kernel.org; Sat, 15 Sep 2012 03:13:56 +0200
Received: from rigel.stratus.com ([rigel.stratus.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 15 Sep 2012 03:13:56 +0200
Received: from joe.lawrence by rigel.stratus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 15 Sep 2012 03:13:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Fri, 14 Sep 2012 16:27:48 -0400
Subject: [PATCH] SCSI: st: Take additional queue ref in st_probe

The disk_release function expects that add_disk was called and that the
latter function took an extra reference to the disk queue.  The st driver
does not call add_disk, but when a tape device is torn down, the disk_type
release method disk_release is called, and we end up returning one too many
references.  Fix the kref accounting by adding a blk_get_queue to st_probe.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/st.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e41998c..e078944 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4077,6 +4077,8 @@ static int st_probe(struct device *dev)
 	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
+	if (blk_get_queue(disk->queue)) /* disk_release expects extra kref */
+		goto out_put_queue;
 	tpnt->driver = &st_template;
 	scsi_tapes[i] = tpnt;
 	dev_num = i;
@@ -4208,6 +4210,8 @@ out_free_tape:
 	scsi_tapes[dev_num] = NULL;
 	st_nr_dev--;
 	write_unlock(&st_dev_arr_lock);
+out_put_queue:
+	blk_put_queue(disk->queue);
 out_put_disk:
 	put_disk(disk);
 	kfree(tpnt);
-- 
1.7.11.4


