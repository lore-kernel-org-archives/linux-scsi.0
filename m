Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9FC4D599;
	Wed, 23 Oct 2024 22:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729721998; cv=none; b=MyTLVRUXIUKVH7vUmdBSJ90UX71n2yFV+cMWyKQmFyb3GXUdJHlvmp/xvPgc+4LA1F+LM5YAtKf21DBkLayjvzW4HL1HB8uUiZ03QDnYe4Y9fiFOV3wZUsbcFwDPm+/wPalReYdoGtHGzm93ChN/9OramN30ljTWbvP+a6uNdqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729721998; c=relaxed/simple;
	bh=mV84I4qZ8tlIw/c+y0ZJiDf0fln/nmcp0z4Cz6gtDFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jl5jjnGh2UAzMU2lP35Nhm49BlORhQShfeRxtzeSPp3s9V8v4vajvW6ZLBXPa4CBA6+ewXJg4OMlyXaJgB+BCR20LDjVl9h+qFD3ctJTCM18MdRTYc9eBXXYLRxP7j5WuboLYvE2QrlmjHPS+COrD3cNqa9RCXRoapK1ijyF/kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNw9TPuL; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNw9TPuL"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso3563355e9.0;
        Wed, 23 Oct 2024 15:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729721995; x=1730326795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C2vqjRtQrTFe1H9KEMD4tub74VI4r1dTRrrAD426lhE=;
        b=UNw9TPuLMVTHThettXgC00W6XB9wMTDGT5IsdQKxVQStOWEAmzOCUplOm8qMUzc2Ta
         kOiRLNZJvqRbWSwdkivsXAkkbnMW2hwDhS4N6ZtU9BxWanz5UU5kHruCVRnA9dtv9I6t
         CcxuunDORIyDcNoIYO87jjVAVDgBIa/HOyw3br9bI+4nLFoX3yB045GmUO/tJcTl2JfN
         8HNkpxbVi26Jp/zDM3o/nupRKvesEmMEuIlxXZQoXOT9j819Jw7TJqgEbDJ4ARSM3Dcf
         qQT27kCFd90wBfANRevB8c5GEIEysY1eZhY6qOVXfsdUKB2kxOmiVwh6Btg8dfJ30Pku
         01bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729721995; x=1730326795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C2vqjRtQrTFe1H9KEMD4tub74VI4r1dTRrrAD426lhE=;
        b=G3QcxN4vm1d9RbNhwpjWU6Ua0DK/t5+fmOC0ha39OL/VKORSDLVCfHWFELGawQ2S/O
         o4gGO11nhuxQgyrJ5zwBEkdWyxB3S573ioRLtevCNtyZJUy0q56OBGTj5VYR7ywTc27J
         uiMPDSUSKUc4SRryE15iR4v7efOpfNYDyZgqrDkED4RHbMJ3EGmxy+2FRRnJi3YBxoVk
         z0taaA3cnSyuY3nGTNHhsZwqYrND4plrNdKLVTpkMhApYryrzqGdZHGGrTkTHSRrgPDX
         mYw5EVC0/eBZU/TEW8tGaQDrnBiYn6S6UPKOosmdEPXwG/BJYDsB1+1HBtMb/JU7kXw0
         8/Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXirvScL2nunRd1e92uBeV6OcV5Z0TatVzSEOmIEIwH7mALQqB0Kbo1Q1qh+DgEvjA070Ckhd4Qq+gWvi4=@vger.kernel.org, AJvYcCXji76O8XZab8+w+KnuTGfuUyn6uZIh2gmqGt6aeBBNPCmaE4yvQcL9vewIkWhtqFdc5YDTGwRo+prrTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxiCuVa2fWd0YDNMlswcJByfSrj/1ZeFJwqGR/BHKxXFMQhBZK
	T9Ge1YiIPdi6JidHtDnx4wC9pTp5iOxPgeTWXVOP0XgDUk3PPowb
X-Google-Smtp-Source: AGHT+IHvAj5PNufdD4eKc7jeBApg8U+ynarWqrcHNYd6YMh0MPzUCKX6EDDaL27Wk3l3+MvhXCvUgQ==
X-Received: by 2002:a05:6000:cc7:b0:37d:5296:4b37 with SMTP id ffacd0b85a97d-37efcf18a93mr3316830f8f.24.1729721994516;
        Wed, 23 Oct 2024 15:19:54 -0700 (PDT)
Received: from localhost (dh207-42-182.xnet.hr. [88.207.42.182])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d6579sm529392366b.41.2024.10.23.15.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 15:19:54 -0700 (PDT)
From: Mirsad Todorovac <mtodorovac69@gmail.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the end of structures
Date: Thu, 24 Oct 2024 00:17:01 +0200
Message-ID: <20241023221700.220063-2-mtodorovac69@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Coccinelle advised modern C99-style flexible arrays instead of array[1] as the closing
member of the struct:

./drivers/scsi/qla2xxx/qla_dbg.h:34:8-16: WARNING use flexible-array member instead (https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays)
./drivers/scsi/qla2xxx/qla_dbg.h:87:8-15: WARNING use flexible-array member instead (https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays)
./drivers/scsi/qla2xxx/qla_dbg.h:126:8-15: WARNING use flexible-array member instead (https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays)
./drivers/scsi/qla2xxx/qla_dbg.h:165:8-15: WARNING use flexible-array member instead (https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays)
./drivers/scsi/qla2xxx/qla_dbg.h:213:8-15: WARNING use flexible-array member instead (https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays)

Fixes: 21038b0900d1b ("scsi: qla2xxx: Fix endianness annotations in header files")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
---
 v1: initial patch to conform to C99 standard.

 drivers/scsi/qla2xxx/qla_dbg.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 54f0a412226f..ca9304df484b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -31,7 +31,7 @@ struct qla2300_fw_dump {
 	__be16 fpm_b1_reg[64];
 	__be16 risc_ram[0xf800];
 	__be16 stack_ram[0x1000];
-	__be16 data_ram[1];
+	__be16 data_ram[];
 };
 
 struct qla2100_fw_dump {
@@ -84,7 +84,7 @@ struct qla24xx_fw_dump {
 	__be32	fpm_hdw_reg[192];
 	__be32	fb_hdw_reg[176];
 	__be32	code_ram[0x2000];
-	__be32	ext_mem[1];
+	__be32	ext_mem[];
 };
 
 struct qla25xx_fw_dump {
@@ -123,7 +123,7 @@ struct qla25xx_fw_dump {
 	__be32	fpm_hdw_reg[192];
 	__be32	fb_hdw_reg[192];
 	__be32	code_ram[0x2000];
-	__be32	ext_mem[1];
+	__be32	ext_mem[];
 };
 
 struct qla81xx_fw_dump {
@@ -162,7 +162,7 @@ struct qla81xx_fw_dump {
 	__be32	fpm_hdw_reg[224];
 	__be32	fb_hdw_reg[208];
 	__be32	code_ram[0x2000];
-	__be32	ext_mem[1];
+	__be32	ext_mem[];
 };
 
 struct qla83xx_fw_dump {
@@ -210,7 +210,7 @@ struct qla83xx_fw_dump {
 	__be32	fb_hdw_reg[432];
 	__be32	at0_array_reg[128];
 	__be32	code_ram[0x2400];
-	__be32	ext_mem[1];
+	__be32	ext_mem[];
 };
 
 #define EFT_NUM_BUFFERS		4
-- 
2.43.0

