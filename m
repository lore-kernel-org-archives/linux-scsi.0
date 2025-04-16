Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D09F14885B;
	Wed, 16 Apr 2025 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744762972; cv=none; b=uI9EJV+ogDINf/SrBmfNKzmQWIElRfpm3xXAbUzuqk4Tk65oQKUacVq/LZFceFXVwmkHOLctivRc8Rdi0/kW0C85fswhbzAfbXyu69HrHSqQ5K1bbtTX3WbE88umzqG6kwHgKPcX74i3SWF4CEQ7peQHKIjFL2j50+Qz6vhG/mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744762972; c=relaxed/simple;
	bh=z6KRybVRyZdmi7I64NV9NpHJZKwSsx2rh86tzAWVzSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdroaixyczSh4oIPpG+RVnCs01Z8DuMZXM7hZjiJQ/QHkyUX9xwnPiWs9RraeV6S/lMQqwdMhm4D5G0MYvOnt0tNBTp04evg6MprpTqSArmMLo9D1YCpPRtmrQjx1ASgnErmsKhMiV+VtWTM5OIFZBMRgb4xSd3WTvm91VWABr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TPsg5MXZ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TPsg5MXZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=x+BmAxJowFyvmkWWUzVNWCt7ToHiHFv3CvWlBzbM/N8=; b=TPsg5MXZtPIffwar
	JavXQUlv2VBfn/iCgxgF+SiXcaIZRku2+GdVbvvs8r6+I2yWMyOLft6slhTwITr9aLT5aEntXQGiy
	PBAcX7/dVOjMe6CZQC42fgmAive6jPH1be4oGmKWi/SKyplS3Wt7f2AM3J10BnqgLNRuCZD7qin/Z
	XaTKs2dvpf4XYAxeZcIPomZqgaiOKWd7CLZSSk7M+B6/cL9n3W+pwFtgIBsg+xadzepbG1KjNVDST
	JnJxqmYCQCP9LaaCKxIrYwAOqQ6Btu4zPeiu1ZH8oKIh8DXkpeP31dqM8Xd3vIqB/bYiqXorOkClv
	0g/veP6jDi8plx//AQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4qY0-00Bl42-2P;
	Wed, 16 Apr 2025 00:22:36 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/2] scsi: qedi: Remove unused sysfs functions
Date: Wed, 16 Apr 2025 01:22:34 +0100
Message-ID: <20250416002235.299347-2-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250416002235.299347-1-linux@treblig.org>
References: <20250416002235.299347-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qedi_remove_sysfs_attr() and qedi_create_sysfs_attr() were added in 2016
by
commit ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver
framework.")
but have remained unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qedi/qedi_dbg.c | 22 ----------------------
 drivers/scsi/qedi/qedi_dbg.h | 12 ------------
 2 files changed, 34 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_dbg.c b/drivers/scsi/qedi/qedi_dbg.c
index 2ebef4d20b5b..2f3e044b818f 100644
--- a/drivers/scsi/qedi/qedi_dbg.c
+++ b/drivers/scsi/qedi/qedi_dbg.c
@@ -103,25 +103,3 @@ qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 ret:
 	va_end(va);
 }
-
-int
-qedi_create_sysfs_attr(struct Scsi_Host *shost, struct sysfs_bin_attrs *iter)
-{
-	int ret = 0;
-
-	for (; iter->name; iter++) {
-		ret = sysfs_create_bin_file(&shost->shost_gendev.kobj,
-					    iter->attr);
-		if (ret)
-			pr_err("Unable to create sysfs %s attr, err(%d).\n",
-			       iter->name, ret);
-	}
-	return ret;
-}
-
-void
-qedi_remove_sysfs_attr(struct Scsi_Host *shost, struct sysfs_bin_attrs *iter)
-{
-	for (; iter->name; iter++)
-		sysfs_remove_bin_file(&shost->shost_gendev.kobj, iter->attr);
-}
diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
index 5a1ec4542183..864951865869 100644
--- a/drivers/scsi/qedi/qedi_dbg.h
+++ b/drivers/scsi/qedi/qedi_dbg.h
@@ -87,18 +87,6 @@ void qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 void qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 		   u32 info, const char *fmt, ...);
 
-struct Scsi_Host;
-
-struct sysfs_bin_attrs {
-	char *name;
-	const struct bin_attribute *attr;
-};
-
-int qedi_create_sysfs_attr(struct Scsi_Host *shost,
-			   struct sysfs_bin_attrs *iter);
-void qedi_remove_sysfs_attr(struct Scsi_Host *shost,
-			    struct sysfs_bin_attrs *iter);
-
 /* DebugFS related code */
 struct qedi_list_of_funcs {
 	char *oper_str;
-- 
2.49.0

