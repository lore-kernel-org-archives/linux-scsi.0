Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AB9C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 20:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6262311B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 20:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbhAFUiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 15:38:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbhAFUiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 15:38:12 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 106KWoRi099647;
        Wed, 6 Jan 2021 15:37:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=x31loi0UkcxiP+riaTcZKLPN0WsRuXfGo7wtYsWCY7s=;
 b=TOtlXh/G6+Nf1PeC77+Hk1F6g80HoJodH3BIJKd6bqGWhtQkEB7Mmsq878wnmq9JEg5X
 D9JN2XOLMGru/GXaY9FBpjxQWqmNWdGmcql5ZyFUrJu6ScnpJ7BasBm1nx8nz+Rpuj2h
 nTx5Ep4kpMIAFLLRIdB5xH1o+QtJi96V2X5tN+5/TPUGJ+1Db3u1ochnrtYBqtnFbp3O
 MiXNvzAr7Bf92P0n00IRpT1IIHpY7jv1D8l7fK77f5S4eaHU4ACzXIeDy95XAIvCD6ym
 DPDZGX0l1jQnux3aQNEErDeQ07nEIFQSKWHE1jI6mfqdnj8fIjY0lJ4OL3Ov9FkxWW+K QQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35wm8987mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jan 2021 15:37:26 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 106KXrkO017703;
        Wed, 6 Jan 2021 20:37:24 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 35tgf97kyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jan 2021 20:37:24 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 106KbNZK26411382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jan 2021 20:37:23 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 892DB6E050;
        Wed,  6 Jan 2021 20:37:23 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19A046E053;
        Wed,  6 Jan 2021 20:37:23 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jan 2021 20:37:22 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ibmvfc: fix missing cast of ibmvfc_event pointer to u64 handle
Date:   Wed,  6 Jan 2021 14:37:21 -0600
Message-Id: <20210106203721.1054693-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_11:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 clxscore=1011
 mlxscore=0 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 2aa0102c6688 ("scsi: ibmvfc: Use correlation token to tag
commands") sets the vfcFrame correlation token to the pointer handle of
the associated ibmvfc_event. However, that commit failed to cast the
pointer to an appropriate type which in this case is a u64. As such
sparse warnings are generated for both correlation token assignments.

 ibmvfc.c:2375:36: sparse: incorrect type in argument 1 (different base types)
 ibmvfc.c:2375:36: sparse: expected unsigned long long [usertype] val
 ibmvfc.c:2375:36: sparse: got struct ibmvfc_event *[assigned] evt

Add the apporpriate u64 casts when assigning an ibmvfc_event as a
correlation token.

Fixes: Commit 2aa0102c6688 ("scsi: ibmvfc: Use correlation token to tag commands")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 42e4d35e0d35..7312f31df878 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1744,7 +1744,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 		iu->pri_task_attr = IBMVFC_SIMPLE_TASK;
 	}
 
-	vfc_cmd->correlation = cpu_to_be64(evt);
+	vfc_cmd->correlation = cpu_to_be64((u64)evt);
 
 	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
 		return ibmvfc_send_event(evt, vhost, 0);
@@ -2418,7 +2418,7 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 		tmf->flags = cpu_to_be16((IBMVFC_NO_MEM_DESC | IBMVFC_TMF));
 		evt->sync_iu = &rsp_iu;
 
-		tmf->correlation = cpu_to_be64(evt);
+		tmf->correlation = cpu_to_be64((u64)evt);
 
 		init_completion(&evt->comp);
 		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
-- 
2.27.0

