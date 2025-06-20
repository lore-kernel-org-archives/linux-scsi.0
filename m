Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B575728A1F6;
	Fri, 20 Jun 2025 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750419563; cv=none; b=ZL+iijTf3jOgNKvEJCxdmXrfvF4CUSGGlp3NWb2gPd0ceE58f09+cWLawCsEL/HrQeSh7ZTn+TSbXIJloFan/KxIthPzoH12rn8srfgERFM9borR5PNtVMjE/8TIDAHGbQ0LhyOJQGIeCio6IPFczF6UQ+x9+lvzgpUWaP9GRFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750419563; c=relaxed/simple;
	bh=o0Q+jJlE+4KCD6McJOZBcBxadKWIt+MWEaZEfa3c2ao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=edKbv72K2U0NpQ57+v/NsfarsnjwP8hvY1sksmzZoN6qnDygomqbZMcGTIFk5r8vCgUHuHOQTXaB65NUKhE6fZcTDPgWd/Np8NZnh94erOcE/mWaO/5ZLjS9QDyZHfMcl6CWe5yCJ7v70vjxnjUXL02R1QrC9FHB9eB4aw75XKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwUKN0kI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwUKN0kI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5105FC4CEEE;
	Fri, 20 Jun 2025 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750419563;
	bh=o0Q+jJlE+4KCD6McJOZBcBxadKWIt+MWEaZEfa3c2ao=;
	h=From:To:Cc:Subject:Date:From;
	b=GwUKN0kIheVSXlhTIoNOAhfnK5snShTKokOhfRJK4Z/Wp6aHhtmwc/VILq+poE5J4
	 sesBzPtFZ+EnQc1Tr2YPzPt8HYEPERU8x35s0J9dA93RL7qVdHY9VPb400f52baBrL
	 Kzny6Hk8YOfbaPWHgXFHhHNeIhbxskrHz/xUaMS7qoHXNLmxH7DPQGNhuFVhfJzJ/7
	 GX7DJMK79/zjmu2GuP+I462YBIHF/peuzaM4YqGuAKUfqA38H8BzpTfx8xLYqqRfeC
	 IGkfDGJMwjgW+r//6sG6J1ToB7rKgwSgcny8xTL12Sq/gGyDzInoMjsLJmFcPuwoDS
	 /IS+6KXzKODdQ==
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
Subject: [PATCH] scsi: qla2xxx: avoid stack frame size warning in qla_dfs
Date: Fri, 20 Jun 2025 13:39:11 +0200
Message-Id: <20250620113919.3974443-1-arnd@kernel.org>
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
I don't have this hardware and tried restructing the code in
a way that makes sense to me. This should be tested on an actual
device before it gets applied.
---
 drivers/scsi/qla2xxx/qla_dfs.c | 20 +++++---------
 drivers/scsi/qla2xxx/qla_gbl.h |  1 +
 drivers/scsi/qla2xxx/qla_mbx.c | 49 ++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 14 deletions(-)

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
index 0cd6f3e14882..a51b9704cf4b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6597,6 +6597,55 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
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
+	if (pd  == NULL) {
+		ql_log(ql_log_warn, vha, 0xd047,
+		    "Failed to allocate port database structure.\n");
+		goto done_free_sp;
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
+	mc.mb[10] = 0;
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

