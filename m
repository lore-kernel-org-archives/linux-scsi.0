From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 14/19] scsi: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:46 +0200
Message-ID: <1379802471-30252-14-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: intel-linux-scu@intel.com
Cc: lukasz.dorau@intel.com, maciej.patelczyk@intel.com, dave.jiang@intel.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The variable success is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/scsi/isci/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 13098b0..26f8e5c 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -174,7 +174,7 @@ static void isci_port_link_up(struct isci_host *isci_host,
 {
 	unsigned long flags;
 	struct sci_port_properties properties;
-	unsigned long success = true;
+	bool success = true;
 
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_port = %p\n",
-- 
1.8.3.1
