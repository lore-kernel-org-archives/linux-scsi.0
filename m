Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA94D14A0B7;
	Tue, 15 Apr 2025 00:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676903; cv=none; b=pgxMKY+BbO83j0kiWPsM4zcL5xv7+nXYjV2ahq8e4CnIZS7Wk0j2uctM0IhR2IzBwOeww7VdjtdapyPGtkAEdrOAxsjKQjooHKNEIhVO2OVOObJlS+F7KUZzJJMn42ECdPzjBrZQEULrG7APcJ0EpFF4jM5+RU9GCjM4yvUMKDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676903; c=relaxed/simple;
	bh=S9WqlAPk15FLu4y+RDpz3a2PdBz0FRyegL/qDVKFPeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5QAf5jV6UCQnnrxjMDaI7uPSDxjNRGWJQ0O0l6oUXwxuxdBj5c6lP6Ht/Ut9FhAMbMa/5FliakakXFJh+rgOJw/wXIUb7NmwAx10Esx5YmVGmXR5SmNV6hB82B77+i3HICsngzQ/U2HT+1e2P0tdiSSc+uGvQQqTe+4o/J2QCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=JTayQbEM; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="JTayQbEM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=SL0phU/G9T3j0VI5/RLTYm6D8TJuMcZGybgtCw8AavE=; b=JTayQbEMskaTOjng
	MYlOpUDrlwNHWw5aMB9hSUwsrnE/ioanYzB5ckZE1Q0n6HDz1+gg3jBzeqC+6OmkBok0vRWJNwpi2
	ZhZcvNeLsguRJ2P6/Wi/KTlBfPNydVRsorPiBC/m5ssQNwWTHEg7RNACIZPfldYsvRa82/Ii4Q0EM
	KN9dQdCKDmXkU3mPr7rHM3jRq7dDQl2r7NobQ3aVqrkUbhPezZA+wF+2xj5Dl5vlYQcfvzxpVYdwt
	Qyp9le0v9PJxZu9t6Qpa/OcyIJyExgL8bhiadovxcjNv8r6qBNDOB+3sTyjOknYnJSNN6Fe6opB5r
	EM57eDxe3KWMnZoUHA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9o-00BSPG-0K;
	Tue, 15 Apr 2025 00:28:08 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 7/8] scsi: qla2xxx: Remove unused qla2x00_gpsc
Date: Tue, 15 Apr 2025 01:28:02 +0100
Message-ID: <20250415002803.135909-8-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qla2x00_gpsc() was added in 2017 as part of
commit 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
but has remained unused.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  1 -
 drivers/scsi/qla2xxx/qla_gs.c  | 90 ----------------------------------
 2 files changed, 91 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 73bccd514791..a8c3a4f7862b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -720,7 +720,6 @@ extern void *qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 extern void *qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 extern int qla2x00_fdmi_register(scsi_qla_host_t *);
 extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
-extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
 extern size_t qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *, size_t);
 extern int qla2x00_chk_ms_status(scsi_qla_host_t *, ms_iocb_entry_t *,
 	struct ct_sns_rsp *, const char *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d2bddca7045a..51c7cea71f90 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2625,96 +2625,6 @@ qla2x00_port_speed_capability(uint16_t speed)
 	}
 }
 
-/**
- * qla2x00_gpsc() - FCS Get Port Speed Capabilities (GPSC) query.
- * @vha: HA context
- * @list: switch info entries to populate
- *
- * Returns 0 on success.
- */
-int
-qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
-{
-	int		rval;
-	uint16_t	i;
-	struct qla_hw_data *ha = vha->hw;
-	ms_iocb_entry_t *ms_pkt;
-	struct ct_sns_req	*ct_req;
-	struct ct_sns_rsp	*ct_rsp;
-	struct ct_arg arg;
-
-	if (!IS_IIDMA_CAPABLE(ha))
-		return QLA_FUNCTION_FAILED;
-	if (!ha->flags.gpsc_supported)
-		return QLA_FUNCTION_FAILED;
-
-	rval = qla2x00_mgmt_svr_login(vha);
-	if (rval)
-		return rval;
-
-	arg.iocb = ha->ms_iocb;
-	arg.req_dma = ha->ct_sns_dma;
-	arg.rsp_dma = ha->ct_sns_dma;
-	arg.req_size = GPSC_REQ_SIZE;
-	arg.rsp_size = GPSC_RSP_SIZE;
-	arg.nport_handle = vha->mgmt_svr_loop_id;
-
-	for (i = 0; i < ha->max_fibre_devices; i++) {
-		/* Issue GFPN_ID */
-		/* Prepare common MS IOCB */
-		ms_pkt = qla24xx_prep_ms_iocb(vha, &arg);
-
-		/* Prepare CT request */
-		ct_req = qla24xx_prep_ct_fm_req(ha->ct_sns, GPSC_CMD,
-		    GPSC_RSP_SIZE);
-		ct_rsp = &ha->ct_sns->p.rsp;
-
-		/* Prepare CT arguments -- port_name */
-		memcpy(ct_req->req.gpsc.port_name, list[i].fabric_port_name,
-		    WWN_SIZE);
-
-		/* Execute MS IOCB */
-		rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
-		    sizeof(ms_iocb_entry_t));
-		if (rval != QLA_SUCCESS) {
-			/*EMPTY*/
-			ql_dbg(ql_dbg_disc, vha, 0x2059,
-			    "GPSC issue IOCB failed (%d).\n", rval);
-		} else if ((rval = qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
-		    "GPSC")) != QLA_SUCCESS) {
-			/* FM command unsupported? */
-			if (rval == QLA_INVALID_COMMAND &&
-			    (ct_rsp->header.reason_code ==
-				CT_REASON_INVALID_COMMAND_CODE ||
-			     ct_rsp->header.reason_code ==
-				CT_REASON_COMMAND_UNSUPPORTED)) {
-				ql_dbg(ql_dbg_disc, vha, 0x205a,
-				    "GPSC command unsupported, disabling "
-				    "query.\n");
-				ha->flags.gpsc_supported = 0;
-				rval = QLA_FUNCTION_FAILED;
-				break;
-			}
-			rval = QLA_FUNCTION_FAILED;
-		} else {
-			list->fp_speed = qla2x00_port_speed_capability(
-			    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
-			ql_dbg(ql_dbg_disc, vha, 0x205b,
-			    "GPSC ext entry - fpn "
-			    "%8phN speeds=%04x speed=%04x.\n",
-			    list[i].fabric_port_name,
-			    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
-			    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
-		}
-
-		/* Last device exit. */
-		if (list[i].d_id.b.rsvd_1 != 0)
-			break;
-	}
-
-	return (rval);
-}
-
 /**
  * qla2x00_gff_id() - SNS Get FC-4 Features (GFF_ID) query.
  *
-- 
2.49.0

