Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D3EB661;
	Fri,  5 Sep 2025 01:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757037061; cv=none; b=nO1tddJzN5RzEd6j56bnkEG/iA8pPcL6fsYOXhRGja/uTeEjeHaV8M64W9Ux7ueSttwHKcqg1/JTEP49vb5Xqt0P7NoPtuyyr9At/mzvTujWQ8BIJ2vu97lTO2B0DP5cSDmjR8//ed8LhthveyCPmW2fLSj//1EIK8qLv/lpX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757037061; c=relaxed/simple;
	bh=mtUCiZFkROrmNmZueNDQiWOeAr2ehmsSpZK0qNYFgkI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qiol/+mYpgQBqfOtrMXbT2GnLWlhDS16z5Ax/oDSTgoVTH/+foDfw+dkPKwdek8wQUsqBzGtfrTiBN7XnCv/EtwHyZ2v4A0MHNhk4aQ3lsxkjNaOsYojoUEllpPfLbF8hGJ/PztBboX918JsGAyADdjBZIvpxwqp0Tr8DKYt5Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RD+pAQH1; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RD+pAQH1"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-30ccea8a199so1681024fac.2;
        Thu, 04 Sep 2025 18:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757037059; x=1757641859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8JY0OivZfKZISUUtnUE77EU75I1wp67Mbf/W+WdkKKE=;
        b=RD+pAQH1aqQEM5sazVYmKev95fa3DNuPejOposje2zr4HsLas+dsAmyL/GC+GG+JPa
         yM+W0vNMabqbRHmZaqqzWmJGIPK1Rl/xZ4O0QKmWjyO7KvcbsodZslU6jdpg9TaQl+NW
         tBiSFccHuo4tOfUEvOGc/5MadlFufuJAdFy7AhDdpehD5s/6TFZZSFTyPMgHJ/yjFuGT
         04YVruPFwS7Qeo6f49fXvAipUWCjJJVIyYJlR32Chcf4QZRx4KM+6AIi7hZ4wRcGdKd5
         HMh/Nes7Wo7k7fcmTT45Xs2ptp86cuZUhwru7JrwGHA5WxCCTgsTOrOEJcRrYyOvRGuT
         iusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757037059; x=1757641859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8JY0OivZfKZISUUtnUE77EU75I1wp67Mbf/W+WdkKKE=;
        b=a4eM/g5MesZbCxQr3uXDqil3SecaJINFRDIbdyk3eWHmyIr5td8vIE1Z/x/Cp0MfsN
         AOrvTriv8SHC20s3eFTBwLU1F2C+9cbX88NCPASuc5ffCAQXWcJpWYQqVHoirGvV74hQ
         cqSofNd0TVJaXSijIjelyES2Zeu2FJhjwhC6R5CkEIN9bLsM3bOJYu7AGTixsiM/NCn1
         1JLdJIIEX9jkARaO5SkOGAVPCMTb6xlj5zS/okxPTXfQ9JbPTxnjG5GyUXGI3sUNVUiX
         Ixb+XhZqYIBY9z+8b4cezIRPulrRR2oSavTcIob0n23vJxIHOthajJilhz2ORem05BMS
         ma0A==
X-Forwarded-Encrypted: i=1; AJvYcCUtwBEA0YJl83aNSFbnGzR/jxKNF0+XMt6MGSF4pnkZEZHOOwOukWjd3smgAU2MAFXR7+BR90PfzKT4sKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgIoqCXcUlNQKpfPBYxwvDdD2luoYTwEd9P4zT2TMQpDBG4JNy
	PQoA3FZoG5+N5r3Hi9uALBywbFnSAyKAxvmlXRC3O+zNhgBqBWcpSPwyg4St4CcH
X-Gm-Gg: ASbGncvO3OP9lzYlQRbbEVHLoYI1AoxELhQiYPrstrNZsiJ5vC8L9iIT5CEeAiN14Wo
	MY+cPwPTl/YtCj6010RIboAaeoqWJKape0VcXJr5T8+AD0QhvEigr21RM+PyXXSpdLSaymAI8D1
	tDbbH2i64FLjupOT+sfgmo4/lFln84qTKxBgnvhTE9WBCttwu3rGMRWbIsr2wfZASKdo4rVGQyD
	Dq5FbWxXZB9Pqb+6xjpahx+yfEdtSDb6eV2x8fNsMUWvefqW8zktcbAkjZIq/YMzl+NEbc82X8v
	kGXAYncQ6bmDO3Jqaqxr/vc9wsQg0ZiMRr4K5lT92HzkWhT+400nCf2xYOV7Vxiqiw/iGYCUTGC
	PuUz1NGri9+FaePPREHHq0NiDRwRQuaiv4KOaug==
X-Google-Smtp-Source: AGHT+IEUOSHI82q+qUqzWnyKrSzQRvdztHSGTkGFLJQrV/Qab/Uy462NQfF+hyPQzgE+WUmNpDc60w==
X-Received: by 2002:a05:6871:230c:b0:30c:9385:bf11 with SMTP id 586e51a60fabf-3196309acf7mr10018044fac.3.1757037058680;
        Thu, 04 Sep 2025 18:50:58 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:c6df:ff74:ed73:ebff])
        by smtp.googlemail.com with ESMTPSA id 586e51a60fabf-32128eaef7bsm229154fac.26.2025.09.04.18.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 18:50:58 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH] scsi: mpi3mr: Replace one-element arrays with flexible-array members 
Date: Thu,  4 Sep 2025 22:43:45 -0300
Message-Id: <20250905014345.7054-1-pedrodemargomes@gmail.com>
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

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 include/uapi/scsi/scsi_bsg_mpi3mr.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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

