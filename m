Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8802C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 01:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF5664E33
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 01:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCKBWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 20:22:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230002AbhCKBW0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Mar 2021 20:22:26 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12B13hRR067777;
        Wed, 10 Mar 2021 20:22:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mFXtU+zxowGTGGG0QOp7xGjGqTn6kG26cxtGR7OX7jk=;
 b=EEdCyich9uOHhuh++cmQgnooeOu7G4uBc6Z+j1ci3i8qle0Nun3JyUoKkR5M3v5UtjbJ
 xdBN49LYn/ovGQcnis8HpWNh+Pmy04rZt8LKPFMrLwk/dgkrZB8ccKhMBrjwwZjaprtP
 fcYWbIvxFG+gk+QMpzI6UKe68YADsSrypS7OFjCw9/zJjhbjctGk60oZeQ+ugXrnx8fq
 QB25Gl1TZXOq4kkHkcn4WsR3vw96FriKl9bHLeLMo4Ub7rIOR3xPwgnwzCetXB7rWs5J
 FRdplKkxthmPn73nFKCL24Pw7DlcqUyVQNaM+n93eewjW777ISwJS20Zh0DhVm/313e5 wQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m07fch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Mar 2021 20:22:17 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12B1Kl25025455;
        Thu, 11 Mar 2021 01:22:16 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3768mh489f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 01:22:16 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12B1MFkU21430636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 01:22:15 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46A746E053;
        Thu, 11 Mar 2021 01:22:15 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A68AB6E050;
        Thu, 11 Mar 2021 01:22:14 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 01:22:14 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH] ibmvfc: free channel_setup_buf during device tear down
Date:   Wed, 10 Mar 2021 19:22:12 -0600
Message-Id: <20210311012212.428068-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-10_13:2021-03-10,2021-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 phishscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The buffer for negotiating channel setup is DMA allocated at device
probe time. However, the remove path fails to free this allocation which
will prevent the hypervisor from releasing the virtual device in the
case of a hotplug remove.

Fix this issue by freeing the buffer allocation in ibmvfc_free_mem().

Fixes: e95eef3fc0bc ("scsi: ibmvfc: Implement channel enquiry and setup commands")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index e663085a8944..76531eec49de 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5770,6 +5770,8 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 			  vhost->disc_buf_dma);
 	dma_free_coherent(vhost->dev, sizeof(*vhost->login_buf),
 			  vhost->login_buf, vhost->login_buf_dma);
+	dma_free_coherent(vhost->dev, sizeof(*vhost->channel_setup_buf),
+			  vhost->channel_setup_buf, vhost->channel_setup_dma);
 	dma_pool_destroy(vhost->sg_pool);
 	ibmvfc_free_queue(vhost, async_q);
 	LEAVE;
-- 
2.27.0

