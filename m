Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8CE50B8B9
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903888; cv=none; b=rRgZ5p1ZrX1EznICv9mYhiYMeGcfuX21Bd5LpNqI1h14q2mHR2zvRmO2oXLhkLuuMoSLGW7PJfe0qdOJWP4LZyy2VBTNJZGKFZD4EIJw8a7RrAK3j+lk4RrRHeaHBelE3F0kQzTMIFbfbncU0wU2iXo04V15mf1OkrPSQ7vPSSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903888; c=relaxed/simple;
	bh=bi8oRlfrRBEJaVuletyP366v4gz/FKhCZMXrwV4xcfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1nMjBrnnYVZo5SQTPASwyJvRi/R5PtlaQqs/EB3zuoYXnzZ+Mo3xjpf/2eVeJ+1n0zyMVB+jCpZBYMs738XyXHB11ZilxaRDfYYR5FWEKGg8F1zy9rPlwRK6zK6q5CKDO0HIkRQyHeQWiUkURvnsJbGT7JCxWGSnZRXfNuQjRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=rbuo6Zff; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="rbuo6Zff"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e623eda81cso18725605ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791903885; x=1792508685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1t4kFfs6QniDgJn2gFawB3EB0+cBfYe4gG9Y5fNmRL4=;
        b=rbuo6ZffI5hm9aeWJO1aldLH5YyotCW+z+ePKyL6YBUsPKB4eSZ0bl0LbhdI4TDdRX
         TBKFi716wvdQydQ4Ep372RJ8y3j2XmWpJTbkVnicGMvneA8ZR8HEJT6NFJqFEceMGkEs
         qZvBRVFaweIA5lsrlSW2oZ3h35qxn0MZjuubdLQ+vASV5ctkqVFCBSBzFL0OimurbQ0n
         pKBHlcjQoWTr6cS6yFIrhuLmuymuZGmvo+GC34FfjvYq5Ie1kpk8uWYn0EHZU48ibZF7
         5Hr0v/kWeLj3su0ALINzITYo+ldDNB2qTFRE+Ini5mbMIc7CHjfrfIaafsUX/kKXpx7I
         LNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903885; x=1792508685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1t4kFfs6QniDgJn2gFawB3EB0+cBfYe4gG9Y5fNmRL4=;
        b=WYqDt1vAyUu4LjuFShTtFoVTclPsZBr8U9cHLcPLfx/JWK+ZiV6GI/CbHky2Hcb+kS
         FcR0UT3djPys2E2rGYZ0XtaRoezxi4TRJ5guLa7fqkLG4uOHfRiYkGJ/s/ohNn+MDxrG
         +lVcLEqIj+cGX1u0iMZ5OqWRC2Tc/VDeYTGStD92vn9Fu0PFIWC+DCMEZn/BK4Eu1ehQ
         maCFawLvFbjWpe2z3z1SdJFFeUBwTNwbE0PC5pq5rgfK/KNt+Uxl+bCKO/kgQoZJNYt3
         rMw/pgCcEIDZAzIV0d4h0JQg9eBtNLLT07mb/N/ERKBbIfmD+pBTZ0Fl/pJEMS2Wooni
         7OEQ==
X-Gm-Message-State: AFq9FYJf8Cq2T8k0afKt0MqPqCoBrlqF8z28KPkSqenGCW+G3tdjyxw3
	hWSWBvBErnfHQu3zRcsBzfgyw2PS+2nm9WabU64+PWTU9+jRVcnoEYYtAnnCbnbcxLE=
X-Gm-Gg: AYBFou07Qup9uLZm8pjIPg5g58/GkBBQCb65JWMc2tD5dvvHiabYAvlBCH8W4FDAKM3
	Uk5YyT1fKckYMAzWpee2OcIGn7m+j3BOWNcwb1tsIOPXmOqA9i7EzJl+pOJecc9oelXQNLpVIcP
	+MSoYgF0PFcQ0vAjQo/9lnknfP6hDtJeg9fIXN4Xx+lv/o+lfusrOCFIzOWnRDZg37JWwhga+l+
	lZ+tfyvidIVqYom1U6ztg/vSSrRkqUFpHoQjMkDzRUWVEWONrj0LtJpwapuN/l3RYhnym+zRlrE
	JgW+qACdtYy9qvIpj5afXXrGNB//E0laBC0iFYUZjvBwwTWFFIm2NdGZcnyuI1/ISB1sj+iJZ/y
	z8GnobV9ZLrutKXpjaQk6jFpju49QSpVDbHbBy0beUiiFchrLxTW0Wa0c8BO4iGbNGzXF01fOYy
	Wmwbzjb443bXykmwW7DV78eYVmKmLBBBqHczh63h57HV3jPbQ+PeQDHCMFirz34TeHEZEcG7eYO
	H5UCNfuhr7XIk17f8rs
X-Received: by 2002:a17:903:19cf:b0:2e2:d834:a40f with SMTP id d9443c01a7336-2e842837a49mr114138425ad.9.1791903884642;
        Tue, 13 Oct 2026 08:04:44 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b8c57sm60302265ad.53.2026.10.13.08.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 08:04:43 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2] scsi: aacraid: bound the SRB sense data copy to the source buffer
Date: Wed, 14 Oct 2026 00:04:20 +0900
Message-ID: <20261013150420.3168223-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aac_srb_callback() copies the sense data from an adapter SRB reply into
the command's sense buffer, using a length that is only capped at
SCSI_SENSE_BUFFERSIZE (96 bytes).  The source, srbreply->sense_data, is
AAC_SENSE_BUFFERSIZE (30 bytes), so an adapter that reports a larger
sense_data_size makes the copy read up to 66 bytes past the sense array.

The reply is placed in the FIB data area that the outgoing SRB request
was built in, and that area is not cleared between uses, so the bytes
past the sense array are the previous request's scatter-gather list --
DMA addresses and lengths -- which are then handed to user space in the
sense buffer of a pass-through command.

Cap the copy at the size of the source array, matching the container
sense paths in this driver.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2:
- Drop the second patch from v1 (the HBA sense-response copy).  As the
  review pointed out, struct aac_native_hba backs that response with a
  512-byte union, so the copy was already within bounds and capping it to
  the 32-byte sense_response_buf would have truncated valid sense data;
  only this SRB bound remains.
- The review also flagged that aac_srb_callback() overwrites, in the
  srb_status switch that follows, the DID_ERROR it sets on a FIB-level
  failure.  That is pre-existing and independent of this length change,
  so it is left untouched here.
v1: https://lore.kernel.org/linux-scsi/20261013140214.3156938-1-yhlee@isslab.korea.ac.kr/

 drivers/scsi/aacraid/aachba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index df9492247631f..89d8e33517584 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3418,7 +3418,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 		pr_warn("aac_srb_callback: srb failed, status = %d\n",
 				le32_to_cpu(srbreply->status));
 		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-			    SCSI_SENSE_BUFFERSIZE);
+			    sizeof(srbreply->sense_data));
 		scsicmd->result = DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
 		memcpy(scsicmd->sense_buffer,
 				srbreply->sense_data, len);
@@ -3544,7 +3544,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 
 		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
 		len = min_t(u32, le32_to_cpu(srbreply->sense_data_size),
-			    SCSI_SENSE_BUFFERSIZE);
+			    sizeof(srbreply->sense_data));
 #ifdef AAC_DETAILED_STATUS_INFO
 		pr_warn("aac_srb_callback: check condition, status = %d len=%d\n",
 					le32_to_cpu(srbreply->status), len);

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

