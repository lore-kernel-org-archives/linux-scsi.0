Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D21367;
	Sat,  6 Sep 2025 05:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757136459; cv=none; b=l9+iALC/bvxVCfEwu3+gqy+M+l6+d8M21vwMobd26VM2DJqmely+Q8RmlpF5MFVpSAAipz6a3ZOL8kXoY1g7zxuIQa9NMWvaaYGuvMrGGu2uznqk/RWiiHIUPQoO8zxx71uBkFfjjrfDC0iakef8CBem8d6IcMnH/ymhaEhXPdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757136459; c=relaxed/simple;
	bh=ILx/IqUEAf5dNfgv1RCPobsMBAq478CLLLrBl/sSiig=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fqeR1XZV1BpToVAu4Ss9Zqi4r8c+os0zY3QNdFwOL5pS12tF/akmcrY2aR5JvsY9PLhg9Mnv75GczQACoFgnxzodT7yFaoJUJjWPxIyxxNCyrmiZscU6r8samrC99lQDPo2fTvACe/kWhQlPGcWP8T/18ChaG0uEt9Q3bZzIu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QdPTDbBK; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QdPTDbBK"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-544acb1f41dso1220266e0c.2;
        Fri, 05 Sep 2025 22:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757136457; x=1757741257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tQdhQjCLnbttw1C2tIoR+bnhZgK38rRIuMpPdmFaKlg=;
        b=QdPTDbBK1OBczpcAVRj1kA1pV/TOzY6wPJcRqZgDhdUXkhVRu8c87OCiHt3lu1SE+g
         wwQN6Jszn4SoB/BpIijPKLmwuY+zGbSk/4MGEXs41bE+eYPfIkqOydzI4RU1LShmYBSa
         ozuu6w2w/jd5odHEgSvQMA6aClQYECpwGYvWlP20ldoPcMZEwq6tLf+/tWN+YFapwFqW
         wRtrcUzjx9L9RXe/cl7vmNLTvXo22BDuNiFzP10jAYH3FJJC5Xa9aiauBle2+CuEiHb8
         knMI3BQ2SrT88reTUbT0VF1IqJCCQ6VFI6KWkByxZ4rjdQIMxIEftnQ/izU+WYU7WCzU
         4YSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757136457; x=1757741257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQdhQjCLnbttw1C2tIoR+bnhZgK38rRIuMpPdmFaKlg=;
        b=W/NaKKJw8+UhO0p5O+W2SyEmCEReA5JAENp95tayq7BwPei8YfsC9Kt7gUQO8XtmJI
         GuV8+XoE1klpdLDPB17Mo8TL6ZAdwR4irznSUapIhEPrDLCVWrCaXMqHFgg/N2wuwxPu
         yQzayXPKEkb2umlvuYTscvFne4NWlDKFBT0pJdoMXGiO0nFAuvXobK9SYHiLA0Qy54hO
         EtmSNc5Ef2v/Oob9N7VfOiQz1heCosxr4ljmegWe+OUWr8wE11paTnHgScmzSGaOoDzK
         nHV6eVI8lrfxKMbzll/Tb312DqCKEkfwV4XfW3Ng4plYajlA4+65BgOUGmWjYf2Kx5OX
         0vMg==
X-Forwarded-Encrypted: i=1; AJvYcCX9yLhrI5FrnVQnHTxQoVe/Gfxk41kLTjmZmYCX0RU8KtHW/GoHYxsAWyzvOZznjxFXQmu5mo/Gfl3evTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgASKuGfNM8koEAjv5BX09h2M+N08dsSxr8MrSzd0Tcqoasioz
	p8Jg2PvX9gDvlzwQizC86y1sTb8X9ebYn6yGUlipL38M2qKk6dkE7STSblJg4tA/
X-Gm-Gg: ASbGncugrKpLyrUK/gcCGtG6Tpd4fVk5Rd4la2XT3mCqt5UvWMpKhstJFLjFe96BB/6
	2oWmyJQaONpsSA8fqNieLqDkzVgNZCQFEXd5i5gCXACH7GYMooQjmBRJaGBKpr2wHPLCJ+IcmUU
	nvfaJJiN6wjw/qjtWmsPXxJoKdygqccSV5WC25YBvzVYqcYXCaJqpwxGK96V5egi4cCtuqoklBI
	+vROjigS32aVK3/067Nqyp1gsKq6mIDCcrxRiVkIICO8e6Hgu3wNoaaPGTWtlFSJ8yR73cwPfpK
	U3E7u2SLtOcJI7s0HD9+dp5fKdIjZ9qBncWAUh5ZH2xYdHBQJzflmz3xg/pcqWwMUb706SZSYTx
	GvBvGpKrSjEhtseFVoISMqa29YHenV3V8oTtH
X-Google-Smtp-Source: AGHT+IFnLfCtooVCkNri1sHLTys6A8NIDo6CEVuTcuHXJ+a+CVUdg0e4kqKxuKx5jEUnuUguy/d4pQ==
X-Received: by 2002:a05:6122:7c9:b0:539:33b1:5571 with SMTP id 71dfb90a1353d-5473aac04c1mr375378e0c.4.1757136456668;
        Fri, 05 Sep 2025 22:27:36 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:2f8:6aa5:de03:ccda])
        by smtp.googlemail.com with ESMTPSA id 71dfb90a1353d-544912eef59sm10643006e0c.8.2025.09.05.22.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 22:27:36 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v2] scsi: mpi3mr: Replace one-element arrays with flexible-array members
Date: Sat,  6 Sep 2025 02:20:41 -0300
Message-Id: <20250906052041.242671-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element arrays with flexible-array
members in multiple structures.
---
Change in v2:
- Use struct_size
---
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 11 +++--------
 include/uapi/scsi/scsi_bsg_mpi3mr.h | 10 +++++-----
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0e5478d62580..cdcdecb21b37 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1241,10 +1241,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc *mrioc,
 	uint32_t data_in_sz = 0;
 
 	data_in_sz = job->request_payload.payload_len;
-
-	length = (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
-		    sizeof(*hbd_status_entry)));
-	hbd_status = kmalloc(length, GFP_KERNEL);
+	hbd_status = kmalloc(struct_size(hbd_status, entry, MPI3MR_MAX_NUM_HDB), GFP_KERNEL);
 	if (!hbd_status)
 		return -ENOMEM;
 	hbd_status_entry = &hbd_status->entry[0];
@@ -1466,7 +1463,7 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -1492,9 +1489,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = num_devices * sizeof(*devmap_info);
-	size = sizeof(u64) + kern_entrylen;
-	alltgt_info = kzalloc(size, GFP_KERNEL);
+	alltgt_info = kzalloc(struct_size(alltgt_info, dmi, num_devices), GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
 
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index f5ea1db92339..9e5b6ced53ab 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -205,7 +205,7 @@ struct mpi3mr_all_tgt_info {
 	__u16	num_devices;
 	__u16	rsvd1;
 	__u32	rsvd2;
-	struct mpi3mr_device_map_info dmi[1];
+	struct mpi3mr_device_map_info dmi[];
 };
 
 /**
@@ -248,7 +248,7 @@ struct mpi3mr_logdata_entry {
 	__u8	valid_entry;
 	__u8	rsvd1;
 	__u16	rsvd2;
-	__u8	data[1]; /* Variable length Array */
+	__u8	data[]; /* Variable length Array */
 };
 
 /**
@@ -259,7 +259,7 @@ struct mpi3mr_logdata_entry {
  * @entry: Variable length Log data entry array
  */
 struct mpi3mr_bsg_in_log_data {
-	struct mpi3mr_logdata_entry entry[1];
+	__DECLARE_FLEX_ARRAY(struct mpi3mr_logdata_entry, entry);
 };
 
 /**
@@ -307,7 +307,7 @@ struct mpi3mr_bsg_in_hdb_status {
 	__u8    element_trigger_format;
 	__u16	rsvd2;
 	__u32	rsvd3;
-	struct mpi3mr_hdb_entry entry[1];
+	struct mpi3mr_hdb_entry entry[];
 };
 
 /**
@@ -416,7 +416,7 @@ struct mpi3mr_buf_entry_list {
 	__u8	rsvd1;
 	__u16	rsvd2;
 	__u32	rsvd3;
-	struct mpi3mr_buf_entry buf_entry[1];
+	struct mpi3mr_buf_entry buf_entry[];
 };
 /**
  * struct mpi3mr_bsg_mptcmd -  Generic bsg data
-- 
2.39.5

