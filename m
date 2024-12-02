Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9C21DE3D8;
	Mon,  2 Dec 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733166042; cv=none; b=jKg8bjI6VkpJantYcXMNkVh2YobrClX5rKzVmiJkv2oY8lXa4hWRhRAC4WRqI12KC7jDWhyvGI5BDRh2WSmCygxitL4Fm92OHBnqycy3X57w6plSZGbKkfZ9YvKjCCXNeLpziCxdphzaxdK4RcT0voISThZLa01vCcTSpWkluWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733166042; c=relaxed/simple;
	bh=+arb4UAMXaf51SIDs7YdZ7RZB12zGnsK5LernLVB4+0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=juEUEtmw0UpHZj9QFC54ahdIaJA2IpEO4XQqu38CqCWFVZKhqIA/n5VF318AZli0wUbjA8ZdzAzxB4RcRAPDvR3noPwmNHvDc5UH1CyvRLwCUQER2y3g0LTjCAH7ohIbKcEEY+WvwCOmdhkdJlQSoE9riWa3BQnqMOGJV6YsjVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=ThF6iULN; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="ThF6iULN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1733166037;
	bh=+arb4UAMXaf51SIDs7YdZ7RZB12zGnsK5LernLVB4+0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ThF6iULNZ7DQJIv5R4Hc+nABWuz2CXsroKR2IL96Lww5yAzqcqyOFzP2KUPsddAzL
	 6VPpbB9bQcdgMtx9kcgoMZO6ezbbY8jljpLWK+GEHv5+4v3OD9ZFn/Ho5WSfPUmpqx
	 UwDl45hT0Cmsv5u/Vj5Ui4aPXAfVpX/KxBsIVbgE=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 02 Dec 2024 20:00:39 +0100
Subject: [PATCH 4/5] firmware: google: gsmi: Use BIN_ATTR_ADMIN_WO() for
 bin_attribute definition
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241202-sysfs-const-bin_attr-admin_wo-v1-4-f489116210bf@weissschuh.net>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Tzung-Bi Shih <tzungbi@kernel.org>, Brian Norris <briannorris@chromium.org>, 
 Julius Werner <jwerner@chromium.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733166036; l=2521;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=+arb4UAMXaf51SIDs7YdZ7RZB12zGnsK5LernLVB4+0=;
 b=vs/2qmzMQ2i0kyAzZ0xLNPY2RWbz1iPcaFTdxlz5AdVN+D//QkatZ10EMOrH1vwujAOmcl20z
 TfIbn4l+sK0Cyv5rUwyZivbShgztDbnhu1XZhF5TMYQdLbZA2Ek09Ca
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

Using the macro saves some lines of code and prepares the attribute for
the general constifications of struct bin_attributes.

While at it also constify the callback parameter.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/firmware/google/gsmi.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 24e666d5c3d1a231d611ad3c20816c1d223a0dc5..cd946633ef727e826449a7b307a15a2c9f07d655 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -487,9 +487,9 @@ static const struct efivar_operations efivar_ops = {
 
 #endif /* CONFIG_EFI */
 
-static ssize_t eventlog_write(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t pos, size_t count)
+static ssize_t append_to_eventlog_write(struct file *filp, struct kobject *kobj,
+					const struct bin_attribute *bin_attr,
+					char *buf, loff_t pos, size_t count)
 {
 	struct gsmi_set_eventlog_param param = {
 		.data_ptr = gsmi_dev.data_buf->address,
@@ -528,10 +528,7 @@ static ssize_t eventlog_write(struct file *filp, struct kobject *kobj,
 
 }
 
-static struct bin_attribute eventlog_bin_attr = {
-	.attr = {.name = "append_to_eventlog", .mode = 0200},
-	.write = eventlog_write,
-};
+static const BIN_ATTR_ADMIN_WO(append_to_eventlog, 0);
 
 static ssize_t gsmi_clear_eventlog_store(struct kobject *kobj,
 					 struct kobj_attribute *attr,
@@ -1017,7 +1014,7 @@ static __init int gsmi_init(void)
 	}
 
 	/* Setup eventlog access */
-	ret = sysfs_create_bin_file(gsmi_kobj, &eventlog_bin_attr);
+	ret = sysfs_create_bin_file(gsmi_kobj, &bin_attr_append_to_eventlog);
 	if (ret) {
 		printk(KERN_INFO "gsmi: Failed to setup eventlog");
 		goto out_err;
@@ -1049,7 +1046,7 @@ static __init int gsmi_init(void)
 	return 0;
 
 out_remove_bin_file:
-	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
+	sysfs_remove_bin_file(gsmi_kobj, &bin_attr_append_to_eventlog);
 out_err:
 	kobject_put(gsmi_kobj);
 	gsmi_buf_free(gsmi_dev.param_buf);
@@ -1076,7 +1073,7 @@ static void __exit gsmi_exit(void)
 #endif
 
 	sysfs_remove_files(gsmi_kobj, gsmi_attrs);
-	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
+	sysfs_remove_bin_file(gsmi_kobj, &bin_attr_append_to_eventlog);
 	kobject_put(gsmi_kobj);
 	gsmi_buf_free(gsmi_dev.param_buf);
 	gsmi_buf_free(gsmi_dev.data_buf);

-- 
2.47.1

