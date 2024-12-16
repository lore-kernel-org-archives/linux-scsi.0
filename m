Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77068204563;
	Mon, 16 Dec 2024 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348558; cv=none; b=aY/FQct6UISWz5Y9qSetNVAqGxjXKRi6+YO4p2KSm5OyI6Vo9W8FjGFDXPnNTajeq4iW+3C6hE5tUNZ8i+D+hQ4STGSvgAuxyIduOB0Nxm8DGeeDjpLMmYty1i3vRcPRgwBGq+D+4q0FetvcPYf5d37IgyeddJz5SJ6+q/84w1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348558; c=relaxed/simple;
	bh=J7r5Ti/saHXCrjrJTNrPH1+HHellTzKNGzEhEZF4B/8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HLxWvQ2E9E6P1bBF8GTfqc/KGQefBSgkLQ1DrCHEWnGMBXwRVR4C6EfS/GJlLC8xBw6S02YRyul3j0NvwIPTM2MyGUvCKVRq5yEGIiKUHGbYSlsTQKrv7ch5bn6PiZh64uRiw7ZNDFmnfZ+gg3mzrKhnrJcYG2S3mtXWiwwbPE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=ezXrjNfZ; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="ezXrjNfZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348553;
	bh=J7r5Ti/saHXCrjrJTNrPH1+HHellTzKNGzEhEZF4B/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ezXrjNfZeyrhOmlE3jk3YbSVQVNKRizh3lAJnus8DGuzlcE6RzSC9JrFiNokNSuSP
	 wIBV4gL6Q45L788RVY2O7GqGFjFTWkITpIaVHI+0VmeSW7l5YPySAMxz2NJu2I7V4L
	 p6DY+Vi09CFaP0/3fFBrYHt+c3R4Ts/EgUT22Lls=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:14 +0100
Subject: [PATCH 07/11] scsi: ipr: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-7-f0a5e54b3437@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=3842;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=J7r5Ti/saHXCrjrJTNrPH1+HHellTzKNGzEhEZF4B/8=;
 b=ikn/d3a4NvnzIoHDX3GVT/kqTj/u6jpmFIMnON6Q5cPNcZXzDO6bWCS+3GkoABkAbnZG8P+BJ
 LPuxqooaZ6uAHRElQg2VVKnnE/PybWFkgTefSC+utZqJHkMb2J4lr7F
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/ipr.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 31cf2d31cceba090859c15f72f85fe7ca1698a55..db19888c5351a27d7560192339d2b9b533101e58 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3366,7 +3366,7 @@ static void ipr_worker_thread(struct work_struct *work)
  *	number of bytes printed to buffer
  **/
 static ssize_t ipr_read_trace(struct file *filp, struct kobject *kobj,
-			      struct bin_attribute *bin_attr,
+			      const struct bin_attribute *bin_attr,
 			      char *buf, loff_t off, size_t count)
 {
 	struct device *dev = kobj_to_dev(kobj);
@@ -3383,13 +3383,13 @@ static ssize_t ipr_read_trace(struct file *filp, struct kobject *kobj,
 	return ret;
 }
 
-static struct bin_attribute ipr_trace_attr = {
+static const struct bin_attribute ipr_trace_attr = {
 	.attr =	{
 		.name = "trace",
 		.mode = S_IRUGO,
 	},
 	.size = 0,
-	.read = ipr_read_trace,
+	.read_new = ipr_read_trace,
 };
 #endif
 
@@ -4087,7 +4087,7 @@ static struct device_attribute ipr_ioa_fw_type_attr = {
 };
 
 static ssize_t ipr_read_async_err_log(struct file *filep, struct kobject *kobj,
-				struct bin_attribute *bin_attr, char *buf,
+				const struct bin_attribute *bin_attr, char *buf,
 				loff_t off, size_t count)
 {
 	struct device *cdev = kobj_to_dev(kobj);
@@ -4111,7 +4111,7 @@ static ssize_t ipr_read_async_err_log(struct file *filep, struct kobject *kobj,
 }
 
 static ssize_t ipr_next_async_err_log(struct file *filep, struct kobject *kobj,
-				struct bin_attribute *bin_attr, char *buf,
+				const struct bin_attribute *bin_attr, char *buf,
 				loff_t off, size_t count)
 {
 	struct device *cdev = kobj_to_dev(kobj);
@@ -4134,14 +4134,14 @@ static ssize_t ipr_next_async_err_log(struct file *filep, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute ipr_ioa_async_err_log = {
+static const struct bin_attribute ipr_ioa_async_err_log = {
 	.attr = {
 		.name =		"async_err_log",
 		.mode =		S_IRUGO | S_IWUSR,
 	},
 	.size = 0,
-	.read = ipr_read_async_err_log,
-	.write = ipr_next_async_err_log
+	.read_new = ipr_read_async_err_log,
+	.write_new = ipr_next_async_err_log
 };
 
 static struct attribute *ipr_ioa_attrs[] = {
@@ -4172,7 +4172,7 @@ ATTRIBUTE_GROUPS(ipr_ioa);
  *	number of bytes printed to buffer
  **/
 static ssize_t ipr_read_dump(struct file *filp, struct kobject *kobj,
-			     struct bin_attribute *bin_attr,
+			     const struct bin_attribute *bin_attr,
 			     char *buf, loff_t off, size_t count)
 {
 	struct device *cdev = kobj_to_dev(kobj);
@@ -4361,7 +4361,7 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
  *	number of bytes printed to buffer
  **/
 static ssize_t ipr_write_dump(struct file *filp, struct kobject *kobj,
-			      struct bin_attribute *bin_attr,
+			      const struct bin_attribute *bin_attr,
 			      char *buf, loff_t off, size_t count)
 {
 	struct device *cdev = kobj_to_dev(kobj);
@@ -4385,14 +4385,14 @@ static ssize_t ipr_write_dump(struct file *filp, struct kobject *kobj,
 		return count;
 }
 
-static struct bin_attribute ipr_dump_attr = {
+static const struct bin_attribute ipr_dump_attr = {
 	.attr =	{
 		.name = "dump",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 0,
-	.read = ipr_read_dump,
-	.write = ipr_write_dump
+	.read_new = ipr_read_dump,
+	.write_new = ipr_write_dump
 };
 #else
 static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg) { return 0; };

-- 
2.47.1

