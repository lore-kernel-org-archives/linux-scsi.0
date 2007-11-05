From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.24-rc1
Date: Mon, 05 Nov 2007 11:45:20 -0600
Message-ID: <1194284720.5367.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755024AbXKERph@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

These are a fairly straightforward and small collection of fixes.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Ilpo J=C3=A4rvinen (1):
      osst: fix if (...) \n #if... cases missing semicolons when false

James Bottomley (1):
      Update MAINTAINER email address and trees

James Smart (1):
      lpfc : Correct queue tag handling

Robert Jennings (1):
      ibmvscsi: Prevent IO during partner login

The diffstat is:

 MAINTAINERS                      |    6 ++++--
 drivers/scsi/ibmvscsi/ibmvscsi.c |   19 ++++++++++++++-----
 drivers/scsi/lpfc/lpfc_scsi.c    |    5 +++--
 drivers/scsi/osst.c              |    6 ++++--
 4 files changed, 25 insertions(+), 11 deletions(-)

James

---
And the complete diff:

diff --git a/MAINTAINERS b/MAINTAINERS
index 231bda2..b03014d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2544,7 +2544,7 @@ S:	Supported
=20
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
-M:	jejb@steeleye.com
+M:	James.Bottomley@HansenPartnership.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
=20
@@ -3296,9 +3296,11 @@ S:	Maintained
=20
 SCSI SUBSYSTEM
 P:	James E.J. Bottomley
-M:	James.Bottomley@SteelEye.com
+M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
 S:	Maintained
=20
 SCSI TAPE DRIVER
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/i=
bmvscsi.c
index 22d91ee..5f2396c 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -556,7 +556,7 @@ static int ibmvscsi_send_srp_event(struct srp_event=
_struct *evt_struct,
 				   unsigned long timeout)
 {
 	u64 *crq_as_u64 =3D (u64 *) &evt_struct->crq;
-	int request_status;
+	int request_status =3D 0;
 	int rc;
=20
 	/* If we have exhausted our request limit, just fail this request,
@@ -574,6 +574,13 @@ static int ibmvscsi_send_srp_event(struct srp_even=
t_struct *evt_struct,
 		if (request_status < -1)
 			goto send_error;
 		/* Otherwise, we may have run out of requests. */
+		/* If request limit was 0 when we started the adapter is in the
+		 * process of performing a login with the server adapter, or
+		 * we may have run out of requests.
+		 */
+		else if (request_status =3D=3D -1 &&
+		         evt_struct->iu.srp.login_req.opcode !=3D SRP_LOGIN_REQ)
+			goto send_busy;
 		/* Abort and reset calls should make it through.
 		 * Nothing except abort and reset should use the last two
 		 * slots unless we had two or less to begin with.
@@ -633,7 +640,8 @@ static int ibmvscsi_send_srp_event(struct srp_event=
_struct *evt_struct,
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
=20
 	free_event_struct(&hostdata->pool, evt_struct);
-	atomic_inc(&hostdata->request_limit);
+	if (request_status !=3D -1)
+		atomic_inc(&hostdata->request_limit);
 	return SCSI_MLQUEUE_HOST_BUSY;
=20
  send_error:
@@ -927,10 +935,11 @@ static int send_srp_login(struct ibmvscsi_host_da=
ta *hostdata)
 	login->req_buf_fmt =3D SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIREC=
T;
 =09
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	/* Start out with a request limit of 1, since this is negotiated in
-	 * the login request we are just sending
+	/* Start out with a request limit of 0, since this is negotiated in
+	 * the login request we are just sending and login requests always
+	 * get sent by the driver regardless of request_limit.
 	 */
-	atomic_set(&hostdata->request_limit, 1);
+	atomic_set(&hostdata->request_limit, 0);
=20
 	rc =3D ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2=
);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scs=
i.c
index c075556..4e46045 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -682,6 +682,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struc=
t lpfc_scsi_buf *lpfc_cmd,
 	IOCB_t *iocb_cmd =3D &lpfc_cmd->cur_iocbq.iocb;
 	struct lpfc_iocbq *piocbq =3D &(lpfc_cmd->cur_iocbq);
 	int datadir =3D scsi_cmnd->sc_data_direction;
+	char tag[2];
=20
 	lpfc_cmd->fcp_rsp->rspSnsLen =3D 0;
 	/* clear task management bits */
@@ -692,8 +693,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struc=
t lpfc_scsi_buf *lpfc_cmd,
=20
 	memcpy(&fcp_cmnd->fcpCdb[0], scsi_cmnd->cmnd, 16);
=20
-	if (scsi_cmnd->device->tagged_supported) {
-		switch (scsi_cmnd->tag) {
+	if (scsi_populate_tag_msg(scsi_cmnd, tag)) {
+		switch (tag[0]) {
 		case HEAD_OF_QUEUE_TAG:
 			fcp_cmnd->fcpCntl1 =3D HEAD_OF_Q;
 			break;
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 4652ad2..abef704 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -593,10 +593,11 @@ static int osst_verify_frame(struct osst_tape * S=
Tp, int frame_seq_number, int q
 	if (aux->frame_type !=3D OS_FRAME_TYPE_DATA &&
 	    aux->frame_type !=3D OS_FRAME_TYPE_EOD &&
 	    aux->frame_type !=3D OS_FRAME_TYPE_MARKER) {
-		if (!quiet)
+		if (!quiet) {
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Skipping frame, frame type %x\n", name, =
aux->frame_type);
 #endif
+		}
 		goto err_out;
 	}
 	if (aux->frame_type =3D=3D OS_FRAME_TYPE_EOD &&
@@ -606,11 +607,12 @@ static int osst_verify_frame(struct osst_tape * S=
Tp, int frame_seq_number, int q
 		goto err_out;
 	}
         if (frame_seq_number !=3D -1 && ntohl(aux->frame_seq_num) !=3D=
 frame_seq_number) {
-		if (!quiet)
+		if (!quiet) {
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Skipping frame, sequence number %u (expe=
cted %d)\n",=20
 					    name, ntohl(aux->frame_seq_num), frame_seq_number);
 #endif
+		}
 		goto err_out;
 	}
 	if (aux->frame_type =3D=3D OS_FRAME_TYPE_MARKER) {
