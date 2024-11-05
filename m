Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37F71D61BF;
	Tue,  5 Nov 2024 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730812156; cv=none; b=Y7GgHu2n3nN2SR9mqk39y3iuJ4/ygesahmrR1dgjGrFFNicI1W2+KkOmBVrFYExebhwpjhoN7YB0+zAfLOSqbfR6Vh2uUCj2gPUGqP9Co0ZheEyzfWsnIVXiQExN/sFFP7REWtTmcn/0L0RJrpYq5szNc8ETrLogReWTvr0K8Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730812156; c=relaxed/simple;
	bh=DVPfp6KGwwMItlmqw72swXe0/qshydUKTIJ5gveB9rs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PIrnfyCfj+zdzHzNiajTHKvX3l/KFw02u5QFABxAufVPF/ss0Js9MJjD3A9V0XejDsavajXDtwX8vaAuLpAn970OVYjUV5CJN2ofBJEVw4HA8GepziahjxRAgEBYqitLHrWs1R9d7WH80SgGXHDokO4wklgWgqBENmmuQCZpQhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHX3yFMM; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHX3yFMM"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-20e576dbc42so56315075ad.0;
        Tue, 05 Nov 2024 05:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730812154; x=1731416954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pd+t2u3QvsPX1cIumIVDb+Kou2m+XAm5CTqIIKxI2Uw=;
        b=ZHX3yFMMvGnn0Qxu+E83H/ml5e8lOl0dHcwPYu72dOjJeCcXY+riLExtWoxQNqFTpW
         /mReuahSdou7O6tx+xi+FEXyQ4jM/lyv8V/6v6/EptiXSeWkENwulfOoIT4h9IIf3NoM
         F5nUDgOHfavoflsQGemwvQmwR0TaFo433LRpJ2OgarDwqryP18CCE2MEsLx+DNaERgXx
         HsW94t4MW1OW5LsZet9iMyNFe3p7BkL46qnAvfgHVhEidINQerzxoiFZyYFw0ErUvHj8
         CJqB34D2Egv53s8mdN6OaJsWk1qhb1KdtjqiQE9Jh45Rk1P/wffHEB6EWYH3TiBfZ0qk
         2OoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730812154; x=1731416954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pd+t2u3QvsPX1cIumIVDb+Kou2m+XAm5CTqIIKxI2Uw=;
        b=I7tJk4gtMhde0c4xgSg10IkBVez7RxUZKsh2s2NGu1LZncQhIasiyo6Aqfb1MguZgb
         lakKYV4l3/OHGCHChclIX5goUBvVMhG2JLP+VAzwE1j8T+hudaX1V40T73r4rtxvRwX/
         oJBsVlsRSgOBfOhmtVT7J+1RbWJRcrmoXAdYC0vhix9rIduQNbhCh9ykIJgQPOi00z8p
         EimU2IHol3BVgpcPsVWtZojHcPLFLH5i5IRhxVDjfnYwWbAYPXc/sgKRHmS6WMB9gc6u
         9cVzMVf8WGOMGVVc1I+KaiMUFnUe0seq0FHPL5LuxyiA+8Rp/CW7wvTHtsFiJ0BKktDI
         joiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVhhocJ7e7zaFG920r9VYCSu9PWBUpN1EO8nA7d7dPhLh4JWY2wT2uAu1m9OShQjm/vhsfMWKl+JaSmLE=@vger.kernel.org, AJvYcCViZxFSMDydt2IPn5vX/g54wYWFB12fk2GcUHfGVNGvI1Etn1jUdQ5RkSSzQvWQ3KtWOQ54t0IN@vger.kernel.org
X-Gm-Message-State: AOJu0YwiKKbdZjgYdBPzaC8Rh5pynFRW7kkYZdGedcMMqRGjO1HoI8+T
	uGnFU5A7dK7btBEkC9ivfhQ89+/EknsS1kL17tvu7obYyHVX82tY
X-Google-Smtp-Source: AGHT+IFSld5Dtzy9w8oirg/pkVwIv0lEqyttvUVu9GEQ9my5sCZbENiAWf5cmUvcRIWeWc2bJ0HxVQ==
X-Received: by 2002:a17:903:2443:b0:202:28b1:9f34 with SMTP id d9443c01a7336-21103caeba3mr290569015ad.56.1730812153849;
        Tue, 05 Nov 2024 05:09:13 -0800 (PST)
Received: from tom-QiTianM540-A739.. ([106.39.42.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2110570ae27sm77316175ad.101.2024.11.05.05.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 05:09:12 -0800 (PST)
From: Qiu-ji Chen <chenqiuji666@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix improper handling of refcount in lpfc_bsg_hba_get_event()
Date: Tue,  5 Nov 2024 21:09:02 +0800
Message-Id: <20241105130902.4603-1-chenqiuji666@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch addresses a reference count handling issue in the 
lpfc_bsg_hba_get_event() function. In the branch 
if (evt->reg_id == event_req->ev_reg_id), the function calls 
lpfc_bsg_event_ref(), which increments the reference count of the relevant 
resources. However, in the branch if (evt_dat == NULL), a goto statement 
directly jumps to the function’s final goto block, skipping the release 
operations at the end of the function. This means that, if the condition 
if (evt_dat == NULL) is met, the function fails to correctly release the 
resources acquired by lpfc_bsg_event_ref(), leading to a reference count 
leak.

To fix this issue, we added a new block job_error_unref before the 
job_error block. When the condition if (evt_dat == NULL) is met, the 
function will enter the job_error_unref block, ensuring that the previously
allocated resources are properly released, thereby preventing the reference
count leak.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and detecting potential issues where resources are not properly managed.
In this case, the tool flagged the missing release operation as a
potential problem, which led to the development of this patch.

Fixes: 4cc0e56e977f ("[SCSI] lpfc 8.3.8: (BSG3) Modify BSG commands to operate asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 85059b83ea6b..832a5a6dd85f 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1294,7 +1294,7 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
 	if (evt_dat == NULL) {
 		bsg_reply->reply_payload_rcv_len = 0;
 		rc = -ENOENT;
-		goto job_error;
+		goto job_error_unref;
 	}
 
 	if (evt_dat->len > job->request_payload.payload_len) {
@@ -1329,6 +1329,10 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 
+job_err_unref:
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
+	lpfc_bsg_event_unref(evt);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 job_error:
 	job->dd_data = NULL;
 	bsg_reply->result = rc;
-- 
2.34.1

