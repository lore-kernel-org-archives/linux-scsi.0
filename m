From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.14-rc7
Date: Fri, 03 Nov 2017 09:42:30 -0700
Message-ID: <1509727350.3148.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

One minor fix in the error leg of the qla2xxx driver (it oopses the
system if we get an error trying to start the internal kernel thread).
 The fix is minor because the problem isn't often encountered in the
field (although it can be induced by inserting the module in a low
memory environment).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Douglas Miller (1):
      scsi: qla2xxx: Fix oops in qla2x00_probe_one error path

And the diffstat:

 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3bd956d3bc5d..dce42a416876 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3212,6 +3212,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ql_log(ql_log_fatal, base_vha, 0x00ed,
 		    "Failed to start DPC thread.\n");
 		ret = PTR_ERR(ha->dpc_thread);
+		ha->dpc_thread = NULL;
 		goto probe_failed;
 	}
 	ql_dbg(ql_dbg_init, base_vha, 0x00ee,
