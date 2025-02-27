Received: from out30-76.freemail.mail.aliyun.com (out30-76.freemail.mail.aliyun.com [115.124.30.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270A7215769;
	Thu, 27 Feb 2025 06:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740636387; cv=none; b=IHYoVDOesYBJpttGDmq/RG7bqOwGVwwIxzZoIogt1ZEz3Ovtr9lcPS3w0WXsXJF+0ZS/mQQXmoVNlHh9mOWXDQPyRXNC/URNUrRpzghxqSly9wi6o9PP2HxBjHrp6Ew7YMia9n5JJYFe6fCp8EZy5uCSxQBVNb0bGwCs7DYXmTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740636387; c=relaxed/simple;
	bh=MRDaPLCqZz95pHvDjZTzsqL7skQhQQBnkKOkskKMigU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zx4/mUtpo19t3SWu3h1Uk99AdVQfV4QGUzcGazdZaQVhfespZfr3okHsJIlLiR1/h01PAwFAVaWguT0XJgD52OfuVNaCHt8JnRvQgjFVoIxYLVjG+TFjaufrDtJcXmCvdhGtv69cT0KrAB8jzTN1ToMRMsqFC5vwj8nuDDqMLbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=dEOnEDcC; arc=none smtp.client-ip=115.124.30.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="dEOnEDcC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1740636381; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=tsjJ1CUgso9hgCs6BQlR7A1A6pYF1IZyhdH9Cs3s5fY=;
	b=dEOnEDcCR2z/twUDXAgGdvj1dg1sPJydEcJm8y/oSJzXwxwlPQJ3uHQSgAkhzKk3Ye7WHeExawOvkEhFWqXAO897sz9n72pkfJUyW6EweMaNcur9+CGPx9L48o6l0FGwe/KHyKkaK0txJkrbKDrXaTAtxUssGszrIARQ7yWoi4k=
Received: from wdhh6.sugon.cn(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WQL9Ff7_1740636380 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Feb 2025 14:06:20 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH v2] scsi: stop judging after finding a VPD page expected to be processed.
Date: Thu, 27 Feb 2025 14:06:18 +0800
Message-Id: <20250227060618.15787-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the vpd_buf->data[i] is expected to be processed, stop other
judgments.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
v1: https://lore.kernel.org/all/20250226065802.234144-1-wdhh6@aliyun.com/
v1->v2:
 * Modify this function so that there is no code duplication
---
---
 drivers/scsi/scsi.c        | 39 +++++++++++++++++++++-----------------
 include/scsi/scsi_device.h | 12 ++++++++++++
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a77e0499b738..e840616d4deb 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -498,8 +498,18 @@ static void scsi_update_vpd_page(struct scsi_device *sdev, u8 page,
  */
 void scsi_attach_vpd(struct scsi_device *sdev)
 {
-	int i;
+	int i, j;
 	struct scsi_vpd *vpd_buf;
+	static const struct vpd_page_info cached_page[] = {
+		VPD_PAGE_INFO(0),
+		VPD_PAGE_INFO(80),
+		VPD_PAGE_INFO(83),
+		VPD_PAGE_INFO(89),
+		VPD_PAGE_INFO(b0),
+		VPD_PAGE_INFO(b1),
+		VPD_PAGE_INFO(b2),
+		VPD_PAGE_INFO(b7),
+	};
 
 	if (!scsi_device_supports_vpd(sdev))
 		return;
@@ -510,22 +520,17 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 		return;
 
 	for (i = 4; i < vpd_buf->len; i++) {
-		if (vpd_buf->data[i] == 0x0)
-			scsi_update_vpd_page(sdev, 0x0, &sdev->vpd_pg0);
-		if (vpd_buf->data[i] == 0x80)
-			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
-		if (vpd_buf->data[i] == 0x83)
-			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
-		if (vpd_buf->data[i] == 0x89)
-			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
-		if (vpd_buf->data[i] == 0xb0)
-			scsi_update_vpd_page(sdev, 0xb0, &sdev->vpd_pgb0);
-		if (vpd_buf->data[i] == 0xb1)
-			scsi_update_vpd_page(sdev, 0xb1, &sdev->vpd_pgb1);
-		if (vpd_buf->data[i] == 0xb2)
-			scsi_update_vpd_page(sdev, 0xb2, &sdev->vpd_pgb2);
-		if (vpd_buf->data[i] == 0xb7)
-			scsi_update_vpd_page(sdev, 0xb7, &sdev->vpd_pgb7);
+		for (j = 0; j < ARRAY_SIZE(cached_page); j++) {
+			const u8 page_code = cached_page[j].page_code;
+			const u16 offset = cached_page[j].offset;
+			struct scsi_vpd __rcu **vpd_data =
+				(void *)&sdev + offset;
+
+			if (vpd_buf->data[i] == page_code) {
+				scsi_update_vpd_page(sdev, page_code, vpd_data);
+				break;
+			}
+		}
 	}
 	kfree(vpd_buf);
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7acd0ec82bb0..46f17875b758 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -284,6 +284,18 @@ struct scsi_device {
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
+struct vpd_page_info {
+	u8 page_code;
+	u16 offset; /* offset in struct scsi_device of vpd_pg... member */
+};
+
+#define SCSI_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) - sizeof(char))
+
+#define VPD_PAGE_INFO(vpd_page)							\
+	{ 0x##vpd_page, offsetof(struct scsi_device, vpd_pg##vpd_page) + \
+		SCSI_BUILD_BUG_ON(!__same_type(&((struct scsi_device *)NULL)->vpd_pg##vpd_page, \
+				struct scsi_vpd __rcu **))} \
+
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
-- 
2.34.1

