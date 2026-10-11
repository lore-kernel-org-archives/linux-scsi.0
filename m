Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1143955C7
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 04:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791691397; cv=none; b=OPDsYHm5VCotkOosST8vAsGYeXcjTFG1odqRdBlWdzauGE+bVt6HagWoGE6yHYf9CUJ1bp05JT3pbewSfJK0VYMG5qv9esykt9H8S8DYlV90s3TtZIrbLgsaxZpeKfnX3beN1K3GFAQkjUFontwgurUlAka1l3qF/A7mPiwAPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791691397; c=relaxed/simple;
	bh=AVILD4NIFiaHIKZF3dObJ7wQt2O+e8whBy0FyrWCgMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcwWSo19OaHQuZFRbKczR+YFM4C5Q1odHcpYeCpo7YjkoO/mmoyQwI8GlEQtpwdrvBZMjshiWg2FyHHKL6xyjNf/co734gdR8skNxQRq6gs2wBvSxUsN6e6S+7zo2La1z5m4adU5ngGjQt/C7mxL8AQMRmHgoydBH8AHN8yZlqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=vffFsQBk; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="vffFsQBk"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2df982e04c1so4281335ad.2
        for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 21:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791691396; x=1792296196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uexou8z/rPlM4ERJgzJ952D7p4Fry0pcqVESxFyRPsw=;
        b=vffFsQBkJtUEqrNvbfhoKtWoRTqeYYMBTIpSLDgrSZVAkGt1QHgR51nlzXoYbOxVSc
         YSIwjMY2E6Vgod40cTE8RoIHoiP0idMWyaS9MZCw+P3dP+hsxGIkxJ445vsTOYq0euEB
         g6UbGhbSmEMpdpvX1dzYnEqlUMikQaZVD8OwlOxoq6OjXGZm+h1VEyirEP2D2TevlWn1
         Cd/LPQWuxxPDktUGroQOkU7uDDLQaKDlKlu/3mWOUCfqLxQstkQAx+c8onLc/JpM72BN
         PFK5QaY7GfD4y90/SIf7J1ergzWY7TAB0LbU7seCbesa9nEUFwg77XRuI1FaeBfnxnVI
         +Sew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791691396; x=1792296196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uexou8z/rPlM4ERJgzJ952D7p4Fry0pcqVESxFyRPsw=;
        b=jx1fCdCBYqHCTRXAlQvar+YZsjlZUx4Z73mYb7nuI0q8kRMMNQx1xWr5uCxowR5e2T
         oGC8EC8F0/4VmHaFbvPnFYfyAnBPndey5B2QC+PjHZzF8qyVN3y23uges1PNhMB7BGcD
         HH3RSSISAHVCqFxldefqM69HZNixji/h0xorBPF8KO3wb6myVjLqIqvnMBkTF2iK0F4G
         jG+wkfWcwjOq4KR9Ckg5I4JPStwV9FSVRk9OqqPWncPpH8SKkqdVQLZUXvdx81fWv9do
         65qjG/jb7WokpjFwxHy+OO2ifk4uxKXOAxBFHBrF3A/TX1f1EagSlHy9RNI4MvrsHifd
         JKfA==
X-Forwarded-Encrypted: i=1; AKwUvBxEtDinCLjf6xrKZMns0MCnhQ5gtBQny5iVfhd82mKY5COiAC24V5V3lMPVEPqxtc2U5HPXnkzXsGlX@vger.kernel.org
X-Gm-Message-State: AFq9FYK3VjKHVDn3GD9QmjTe3xW9fxbiyF32FL3UBJRuD8TXfdW+3Fzo
	q1QlDMhPuDjl42B9Zfe6mjh1ntcGuZDye5rzhmEoiiaDVHEkpOShTY1sskDOV/gdMXg=
X-Gm-Gg: AYBFou0wzy+//K+iylK4SPKPLtyoL8R0aNh8qG+RVcXCKqFWMxis+wtPvaDi2TB2S29
	duEfexIyZIzE1Mkw9L+TrSfSF8+vMCDWALpnCgaFe8wIMq2TGsJf1hNxgMILnXsMplDdRIy1Tsj
	2Ewxf5kKdzYntoTORVo3g0ki44ORDrPgexhkFgKyhthSsvkO+mk8EX7fPDzX91f8D78qFY4XIox
	V1SQYBRF4oxrD215Qn+ixJx5svVkYAsh1QPxBBl0PBGu4kKZgEcd72rgM2HnXQeGfij5ulymLoa
	lzHwjGk8qkj+ICDO9SdCTngiZtNEMlJa5lkmfafTVp0Cmvqygh5I1YD+UVoo5kcccreQTlcXMcK
	Q0iHxLYNpWNrFcCOmCRfGvUdt/Tjo7TawPskycwpVedJCOhSwUD3EK6Wbpe3xjRgBilN0y5rui4
	UOGyRGk/vCam45XFJ5t/Mx9/y+PLKQll+nWsPD9EYtbQPtnWGtk1eHuv5SsNA36lmIC/wl5wsUu
	VzlX9sj5KMmMvq5iyHAvw==
X-Received: by 2002:a17:90b:2e4b:b0:3a8:195f:186 with SMTP id 98e67ed59e1d1-3ab3a9fc457mr4519518a91.42.1791691395711;
        Sat, 10 Oct 2026 21:03:15 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:9657:9541:a576:7d2f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38b981b9sm10519758a91.5.2026.10.10.21.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 21:03:15 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 2/2] scsi: qla4xxx: advance the reset-sequence array cursor in poll_read_list
Date: Sun, 11 Oct 2026 13:02:57 +0900
Message-ID: <20261011040257.2017421-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
References: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qla4_83xx_poll_read_list() stashes each value it reads into
ha->reset_tmplt.array[] and is meant to advance the cursor so the next
read lands in the next slot, which a later read-modify-write entry then
picks up by index:

	index = ha->reset_tmplt.array_index;
	qla4_83xx_rd_reg_indirect(ha, p_entry->dr_addr, &value);
	ha->reset_tmplt.array[index++] = value;
	if (index == QLA83XX_MAX_RESET_SEQ_ENTRIES)
		ha->reset_tmplt.array_index = 1;

index is a local copy and is only written back to array_index when it
reaches the end of the array. Every other read reloads the same cursor
and overwrites the same slot, so the array is never filled past its
first entry and a read-modify-write entry referring to a later index
gets a stale or zero value and programs the wrong word into the
hardware during reset recovery.

Write the cursor back on every read so the slots fill in order.

Fixes: 6e7b429259fc0 ("[SCSI] qla4xxx: Added support for ISP83XX")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 44d285af22727..2ac833c5b1400 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1117,7 +1117,8 @@ static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
 				ha->reset_tmplt.array[index++] = value;
 
 				if (index == QLA83XX_MAX_RESET_SEQ_ENTRIES)
-					ha->reset_tmplt.array_index = 1;
+					index = 1;
+				ha->reset_tmplt.array_index = index;
 			}
 		}
 	}
-- 
2.43.0

