Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 10D881720;
	Thu, 30 Nov 2023 19:00:21 -0800 (PST)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 222D560105E64;
	Fri,  1 Dec 2023 11:00:20 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: dan.carpenter@linaro.org,
	hare@suse.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: Su Hui <suhui@nfschina.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: aic7xxx: return ahc_linux_register_host()'s value rather than zero
Date: Fri,  1 Dec 2023 10:59:55 +0800
Message-Id: <20231201025955.1584260-3-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231201025955.1584260-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ahc_linux_register_host() can return error code if failed.
So ahc_linux_pci_dev_probe() should return the value of
ahc_linux_register_host() rather than zero.

And the last patch made ahc_linux_register_host() return negative error
codes, which makes sure ahc_linux_pci_dev_probe() returns negative error
codes.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index a07e94fac673..198440dc0918 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -241,8 +241,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ahc_linux_pci_inherit_flags(ahc);
 
 	pci_set_drvdata(pdev, ahc);
-	ahc_linux_register_host(ahc, &aic7xxx_driver_template);
-	return (0);
+	return ahc_linux_register_host(ahc, &aic7xxx_driver_template);
 }
 
 /******************************* PCI Routines *********************************/
-- 
2.30.2

