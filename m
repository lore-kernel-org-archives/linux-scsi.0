Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B1F2ECE57;
	Mon,  5 May 2025 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486650; cv=none; b=jjSveA55cI14tvl4BZ9tpfIKTDVUBhsMQE486b0/a7sqjnwctIV1UycyDG63owvoFRC+x5JfBvpRTQBuo/hyOKS+IOfZIXHlJcntdqgeV5UcsyzDeltXsQ/tRYixwY7KcyXDS92wJFU7guK70sUBlk9+uA9mmAiQ99+rDf0vP7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486650; c=relaxed/simple;
	bh=9dgeRB9RiOpL/1PMxwmzRWywCC+qvQOmB5skJqPYObU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DZu+hS3HCXGfXuFNJtpD4DDkmBsWwJ/s3ib6sfEwediryXU6QmiqCz3ujd9aQcmIH/Tlx/iDnkhByyT82HTRJCVHtH0jvbGxm0RNDNpm0vi3KlOb4rXnfGW7Gj4axz+1ftOKdXET5jEFK9eX9tfk4iHUtpH/qTb9+UghOAc7N1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aD+w/2pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aD+w/2pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB479C4CEF2;
	Mon,  5 May 2025 23:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486649;
	bh=9dgeRB9RiOpL/1PMxwmzRWywCC+qvQOmB5skJqPYObU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aD+w/2pkNv0ZO0ldQiPKB87meMIOS932q9oOtEysiJ5lPNPnhK3UDrYIUv6hVm8CU
	 eFnyXz0Az8lJUapLkYcTHNuhGe6CSXc42UraUl2lk8ot+w4AIZWBz6y1l6WZKsHGFO
	 hGyuFm/kkzsIuoNw1QS85WG2YBXN/tyVzL4GuRy8GntcQcLAasp3L//5eh6GIrpnyE
	 VjGCTkhOaHZSKL2kkqL2vUDz40kXKpZKjJN4kt8tVqK7Dw/6aG4nw5oyi5ovvNxinK
	 bRLbSm55irU00T9E5Cm7z9EFeOoXkQ8wjlgIW0+FYAxBSen1dwR8d08JBX1ZyT3415
	 EP3qnwprz2OQA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 135/212] scsi: mpt3sas: Send a diag reset if target reset fails
Date: Mon,  5 May 2025 19:05:07 -0400
Message-Id: <20250505230624.2692522-135-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
Content-Transfer-Encoding: 8bit

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 5612d6d51ed2634a033c95de2edec7449409cbb9 ]

When an IOCTL times out and driver issues a target reset, if firmware
fails the task management elevate the recovery by issuing a diag reset to
controller.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Link: https://lore.kernel.org/r/1739410016-27503-5-git-send-email-shivasharan.srikanteshwara@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index fc5af6a5114e3..863503e8a4d1a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -679,6 +679,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	size_t data_in_sz = 0;
 	long ret;
 	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	int tm_ret;
 
 	issue_reset = 0;
 
@@ -1120,18 +1121,25 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			if (pcie_device && (!ioc->tm_custom_handling) &&
 			    (!(mpt3sas_scsih_is_pcie_scsi_device(
 			    pcie_device->device_info))))
-				mpt3sas_scsih_issue_locked_tm(ioc,
+				tm_ret = mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
 				  0, 0, 0,
 				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, pcie_device->reset_timeout,
 			MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE);
 			else
-				mpt3sas_scsih_issue_locked_tm(ioc,
+				tm_ret = mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
 				  0, 0, 0,
 				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, 30, MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET);
+
+			if (tm_ret != SUCCESS) {
+				ioc_info(ioc,
+					 "target reset failed, issue hard reset: handle (0x%04x)\n",
+					 le16_to_cpu(mpi_request->FunctionDependent1));
+				mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+			}
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	}
-- 
2.39.5

