From: Daniel Wagner <wagi@monom.org>
Subject: [PATCH 2/3] sym53c8xx_2: use complete() instead complete_all()
Date: Tue, 13 Sep 2016 10:58:49 +0200
Message-ID: <1473757130-14751-3-git-send-email-wagi@monom.org>
References: <1473757130-14751-1-git-send-email-wagi@monom.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473757130-14751-1-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
List-Id: linux-scsi@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

There is only one waiter for the completion, therefore there is no need
to use complete_all(). Let's make that clear by using complete() instead
of complete_all().

The usage pattern of the completion is:

waiter context                          waker context

sym_eh_handler()
  struct completion eh_done
  init_completion(eh_done)
  pci_channel_offline()
  wait_for_completion_timeout(eh_done)

                                        sym2_io_resume()
                                          complete(eh_done)

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 5d00e51..d32e3ba 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1874,7 +1874,7 @@ static void sym2_io_resume(struct pci_dev *pdev)
 
 	spin_lock_irq(shost->host_lock);
 	if (sym_data->io_reset)
-		complete_all(sym_data->io_reset);
+		complete(sym_data->io_reset);
 	spin_unlock_irq(shost->host_lock);
 }
 
-- 
2.7.4
