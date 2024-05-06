Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47888335B5;
	Mon,  6 May 2024 12:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714999143; cv=none; b=T8DYVeixdjZx6tFdlL4GIrwuTa74spWa5Y+cZZQylzScgvltjMhMMSSI/tqWbdW8Y6Glju5qVZjdRmpK+EooVnvkF5pAhBcRgHKDINQg0GuAWZ+HGQDDVDTvdRULq/oElOcVwtZbvGlMbmoe7NAj27/y8XBfz4PqatITMNxsn1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714999143; c=relaxed/simple;
	bh=3Xlpqb/h/LbWUA++nfPRA220rLCTMZ3RCe9XHjr+l7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hxLk2APawU0vJ67ictwAAbDVhgDBw5CjUMFrti7Y4yIFEniuQHCMXCJtgcMI1c39QDrkfhmRufTbyxINzdVG2cORTn424q8xEEE3ReiheAaZsq2wuvm78GDhpnS2LB05B/rqYfosyaxzfELqqhyCHvkkki0A87UEzjq6A9r5vk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGSN35JL; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGSN35JL"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f44bcbaae7so1398483b3a.2;
        Mon, 06 May 2024 05:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714999141; x=1715603941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Hkuj0HKDvuaVZat/vZwkf1H5ug1+hqs2t9w9FcU+/I=;
        b=gGSN35JLsPNH1XqkPHO8i3MeEdILygGEEuyn8wn7QiJhCfbZe2iPBxy4amaBQKM2FG
         UMLJrVmLraB5eH5xSSywDedEtcR/Tu9umhmvhPys1pikPFNTN3474gyyeKr+clIqmXmB
         Kvml3jvMkMQKsLx5wz2IstzNDujSYbMJcz5Sdnmsu1E8O9JXG+nMUFmrgbZmGnnKx/d2
         fy4E/pwGIDp40FLxW+7ULFP66fYGMLplkkuyqbCUlrOW0fyFgviNgJpo4hDnHpHK70G9
         E9M7fTmhu8Pb0Rn0S/XCfg+9+7gnWdzdynFAJ3jPtU5fyO1h515HDiRGPkzlWN2ZpmEz
         vi8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714999141; x=1715603941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Hkuj0HKDvuaVZat/vZwkf1H5ug1+hqs2t9w9FcU+/I=;
        b=fbb6eoqf2I9YsjeEj8b6pnyKDA1L/d4A++wPSj/xIgqSAL/TMq+Z3Nu7VYWEw3PPtX
         drdqISv5xiWsudK1o8dIA+dhg9vL7w5JT/Dn1m5OG0BRQn51Dh24O0yO3Jta2UGaZ7db
         5paxRWHT6bAkZlUxl0+aie84OZbgm1EO9n1zrc+R1kOdj3ypnh5SCrD8GzCFlFRioYQq
         ZhSJOzNd0wdX31lScsZj0cdQFYSKRzhNdCJJyKwgnm4DTiFJrROTDXEJA9o92OsR/TA/
         cwqULPQeT87+Y/B6bx5SDMsH0QBW3uFqd7bFJa6UREBKzWE1hAaAbX9QheKfELKSwrJE
         Ab8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUoJui2aAObA+IszgDNHSYy3f80Qgk+GJWmq98MF4KCTPbEHfPC1/29HTxxuN4yN7FNwhf2lEt/5sbP3yFLl2QFnAbIpxs8gXFBEm7QZ4QYswjUua7rjlj+kjSTYE39jbo00lVqCkVswQ==
X-Gm-Message-State: AOJu0YxxafMtjWpQNXz/uZdcbxzF0gTWfo6l3xkC+rL6zAhFbrOm33bl
	u2bDWIWRJF71kElf6QtuKN/JuzDNfoq2yQEhmVM3tVtUZOLddmYp
X-Google-Smtp-Source: AGHT+IFkngSnVvSFrcNDs7AF9Vc61JHe4VaYwZt/7TDSFo4ybVjBShyMNDwQ4zSEqBkv3eixDs/flw==
X-Received: by 2002:a05:6a00:93a4:b0:6ec:fd67:a27e with SMTP id ka36-20020a056a0093a400b006ecfd67a27emr10838652pfb.1.1714999141374;
        Mon, 06 May 2024 05:39:01 -0700 (PDT)
Received: from VM-147-239-centos.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id w6-20020a634746000000b005dc4829d0e1sm7940433pgk.85.2024.05.06.05.38.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2024 05:39:00 -0700 (PDT)
From: Yongzhi Liu <hyperlyzcs@gmail.com>
To: skashyap@marvell.com,
	Markus.Elfring@web.de,
	njavali@marvell.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: himanshu.madhani@oracle.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jitxie@tencent.com,
	huntazhang@tencent.com,
	Yongzhi Liu <hyperlyzcs@gmail.com>
Subject: [PATCH V4 2/2] scsi: qla2xxx: Use common error handling code in qla24xx_els_dcmd_iocb()
Date: Mon,  6 May 2024 20:38:35 +0800
Message-Id: <20240506123835.17527-3-hyperlyzcs@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20240506123835.17527-1-hyperlyzcs@gmail.com>
References: <230af978-c834-423b-8d42-78c164be40b9@web.de>
 <20240506123835.17527-1-hyperlyzcs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a jump target so that a bit of exception handling can be better reused
at the end of this function implementation.

Signed-off-by: Yongzhi Liu <hyperlyzcs@gmail.com>
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index faec66bd1951..a3a3904cbb47 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2749,9 +2749,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 			    GFP_KERNEL);
 
 	if (!elsio->u.els_logo.els_logo_pyld) {
-		/* ref: INIT */
-		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		return QLA_FUNCTION_FAILED;
+		rval = QLA_FUNCTION_FAILED;
+		goto put_ref;
 	}
 
 	memset(&logo_pyld, 0, sizeof(struct els_logo_payload));
@@ -2773,9 +2772,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		/* ref: INIT */
-		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		return QLA_FUNCTION_FAILED;
+		rval = QLA_FUNCTION_FAILED;
+		goto put_ref;
 	}
 
 	ql_dbg(ql_dbg_io, vha, 0x3074,
@@ -2784,7 +2782,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
-
+put_ref:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return rval;
-- 
2.36.1

