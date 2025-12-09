Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660B028DF07;
	Tue,  9 Dec 2025 09:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765273437; cv=none; b=Ioe2fg/ctWyMjA67EVBjeJkdOPs5SSXC8gMOPlNXVmK4BTBOBK0fzFJDmsiPSH4elbIlouXS9aNMXlpu9paG9TzAYpktoznba8MEbOKVAXgIIpqdxXKlaStq/WihsqU7Dhw3SQuFkUEuh3vxgKeunRKzfTRHZtb4ydX3/ueaiMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765273437; c=relaxed/simple;
	bh=ugxhwUp3hnIN87Qp2J8QO5O2nK+dGGSbi02fplkR+Js=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Vn9jleigYVQjg1zCw9zreJa4VFNZPRAO3tUSAZwkO9lxYHJUWcdxok6QFH8rijZ+75kzXppGXixql9fKgoNsXTUKRoFPn8ljU2JsjWU5wtS+cU5oslVCGiHNMYbcezcTHzIDsttKZ5xqBMvTeZOKYlvU0IMoboY0/vmCk6HRMis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=op1EuqOy; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="op1EuqOy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=51
	9UO3NhwjvbDexoQRAcyAwdcV+OpfEZyuHx3iaqzw4=; b=op1EuqOyEsVVE7h8T8
	QwSiQVBiaiAGC3UG4rLh0ZtrtGi+Zez9WbjVsVfks8ky0VlF9Xnl/MkcK1VsFlSZ
	xmNk7BOv2iOIP62bjG54BVTQUIZXENI9dLnBuFN7cfXC7Z4CbTIe0p8ZVg59EcFj
	w2+ZMfGrmTaADhith8aHBIU6Y=
Received: from hello.company.local (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wAX7QdH7zdpihjaAg--.740S2;
	Tue, 09 Dec 2025 17:43:37 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Liang Jie <liangjie@lixiang.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: cxgbi: simplify cxgbi_sock_free_cpl_skbs()
Date: Tue,  9 Dec 2025 17:43:32 +0800
Message-Id: <20251209094333.116276-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAX7QdH7zdpihjaAg--.740S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr1UtFyfZF48JFWDWr4DJwb_yoW8JFWfpF
	1kC3yxA3W8ArW0qr48ZF40yFyfJa1Fq3W7GrW7Zw1fGanxW34jgw47J3WIqr1kXws7twnI
	qr4UGFW3JF4xC3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1dgZUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/xtbDAAk2Vmk370k6yQAA3i

From: Liang Jie <liangjie@lixiang.com>

kfree_skb(NULL) is a no-op, so the explicit NULL checks before
kfree_skb() are redundant. Drop the checks and keep the NULL
assignments to simplify the code.

No functional change intended.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bf75940f2be1..ce4351232a5d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -539,18 +539,14 @@ static void sock_put_port(struct cxgbi_sock *csk)
  */
 void cxgbi_sock_free_cpl_skbs(struct cxgbi_sock *csk)
 {
-	if (csk->cpl_close) {
-		kfree_skb(csk->cpl_close);
-		csk->cpl_close = NULL;
-	}
-	if (csk->cpl_abort_req) {
-		kfree_skb(csk->cpl_abort_req);
-		csk->cpl_abort_req = NULL;
-	}
-	if (csk->cpl_abort_rpl) {
-		kfree_skb(csk->cpl_abort_rpl);
-		csk->cpl_abort_rpl = NULL;
-	}
+	kfree_skb(csk->cpl_close);
+	csk->cpl_close = NULL;
+
+	kfree_skb(csk->cpl_abort_req);
+	csk->cpl_abort_req = NULL;
+
+	kfree_skb(csk->cpl_abort_rpl);
+	csk->cpl_abort_rpl = NULL;
 }
 EXPORT_SYMBOL_GPL(cxgbi_sock_free_cpl_skbs);
 
-- 
2.25.1

