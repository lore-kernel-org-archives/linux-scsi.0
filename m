From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.1-rc4
Date: Sat, 13 Apr 2019 11:59:02 +0200
Message-ID: <1555149542.2995.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

One obvious fix for a ciostor data corruption on error bug.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

And the diffstat:

 drivers/scsi/csiostor/csio_scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 462560b2855e..469d0bc9f5fe 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1713,8 +1713,11 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 out:
-	if (req->nsge > 0)
+	if (req->nsge > 0) {
 		scsi_dma_unmap(cmnd);
+		if (req->dcopy && (host_status == DID_OK))
+			host_status = csio_scsi_copy_to_sgl(hw, req);
+	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
 	cmnd->scsi_done(cmnd);
