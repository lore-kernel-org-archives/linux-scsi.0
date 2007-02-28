From: Tobias Klauser <tklauser@distanz.ch>
Subject: [KJ] [PATCH] aacraid: Use DMA_31BIT_MASK
Date: Wed, 28 Feb 2007 10:31:45 +0100
Message-ID: <20070228093145.GA15159@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-bounces@lists.osdl.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use constants from linux/dma-mapping.h for pci_set_dma_mask() and
pci_set_consistent_dma_mask()

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

---
 drivers/scsi/aacraid/commsup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 1b97f60..bb4fe48 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -34,6 +34,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/pci.h>
+#include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
@@ -1113,8 +1114,8 @@ static int _aac_reset_adapter(struct aac_dev *aac)
 		  ((retval =3D pci_set_consistent_dma_mask(aac->pdev, DMA_32BIT_MASK))))
 			goto out;
 	} else {
-		if (((retval =3D pci_set_dma_mask(aac->pdev, 0x7FFFFFFFULL))) ||
-		  ((retval =3D pci_set_consistent_dma_mask(aac->pdev, 0x7FFFFFFFULL))))
+		if (((retval =3D pci_set_dma_mask(aac->pdev, DMA_31BIT_MASK))) ||
+		  ((retval =3D pci_set_consistent_dma_mask(aac->pdev, DMA_31BIT_MASK))))
 			goto out;
 	}
 	if ((retval =3D (*(aac_get_driver_ident(index)->init))(aac)))
-- =

1.5.0.2
