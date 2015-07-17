From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] wd719x: Remove use of macro DEFINE_PCI_DEVICE_TABLE
Date: Fri, 17 Jul 2015 11:16:43 +0530
Message-ID: <20150717054643.GA7209@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Macro DEFINE_PCI_DEVICE_TABLE is deprecated. So, here use
struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE with
the goal of getting rid of this macro completely.

The Coccinelle semantic patch that performs this transformation
is as follows:

@@
identifier a;
declarer name DEFINE_PCI_DEVICE_TABLE;
initializer i;
@@
- DEFINE_PCI_DEVICE_TABLE(a)
+ const struct pci_device_id a[]
= i;

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
This patch is against linux-next branch
---
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 61346aa..4655d16 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -962,7 +962,7 @@ static void wd719x_pci_remove(struct pci_dev *pdev)
 	scsi_host_put(sh);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) = {
+static const struct pci_device_id wd719x_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
 	{}
 };
-- 
1.9.1
