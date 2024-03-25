Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483597F7DD
	for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 22:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406884; cv=none; b=N+exjjTQYzDjA2MvQWaAopTlocM0L9Gmku3dFx/cYqvqchX9IAqhAIy4DuyrqxAK8wRynasApNVR/4musvc1vCRz2nDb4FhhS3FVfDFMHDc+GSwPMjYnWwOpe9ZLba3htQHqUUZG73dL1qQ5nRYiqI3KI99Jd/fwX832sxd5sqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406884; c=relaxed/simple;
	bh=SUIEKMxgRNINV53SsoLAcOihS6rqNFNJ3fzEsnmfHgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwvM1WhDOwRtG2yL8sJKnNJWEKlRxF7zYagGVj0Hcb3nP7PK28yTDtCiPfv4U5pDBEGjzW794WQQ5Vg/amtmIBV4uurWgO0mFURps219eeW88NLq1GPxjgq1oE7GUAYZXbdTqvdHtRnspAS8ZvM6dSWDlHCrvnL7ATGNkat61js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e704078860so3432649b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 15:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711406882; x=1712011682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+KM/Dx9Pz+gNMPU1Rnv53s17ws71jNsxjvaPJkYo9g=;
        b=byTxmNI7hpxJqd7ZpoDIbio93WwEMcS6EHvgrVcxrjzx33mDmHWjN4Fox4x3WPCB60
         /8jFecQ7ZFOFEs/W7gOoNft0baOa5wlGHKvQImbgs/l/5L0IUbv9aqW5Z2usTagH4l1H
         7iLEuAlddpXXsBTOeqT8dRX5UJCUuVr9/95Ux3BhX8JarkLT2rqlG0/P92PHqSepHomb
         a0wFu9jjCBlwuyVYt1pFbb6mlY3Im0LwpcPLr+CXhxMAKP6h5YNbisVeteeipBTRy6Wu
         VLbxbtpwCnNveJrYTnIajKHSkwURwiMetssJC9SDRIfsGg07xwiHRtcXEQwLpa0TSFah
         nBtw==
X-Gm-Message-State: AOJu0YwdU+yTB9pmv+9NoLh0JkOzZExwMSmKry3gd5EPGP0Y/1BZhNWJ
	WieTDFkyoRHHyBG0LHeA+bdcGY60gOuwbf1Hj5QpWJnH5JzRPgoCBFtR3zsn
X-Google-Smtp-Source: AGHT+IF3Mtu/5IxdfycYPzEzr4YOMkCetjCd4tBWSqj1OlmugDxhChW8sZyqgp5K9uGPWCIUQg8/wA==
X-Received: by 2002:a05:6a00:1829:b0:6e6:1f10:9ead with SMTP id y41-20020a056a00182900b006e61f109eadmr9137016pfa.27.1711406882376;
        Mon, 25 Mar 2024 15:48:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id z10-20020aa791ca000000b006eaafcb0ba4sm1582565pfa.185.2024.03.25.15.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 15:48:01 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/2] scsi: core: Introduce scsi_cmd_list_info()
Date: Mon, 25 Mar 2024 15:47:53 -0700
Message-ID: <20240325224755.1477910-2-bvanassche@acm.org>
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

Slightly improve code readability by introducing a helper function for
deriving the list information and by using guard() + return instead of
goto + explicit unlock + return.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debugfs.c | 40 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index f795848b316c..d4eaca7cc952 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/seq_file.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -32,31 +33,32 @@ static int scsi_flags_show(struct seq_file *m, const unsigned long flags,
 	return 0;
 }
 
-void scsi_show_rq(struct seq_file *m, struct request *rq)
+static const char *scsi_cmd_list_info(struct scsi_cmnd *cmd)
 {
-	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq), *cmd2;
 	struct Scsi_Host *shost = cmd->device->host;
+	struct scsi_cmnd *cmd2;
+
+	guard(spinlock_irq)(shost->host_lock);
+
+	list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry)
+		if (cmd == cmd2)
+			return "on eh_abort_list";
+
+	list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry)
+		if (cmd == cmd2)
+			return "on eh_cmd_q";
+
+	return NULL;
+}
+
+void scsi_show_rq(struct seq_file *m, struct request *rq)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
 	int timeout_ms = jiffies_to_msecs(rq->timeout);
-	const char *list_info = NULL;
+	const char *list_info = scsi_cmd_list_info(cmd);
 	char buf[80] = "(?)";
 
-	spin_lock_irq(shost->host_lock);
-	list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry) {
-		if (cmd == cmd2) {
-			list_info = "on eh_abort_list";
-			goto unlock;
-		}
-	}
-	list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry) {
-		if (cmd == cmd2) {
-			list_info = "on eh_cmd_q";
-			goto unlock;
-		}
-	}
-unlock:
-	spin_unlock_irq(shost->host_lock);
-
 	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
 	seq_printf(m, ", .cmd=%s, .retries=%d, .allowed=%d, .result = %#x, %s%s.flags=",
 		   buf, cmd->retries, cmd->allowed, cmd->result,
