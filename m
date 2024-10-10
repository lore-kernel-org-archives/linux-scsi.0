Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31CF194C8B;
	Thu, 10 Oct 2024 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578056; cv=none; b=htiACvJN5lsChqtAVv0S/N8fFQLdqf18vlKCCmv2eYKc5Z3OndK+3x+g1+MGxFVYwzEJXqx8g9MNiO+QtaeeLToXGNXMEQi2a8yZMsmI//rkH0d5stouReWdPCLdJz4e+3trMHU9NkUsRqM4QEnCInJQOZBKt4v9bbkc8p46Omg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578056; c=relaxed/simple;
	bh=tr8pkrnOXKz7zS3wPd0Hnto0kzymsME6yt2kXtU/XWI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pV2cD/ZXTeXEpPORpLwN7i2myI3By3sly7J7ojj87HbxiwBRr9F7QNk6iLPRTy1tp2yXFTere9QkB4oSfNws02rtiZ/axeRVwvWJZUKazC1QehmMmJiIQ2eUgB53TaCp+xibpSGNPxORXlXZiYVs6wSwIX8Fhnsbu6BOamh5Rck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=Lkr3JkP6; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=TywZBUkJ; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="Lkr3JkP6";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="TywZBUkJ"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com E54B9E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728578050; bh=Sh3HKrB3v+QaFjAI8p9VP95XJqBlxSmNtlnT9W1h0mE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=Lkr3JkP6sdodiK5awbExfLhvsfj/nZKU1t2fxT/IlVxA3PFDfZIlGfTDsJyx+jsm3
	 r55BZA/9gayaRHmTtvbLzbcI6BWo/pgoOTesWoZCkzZEk1JaxHE2BujPs9K7sUJLtQ
	 U2NjBN7T7okZHm9D2JdVnzns2lubfKzcw/KCOG9R6ZB0T0f2UJr5N3aAopBykucG+3
	 vkgmRZIlMP0I/mBhSwilUussG06U3Y6sF125+jTHn1WlNPyb2h0F++QOAtmCvH1G3a
	 QxceOY8m7qDgrPdsfC1Ohba0hX/Iv0A9iu6ErM5yyFTeVs2d25BDGnKul3q9+KVaxc
	 s7djBIy9J7npw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728578050; bh=Sh3HKrB3v+QaFjAI8p9VP95XJqBlxSmNtlnT9W1h0mE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=TywZBUkJZs2EeclEEQediS/df367he4eaYziBNWgXkzVDs7y9Ycy4nd6tlTPI1/Tn
	 vl5aiMya1BKYAU/gjFtZ5o82NHJ2hRszAHOvIfXJZn5s7hAsh0Or9ylkRPEhY0PmJ5
	 EXNojojOfjt/f3t86kSmxaSTF9I+rUaFGa9SsUpmjF6lhHNeTCns0jyZAEZ+5c2h4O
	 CK6hXVkhm++kfI9YVt0NQIuBQ7obiT2N99T/Lk3Cwh2AdEqvrYJQ+LOLyITLONd//W
	 RhD1SpHYrOr244A+Eww9t+5pJjbqhGp8xYDiPwarRYcy9bSOO960YQNxIc2T6l8eqc
	 uKn+y+fw8dodw==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <himanshu.madhani@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>, <hare@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH v3 1/3] scsi: qla2xxx: Drop starvation counter on success
Date: Thu, 10 Oct 2024 19:32:35 +0300
Message-ID: <20241010163236.27969-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241010163236.27969-1-a.kovaleva@yadro.com>
References: <20241010163236.27969-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-08.corp.yadro.com (172.17.11.58) To
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
index d7551b1443e4..0a82360141f8 100644
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
+			WRITE_ONCE(vha->hw->exch_starvation, 0);
+
 			qlt_24xx_atio_pkt_all_vps(vha,
 			    (struct atio_from_isp *)pkt, ha_locked);
 		}
-- 
2.40.1

