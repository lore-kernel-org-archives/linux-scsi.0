Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3965C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 23:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8956A23BA7
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 23:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgLRXUP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 18:20:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgLRXUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Dec 2020 18:20:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIN27pa024514;
        Fri, 18 Dec 2020 18:19:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UOW/U+R2R9ikea6gkC30D+0Oge3XWVvq+FUiDEVEwjY=;
 b=sRUdoMdcwVXd8RMfepWBHjrwNh6bHWhQsekW0ekt1WLFT+eR3UK0nYBYX8l15XRsm3SO
 EI4TfS7DA9Q0fRiw/gNda/ohXaC0ecEnCFhkOcvzx0BMWEoVrkbYlPN9R6714ghX5Jj3
 vB7JbyuRkbQpXQadDKZ6oFKTYO+0bDTzNLkIaE1XsmbpXrbA4O2zFmcDokl6B9G2RvVt
 TVcpB+4enLtoISSX0zZSbzMfHZ4tg94rd6csxatcsASHlulyK9BxJ2XvKvvlJkg+sBYv
 Wu7n+tb74IkY/NMFAv2At0l1wQUrPjgEC9d9jM+6hx1fms5Y4gnQ41RqpK1s6FCmMhIe /A== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35h5exrpkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 18:19:28 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BINHQvA008699;
        Fri, 18 Dec 2020 23:19:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 35cnga7cn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 23:19:27 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BINJPOC21037410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 23:19:25 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896A113604F;
        Fri, 18 Dec 2020 23:19:25 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39F8C136051;
        Fri, 18 Dec 2020 23:19:25 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 23:19:25 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ibmvfc: relax locking around ibmvfc_queuecommand
Date:   Fri, 18 Dec 2020 17:19:16 -0600
Message-Id: <20201218231916.279833-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201218231916.279833-1-tyreld@linux.ibm.com>
References: <20201218231916.279833-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_14:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012180153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The drivers queuecommand routine is still wrapped to hold the host lock
for the duration of the call. This will become problematic when moving
to multiple queues due to the lock contention preventing asynchronous
submissions to mulitple queues. There is no real legatimate reason to
hold the host lock, and previous patches have insured proper protection
of moving ibmvfc_event objects between free and sent lists.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b74080489807..151e9111ab8a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1793,10 +1793,9 @@ static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struct ibmvfc_event *evt, struct s
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
-			       void (*done) (struct scsi_cmnd *))
+static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 {
-	struct ibmvfc_host *vhost = shost_priv(cmnd->device->host);
+	struct ibmvfc_host *vhost = shost_priv(shost);
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_fcp_cmd_iu *iu;
@@ -1806,7 +1805,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
 	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
 		cmnd->result = rc;
-		done(cmnd);
+		cmnd->scsi_done(cmnd);
 		return 0;
 	}
 
@@ -1814,7 +1813,6 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	evt = ibmvfc_get_event(&vhost->crq);
 	ibmvfc_init_event(evt, ibmvfc_scsi_done, IBMVFC_CMD_FORMAT);
 	evt->cmnd = cmnd;
-	cmnd->scsi_done = done;
 
 	vfc_cmd = ibmvfc_init_vfc_cmd(evt, cmnd->device);
 	iu = ibmvfc_get_fcp_iu(vhost, vfc_cmd);
@@ -1841,12 +1839,10 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 			    "Failed to map DMA buffer for command. rc=%d\n", rc);
 
 	cmnd->result = DID_ERROR << 16;
-	done(cmnd);
+	cmnd->scsi_done(cmnd);
 	return 0;
 }
 
-static DEF_SCSI_QCMD(ibmvfc_queuecommand)
-
 /**
  * ibmvfc_sync_completion - Signal that a synchronous command has completed
  * @evt:	ibmvfc event struct
-- 
2.27.0

