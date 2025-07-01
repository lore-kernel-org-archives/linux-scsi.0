Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E2269CE5;
	Tue,  1 Jul 2025 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407359; cv=none; b=rcjgsIUhIGdcIV77mkC3ux6gQZSO/AVzKoeD28r0EIcpdu6N5+j8FsGvBQ3WW1UfuAumGdx/HXIX00mwL9po1wpjMXAka5U/k2vnugBow1hwDHUk4NnHGcAI9gC1O4yeekBSX9DIKwl1NUOw1Ecb8f7FyP4zOk1/BfKg9/EmuXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407359; c=relaxed/simple;
	bh=5KS4WpX0v/dFCdLjrGD3LG42ND5wUVQSViSpz8G/ZsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W/+yAHZYuX/zyj2Sq8B1o/F7zNS03WUwVH3kuhbBTxa6pU8ARTuEBSf50XPiQC1DELY405qnV/Wguk2yLdDmgF5SYmE64g2Yu8L7XA9kMMFRtVK1mauec8h+7JUvNfbNGBHG9twv1hpg8VINgudQM6qf8Mw6AZJnHrPl48D5BgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GfIMVpRf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GfIMVpRf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=H1uFGwDeNOpk8or4A3y67qS+sg2s+Vji69hu8RBbx84=; b=GfIMVpRf0kxKC0cjSvfuLCOb6a
	bfgW0ITaDbHNIR3qupRVkz4lbgLw4j0uqUR35HqJvuyHXGQJb1IiSSPnlW6xQ62F6/LfFpx4aR2xK
	fmjIgw34df2CrLPfsNnaWeX5pNbafsFF2mrlvjaoEHmahnN59iGPnrbf8+JANYMt8MFr4+M0bsptl
	DQtLSSSUbzK1NoUQWSOgjnBPtqEw1VfdB88ai0OHNb6MrPbJmIOEdIOsMW8WOqJRjTEi3zO5nitzp
	3rWclBXAtFMdIJEw+RcoXbikJn/FDY/9hTEhaf0K7HbqbM5FzyHhHqLVTAICW60zcLH3y/m1QedG5
	vAI9SBog==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWj3j-00000006jgu-3ubp;
	Tue, 01 Jul 2025 22:02:35 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: mcgrof@kernel.org,
	gost.dev@samsung.com,
	s.prabhu@samsung.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi_debug: Fix shared UUID issue when creating multiple hosts
Date: Tue,  1 Jul 2025 15:02:34 -0700
Message-ID: <20250701220234.1605559-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

When creating multiple scsi_debug hosts (e.g., modprobe scsi_debug
add_host=2), all devices share the same backing storage by default.
This causes filesystem UUIDs to be shared between devices like /dev/sda
and /dev/sdb, leading to confusion and potential mount issues.

For example:
  # modprobe scsi_debug add_host=2 dev_size_mb=1024
  # mkfs.xfs -f /dev/sda
  # wipefs /dev/sda /dev/sdb
Both devices show the same UUID, which is incorrect behavior.

Fix this by automatically enabling separate per-host stores when
multiple hosts are created, while preserving backward compatibility
for single-host scenarios. Users can still explicitly control this
behavior via the per_host_store parameter.

After this fix:
- Single host: Uses shared store (unchanged behavior)
- Multiple hosts: Automatically uses separate stores (fixes UUID issue)
- Explicit per_host_store=1: Always separate stores (unchanged behavior)

Reported-by: Swarna Prabhu <s.prabhu@samsung.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/scsi/scsi_debug.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f0eec4708ddd..4d0b17861adb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8034,12 +8034,18 @@ static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
 	bool found;
 	unsigned long idx;
 	struct sdeb_store_info *sip;
+	bool uniq_uuid_required = false;
 	bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
 	int delta_hosts;
 
 	if (sscanf(buf, "%d", &delta_hosts) != 1)
 		return -EINVAL;
 	if (delta_hosts > 0) {
+		if (delta_hosts > 1) {
+			uniq_uuid_required = true;
+			if (sdebug_fake_rw == 0)
+				want_phs = true;
+		}
 		do {
 			found = false;
 			if (want_phs) {
@@ -8054,7 +8060,7 @@ static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
 				else
 					sdebug_do_add_host(true);
 			} else {
-				sdebug_do_add_host(false);
+				sdebug_do_add_host(uniq_uuid_required);
 			}
 		} while (--delta_hosts);
 	} else if (delta_hosts < 0) {
@@ -8383,6 +8389,7 @@ static struct device *pseudo_primary;
 static int __init scsi_debug_init(void)
 {
 	bool want_store = (sdebug_fake_rw == 0);
+	bool uniq_uuid_required = false;
 	unsigned long sz;
 	int k, ret, hosts_to_add;
 	int idx = -1;
@@ -8578,6 +8585,9 @@ static int __init scsi_debug_init(void)
 	}
 
 	hosts_to_add = sdebug_add_host;
+	if (hosts_to_add > 1)
+		uniq_uuid_required = true;
+
 	sdebug_add_host = 0;
 
 	sdebug_debugfs_root = debugfs_create_dir("scsi_debug", NULL);
@@ -8593,8 +8603,9 @@ static int __init scsi_debug_init(void)
 				break;
 			}
 		} else {
-			ret = sdebug_do_add_host(want_store &&
-						 sdebug_per_host_store);
+			bool use_store = want_store &&
+				(sdebug_per_host_store || uniq_uuid_required);
+			ret = sdebug_do_add_host(use_store);
 			if (ret < 0) {
 				pr_err("add_host k=%d error=%d\n", k, -ret);
 				break;
-- 
2.45.2

