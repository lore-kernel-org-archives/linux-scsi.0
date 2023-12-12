Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="D3EWyeHk"
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029FAE3
	for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 12:09:40 -0800 (PST)
Received: from pop-os.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id D94JrCWy533VXD94UrOSjX; Tue, 12 Dec 2023 21:09:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1702411778;
	bh=aQv1R2UteayjqvKDNKiDv03fz9TZ0ZNa1LFJYmxEkvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3EWyeHkIvr5Rxwxb54c75yc3CvncyLDgz++8kEZWr//jY9N/UAmbOvFVlLtLSFQR
	 AJMlbZbo8qdAPtZqMd3nwc+CDY5XEOrF6w/btHMHktfCwZbS6U6vIIW5crRiPSZVqM
	 NQQyj1SPnjbVoMQnZEyIRrHWNy+2Ch/d3Eli1lbsdYI4mvFZRJlqhaQnYEN2M+RiRw
	 WvwbbjadlRlILxPXcisn1DXDKvtf2WSCxsAcWljSPps0ya62BGuBQxhhojLAgn6mkx
	 cWsF74oAkGMK7opdhx8GuIX6EVxbj8d515FxHYKDb7tWxFXlXzK0aaSChqii0XPtRC
	 l6tTDRvQHUXcQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 12 Dec 2023 21:09:38 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: hare@kernel.org,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: hare@suse.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] scsi: myrb: Use sysfs_emit()
Date: Tue, 12 Dec 2023 21:09:11 +0100
Message-Id: <d2b2a961ac595f509b09c3f88cd33cf659a8b562.1702411083.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1702411083.git.christophe.jaillet@wanadoo.fr>
References: <cover.1702411083.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to avoid hard-coded limits in _show() function, use the preferred
sysfs_emit() that knows better about it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/myrb.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index ca2380d2d6d3..06a5e6fb9f99 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1767,7 +1767,7 @@ static ssize_t raid_state_show(struct device *dev,
 	int ret;
 
 	if (!sdev->hostdata)
-		return snprintf(buf, 16, "Unknown\n");
+		return sysfs_emit(buf, "Unknown\n");
 
 	if (sdev->channel == myrb_logical_channel(sdev->host)) {
 		struct myrb_ldev_info *ldev_info = sdev->hostdata;
@@ -1775,10 +1775,10 @@ static ssize_t raid_state_show(struct device *dev,
 
 		name = myrb_devstate_name(ldev_info->state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = sysfs_emit(buf, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
-				       ldev_info->state);
+			ret = sysfs_emit(buf, "Invalid (%02X)\n",
+					 ldev_info->state);
 	} else {
 		struct myrb_pdev_state *pdev_info = sdev->hostdata;
 		unsigned short status;
@@ -1796,10 +1796,10 @@ static ssize_t raid_state_show(struct device *dev,
 		else
 			name = myrb_devstate_name(pdev_info->state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = sysfs_emit(buf, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
-				       pdev_info->state);
+			ret = sysfs_emit(buf, "Invalid (%02X)\n",
+					 pdev_info->state);
 	}
 	return ret;
 }
@@ -1886,11 +1886,11 @@ static ssize_t raid_level_show(struct device *dev,
 
 		name = myrb_raidlevel_name(ldev_info->raid_level);
 		if (!name)
-			return snprintf(buf, 32, "Invalid (%02X)\n",
-					ldev_info->state);
-		return snprintf(buf, 32, "%s\n", name);
+			return sysfs_emit(buf, "Invalid (%02X)\n",
+					  ldev_info->state);
+		return sysfs_emit(buf, "%s\n", name);
 	}
-	return snprintf(buf, 32, "Physical Drive\n");
+	return sysfs_emit(buf, "Physical Drive\n");
 }
 static DEVICE_ATTR_RO(raid_level);
 
@@ -1903,17 +1903,17 @@ static ssize_t rebuild_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < myrb_logical_channel(sdev->host))
-		return snprintf(buf, 64, "physical device - not rebuilding\n");
+		return sysfs_emit(buf, "physical device - not rebuilding\n");
 
 	status = myrb_get_rbld_progress(cb, &rbld_buf);
 
 	if (rbld_buf.ldev_num != sdev->id ||
 	    status != MYRB_STATUS_SUCCESS)
-		return snprintf(buf, 64, "not rebuilding\n");
+		return sysfs_emit(buf, "not rebuilding\n");
 
-	return snprintf(buf, 64, "rebuilding block %u of %u\n",
-			rbld_buf.ldev_size - rbld_buf.blocks_left,
-			rbld_buf.ldev_size);
+	return sysfs_emit(buf, "rebuilding block %u of %u\n",
+			  rbld_buf.ldev_size - rbld_buf.blocks_left,
+			  rbld_buf.ldev_size);
 }
 
 static ssize_t rebuild_store(struct device *dev,
@@ -2140,7 +2140,7 @@ static ssize_t ctlr_num_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct myrb_hba *cb = shost_priv(shost);
 
-	return snprintf(buf, 20, "%u\n", cb->ctlr_num);
+	return sysfs_emit(buf, "%u\n", cb->ctlr_num);
 }
 static DEVICE_ATTR_RO(ctlr_num);
 
@@ -2150,7 +2150,7 @@ static ssize_t firmware_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct myrb_hba *cb = shost_priv(shost);
 
-	return snprintf(buf, 16, "%s\n", cb->fw_version);
+	return sysfs_emit(buf, "%s\n", cb->fw_version);
 }
 static DEVICE_ATTR_RO(firmware);
 
@@ -2160,7 +2160,7 @@ static ssize_t model_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct myrb_hba *cb = shost_priv(shost);
 
-	return snprintf(buf, 16, "%s\n", cb->model_name);
+	return sysfs_emit(buf, "%s\n", cb->model_name);
 }
 static DEVICE_ATTR_RO(model);
 
-- 
2.34.1

