Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590C3204F76;
	Mon, 16 Dec 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348562; cv=none; b=u2+ZLrRvUqNSSx/4ru/UjDDkM5K2xPExKb5Fa+a1YJk8aBIpazrRam+r0p6DxoxrOZmQPJIhepLjULOx7HJqkd9iL/v79CbUFJuNn4sOIWP/X9+E3MLmXoJa4R61GGuxPWC2dJ85OuKOfx5J6vK0lGEUJ4YgovOcbeZ1KQQeAz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348562; c=relaxed/simple;
	bh=/47zmPkyqW64N/sWNZItQvBd6ybLPkBtNbUpLnt2Msc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T+HNRwPHCIQoWgjX4lIcBUNLUOPqMDKXldyDBo6MEe6TXYgG5MzX+rp4ezY1V2DMknyh4TOS2fHy0NHLTqeizy4/y9wQHnpEC5MQiO6AYvXagLTmvjc2nf5PyJ9dnOulKYb+aGCEi9DoKUUBTcJCQetja6Sg/O8c9nCEkThdzQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=RMkcaJQt; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="RMkcaJQt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348553;
	bh=/47zmPkyqW64N/sWNZItQvBd6ybLPkBtNbUpLnt2Msc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RMkcaJQt8UBr77DelZNaePGGudtkBLDC/fceGR/DYNrQruoPmfGp4X4Ih/idasJ6J
	 LiP0ReqpGtsDJ4ilq11ZC+OV9Cbpz725LuWbb6g46Hx+hov/ipO+zMCZVcF09Ux8PE
	 lJ5Ghu3SIfOUoQJLq2aoT99RDZ4Fio79eyMt9grk=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:15 +0100
Subject: [PATCH 08/11] scsi: qedf: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-8-f0a5e54b3437@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=2312;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=/47zmPkyqW64N/sWNZItQvBd6ybLPkBtNbUpLnt2Msc=;
 b=yoemaf355a7pBtjrYmusgAHSgDSHBiZ/xpsxVOY2bN+lr7orgVWt0/padwJDXbBQS6h6g2A/v
 ZfCk5GBEeFnA/CuO6ERllqvp4wf56ggfq0HQFvV9/Vx9XlOgwrjVYfl
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/qedf/qedf_attr.c | 10 +++++-----
 drivers/scsi/qedf/qedf_dbg.h  |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index 8d8c760eee435ad9018e64440837211109725ff6..769da92ee20d0fac71525a8265cb6332146585ec 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -104,7 +104,7 @@ void qedf_capture_grc_dump(struct qedf_ctx *qedf)
 
 static ssize_t
 qedf_sysfs_read_grcdump(struct file *filep, struct kobject *kobj,
-			struct bin_attribute *ba, char *buf, loff_t off,
+			const struct bin_attribute *ba, char *buf, loff_t off,
 			size_t count)
 {
 	ssize_t ret = 0;
@@ -124,7 +124,7 @@ qedf_sysfs_read_grcdump(struct file *filep, struct kobject *kobj,
 
 static ssize_t
 qedf_sysfs_write_grcdump(struct file *filep, struct kobject *kobj,
-			struct bin_attribute *ba, char *buf, loff_t off,
+			const struct bin_attribute *ba, char *buf, loff_t off,
 			size_t count)
 {
 	struct fc_lport *lport = NULL;
@@ -160,14 +160,14 @@ qedf_sysfs_write_grcdump(struct file *filep, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_grcdump_attr = {
+static const struct bin_attribute sysfs_grcdump_attr = {
 	.attr = {
 		.name = "grcdump",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 0,
-	.read = qedf_sysfs_read_grcdump,
-	.write = qedf_sysfs_write_grcdump,
+	.read_new = qedf_sysfs_read_grcdump,
+	.write_new = qedf_sysfs_write_grcdump,
 };
 
 static struct sysfs_bin_attrs bin_file_entries[] = {
diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h
index 5ec2b817c694a9846c337c88f6e9b59382dbaa1b..eeb6c841dacb1e68890420db2e5349e9ce60bc20 100644
--- a/drivers/scsi/qedf/qedf_dbg.h
+++ b/drivers/scsi/qedf/qedf_dbg.h
@@ -100,7 +100,7 @@ struct Scsi_Host;
 
 struct sysfs_bin_attrs {
 	char *name;
-	struct bin_attribute *attr;
+	const struct bin_attribute *attr;
 };
 
 extern int qedf_alloc_grc_dump_buf(uint8_t **buf, uint32_t len);

-- 
2.47.1

