From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH] zfcp: fix use-after-free by not tracing WKA port open/close on failed send
Date: Wed,  8 Feb 2017 15:34:22 +0100
Message-ID: <20170208143422.64943-1-maier@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Dan Carpenter kindly reported:
<quote>
The patch d27a7cb91960: "zfcp: trace on request for open and close of
WKA port" from Aug 10, 2016, leads to the following static checker
warning:

	drivers/s390/scsi/zfcp_fsf.c:1615 zfcp_fsf_open_wka_port()
	warn: 'req' was already freed.

drivers/s390/scsi/zfcp_fsf.c
  1609          zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
  1610          retval = zfcp_fsf_req_send(req);
  1611          if (retval)
  1612                  zfcp_fsf_req_free(req);
                                          ^^^
Freed.

  1613  out:
  1614          spin_unlock_irq(&qdio->req_q_lock);
  1615          if (req && !IS_ERR(req))
  1616                  zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
                                                                  ^^^^^^^^^^^
Use after free.

  1617          return retval;
  1618  }

Same thing for zfcp_fsf_close_wka_port() as well.
</quote>

Rather than relying on req being NULL (or ERR_PTR) for all cases where
we don't want to trace or should not trace,
simply check retval which is unconditionally initialized with -EIO != 0
and it can only become 0 on successful retval = zfcp_fsf_req_send(req).
With that we can also remove the then again unnecessary unconditional
initialization of req which was introduced with that earlier commit.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: d27a7cb91960 ("zfcp: trace on request for open and close of WKA port")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1583,7 +1583,7 @@ out:
 int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
-	struct zfcp_fsf_req *req = NULL;
+	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1612,7 +1612,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 		zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
-	if (req && !IS_ERR(req))
+	if (!retval)
 		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
 	return retval;
 }
@@ -1638,7 +1638,7 @@ static void zfcp_fsf_close_wka_port_hand
 int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
-	struct zfcp_fsf_req *req = NULL;
+	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1667,7 +1667,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 		zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
-	if (req && !IS_ERR(req))
+	if (!retval)
 		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req->req_id);
 	return retval;
 }
