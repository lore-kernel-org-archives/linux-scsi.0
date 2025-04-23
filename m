Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B64226B09F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 18:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433188; cv=none; b=R39c78A7sMC8AlZjR0Q28XhKRk15NBUpdyulS55txN8yRUHeevaMnf9cxM4ivTZZ9YHlmNPF9gJ+4cWRCvne47LyTS4MLCKRVDOtf04/Z5Up96m5SC/FICqk6GWBbXpBeMhpQoWEvC8VZT9V+LUfFtc2SOK+73sM6+X7vCOT+ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433188; c=relaxed/simple;
	bh=k6RYu4gJzGOxlL6KVTX6HkVM2RCwXu9gHX4fp6HujWc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOunbytwYPQVMLMsiPgmn1wW+Kif0pzM79dd+llTFtiGDJ8pXq17jXKKgPLNGOrJqAbAdJCZol/yYIXQhBnGji8btvSqmp6P8s75F2Xw3tUVYm86aM5C0MNsch5A8scGa1r7bUwWE6kQxVcydlNhwyzT7wUxtesC8RYispLGOsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=XtZWTE/1; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="XtZWTE/1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1745433188; x=1776969188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k6RYu4gJzGOxlL6KVTX6HkVM2RCwXu9gHX4fp6HujWc=;
  b=XtZWTE/1pkCEYxN1FsJSUm2Kt4fRIdYWC+xrGJs6Y8dslj7cpEBhpKvG
   dRpl8dbbsA9/Jx9X4zDDcBdum3gRn/PEPDbeXxBdFd+zbhTiFYgB83Jqm
   8XOYh0HQVc3117EgGk+7PhM6fB1lKx0VJGfXMUVTvJWYlysiiBip1g0Bx
   ur66IDPj6Z6/Z6MYerkA/nCBY3hE0Ls/jPLLCl4wR9FryHoDZhgnmakhR
   apLjcJnSVOL/VKL6WjTjiSyKSO++A2OzdyIfZkNSldxehTyrlQtf3EQEf
   Yh+Et8aHaXr/+aDERAFqT2p+sb/USIgoYGSej3wKO7crv1yKm6TVuzgz+
   w==;
X-CSE-ConnectionGUID: whCUM/FPRpqRy+T/Tuj6Xw==
X-CSE-MsgGUID: mEmgiD/rQNW5IEY/Chf+rQ==
X-IronPort-AV: E=Sophos;i="6.15,233,1739862000"; 
   d="scan'208";a="40821227"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2025 11:33:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 23 Apr 2025 11:32:35 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 23 Apr 2025 11:32:34 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <hch@infradead.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<joseph.szczypek@hpe.com>, <POSWALD@suse.com>, <cameron.cumberland@suse.com>,
	Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 4/5] smartpqi: fix smp_processor_id() call trace for preemptible kernels
Date: Wed, 23 Apr 2025 13:32:28 -0500
Message-ID: <20250423183229.538572-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.49.0.391.g4bbb303af6
In-Reply-To: <20250423183229.538572-1-don.brace@microchip.com>
References: <20250423183229.538572-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Yi Zhang <yi.zhang@redhat.com>

Correct kernel call trace when calling smp_processor_id() when called in
preemptible kernels by using raw_smp_processor_id().

smp_processor_id() checks to see if preemption is disabled and if not,
issue an error message followed by a call to dump_stack().

Brief example of call trace:
kernel:  check_preemption_disabled: 436 callbacks suppressed
kernel:  BUG: using smp_processor_id() in preemptible [00000000]
         code: kworker/u1025:0/2354
kernel:  caller is pqi_scsi_queue_command+0x183/0x310 [smartpqi]
kernel:  CPU: 129 PID: 2354 Comm: kworker/u1025:0
kernel:  ...
kernel:  Workqueue: writeback wb_workfn (flush-253:0)
kernel:  Call Trace:
kernel:   <TASK>
kernel:   dump_stack_lvl+0x34/0x48
kernel:   check_preemption_disabled+0xdd/0xe0
kernel:   pqi_scsi_queue_command+0x183/0x310 [smartpqi]
kernel:  ...

Fixes: 283dcc1b142e ("scsi: smartpqi: add counter for parity write stream requests")
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Tested-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index efc042071ec0..e8abfc56d0f0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6003,7 +6003,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 			pqi_stream_data->next_lba = rmd.first_block +
 				rmd.block_cnt;
 			pqi_stream_data->last_accessed = jiffies;
-			per_cpu_ptr(device->raid_io_stats, smp_processor_id())->write_stream_cnt++;
+				per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id())->write_stream_cnt++;
 			return true;
 		}
 
@@ -6082,7 +6082,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
-				per_cpu_ptr(device->raid_io_stats, smp_processor_id())->raid_bypass_cnt++;
+				per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id())->raid_bypass_cnt++;
 			}
 		}
 		if (!raid_bypassed)
-- 
2.49.0.391.g4bbb303af6

