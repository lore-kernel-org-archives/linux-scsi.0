From: Doug Ledford <dledford@redhat.com>
Subject: Failure to reread partition tables on non-busy devices
Date: Sun, 17 Nov 2002 19:05:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021118000505.GM3280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch (almost certainly wrong BTW) makes it work.  Obviously, 
somewhere there should be a call to invalidate_bdev(); that doesn't exist.  
I'm not sure A) where that call should be and B) what checks there should 
be to avoid calling invalidate_bdev() on a device that is busy.

fs/partitions/check.c:  1.85 1.86 dledford 02/11/17 17:22:37 (modified, 
needs delta)

@@ -453,8 +453,8 @@ int rescan_partitions()
 	struct parsed_partitions *state;
 	int p, res;
 
-	if (!bdev->bd_invalidated)
-		return 0;
+	//if (!bdev->bd_invalidated)
+	//	return 0;
 	if (bdev->bd_part_count)
 		return -EBUSY;
 	res = invalidate_device(dev, 1);

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
