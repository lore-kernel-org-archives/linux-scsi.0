Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7F44078D8
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 11:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521198; cv=none; b=W7GHfaQYlC8FycShPjZ2nwATRUAA+PCGT/HLkzUfyoOHcGG7tkICHzpBQbcsbTrFxVN3dN6NWxg6H63FH85DOWfoLvyyFAS+GrtHbTBeucmO7jeopThNcQJa769/UL5x/DEkEitUbTv2Zhzs3lI+RtT9h9f81qFUSSh1uotQZqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521198; c=relaxed/simple;
	bh=RZ4MZ9e4RQQyNNndoqpPLQ24BPocKKnqZON0STdrbE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khnqpwHIOJOxPSmbd3ZUyjVVMh2u4q9D6bWpXrOWe6ijBIQkU9+tvHFMt8S6gWzWVNmWG+oPKrJAJ+MfsE67UPTbPo2zWom3ObEVgi4NOQtNthg4TvspB221QQssPyGwjg/8dBIm3ozrs8JN1O86bM8J2A8nU80d4XHMYGRk8nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUIKNywz; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUIKNywz"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-39b35105ba4so215755a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 04:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788521196; x=1789125996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=39S0vRRIIz0NXE/IhNc4AIAytaNZkeO5JMe/OAcGwbY=;
        b=GUIKNywzTXjNPyyzG9kEWkeYhihsm1t+HeqOzH1Ef3E8jWjiQ+zdNTPIeu8gKVUG6g
         DRdGW6I09Dd47Utnw0BaoKhzft8q/3RQcguPfvtxETwp7KszjoOEL4uCp+5ybPeSKSDB
         3jSNfzqXKe4NQkX0kXjI8AG+JLtf1uffRtXHqTWNl+3CRKKSQzk45smjMqAUpVrnL5fJ
         xSbz8tgt6HkR/vg82ALPo29EoQN67h4veB44LU4xxezwaa+ZJdaEnlt10oAORAIiQH8c
         bjKmVWbJJNXaB9asr0UXWOcz44tmLY7JbLKZ0RY4gUKUk93EawEdDdDqZW2hI1UTz+vj
         bG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788521196; x=1789125996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=39S0vRRIIz0NXE/IhNc4AIAytaNZkeO5JMe/OAcGwbY=;
        b=FXsCfOYQ6br3qkJBg9FNyOSJmAexbx97l2UQ4MQow2jfFKCFFmabA/C+Iv4RuLL6Bn
         jFza5vvrqSjD0YpUxUF88nou5oYprYwFP8wFqb1+Jt8CVLbUSp8VfSIXAtsE6+kLjh1Z
         f5cPHvSDTwNUeOhhYS3992QFRqpVhjVB6gPFtaWiiemyiruQ2nOmx43oIvQ4Uq22gmo/
         hIi6Efa8XY8iHWcVPtRuPMxjcd8y1eD8O1ZY82W9jyTQKB3c5qjLVpMYbQXtXtmHduKG
         Z7CiFwjA+LqbYb3LDHRPv5w2vdshQu3Vxv3A7MCsQofSt8lVDydJq5baP6/4sMEumJL+
         YYWA==
X-Forwarded-Encrypted: i=1; AKwUvBxh2d1mHSlXK/j3cC5RqJEjk72KJN0Yj1n4NqKq+UK1uDQr/jyXh31jfYdmpESB56ptMO0h2WOeo5P/@vger.kernel.org
X-Gm-Message-State: AFuF++kwbNWcOliQ7vFNSTNBMSUV1FnKEysnRvlStAJezn+uNnGFwL5S
	4Bothn9oUY9Ss9uzvasvjOLxYjuhFRhjQWYJVz3q4SN6raeu2c+beU6E
X-Gm-Gg: AYBFou1pjL3eLEvX6/Q83VSAnjyE7IrtRipyBWyhAYmNn8ESyQ4aZo5fR7FVKvQt2uS
	enYTC+qeDcqbVLUOtDCuorr8n9Hw8hW9KS5XMMZRFRHBeltRBbTPv3AtGToLZ+o5LKBHWbKI31y
	+myugXqWT4tBJVzlXQlkxWIHVmLCNTF6Hg+Pey5ylVHawYUREjwH8YP5QQSk8ufWGubXENThMBy
	+ypwHm8zKfV81ALRy6Qb9C2nEK4Eh1GTNUPwS/k5PvwTEfMZDvPOJG/zSkCta8gW9RLLcg2UnMV
	uahuWwVXoCnrgwOlDJyuunp1LtXUfPOp99h4vguz+3iyGiDyZa6HVBZi5KIJFp7caRexYjsp6Pd
	yvs/HmYG9m6mvA1gXIcPdppmSCF8aYIHbN33lI/04klgQbvr0n6aPATWZ78otoSZQ8yt1qupjMv
	4CX+jAsIk1hDR77vPz4as1/OgbsE6BSS9DCuwPjz5aPfhy5xAXtgaiGVr0TXrj6TkOjwMkZPxqF
	hWKqK5jlf7Q6KU=
X-Received: by 2002:a17:90b:4a49:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-39b26100cd2mr7424158a91.2.1788521195861;
        Fri, 04 Sep 2026 04:26:35 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm6698786eec.21.2026.09.04.04.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:26:35 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: isci: fix repeated words in comments
Date: Fri,  4 Sep 2026 16:56:18 +0530
Message-ID: <20260904112623.4208-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904112623.4208-1-hemanth.selam@gmail.com>
References: <20260904112623.4208-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop words accidentally written twice, reported by checkpatch.pl as a
possible repeated word.  Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/scsi/isci/host.h                      | 2 +-
 drivers/scsi/isci/remote_device.h             | 4 ++--
 drivers/scsi/isci/remote_node_context.h       | 2 +-
 drivers/scsi/isci/task.c                      | 2 +-
 drivers/scsi/isci/unsolicited_frame_control.h | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 52388374cf31..e4971ca00769 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -244,7 +244,7 @@ enum sci_controller_states {
 	SCIC_INITIALIZED,
 
 	/**
-	 * This state indicates the the controller is in the process of becoming
+	 * This state indicates the controller is in the process of becoming
 	 * ready (i.e. starting).  In this state no new IO operations are permitted.
 	 * This state is entered from the INITIALIZED state.
 	 */
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index e7c923909920..a8175b2fbee3 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -170,7 +170,7 @@ enum sci_status sci_remote_device_stop(
  * permitted.  This state is entered from the INITIAL state.  This state
  * is entered from the STOPPING state.
  *
- * @SCI_DEV_STARTING: This state indicates the the remote device is in
+ * @SCI_DEV_STARTING: This state indicates the remote device is in
  * the process of becoming ready (i.e. starting).  In this state no new
  * IO operations are permitted.  This state is entered from the STOPPED
  * state.
@@ -180,7 +180,7 @@ enum sci_status sci_remote_device_stop(
  * This state is entered from the STARTING state.
  *
  * @SCI_STP_DEV_IDLE: This is the idle substate for the stp remote
- * device.  When there are no active IO for the device it is is in this
+ * device.  When there are no active IO for the device it is in this
  * state.
  *
  * @SCI_STP_DEV_CMD: This is the command state for the STP remote
diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index e069d7ca78ef..b5c18d48948b 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -154,7 +154,7 @@ enum sci_remote_node_context_destination_state {
 /**
  * struct sci_remote_node_context - This structure contains the data
  *    associated with the remote node context object.  The remote node context
- *    (RNC) object models the the remote device information necessary to manage
+ *    (RNC) object models the remote device information necessary to manage
  *    the silicon RNC.
  */
 struct sci_remote_node_context {
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 3a25b1a2c52d..aeb2cda92465 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,7 +67,7 @@
 /**
 * isci_task_refuse() - complete the request to the upper layer driver in
 *     the case where an I/O needs to be completed back in the submit path.
-* @ihost: host on which the the request was queued
+* @ihost: host on which the request was queued
 * @task: request to complete
 * @response: response code for the completed task.
 * @status: status code for the completed task.
diff --git a/drivers/scsi/isci/unsolicited_frame_control.h b/drivers/scsi/isci/unsolicited_frame_control.h
index 1bc551ec611f..f9c816d9cd38 100644
--- a/drivers/scsi/isci/unsolicited_frame_control.h
+++ b/drivers/scsi/isci/unsolicited_frame_control.h
@@ -118,7 +118,7 @@ enum unsolicited_frame_state {
 	UNSOLICITED_FRAME_EMPTY,
 
 	/**
-	 * This state is set when the frame buffer is in use by by some
+	 * This state is set when the frame buffer is in use by some
 	 * object in the system.
 	 */
 	UNSOLICITED_FRAME_IN_USE,
-- 
2.48.1

