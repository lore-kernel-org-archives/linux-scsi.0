Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE4413B797;
	Wed,  8 Jan 2025 05:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736312963; cv=none; b=gd8yyLolQPI/Z+PNOxpV2xTjEgnHX+yxfaXmAB6dJOj7Dky/OPPvdV3LwQQ6GfVRfq1QaW1jbBs7jxZsR/vISzwPzFHlCO1BpeBu8FQn73E4CK/EW2ewFQO/3C2sEvZLETX7ipSVI7Q688lZLoG+umwVcfnMiXpVtQQqZuKPM0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736312963; c=relaxed/simple;
	bh=yshGj3Efjd6907/Fm8p8gk9tJtpSFmIfG5ROn4lL/ow=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YrauoWkdxVLU7infnfXnZ2MUstnGdWG0cSbWUzNP7TbmRq3IbIXSsvoyv3K9M8eicTsWTM7mLNrkFZtdR0TGj7o80w8bEIBt1UCWgB67+DD7repSu3lGDkEmKlUH0RvVqGu825vHRqzFUckiphYtnyByg2uOszmMk+IZ9Csryos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S9SKKOU9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S9SKKOU9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ef70c7efa5so19370521a91.2;
        Tue, 07 Jan 2025 21:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736312961; x=1736917761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MTDWQO6hhYrmitjYrQrRGGY93eShYihp/bO4a9zHqj4=;
        b=S9SKKOU9ccP+feQ7/b2o51HpzXC8zu28OdoA77hcT6PtcEwlSExLUUoAbWoHp+RPWt
         z7hu1R3jQ5MgWOpvHSIhXHHV9PHO7fAyM/uzDz8x1YnxSi/ZxJ8ObQFXrUuSxWtLVlMP
         3k+W8VSP8naLNySTz9daxjRg00cfHAeOBAQsIVw5NTGGn9bF6QSu9vLMIC0YsdbPyi9C
         9NUUC86NPrSDXzXjeVpgNjaHhQWdx2VQEgGJ1ieI/rVCHuGj/rTAGaIaVYy6B9RmTZxS
         uvYVrn6n6GrUTWjow82avM+fo62UKQYe3HvB/Z6zDQMHSBGhjX5U6DBFPKFzcDWz9DRO
         5T8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736312961; x=1736917761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MTDWQO6hhYrmitjYrQrRGGY93eShYihp/bO4a9zHqj4=;
        b=hT3fAEEQVcX8JnHdI5NBUGSrDzWDxML/xA4NPGP0kMaXh3C38bkQF7FmF5pv/L/ZM0
         W73W7ERiniEaQaGCcpVint5yB4FwDUA+ELJBJpcZQvQ4VdAnmVoGX+Vm4bN8eE8Xg40c
         nTYYluuvVQHDXzDGiyz3/xDrM4frevJCqFmY0PXKc9gxOHOrADXXNEnTTysuFI5gqj2x
         CB14C+zZIwJOQZvxry952OHnyLjVAS75ZucDPj9Jk+LClN7olKqezoDmrmvAFvE/uSal
         F2MaSRN+ZCDGMWK35srak1wVQU2c8fIIf2VpazAeR2AnUsvz+kFkdUvNKjra2/1GlxQb
         I2Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUbEULTonCC5JqRZyjH/KJQRIOahq7Yu2cwjV4ynZ+QZQEA2Ob4+7FAMrkaOXmUyADi8EnMB2Ah9Hp7jtw=@vger.kernel.org, AJvYcCUneT3mIW1ErKSTvcWU1VWeZaKDU7HuhGrLrlFUHpuywvotoIkYEQGsai3yGchxR8FQeUdEMvtbDsZq+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnCDHTNBFkCRpOBhsWwST4ImEX53be7ZebWoPI//ewjKvbENS7
	19pXFZdWaIJpYQiX8T99N+QjApzQ5VkHy1PNHLOY/UlnUQne8xmcJ7QKG1d9HKw=
X-Gm-Gg: ASbGncs/If91qsHM4tJ2HfgHxPlEBQ1zMl7rgX5u5zB1s1R5uEnu7+AdA/wWs/DpNCK
	05o7Gh+3oca2H3DXF+Z60gA2MW3D0nBpUY1KHPeBu5gOOEYz8LuwbzCdo74aYfcZHixr4P5W+9U
	uJmgKBKM2IQXAJN8KjjqNtC2gu5W0mMIxtEUF6zLO2s5y73guwQ7X3LM6YrTP8Pv25kVTzM+peT
	8UJHihn0V/9hWhtwgd7NKEaLZiWcu9bymFoRrkHwtebhbdMDpsOHS+XiE5C
X-Google-Smtp-Source: AGHT+IF1SeejcnPqaE6PtxfHlCWA6lWYaC8lS27aqPobHaWxkdHF2OyH1z7iu84OjH1Fkm6dAqTvDA==
X-Received: by 2002:a17:90b:3bc3:b0:2ee:cd83:8fc3 with SMTP id 98e67ed59e1d1-2f548f44382mr2248125a91.37.1736312961282;
        Tue, 07 Jan 2025 21:09:21 -0800 (PST)
Received: from HOME-PC ([223.185.133.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a286d24sm465247a91.19.2025.01.07.21.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 21:09:20 -0800 (PST)
From: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: satishkh@cisco.com,
	kartilak@cisco.com,
	sebaddel@cisco.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
Subject: [PATCH scsi-next] scsi: fnic: Fix use of uninitialized value in debug message
Date: Wed,  8 Jan 2025 10:39:16 +0530
Message-Id: <20250108050916.52721-1-dheeraj.linuxdev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The oxid variable in fdls_process_abts_req() was only being initialized
inside the if (tport) block, but was being used in a debug print statement
after that block. If tport was NULL, oxid would remain uninitialized.
Move the oxid initialization to happen at declaration using
FNIC_STD_GET_OX_ID(fchdr).

Fixes: f828af44b8dd ("scsi: fnic: Add support for unsolicited requests and responses")
Closes: https://scan7.scan.coverity.com/#/project-view/52337/11354?selectedIssue=1602772
Signed-off-by: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
---
 drivers/scsi/fnic/fdls_disc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 2534af2fff53..266d9f090772 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -3904,7 +3904,7 @@ fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	uint8_t *frame;
 	struct fc_std_abts_ba_acc *pba_acc;
 	uint32_t nport_id;
-	uint16_t oxid;
+	uint16_t oxid = FNIC_STD_GET_OX_ID(fchdr);
 	struct fnic_tport_s *tport;
 	struct fnic *fnic = iport->fnic;
 	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
@@ -3916,7 +3916,6 @@ fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 
 	tport = fnic_find_tport_by_fcid(iport, nport_id);
 	if (tport) {
-		oxid = FNIC_STD_GET_OX_ID(fchdr);
 		if (tport->active_oxid == oxid) {
 			tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
 			fdls_free_oxid(iport, oxid, &tport->active_oxid);
-- 
2.34.1

