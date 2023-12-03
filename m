Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="TXgQzPbf"
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A367AFC;
	Sun,  3 Dec 2023 07:51:21 -0800 (PST)
Received: from localhost.localdomain (unknown [46.242.8.170])
	by mail.ispras.ru (Postfix) with ESMTPSA id 3E8F140F1DE6;
	Sun,  3 Dec 2023 15:51:17 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 3E8F140F1DE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1701618677;
	bh=OzqlpYzBI15i6FXYFGVQXHLoruvKle2z9Cu7A+AYusY=;
	h=From:To:Cc:Subject:Date:From;
	b=TXgQzPbfxSrdpYYw84oDK20OZfkSeQdWdzqyfZOwnJMGcYsbwkX1D27IEo/QQ2F8F
	 nn6+wULBdJn0Hz87drvzHz3Rj+/WG0VhY5x8uqGqgBG7YV2bYKjbd8LGroyWhns4gz
	 q7IDTPju6sD5xZhcREAO5OXY+BKTeKm1dmwVZJfg=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: [PATCH] scsi: megaraid_mm: do not access uninit kioc_list members
Date: Sun,  3 Dec 2023 18:50:57 +0300
Message-ID: <20231203155058.24293-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

adapter->kioc_list is allocated using kmalloc_array() so its values are
left uninitialized. In a rare OOM case when dma_pool_alloc() fails in
mraid_mm_register_adp(), we should free the already allocated DMA pools
but comparing kioc->pthru32 with NULL doesn't guard from accessing uninit
memory.

Properly roll back in error case: free array members with lower indices.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/scsi/megaraid/megaraid_mm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index c509440bd161..701eb5ee2a69 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -1001,12 +1001,10 @@ mraid_mm_register_adp(mraid_mmadp_t *lld_adp)
 
 pthru_dma_pool_error:
 
-	for (i = 0; i < lld_adp->max_kioc; i++) {
+	while (--i >= 0) {
 		kioc = adapter->kioc_list + i;
-		if (kioc->pthru32) {
-			dma_pool_free(adapter->pthru_dma_pool, kioc->pthru32,
-				kioc->pthru32_h);
-		}
+		dma_pool_free(adapter->pthru_dma_pool, kioc->pthru32,
+			kioc->pthru32_h);
 	}
 
 memalloc_error:
-- 
2.43.0

