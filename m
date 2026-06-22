Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3537B361675;
	Mon, 22 Jun 2026 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782115196; cv=none; b=CrQzYctDzrVNcOkWXjFrmgydp7+Yo4Id4eqDtQefs4D5vXDf0x7GVUILGwvWlUkEx94njY9Q+7PEb7Du61AN5rjw2mAAGpkRcI46Hr+h71EkF+sqvDeU82LT0NevtCsvh2d2quabQfU2oe/P6CbWlAPdvD6HYoaoas3Zy8pa0TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782115196; c=relaxed/simple;
	bh=qyBaaWnYRbK7XCAbAJbWuep5cFL9E/JUZL/x+Cq/CYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g8J1oS0Lt7aJz/4Dirv89V0Dlu5GRzMGmOUAZG4WFCqKsjQbxD33IwskofsNqpsT6dxDkK+N3E7pHtFzkbPZTkC7POGgmL900stt4PEqpuFWHCvU3ksrkjPzdmUaws2b/dzh7xn1haQJTIu3eJ7KxgaVc2MYegQK0a77eFlurBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=eMhbPW4A; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="eMhbPW4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ws
	C9plxLC49dLoH7qzqis/G3QGv01+Xrfj7bJMYdBtE=; b=eMhbPW4A+xpCxezzUb
	p6ljtzbsufNBos05mhI+GMooS5VAAhvcSSUFadlUkiBynfiv0VnjrpK7Tn6kTPLv
	qx0P0ckt66X/RXdHE0KCxW2oVGZf6ELA9RcA39pefdqSvQsVuieig0BgCD/HvbQR
	19BfYNXvrMbSdPiCnBucelB5E=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDnNwU16zhqBIo_FA--.7653S2;
	Mon, 22 Jun 2026 15:58:47 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: ram.vegesna@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dwagner@suse.de,
	jsmart2021@gmail.com,
	hare@suse.de
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: Fix IO leak on unsupported additional CDB
Date: Mon, 22 Jun 2026 15:58:44 +0800
Message-Id: <20260622075844.832871-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnNwU16zhqBIo_FA--.7653S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF17ZF4fur4rtr18tr4xJFb_yoWDCrg_ur
	4rXryfZrnYkF1kGF4rtF4fZayaka1Duwn7ZF1Fg34Fgr47ZrWUCw1DArZag3yUJrZ2yFZ5
	Ww17ZFWUCr17ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRPfHUUUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7hewH2o46zdBawAA3y

efct_dispatch_fcp_cmd() allocates an efct_io before dispatching an
unsolicited FCP command. If the command has an unsupported additional
CDB, the function returns -EIO before handing the IO to the SCSI layer.

Free the allocated IO before returning from this error path.

Fixes: f45ae6aac0a0 ("scsi: elx: efct: Unsolicited FC frame processing routines")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/elx/efct/efct_unsol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_unsol.c b/drivers/scsi/elx/efct/efct_unsol.c
index e6addab66a60..6a871a59c909 100644
--- a/drivers/scsi/elx/efct/efct_unsol.c
+++ b/drivers/scsi/elx/efct/efct_unsol.c
@@ -385,6 +385,7 @@ efct_dispatch_fcp_cmd(struct efct_node *node, struct efc_hw_sequence *seq)
 
 		if (cmnd->fc_flags & FCP_CFL_LEN_MASK) {
 			efc_log_err(efct, "Additional CDB not supported\n");
+			efct_scsi_io_free(io);
 			return -EIO;
 		}
 		/*
-- 
2.25.1

