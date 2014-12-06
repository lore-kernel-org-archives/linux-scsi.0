From: Song Liu <songliubraving@fb.com>
Subject: [PATCH RESEND 2/5] SES: generate KOBJ_CHANGE on enclosure attach
Date: Sat, 6 Dec 2014 00:27:04 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBCC5C04@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1362 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751709AbaLFA1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 19:27:30 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>

From: Dan Williams <dan.j.williams@intel.com>

In support of a /dev/disk/by-slot populated with data from the enclosure and ses modules udev needs notification when the new interface files/links are available.  Otherwise, any udev rules specified for the disk cannot assume that the enclosure topology has settled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ses.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index c52fd98..87cf970b 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -349,7 +349,8 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 		if (scomp->addr != efd->addr)
 			continue;
 
-		enclosure_add_device(edev, i, efd->dev);
+		if (enclosure_add_device(edev, i, efd->dev) == 0)
+			kobject_uevent(&efd->dev->kobj, KOBJ_CHANGE);
 		return 1;
 	}
 	return 0;
--
1.8.1

