Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90821BBBE0
	for <linux-scsi@vger.kernel.org>; Sat,  1 Feb 2025 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738422688; cv=none; b=n/vQDO08nBt6ydc1Yq63HEDcpaRLHi4NvygCXFY3C0C1XcY4bItS8iGf/tGBZgm8T7YhPbWUf9mQJCbJhkQxna6JKHj8EoXzVpxPS64IfMysX+ZD4uR5TJARmNyR1T12TGNe5AToQGgjiBJl/U8n/cwBAHsmDfTjvlIk5jsV1mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738422688; c=relaxed/simple;
	bh=qTQEbJixtpnKS+er6RSuKUaN35yk13YrhgZT57AKMWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OvYwOo6q9z/2ysLrwVzRJk/kt4DQDrPRlOEKuTdpbNZEKdXbuQLGH2uoR7tcdb5k30lGFHT5VVStpWmSdsjJYgjebRAZNpn8ay1VkQvLiMSF8Kd3wM4SRLD9Oe5tMrPZjjEbDfOLlMIyg7NuYwTjr1G8aAmYLet68xgW/zb3A80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=BW4bUGgQ; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="BW4bUGgQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=vpfjphiWLtO3xDqeS0NGaZnf4ctCqxO2i/pvC0IrGvQ=;
	b=BW4bUGgQ2X/MpPuv0kKdIP/zabFjmxHo5UPW0rFQyax8pV5ZRsLdT5/gCOjAbpSFvRHcmPePiTZ+z
	 905mPtsrmadbSrzArsoD/0vTax7erBI1lTe4Ot2n+1oyE1Tu9ktGieV+ctckIsxIUTAtqP4dxQEkqN
	 5VmVXh3vSCaqd6wneeenHaOEmKwsNRGj0wyTiV0wGYMjwi2D55NFQ9FhwUl2rYQs3r6tOJsymZlzrX
	 n5cXbbrL9PvxKnB8et4enGtatCm9Al/5Q2iHEjTxpnLo5SaYtBRIeN6o+z+jfos4E8a8r+A5I/WQqZ
	 BQWA4WIRRiCqaeK13NDjvRnE3ImEzIQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id c4bbc84c-e0ae-11ef-a26c-005056bdfda7;
	Sat, 01 Feb 2025 17:11:15 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v3b 4/4] scsi: st: Add sysfs file position_lost_in_reset
Date: Sat,  1 Feb 2025 17:11:06 +0200
Message-ID: <20250201151106.25529-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
References: <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the value read from the file is 1, reads and writes from/to the
device are blocked because the tape position may not match user's
expectation (tape rewound after device reset).

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
---

Changed in v3b:
- sysfs file name has been changed to position_lost_in_reset

---
 Documentation/scsi/st.rst |  5 +++++
 drivers/scsi/st.c         | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/scsi/st.rst b/Documentation/scsi/st.rst
index d3b28c28d74c..b4a092faa9c8 100644
--- a/Documentation/scsi/st.rst
+++ b/Documentation/scsi/st.rst
@@ -157,6 +157,11 @@ enabled driver and mode options. The value in the file is a bit mask where the
 bit definitions are the same as those used with MTSETDRVBUFFER in setting the
 options.
 
+Each directory contains the entry 'position_lost_in_reset'. If this value is
+one, reading and writing to the device is blocked after device reset. Most
+devices rewind the tape after reset and the writes/read don't access the
+tape position the user expects.
+
 A link named 'tape' is made from the SCSI device directory to the class
 directory corresponding to the mode 0 auto-rewind device (e.g., st0).
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6ec1cfeb92ff..85867120c8a9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4703,6 +4703,24 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(options);
 
+/**
+ * position_lost_in_reset_show - Value 1 indicates that reads, writes, etc.
+ * are blocked because a device reset has occurred and no operation positioning
+ * the tape has been issued.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t position_lost_in_reset_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+	struct scsi_tape *STp = STm->tape;
+
+	return sprintf(buf, "%d", STp->pos_unknown);
+}
+static DEVICE_ATTR_RO(position_lost_in_reset);
+
 /* Support for tape stats */
 
 /**
@@ -4887,6 +4905,7 @@ static struct attribute *st_dev_attrs[] = {
 	&dev_attr_default_density.attr,
 	&dev_attr_default_compression.attr,
 	&dev_attr_options.attr,
+	&dev_attr_position_lost_in_reset.attr,
 	NULL,
 };
 
-- 
2.43.0

