Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8997F1EEA51
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2025 19:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737402627; cv=none; b=DOWgnBNa86CcXRhck1Jok+PFTyCPpygcuXEUbaRAEctNhiioR63BZVj7QQGIvbFoMcJ1i13bTsvtSR21o9cJTsZIW4r4LO3XrV1RxN+Z9yuEqumZuRIHkh0DS5zdMf/uvpwtOv54tClTTtC/Cb1es4IPVA7COkaFNT2bVk9lhi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737402627; c=relaxed/simple;
	bh=KABGlaX7rMXucBqJq+MIXlqOLNLFyeYLI92Yrw0NLq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDOjuC2HLiOlw5TkK1QsQiGnMP563oO5a6IrLnJa7GTgfIYi3Hhd8K3WBvjhD18M2mp1RX2pTMGYakeTkVPuGB02tn7kbAw3tX/Ls2Vjv8GikF2HH5ghprrpJx4OHUAnHhccsJDzc5FGYJ87Id6kXqX2l+ooMBpFyv2WNYIc+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=F6Bf9wgS; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="F6Bf9wgS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=DtYdyyTFdl4qm+eN09b6vGlwUwXQ5lNR8Cz7Z4xR+JE=;
	b=F6Bf9wgSG3582uNDNDl/lJrM9AOAUSRJ6OLp9b+59J43Wq9PF2UmCNxIHkkasqbC3lsXh44+gRsCa
	 Xy4jz5oQ2WixSojiQKNbNgSHOIqyEk6c6QEpKXJ7QZpwkh8bNTbaTVE5bmyjqHbJcY6wApcXyqdFt8
	 6vTiElvajYAKtqJPiPEoE4z9aACEgsqy1FQPfvRnsGV0ExTrk4YkCKOFluSf29H+r2LWu1jMPFcHGN
	 gm+rMky85KdYKR7qNElPjhoshc1CQCUpHz3QsojmpgIQk2sN0EpZOu3kvh216NeYU2UgUeRNueasWQ
	 lh2aCDeWhj9EYrwa9n/o06Oet6wtPLQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id c3568288-d767-11ef-88a3-005056bdd08f;
	Mon, 20 Jan 2025 21:50:13 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v3 4/4] scsi: st: Add sysfs file reset_blocked
Date: Mon, 20 Jan 2025 21:49:25 +0200
Message-ID: <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
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
---
 Documentation/scsi/st.rst |  5 +++++
 drivers/scsi/st.c         | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/scsi/st.rst b/Documentation/scsi/st.rst
index d3b28c28d74c..2209f03faad3 100644
--- a/Documentation/scsi/st.rst
+++ b/Documentation/scsi/st.rst
@@ -157,6 +157,11 @@ enabled driver and mode options. The value in the file is a bit mask where the
 bit definitions are the same as those used with MTSETDRVBUFFER in setting the
 options.
 
+Each directory contains the entry 'reset_blocked'. If this value is one,
+reading and writing to the device is blocked after device reset. Most
+devices rewind the tape after reset and the writes/read don't access the
+tape position the user expects.
+
 A link named 'tape' is made from the SCSI device directory to the class
 directory corresponding to the mode 0 auto-rewind device (e.g., st0).
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6ec1cfeb92ff..e4fda0954004 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4703,6 +4703,24 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(options);
 
+/**
+ * reset_blocked_show - Value 1 indicates that reads, writes, etc. are blocked
+ * because a device reset has occurred and no operation positioning the tape
+ * has been issued.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t reset_blocked_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+	struct scsi_tape *STp = STm->tape;
+
+	return sprintf(buf, "%d", STp->pos_unknown);
+}
+static DEVICE_ATTR_RO(reset_blocked);
+
 /* Support for tape stats */
 
 /**
@@ -4887,6 +4905,7 @@ static struct attribute *st_dev_attrs[] = {
 	&dev_attr_default_density.attr,
 	&dev_attr_default_compression.attr,
 	&dev_attr_options.attr,
+	&dev_attr_reset_blocked.attr,
 	NULL,
 };
 
-- 
2.43.0

