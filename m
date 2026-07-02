Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED39C34C130;
	Thu,  2 Jul 2026 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782964778; cv=none; b=rxbn+U0JvgyhOsMLmCowpFCPI3gIJ3TzAHgucP+R93YFQtpF3PUnhNAqcthnGNSNCtx2AOyuPErSHV7v1j5oJZXCbgqAAk/UmNnlddUXZX65sPL5Kgyj9+6MS9t2vQePmzs9T5+kazbdTyIhGwA4UEQe/f3daz4YYd90uP+R2sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782964778; c=relaxed/simple;
	bh=UunjM0092egpSTA5aUPq6+VjOAPUA2ekuy9Des6nBwI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1QdwYKZB0j2bVPXpCn+ADUyASuHaNiZsYtth+ycpQWOfZzYQTjoOun2YfEdFqEx3obj0wdStlfcVAmjkm9ZDL8ck3Z6ZerDSWvlvSpWkT7ORfWP2U06//z7D7sFtpKzoPVO5pQ54mogfaHQCqv62am3BXSdhKbaoaqOKzaRVO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=huE0Ywh+; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="huE0Ywh+"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nP/NXLt1Leq0gYIF0Cpx+S7okE/swTivpVbp85RmJC4=;
	b=huE0Ywh+UQWA5FOZBBUmAdNBx3iyVUp4MF8kJq5IGSs1zKf0vrYBjBQWrqkCjnHxYkA83bL4o
	0txMfFz5R84VFscRuJqz9oglWihnhBHx6+jPHowQKM3CZG038AMnAWaBI+DaWWPK3VbJMT0dgVS
	trbzjpUl7ZLF5VaHXFMkFpo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4grNFl6r6Dzcb34;
	Thu,  2 Jul 2026 11:50:35 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id B51564058C;
	Thu,  2 Jul 2026 11:59:27 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 2 Jul 2026 11:59:27 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <dlemoal@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH 1/2] scsi: scsi_lib: add spinup_notify callback for ASC/ASCQ=0x04/0x11
Date: Thu, 2 Jul 2026 11:57:23 +0800
Message-ID: <20260702035724.2059166-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702035724.2059166-1-yangxingui@huawei.com>
References: <20260702035724.2059166-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100018.china.huawei.com (7.202.194.12)

When a SCSI device returns NOT_READY with ASC/ASCQ = 0x04/0x11
("notify (enable spinup) required"), the device is in Active_Wait or
Idle_Wait power state and will not respond to standard START_STOP
spinup commands.

Add an optional spinup_notify callback to struct scsi_host_template.
When ASCQ=0x11 is detected in the mid-layer, invoke this callback
before ACTION_DELAYED_RETRY, allowing LLDDs to perform controller-
specific spinup notification.

Example log:
[Tue Jun 23 08:34:44 2026] sd 4:0:9:0: [sde] Spinning up disk...
[Tue Jun 23 08:36:22 2026] ...not responding...
[Tue Jun 23 08:36:24 2026] sd 4:0:9:0: [sde] Sense Key : Not Ready
[Tue Jun 23 08:36:24 2026] sd 4:0:9:0: [sde] Add. Sense: Logical unit
  not ready, notify (enable spinup) required

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/scsi_lib.c  | 4 ++++
 include/scsi/scsi_host.h | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b67f0dc79499..33c4339ca8c5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -905,6 +905,10 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x1a: /* start stop unit in progress */
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
+					if (sshdr.ascq == 0x11 &&
+					    cmd->device->host->hostt->spinup_notify)
+						cmd->device->host->hostt->spinup_notify(
+							cmd->device);
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4..500fad5ffab6 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -374,6 +374,15 @@ struct scsi_host_template {
 #define SCSI_ADAPTER_RESET	1
 #define SCSI_FIRMWARE_RESET	2
 
+	/*
+	 * Optional callback invoked when a device returns NOT_READY with
+	 * ASC/ASCQ = 0x04/0x11 ("notify (enable spinup) required").
+	 * This allows LLDDs to perform controller-specific spinup
+	 * notification before the mid-layer retries.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (*spinup_notify)(struct scsi_device *sdev);
 
 	/*
 	 * Name of proc directory
-- 
2.43.0

