Received: from out28-169.mail.aliyun.com (out28-169.mail.aliyun.com [115.124.28.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAB735A397;
	Thu, 15 Oct 2026 02:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030029; cv=none; b=rfuXWUeji5Or8dWF1dj8g83WLICSoflUHxuN0bJoLiqb8UXdLISGECRz4Rb5SarAHORpPb96aOtK7Kl9DHPoiVka0rbaOM6B5JzTsTwEtowSRCuE0zJcXzVZFZoARu5912hZHMk7rsz47YuFVX92ipPHVNiRnE9SLDeraZWmxc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030029; c=relaxed/simple;
	bh=sb0PPddnt0hkRbE612hiT6z0RHn2SWzqZldRyrJvOys=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YlVtq/cfTZPqBz1YCDUKqvDDms1uNl82pwNj2BVWcq+kI90LkE6xu7lPEZdJp1DBmWVZJ5NKNyClpR68hft0TpryJlMGPbrL3tnLkCgZiIpsrXuXeaQBKPoPY0BoxzDpt/g+swtMGXa3nVW26pTz7johIDlVESd70iNbocDzLRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=TRBCK3HX; arc=none smtp.client-ip=115.124.28.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="TRBCK3HX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1792030018; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To;
	bh=ef3lgvkYm7aFgyWoUtYsRyn0vjEqMssju2pSN7CWKis=;
	b=TRBCK3HXYYiRxkpaH6bWaaP5ZIEQPlxS7kkbWlbtfI6d2Bnk6leaJ5RsZ3JNXtayWFnx+SE5jBkh7Bry7C1oMCW64Mq2ybljWAwgjU4RTur0v83vwNU2MDOHAIUu4VlvEd6waJK7C0zHVkO1Kl+3CuanXQjDPa+zPx7ADkwHsnI=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1069297|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00583292-0.000657232-0.99351;FP=13730585837055215582|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037028158;MF=liuwb@xiaopeng.com;NM=1;PH=DS;RN=12;RT=12;SR=0;TI=SMTPD_---.je9qaAG_1792030016;
Received: from 127.0.0.1(mailfrom:liuwb@xiaopeng.com fp:SMTPD_---.je9qaAG_1792030016 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 10:06:57 +0800
From: Weibin Liu <liuwb@xiaopeng.com>
Date: Thu, 15 Oct 2026 10:06:57 +0800
Subject: [PATCH] scsi: mpt3sas: clamp ValidEntries in driver trigger pg2
 store
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-mpt3sas-validentries-v1-1-f4d802788b65@xiaopeng.com>
X-B4-Tracking: v=1; b=H4sIAEA10GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0NT3dyCEuPixGLdssSczJTUvBKQbt0k82RTixSLJGNLMzMloNaCotS
 0zAqwsdGxtbUA3Ast2mYAAAA=
X-Change-ID: 20261015-mpt3sas-validentries-b7c58d8b3966
To: ranjan.kumar@broadcom.com, suganath-prabu.subramani@broadcom.com, 
 linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com, 
 sathya.prakash@broadcom.com
Cc: linux-kernel@vger.kernel.org, mkp@kernel.org, 
 James.Bottomley@HansenPartnership.com, MPT-FusionLinux.pdl@broadcom.com, 
 Liu Chao <liuc63@xiaopeng.com>, stable@vger.kernel.org, 
 Weibin Liu <liuwb@xiaopeng.com>
X-Mailer: b4 0.14.3

The driver trigger page 2 store path copies the user-supplied
event_tg->ValidEntries directly into tg_pg2.NumMPIEventTrigger and
then iterates over it while filling MPIEventTriggers[]. The array
holds NUM_VALID_ENTRIES (20) entries, so a ValidEntries value larger
than that causes an out-of-bounds read of event_tg->EventTriggerEntry[]
and an out-of-bounds write into the on-stack tg_pg2 structure.

The local copy of the trigger data is only clamped later inside
diag_trigger_event(), which is too late for this path.

Clamp count to NUM_VALID_ENTRIES before using it as the loop bound
and when programming NumMPIEventTrigger.

Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
Fixes: 71b3fb8fe6dd ("scsi: mpt3sas: Add persistent Event trigger page")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index b0d5ef893600..62999682ce95 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2278,6 +2278,8 @@ mpt3sas_config_update_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 
 	if (set) {
 		count = event_tg->ValidEntries;
+		if (count > NUM_VALID_ENTRIES)
+			count = NUM_VALID_ENTRIES;
 		tg_pg2.NumMPIEventTrigger = cpu_to_le16(count);
 		for (i = 0; i < count; i++) {
 			tg_pg2.MPIEventTriggers[i].MPIEventCode =

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261015-mpt3sas-validentries-b7c58d8b3966

Best regards,
-- 
Weibin Liu <liuwb@xiaopeng.com>

