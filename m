From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v3] scsi: ibmvscsi: Don't use rc uninitialized in ibmvscsi_do_work
Date: Mon,  3 Jun 2019 16:44:06 -0700
Message-ID: <20190603234405.29600-1-natechancellor@gmail.com>
References: <20190603221941.65432-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190603221941.65432-1-natechancellor@gmail.com>
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

Initialize rc in the IBMVSCSI_HOST_ACTION_UNBLOCK case statement then
shuffle IBMVSCSI_HOST_ACTION_NONE down to the default case statement and
make it return early so that rc is never used uninitialized in this
function.

Fixes: 035a3c4046b5 ("scsi: ibmvscsi: redo driver work thread to use enum action states")
Link: https://github.com/ClangBuiltLinux/linux/issues/502
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Suggested-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Initialize rc in the case statements, rather than at the top of the
  function, as suggested by Michael.
  
v2 -> v3:

* default and IBMVSCSI_HOST_ACTION_NONE now return early from the
  function, as requested by Tyrel.

 drivers/scsi/ibmvscsi/ibmvscsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 65053daef5f7..7f66a7783209 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2109,8 +2109,8 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	switch (hostdata->action) {
-	case IBMVSCSI_HOST_ACTION_NONE:
 	case IBMVSCSI_HOST_ACTION_UNBLOCK:
+		rc = 0;
 		break;
 	case IBMVSCSI_HOST_ACTION_RESET:
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
@@ -2128,8 +2128,10 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 		if (!rc)
 			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
 		break;
+	case IBMVSCSI_HOST_ACTION_NONE:
 	default:
-		break;
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		return;
 	}
 
 	hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
-- 
2.22.0.rc3
