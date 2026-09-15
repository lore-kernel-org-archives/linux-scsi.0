Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31B147254A
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463754; cv=none; b=QbAwe/6PM4oE+wU4WCrz/HTbGUKqnyCUxR+nooe36676X4sFnJPwVlmvmHNW2VNYE4WMtsQ4khiIFFDx1NqxrpvtICuGUwtORScUIkMmIWFVfo98ZPLvFFxBgsSUJP4VPhtIHzSaEwZjbAKqneTgLxrc3xbKuy0k7gHYb4pPk6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463754; c=relaxed/simple;
	bh=Hlr9Ut/EovEIElNh/ZcSjW6ek2j9qSFL+qKjDzPgPE0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tDBz2l5OuYxW0Yo5pHcaFyMMPjDXvVnA88hIWqwjUTgmAerYHE2LLh54UI6VPm5hFxjLm283DoI7r4r7K4KGpY17AnuG5JwfLJi9NfQLTmHs+P4hPv5LN2PEOrDoaLHG8T2I0S4kY42jJBBzHGT8yCGtk1VQwV7g3J/b9zHndr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ggcircuit.com; spf=pass smtp.mailfrom=ggcircuit.com; dkim=pass (1024-bit key) header.d=ggcircuit.com header.i=@ggcircuit.com header.b=ZxIDr+HQ; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ggcircuit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ggcircuit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ggcircuit.com header.i=@ggcircuit.com header.b="ZxIDr+HQ"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9106feddbdfso35316646d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 02:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ggcircuit.com; s=google; t=1789463751; x=1790068551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iLK542vtUaly/RpbeUB/EH4PBRh7qkRiR6AHFszoPZg=;
        b=ZxIDr+HQnoLwlj+DTWhlKIjsu0gm5LRR0iYr5bxOTRTwYzQd9cfr/HlpDet/fOAqQU
         SbPmI2qZ4hR4BmNw56cZ21DfwF5tRB9CDHzLA4M3cCIy4++Cfod/YDvEbHY+O0rwneOv
         8HymReQUZMy5+qMP6Gh6Z/fRVivOmmLJGy2r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789463751; x=1790068551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iLK542vtUaly/RpbeUB/EH4PBRh7qkRiR6AHFszoPZg=;
        b=GLET2Guh05rw3EKOudr1iSlNqswEaoo2HTtM4KRJySxwokzkl9je69iJaCqBotWqnp
         0pXEBB/1HG+tFOfghbA2NyyW0LDMulqKYAMDkAI5igKXrQAP7DnsP/FVhA832rm7CSom
         +MVyQi7KyKYK9ydH9R1Pbrze57FUwRAeOmX3/Uf+w+3Lg/n/bKi50FJC2bxdq/dsaEO+
         GM/XAp9cAkGJKc5nW1Z+VkH+YZQ4o8Ku+JiCZbCZyKN0m8y49VA3UxtHFapQdV/fMCP+
         cR+vGthzF5p6EhZGaSd8QZXc/OcUwGXfhFxYyaiYMjr9NQjT9RIC/3aBGySoP/e3MDX1
         TdRA==
X-Forwarded-Encrypted: i=1; AKwUvBxgOM6kZMruBcSmNT+CCRvO+93BU+nmuiNFEmUd/dw5yr4HKkOn18WkZF5ePEiGhq3JWJzzZfTMH+Ud@vger.kernel.org
X-Gm-Message-State: AFuF++ltcMZwuqWq79Np0vNiPaPcKzjLOze91VNw9RlDlrCJdC0gVwM1
	ctkrLZ8z9c5v3E2Kn0gaLOGQzu9Akmhm52zLm3n04XNUlH0EtWqpendgBIFewD5LRzQ=
X-Gm-Gg: AYBFou1JYxbFlYqizXK3Y0kbN8bS/xpAtTlAZ2/u4f29Jy8LG21YvSxptYYFq1s7GqO
	Hye8uzOfbW1H6peT9JbV+mOPyRA9QeaFniZtZz0gWALTGgLh9LpvOigZK13zn99FOuAiIpLNddS
	LiLA+2fJNBUZrtXKuXH1nXCb24Ko6eK7pYLRXiJM7VftiMB8avpO22+SorkK3N8JwVrhiSZKRRQ
	W6H3jajbpfR7HdR1gX+uR7iHoXHUgoQ5SMUjj0vnM8guUn2vVFEitr5RXXCbZZVE4tUgozAduVl
	zPQYf0+Bo3QNZrXgSnylDacszYoD0lE3fiC3ct47UOJXRQX4iXOmBIR6uNzljpw5La10zakiekm
	buNV8HufbSj8J/wDz3+E54MskOU0DEYcQYFRBc7qHS13I6ncR2aLgzzwsCfvW9rGWFkD9czJkLu
	m9Ljv6ved4b32KfMpRHcxNkxEpws7NYzFUViRQIWoTBSmVobvgtiE1PkwJenWuRRC+9TKUsi5iw
	4IWbmv/RinhWmnF1OkOLvl8xOl8D/vXEg92KWE71zHGapxJRQxStEcbG5KsyIZ50fNrS6IYSjAY
	1ucuCzL++2hv/u1dog==
X-Received: by 2002:ac8:5a09:0:b0:52f:acf2:110c with SMTP id d75a77b69052e-5310cf1b729mr102021661cf.3.1789463750713;
        Tue, 15 Sep 2026 02:15:50 -0700 (PDT)
Received: from dcf96c429d24.ec2.internal (ec2-52-87-229-18.compute-1.amazonaws.com. [52.87.229.18])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d35a9sm116773406d6.41.2026.09.15.02.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:15:50 -0700 (PDT)
From: Dmitriy Polomoshnov <dmitriy.polomoshnov@ggcircuit.com>
To: stable@vger.kernel.org
Cc: mlombard@redhat.com,
	martin.petersen@oracle.com,
	loberman@redhat.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	jonatan.rueda@ggcircuit.com,
	jacob.pitcher@ggcircuit.com
Subject: [PATCH 6.1.y] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Tue, 15 Sep 2026 09:14:56 +0000
Message-Id: <20260915091456.8-1-dmitriy.polomoshnov@ggcircuit.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit d5869dae5080e976d4b03cc33eb7ceb527f242bf upstream.

When a LUN_RESET aborts a WRITE command that is in the
TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and
waits for the frontend to finish processing.

If the initiator subsequently sends the remaining dataout PDUs,
__iscsit_check_dataout_hdr() catches the payload, stops the dataout
timer if the sequence is final and finally dumps the data. However, the
iSCSI target doesn't trigger the completion process for these aborted
commands. Because of this, the abort path hangs indefinitely in
target_put_cmd_and_wait(), leading to a deadlocked target worker thread.

Fix this by explicitly calling target_complete_cmd() when the final
dataout PDU is received for an aborted WRITE command.
target_complete_cmd() detects the CMD_T_ABORTED flag and cleanly routes
the command into target_abort_work, allowing the abort completion to
successfully unblock.

[ dpolomoshnov: 6.1 does not reach the target_complete_cmd() declaration
  through the headers iscsi_target.c already includes, so a straight
  cherry-pick fails to build with "implicit declaration of function
  'target_complete_cmd'". Added the target_core_backend.h include.
  No other change from upstream. ]

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Dmitriy Polomoshnov <dmitriy.polomoshnov@ggcircuit.com>
---
Reproduced on Debian bookworm, kernel 6.1.187-1 (6.1.0-53-amd64), with a
16 MB fileio backstore and a scripted initiator:

  Login -> WRITE_10 8 KB (InitialR2T=Yes, ImmediateData=No,
  MaxOutstandingR2T=1) -> receive R2T -> TMF LOGICAL UNIT RESET ->
  DataOut with F=1

Three tasks are then left in uninterruptible sleep and never recover:

  kworker    target_tmr_work -> core_tmr_lun_reset -> target_put_cmd_and_wait
  iscsi_ttx  iscsit_close_connection -> iscsit_free_cmd ->
             transport_generic_free_cmd -> __transport_wait_for_tasks
  iscsi_np   iscsi_target_do_login -> iscsi_check_for_session_reinstatement ->
             iscsit_stop_session -> iscsit_cause_connection_reinstatement

Only a reboot clears it; hung_task fires at 120 s.

  stock 6.1.187-1 module                    5 of 5 runs hang
  self-built unpatched, same srcversion     3 of 3 runs hang
  self-built patched                        0 of 6 runs hang

The unpatched rebuild has the same srcversion as Debian's shipped module,
so only this patch differs between the last two rows.

5.10.223-1 behaves the same, 5 of 5. 6.12.94-1 did not hold the hang in 13
runs even though the completion call is missing there too, so something in
6.12 appears to release the command by another path. I have not identified
it.

Hit in production on iSCSI diskless-boot servers, where it takes the machine
out until rebooted.

Please also consider the commit for the other longterm trees. 6.6.y and
6.12.y already include target_core_backend.h, so the unmodified upstream
commit applies there. 5.10.y and 5.15.y do not include it, so they need
the same added include as this patch; I have only built 6.1.y and 6.12.y,
so treat the other three as untested.

 drivers/target/iscsi/iscsi_target.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -25,6 +25,7 @@
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
+#include <target/target_core_backend.h>
 
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
@@ -1568,8 +1569,10 @@
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
+			    --cmd->outstanding_r2ts < 1) {
 				iscsit_stop_dataout_timer(cmd);
+				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
+			}
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
