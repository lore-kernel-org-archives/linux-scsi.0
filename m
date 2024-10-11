Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD21420ADF8;
	Fri, 11 Oct 2024 08:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728634710; cv=none; b=GdDiLDXiOSQnW+dHu24rRTI6YVmWqw6OFmmV29A3/Cfh5n+3T9RVduDH39LTKL+8xHiPAJd9S7bWFjH+dRZcTvYgl0hmtCp+mn9ER96jAb3LUxdy49GLYTh5NqCf/4Loe3D+qdIuC+ZS31KeMi3Pxzmpjz1tDBytkipTtfl7bLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728634710; c=relaxed/simple;
	bh=rJDqg06l8MlzJW2wyP/JMCBHtMIsuPB8sauLk7bQXo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FcLyUtZbT6rOS2OOug2eyln4VyXOk+yUr0+ZS4YQbHWeP0Sp53XlwfQ4UpT+xtn9yErZWnGtIAs3QAyFqBNiRvMmE+PtolUB8USVnxXlqokXDOYC9H2ynYahvDH/oDvCmGYhj9EYooxYe6WnQtjwvhLm4JGpBQ4vN3RaAgjh29A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SznbwnIy; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SznbwnIy"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20ca388d242so2703485ad.2;
        Fri, 11 Oct 2024 01:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728634708; x=1729239508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0zswoaeYgVW+5VHGofjL2aevGpeDGnZ4Z9y6u1Rv3Ac=;
        b=SznbwnIyPYqbtCRMJ5N1CkYb150rJ+71VPrWv4m2yWouRlDxakjsMlLESzwYbq3HEq
         A9aKjN7EvjmaLPMzoeLqoI7HiytEXxDcDbkuHzQI+QhULRpS/gIBvT7g3U9kwRqbgt3/
         BM3zAzYhI28Sy9gcbBbPCSyi93q5hnJDfDNmzPr7aiX4kY32lnOEVFN/PgiCss31dGoS
         15jfVjLcQOEi6OL4+UkPh6sTzdABH72wCQTmq38xsHgE/ugoOfpUbB90s10E11Up7wNV
         3cb7QQm51oT66y3PDGNOGcRPmcCcKtuade6ylCKyeZjePB7hFSLBDO+Px5YAj7gsbUs9
         4x8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728634708; x=1729239508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0zswoaeYgVW+5VHGofjL2aevGpeDGnZ4Z9y6u1Rv3Ac=;
        b=bjkK6jD2NuMdYkqmdLr1T3Sl5Ye2q0OA0xwEXTJ/Ht7V4p3ivnUopz4OaippkHOFyq
         olEJPgK+3o8+X66s03jkr/3ugtlpNF0VuwbHqZESNYbMNneCUQWJAr4MHqSPVwJHC6BC
         YIvben8OYUQIzCtrPUUyejCnZti9YBurIE+jR1cpYM+BR2OPZ3E7xsKrb5sMvYfUs/ND
         oZYJ53IFZzPBRPCpXwY+6VlLQ3KQ6VUlhSuAdyb7bggWv/mU/e8EyXOQJTW+V2DAG96x
         8HUdygsHZT1dnSAxzEaeWzlj5gNziicJza9faEbbnRwmIdzDw/TiMjbPIpkV8MXA2XdU
         dxyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqyW+EwZE02tvYPsOnE4A5TAJK1vup9XhLgFetFsn0af4rlwL9HKfAkPe6bC+i3co26iSQ5qRmJqegKr8=@vger.kernel.org, AJvYcCVYIIbDGoyPOp2el2d+3vyHh4fA1Qqcjkn785sliv+tEQFXA59gpVjTSsol9IknBbGsGvX82p983dR5SQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwO0CEpe8gyK+CExvA8mmM2LWgZ/Z9BTlNahNAxd2W9f6cTCNy
	KAslclz3Vx86AgIqqZT05B99XLBW8FANGMJuB/lZaMtQ7AvzUjda
X-Google-Smtp-Source: AGHT+IEbW1bwjT/qO1cbJHu4kUayygZL7WnlkqAu4vn6qWRrGEPNQpYGeiFG6oo4j+0pLRCb3AoiRQ==
X-Received: by 2002:a17:902:c408:b0:20c:a1a3:5373 with SMTP id d9443c01a7336-20ca1a3550dmr18549825ad.55.1728634707908;
        Fri, 11 Oct 2024 01:18:27 -0700 (PDT)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0e7866sm19665275ad.171.2024.10.11.01.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 01:18:27 -0700 (PDT)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	ames.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>
Subject: [PATCH] scsi: libiscsi: Set expecting_cc_ua flag when stop_conn
Date: Fri, 11 Oct 2024 16:18:06 +0800
Message-ID: <20241011081807.65027-1-hawkxiang.cpp@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initiator need to recover session and reconnect to target, after calling stop_conn. And target will rebuild new session info, and mark ASC_POWERON_RESET ua sense for scsi devices belong to the target(device reset). After recovery, first scsi command(scmd) request to target will get ASC_POWERON_RESET(ua sense) + SAM_STAT_CHECK_CONDITION(status) in response.
According to scsi code: "scsi_done --> scsi_complete --> scsi_decide_disposition --> scsi_check_sense", if expecting_cc_ua = 0, scmd response with ASC_POWERON_RESET(ua sense) will ignore "cmd->retries <= cmd->allowed", fail directly. It will cause SCSI return io_error to upper layer without retry.
If we set expecting_cc_ua=1 in fail_scsi_tasks, SISC will retry the scmd which is response with ASC_POWERON_RESET. The scmd second request to target can successful, because target will clear ASC_POWERON_RESET in device pending ua_sense_list after first scmd request.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
---
 drivers/scsi/libiscsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0fda8905eabd..317e57be32b3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -629,9 +629,10 @@ static void __fail_scsi_task(struct iscsi_task *task, int err)
 		conn->session->queued_cmdsn--;
 		/* it was never sent so just complete like normal */
 		state = ISCSI_TASK_COMPLETED;
-	} else if (err == DID_TRANSPORT_DISRUPTED)
+	} else if (err == DID_TRANSPORT_DISRUPTED) {
 		state = ISCSI_TASK_ABRT_SESS_RECOV;
-	else
+		sc->device->expecting_cc_ua = 1;
+	} else
 		state = ISCSI_TASK_ABRT_TMF;
 
 	sc = task->sc;
-- 
2.44.0

