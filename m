Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3C813774D;
	Fri, 20 Jun 2025 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750440758; cv=none; b=LbMOwydS+HkWabOqWwj2KbKYAwRLMhp5ljI6dx1k67X1IkU0ZiGhRHeQNH40/hunPp+1EHqrlbtvmtUt0IzF1FIHJfhu9M70fe9qjjNMEsr1HYHjUcVgT2BvAiWV5kdqcCYQRD/l2FNq9q7rYsXFwCtwuy6tICDzg61d2f1lQcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750440758; c=relaxed/simple;
	bh=hUmxKxYrfLSvEtssqPOOtV8zd1BBWLh011LOtkMog40=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kaTuDSrdCVp6ejfNj+HI0TCZENKtmJzNjqTXkKoI/YXs2pmPFVdQWKEkZOYt+URuYfTakM3lN4wvLXRodIv6kHpGQVVHwWMaPwQQ3dl6x67GxXULhbPWFjm8tZLEqhKVP7I5K96AGvyefCB1QzBNcOqRAADdaevULmIqUAhb3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afZMCWUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afZMCWUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEEDC4CEE3;
	Fri, 20 Jun 2025 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750440756;
	bh=hUmxKxYrfLSvEtssqPOOtV8zd1BBWLh011LOtkMog40=;
	h=From:To:Cc:Subject:Date:From;
	b=afZMCWUMNiFexScGZnhQw4culXKOSZynp/wiuc2FpPbaZzjjG1GeNhO7FuGRmHzx7
	 f4YsWE+k8TPzg3jb8z8g+T4GOFft/RgnkFO0tUERTvkEgS4NIzof15li+RdIbhzy8f
	 UAvh+IdbbVf1d6L+l4xueOeF9ptnw3B6WZ/2vPnCfAH/44Z+JY1amVHjIrxV+YPedd
	 +sv/fl94OxIW27eT3wzaJjl0IdDfKe4i50Y02DroP6EDL8yMLNkFIWK7CsTdw7waMN
	 7KFm+KgJudHaMHMrbLMhkl+oFlihRYKp6lXz1v3H26dydis0Xf8jy/ySDLV4+NnBR6
	 0UoUXJUPcaXCA==
From: Arnd Bergmann <arnd@kernel.org>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Quinn Tran <qutran@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] scsi: qla2xxx: avoid stack frame size warning in qla_dfs
Date: Fri, 20 Jun 2025 19:32:22 +0200
Message-Id: <20250620173232.864179-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The qla2x00_dfs_tgt_port_database_show() function constructs a fake
fc_port_t object on the stack, which depending on the configuration
is large enough to exceed the stack size warning limit:

drivers/scsi/qla2xxx/qla_dfs.c:176:1: error: stack frame size (1392) exceeds limit (1280) in 'qla2x00_dfs_tgt_port_database_show' [-Werror,-Wframe-larger-than]

Rework this function to no longer need the structure but instead
call a custom helper function that just prints the data directly
from the port_database_24xx structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: address review comments from ALOK TIWARI
---
 drivers/scsi/qla2xxx/qla_dfs.c | 20 +++++---------
 drivers/scsi/qla2xxx/qla_gbl.h |  1 +
 drivers/scsi/qla2xxx/qla_mbx.c | 48 ++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 08273520c777..43970caca7b3 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -179,10 +179,9 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 	struct qla_hw_data *ha = vha->hw;
 	struct gid_list_info *gid_list;
 	dma_addr_t gid_list_dma;
-	fc_port_t fc_port;
 	char *id_iter;
 	int rc, i;
-	uint16_t entries, loop_id;
+	uint16_t entries;
 
 	seq_printf(s, "%s\n", vha->host_str);
 	gid_list = dma_alloc_coherent(&ha->pdev->dev,
@@ -205,18 +204,11 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 	seq_puts(s, "Port Name	Port ID		Loop ID\n");
 
 	for (i = 0; i < entries; i++) {
-		struct gid_list_info *gid =
-			(struct gid_list_info *)id_iter;
-		loop_id = le16_to_cpu(gid->loop_id);
-		memset(&fc_port, 0, sizeof(fc_port_t));
-
-		fc_port.loop_id = loop_id;
-
-		rc = qla24xx_gpdb_wait(vha, &fc_port, 0);
-		seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
-			   fc_port.port_name, fc_port.d_id.b.domain,
-			   fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
-			   fc_port.loop_id);
+		struct gid_list_info *gid = (struct gid_list_info *)id_iter;
+
+		rc = qla24xx_print_fc_port_id(vha, s, le16_to_cpu(gid->loop_id));
+		if (rc != QLA_SUCCESS)
+			break;
 		id_iter += ha->gid_list_info_size;
 	}
 out_free_id_list:
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 03e50e8fc08d..145defc420f2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -557,6 +557,7 @@ qla26xx_dport_diagnostics_v2(scsi_qla_host_t *,
 
 int qla24xx_send_mb_cmd(struct scsi_qla_host *, mbx_cmd_t *);
 int qla24xx_gpdb_wait(struct scsi_qla_host *, fc_port_t *, u8);
+int qla24xx_print_fc_port_id(struct scsi_qla_host *, struct seq_file *, u16);
 int qla24xx_gidlist_wait(struct scsi_qla_host *, void *, dma_addr_t,
     uint16_t *);
 int __qla24xx_parse_gpdb(struct scsi_qla_host *, fc_port_t *,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0cd6f3e14882..ae90c0973ca7 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6597,6 +6597,54 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	return rval;
 }
 
+int qla24xx_print_fc_port_id(struct scsi_qla_host *vha, struct seq_file *s, u16 loop_id)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	dma_addr_t pd_dma;
+	struct port_database_24xx *pd;
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	pd = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
+	if (pd == NULL) {
+		ql_log(ql_log_warn, vha, 0xd047,
+		    "Failed to allocate port database structure.\n");
+		goto done;
+	}
+
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_PORT_DATABASE;
+	mc.mb[1] = loop_id;
+	mc.mb[2] = MSW(pd_dma);
+	mc.mb[3] = LSW(pd_dma);
+	mc.mb[6] = MSW(MSD(pd_dma));
+	mc.mb[7] = LSW(MSD(pd_dma));
+	mc.mb[9] = vha->vp_idx;
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1193, "%s: fail\n", __func__);
+		goto done_free_sp;
+	}
+
+	ql_dbg(ql_dbg_mbx, vha, 0x1197, "%s: %8phC done\n",
+	    __func__, pd->port_name);
+
+	seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
+		   pd->port_name, pd->port_id[0],
+		   pd->port_id[1], pd->port_id[2],
+		   loop_id);
+
+done_free_sp:
+	if (pd)
+		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
+done:
+	return rval;
+}
+
 /*
  * qla24xx_gpdb_wait
  * NOTE: Do not call this routine from DPC thread
-- 
2.39.5

