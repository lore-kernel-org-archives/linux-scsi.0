Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD5836CC88;
	Tue, 26 Aug 2025 19:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756238214; cv=none; b=m8XDzvtNZVIWLwBI239NpFytScIxp2Ubzn5+le/qiTY/CLotHdNTCsBPiModX9V+dkXgASId49gP7MANvuR5m4ylymtD5eFSi44UX+QMnnKbSdSlv+hcnb09w2CAeo2C/I2HXP3NxB3G/Nl/Rqql4KEDa06hmcGEE0I0XlVdmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756238214; c=relaxed/simple;
	bh=xJa+W3UokioulPwGvLVtg35a5+SMdSqwOfR7pM6zUSI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JGjP8kNhhiX6zMeQ6nBfs1U39KE63i9SDmVsq4AQqlrv2fJHxyR+laHsQXlMLN4EVS/SALPTXR4VBW95260TxknhcS8HNt6zs9bveSuNwIK3rEf+tbQkascQWZCcy9xsKk0J/V/+BsD0m3ue5Hz1fgMnRToE2BojKx5xFk8eK3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTG1lPK/; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTG1lPK/"
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-b4c1ed55930so2476468a12.1;
        Tue, 26 Aug 2025 12:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756238212; x=1756843012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4vNLOlgD3vPK4LvPKDOvALHCAxJkia83pN01LYsamok=;
        b=JTG1lPK/q1nXvSkVjNY3CTdTNnSCMKbR1DXfhiw2/HF6AA252WwFuPnQcbJjQ1sCsz
         3xv+diTl7XAmh4+tg3ROJFL2QomTVQQfWieKC/jq2ItgQ4JdnUjCAxzMORpfnzXdggzo
         1zdSYGsAtvpN3+7x609kUEk4XfiJ6q3nZmG8wUvk0ufN0HIkPFFkEgUh/mjRxWQlRwR6
         vE1ZPURAhQ2LKzKO2PsV1Dm5rmkcRfLCEfTLHwGv0sOL77Si5LhB7IPXLrDeCY/K+Sbi
         rZ0MnFruqvOIODEq1NKeRNx5kIuRaLw2lUuGKsJNc5GfIpRNoJgy2kr9Uxmw7YcfLAM4
         rmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756238212; x=1756843012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4vNLOlgD3vPK4LvPKDOvALHCAxJkia83pN01LYsamok=;
        b=g/hz3zSdXWjlsY1iqRGvAVSKiGzMopGGO2uKHQgRSF7stjHuqDWjGGbdIFB7d2GHvs
         dvGcYsmL9wfY0OCdjSklzR31D9sdBWt0Ic4MTpGdaVs14iL3L2Zo5SfuawLkOEe2v0EF
         V/3UbW978VXxeDgq6O44KFKPnsIvWFB/ix28Nz9P4OjvpzuYwOWhNSJIE3g3pvziMMix
         Dbu4qjxOR62aOqZUdNNjot+NmYnn7u7t4ydJU0QXcAm0ms0QIng78MNOSNaUCe/8XfcL
         l1q/1ruFdBXZrs0JNqLlqiH6t7y5APchh5HEhpySccjtCB4JAjPZki+iUN3i9/8gxe04
         nNFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfNK9TZ5Mm1ERWOaAurss+tZ5a7sICvtdpxhkBFstYNbDMPHg7XEbtcyohyVhOjn5m6mjIwVWddYLyZd8=@vger.kernel.org, AJvYcCXRPztz6f2mRijPbBXWoCmjSgIC79kW05EZJ+mZaMoTJKazVw1cQ20D0f/L7GxaWD1kyZ5R1R11@vger.kernel.org
X-Gm-Message-State: AOJu0YxPaqK00XUGt9KMyoLSQjWIW4JCBLdpMqaXZdoGvxHGmGwhNNgN
	YP9EeXYWJ6vZyFiiyBsVizHK+10j9BxEcZQq2NLSny0OVBDaj9499JQg
X-Gm-Gg: ASbGncuix5tm895pfpiqgttd5SqsBOb7ZjBEv84WwduiXl+r07eMVxDd4U5lq0D3GdT
	vHQA1IuLEOuOkCmeqbJ7jApfFEF9oMUbXDxWRQP8BuOqHHvPKICr689tlvmvx/tONoGbtp898Lc
	pPNFGfZWlhJIiI/IeGwZMeg93FUqgLGTXWCqxjX1ZbCgrKdgx8MZqjrfmSSCKvMb/GUy7l9BCyL
	vUtbh/FbIe+3KMl/Zum4UE6NN2UB3ACDcCwOZqzVuv+2YqOXYyucV/h7H9JgzsbyRcVVrsfTybf
	eQMAKcz0GAY50RZmTxInj2ZaCsGSAg4iWS5uCpxw9J+F01N6f7GBGIxjhK8GQRYZlBQ76zzv3u9
	2V0vUwMdDiuGu6/euhDTzTvak4yPGyGCH3mrBl293keHcxHAbM48twiP0wMPuUiL5IMoXJwhY
X-Google-Smtp-Source: AGHT+IFfIJ+TQCebVZNnXSchhRPJtNdtNYjqf8pcWiVrCLWy2yGcohk7uncuJrAvb/82tP/d800VpA==
X-Received: by 2002:a17:903:37c5:b0:246:cfc4:9a52 with SMTP id d9443c01a7336-246cfc4a0ccmr102210245ad.52.1756238212185;
        Tue, 26 Aug 2025 12:56:52 -0700 (PDT)
Received: from 2045D.localdomain (65.sub-72-110-66.myvzw.com. [72.110.66.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24896721727sm2214555ad.84.2025.08.26.12.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:56:51 -0700 (PDT)
From: John Evans <evans1210144@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix buffer free/clear order in deferred receive path
Date: Tue, 26 Aug 2025 15:56:45 -0400
Message-ID: <20250826195645.720-1-evans1210144@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a use-after-free window by correcting the buffer release sequence in
the deferred receive path. The code freed the RQ buffer first and only
then cleared the context pointer under the lock. Concurrent paths
(e.g., ABTS and the repost path) also inspect and release the same
pointer under the lock, so the old order could lead to double-free/UAF.

Note that the repost path already uses the correct pattern: detach the
pointer under the lock, then free it after dropping the lock. The deferred
path should do the same.

Fixes: 472e146d1cf3 ("scsi: lpfc: Correct upcalling nvmet_fc transport during io done downcall")
Cc: stable@vger.kernel.org
Signed-off-by: John Evans <evans1210144@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fba2e62027b7..766319543680 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1264,10 +1264,15 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
 		atomic_inc(&tgtp->rcv_fcp_cmd_defer);
 
 	/* Free the nvmebuf since a new buffer already replaced it */
-	nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
 	spin_lock_irqsave(&ctxp->ctxlock, iflag);
-	ctxp->rqb_buffer = NULL;
-	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
+	nvmebuf = ctxp->rqb_buffer;
+	if (nvmebuf) {
+		ctxp->rqb_buffer = NULL;
+		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
+		nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
+	} else {
+		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
+	}
 }
 
 /**
-- 
2.43.0

