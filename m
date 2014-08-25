From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/5] SES: generate KOBJ_CHANGE on enclosure attach
Date: Mon, 25 Aug 2014 17:34:39 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABB7@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
 <1408987546-2418-3-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15536 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307AbaHYRep convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 13:34:45 -0400
In-Reply-To: <1408987546-2418-3-git-send-email-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>

From: Song Liu [mailto:songliubraving@fb.com] 
Sent: Monday, August 25, 2014 10:26 AM
To: Song Liu
Cc: Dan Williams; Hannes Reinecke
Subject: [PATCH 2/5] SES: generate KOBJ_CHANGE on enclosure attach

From: Dan Williams <dan.j.williams@intel.com>

In support of a /dev/disk/by-slot populated with data from the enclosure and ses modules udev needs notification when the new interface files/links are available.  Otherwise, any udev rules specified for the disk cannot assume that the enclosure topology has settled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ses.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index c2e8a98..8f0a62a 100644
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

