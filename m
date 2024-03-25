Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A1B7F7E8
	for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406886; cv=none; b=CxBfW9UbaWSQ+oTCWkt9tsSotUqkzJHswIG5L8oG57Q0c97MGQxcZA7biMIcWU3ieXmgsiOGgT/d4ka0GL0NsHQAs/8caGddLqwDbMzVHCToyLSYLW8ABN6dCVql14bh1atXKF8eOo6G5MZf5dyOoYPbhvTqvmRn/Ix12gL39R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406886; c=relaxed/simple;
	bh=oWaGwFAbq1hQt6IwyBQmWWcrvfGE6Uu32YM9ZnXUAr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gogSo11bQttE4J/6KkyrLD2XEAt4jOWdUDBLzgbPJZVBB60P7Ipu8J3gGkPdpiGmmxfXCgmTTweZ+iKqE8yeJtGlfTMdkngDQnB7D2mjHqXp5efE/u+XPQEB87kXmw99EhA5YOPuLZTZ2/j2ezel8L60x4+YjcCpswCiy5iFyNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6a9fafacdso3691724b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 15:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711406884; x=1712011684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UlYuPM+tiIM8YfXCnOC8j2a3ZvRig7UALW2DJ19FIks=;
        b=rtnWrabS+4S84HmvwpVifpXpOku5OHl3ium4fb26B2XazZh2xItoLBP+1iYWKuCmp1
         Itd7fRUnTPD6Np5rMPNrhAJO0ic6ud68y0sy/RtlLsrXB+uPMeOGOdUfWE6fsuPfHbzb
         sJ2I+rVYnVna0RgD0snOpGXcu+KqkxMq+qs2OJNDdngTcWG6Gpwlx5MpYN2NWdPutsFa
         LPAmRfRhZh1Lu27/HFr3+4H6IqgAPyWwSp9v+dj/kvDTMMrOITzZP18SToj9Mt68wHtH
         SYuYL3jsIkF0Log4kXxz7syOBqpW973JeEbzVXgp5g3euMHYgpIZvJsB+mR1L9p7BLo4
         dKrw==
X-Gm-Message-State: AOJu0YwlwADqbaKfJn/Bk0icR/X4g/FfNP03D4dISElyAyvmBCBeBDCG
	1m3tffHmul6nNFNx159pw80//Os2tp6r33T/UL4EOIRKeScHFPmllk5npTqv
X-Google-Smtp-Source: AGHT+IGDYRRsKik35UJB5c292a4zQ335j4exkm008WsyKJcadkNDkvwy9FEPXuIED6OT/N6/rtYDmw==
X-Received: by 2002:a05:6a20:4306:b0:1a3:5c60:112a with SMTP id h6-20020a056a20430600b001a35c60112amr8641635pzk.36.1711406883851;
        Mon, 25 Mar 2024 15:48:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id z10-20020aa791ca000000b006eaafcb0ba4sm1582565pfa.185.2024.03.25.15.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 15:48:03 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 2/2] scsi: core: Improve the code for showing commands in debugfs
Date: Mon, 25 Mar 2024 15:47:54 -0700
Message-ID: <20240325224755.1477910-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.396.g6e790dbe36-goog
In-Reply-To: <20240325224755.1477910-1-bvanassche@acm.org>
References: <20240325224755.1477910-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some but not all command information is cleared by scsi_end_request().
As an example, if scsi_show_rq() is called after a SCSI command has been
allocated and before SCMD_INITIALIZED is set, .cmnd holds the CDB
of a previous command. Showing that information in debugfs is confusing.
Hence this patch that restricts the information shown in debugfs to
valid information.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debugfs.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index d4eaca7cc952..eb52e39f37c9 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -56,16 +56,20 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
 	int timeout_ms = jiffies_to_msecs(rq->timeout);
-	const char *list_info = scsi_cmd_list_info(cmd);
 	char buf[80] = "(?)";
 
-	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
-	seq_printf(m, ", .cmd=%s, .retries=%d, .allowed=%d, .result = %#x, %s%s.flags=",
-		   buf, cmd->retries, cmd->allowed, cmd->result,
-		   list_info ? : "", list_info ? ", " : "");
+	if (cmd->flags & SCMD_INITIALIZED) {
+		const char *list_info = scsi_cmd_list_info(cmd);
+
+		__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
+		seq_printf(m, ", .cmd=%s, .retries=%d, .allowed=%d, .result = %#x%s%s",
+			   buf, cmd->retries, cmd->allowed, cmd->result,
+			   list_info ? ", " : "", list_info ? : "");
+		seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
+			   timeout_ms / 1000, timeout_ms % 1000,
+			   alloc_ms / 1000, alloc_ms % 1000);
+	}
+	seq_printf(m, ", .flags=");
 	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
 			ARRAY_SIZE(scsi_cmd_flags));
-	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
-		   timeout_ms / 1000, timeout_ms % 1000,
-		   alloc_ms / 1000, alloc_ms % 1000);
 }
