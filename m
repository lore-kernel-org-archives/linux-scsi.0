Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C151246AA6B
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 13:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785851998; cv=none; b=YWoKjNzqPAVfhVf4b7Ymmlg6kBlfqrsGyFiDsR4Hn06oz5oO32LGThbra+ZzDisfPz69oXkX1COzW8H/+QHYv8lo1ly11CWRVuzPhAjs9W8EqZdIn3rMZatILzHUpDv8+1wjmPgHy7mGeURCM7RB2U/tAV0Ljd4ptzbmFRek9Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785851998; c=relaxed/simple;
	bh=RsDBi8475TpIHQjUtUBpRHh5ONEgHfnupLzp2MTRyGw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RGHNrxfBFwrfQMb/hd9jBirTAvceFwZfnw3+D9gvWmX7KWgVhhhH6q9LeIJI0eETzOOUj0fE1b6gjsPfzk5jTwre1strKD9Tje+8I5qTC0WoIwyElkVQQhbGZVXMVKJl6Q9a9gDb1o0Luyzy+/L73Y9EzebUlgANBhgwDLBe39s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Za1jkuCh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Za1jkuCh"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso28495415e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 06:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785851995; x=1786456795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rct+zRFkfhaiayckwn1MyC9PfAByz7KiBh2UElUWcVU=;
        b=Za1jkuChtL/OxIVAjzCIZj4CBGVEs84n5rlPnxfyu3OzzQk3Z1sc1Nd/BGdfKbvVLL
         FJ6giuUvX/1h8d0oXLi/9QnisK4039izkb+w6Ijq4YbnDgCExr/pWCMOGtzqLSWaMfzw
         OG4sWNAH8JvYvsZP8ggO8cyu0fyF13CIDVh7dgsn5V/hvQvvJTysWYuSXKULFG1cxJyE
         OG+BxsIJKn/3pAZVhHDZkXat0yYJ0aoIi5l7qswwunKnR0rKEwBpG3d3j/xBJOL6mtCH
         oejXwrZP7nCurnRwdpdjIp2Nxw5NBBBFauBXvT32Od1Pwr4/bz0wngT4XFvjwGW4CNQT
         J2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785851995; x=1786456795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rct+zRFkfhaiayckwn1MyC9PfAByz7KiBh2UElUWcVU=;
        b=NEgR6AsLigd1xSXt/HG4znQQtt+kaGd2fs7Kfsa5TFjUz8CRVZCirGYENljtU0VDyt
         /BkyVVxPm8e+z0j+27yTnlc3suHdarSMep4mSzxGNBMQqSJy3QJgEfo2bIQ6/hOxdhEi
         OBqwiJuuXLSxuPb9l4A4IR69kvLlsysjYozbNdz73s2mSq0gx23pFtOHKx6VdZiNLXKI
         VGg/bJnV88tIeL8xFN9shBIHEwJEa2uvnVXtL89LV8RL3/E45+KZyrZzYefHk0p2tj+e
         I5S9wzJQdR7RnaOYHEga9QvbGpIgjFZj+rmD5Hopo4HCuc4ZWCobGO8uNazD27Vyt6KQ
         N6nw==
X-Gm-Message-State: AOJu0YyiHhfdISHQ93JgHwMVJGQs+fZt0dWjAjvQEyxgn9WlEEkQh+IH
	Y4V4iVLwwOhdvmTmOZG7XQ+Ug9YBJjLR/Ze7YER9HMr4xEftqxeZhN2Uj4WPpl3a/K7NKA==
X-Gm-Gg: AR+sD11oLCQSRGBX5JtjlvCvTIOkXFadQirBx5Suf5pobk3sk7vOf0FwZ8VV4j/wqGQ
	Wini9MMc9WNUfCuY6ArX8uoDvSCFP+DvYhkoxTUiLjUdulnTsxUkzD+m1FeZKjUBfe+2YOz2tHm
	m2B/Vhliwn0bSE/DWfjdorGwphwrP3NwSkYZs5QQIffdXl43Zmq1t/AaMkfDp+QJwz4zq9jFWwJ
	fqPqWw7qxDeAH81MiqvMcZdUcdBN5AMMlKb/zr84O3TbbzmBPNBfZMuM4BgwZqIdPOFChJ62c1s
	sXJELCWty+s7RrM777oOnIXd1Qi9xm1xtVhBOl+ah8UrNgJFYHQdK8U2y+sobGVdYMiyg7Mo01p
	C/UbtZ6Xwu7MTdKWYsU8E9n0Z6GGSC3E1pxgctH9pHoOxwQbCJB1/ZNNlGCKwMOZUXwcJ7gg0z1
	VAfGzJYDOmdbDjNuno+tdSWAQau0mfbJ/8qIVuVVA1WsQf6CNhup9r4UreISYfrEMiLt4je0XDe
	fyZpKnUfGC9Jhj7
X-Received: by 2002:a05:600c:c170:b0:495:4749:16a7 with SMTP id 5b1f17b1804b1-4980c673ca5mr396870185e9.14.1785851994797;
        Tue, 04 Aug 2026 06:59:54 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd4562667sm46160927f8f.24.2026.08.04.06.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:59:54 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	regressions@lists.linux.dev,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: use DevicePage0 link rate only for direct-attached targets
Date: Tue,  4 Aug 2026 16:59:29 +0300
Message-ID: <20260804135929.3962-1-khomyakovilya@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes a regression in the Broadcom MPI3 Storage Controller
driver under drivers/scsi/mpi3mr/.

Commit c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from
DevicePage0") changed mpi3mr to prefer the cached DevicePage0 rate.

DevicePage0 stores negotiated_link_rate as one standalone MPI3 SAS
link-rate code, while SAS PHY Page 0 and SAS Expander Page 1 store logical
and physical rates as two nibbles of one packed byte.

mpi3mr_get_sas_negotiated_logical_linkrate() currently sends both formats
through the same high-nibble extraction at its common exit. A valid
DevicePage0 value of 0x0b or 0x0c is therefore converted to zero. The later
minimum-rate safeguard then publishes the value as 1.5 Gbit/s.

For example:

  DevicePage0 value:            0x0b
  packed-field extraction:      (0x0b & 0xf0) >> 4 = 0x00
  minimum-rate substitution:    0x00 -> 0x08
  Linux SAS transport result:   1.5 Gbit/s

There is also a topology distinction. The caller uses the returned value to
update the parent sas_phy. In an expander topology with the HBA-to-expander
link limited to 12 Gbit/s, DevicePage0 reported 0x0b for every tested
target, while Expander Page 1 reported 0xcc for several disk-facing PHYs
that were operating at 22.5 Gbit/s. The cached target value therefore
cannot unconditionally replace the local parent expander PHY value.

The original failure was reproduced on an eHBA 9600 controller with a
SAS4016 IOC and a 46-PHY Microchip expander. Before the fix, a target with
DevicePage0 negotiated_link_rate 0x0b could remain visible in sysfs as
1.5 Gbit/s when a replayed topology event contained current=0x0b and
previous=0x0b and therefore skipped the Linux-side update.

Validate the standalone DevicePage0 code and use it directly only for a
directly attached target. For an expander-attached target, retain the
existing Expander Page 1 path because it describes the local parent
expander PHY being updated. Retain the SAS PHY Page 0 fallback when a
directly attached cached value is invalid.

The topology-aware variant was tested in an out-of-tree mpi3mr 8.17.1.0.0
build. After boot, Linux reported:

  PHY 18: 12.0 Gbit/s
  PHY 19: 12.0 Gbit/s
  PHY 24: 22.5 Gbit/s
  PHY 25: 22.5 Gbit/s
  PHY 26: 22.5 Gbit/s
  PHY 27: 22.5 Gbit/s
  PHY 28: 12.0 Gbit/s
  PHY 30: 22.5 Gbit/s

No tested PHY was incorrectly reported as 1.5 Gbit/s, and the 22.5 Gbit/s
disk-facing rates were preserved even though DevicePage0 contained 0x0b.

Fixes: c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from DevicePage0")
Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>

---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 46 ++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a..740fccc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -587,6 +587,30 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
 	return rc;
 }
 
+/**
+ * mpi3mr_sas_link_rate_valid - validate a standalone SAS link-rate code
+ * @link_rate: MPI3 standalone SAS negotiated link-rate code
+ *
+ * DevicePage0 stores one plain negotiated link-rate code. Accept only
+ * negotiated data rates supported by the SAS transport conversion code;
+ * reserved or transitional values must use the existing PHY-page path.
+ *
+ * Return: true for a supported negotiated data rate, false otherwise.
+ */
+static bool mpi3mr_sas_link_rate_valid(u8 link_rate)
+{
+	switch (link_rate) {
+	case MPI3_SAS_NEG_LINK_RATE_1_5:
+	case MPI3_SAS_NEG_LINK_RATE_3_0:
+	case MPI3_SAS_NEG_LINK_RATE_6_0:
+	case MPI3_SAS_NEG_LINK_RATE_12_0:
+	case MPI3_SAS_NEG_LINK_RATE_22_5:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * mpi3mr_delete_sas_phy - Remove a single phy from port
  * @mrioc: Adapter instance reference
@@ -2292,18 +2316,26 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev)
 {
-	u8 link_rate = MPI3_SAS_NEG_LINK_RATE_1_5, phy_number;
+	u8 cached_link_rate, link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+	u8 phy_number;
 	struct mpi3_sas_expander_page1 expander_pg1;
 	struct mpi3_sas_phy_page0 phy_pg0;
 	u32 phynum_handle;
 	u16 ioc_status;
 
-	/* First, try to use link rate from DevicePage0 (populated by firmware) */
-	if (tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate >=
-	    MPI3_SAS_NEG_LINK_RATE_1_5) {
-		link_rate = tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
-		goto out;
-	}
+	cached_link_rate =
+		tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
+
+	/*
+	 * For a directly attached target, DevicePage0 and the parent host PHY
+	 * describe the same link, so the standalone cached code can be used
+	 * without packed-field decoding. For an expander-attached target, the
+	 * caller updates the parent expander PHY and DevicePage0 can differ from
+	 * that local segment; retain the Expander Page 1 read in that case.
+	 */
+	if ((tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED) &&
+	    mpi3mr_sas_link_rate_valid(cached_link_rate))
+		return cached_link_rate;
 
 	/* Fallback to reading from phy pages if DevicePage0 value not available */
 	phy_number = tgtdev->dev_spec.sas_sata_inf.phy_id;
