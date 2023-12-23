Received: from smtp.smtpout.orange.fr (smtp-30.smtpout.orange.fr [80.12.242.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168D76AA0
	for <linux-scsi@vger.kernel.org>; Sat, 23 Dec 2023 07:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="DvdU5XM+"
Received: from pop-os.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id GwGurd3vWIwxKGwGurw9QD; Sat, 23 Dec 2023 08:18:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1703315890;
	bh=/VcQ3ywtBHiz2ekkrkufS8HtOtQjntld/yz+tR1IO94=;
	h=From:To:Cc:Subject:Date;
	b=DvdU5XM+20cp+xGQjO8cNsK9VuhzCs8sNKlHZZ76nuqBSMy+ntaDUv7D0eWBP/S30
	 JdmIMYwx73qLglLB8bdBs0E0FEpbj9ObtQj8k58ejYgigqUELSQldCDmREV5FPyZ02
	 6T1/lgJiLSn2N/XxkNeoqKV6ezyID+R+xk1oCisX4swdPf+BlEPSdNTl1EyzngOFP2
	 q3ElUPNNOAONSvna0VcTF/4taApsZ7kS3YV/9xuRtYWcQYXSA5rPLDn4vVjmF+b0Y9
	 439LUsBCnmLbTLkSrsvKJG5Mi76LowKWje8jcUASwnYM3YqwGcOcfrxgGs86CVH8l8
	 /tef6wuzOAAdw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 23 Dec 2023 08:18:10 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: bnx2fc: Use netif_carrier_ok()
Date: Sat, 23 Dec 2023 08:18:04 +0100
Message-Id: <888a8efb514cb9ed984253de147b2b212c649dce.1703315854.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use netif_carrier_ok() instead of hand-writing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 1078c20c5ef6..cf5b58798975 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -784,7 +784,7 @@ static int bnx2fc_link_ok(struct fc_lport *lport)
  */
 void bnx2fc_get_link_state(struct bnx2fc_hba *hba)
 {
-	if (test_bit(__LINK_STATE_NOCARRIER, &hba->phys_dev->state))
+	if (!netif_carrier_ok(hba->phys_dev))
 		set_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
 	else
 		clear_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
-- 
2.34.1

