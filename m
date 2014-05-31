From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/11] isci: Remove useless return variables
Date: Sat, 31 May 2014 10:14:03 -0300
Message-ID: <1401542051-3174-3-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: kernel-janitors@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/isci/request.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 56e3809..ecf7924 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1480,8 +1480,6 @@ static enum sci_status
 stp_request_pio_await_h2d_completion_tc_event(struct isci_request *ireq,
 					      u32 completion_code)
 {
-	enum sci_status status = SCI_SUCCESS;
-
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
 		ireq->scu_status = SCU_TASK_DONE_GOOD;
@@ -1500,7 +1498,7 @@ stp_request_pio_await_h2d_completion_tc_event(struct isci_request *ireq,
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status
@@ -2103,8 +2101,6 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 static enum sci_status stp_request_udma_await_tc_event(struct isci_request *ireq,
 						       u32 completion_code)
 {
-	enum sci_status status = SCI_SUCCESS;
-
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
 		ireq->scu_status = SCU_TASK_DONE_GOOD;
@@ -2148,14 +2144,12 @@ static enum sci_status stp_request_udma_await_tc_event(struct isci_request *ireq
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status atapi_raw_completion(struct isci_request *ireq, u32 completion_code,
 						  enum sci_base_request_states next)
 {
-	enum sci_status status = SCI_SUCCESS;
-
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
 		ireq->scu_status = SCU_TASK_DONE_GOOD;
@@ -2174,7 +2168,7 @@ static enum sci_status atapi_raw_completion(struct isci_request *ireq, u32 compl
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status atapi_data_tc_completion_handler(struct isci_request *ireq,
@@ -3444,7 +3438,6 @@ int isci_request_execute(struct isci_host *ihost, struct isci_remote_device *ide
 	enum sci_status status = SCI_FAILURE_UNSUPPORTED_PROTOCOL;
 	struct isci_request *ireq;
 	unsigned long flags;
-	int ret = 0;
 
 	/* do common allocation and init of request object. */
 	ireq = isci_io_request_from_tag(ihost, task, tag);
@@ -3524,5 +3517,5 @@ int isci_request_execute(struct isci_host *ihost, struct isci_remote_device *ide
 		status = SCI_SUCCESS;
 	}
 
-	return ret;
+	return 0;
 }
