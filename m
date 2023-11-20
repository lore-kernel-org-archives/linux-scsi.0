Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkfyg/wy"
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2735DCD
	for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 14:56:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F208C433C9;
	Mon, 20 Nov 2023 22:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700520995;
	bh=EQX3/86Vv7wsbEi0uJlh+x4Ip/sHKdTdinG04g68vnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkfyg/wyLENosjZG6e4dT0yxD9G4uwn/1cuiY6WkFO9I79jQkW3DrkZuRB55qyxFV
	 RNiYOxBYaDnu2WrZrT9oMatqTdZJXWV154GRK1vpkSiJxxXn/ZMB+VAlzCadblqVrN
	 T79ED7whGitaAI0/hVMJqaZ4QKdxLDpuh2IxpO+r1Mx1h2ExBUKJSrJEU2pBisvqY1
	 LHzDQACidkeh069N7xGPwS4dAC3fiU61UwhzClt6Bt2HE3mgLZM2JOOulPHiDkK2n9
	 VDN1lgE7QSkg8THR37L/i0c66Ok+Enw+QklHHmEikfnnn7sH6lyG52hcJG8ghFvJIn
	 V2kbxMcZoFBxg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Phillip Susi <phill@thesusis.net>
Subject: [PATCH v2 1/2] scsi: Change scsi device boolean fields to single bit flags
Date: Tue, 21 Nov 2023 07:56:30 +0900
Message-ID: <20231120225631.37938-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231120225631.37938-1-dlemoal@kernel.org>
References: <20231120225631.37938-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime
start/stop management") changed the single bit manage_start_stop flag
into 2 boolean fields of the SCSI device structure. Commit 24eca2dce0f8
("scsi: sd: Introduce manage_shutdown device flag") introduced the
manage_shutdown boolean field for the same structure. Together, these 2
commits increase the size of struct scsi_device by 8 bytes by using
booleans instead of defining the manage_xxx fields as single bit flags,
similarly to other flags of this structure.

Avoid this unnecessary structure size increase and be consistent with
the definition of other flags by reverting the definitions of the
manage_xxx fields as single bit flags.

Fixes: 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime start/stop management")
Fixes: 24eca2dce0f8 ("scsi: sd: Introduce manage_shutdown device flag")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c  | 4 ++--
 drivers/firewire/sbp2.c    | 6 +++---
 include/scsi/scsi_device.h | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c10ff8985203..63317449f6ea 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1056,8 +1056,8 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 		 * and resume and shutdown only. For system level suspend/resume,
 		 * devices power state is handled directly by libata EH.
 		 */
-		sdev->manage_runtime_start_stop = true;
-		sdev->manage_shutdown = true;
+		sdev->manage_runtime_start_stop = 1;
+		sdev->manage_shutdown = 1;
 	}
 
 	/*
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 7edf2c95282f..e779d866022b 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1519,9 +1519,9 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 	sdev->use_10_for_rw = 1;
 
 	if (sbp2_param_exclusive_login) {
-		sdev->manage_system_start_stop = true;
-		sdev->manage_runtime_start_stop = true;
-		sdev->manage_shutdown = true;
+		sdev->manage_system_start_stop = 1;
+		sdev->manage_runtime_start_stop = 1;
+		sdev->manage_shutdown = 1;
 	}
 
 	if (sdev->type == TYPE_ROM)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 10480eb582b2..1fb460dfca0c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -167,19 +167,19 @@ struct scsi_device {
 	 * power state for system suspend/resume (suspend to RAM and
 	 * hibernation) operations.
 	 */
-	bool manage_system_start_stop;
+	unsigned manage_system_start_stop:1;
 
 	/*
 	 * If true, let the high-level device driver (sd) manage the device
 	 * power state for runtime device suspand and resume operations.
 	 */
-	bool manage_runtime_start_stop;
+	unsigned manage_runtime_start_stop:1;
 
 	/*
 	 * If true, let the high-level device driver (sd) manage the device
 	 * power state for system shutdown (power off) operations.
 	 */
-	bool manage_shutdown;
+	unsigned manage_shutdown:1;
 
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
-- 
2.42.0

