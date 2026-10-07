Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209622425B
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791382708; cv=none; b=RH7RVs8b+gUIa7M9VJ79bKQIjzxNfZ5D7CMDFkIdawvRlHNgHK0NMBIoCEc2aNJDP/sTalZOeRNlpQPboDTyUzjVHstCLW4B0umaOcr6z0Fg+6FsjKLyl85372zl6WR7ZCbsQcXGOlIn4iEQAQAM4x7REW0fUhiEK6R9c5a41LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791382708; c=relaxed/simple;
	bh=3jIritETAAQuv6kAdsHON0sENC6zIY9Enr0b/xxc6F0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dza+urTmVXYX3a/33tStSktVhipGb3lxTIdvnaeUz+5DY+Oh9xv1NUqArR4tBrlK15/aKcNJ02qADgFGNi7Maw9rAf36L/uUg4I+e8P8YT5Lj19Lsz9KYqbS60eND8KzUbnqOVVCTdU+E/cKAMrxIVtahHADuPT7WagAVPwuYKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20251104.gappssmtp.com header.i=@smartx-com.20251104.gappssmtp.com header.b=IbXNwKF9; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20251104.gappssmtp.com header.i=@smartx-com.20251104.gappssmtp.com header.b="IbXNwKF9"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f48c750afcso2802672a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 07:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20251104.gappssmtp.com; s=20251104; t=1791382699; x=1791987499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jp1XCm/vj9IDzSYwv15Kh1QdqJQdJPhxMV80ssGGTGU=;
        b=IbXNwKF9ylOBv81mY4efOGqk8aKxeWj4r7XaNJiw2YmtH8X8Eli8UizrhM7j71KUJT
         W3RIo0TI6/hQf2PxvKCPAWxzVsU69lYOO+cOdWYb74nMMxZ6URF6aRYeI7NTgV2vQznb
         DFRmhxJhoIR/zezNTrlUvrpns9Z/ZaJ9GW/UgvUWLJ8PAX90l0QWqp4KpOLALp7WfjYD
         Pp/nCcHO2WOdXS8aYYlYUn+kGci+uv9ysI/h4wPA1dEMjJQOrA+/n+ifThm6zLn0QtCh
         sYrbvWJH5qkOncOeCOEAqbnzLzWNU+9kR5swvf9jRt9Sddk0KceimCp6VLkK9KDgHDyP
         JMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791382699; x=1791987499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jp1XCm/vj9IDzSYwv15Kh1QdqJQdJPhxMV80ssGGTGU=;
        b=m18PxqXEJKG4UJVeJVW7ay25CqOS48w3yl65ITsmBO31xaKYauLhsb9/NdLEaUtEw1
         qGDf2QjLu5bzkiSphoxTMPjlAqLYTooGS3GyG3crQBhQFweNOWwAMqukW6X7iPvKmcgW
         xJH3ozuF84G8cVdKRHbSWfAXWPSsQbvCuAxU9HqqqJRx6d/iv9L80aqnoyFjZPLCo5ar
         iROD4q6X/JGDpsACutQT7O/wRRPMdrM+q2cPQNReVElK6VfcnwzkyAVPztRjKqvEHXHh
         6cdenWtQYFQrMARD2p2m2e+X5sTAchVX6sxnZ8tEL7Sp9iyUJXsxykCQRVmSqbIuGMWF
         DhEg==
X-Forwarded-Encrypted: i=1; AKwUvBxlQGIzyG9kbui7kWyx0ROzDQiiUgAIDo+w8HKwOKoX2AH5PTqbjq1IYj3OWOHVFlONcqV8m6OyK6f/@vger.kernel.org
X-Gm-Message-State: AFuF++nzWsvzi2WJzgEI81V68HAxFsQSO9Wo60vWqwVOSm67HTjZCq5Y
	B9F7WF4GChfjb3dDVAC31lajSOkmiVCjv6S7hbgyVDCFWHApUPy+gjFXbfT0OilucZgOSQj+QF/
	0cLCl/OuNhOBWJZuFA7S0/4XVX/ZZc7lrJH8FSsXyo0ad/eMJRwrc7zPB
X-Gm-Gg: AYBFou1rejQ0hRjnH2Fp6ho5rolhL4N6W4r/X3jb9pbI/cRmAdk1CU/WKq/0BXDzQBp
	jmC/AMdqyTi7fsh9mupAP8fv69uWJtRDZbmQp9UmCucfDQi/kp7cJbHaEDCZjOCgjEefvAIR+X0
	AvmqAG7mPzoV+Xo4zlPoYjFn8Ox1ftMH5x8Bt6yMAqorPdLcuq+k7X9xo1ftQ+CVwjz56KQwNG+
	osMsZ4okKQsGa127i4KvUPKlmrdp4lt0SkQiLdcCx6J1ritq/V/P0w8KWdj+aK2zE5GJMVkeK0o
	rky5esqRCycsChHLiBLqG0iVuDuO+M1o8ZWpjMDCc3q8j0Kt22l3GHrnuOXSsddoSQf//6z4Rxq
	Nc8hsrjCNILsfHvNjPkJDHNJ6khEo4eKJD5B8IB3ecTGsYI84jv4RQjOSiLULoWB0nGQ1B1Ruua
	/13IQfYC/2N+7Hstyp810j6HHnXH+biXpdBNa+5gOaUEbCQfcdaI6AG2KtOMf4dMfwpYSl53zLN
	tNN6z4KniIAXU93hHK+
X-Received: by 2002:a05:6830:651a:b0:81c:5aac:798a with SMTP id 46e09a7af769-82acee8f351mr3093634a34.13.1791382699344;
        Wed, 07 Oct 2026 07:18:19 -0700 (PDT)
Received: from localhost.localdomain ([23.148.204.128])
        by smtp.googlemail.com with ESMTPSA id 46e09a7af769-82ad9eeb5eesm2723670a34.2.2026.10.07.07.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 07:18:18 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lei.chen@smartx.com
Subject: [PATCH] scsi: megaraid_sas: Fix debugfs setup error handling
Date: Wed,  7 Oct 2026 22:17:53 +0800
Message-ID: <20261007141753.416672-1-lei.chen@smartx.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

debugfs_create_dir() and debugfs_create_file() return error pointers on
failure, but megasas_setup_debugfs() only checks for NULL. As a result,
setup continues after directory creation fails, and a failure to create
raidmap_dump leaves the per-adapter directory behind.

Skip per-adapter setup if the driver debugfs root is unavailable, and
use IS_ERR_OR_NULL() to check directory and file creation results so
that the existing error paths also handle error pointers.

With the corrected error check, file creation failure removes the
per-adapter directory. Clear the stored directory pointer as well so
teardown does not attempt to remove the freed dentry again.

Fixes: ba53572bf02d ("scsi: megaraid_sas: Export RAID map through debugfs")
Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 drivers/scsi/megaraid/megaraid_sas_debugfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
index 81698cd83f5a..556e01fc25e8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
+++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
@@ -126,13 +126,16 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 
+	if (IS_ERR_OR_NULL(megasas_debugfs_root))
+		return;
+
 	if (fusion) {
 		snprintf(name, sizeof(name),
 			 "scsi_host%d", instance->host->host_no);
 		if (!instance->debugfs_root) {
 			instance->debugfs_root =
 				debugfs_create_dir(name, megasas_debugfs_root);
-			if (!instance->debugfs_root) {
+			if (IS_ERR_OR_NULL(instance->debugfs_root)) {
 				dev_err(&instance->pdev->dev,
 					"Cannot create per adapter debugfs directory\n");
 				return;
@@ -144,10 +147,11 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 			debugfs_create_file(name, S_IRUGO,
 					    instance->debugfs_root, instance,
 					    &megasas_debugfs_raidmap_fops);
-		if (!instance->raidmap_dump) {
+		if (IS_ERR_OR_NULL(instance->raidmap_dump)) {
 			dev_err(&instance->pdev->dev,
 				"Cannot create raidmap debugfs file\n");
 			debugfs_remove(instance->debugfs_root);
+			instance->debugfs_root = NULL;
 			return;
 		}
 	}
-- 
2.43.0

