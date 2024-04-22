Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6907716C84B;
	Mon, 22 Apr 2024 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713830191; cv=none; b=UMSCXSqC69U4lz6UjOQg0Lyx14/SCQaS0TZEvDM5vyq2tlpdPdyVGdw4sEHfDQMSRzwG9ioNPTygNF3jPfM6+QNcFwuqZgtzEvpOo5gSkEU/IM0y1l0FyYJJfZyv/SCbZWShbxj+bnjMaAVmLMJl0qf/fUpjIOE8s1QAXRVcrXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713830191; c=relaxed/simple;
	bh=rBjfbfl3JjgBv0+x4fmxGU+HgmS064ASrOJqWcVwUbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPr5yZEgMu8gsib5bSy155YD4cTUpUqMDDJad5WRtYjbXKYP9qOs33id2uQBS8/ZLBZ/ekCnz+QcxyqZCj/Cmkrk85SdMcV2U6zG6rtQhgVKYnLjs1NcE80e2yHestjKhmOepScv6XzwMqhEIxwEIY6tZ1jpq5DwaXb6U7woYT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8jA3Lx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8jA3Lx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604AAC32782;
	Mon, 22 Apr 2024 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713830191;
	bh=rBjfbfl3JjgBv0+x4fmxGU+HgmS064ASrOJqWcVwUbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8jA3Lx1pfAMm1IdRdLjvPg82vKXSoK6/lF+H6VeJfus41TpgObBBgDNnq1JNncSB
	 Yh4J+y9UBRnlJCZ0cZvgGAYS/pmu7pp72cvKnVqI4+UCXd5+5eMr7n/yO4Jw28/gcd
	 8+LHwBrhrinPHq2hhO35oF0+BpG1UvnOvkkcVI7gYwVPXCoq22Hbq4zYyPI0z2P+62
	 75335xNlB6VMTF3gBClZizlyvDMqE5ch/LjH114zhm5m6zIuBRIVVNzpSmmzZ9AeaI
	 cghnrcwUp6I5S0Uaq1wTuyDv/oqKvU7a8kQ+BcmWA/FnTYK1YrtsrxhJqN9ayJ+t06
	 lXfTBZg/knTNQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Xiang Chen <chenxiang66@hisilicon.com>,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 12/29] scsi: hisi_sas: Handle the NCQ error returned by D2H frame
Date: Mon, 22 Apr 2024 19:16:53 -0400
Message-ID: <20240422231730.1601976-12-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422231730.1601976-1-sashal@kernel.org>
References: <20240422231730.1601976-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.28
Content-Transfer-Encoding: 8bit

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 358e919a351f2ea4b412e7dac6b1c23ec10bd4f5 ]

We find that some disks use D2H frame instead of SDB frame to return NCQ
error. Currently, only the I/O corresponding to the D2H frame is processed
in this scenario, which does not meet the processing requirements of the
NCQ error scenario.  So we set dev_status to HISI_SAS_DEV_NCQ_ERR and abort
all I/Os of the disk in this scenario.

Co-developed-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/20240402035513.2024241-2-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e914c0c13bb5b..6b97c066e6631 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2245,7 +2245,15 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 		if ((dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
 		    (sipc_rx_err_type & RX_FIS_STATUS_ERR_MSK)) {
-			ts->stat = SAS_PROTO_RESPONSE;
+			if (task->ata_task.use_ncq) {
+				struct domain_device *device = task->dev;
+				struct hisi_sas_device *sas_dev = device->lldd_dev;
+
+				sas_dev->dev_status = HISI_SAS_DEV_NCQ_ERR;
+				slot->abort = 1;
+			} else {
+				ts->stat = SAS_PROTO_RESPONSE;
+			}
 		} else if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
 			ts->residual = trans_tx_fail_type;
 			ts->stat = SAS_DATA_UNDERRUN;
-- 
2.43.0

