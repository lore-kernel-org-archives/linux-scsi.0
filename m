Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D190257ACF;
	Fri,  3 Jul 2026 02:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045721; cv=none; b=Ze/P6FDucQZy5XGpOXJowQxc6x8TEzKEQx+YMuPu5hMue858Ix2y+2WMap9I3e99ayQfu7TUMyMINh/Q9dekiCNcgD9zP6ooR1P+ZJTJDRsXN/LcR80mjbtlUrRpVEe3Jyr5wgUAEvkcF8oj9ZREGioQrdu+cGsaN9qfO62OM30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045721; c=relaxed/simple;
	bh=KSPe7Q0dCyS5Mgb6IdQqoQEvoeoh2wVcrMKfD5MyVww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9yjdzFgfToNxIUDDW87ap7iIiGRdzD5oTrgRj/Fsdkpcl4/ZaGMshs7dVscw+ki0D88DObWt9Tiqk7wRZ6kCGWTxYCiNxXZnQaZXGAJvslVPcCRGS9DjIBG6z2CR3Lj8t6bmS8B+MeCTe95DDQsqTv16oQ3CyTFs5sWbgcTHME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=cp3bt2ud; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="cp3bt2ud"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8zxkuvm6SPj0DSnW5LeZBsKdUnQ1mvNhy91FeKeKfMc=;
	b=cp3bt2udNBj4ly6nga1henwfy6g1e0YQDpcffvMCVGdTiYMdQtQMS5SpR+yrAH9/DY31ZueHD
	yMykU6nlYG2BxeaXrpD8cnVhZw1Uwb5FcE1wlYAwxOcNixn5ufQpDLD6fKreMjgeaU2YfPxAElV
	k4obbv1RbBgXa5mFyX+JjiI=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gryB66R1fz1K96m;
	Fri,  3 Jul 2026 10:19:26 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 6908240580;
	Fri,  3 Jul 2026 10:28:36 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 3 Jul 2026 10:28:35 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <dlemoal@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v2 1/2] scsi: scsi_lib: add spinup_notify callback for ASC/ASCQ=0x04/0x11
Date: Fri, 3 Jul 2026 10:28:32 +0800
Message-ID: <20260703022833.36847-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703022833.36847-1-yangxingui@huawei.com>
References: <20260703022833.36847-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
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
 drivers/scsi/scsi_lib.c  |  4 ++++
 include/scsi/scsi_host.h | 12 ++++++++++++
 2 files changed, 16 insertions(+)

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
index 7e2011830ba4..22bf2d3d9b36 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -374,6 +374,18 @@ struct scsi_host_template {
 #define SCSI_ADAPTER_RESET	1
 #define SCSI_FIRMWARE_RESET	2
 
+	/*
+	 * Optional callback invoked when a device returns NOT_READY with
+	 * ASC/ASCQ = 0x04/0x11 ("notify (enable spinup) required").
+	 * This allows LLDDs to perform controller-specific spinup
+	 * notification before the mid-layer retries.
+	 *
+	 * Context: Called from softirq (block layer completion) context.
+	 * Implementations must not sleep or schedule.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (*spinup_notify)(struct scsi_device *sdev);
 
 	/*
 	 * Name of proc directory
-- 
2.43.0

