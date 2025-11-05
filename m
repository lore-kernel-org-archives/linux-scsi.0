Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770342F5332
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 11:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762341779; cv=none; b=G0AqysLYQbT7avciNlxdC4oGDY3jEmCFVY3oGWM+OSuuM2ugKtcJ2ZKAKaLhQxLtGeofuB6odm310E9W2mMVbhdtk0dnFkt+LWAXwv0zFSCValzprhXArjcFx3Dg8zGiG7h8EiYX8pxpFLoSeqOAUgregPZVQXba4zSIXt5C84s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762341779; c=relaxed/simple;
	bh=lnLHz4GA8+8YXZRlXyloiFq/qFqW00pgYvfIRW38KzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjH2/e4xiVsIta9i7fZ39n76VPKBcsQN6Yo6uheAQreZE0eeHZ//FhyYFlgPQOIqiUX3HXhAxc7VrKjr7frQEGn/GoqCUb/5JYn45kEiFgM2YselPh3vvVlTq+VbVkJZv8hjsPQSJJijrzE4lTVDgtNeY1H4vBTpI5zISsVNaI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=XOT9zaP0; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="XOT9zaP0"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=92JC27mDPJloZ1mOGLQV9cMWKdZ2iVdLNF4HlThwsBo=;
	b=XOT9zaP0ZU6YyK71RY5H+dVuqdqk0qcVGMGMxcP1CAPfg9BI9kNX/MvK7I37pvWhgIb+nXAsQ
	yTnjoDh2xXNsz5JQN54mMxDCqLg+Z7yitBzncQW4jW4e034NrGrntgrEPo/OWgZcrgRhQopfYvf
	jLUyWWa9AO7L2t+O/8ZMfpM=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d1jZ66TZpzLlSM;
	Wed,  5 Nov 2025 19:21:18 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id CBF53140109;
	Wed,  5 Nov 2025 19:22:53 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Nov 2025 19:22:53 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <bvanassche@acm.org>, <john.g.garry@oracle.com>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>
Subject: [PATCH] scsi: scsi_debug: make timeout faults by set delay to maximum value
Date: Wed, 5 Nov 2025 19:57:22 +0800
Message-ID: <20251105115722.1634895-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250224115517.495899-5-john.g.garry@oracle.com>
References: <20250224115517.495899-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk500001.china.huawei.com (7.202.194.86)

The injection of timeout faults is achieved by directly discarding the
SCSI command.

However, after the timeout, the SCSI mid-layer cancels the SCSI command.
At this point, if the command is checked during cancellation, it will result
in a "not found" outcome, making it impossible to cancel the command properly.

Therefore, the approach has been changed to avoid direct cancellation, and the
delay is set to the maximum value(0x7FFFFFFF).

Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..7d86a6f10130 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9249,6 +9249,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	bool inject_now;
 	int ret = 0;
 	struct sdebug_err_inject err;
+	bool timeout = false;
 
 	scsi_set_resid(scp, 0);
 	if (sdebug_statistics) {
@@ -9291,7 +9292,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 
 	if (sdebug_timeout_cmd(scp)) {
 		scmd_printk(KERN_INFO, scp, "timeout command 0x%x\n", opcode);
-		return 0;
+		timeout = true;
 	}
 
 	ret = sdebug_fail_queue_cmd(scp);
@@ -9398,7 +9399,9 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
 
 fini:
-	if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
+	if (unlikely(timeout)) /* inject timeout */
+		return schedule_resp(scp, devip, errsts, pfp, 0x7FFFFFFF, 0x7FFFFFFF);
+	else if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
 		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
 	else if ((flags & F_LONG_DELAY) && (sdebug_jdelay > 0 ||
 					    sdebug_ndelay > 10000)) {
-- 
2.33.0

