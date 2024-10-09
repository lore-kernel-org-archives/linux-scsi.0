Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C5C191F85;
	Wed,  9 Oct 2024 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472669; cv=none; b=CqFIhtrqzI5P7qLNrdPem5kFtvFrU419zHTfCvLDrRids4ZnmMaQzwflfDUz5ZXrC1BoFog+Zu3Fjmvs4F97Uix5ZXHyWj1s49SwyjDwj1j21adCFBp4uO0ureCi8ct80GtzKDz5chpLwHcdBCuggK2/6GlEQJCqwgTYh2r6mR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472669; c=relaxed/simple;
	bh=5aHOeAtBoQ4fy9LIVowu40CIt8+E+nZORgo1JCwLaMs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZzL5quo8adsC8oGNTfapFjRmP6SIwxSULMWvpiXIda8wptaDJNu2kgptgvEqFBxGASFLBCnS0vffS8dv6P1KZdjNbR2da6p/ag6QPbN0TYOrooPbrLzOnbEKncQuorid4I2UDn6GWjzcWmSkY3gKFeVOW2EwzOOpSRLhN9yLVmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=MFkklhY7; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=mz5uD94U; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="MFkklhY7";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="mz5uD94U"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com D3ED9E0010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728472661; bh=sB43ziImdTPLgJU6g+q4wMVcdAGDARS25Yq8tvz7Y9s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=MFkklhY7m6kgOTJesJMrQW2kHYM4UV4AticrjWsJMp0w3IgaSftEryyfrvF3fVucn
	 TpkvPfzu4PQQov2McvHoLy4XgasZOddRnKsDx6Zjvdfh1lTe/xcZJ7/6juDF2MKPTo
	 +KRn6oit0nWpR4yZeW8IclIGfZgXWMwIOOy5BQrLv6tclEECnjJ7c4iLdkZo3Blm27
	 oyjLGrxyCvoY+2fzC9FBZsY2Om1T5ql5WHkxRFGnGE/viCTvAKYaFiIjjHJbZ6azfH
	 jHwRxcHePCRxPPh85kC5Mw31YwPLZu8FP/oirPIsysCEEjq8KpD2p4aa6BMV03GZCL
	 dQaDUGlfp/Cgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728472661; bh=sB43ziImdTPLgJU6g+q4wMVcdAGDARS25Yq8tvz7Y9s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=mz5uD94UePKwv5w1OgF8sDDxDD+DnzmCYCTFvJfCDIjYhA/+Lq3/cWucyKkycMFmT
	 rFvx6nB+gO+IFYTK1jEsVE0ZBfQXqcr+t0FmTQPIH+6x4GnIQGEnqkKo4w9WEFnnUv
	 pI7o7X1QOVQnqndkMG7q9ph8U/jO98jU2daRKZlS+8cHYST9k9KMoCDtLjGQJO4/u2
	 ySH3zwrO1TrchELcXXgikxkC7bf9dG3WTbN1IhtOP0j5w4PXiupeIwgyrv8+WETHGb
	 zWD0JXQJccu4X11rfQnWvW0FdNuGca0TGaj/1GQp0nUD724sgto4fib5uMfV6M8CYw
	 /efkezeodzwDg==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@cavium.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] scsi: qla2xxx: Drop starvation counter on success
Date: Wed, 9 Oct 2024 14:16:52 +0300
Message-ID: <20241009111654.4697-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241009111654.4697-1-a.kovaleva@yadro.com>
References: <20241009111654.4697-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
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
 drivers/scsi/qla2xxx/qla_isr.c    | 4 ++++
 drivers/scsi/qla2xxx/qla_target.c | 6 ++++++
 2 files changed, 10 insertions(+)

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
index d7551b1443e4..bc6b014eb422 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6826,6 +6826,12 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
 			    ha_locked, 0);
 		} else {
+			/*
+			 * If we get correct ATIO, then HBA had enough memory
+			 * to proceed without reset.
+			 */
+			WRITE_ONCE(&vha->hw->exch_starvation, 0);
+
 			qlt_24xx_atio_pkt_all_vps(vha,
 			    (struct atio_from_isp *)pkt, ha_locked);
 		}
-- 
2.40.1

