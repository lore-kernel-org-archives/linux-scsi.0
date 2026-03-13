Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260343CD8B8
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 20:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433715; cv=none; b=LtSz8LFYIHh+jNgYAgNH4NdTiuinFE/v8SyNvdosDkXX513Gw+mvlDQaUmnygGsBfnCtNvm+26M/BPMGPCAVAE1/f1izrJumbdWksVye0Is9KQVBHufdv2u6OWFbabZryk9k7lmODQllQA6pe9jNfJj8pHhk2elzXRZ1TP0+OWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433715; c=relaxed/simple;
	bh=ii9fJhTNRCUfnNusQUvOKz4dkevUob11vFbmcLrbY/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=TmHPSwHgiWSyijQX8jXiHUk4O69fwWshdaLx0KyOOlSKev1CdxnCMaSpb+bjzxJtVdIUJM6Ug/6C9jNUjjh/myaDs+FXe3RdVhvEZDDukjeVJb7MBMjyXUWQ/QQfVE9rzpNBJZvY2by1Cz+nSnjId5uPAx0KxZRVaa9NCTdKKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lIldUwTI; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIldUwTI"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a871daa98fso19847845ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 13:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773433713; x=1774038513; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N8+xm/zzL7SoctPYMLA/7E47XuiprZZpUPBZzC9PZac=;
        b=lIldUwTIcy2/T0+d+c8ke4O4N0cwpUXay7+Dvpqr/MOXagzjB+4sTekPMXQ26AI6Yb
         Yr4Z0e6HNWnsNHM7nKa4f75JlxfoiD/r4OtUDWP1KCaw8W6YLS85VR8CGTm3o4LX4DY+
         RB8fpsQJGGi9mAUZCti/+pi30t5IYfs7+mavxpTtH2bX7ry19trQQ6fY7rLGbQOgLkMk
         F5hGoz+ZnMv8O7Dg9GH330mSOpQKbLaDj+HA2mNM5HF/r+FzA6fV2D4m4DHk6ZuZDjsA
         TTTdSF4fWZwrnjRxd0rMGNL5V86gL6mJDWZjf1HbexXK5uwmkyq83iusjUKaLk/eG0ku
         Yw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773433713; x=1774038513;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8+xm/zzL7SoctPYMLA/7E47XuiprZZpUPBZzC9PZac=;
        b=ph7UQbzNCYD5x9JYYKCUR2Ncs4qtjkvdPmK0XKOZHEjaj1XrcEnfOusWxacZ7ucoAP
         T2QEF/oK0TxeDpxiFBgvxTW7/DlvhUuno1Np45gz0Sk4ODNjz69XwvKWL8ZLD9nUmP/V
         jpw1gjB6Jy2vBvIPk1w1Wnnfazdg78GywUlxg+h6ZM3cR5adqJwq28IxA1R+caQ0sPGV
         CskY4D88XkxY/ZVUlr57c6ht52B5A1OR+iU2iyKNYMTfaTxmtY3l9vfxwpYY0eiWI3bQ
         GH7u0pma2KBO+IqMSGeA72jAKO2IneToa/4qmrmBayBtYR7HtSXaCB8MFni2i7slYVbw
         KwIg==
X-Forwarded-Encrypted: i=1; AJvYcCXr7WTJUEXiVGaJZFQ+06MhwElbcQ0DDSynaHpdLvX9bXoLdKDtdtjwi0SKGtcWLbt4U/Go3g3JCDqy@vger.kernel.org
X-Gm-Message-State: AOJu0YwfEHnS5e4gMdXplP/0HnvMIXugxZKMv3RUB6Zus9CWO4krFw2P
	SAg8yoKZHNwps08vCsK3chBXI5EblU1aoBSfdZPJqOcieNUUoztId4Pl
X-Gm-Gg: ATEYQzz8DOFQGt5QiURtPobZNu4AcHGULHjZykEB1CbcjSdHuva28Tm1aSMda8bEcl1
	jo+B/3gxQPAQWk5eUol9A7c7UWZfeeMQ/oimz68cPqM14NZ7ijDhMa/VKs8XJ4hS0yUQQzZ9l/c
	roLHXbKx0bhrbuHevhM30y8jVCAmY4jAxcf0IEh/bmNCZCKyTGVnMwWRGi6ZRyi7dhBzlTsNsi8
	Qyw4M3g0a/wwOXxO6HGox3JA+5W4XMTELyS3VY9FrZd8yo/lzbGg0cn9T1UsBTiFwq4ojKyo/MZ
	F9VVceqfwnv57yr4+fJpDQZwN6u8onxVIRF4l663vkhJgfoQrVDmHH/ZvKjepjkgcyMbxN1NKhB
	gZsQI3dZqazk2xKfH6VO2uUwiP2MvPYz25uvDCLOKg2ehdhskavVC/t6VJ5t8PfR2zsjbY1jv3v
	9T4N6lXAgOt10m+nu+QlJ0b6xvYw==
X-Received: by 2002:a17:902:f683:b0:2ae:508e:5019 with SMTP id d9443c01a7336-2aecaa4bc64mr47344505ad.20.1773433713568;
        Fri, 13 Mar 2026 13:28:33 -0700 (PDT)
Received: from [127.0.1.1] ([103.216.213.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece8629bbsm29165095ad.88.2026.03.13.13.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:28:33 -0700 (PDT)
From: Atharv Dubey <atharvd440@gmail.com>
Date: Sat, 14 Mar 2026 01:58:24 +0530
Subject: [PATCH] scsi: buslogic: replace strcpy() with strscpy()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260314-strcpy-v1-1-0b38691fe11e@gmail.com>
X-B4-Tracking: v=1; b=H4sIAGdztGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY0MT3eKSouSCSt2URHMDS2MLYzNTU0MloOKCotS0zAqwQdGxtbUA3uU
 JO1gAAAA=
X-Change-ID: 20260314-strcpy-da7093836551
To: Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Khalid Aziz <khalid@gonehiking.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, Atharv Dubey <atharvd440@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773433708; l=1867;
 i=atharvd440@gmail.com; s=20260314; h=from:subject:message-id;
 bh=ii9fJhTNRCUfnNusQUvOKz4dkevUob11vFbmcLrbY/E=;
 b=e1iEuhHK4OpMzbGVX2kfHOCk6zBJiBUHK2QGH7bsEP/kyKyNuZ1ws8jK2RNUnANqyburlIpPk
 BGxSyK0Z7dVBoeys3l2dAfwTy9KmNg1WRwps6UQOyDa4Lv/YtSCPUvm
X-Developer-Key: i=atharvd440@gmail.com; a=ed25519;
 pk=T6i1xWOKT/RUSDYATSgyVG/4X7ac8jPjRSG1mMAcqVk=

strcpy() is deprecated as it does not perform bounds checking[1].
Using it can risk buffer overflows if the source string exceeds
the destination.

Replace occurrences of strcpy() with the safer strscpy() where
the size of buffer is being checked.

Compile tested.

[1] Documentation/process/deprecated.rst

Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
---
 drivers/scsi/BusLogic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index da6599ae3d0d..c070f3b8197e 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1262,7 +1262,7 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 		for (i = 0; i < sizeof(fpinfo->model); i++)
 			*tgt++ = fpinfo->model[i];
 		*tgt++ = '\0';
-		strcpy(adapter->fw_ver, FLASHPOINT_FW_VER);
+		strscpy(adapter->fw_ver, FLASHPOINT_FW_VER);
 		adapter->scsi_id = fpinfo->scsi_id;
 		adapter->ext_trans_enable = fpinfo->ext_trans_enable;
 		adapter->parity = fpinfo->parity;
@@ -3451,12 +3451,12 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 	va_end(args);
 	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
 		static int msglines = 0;
-		strcpy(&adapter->msgbuf[adapter->msgbuflen], buf);
+		strscpy(&adapter->msgbuf[adapter->msgbuflen], buf);
 		adapter->msgbuflen += len;
 		if (++msglines <= 2)
 			printk("%sscsi: %s", blogic_msglevelmap[msglevel], buf);
 	} else if (msglevel == BLOGIC_INFO_LEVEL) {
-		strcpy(&adapter->msgbuf[adapter->msgbuflen], buf);
+		strscpy(&adapter->msgbuf[adapter->msgbuflen], buf);
 		adapter->msgbuflen += len;
 		if (begin) {
 			if (buf[0] != '\n' || len > 1)

---
base-commit: 173b959a8bb814f55660f7c34ddedd4e75c203d2
change-id: 20260314-strcpy-da7093836551

Best regards,
-- 
Atharv Dubey <atharvd440@gmail.com>

