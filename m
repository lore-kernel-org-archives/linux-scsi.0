Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BF816BE23;
	Tue,  8 Oct 2024 13:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394298; cv=none; b=IEGDfrzNgPZeSaXeIonTkj/FYNYiyPMlQrnFWoctKZrwGEpFPbWqx4x5SAL6JD1k7pyzZ9dBhGt5jr+XvnewFOQYf3VApmiIGzVo4lINf0xzgPjb0luZZ8wHMzlUUum9rn+YNg3N+jFcKkjTcntLcJXh3m82WS5zl8to4Xuo7GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394298; c=relaxed/simple;
	bh=+OlTN/ovL6RkNLVjZ/Iaghl07ZO1wj2GKZnvSY5+ZNk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rOEFjbt7AIQvsJsHKBMUxkOa5s26t6ehz+SHOrwFIHRv7gu37+SEX3CxwRTXYEx5f9wjg6DQdybN3NMRfLNkoKSH6dqk5r+Ir9IGoOlKNKGlYssvcUMWngQQ7Rsz4xp4VrltF2SBHvDSGMTX7ZeYaC7AQDFya6ItobYZ83hcZrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=RQ4cBBIn; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=PdgABHd/; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="RQ4cBBIn";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="PdgABHd/"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 9FA50E0018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728394293; bh=H1oTRc4Y1f8WkNfiYna4kFAAcmxaeENZkzKrTLhD6m0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=RQ4cBBIn1K+tL/9yEDUV19AOSFGXmO2gCwPxQWNT2nhgRcydriSHzuLaqmK5v2f4Z
	 9ivW/t9rI3GEQd23mqIbk0TuNmtY+1A6r6zn0hnPuH9DjXrDpE807hQFU5grVQ/7V/
	 T5MeqJcHBOwXe0EoLvtfLuBv2zv75bsnt6bz+0TaTu2GObze6gJPrUC1wtTby9xwXS
	 +m/GHDSI6+mavfsXz/FaA3hXaquw00P5LsV8iTQ1kPFC9SVTI8TUjocErhLgzO/wOA
	 iIxbHg4gq7I//84t27iw+5XRFjlPtEFJTHVktFmRWegUz8GYzOQN1uwJT9tiKzG0Zp
	 hNGDM9HOEPSiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728394293; bh=H1oTRc4Y1f8WkNfiYna4kFAAcmxaeENZkzKrTLhD6m0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=PdgABHd/9UepfPXsX9JnkAjkNw6BNZxlK3yBSBCYqcLpyvJsk1bLqZD37Cqn76CPf
	 +rywM7G6bjKQdvsibLR52DZpKTNVtjv4PyqKmc9cwdwKzEHWHGL4/o1xDfd1a1IhUm
	 HO7FSyLwcfMtSe0/9eDd8/5q585Y1f4WUsnZ4isbo0xNGkHrFo9aU+i0Uc3xmyh770
	 QBRoOhxlmz/2HvQ4xEqQatx09t9i/kdMiRVlrCy5cyO4vJ4ybr0a2AOQTQbC7gjJkG
	 HP+JSd1K+snvojk4AIfNmt73f4Yo94IFN7UT9pzAJn2craeMCnFiSNM0YAlBTh5mcv
	 DynL1asB/UFwQ==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <nab@linux-iscsi.org>,
	<himanshu.madhani@cavium.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH 1/3] scsi: qla2xxx: Drop starvation counter on success
Date: Tue, 8 Oct 2024 16:24:00 +0300
Message-ID: <20241008132402.26164-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241008132402.26164-1-a.kovaleva@yadro.com>
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Long-lived sessions under high load can accumulate a starvation counter,
and the current implementation does not allow this counter to be reset
during an active session.

If HBA sends correct ATIO IOCB, then it has enough resources to process
commands and we should not call ISP recovery.

Cc: stable@vger.kernel.org
Fixes: ead038556f64 ("qla2xxx: Add Dual mode support in the driver")
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_isr.c    |  4 ++++
 drivers/scsi/qla2xxx/qla_target.c | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be3..5234ce0985e0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1959,6 +1959,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		ql_dbg(ql_dbg_async, vha, 0x5091, "Transceiver Removal\n");
 		break;
 
+	case MBA_REJECTED_FCP_CMD:
+		ql_dbg(ql_dbg_async, vha, 0x5092, "LS_RJT was sent. No resources to process the ELS request.\n");
+		break;
+
 	default:
 		ql_dbg(ql_dbg_async, vha, 0x5057,
 		    "Unknown AEN:%04x %04x %04x %04x\n",
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d7551b1443e4..bc7feef6ee79 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6801,6 +6801,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 	struct qla_hw_data *ha = vha->hw;
 	struct atio_from_isp *pkt;
 	int cnt, i;
+	unsigned long flags = 0;
 
 	if (!ha->flags.fw_started)
 		return;
@@ -6826,6 +6827,16 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
 			    ha_locked, 0);
 		} else {
+			/*
+			 * If we get correct ATIO, then HBA had enough memory
+			 * to proceed without reset.
+			 */
+			if (!ha_locked)
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+			vha->hw->exch_starvation = 0;
+			if (!ha_locked)
+				spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 			qlt_24xx_atio_pkt_all_vps(vha,
 			    (struct atio_from_isp *)pkt, ha_locked);
 		}
-- 
2.40.1

