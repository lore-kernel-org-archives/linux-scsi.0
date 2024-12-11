Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBC242F03;
	Wed, 11 Dec 2024 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943100; cv=none; b=RRWdC/wVGf4yw5NQxd359kS6kSqY+kp0kaF2xjZSf5X5F6TitUBi+bUrlK9/Z1ZRqMhjkmidYnb9aiSLPS1Pl46Qf3XgQGDsd/o4TdDqORBl9CrOtJp9AEQpcdn2BCoLY97Da8CaSosbGAy0wfWp9cz+MRN4dN4e62cP5bVmR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943100; c=relaxed/simple;
	bh=nHZ9ez5NEG3v/aXAwov+Llsdqu13OQNFnQ0ciLbwRqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFZ1V2TU+OJNpz82vAr1VoZ5b3VnzdvqF0FHWAp4caxGmYPr432MDge1JIplB8WL/ra0LJtWR61cQE1r9VzyXeffFcgOsEjor4bnX4gnL9ATPLgc/h/DIO+1MmdN6nEzKGB5eMSTdopolZpI3FhKTZ+ojYHQAfMnXz6YMx2Wgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uO6dHw+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uO6dHw+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5E2C4CEDE;
	Wed, 11 Dec 2024 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943100;
	bh=nHZ9ez5NEG3v/aXAwov+Llsdqu13OQNFnQ0ciLbwRqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO6dHw+h107i65J3uGXKvvO3GE+Cj57VGGU9f2VRbyereqobauMv4Sw3iU+qTEb9f
	 kLaDAvllWlP4heJiISX1TtMYxwS307Sky9aqaDl8ZiT4jT1lgAPZYHl/demRt+uRvB
	 JFSQWhyNi9EBfB1Mb0ayTxGt44qJbM6y2eVzVRRa46ni45y813uPuswl41GXmt0lT2
	 +THMpKovP65HEL5QeLedRbhZl9e1aahZNLweTAnVpvMng8KuD/jtIdou9tiW9TMJOh
	 v5axucxhY+Cy4uxW+ulmL2sC1FBj3eS7rK2iCTvd9h+5u+PqqfZkLpuM5DdsnZYwXu
	 xbV2YU+Iluuzw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Prayas Patel <prayas.patel@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 28/36] scsi: mpi3mr: Handling of fault code for insufficient power
Date: Wed, 11 Dec 2024 13:49:44 -0500
Message-ID: <20241211185028.3841047-28-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185028.3841047-1-sashal@kernel.org>
References: <20241211185028.3841047-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.4
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit fb6eb98f3965e2ee92cbcb466051d2f2acf552d1 ]

Before retrying initialization, check and abort if the fault code
indicates insufficient power. Also mark the controller as unrecoverable
instead of issuing reset in the watch dog timer if the fault code
indicates insufficient power.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-5-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2e6245bd4282e..5ed31fe57474a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1035,6 +1035,36 @@ static const char *mpi3mr_reset_type_name(u16 reset_type)
 	return name;
 }
 
+/**
+ * mpi3mr_is_fault_recoverable - Read fault code and decide
+ * whether the controller can be recoverable
+ * @mrioc: Adapter instance reference
+ * Return: true if fault is recoverable, false otherwise.
+ */
+static inline bool mpi3mr_is_fault_recoverable(struct mpi3mr_ioc *mrioc)
+{
+	u32 fault;
+
+	fault = (readl(&mrioc->sysif_regs->fault) &
+		      MPI3_SYSIF_FAULT_CODE_MASK);
+
+	switch (fault) {
+	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
+	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
+		ioc_warn(mrioc,
+		    "controller requires system power cycle, marking controller as unrecoverable\n");
+		return false;
+	case MPI3_SYSIF_FAULT_CODE_INSUFFICIENT_PCI_SLOT_POWER:
+		ioc_warn(mrioc,
+		    "controller faulted due to insufficient power,\n"
+		    " try by connecting it to a different slot\n");
+		return false;
+	default:
+		break;
+	}
+	return true;
+}
+
 /**
  * mpi3mr_print_fault_info - Display fault information
  * @mrioc: Adapter instance reference
@@ -1373,6 +1403,11 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_info(mrioc, "ioc_status(0x%08x), ioc_config(0x%08x), ioc_info(0x%016llx) at the bringup\n",
 	    ioc_status, ioc_config, base_info);
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto out_device_not_present;
+	}
+
 	/*The timeout value is in 2sec unit, changing it to seconds*/
 	mrioc->ready_timeout =
 	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
@@ -2734,6 +2769,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	mpi3mr_print_fault_info(mrioc);
 	mrioc->diagsave_timeout = 0;
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto schedule_work;
+	}
+
 	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
-- 
2.43.0

