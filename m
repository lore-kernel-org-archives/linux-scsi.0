Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070361514CE;
	Tue, 24 Dec 2024 10:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735036057; cv=none; b=KzvU21+HBSAB5/CRmlBFfQCn9irL7OtHsHY0z5bJxtYsFCAZbOTHgnfpFYTuFeA1gocAM4Eee7LipXp11LNKQR32DVXcNJ+Nic7U+kYCbBHbjf8/mgfl0zHjfLL1lBxDLzPTlnDchSsisDVxaqpU63l+Kr3/RKp6hg1h1dO6SB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735036057; c=relaxed/simple;
	bh=OQdBm96XjvHu+ysm0AS5waB0rbilpMe0t9qNQeyg7KM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nfvSJsVVC794u9QirlkJdjRsCGXOvnHHx4vS4jKKrzHzcY8mnch0xq88gXCWRu6HkBcGSI6mVAFG0UtrIpz/kbAXPa26zH5l+wkMd6DnJz4k3o1tFOzrXQLFcgnLWeIrivCjfiTn8gfUV2U++9zmbVJ76b29Eac+EBHk1WWu1ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=oi2YxLzF; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=p7gODdwD; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="oi2YxLzF";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="p7gODdwD"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 67B9AE0005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1735035487; bh=9wm0+2GGYfL33Wai8vLODSXNXwkx5IgzRAuwWBfhjbw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=oi2YxLzFXmjjFOpuARr5sZ74ezQzt7wruv9AxMTmlVPU8GZ1onzVwTvMaFLktDcWK
	 X5FK2FqLByA7yOmzGAS7nNiBx4jpFaLos+z36BOPySga5J+/f6MhjWnQibnhw14lx/
	 YZGqEE+ZhfwpLSw30Ri01KSmfYNu8p57qCNjJColmuzZXrYyXtkhR7Ra92FR1rPs+P
	 54fOe9kiDXIBHBB84o/OyysDbB+lHRV5HijxlgklRomXv/URw1XT+vMyeNgu4dR+yv
	 oJ59SjTmg/sUwL/6LYJxU/IpE3YVwr6ZQDQ84rBfNDMaztcATDNFMBfJSeP7N+sIm2
	 ik13zeiPok3AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1735035487; bh=9wm0+2GGYfL33Wai8vLODSXNXwkx5IgzRAuwWBfhjbw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=p7gODdwDLJ7oOlTM/q1yaLPyo0AA3h55pjvieYWfK78HK7izm4wxi0+5ZeUB+bWGJ
	 B5PbNndEakRRw1XJL1NCBnfC50lC/KDhzCePMKz1fL+g/nWe8qJI1Wqcl2368HnK8C
	 uGRX5nMY5ZMEvNk3dHLJfnWjaZxdS39g1OBwRBdKbZ9uYC509zPJYdcsYkx0xne7p+
	 Nw1+/e9u98oG0n892bK9HpV6HAjXVQ+a+ynXKtRBKUccbGfUKPZ1LlVtzTs/Y397Z7
	 WysovJz24WQDtYL4HrMpSTpEDZ8ADIN9NwnrTdiq0A0G7F4iknp0ruMKlBIQNdileC
	 eykHU96u8yf/Q==
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Martin Petersen <martin.petersen@oracle.com>,
	<target-devel@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux@yadro.com>, Dmitry Bogdanov
	<d.bogdanov@yadro.com>
Subject: [PATCH] scsi: target: iscsi: fix timeout on deleted connection
Date: Tue, 24 Dec 2024 13:17:57 +0300
Message-ID: <20241224101757.32300-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-07.corp.yadro.com (172.17.11.57) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

NOPIN response timer may expire on a deleted connection and crash with
such logs:

Did not receive response to NOPIN on CID: 0, failing connection for I_T Nexus (null),i,0x00023d000125,iqn.2017-01.com.iscsi.target,t,0x3d

BUG: Kernel NULL pointer dereference on read at 0x00000000
NIP  strlcpy+0x8/0xb0
LR iscsit_fill_cxn_timeout_err_stats+0x5c/0xc0 [iscsi_target_mod]
Call Trace:
 iscsit_handle_nopin_response_timeout+0xfc/0x120 [iscsi_target_mod]
 call_timer_fn+0x58/0x1f0
 run_timer_softirq+0x740/0x860
 __do_softirq+0x16c/0x420
 irq_exit+0x188/0x1c0
 timer_interrupt+0x184/0x410

That is because nopin response timer may be re-started on nopin timer expiration.

Stop nopin timer before stopping the nopin response timer to be sure
that no one of them will be re-started.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6002283cbeba..68bbdf3ee101 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4317,8 +4317,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
-- 
2.25.1

