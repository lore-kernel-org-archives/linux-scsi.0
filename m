Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3651D4C9F;
	Sun, 10 Aug 2025 00:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785285; cv=none; b=KwxM1cDEIEUmyhViQXpGhY1Clwjk27WTsBZx2LcZY8zrU2E2GSX4EJzxTl3e0zeVtzCAaNGlUEIujenibVQyWjJIsw+HvLMhOQ7yzTB5WdUFPK54kCMM2BFOYIZXpHAiToP5/i2i7pcIVPmOA/EhcjwgP5R8De4KBSiACU77XG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785285; c=relaxed/simple;
	bh=jeoA254isR7T1Cz0HSUWsDyvPf9kVzICJGvd3hDuKrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BzGLjOQu+ccfm46W2WbXzax2rwIu1qif4eHudZz8Kzd+fk8cXy43X0vInd4YIS4zcskrXN9MNyHTZEscKGLsaNgp5JBIz31O3ieCDS97uq3qXYZDfZ/kFBKdnZPHt5sfebccxcrKY7pz4DUMu7+om1VUYtiwo31fg6GRdKIpr3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joVhhOzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joVhhOzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993E8C4CEE7;
	Sun, 10 Aug 2025 00:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785284;
	bh=jeoA254isR7T1Cz0HSUWsDyvPf9kVzICJGvd3hDuKrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joVhhOzfl8ab1+JO+HcOGkiGy5KGHzljy5I4q+YZ5lFpdzeD8KPd1N/84G9omzlAZ
	 vhLad59SCAlQ8RSUtqNJYNSfReQNv5y7ivef//qxRf4GOuqwU9pkuD5NIsE6vHtISS
	 DJFhh5fTIFK34YDjSMflY0oCXIc6eyCVGfHpqHFcJNZwSgPtru39sWj+0K2b7wUWS7
	 hsc43uDtdnxEUoe3YBM666OEKLG9ltULwUJ3LaF9YvbXDc38AzLXogWLJ9vdVHJ9uX
	 zrMeBtGvfsH1Fy1xi8v3uZ9bcJC3MjdQR+pe6vl14OeHfUXu2DQ7tdppoaIWKRNraM
	 DD7XKag3/PwpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans
Date: Sat,  9 Aug 2025 20:20:57 -0400
Message-Id: <20250810002104.1545396-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 37c4e72b0651e7697eb338cd1fb09feef472cc1a ]

sas_user_scan() did not fully process wildcard channel scans
(SCAN_WILD_CARD) when a transport-specific user_scan() callback was
present. Only channel 0 would be scanned via user_scan(), while the
remaining channels were skipped, potentially missing devices.

user_scan() invokes updated sas_user_scan() for channel 0, and if
successful, iteratively scans remaining channels (1 to
shost->max_channel) via scsi_scan_host_selected().  This ensures complete
wildcard scanning without affecting transport-specific scanning behavior.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250624061649.17990-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Bug Fix Analysis

This commit fixes a **functional bug** in the SAS transport layer where
wildcard channel scans (`SCAN_WILD_CARD`) were not working correctly
when a transport-specific `user_scan()` callback was present. The bug
manifested as:

1. **Incomplete device discovery**: When performing wildcard scans, only
   channel 0 devices would be scanned via the SAS-specific
   `sas_user_scan()`, while channels 1 through `max_channel` were
   completely skipped.
2. **Missing devices**: This could result in SAS devices on non-zero
   channels not being discovered during rescans, which is a serious
   issue for storage management.

## Code Changes Analysis

The fix involves two key changes:

1. **Export of `scsi_scan_host_selected()`** in
   `drivers/scsi/scsi_scan.c:1902`:
   - This makes the function available to transport modules
   - Simple one-line addition: `EXPORT_SYMBOL(scsi_scan_host_selected);`

2. **Rewrite of `sas_user_scan()` logic** in
   `drivers/scsi/scsi_transport_sas.c`:
   - Refactored to handle three cases properly:
     - Channel 0: Scan SAS-specific devices only
     - `SCAN_WILD_CARD`: First scan channel 0 SAS devices, then iterate
       through channels 1 to `max_channel` using
       `scsi_scan_host_selected()`
     - Other channels: Delegate to `scsi_scan_host_selected()`
   - The new code properly handles multi-channel configurations

## Stable Backport Criteria

This commit meets the stable kernel criteria:

1. **Fixes a real bug**: The inability to discover devices on non-zero
   channels during wildcard scans is a clear functional bug that affects
   users.

2. **Small and contained**: The changes are limited to:
   - One export symbol addition
   - One function rewrite in the SAS transport layer
   - Total diff is relatively small (~100 lines)

3. **No architectural changes**: This is a targeted fix that doesn't
   change any kernel subsystem architecture or APIs.

4. **Low regression risk**:
   - The changes are confined to the SCSI SAS transport subsystem
   - The fix preserves existing behavior for non-wildcard scans
   - Error handling paths remain intact

5. **Important for users**: Multi-channel SAS configurations are common
   in enterprise storage systems, and the ability to properly rescan all
   channels is critical for:
   - Hot-plug scenarios
   - Device recovery after errors
   - Storage management operations

## Additional Context

Looking at the commit history, there have been previous issues with SAS
scanning (e.g., commit e9dedc13bb11 "scsi: hisi_sas: Fix rescan after
deleting a disk"), indicating this is an area where proper functioning
is critical and has had issues before.

The fix is straightforward and correct - it ensures that wildcard scans
actually scan all channels as intended, not just channel 0. This is
essential functionality that should work correctly in stable kernels.

 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/scsi_transport_sas.c | 60 ++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4833b8fe251b..396fcf194b6b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1899,7 +1899,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(scsi_scan_host_selected);
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 351b028ef893..d69c7c444a31 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -40,6 +40,8 @@
 #include <scsi/scsi_transport_sas.h>
 
 #include "scsi_sas_internal.h"
+#include "scsi_priv.h"
+
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
@@ -1683,32 +1685,66 @@ int scsi_is_sas_rphy(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_sas_rphy);
 
-
-/*
- * SCSI scan helper
- */
-
-static int sas_user_scan(struct Scsi_Host *shost, uint channel,
-		uint id, u64 lun)
+static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_rphy *rphy;
 
-	mutex_lock(&sas_host->lock);
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
 		if (rphy->identify.device_type != SAS_END_DEVICE ||
 		    rphy->scsi_target_id == -1)
 			continue;
 
-		if ((channel == SCAN_WILD_CARD || channel == 0) &&
-		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
+		if (id == SCAN_WILD_CARD || id == rphy->scsi_target_id) {
 			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
 					 lun, SCSI_SCAN_MANUAL);
 		}
 	}
-	mutex_unlock(&sas_host->lock);
+}
 
-	return 0;
+/*
+ * SCSI scan helper
+ */
+
+static int sas_user_scan(struct Scsi_Host *shost, uint channel,
+		uint id, u64 lun)
+{
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	int res = 0;
+	int i;
+
+	switch (channel) {
+	case 0:
+		mutex_lock(&sas_host->lock);
+		scan_channel_zero(shost, id, lun);
+		mutex_unlock(&sas_host->lock);
+		break;
+
+	case SCAN_WILD_CARD:
+		mutex_lock(&sas_host->lock);
+		scan_channel_zero(shost, id, lun);
+		mutex_unlock(&sas_host->lock);
+
+		for (i = 1; i <= shost->max_channel; i++) {
+			res = scsi_scan_host_selected(shost, i, id, lun,
+						      SCSI_SCAN_MANUAL);
+			if (res)
+				goto exit_scan;
+		}
+		break;
+
+	default:
+		if (channel < shost->max_channel) {
+			res = scsi_scan_host_selected(shost, channel, id, lun,
+						      SCSI_SCAN_MANUAL);
+		} else {
+			res = -EINVAL;
+		}
+		break;
+	}
+
+exit_scan:
+	return res;
 }
 
 
-- 
2.39.5

