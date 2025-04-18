Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9D254AEE;
	Fri, 18 Apr 2025 23:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745017636; cv=none; b=o0ffSzEZrqsld/19D3Cg2k3jtJIFyBesGEB4IpEJFhP62IjagwG2HZbv+p/L61I4q0OcVnERXJs9S4u8Xdpn7Hk/vbZYHBNCbWA15JGSYekl14fuG/r3lKkPsq+0CJkguKYFUC9cqR3k99EF1L88iytM/TUm5+YyEPupwkAGBpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745017636; c=relaxed/simple;
	bh=CrRCKqz/JA5HsPhH6mB3lb5rhNmWhPIYyZNe/G7Iz0Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBcfh9TLygN89CULxTdZZ+GH56yb4LBP0iJ8LvyA56cV3fhNqPxrBNWqA5HedPHOc7oBoJ0i2ILTb3j4ns8sMP1cR2YJv9YeyePcIi/fO7p1IRKRhBblx2xo/G+NrmvzOfDVnZYbD3VCztDgGrmsf8AXW32GkFVKPL8wHTA1tdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+Lzr9M3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+Lzr9M3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B744C4CEEB;
	Fri, 18 Apr 2025 23:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745017635;
	bh=CrRCKqz/JA5HsPhH6mB3lb5rhNmWhPIYyZNe/G7Iz0Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i+Lzr9M3TjMPwlLerRbFt/AFgJVfJRrWlMQyB84WMxY3gTPvzNWpLMM/k96zcIk8p
	 0HfeE/1xLHpF6wtw1WWwZROX9TuAIpIUalMBV/FAsthKabj2lfXiGlUzR/i8mE35vU
	 uDLsMnDjzAfuPwKJ9Zwmc4JSawxJ9nnUhISGlIBBqA+oQe3y95PVfk3+LeglTjahQY
	 61yvT3erHfAYkdX9JKqKUKfv1x6HAeTECud4/jjQwuLZIY+YPr27R6tt3Fg1eOo0da
	 vR+4ZkvdKgeZu9B6MsgwOpSb/TIyM4kU6EGNWuSWooZExQBObsTOxWGbSGAH+befGg
	 +2bijV33rGTtw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 4/4] scsi: Improve CDL control
Date: Sat, 19 Apr 2025 08:06:23 +0900
Message-ID: <20250418230623.375686-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250418230623.375686-1-dlemoal@kernel.org>
References: <20250418230623.375686-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With ATA devices supporting the CDL feature, using CDL requires that the
feature be enabled with a SET FEATURES command. This command is issued
as the translated command for the MODE SELECT command issued by
scsi_cdl_enable() when the user enables CDL through the device
cdl_enable sysfs attribute.

However, the implementation of scsi_cdl_enable() always issues a MODE
SELECT command for ATA devices when the enable argument is true, even if
CDL is already enabled on the device. While this does not cause any
issue with using CDL descriptors with read/write commands (the CDL
feature will be enabled on the drive), issuing the MODE SELECT command
even when the device CDL feature is already enabled will cause a reset
of the ATA device CDL statistics log page (as defined in ACS, any CDL
enable action must reset the device statistics).

Avoid this needless actions (and the implied statistics log page reset)
by modifying scsi_cdl_enable() to issue the MODE SELECT command to
enable CDL if and only if CDL is not reported as already enabled on the
device.

And while at it, simplify the initialization of the is_ata boolean
variable and move the declaration of the scsi mode data and sense header
variables to within the scope of ATA device handling.

Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/scsi.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 53daf923ad8e..518a252eb6aa 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -707,26 +707,23 @@ void scsi_cdl_check(struct scsi_device *sdev)
  */
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 {
-	struct scsi_mode_data data;
-	struct scsi_sense_hdr sshdr;
-	struct scsi_vpd *vpd;
-	bool is_ata = false;
 	char buf[64];
+	bool is_ata;
 	int ret;
 
 	if (!sdev->cdl_supported)
 		return -EOPNOTSUPP;
 
 	rcu_read_lock();
-	vpd = rcu_dereference(sdev->vpd_pg89);
-	if (vpd)
-		is_ata = true;
+	is_ata = rcu_dereference(sdev->vpd_pg89);
 	rcu_read_unlock();
 
 	/*
 	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
 	 */
 	if (is_ata) {
+		struct scsi_mode_data data;
+		struct scsi_sense_hdr sshdr;
 		char *buf_data;
 		int len;
 
@@ -735,16 +732,30 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		if (ret)
 			return -EINVAL;
 
-		/* Enable CDL using the ATA feature page */
+		/* Enable or disable CDL using the ATA feature page */
 		len = min_t(size_t, sizeof(buf),
 			    data.length - data.header_length -
 			    data.block_descriptor_length);
 		buf_data = buf + data.header_length +
 			data.block_descriptor_length;
-		if (enable)
-			buf_data[4] = 0x02;
-		else
-			buf_data[4] = 0;
+
+		/*
+		 * If we want to enable CDL and CDL is already enabled on the
+		 * device, do nothing. This avoids needlessly resetting the CDL
+		 * statistics on the device as that is implied by the CDL enable
+		 * action. Similar to this, there is no need to do anything if
+		 * we want to disable CDL and CDL is already disabled.
+		 */
+		if (enable) {
+			if ((buf_data[4] & 0x03) == 0x02)
+				goto out;
+			buf_data[4] &= ~0x03;
+			buf_data[4] |= 0x02;
+		} else {
+			if ((buf_data[4] & 0x03) == 0x00)
+				goto out;
+			buf_data[4] &= ~0x03;
+		}
 
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
@@ -756,6 +767,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		}
 	}
 
+out:
 	sdev->cdl_enable = enable;
 
 	return 0;
-- 
2.49.0

