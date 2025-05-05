Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66565390E1B;
	Mon,  5 May 2025 23:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486998; cv=none; b=NidUkj1w8IoS58oDNo8oy2c5c7qA9M9L0qBHLhT+Weog29WF1BgAC9eaNTPD2ZYf8HNA2y5VC5FYB8pu11/weJbF1LAXbCIC5dnM9TVwDVI2lguR+9obbJJaWFMjYkNzGT2VLPgGSMmFRzOyHnTv7es4UPZ2euZ+eOaPMyejsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486998; c=relaxed/simple;
	bh=kE+Ox8+wh2XWdCq4ivPaCQX40m7HZo0+tSTOrHgS04E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dRE84BTks1BxJWoiILcNLlUaFOeJUCoPFwXKhmZ8RrSlGOyVobsKnHaoFegBAk91yXoB9UaIaUFpE5WIT19pm4tFy1a603VIhAXayepy0pwtNUyqvnyNbwMO5pQGVGIJh0zL19fYGbKWQCclo/GbSFTG5NcYkLW3Y6jrdOLsnkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/qZmqL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/qZmqL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23002C4CEF2;
	Mon,  5 May 2025 23:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486997;
	bh=kE+Ox8+wh2XWdCq4ivPaCQX40m7HZo0+tSTOrHgS04E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/qZmqL0XvZP+RTu+GeaHA5eTJ0YEIgWNJhe/XzWT+Z0QBr0REBV/6BGHs662zfZY
	 94fq2sKVAyYNi3jSvKIr4snpDxG5UCEsNMCij5tIwq0RKS6B6xvz4ApV+QdJvGD7Rs
	 nalPyFvvt22sQ+iP2oV6t6tSTC0Ze6J+3eyq1FVckbg2oBsr6J30c4OnILPQ/UG30A
	 XaQRRZLF8/5KnWqxaxAqStB0rHi1l/y4wdAfXZ7whYtDXKHI3BxXEQ8ktIhKUHGuiS
	 lbAme1Zh3Ix5TRmxE/wNnC3n2rNuXhBxJjiDnsmiR2tjlHDhDTjFrURnP1DUmmXUze
	 HWETn/xJll7Sg==
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
Subject: [PATCH AUTOSEL 5.15 098/153] scsi: mpt3sas: Send a diag reset if target reset fails
Date: Mon,  5 May 2025 19:12:25 -0400
Message-Id: <20250505231320.2695319-98-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231320.2695319-1-sashal@kernel.org>
References: <20250505231320.2695319-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
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
index 20336175c14f5..81cd96b93bdf8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -678,6 +678,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	size_t data_in_sz = 0;
 	long ret;
 	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	int tm_ret;
 
 	issue_reset = 0;
 
@@ -1111,18 +1112,25 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
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

