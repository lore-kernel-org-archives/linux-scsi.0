Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="I+zLitdM"
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B92910D8;
	Sat,  9 Dec 2023 03:19:23 -0800 (PST)
Received: from localhost.localdomain (unknown [46.242.8.170])
	by mail.ispras.ru (Postfix) with ESMTPSA id 61BDE400CBDC;
	Sat,  9 Dec 2023 11:19:19 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 61BDE400CBDC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1702120760;
	bh=odq4MrakWESK/R0F/Uy9J0JMTX/2+rbQ0CI8lN5aBHQ=;
	h=From:To:Cc:Subject:Date:From;
	b=I+zLitdMGwY0lck2CkXo2mrldGQO4nakM7w/WDRRft6Py2+4wvuucp5bPls9vgdDf
	 2Oha2DFT77/GNJoLVxFC7w1uTEPKoE1sk3AiPcJx0+ckXqcOudEwAznuz1/rmNcnbz
	 SeQ4W7SfQ1C7n41e/c1slG0BMdLTI+snqwGXSAgk=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Don Brace <don.brace@microchip.com>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alex Chiang <achiang@hp.com>,
	Mike Miller <mikem@beardog.cce.hp.com>,
	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: [PATCH] scsi: hpsa: prevent memory leak in hpsa_big_passthru_ioctl
Date: Sat,  9 Dec 2023 14:18:56 +0300
Message-ID: <20231209111857.19393-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case copy_from_user() fails during the buffers allocating loop inside
hpsa_big_passthru_ioctl(), the last allocated buffer (accessed by sg_used
index) is not freed on cleanup1 error path as sg_used index has not been
incremented yet.

Free the last allocated buffer directly if copy_from_user() fails.

Found by Linux Verification Center (linuxtesting.org).

Fixes: edd163687ea5 ("[SCSI] hpsa: add driver for HP Smart Array controllers.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/scsi/hpsa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af18d20f3079..897f9ee3c004 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6536,6 +6536,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h,
 		if (ioc->Request.Type.Direction & XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
 				status = -EFAULT;
+				kfree(buff[sg_used]);
 				goto cleanup1;
 			}
 		} else
-- 
2.43.0

