Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758E6C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ADA320760
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGCNVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:21:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35294 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbgGCNVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 09:21:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063CduMZ162542;
        Fri, 3 Jul 2020 09:21:02 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 321ng20hnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 09:21:02 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063DGdCb030922;
        Fri, 3 Jul 2020 13:21:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 31wwch6ugs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 13:21:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063DKvg865536206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 13:20:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEAAD11C050;
        Fri,  3 Jul 2020 13:20:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9942C11C04A;
        Fri,  3 Jul 2020 13:20:57 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.150.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jul 2020 13:20:57 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jrLce-005ouR-J9; Fri, 03 Jul 2020 15:20:56 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 7/7] zfcp: avoid benign overflow of the Request Queue's free-level
Date:   Fri,  3 Jul 2020 15:20:03 +0200
Message-Id: <7f61f59a1f8db270312e64644f9173b8f1ac895f.1593780621.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593780621.git.bblock@linux.ibm.com>
References: <cover.1593780621.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 cotscore=-2147483648 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=2 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030087
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

zfcp_qdio_send() and zfcp_qdio_int_req() run concurrently, adding and
completing SBALs on the Request Queue. There's a theoretical race where
zfcp_qdio_int_req() completes a number of SBALs & increments the queue's
free-level _before_ zfcp_qdio_send() was able to decrement it.

This can cause ->req_q_free to momentarily hold a value larger than
QDIO_MAX_BUFFERS_PER_Q. Luckily zfcp_qdio_send() is always called under
->req_q_lock, and all readers of the free-level also take this lock. So
we can trust that zfcp_qdio_send() will clean up such a temporary
overflow before anyone can actually observe it.

But it's still confusing and annoying to worry about. So adjust the code
to avoid this race.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index d3d110a04884..e78d65bd46b1 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -260,17 +260,20 @@ int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 	zfcp_qdio_account(qdio);
 	spin_unlock(&qdio->stat_lock);
 
+	atomic_sub(sbal_number, &qdio->req_q_free);
+
 	retval = do_QDIO(qdio->adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0,
 			 q_req->sbal_first, sbal_number);
 
 	if (unlikely(retval)) {
+		/* Failed to submit the IO, roll back our modifications. */
+		atomic_add(sbal_number, &qdio->req_q_free);
 		zfcp_qdio_zero_sbals(qdio->req_q, q_req->sbal_first,
 				     sbal_number);
 		return retval;
 	}
 
 	/* account for transferred buffers */
-	atomic_sub(sbal_number, &qdio->req_q_free);
 	qdio->req_q_idx += sbal_number;
 	qdio->req_q_idx %= QDIO_MAX_BUFFERS_PER_Q;
 
-- 
2.26.2

