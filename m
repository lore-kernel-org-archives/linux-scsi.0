Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw3oeeAq"
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B0C1
	for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 14:56:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FDBC433C7;
	Mon, 20 Nov 2023 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700520997;
	bh=zYzjASgAhGCTwD/qqoBAN9DxzzXgVpa3MZatwKVfpF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vw3oeeAq9rUfY/KoFMXLCChSbMvrxrrlJsPXnTY5+gok/C31GXZcayjxzg/lA0dKE
	 vxcuRL5Ygeg6IuJt6UJobaSM+f6WfYTo+gxtBQG5OOkCwTXnqkDkabzoKIuiHEr1Cz
	 ZbOTniWqRrMdbVmsfUs3rUtpSLjmdIglywYHxcNyiW3lBI0G5OhrPj6qt18H+jISGV
	 +6nVSDO9LJP1v6kEK2BmMy1ITGx21TMuxhACN9gABDfa5QdEnLcct4fSknyejMqINs
	 X7zxyRCglX3KZMgLEln1zV5QAPsMPBjk/e8DNDSFg4Wo5eGv2qeYLLfUQXFPKCGYWV
	 WQMJnuRF8cx8w==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Phillip Susi <phill@thesusis.net>
Subject: [PATCH v2 2/2] scsi: sd: fix system start for ATA devices
Date: Tue, 21 Nov 2023 07:56:31 +0900
Message-ID: <20231120225631.37938-3-dlemoal@kernel.org>
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

It is not always possible to keep a device in the runtime suspended
state when a system level suspend/resume cycle is executed. E.g. for ATA
devices connected to AHCI adapters, system resume resets the ATA ports,
which causes connected devices to spin up. In such case, a runtime
suspended disk will incorrectly be seen with a suspended runtime state
because the device is not resumed by sd_resume_system(). The power state
seen by the user is different than the actual device physical power
state.

Fix this issue by introducing the struct scsi_device flag
force_runtime_start_on_system_start. When set, this flag causes
sd_resume_system() to request a runtime resume operation for runtime
suspended devices. This results in the user seeing the device
runtime_state as active after a system resume, thus correctly reflecting
the device physical power state.

Fixes: 9131bff6a9f1 ("scsi: core: pm: Only runtime resume if necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c  | 5 +++++
 drivers/scsi/sd.c          | 9 ++++++++-
 include/scsi/scsi_device.h | 6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 63317449f6ea..0a0f483124c3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1055,9 +1055,14 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 		 * Ask the sd driver to issue START STOP UNIT on runtime suspend
 		 * and resume and shutdown only. For system level suspend/resume,
 		 * devices power state is handled directly by libata EH.
+		 * Given that disks are always spun up on system resume, also
+		 * make sure that the sd driver forces runtime suspended disks
+		 * to be resumed to correctly reflect the power state of the
+		 * device.
 		 */
 		sdev->manage_runtime_start_stop = 1;
 		sdev->manage_shutdown = 1;
+		sdev->force_runtime_start_on_system_start = 1;
 	}
 
 	/*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa00dd503cbf..542a4bbb21bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3949,8 +3949,15 @@ static int sd_resume(struct device *dev, bool runtime)
 
 static int sd_resume_system(struct device *dev)
 {
-	if (pm_runtime_suspended(dev))
+	if (pm_runtime_suspended(dev)) {
+		struct scsi_disk *sdkp = dev_get_drvdata(dev);
+		struct scsi_device *sdp = sdkp ? sdkp->device : NULL;
+
+		if (sdp && sdp->force_runtime_start_on_system_start)
+			pm_request_resume(dev);
+
 		return 0;
+	}
 
 	return sd_resume(dev, false);
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1fb460dfca0c..5ec1e71a09de 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -181,6 +181,12 @@ struct scsi_device {
 	 */
 	unsigned manage_shutdown:1;
 
+	/*
+	 * If set and if the device is runtime suspended, ask the high-level
+	 * device driver (sd) to force a runtime resume of the device.
+	 */
+	unsigned force_runtime_start_on_system_start:1;
+
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
-- 
2.42.0

