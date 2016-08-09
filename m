From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] aic94xx: Add missing error code assignment before test
Date: Tue,  9 Aug 2016 13:30:02 +0200
Message-ID: <1470742202-11100-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

It is likely that checking the result of 'pci_write_config_dword' is
expected here.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 0fdc98b..7c713f7 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -632,7 +632,7 @@ int asd_init_hw(struct asd_ha_struct *asd_ha)
 			   pci_name(asd_ha->pcidev));
 		return err;
 	}
-	pci_write_config_dword(asd_ha->pcidev, PCIC_HSTPCIX_CNTRL,
+	err = pci_write_config_dword(asd_ha->pcidev, PCIC_HSTPCIX_CNTRL,
 					v | SC_TMR_DIS);
 	if (err) {
 		asd_printk("couldn't disable split completion timer of %s\n",
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
