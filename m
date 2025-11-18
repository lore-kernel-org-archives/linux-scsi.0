Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532712C2349
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 05:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763442716; cv=none; b=VzljP3GCaum52ednPicLvfabjV13qag+1mnmm1lnOtLEHMVtybTQzpWnIqxIxXf585lC15uyDiSjm2xiiPahMMXVA9ypzoqNs5ZHD9VGDNBeCkTJeoa2XnAbBBYkPXwtUm3wtWWyMQYbjGl2jXQGS1Fax3O9dobFR8PqrJlTtyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763442716; c=relaxed/simple;
	bh=kr11XY+CSDK5mIhPK9IXS8cRNnvRWjkrd2lK2Ob8UwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nkAaVKgtNczYnn+aA4MgLGwbzBiv2SuqjQaXY3wMS2/q7RQVsu8aLONWonQ05auma4iKjQiqVWG2n1MtakRAzmemivCXE1Nd4+QyE6/Y5MpN01mgGdE778DBdNTT0yihK5gZSKDPsuIQzKeG0B1Ob2YfOL0KwAGtKnSpjt7snrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y2d1hIS4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y2d1hIS4"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29516a36affso59641335ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 21:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763442714; x=1764047514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=59xr1BKeD/o4XV8SXueHZ8zcsS791YO9ItSBrFaFB7E=;
        b=Y2d1hIS47q02IVbLrwV05tJzJdPoyDAq/sA5SeBJ7fJurv8SAcXtkOR03676CA+qui
         NAirPm/1vuFF2CRC+6XQFpEyslhRpYql/lZCo5Al6/LOFilF0r65vrKeSMXLHRN8yi3r
         DGreqY/E98LAFT5mQ5PvpsQD5lg04IosIUqM4j2sAYwZ+6A9V9jDaQGuMd/KHbuglJo9
         9D/sgtXRXeaJbm7VPHNvz/wMOgSwZXl+MXFcZR67ACTqnCvTqx0UZeNeCQE93YlcRd/0
         xxRKYmeBoJECn4l1TGT66/HttM43sFaFf3cvYTi3o9b9RgO/t1pqVK/aFaGeLZHL1RkV
         Oz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763442714; x=1764047514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59xr1BKeD/o4XV8SXueHZ8zcsS791YO9ItSBrFaFB7E=;
        b=xN2H+YmziLFO20L0DBVmYuOQQcFuqvup9skD/HehAPW8cVr5Np1If+wVZqaGJmKZnD
         mj0mqywitOWqkTiMU2r1Rva5D4GgizxM9q+hXowzDy/LTdpIn0veYVxaj/KJbBY6IiJh
         IQzmzyTal5gG6Dth/8lLVeqY4bue3bidN6JwQmw2Wq6BT0vG6g192+8riXymvvjU00MZ
         JfDuIlQZ/8WEhW0pGlKP1kbHNu7SvLfpE2UwCRUdTwprCOXAIbBujXibtZudtiIODJFs
         7ytgeqLoVDx5kRzbR16ld2VN/+HRF8QT/Ima7xVgfqRCCp3v3qncLnLnkq/FHMEZnM0E
         wuvw==
X-Forwarded-Encrypted: i=1; AJvYcCXcm8rJXMcIkXZjjrVxR734gDhKZTFQwXRbTfpp/yD/6UhRPO7+HZGGSDQPiv2IUTwcsZ0u5F5NwDps@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyy6artO3c+RhDtR5wuH3S2axzjtFjd8mq90PVqOIQuj5CNhu4
	5pCaTj04TFU9QkLQfue/FhIUDaK26rtYJf4M8YAo14h7CV1DsEjJ2t/Z
X-Gm-Gg: ASbGncuuF7ZMv8whT4dDrliFCeg9H1Ds4HebBjABb8Dw0vBia3Pxeu3hRObeJqMbCJy
	jss1gjjCFBWrI9H46r14QUVaBaNpyaY7I0qOUa3MJK7FmLLIxQnsqnJz/RFNtyS/sOfUZ5GOJiB
	ZbVs8TP4rqYTck9yuovPNZAZnLhGjSwSjAKWFxBFWRPUpevKWh112CcrTfFwXM213Uz1UUi7xiy
	C0lkKI+0TSMe9Dk3gjrTpbWfwKW40cXBZGfoOsrpUU03Vq3UTZT1cBTVwxeauSbwL1fiKW6FNok
	kyEevPFcuJ2hZA3HFqEXKBEonuiRL+syRrgWXYkCGWsI0kBj9rJbHWUQo1h3Ru5soZE3fk4koy3
	sjdMQwijEL3miI2p688Dz4a8EiJHWO0vMRhPDdBjlkLvN2wPSPFa/AAfTTuu/+Ax/F1JEJ7Nt6K
	yYJSaQIPf8CZHu32eB4bWw
X-Google-Smtp-Source: AGHT+IEsZXJKIb0LuF/okoDtqo5rJwyR4L+wNew2Yio/WLO+GbmlCPI50ofe8iPVqfrbGNeEbKJBjg==
X-Received: by 2002:a17:902:f689:b0:27e:f018:d2fb with SMTP id d9443c01a7336-2986a6abddbmr180135465ad.6.1763442714430;
        Mon, 17 Nov 2025 21:11:54 -0800 (PST)
Received: from fedora ([2404:7c80:5c:6769:b0bb:547d:696c:eb69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0c92sm159116415ad.69.2025.11.17.21.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 21:11:53 -0800 (PST)
From: Shi Hao <i.shihao.999@gmail.com>
To: njavali@marvell.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	i.shihao.999@gmail.com
Subject: [PATCH] scsi: qla4xxx: fix comment spelling
Date: Tue, 18 Nov 2025 10:41:38 +0530
Message-ID: <20251118051138.13041-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "funcion" with "function" in code comment.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index da2fc66ffedd..f9fc8337027b 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3954,7 +3954,7 @@ qla4_8xxx_get_flash_info(struct scsi_qla_host *ha)
  * Remarks:
  * For iSCSI, throws away all I/O and AENs into bit bucket, so they will
  * not be available after successful return.  Driver must cleanup potential
- * outstanding I/O's after calling this funcion.
+ * outstanding I/O's after calling this function.
  **/
 int
 qla4_8xxx_stop_firmware(struct scsi_qla_host *ha)
--
2.51.0

