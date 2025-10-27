Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B78026CE3A
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607451; cv=none; b=sMSVme3aAjzE86jN0ABQlj4JFGXZ4skVBwjlLJPlxLu7x4AAJxcDLnL2s4bayUYo+NdLdakTq7qFMJOlS4ujum7orbB67PGM+9p5Ie6cFE1TyJX6T89KIg+cI0FiYR/7iFI0BQPNARVsbSpn2warKZn1D8eiqI0tz6iAW76qk2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607451; c=relaxed/simple;
	bh=3r+ijv/UzI0r1D+GeHRtEz9pGU2mLp8Z+lj/DV2eSIE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aMscRqJGe6zBjfJ0djTofXwA2gRF204qR0B5NPLK6uOHIe/+FkQCGnDFZOQX8ePePU3leQLwQQaQ2SMkx8g1/df5yp1pV7BJgaiOFMO4+HKuSK0rzr/usHH3hp30oys3pPTOxj/CP/An5q7cV0a16Z0F/JRC6MsMQz/VpQAslNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hi6Aim5o; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hi6Aim5o"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7811a02316bso3786720b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607449; x=1762212249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ahrwqHY5RGFBCn2xswW2iyIaPDaobH8HCZxwpuaOck=;
        b=hi6Aim5o3j5+UdV/LZnVO0Jswt1gyMYsWTGBVc2ov7RtT8RBECcs3vtCgTH5SNyev+
         mga3QzyS5ElGBQNotKtDTi3X/gvjKc8Um9OQuo4DFRpdT+CIZ1q0uRtX+NUjxcS8Fg3r
         Ju0AQp/U+vbLt9R8+Yg4Knsk38iqwBucPyFyVzdcNKcc/U4gidUB9AW99DBSKZdoBLZ5
         cs/oaEVP7X8Arc99wt4y9b4yZ4hEWg/t/vmJ+pPIDSFZdQsYykHnQI09OyeeaybiuGZZ
         bvkYE9PM4RGwKRL/+BV5FxQD59bUyZBNw7DWwbB7sQucBjlJsPjmPUtow/uABtRF20r8
         l5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607449; x=1762212249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ahrwqHY5RGFBCn2xswW2iyIaPDaobH8HCZxwpuaOck=;
        b=diRinggz17uCn8To8byJFEe/FyZE6hRgFu8GghBV3Z0EiFgKSLa3QDimeQRIEAEwmX
         QOnyAy4oYQiRCLJVLYFXDhXtV0PdLKjARpO4irD30kS350Vr2093QoOftEwDU1DaIVFv
         IA0F/Ze42B5gwoOK6EdUpWpx+rzkZ8HLkZpISUAt1phdJ0aPlCrBgmNY9WuinF+rFSUz
         qNT3sBN75woulrDfypG6Jmk0LwY+sSrz4KBTLQYyzAGNWk3ErzpWrtmPTN/zmwNgze7v
         uHYPJwvSIajptTuz6f95WxFVAOBXYhrqIac6XJVDPaWwzXsfsr5KvNZXR3FgPvby87yl
         644A==
X-Gm-Message-State: AOJu0Yw/d+F+JOkD7ojPr1GNEbINkCL99nko+GnDXo7T3Kk5COpILTUK
	cG3d91+hhCx+Pwtgncw56gLNkGXjDGotfRxld/aJXkKaO35Iyp9LaNdHHlmhjg==
X-Gm-Gg: ASbGncsF0IkN68gdi8zfXPjA/KWYW8SjNJjTZH8JbZmCEP+oINzsvn7W36EKUCyeGos
	5fdjX95PDDFcHhiaJuEO+TGGcljlU3KpwTTxo/FLIzpq0hqcFovjdDjyY2HYCdLDXCMAdDHagYs
	wOlvNXQnatF3LiHG6KfhSsCSTY/fzLxWGdceQ9UgC0SECzvQiQzHyOZoZhyXI8lYEXC7X7y/q74
	esRyQpBGbAXu9TDzDIH0SGjsF00JpqsXHpHorPmhVRHLL9hyoddS64g33fYnIW4QQS3HCC/714p
	VwR1CsyhTpccTXvvfLS3T7dgl1LBwO5esbomb+4JQ6XGs5IVLwvvhYjieHVhe658l9J1OT1ARNY
	MDT9X2rA7KJmnT6ZbaQRMunqEH9vjE9aXOFyl4t+wHDjw1euPCp95LI7yJdzGASZd13KLjMKd/6
	viyl2SEbj8lzMwxwEklqJRXeAeHSyybNbxuDqZZuwrNLvAFVO3y9y0nXYMtLLjn+SQ9FCwF8E=
X-Google-Smtp-Source: AGHT+IHETEQ/L1ORsgX2lmYGuWVED8huilmT8bPdaKk8kUk1AOX8g8D+Kv5gLZOajsQr9NqeKw10ug==
X-Received: by 2002:a17:902:ecc3:b0:290:91b1:2a69 with SMTP id d9443c01a7336-294cb5262a0mr16684195ad.52.1761607449269;
        Mon, 27 Oct 2025 16:24:09 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:08 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/11] Update lpfc to revision 14.4.0.12
Date: Mon, 27 Oct 2025 16:54:35 -0700
Message-Id: <20251027235446.77200-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.12

This patch set contains updates to log messaging, revision of outdated
comment descriptions, fixes to kref accounting, support for BB credit
recovery in point-to-point mode, and introduction of registering unique
platform name identifiers with fabrics.

The patches were cut against Martin's 6.19/scsi-queue tree.

Justin Tee (11):
  lpfc: Update various NPIV diagnostic log messaging
  lpfc: Revise discovery related function headers and comments
  lpfc: Remove redundant NULL ptr assignment in lpfc_els_free_iocb
  lpfc: Ensure unregistration of rpis for received PLOGIs
  lpfc: Fix leaked ndlp krefs when in point-to-point topology
  lpfc: Modify kref handling for Fabric Controller ndlps
  lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
  lpfc: Allow support for BB credit recovery in point-to-point topology
  lpfc: Add capability to register Platform Name ID to fabric
  lpfc: Update lpfc version to 14.4.0.12
  lpfc: Copyright updates for 14.4.0.12 patches

 drivers/scsi/lpfc/lpfc.h           |   5 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  36 +++++
 drivers/scsi/lpfc/lpfc_disc.h      |   3 +-
 drivers/scsi/lpfc/lpfc_els.c       | 249 ++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   6 +-
 drivers/scsi/lpfc/lpfc_hw.h        |  25 ++-
 drivers/scsi/lpfc/lpfc_init.c      |  12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  21 +--
 drivers/scsi/lpfc/lpfc_sli.c       |  92 ++++++++++-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 10 files changed, 341 insertions(+), 110 deletions(-)

-- 
2.38.0

