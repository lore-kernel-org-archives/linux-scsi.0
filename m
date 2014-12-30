From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/5] ses: generate KOBJ_CHANGE on enclosure attach
Date: Tue, 30 Dec 2014 14:46:15 -0800
Message-ID: <1419979578-3793574-3-git-send-email-songliubraving@fb.com>
References: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36907 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbaL3WsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2014 17:48:00 -0500
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id sBUMlQ44025405
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:47:59 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1rm2ww09f7-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:47:59 -0800
Received: from facebook.com (2401:db00:20:701c:face:0:3f:0)	by
 mx-out.facebook.com (10.212.236.89) with ESMTP	id
 b533290c907511e4a00f0002c95209d8-5bddb390 for <linux-scsi@vger.kernel.org>;
	Tue, 30 Dec 2014 14:46:35 -0800
In-Reply-To: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, hare@suse.de, dgilbert@interlog.com, Dan Williams <dan.j.williams@intel.com>, Song Liu <songliubraving@fb.com>

From: Dan Williams <dan.j.williams@intel.com>

In support of a /dev/disk/by-slot populated with data from the enclosure
and ses modules udev needs notification when the new interface
files/links are available.  Otherwise, any udev rules specified for the
disk cannot assume that the enclosure topology has settled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ses.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 7dd9cf5..6662b0c 100644
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

