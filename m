Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE66204C16;
	Mon, 16 Dec 2024 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348561; cv=none; b=McDFhcwLtgbUBbRMSQtvosHyQwetWUuwAYr/yOKXGfbI64JH0Op/11yaXmE6v9l+M/iH5uce9R8bIxb7E+v1Eg4mvXXirD0UrRST15nXP9BlgHKYpBhlAoDVB5IIFPVlT9rnM4A+SVj+JGVRz8AjILN6hSXnT+XxMw9XZR15VQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348561; c=relaxed/simple;
	bh=WaboRMSctLDNjMoiMP+WBKKWL22udYHg4PafZfmH3dE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aWU9NuP+SdCc6XES0AXn+YiDtpQpNBeMQGGXhawLOuwEYYCiTEis1rZSkrN9Cglf7XCKNp1HmtjS2mDj0i5Xcn0arTWm7zbdPG/usReQhS3qtgmX2mj/U180xrXx++KqQDKwXxfgG7HnNQpiwqK39JjAqIJqJvVlDzmoNF4h+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=sN8K+/xC; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="sN8K+/xC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348552;
	bh=WaboRMSctLDNjMoiMP+WBKKWL22udYHg4PafZfmH3dE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sN8K+/xCJ4sZCX8bmX7GVrAxYuOUqAJ6Kee5HVCDqDGMRkmSLuPh/Y6mYGSyXE0HG
	 99ljPEsa8JLb0GraBEi7Y0z46TqX2N5p5HP5IYyCVk53yWaeB9hqS5MQH/bqkzRJQg
	 NY4lfT52/XIEK7EZzNjDbZBnu/AE2ELBiJDhOqxg=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:08 +0100
Subject: [PATCH 01/11] scsi: core: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-1-f0a5e54b3437@weissschuh.net>
References: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
In-Reply-To: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Adam Radford <aradford@gmail.com>, 
 Bradley Grove <linuxdrivers@attotech.com>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, Brian King <brking@us.ibm.com>, 
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=2829;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=WaboRMSctLDNjMoiMP+WBKKWL22udYHg4PafZfmH3dE=;
 b=K189QbdH2CaN3ics6UBI9t1/D7hlarXbzYbn3lOIMhyJEb/UWOgCYM88r+iNuEVwcc/2FVc7b
 pEUwUoHctEGBLGTLnpDHiQ1gf4nRfSgOtBYhF1LFc6MprRLxTDq93bB
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/scsi_sysfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f3a1ecb42128a2b221ca5c362e041eb59dba0f20..6ad859a4ec08f5a6773bb84bf899201eed1f468f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -898,7 +898,7 @@ static DEVICE_ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 #define sdev_vpd_pg_attr(_page)						\
 static ssize_t							\
 show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
-		 struct bin_attribute *bin_attr,			\
+		 const struct bin_attribute *bin_attr,			\
 		 char *buf, loff_t off, size_t count)			\
 {									\
 	struct device *dev = kobj_to_dev(kobj);				\
@@ -914,10 +914,10 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 	rcu_read_unlock();						\
 	return ret;							\
 }									\
-static struct bin_attribute dev_attr_vpd_##_page = {		\
+static const struct bin_attribute dev_attr_vpd_##_page = {		\
 	.attr =	{.name = __stringify(vpd_##_page), .mode = S_IRUGO },	\
 	.size = 0,							\
-	.read = show_vpd_##_page,					\
+	.read_new = show_vpd_##_page,					\
 };
 
 sdev_vpd_pg_attr(pg83);
@@ -930,7 +930,7 @@ sdev_vpd_pg_attr(pgb7);
 sdev_vpd_pg_attr(pg0);
 
 static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
-			    struct bin_attribute *bin_attr,
+			    const struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
 	struct device *dev = kobj_to_dev(kobj);
@@ -943,13 +943,13 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 				       sdev->inquiry_len);
 }
 
-static struct bin_attribute dev_attr_inquiry = {
+static const struct bin_attribute dev_attr_inquiry = {
 	.attr = {
 		.name = "inquiry",
 		.mode = S_IRUGO,
 	},
 	.size = 0,
-	.read = show_inquiry,
+	.read_new = show_inquiry,
 };
 
 static ssize_t
@@ -1348,7 +1348,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	NULL
 };
 
-static struct bin_attribute *scsi_sdev_bin_attrs[] = {
+static const struct bin_attribute *const scsi_sdev_bin_attrs[] = {
 	&dev_attr_vpd_pg0,
 	&dev_attr_vpd_pg83,
 	&dev_attr_vpd_pg80,
@@ -1362,7 +1362,7 @@ static struct bin_attribute *scsi_sdev_bin_attrs[] = {
 };
 static struct attribute_group scsi_sdev_attr_group = {
 	.attrs =	scsi_sdev_attrs,
-	.bin_attrs =	scsi_sdev_bin_attrs,
+	.bin_attrs_new = scsi_sdev_bin_attrs,
 	.is_visible =	scsi_sdev_attr_is_visible,
 	.is_bin_visible = scsi_sdev_bin_attr_is_visible,
 };

-- 
2.47.1

