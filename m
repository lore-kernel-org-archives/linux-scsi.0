From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] scsi: ibmvscsi: Don't use rc uninitialized in ibmvscsi_do_work
Date: Mon,  3 Jun 2019 15:19:42 -0700
Message-ID: <20190603221941.65432-1-natechancellor@gmail.com>
References: <20190531185306.41290-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531185306.41290-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nathan Chancellor <natechancellor@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

clang warns:

drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
        case IBMVSCSI_HOST_ACTION_NONE:
             ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/ibmvscsi/ibmvscsi.c:2151:6: note: uninitialized use occurs
here
        if (rc) {
            ^~

Initialize rc to zero in the case statements that clang mentions so that
the atomic_set and dev_err statement don't trigger for them.

Fixes: 035a3c4046b5 ("scsi: ibmvscsi: redo driver work thread to use enum action states")
Link: https://github.com/ClangBuiltLinux/linux/issues/502
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Initialize rc in the case statements, rather than at the top of the
  function, as suggested by Michael.

 drivers/scsi/ibmvscsi/ibmvscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 65053daef5f7..3b5647d622d9 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2109,9 +2109,6 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	switch (hostdata->action) {
-	case IBMVSCSI_HOST_ACTION_NONE:
-	case IBMVSCSI_HOST_ACTION_UNBLOCK:
-		break;
 	case IBMVSCSI_HOST_ACTION_RESET:
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
@@ -2128,7 +2125,10 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 		if (!rc)
 			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
 		break;
+	case IBMVSCSI_HOST_ACTION_NONE:
+	case IBMVSCSI_HOST_ACTION_UNBLOCK:
 	default:
+		rc = 0;
 		break;
 	}
 
-- 
2.22.0.rc3
