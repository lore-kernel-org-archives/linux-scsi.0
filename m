Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E88936B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 04:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753676371; cv=none; b=GCNL07tSwFjWtWvk7tQxX/tBcPbo7lNvoQm7hJlzFFU8nEDWtVgywY/SJOnXy9csCrb1mgU9wEBE8lhVJFloontSOA3d2LmaPkXgOAPZbd+Ln5hVuydMc+oBMJqxB/PHdaSDRuX8Lpuh5kNiv/Wnt28rKZ/ywgrgMkLnIeOu5bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753676371; c=relaxed/simple;
	bh=p1ar2f+BKcsE8K192o6BKeriAULmiwxo8nwU91lox/M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Tvn7d204ot/Q4JGwHHsr7Wbl7v72cpH/RreApBQKrt+W6uS/O9klxm6pMwyNtSXZV/vLy8m2GFBGVUDKK1ZdZn4Fe0abOq0W82ocDOPXJ7/duU6+axi/GtupbM3QhssDnRUT74UdkIf6ZkBYi2dJdpaahVAAXV01lfhgKDpL1qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVHiTXys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVHiTXys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE32C4CEE7;
	Mon, 28 Jul 2025 04:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753676370;
	bh=p1ar2f+BKcsE8K192o6BKeriAULmiwxo8nwU91lox/M=;
	h=From:To:Subject:Date:From;
	b=KVHiTXys6Kyjo4JjC/9BpR3DLETGZBIQW9qbVK8YO1ImR0JRn+Uw3y2MdN+Wwb+py
	 AZ+R7ANzzwIs1bddFPpiPIaWVBS/KQaGHRZPULhpVOB2CVWq7I/pesBSdqyr49rXxn
	 fLwv/iNbdjt4hFt9uaOGsSc2kqJ3WTnVfK4ixYrO0Pnrl0Zds5jmLTP08uS2V3Gaec
	 bdcVjAbltXUvWCXbeCIvT63hlJKBKyBZH2W00LzRS3kBC9Ay/1QI8Xuj/F3nBABCzY
	 jgN9LsAmrXvcknMRmqrE9Kq/ZInZJLI25rQukEQ0vxs74iQDE4DXSO7PYTS42huRG+
	 1Rhn1OIgmuHow==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: Correct sysfs attributes access rights
Date: Mon, 28 Jul 2025 13:17:00 +0900
Message-ID: <20250728041700.76660-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scsi sysfs attributes "supported_mode" and "active_mode" do not
define a store method and thus cannot be modified. Correct the
DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
allow write access as they are read-only.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d772258e29ad..e6464b998960 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -265,7 +265,7 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 	return show_shost_mode(supported_mode, buf);
 }
 
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NULL);
 
 static ssize_t
 show_shost_active_mode(struct device *dev,
@@ -279,7 +279,7 @@ show_shost_active_mode(struct device *dev,
 		return show_shost_mode(shost->active_mode, buf);
 }
 
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
 
 static int check_reset_type(const char *str)
 {
-- 
2.50.1

