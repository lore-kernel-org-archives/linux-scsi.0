Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A81AC61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 17:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbjBUR5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbjBUR4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 12:56:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C642E0C7;
        Tue, 21 Feb 2023 09:56:26 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmIWP032531;
        Tue, 21 Feb 2023 17:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=0eG07H0FuWc42mew9zTJXO9IqSTz7CwO+5RmoJaf5oQ=;
 b=O6V7/4Jow0XTAg/zB82Gs+5cb1cJcAHMsyR4Ar+K4DCptTJTkrW9aBQv8vIxoj7jjctH
 T6Xc5cvj9D+OJxn38mtw1KTD9TiGIv5oaW6EOGhiv1fuutKe98UuFuOwi0KsEp+EbzJ8
 v45Lyz/GWz/88172v3lcrQfhRTyKeqG4v5wLU6FEvzLoOqoyEhUlT5BuSK3mp1Xpca1e
 VdUiELAT5uHrUhZAtrhq8ufWNp8zemH2cUzJ+vlwHKbJYEc3nOyd/fOldCNDGAiMR5Oy
 oN4xqDpxPZeoozJVhoC2X4Wq80d9QYBxKfOvTzSMfIwkdJVnO/r/WotUHNcIg2ZHrjJG 3g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw2fbrdew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:07 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LDHsTa020937;
        Tue, 21 Feb 2023 17:56:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6b98a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHu2UO54722968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:56:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE2A82004E;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D91AC20043;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.246])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pUWrx-003al7-13;
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
Subject: [PATCH 3/3] zfcp: trace when request remove fails after qdio send fails
Date:   Tue, 21 Feb 2023 18:56:00 +0100
Message-Id: <99b8246b2d71b63fa4f9c56333e2037502f7f5af.1677000450.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1677000450.git.bblock@linux.ibm.com>
References: <cover.1677000450.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mEUSIT3isi_0OZmDdV30FClOEcFdJvAa
X-Proofpoint-ORIG-GUID: mEUSIT3isi_0OZmDdV30FClOEcFdJvAa
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

When we fail to send a FSF request in `zfcp_fsf_req_send()` when calling
`zfcp_qdio_send()` we try to remove the request object from our internal
hash table again to prevent keeping a stale memory reference. This
removal might still - very much theoretically - fail.

To store some evidence of when this happens add a new trace record for
this case; tag: `fsrsrmf`.
    We reuse the `ZFCP_DBF_HBA_RES` trace ID for this, but mark all
fields other then the request ID with ~0, to make fairly obvious that
these are invalid values. This faking has to be done because we don't
have a valid request object at this point, and can not safely access any
of the memory of the old object - we just failed to find it in our hash
table, so it might be gone already.

Here is an example of a decoded trace record:

    Timestamp      : 2023-02-17-13:09:12:748140
    Area           : HBA
    Subarea        : 1
    Level          : -
    Exception      : 000003ff7ff500c2
    CPU ID         : 0011
    Caller         : 0x0
    Record ID      : 1
    Tag            : fsrsrmf
    Request ID     : 0x0000000080126ab6
    Request status : 0xffffffff
    FSF cmnd       : 0xffffffff
    FSF sequence no: 0xffffffff
    FSF issued     : 2042-09-18-01:53:47:370495
    FSF stat       : 0xffffffff
    FSF stat qual  : ffffffff ffffffff ffffffff ffffffff
    Prot stat      : 0xffffffff
    Prot stat qual : ffffffff ffffffff ffffffff ffffffff
    Port handle    : 0xffffffff
    LUN handle     : 0xffffffff

This provides at least some basic evidence that this event happened, and
what object was affected.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 44 +++++++++++++++++++++++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h |  5 +++-
 drivers/s390/scsi/zfcp_fsf.c |  7 ++++--
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index d28c55ae9f01..d904625afd40 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -4,7 +4,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corp. 2002, 2020
+ * Copyright IBM Corp. 2002, 2023
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -145,6 +145,48 @@ void zfcp_dbf_hba_fsf_fces(char *tag, const struct zfcp_fsf_req *req, u64 wwpn,
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
+/**
+ * zfcp_dbf_hba_fsf_reqid - trace only the tag and a request ID
+ * @tag: tag documenting the source
+ * @level: trace level
+ * @adapter: adapter instance the request ID belongs to
+ * @req_id: the request ID to trace
+ */
+void zfcp_dbf_hba_fsf_reqid(const char *const tag, const int level,
+			    struct zfcp_adapter *const adapter,
+			    const u64 req_id)
+{
+	struct zfcp_dbf *const dbf = adapter->dbf;
+	struct zfcp_dbf_hba *const rec = &dbf->hba_buf;
+	struct zfcp_dbf_hba_res *const res = &rec->u.res;
+	unsigned long flags;
+
+	if (unlikely(!debug_level_enabled(dbf->hba, level)))
+		return;
+
+	spin_lock_irqsave(&dbf->hba_lock, flags);
+	memset(rec, 0, sizeof(*rec));
+
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+
+	rec->id = ZFCP_DBF_HBA_RES;
+	rec->fsf_req_id = req_id;
+	rec->fsf_req_status = ~0u;
+	rec->fsf_cmd = ~0u;
+	rec->fsf_seq_no = ~0u;
+
+	res->req_issued = ~0ull;
+	res->prot_status = ~0u;
+	memset(res->prot_status_qual, 0xff, sizeof(res->prot_status_qual));
+	res->fsf_status = ~0u;
+	memset(res->fsf_status_qual, 0xff, sizeof(res->fsf_status_qual));
+	res->port_handle = ~0u;
+	res->lun_handle = ~0u;
+
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
+}
+
 /**
  * zfcp_dbf_hba_fsf_uss - trace event for an unsolicited status buffer
  * @tag: tag indicating which kind of unsolicited status has been received
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index c302cbb18a55..9f5152b42b0e 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -4,7 +4,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corp. 2002, 2020
+ * Copyright IBM Corp. 2002, 2023
  */
 
 #ifndef ZFCP_EXT_H
@@ -46,6 +46,9 @@ extern void zfcp_dbf_hba_fsf_res(char *, int, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_fsf_fces(char *tag, const struct zfcp_fsf_req *req,
 				  u64 wwpn, u32 fc_security_old,
 				  u32 fc_security_new);
+extern void zfcp_dbf_hba_fsf_reqid(const char *const tag, const int level,
+				   struct zfcp_adapter *const adapter,
+				   const u64 req_id);
 extern void zfcp_dbf_hba_bit_err(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_def_err(struct zfcp_adapter *, u64, u16, void **);
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 71eabcc26cbb..ceed1b6f7cb6 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4,7 +4,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corp. 2002, 2020
+ * Copyright IBM Corp. 2002, 2023
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -892,8 +892,11 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	req->issued = get_tod_clock();
 	if (zfcp_qdio_send(qdio, &req->qdio_req)) {
 		del_timer_sync(&req->timer);
+
 		/* lookup request again, list might have changed */
-		zfcp_reqlist_find_rm(adapter->req_list, req_id);
+		if (zfcp_reqlist_find_rm(adapter->req_list, req_id) == NULL)
+			zfcp_dbf_hba_fsf_reqid("fsrsrmf", 1, adapter, req_id);
+
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1");
 		return -EIO;
 	}
-- 
2.39.2

