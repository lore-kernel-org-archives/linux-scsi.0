Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A46519E999;
	Sun,  9 Mar 2025 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741530847; cv=none; b=KEJ8gIE4KlNSlQr45vbzQsGQrNL3mUGRatECEjyGCHGbPOml3C6iTnKBhZPG9MB5PO2ipNjgN8DLXBxZBiL4GxKx0I0jZDVSYvwtO8aCo8ilZHaT0yUa4JDkpwy5DengtwF4FkZ+4LYtI5zEbbx5s4ug70abP3scrib7boTDuo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741530847; c=relaxed/simple;
	bh=3JJGZMJpB7+V80Clbzkplw/qm4VlJ1qS7WZ8lR/zBa4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UypRmRw92fUYaIv2xqCfsx7Y0T0b4uNsumfi4O7qdpgHTJkQtjna8xutL8w0eVLB0vxL74Q85lxiJ57GYsWCtwNyruMPrjbN85LadJf4X5jDBcEsG0ymaxQbVOrGQz8pui++ECWxP8nPk0dIS6tYUEPzGT7yny8QZrLidzAeKQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=YrxIco/d; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="YrxIco/d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=T2cFjlJIrVRM69qletiJGY6RJ3yS/PGLw1X+m0oQKn8=; b=YrxIco/dTxoQcefG
	/4Qj+fTyhIfxj4u8lNXtIYBHgNM0B49JN7/jg0GtaEVwMpIh4wGPnQqA/dBgGccCAJ/wWHK0ifSwQ
	0yTZYsXAXblWCyFLsXsR7Kw5JW+2zPdp79jDs1driYo3q5OY+sqvc9rj0lHzxJbtGN1M6XW3rZD8o
	I/bYnYJ226lyXV5dnexTVPnL1Da9AMQuy9lmfI0mRsboPbAb+gT//lWoXFXBQQzutz5TyTPvc0WAz
	z7DJgIQUTZwc/1ii4rsO+obcUYxEPDiHiuyecv5E9U/1+wVpgGukKB5QD2DjUzXPsEvemzJ8Ljbfu
	lXa1yqfu2ok28kJE7Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1trHiu-003iFV-2S;
	Sun, 09 Mar 2025 14:33:48 +0000
From: linux@treblig.org
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: megaraid_sas: static most module parameters
Date: Sun,  9 Mar 2025 14:33:48 +0000
Message-ID: <20250309143348.32896-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Most of the module parameters are only used locally in the same
C file; so static them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d85f990aec88..28c75865967a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -93,7 +93,7 @@ static unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
 module_param(scmd_timeout, int, 0444);
 MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
 
-int perf_mode = -1;
+static int perf_mode = -1;
 module_param(perf_mode, int, 0444);
 MODULE_PARM_DESC(perf_mode, "Performance mode (only for Aero adapters), options:\n\t\t"
 		"0 - balanced: High iops and low latency queues are allocated &\n\t\t"
@@ -105,15 +105,15 @@ MODULE_PARM_DESC(perf_mode, "Performance mode (only for Aero adapters), options:
 		"default mode is 'balanced'"
 		);
 
-int event_log_level = MFI_EVT_CLASS_CRITICAL;
+static int event_log_level = MFI_EVT_CLASS_CRITICAL;
 module_param(event_log_level, int, 0644);
 MODULE_PARM_DESC(event_log_level, "Asynchronous event logging level- range is: -2(CLASS_DEBUG) to 4(CLASS_DEAD), Default: 2(CLASS_CRITICAL)");
 
-unsigned int enable_sdev_max_qd;
+static unsigned int enable_sdev_max_qd;
 module_param(enable_sdev_max_qd, int, 0444);
 MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as can_queue. Default: 0");
 
-int poll_queues;
+static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues to be use for io_uring poll mode.\n\t\t"
 		"This parameter is effective only if host_tagset_enable=1 &\n\t\t"
@@ -122,7 +122,7 @@ MODULE_PARM_DESC(poll_queues, "Number of queues to be use for io_uring poll mode
 		"High iops queues are not allocated &\n\t\t"
 		);
 
-int host_tagset_enable = 1;
+static int host_tagset_enable = 1;
 module_param(host_tagset_enable, int, 0444);
 MODULE_PARM_DESC(host_tagset_enable, "Shared host tagset enable/disable Default: enable(1)");
 
-- 
2.48.1

