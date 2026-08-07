Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42598381EB7;
	Fri,  7 Aug 2026 09:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786095307; cv=none; b=LQQm23wDVUrz6F1V7RrOr87L+TFcVVVvv2eGThs/DOXpNywCeJPjzrLWpU0yEGcHvHLztVjap+5N3VDEx4vFPwH14H7jkEsejg1Cm6opDiUhrAimnOISx1eqw3L8T5Bn3JYCtGTYTPDytrdr70WgTXpDilsQky3eYmBUjGhFjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786095307; c=relaxed/simple;
	bh=Xwza8ovlQN/EP5UPMzcF8eourSrUyME9cv6QMtCs81I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nRpBPxan9gd1HTccMLZazm5igxKk2XIbTH/zwqoPR9NyeRtAaGwyVqRmetwx3Objnv6sPmW/rI/miZR1m/hINaJZUjv79dcnyukPic7C4Do6KhP8YvRol0mfYNGOPnQ/7K0VwemWBEGHrJuVnrszQGcm2EOD3j1Gbjw7XQHZX/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QWugRti0; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QWugRti0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=RO
	TyfXL+qLotyyjrjww4M4VQ2AoJ/fmuk7EvKDqVgFk=; b=QWugRti0AgqxGSTp4p
	bNHRGlgoiJbiDm7/lO3mGfndTncBprtuCbkjT2hjrZ1AE0f4PtyIkxeJ8PFha6Dm
	di4afbykfO56EAE2zdzpAcAge1kHpvHUbt5/LSWS09D5NTahCQyT3iLWPvXmgMgp
	nJALUntH74144v44VWFF0/1LU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDHUCCnpnVq5rxTLA--.581S2;
	Fri, 07 Aug 2026 17:34:31 +0800 (CST)
From: ghuicao@163.com
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	martin.petersen@oracle.com
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	qutran@marvell.com,
	himanshu.madhani@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] scsi: qla2xxx: Fix buffer overrun in login template
Date: Fri,  7 Aug 2026 17:34:29 +0800
Message-Id: <20260807093429.102604-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDHUCCnpnVq5rxTLA--.581S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur1rWw1rZFy5tw17tFy3CFg_yoW8AF1DpF
	W8Jr1Sk3yUWF47ArWDAay3ZF9093ZrKrW8GayUKa45uryjkF98ZFy5G3y5JasI9rnYk3WS
	vF1vvFZrGF1DJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j50edUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-AfKXWp1pqeJggAA35

From: Cao Guanghui <caoguanghui@kylinos.cn>

In qla_get_login_template(), 'q' points to plogi_els_payld.fl_csp
(offset 4), but the copy length is sizeof(struct fc_els_flogi) = 152
bytes. This makes cpu_to_be32_array() write 4 bytes past the end of
plogi_els_payld, corrupting the adjacent struct member.

Fix by pointing 'q' to the start of plogi_els_payld (offset 0), so the
152-byte copy fits exactly. The transfer length passed to firmware is
unchanged, so firmware compatibility is preserved.

The written bytes at offset 0-3 are never consumed: the only consumers
read from offsetof(fl_csp) onward (148 bytes) - qla_iocb.c copies via
offsetof(fl_csp) and qla_os.c reads fl_csp.sp_bb_cred. This contract was
clarified/normalized by commit 134f66959cd0 ("scsi: qla2xxx: Silence a
static checker warning"), which adjusted the read-side handling and
silenced static checker warnings. Moving q to the start of the struct
therefore does not affect any reader.

Fixes: 44f5a37d1e3e ("scsi: qla2xxx: Fix buffer-buffer credit extraction error")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e746c9274cde..7e50cff79b5c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5666,7 +5666,7 @@ static void qla_get_login_template(scsi_qla_host_t *vha)
 		       "PLOGI ELS param read fail.\n");
 		return;
 	}
-	q = (__be32 *)&ha->plogi_els_payld.fl_csp;
+	q = (__be32 *)&ha->plogi_els_payld;
 
 	bp = (uint32_t *)ha->init_cb;
 	cpu_to_be32_array(q, bp, sz / 4);
-- 
2.25.1

