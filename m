From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/17] hpsa: enable bus master bit after pci_enable_device
Date: Tue, 01 May 2012 11:42:20 -0500
Message-ID: <20120501164220.11705.95002.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

pci_disable_device() disables the bus master bit and pci_enable_device does
not re-enable it.  It needs to be enabled.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5119ce6..de9c8f3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3933,6 +3933,9 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 
+	/* Enable bus mastering (pci_disable_device may disable this) */
+	pci_set_master(h->pdev);
+
 	err = pci_request_regions(h->pdev, HPSA);
 	if (err) {
 		dev_err(&h->pdev->dev,
