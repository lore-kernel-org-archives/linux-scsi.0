Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B499CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jan 2022 16:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243835AbiARQ6R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 11:58:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbiARQ6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jan 2022 11:58:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IExTxr032520;
        Tue, 18 Jan 2022 16:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=fN+4VdW7csDQnRSvc2zhuXQDipHsikrdQ2xEWTx8DYs=;
 b=nQhgb6epA81zqx4s7oAg6V3vpCLHvNLtmA5wMZ0gcNwnjnuqbEgz7HSEk3NN7bVBJV+P
 LBfmAdZSu7PgI39Zh+hscU/ZXMCmEzkWgptYcF1tARhZBAvKDtMuiYsGmOBgnH7veEN/
 QF1Wf3vOnZMzr0E6R999wwU6ryuXiCKXHXuuIuT5gGs+P7kF4lNM1IFOl3R+5u4lh47v
 izkvxTzZMHIWJN0m+OrkEX2BirfegK/sXyLnlycF24C6Uwnx85DJVP/jp2M5H2sqftgt
 onzZ0otCjYSO0hzZK9hyuLOtAthGCHXL4DEc2ZPCqb1BBtH8l4NssnCnlEDvtcs0q9qV pw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnxfgw5ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:58:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IGuxeK029377;
        Tue, 18 Jan 2022 16:58:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3dknwad7n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:58:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IGw5SJ44892606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 16:58:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA10A4055;
        Tue, 18 Jan 2022 16:58:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8577CA405B;
        Tue, 18 Jan 2022 16:58:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 16:58:05 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH] zfcp: fix failed recovery on gone remote port with non-NPIV FCP devices
Date:   Tue, 18 Jan 2022 17:58:03 +0100
Message-Id: <20220118165803.3667947-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W40AfIHTNYURBVoYb_i_SYHhdWW8IRw0
X-Proofpoint-ORIG-GUID: W40AfIHTNYURBVoYb_i_SYHhdWW8IRw0
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppose we have an environment with a number of non-NPIV FCP devices
(virtual HBAs / FCP devices / zfcp "adapter"s) sharing the same physical
FCP channel (HBA port) and its I_T nexus. Plus a number of storage target
ports zoned to such shared channel. Now one target port logs out of the
fabric causing an RSCN. Zfcp reacts with an ADISC ELS and subsequent port
recovery depending on the ADISC result. This happens on all such FCP
devices (in different Linux images) concurrently as they all receive a copy
of this RSCN. In the following we look at one of those FCP devices.

Requests other than FSF_QTCB_FCP_CMND can be slow until they get a
response.

Depending on which requests are affected by slow responses, there are
different recovery outcomes. Here we want to fix failed recoveries on
port or adapter level by avoiding recovery requests that can be slow.

We need the cached N_Port_ID for the remote port "link" test with ADISC.
Just before sending the ADISC, we now intentionally forget the old cached
N_Port_ID. The idea is that on receiving an RSCN for a port, we have to
assume that any cached information about this port is stale.
This forces a fresh new GID_PN [FC-GS] nameserver lookup on any subsequent
recovery for the same port. Since we typically can still communicate with
the nameserver efficiently, we now reach steady state quicker: Either the
nameserver still does not know about the port so we stop recovery, or the
nameserver already knows the port potentially with a new N_Port_ID and we
can successfully and quickly perform open port recovery.
For the one case, where ADISC returns successfully, we re-initialize
port->d_id because that case does not involve any port recovery.

This also solves a problem if the storage WWPN quickly logs into the fabric
again but with a different N_Port_ID. Such as on virtual WWPN takeover
during target NPIV failover.
[https://www.redbooks.ibm.com/abstracts/redp5477.html]
In that case the RSCN from the storage FDISC was ignored by zfcp and we
could not successfully recover the failover. On some later failback
on the storage, we could have been lucky if the virtual WWPN
got the same old N_Port_ID from the SAN switch as we still had cached.
Then the related RSCN triggered a successful port reopen recovery.
However, there is no guarantee to get the same N_Port_ID on NPIV FDISC.

Even though NPIV-enabled FCP devices are not affected by this problem, this
code change optimizes recovery time for gone remote ports as a side effect.
The timely drop of cached N_Port_IDs prevents unnecessary slow open port
attempts.

While the problem might have been in code before v2.6.32 commit
799b76d09aee ("[SCSI] zfcp: Decouple gid_pn requests from erp")
this fix depends on the gid_pn_work introduced with that commit,
so we mark it as culprit to satisfy fix dependencies.

Note: Point-to-point remote port is already handled separately and gets
its N_Port_ID from the cached peer_d_id. So resetting port->d_id in
general does not affect PtP.

Suggested-by: Benjamin Block <bblock@linux.ibm.com>
Fixes: 799b76d09aee ("[SCSI] zfcp: Decouple gid_pn requests from erp")
Cc: <stable@vger.kernel.org> #2.6.32+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index d24cafe02708..511bf8e0a436 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -521,6 +521,8 @@ static void zfcp_fc_adisc_handler(void *data)
 		goto out;
 	}
 
+	/* re-init to undo drop from zfcp_fc_adisc() */
+	port->d_id = ntoh24(adisc_resp->adisc_port_id);
 	/* port is good, unblock rport without going through erp */
 	zfcp_scsi_schedule_rport_register(port);
  out:
@@ -534,6 +536,7 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	struct zfcp_fc_req *fc_req;
 	struct zfcp_adapter *adapter = port->adapter;
 	struct Scsi_Host *shost = adapter->scsi_host;
+	u32 d_id;
 	int ret;
 
 	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_ATOMIC);
@@ -558,7 +561,15 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 	fc_req->u.adisc.req.adisc_cmd = ELS_ADISC;
 	hton24(fc_req->u.adisc.req.adisc_port_id, fc_host_port_id(shost));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &fc_req->ct_els,
+	d_id = port->d_id; /* remember as destination for send els below */
+	/*
+	 * Force fresh GID_PN lookup on next port recovery.
+	 * Must happen after request setup and before sending request,
+	 * to prevent race with port->d_id re-init in zfcp_fc_adisc_handler().
+	 */
+	port->d_id = 0;
+
+	ret = zfcp_fsf_send_els(adapter, d_id, &fc_req->ct_els,
 				ZFCP_FC_CTELS_TMO);
 	if (ret)
 		kmem_cache_free(zfcp_fc_req_cache, fc_req);

base-commit: 2576e153cd982d540b212e989458edc42ad1b390
-- 
2.32.0

