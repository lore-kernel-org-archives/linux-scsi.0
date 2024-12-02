Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EADE1DE3CE;
	Mon,  2 Dec 2024 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733166041; cv=none; b=KaqqvEuJ2IF5wCdzbWYkbx3/CceceiR/P6NZyd0zYbYBmyo9vNmhGxoiqXu+xpNBiWNUMvEHMSlTuPY48tTI3ssZNZJsuyD6IiikmJ+KhXZEv3SU/o5wGIC5V2I6vpa/TLotCNdzhs41irPMiKITYCwbTEFoTd82tncsFTArzFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733166041; c=relaxed/simple;
	bh=xou28swiaoBiDmWpjvH656ao7GcdNsfrzFboEHzP1GM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LXA35x3Ei4VYmKGratFBYtWG7JAL2Gwah/mfLakQ01uQSHP+C1TJNpqlPT2XfLfMiPbMEXbgC8BlAKx0xkc3Ze/wCk5Dwq2OWjdqphuT1afojxFf/Kh8ZppN+IjBV3zZK1/+vD3LVIXxeSzaZYOZvTO1FF3c0+eJj4SoE+Yewi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=VqX26pnl; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="VqX26pnl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1733166037;
	bh=xou28swiaoBiDmWpjvH656ao7GcdNsfrzFboEHzP1GM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VqX26pnlkKD4n+vv/jNOMJWWV3ESbtROgqI/ThqvtEtZ4dhs0a0zruOYJPBUNnoyF
	 PL9lyngKcbu8L/cn+IzJbZKlApbrEiP0EgrTjmkCX0o9HdgNFxI7KFB9PRs/HlRoHa
	 xiD+Ep6fGcSkjH2TV8X9Ca69OaWAHpV45r7ymKEQ=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 02 Dec 2024 20:00:37 +0100
Subject: [PATCH 2/5] s390/sclp_config: use BIN_ATTR_ADMIN_WO() for
 bin_attribute definition
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241202-sysfs-const-bin_attr-admin_wo-v1-2-f489116210bf@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733166036; l=1812;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=xou28swiaoBiDmWpjvH656ao7GcdNsfrzFboEHzP1GM=;
 b=vfWtzqSvOITqm9SIRme74Qk53uJwokLIIK0tBYouqbxDGe+gNmhS3pAcZF3um7CX0Thy4ZYvi
 H8BDLWi3jB1Ckix9bcV5uNOkUK2JN6TmlPQN38QAc33eOmKZczOf8Yb
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

Using the macro saves some lines of code and prepares the attribute for
the general constifications of struct bin_attributes.

While at it also constify the callback parameter.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/s390/char/sclp_config.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_config.c
index f56ea9b60e08e817652a9b7d19d420e9977c6552..0fe0782ccd325c1c3907e5d6272f770477e9ea46 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -127,9 +127,9 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 	return rc;
 }
 
-static ssize_t sysfs_ofb_data_write(struct file *filp, struct kobject *kobj,
-				    struct bin_attribute *bin_attr,
-				    char *buf, loff_t off, size_t count)
+static ssize_t event_data_write(struct file *filp, struct kobject *kobj,
+				const struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	int rc;
 
@@ -137,13 +137,7 @@ static ssize_t sysfs_ofb_data_write(struct file *filp, struct kobject *kobj,
 	return rc ?: count;
 }
 
-static const struct bin_attribute ofb_bin_attr = {
-	.attr = {
-		.name = "event_data",
-		.mode = S_IWUSR,
-	},
-	.write = sysfs_ofb_data_write,
-};
+static const BIN_ATTR_ADMIN_WO(event_data, 0);
 #endif
 
 static int __init sclp_ofb_setup(void)
@@ -155,7 +149,7 @@ static int __init sclp_ofb_setup(void)
 	ofb_kset = kset_create_and_add("ofb", NULL, firmware_kobj);
 	if (!ofb_kset)
 		return -ENOMEM;
-	rc = sysfs_create_bin_file(&ofb_kset->kobj, &ofb_bin_attr);
+	rc = sysfs_create_bin_file(&ofb_kset->kobj, &bin_attr_event_data);
 	if (rc) {
 		kset_unregister(ofb_kset);
 		return rc;

-- 
2.47.1

