Received: from msa.smtpout.orange.fr (smtp-77.smtpout.orange.fr [80.12.242.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69291E517;
	Sun,  1 Sep 2024 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725223546; cv=none; b=JwIja2z/JEULinWjIeGafgu0zy4Xmf3Qap3bnmyuXuWq+9exEuRVHtYOf79DFFXQ/xt/uRPT3HLjeJ1iDtfFyOBO+9zx/gSI2us299zr2JLLfX2iXG/zXYuIkH2xQr7HPy3fdod4Z/Sxwknsi+MZ+Rz4dRtdG/b9aVYF7s0re/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725223546; c=relaxed/simple;
	bh=IpzzL+qffAylT1Kp4b+8Sun0IWPin7IZV0K9T+zFQd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EtpZXa94DQZ255VTDGsMlhMCH+OQciJpOU7+5iqd8R6UjY4cJTJWdwwN4B4icZM5biJ2oymducmktNZ6T+ww8qqrCkDCyNgzNOU/T1XRJctT41z1QsgctsYVqgle5G0BgX2MR5Bn9MhVGjwSPIc0inNaNv/mp/AfDTvU0bgGKII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=O7vUT6oD; arc=none smtp.client-ip=80.12.242.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="O7vUT6oD"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id krRzstoQfjDE7krRzsjq0N; Sun, 01 Sep 2024 22:45:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1725223534;
	bh=OaYwBpcpMqzp3pLDAjlo6pUpuKE0rzYUGot8WgUmNng=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=O7vUT6oD4tCaFxdpGALRGzKNoacDx8+CfVJ4hEoSmoR75kFAoveYEZ+cSTdFe1xvI
	 cmT2gkMputZBR2hFgYFzAGq+nwV8OwPM4+/S7wCVmPt0p1nt5qxbH9mrrhoTg8WWxe
	 WtPb5ODITjxYbjjvKb3y5QJ/irjeMzOKH/zLA78/fSNDhGoTMIx6juFyodwAM7UL1d
	 GKSUUmcDsZemGo/p70fFUEVpSbHGas52ah6zc8ljyXHuSIMLMA0tJPFbdQ+3qcTSuT
	 khc0fBCY22DxxXvCGcU0zLnROpvySn7RgLGzT5vITABYvmarp5baXI/e4AOYSZKF10
	 NbYbPGJSb3iJw==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 01 Sep 2024 22:45:34 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: libcxgbi: Remove an unused field in struct cxgbi_device
Date: Sun,  1 Sep 2024 22:45:27 +0200
Message-ID: <58f77f690d85e2c653447e3e3fc4f8d3c3ce8563.1725223504.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Usage of .dev_ddp_cleanup() in libcxgbi was removed by commit 5999299f1ce9
("cxgb3i,cxgb4i,libcxgbi: remove iSCSI DDP support") on 2016-07.

.csk_rx_pdu_ready() and debugfs_root have apparently never been used since
introduction by commit 9ba682f01e2f ("[SCSI] libcxgbi: common library for
cxgb3i and cxgb4i")

Remove the now unused function pointer from struct cxgbi_device.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 drivers/scsi/cxgbi/libcxgbi.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index d92cf1dccc2f..0909b03e2497 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -485,7 +485,6 @@ struct cxgbi_device {
 	unsigned char nmtus;
 	unsigned char nports;
 	struct pci_dev *pdev;
-	struct dentry *debugfs_root;
 	struct iscsi_transport *itp;
 	struct module *owner;
 
@@ -499,7 +498,6 @@ struct cxgbi_device {
 	unsigned int rxq_idx_cntr;
 	struct cxgbi_ports_map pmap;
 
-	void (*dev_ddp_cleanup)(struct cxgbi_device *);
 	struct cxgbi_ppm* (*cdev2ppm)(struct cxgbi_device *);
 	int (*csk_ddp_set_map)(struct cxgbi_ppm *, struct cxgbi_sock *,
 			       struct cxgbi_task_tag_info *);
@@ -512,7 +510,6 @@ struct cxgbi_device {
 				   unsigned int, int);
 
 	void (*csk_release_offload_resources)(struct cxgbi_sock *);
-	int (*csk_rx_pdu_ready)(struct cxgbi_sock *, struct sk_buff *);
 	u32 (*csk_send_rx_credits)(struct cxgbi_sock *, u32);
 	int (*csk_push_tx_frames)(struct cxgbi_sock *, int);
 	void (*csk_send_abort_req)(struct cxgbi_sock *);
-- 
2.46.0

