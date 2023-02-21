Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B65C61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 17:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjBUR5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbjBUR4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 12:56:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876352F7B3;
        Tue, 21 Feb 2023 09:56:27 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmIrS032698;
        Tue, 21 Feb 2023 17:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=uIH3azIpBzsUm2sTboAkIcqhCWeJqR/wd3Q9h2o485c=;
 b=m+5t2Mo0yAep93FMnfoJ2dznJNjdIg8nAzMUH4V+cHvHC9u0o3Ffs0UgpyIFQMLFDVzZ
 DoqyD2LeO3T0Ue07qcfLfuQkJOOqwoBxATezWHXarw0rbJSV4C1hBrl4rkdtPY2dzV+s
 W/Vmj1Qwhc68x+m3vSEEM8vgDFpKF/0uEWVXs/QVj7Jwxa8tSYSLweftMH6cx5RPQfuf
 /335upPeCE5tcUpG5ufy2R0QzGP4qMpwBrTXlElX21aNU5+YnqaLXaN62+rYfPCdkR75
 i5uNcPAkW4oziEtiPB0XbC0YKEUaOGFVQVw4rgEGMfi7L5zpODjzoRR37OeVjbD17U8P Mg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw2fbrdes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:07 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LClEth008529;
        Tue, 21 Feb 2023 17:56:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ntnxf397m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:05 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHu1lA41877786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:56:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B68ED20043;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CFD420040;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.246])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pUWrx-003al4-0i;
        Tue, 21 Feb 2023 18:56:01 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/3] zfcp: change the type of all fsf request id fields and variables to u64
Date:   Tue, 21 Feb 2023 18:55:59 +0100
Message-Id: <9c9cbe5acc2b419a22dce2fed847e3db91b60201.1677000450.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1677000450.git.bblock@linux.ibm.com>
References: <cover.1677000450.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WNSweivPSSf0TrQfwz8CxRKQ8mMoSF5Z
X-Proofpoint-ORIG-GUID: WNSweivPSSf0TrQfwz8CxRKQ8mMoSF5Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302210148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use different integer types throughout zfcp to store the FSF request
ID and related values; some places use `unsigned long` and others `u64`.
On s390x these are effectively the same type, but this might cause
confusions and is generally inconsistent.

The specification for the used hardware specifies this value as
64 bit number, and ultimately we use this value to communicate with the
hardware, so it makes sense to change the type of all these variables to
`u64` where we can.
    The only exception being when we store it in the `host_scribble`
field of a `struct scsi_cmnd`; for this case we add a build time check
to make sure they are compatible.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c     |  2 +-
 drivers/s390/scsi/zfcp_def.h     |  6 +++---
 drivers/s390/scsi/zfcp_fsf.c     | 15 ++++++++-------
 drivers/s390/scsi/zfcp_qdio.h    |  2 +-
 drivers/s390/scsi/zfcp_reqlist.h |  8 ++++----
 drivers/s390/scsi/zfcp_scsi.c    |  2 +-
 6 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index cbc3b62cd9e5..d28c55ae9f01 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -649,7 +649,7 @@ void zfcp_dbf_scsi_common(char *tag, int level, struct scsi_device *sdev,
 		rec->scsi_id = sc->device->id;
 		rec->scsi_lun = (u32)sc->device->lun;
 		rec->scsi_lun_64_hi = (u32)(sc->device->lun >> 32);
-		rec->host_scribble = (unsigned long)sc->host_scribble;
+		rec->host_scribble = (u64)sc->host_scribble;
 
 		memcpy(rec->scsi_opcode, sc->cmnd,
 		       min_t(int, sc->cmd_len, ZFCP_DBF_SCSI_OPCODE));
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 94de55304a02..6c761299a22f 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -129,7 +129,7 @@ struct zfcp_erp_action {
 	struct scsi_device *sdev;
 	u32		status;	      /* recovery status */
 	enum zfcp_erp_steps	step;	/* active step of this erp action */
-	unsigned long		fsf_req_id;
+	u64			fsf_req_id;
 	struct timer_list timer;
 };
 
@@ -163,7 +163,7 @@ struct zfcp_adapter {
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list;	   /* remote port list */
 	rwlock_t		port_list_lock;    /* port list lock */
-	unsigned long		req_no;		   /* unique FSF req number */
+	u64			req_no;		   /* unique FSF req number */
 	struct zfcp_reqlist	*req_list;
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
 	rwlock_t		abort_lock;        /* Protects against SCSI
@@ -325,7 +325,7 @@ static inline u64 zfcp_scsi_dev_lun(struct scsi_device *sdev)
  */
 struct zfcp_fsf_req {
 	struct list_head	list;
-	unsigned long		req_id;
+	u64			req_id;
 	struct zfcp_adapter	*adapter;
 	struct zfcp_qdio_req	qdio_req;
 	struct completion	completion;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index ab3ea529cca7..71eabcc26cbb 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -884,7 +884,7 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	const bool is_srb = zfcp_fsf_req_is_status_read_buffer(req);
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
-	unsigned long req_id = req->req_id;
+	u64 req_id = req->req_id;
 
 	zfcp_reqlist_add(adapter->req_list, req);
 
@@ -1042,7 +1042,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 	struct scsi_device *sdev = scmnd->device;
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
-	unsigned long old_req_id = (unsigned long) scmnd->host_scribble;
+	u64 old_req_id = (u64) scmnd->host_scribble;
 
 	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
@@ -1065,7 +1065,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 	req->handler = zfcp_fsf_abort_fcp_command_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
-	req->qtcb->bottom.support.req_handle = (u64) old_req_id;
+	req->qtcb->bottom.support.req_handle = old_req_id;
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req)) {
@@ -1919,7 +1919,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
-	unsigned long req_id = 0;
+	u64 req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1978,7 +1978,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
-	unsigned long req_id = 0;
+	u64 req_id = 0;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -2587,6 +2587,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 		goto out;
 	}
 
+	BUILD_BUG_ON(sizeof(scsi_cmnd->host_scribble) < sizeof(req->req_id));
 	scsi_cmnd->host_scribble = (unsigned char *) req->req_id;
 
 	io = &req->qtcb->bottom.io;
@@ -2732,7 +2733,7 @@ void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
 	struct qdio_buffer *sbal = qdio->res_q[sbal_idx];
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req;
-	unsigned long req_id;
+	u64 req_id;
 	int idx;
 
 	for (idx = 0; idx < QDIO_MAX_ELEMENTS_PER_BUFFER; idx++) {
@@ -2747,7 +2748,7 @@ void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
 			 * corruption and must stop the machine immediately.
 			 */
 			zfcp_qdio_siosl(adapter);
-			panic("error: unknown req_id (%lx) on adapter %s.\n",
+			panic("error: unknown req_id (%llx) on adapter %s.\n",
 			      req_id, dev_name(&adapter->ccw_device->dev));
 		}
 
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 390706867df3..90134d9b69a7 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -115,7 +115,7 @@ zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
  */
 static inline
 void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			unsigned long req_id, u8 sbtype, void *data, u32 len)
+			u64 req_id, u8 sbtype, void *data, u32 len)
 {
 	struct qdio_buffer_element *sbale;
 	int count = min(atomic_read(&qdio->req_q_free),
diff --git a/drivers/s390/scsi/zfcp_reqlist.h b/drivers/s390/scsi/zfcp_reqlist.h
index f4bac61dfbd0..59fbb1b128cb 100644
--- a/drivers/s390/scsi/zfcp_reqlist.h
+++ b/drivers/s390/scsi/zfcp_reqlist.h
@@ -26,7 +26,7 @@ struct zfcp_reqlist {
 	struct list_head buckets[ZFCP_REQ_LIST_BUCKETS];
 };
 
-static inline size_t zfcp_reqlist_hash(unsigned long req_id)
+static inline size_t zfcp_reqlist_hash(u64 req_id)
 {
 	return req_id % ZFCP_REQ_LIST_BUCKETS;
 }
@@ -83,7 +83,7 @@ static inline void zfcp_reqlist_free(struct zfcp_reqlist *rl)
 }
 
 static inline struct zfcp_fsf_req *
-_zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
+_zfcp_reqlist_find(struct zfcp_reqlist *rl, u64 req_id)
 {
 	struct zfcp_fsf_req *req;
 	size_t i;
@@ -104,7 +104,7 @@ _zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
  * or NULL if there is no known FSF request with this id.
  */
 static inline struct zfcp_fsf_req *
-zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
+zfcp_reqlist_find(struct zfcp_reqlist *rl, u64 req_id)
 {
 	unsigned long flags;
 	struct zfcp_fsf_req *req;
@@ -129,7 +129,7 @@ zfcp_reqlist_find(struct zfcp_reqlist *rl, unsigned long req_id)
  * NULL if it has not been found.
  */
 static inline struct zfcp_fsf_req *
-zfcp_reqlist_find_rm(struct zfcp_reqlist *rl, unsigned long req_id)
+zfcp_reqlist_find_rm(struct zfcp_reqlist *rl, u64 req_id)
 {
 	unsigned long flags;
 	struct zfcp_fsf_req *req;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 526ac240d9fe..3dbf4b21d127 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -170,7 +170,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
 	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
-	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
+	u64 old_reqid = (u64) scpnt->host_scribble;
 	int retval = SUCCESS, ret;
 	int retry = 3;
 	char *dbf_tag;
-- 
2.39.2

