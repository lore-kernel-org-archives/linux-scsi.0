Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660DC48A2AE
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853598; cv=none; b=YjUslZ/AQSS837VAsE3mXBdIgEY8JuQQ4U5C7wJ2E8+3sZRg/LdJI5FnGQfB6T1cigfgiiEWL7yDD/dm/TDknf/BRsShaAbWNr5czho+ozXkD8f5o2QXsOwhBNdHRLLLbBCo1iBFGZX0YBCRjnRe0dJXblCS4uohmzPVatKfXJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853598; c=relaxed/simple;
	bh=b1kYvevH+ajEE6MrstReQxnYaz40xOpSACY3LJm0wsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l/fPK+ucCdk0xgPFCaDHaJz6IFBoDi8OFwLmBjMA3DQ+HOorbWKhe/Kb2sE1uT30HcAVW/qQKmDGIlKVxwkUQpxczlw+fRckSSMnat55b0Q09liXAwvKx5UlYSfuIsgA7PFrkXup0Qqd799pCaQsb5dO0DWi9+q20eUJFHlL7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=dwUUgb6j; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="dwUUgb6j"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9103019f8c4so330281885a.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1778853593; x=1779458393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mF62S8ulVvnT3KPDUypySvJO/oTH9erKA2nq+/SzcdY=;
        b=dwUUgb6j7G5fIIJq340ASR7DPS4HCHS/9tEjVobrQ9gPtTFfC6Qg4QlhcyaxMKT2/4
         EqVOSuhJQyQMEkF47oE7TK/F5DVeSwoUsuJDa+tIWZrpBdjWA2u18NYiP7fzHne2lSH6
         uH6fOuyiS3P+bkh8qLideuNIou0dRiTfsWPnGjqtf38przwyuem+8caGRJ0fsJw9eCyn
         CCowUhEsc0GgsTHDCXWaLj8LFf3Q/NN18lKWfvcXXQ/wR7j2IV/nmercv5oSYqntikXX
         tzrpy98dHNqxn0pCRhc0Dj6B1kpKQtFfnjjmj8o75ZrpXlt1iJeeJw39dQxu4n05LnL0
         iN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778853593; x=1779458393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mF62S8ulVvnT3KPDUypySvJO/oTH9erKA2nq+/SzcdY=;
        b=Navng24SrLQFeMGGUfZpMpbhqhx3cS0MAmq4EJ2s8Jx2ZzO7uba6E93MybA1cCovQf
         WvJW7vg/7+PL7+AsBtYxjTj69iA7lE0w3+52IfUluMs9LjU9GqpLF2stLB/JcxcYUseN
         lEIHuIj9fOH3De2JzFWawnaxge9U3v0XvCwHJdxFSM4oI1odjbCo0hmyV45PS3Qoh8A/
         YBUEvQxdGHNt68JRcTHrrgjXr9hiszrPEJlFQQgdgvpCzD5qGNjmxDxXZqfiL9oWZqRQ
         X60TfW+KPEN2dazYFbMDD7cK3YDmFNY1xz6PyYAsZxIrpHqw4403hF4OSQcoxWuDjeav
         GFBw==
X-Gm-Message-State: AOJu0YyZwaXK+zTmf0ZrRXtWs3INCo6eNTcGPg+kkavhLSLCarJc5Nmr
	V4NW2H3nkgWO0u1/J1lJlxv9bROwg2Ubh99SW+KfcLnSC9nqstcF4vEyfrbOWvQTvCI=
X-Gm-Gg: Acq92OGrG+lQtdsNvQcJdT7H3CaQ+F9K5FW/QHnfz22yoAKnPz5ocUW4WZuSjDI5iuU
	J4d+QFTaWAfURQg1BZ40ZZkDuhTOWqDXb8y+yqhJV1rlSqqbeOvnuCLAkeaBov252z3h2rJ115h
	5ydHHnnCR9+f1jcp8L6OI7WH4UNIVIKXuYDWKCK5mslNyu0jlMo6x8pxqyrcmYiflCTvAzkaAg/
	n0hTpQLr+xPTN+eTb0uaiIBiJTNTWCaOUFrwRwW4lqgef21aCMZB271QuXV5WZDzhVu3S5zCE0m
	qvVMxkA0hullNQXDtzqGE70fqZC28PLSraOpumQBKQLoV1aEYb9SErUX4lcigz1jCJHBcERwa+j
	kpc7BEnhuoG1Iis0Ui36ZX/EKrCYkDxak5TszE7Vh1eNgHO90Pp13XNLMn3UfoebM6QQPE54A10
	S6S4VU5H6d3ek2JDCvAx7A4g37vZy4xyi5Z7iswfs=
X-Received: by 2002:a05:620a:2685:b0:90f:786c:8949 with SMTP id af79cd13be357-911ceefeb15mr654072685a.41.1778853593204;
        Fri, 15 May 2026 06:59:53 -0700 (PDT)
Received: from vinp2.lan ([2607:fb92:1900:6734:902:ab48:6190:9c1e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bc8408f1sm550564985a.24.2026.05.15.06.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 06:59:52 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-kernel@vger.kernel.org,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 08/11] scsi: ufs: Use trace_call__##name() at guarded tracepoint call sites
Date: Fri, 15 May 2026 09:59:46 -0400
Message-ID: <20260515135946.2238888-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vineeth Pillai <vineeth@bitbyteword.org>

Replace trace_foo() with the new trace_call__foo() at sites already
guarded by trace_foo_enabled(), avoiding a redundant
static_branch_unlikely() re-evaluation inside the tracepoint.
trace_call__foo() calls the tracepoint callbacks directly without
utilizing the static branch again.

Original v2 series:
https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/

Parts of the original v2 series have already been merged in mainline.
This patch is being reposted as a follow-up cleanup for the remaining
unmerged pieces.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..07f3126d2a94 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -421,8 +421,8 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba,
 	else
 		header = &lrb->ucd_rsp_ptr->header;
 
-	trace_ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
-			  UFS_TSF_CDB);
+	trace_call__ufshcd_upiu(hba, str_t, header, &rq->sc.cdb,
+			       UFS_TSF_CDB);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
@@ -432,8 +432,8 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(hba, str_t, &rq_rsp->header,
-			  &rq_rsp->qr, UFS_TSF_OSF);
+	trace_call__ufshcd_upiu(hba, str_t, &rq_rsp->header,
+			       &rq_rsp->qr, UFS_TSF_OSF);
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -445,15 +445,15 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		return;
 
 	if (str_t == UFS_TM_SEND)
-		trace_ufshcd_upiu(hba, str_t,
-				  &descp->upiu_req.req_header,
-				  &descp->upiu_req.input_param1,
-				  UFS_TSF_TM_INPUT);
+		trace_call__ufshcd_upiu(hba, str_t,
+					&descp->upiu_req.req_header,
+					&descp->upiu_req.input_param1,
+					UFS_TSF_TM_INPUT);
 	else
-		trace_ufshcd_upiu(hba, str_t,
-				  &descp->upiu_rsp.rsp_header,
-				  &descp->upiu_rsp.output_param1,
-				  UFS_TSF_TM_OUTPUT);
+		trace_call__ufshcd_upiu(hba, str_t,
+					&descp->upiu_rsp.rsp_header,
+					&descp->upiu_rsp.output_param1,
+					UFS_TSF_TM_OUTPUT);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
@@ -470,10 +470,10 @@ static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
 	else
 		cmd = ufshcd_readl(hba, REG_UIC_COMMAND);
 
-	trace_ufshcd_uic_command(hba, str_t, cmd,
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1),
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2),
-				 ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3));
+	trace_call__ufshcd_uic_command(hba, str_t, cmd,
+				       ufshcd_readl(hba, REG_UIC_COMMAND_ARG_1),
+				       ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2),
+				       ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3));
 }
 
 static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
@@ -522,8 +522,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-	trace_ufshcd_command(cmd->device, hba, str_t, tag, doorbell, hwq_id,
-			     transfer_len, intr, lba, opcode, group_id);
+	trace_call__ufshcd_command(cmd->device, hba, str_t, tag, doorbell,
+				   hwq_id, transfer_len, intr, lba, opcode,
+				   group_id);
 }
 
 static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
-- 
2.54.0

