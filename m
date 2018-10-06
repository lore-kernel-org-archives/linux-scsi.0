From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.19-rc5
Date: Sat, 06 Oct 2018 10:20:12 -0700
Message-ID: <1538846412.4088.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Small fix for an unititialized mutex in the qedi driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Nilesh Javali (1):
      scsi: qedi: Initialize the stats mutex lock

and the diffstat:

 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

With full diff below.

James

---

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cc8e64dc65ad..e5bd035ebad0 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2472,6 +2472,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		/* start qedi context */
 		spin_lock_init(&qedi->hba_lock);
 		spin_lock_init(&qedi->task_idx_lock);
+		mutex_init(&qedi->stats_lock);
 	}
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
