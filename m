Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE08204C15;
	Mon, 16 Dec 2024 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348561; cv=none; b=mslTR6oRSvbhsOuqwCx3Xm99xXAY7FLY0XLpROuIPSfRy3knchxfVCONj5uyWWO0cZKALy90uNm2zx0MFGZv8yXg4oJUQgSVrGQ+Rnp1WkmGlW6x5z3bgatiWrDgf+pbSTHwODdouMiiYi+KcPYlD/anokFjTwTfNB69VozTh6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348561; c=relaxed/simple;
	bh=oitZ6tqthOyv84s9N34Rb9nzMVcAd+9eCJs7DMuMPZg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sj0J8+/dj6QKxzkE2B5AW+Z621o+MHNE7CBD8NDUp8FF/Xh9TIMyToind1NissIjiWINAlfaVECIwnn0ogfMY3yzROmV6dskv/LsxeF64LR5uunZOtu0AOwgM5i+cdNjQpmLFDhdeydVb+0+tGv2E9zfTnElDEoWm8j5E8/x2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=Q1eyXdHb; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="Q1eyXdHb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348552;
	bh=oitZ6tqthOyv84s9N34Rb9nzMVcAd+9eCJs7DMuMPZg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q1eyXdHbyag9KhzRNNgo9E8H9QL8KBm0VJ3bBuTYmu/Q8ID2LdEs7F82M+oAGmL0f
	 hFS3ewEZkIiO22+WG30C4OWIEuIknRZphCNvM1N8nsB04lCaZxqliKvhBLxrIsnnGK
	 yEdF8dh4FKu2rUj1XByTCI+l4AHJ0pzX80nSFnSk=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:09 +0100
Subject: [PATCH 02/11] scsi: 3w-sas: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-2-f0a5e54b3437@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=2354;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=oitZ6tqthOyv84s9N34Rb9nzMVcAd+9eCJs7DMuMPZg=;
 b=sacDHXbh5wtVuj4CIy4c8lPoMwYfRqbvW7o53sDn3Rl8gYBj1PngcDtMJ7orcye3Msm+5Yd3Y
 i5icvP0is0qAVyMZ0QA3a+yvatFzrL5ioZHW6iyicE3OkmniylWhmUR
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/3w-sas.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index caa6713a62a44a72c7cfa5128c01fe54788cf708..6b2b02f89490aeb0494f3b586c9df995ec05a158 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -96,7 +96,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 
 /* This function returns AENs through sysfs */
 static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
+				  const struct bin_attribute *bin_attr,
 				  char *outbuf, loff_t offset, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -116,18 +116,18 @@ static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
 } /* End twl_sysfs_aen_read() */
 
 /* aen_read sysfs attribute initializer */
-static struct bin_attribute twl_sysfs_aen_read_attr = {
+static const struct bin_attribute twl_sysfs_aen_read_attr = {
 	.attr = {
 		.name = "3ware_aen_read",
 		.mode = S_IRUSR,
 	},
 	.size = 0,
-	.read = twl_sysfs_aen_read
+	.read_new = twl_sysfs_aen_read
 };
 
 /* This function returns driver compatibility info through sysfs */
 static ssize_t twl_sysfs_compat_info(struct file *filp, struct kobject *kobj,
-				     struct bin_attribute *bin_attr,
+				     const struct bin_attribute *bin_attr,
 				     char *outbuf, loff_t offset, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -147,13 +147,13 @@ static ssize_t twl_sysfs_compat_info(struct file *filp, struct kobject *kobj,
 } /* End twl_sysfs_compat_info() */
 
 /* compat_info sysfs attribute initializer */
-static struct bin_attribute twl_sysfs_compat_info_attr = {
+static const struct bin_attribute twl_sysfs_compat_info_attr = {
 	.attr = {
 		.name = "3ware_compat_info",
 		.mode = S_IRUSR,
 	},
 	.size = 0,
-	.read = twl_sysfs_compat_info
+	.read_new = twl_sysfs_compat_info
 };
 
 /* Show some statistics about the card */

-- 
2.47.1

