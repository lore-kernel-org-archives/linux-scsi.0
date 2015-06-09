From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 1/6] Add refcount to sas_device struct
Date: Mon, 8 Jun 2015 20:50:51 -0700
Message-ID: <1433821856-2815280-2-git-send-email-calvinowens@fb.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41711 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932288AbbFIDvm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 23:51:42 -0400
In-Reply-To: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com

These objects can be referenced concurrently throughout the driver, we
need a way to make sure threads can't delete them out from under each
other.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index caff8d1..2e7dc33 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -376,8 +376,24 @@ struct _sas_device {
 	u8	phy;
 	u8	responding;
 	u8	pfa_led_on;
+	struct kref refcount;
 };
 
+static inline void sas_device_get(struct _sas_device *s)
+{
+	kref_get(&s->refcount);
+}
+
+static inline void sas_device_free(struct kref *r)
+{
+	kfree(container_of(r, struct _sas_device, refcount));
+}
+
+static inline void sas_device_put(struct _sas_device *s)
+{
+	kref_put(&s->refcount, sas_device_free);
+}
+
 /**
  * struct _raid_device - raid volume link list
  * @list: sas device list
-- 
1.8.1

