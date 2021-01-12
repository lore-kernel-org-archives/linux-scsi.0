Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E25C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B045E23134
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbhALPHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:07:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbhALPHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 10:07:48 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CF2XEj045078;
        Tue, 12 Jan 2021 10:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=2+QIzgqEv4+5LR/ITcMUSMKb5H8YlfepXNhjamCOSFM=;
 b=kj4H4SoyYgcHayKhQ8vl7mT/lgPWj2CL487++RhiCJI9Kwao1Krrbvd5D6rISBiSQb4k
 FMinPzkboKoOvUlstAjVXudSoqDcm1u/zjGU4/dzHbp2h7Z3ftIefGOrDW5jYXVcJlM/
 TBnbR4Gh5LGR+YKP2YR0cIHEnkt5E36ZcqbxrxetaHfRxeX+WgR9ZO/nGcRIvicb/BG5
 ZZVltLB2eYkgY3lvLCGkm4ggyAqRIrIUO11ToxGYO1kdjXN0Sn87LUoaIfeB+pkLpZga
 goGc6umYlp3Wf8WDKQjBm1fKydK9ghOD7wl5jGgh+41/ZuTV1gA44WIrEYjLTEE7en70 lg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361ds58yav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 10:07:04 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CEvxTs031137;
        Tue, 12 Jan 2021 15:06:59 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 35y4494hqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 15:06:59 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CF6wjj15925716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 15:06:59 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E05972805A;
        Tue, 12 Jan 2021 15:06:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3072828058;
        Tue, 12 Jan 2021 15:06:58 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.25.172])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 15:06:58 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     tyreld@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: Set default timeout to avoid crash during migration
Date:   Tue, 12 Jan 2021 09:06:38 -0600
Message-Id: <1610463998-19791-1-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120083
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While testing live partition mobility, we have observed occasional
crashes of the Linux partition. What we've seen is that during
the live migration, for specific configurations with large amounts
of memory, slow network links, and workloads that are changing
memory a lot, the partition can end up being suspended for 30 seconds
or longer. This resulted in the following scenario:

CPU 0                          CPU 1
-------------------------------  ----------------------------------
scsi_queue_rq                    migration_store
 -> blk_mq_start_request          -> rtas_ibm_suspend_me
  -> blk_add_timer                 -> on_each_cpu(rtas_percpu_suspend_me
              _______________________________________V
             |
             V
    -> IPI from CPU 1
     -> rtas_percpu_suspend_me
                                     -> __rtas_suspend_last_cpu

-- Linux partition suspended for > 30 seconds --
                                      -> for_each_online_cpu(cpu)
                                           plpar_hcall_norets(H_PROD
 -> scsi_dispatch_cmd
                                      -> scsi_times_out
                                       -> scsi_abort_command
                                        -> queue_delayed_work
  -> ibmvfc_queuecommand_lck
   -> ibmvfc_send_event
    -> ibmvfc_send_crq
     - returns H_CLOSED
   <- returns SCSI_MLQUEUE_HOST_BUSY
-> __blk_mq_requeue_request

                                      -> scmd_eh_abort_handler
                                       -> scsi_try_to_abort_cmd
                                         - returns SUCCESS
                                       -> scsi_queue_insert

Normally, the SCMD_STATE_COMPLETE bit would protect against the
command completion and the timeout, but that doesn't work here,
since we don't check that at all in the SCSI_MLQUEUE_HOST_BUSY
path.

In this case we end up calling scsi_queue_insert on a request
that has already been queued, or possibly even freed, and
we crash.

The patch below simply increases the default I/O timeout to avoid
this race condition. This is also the timeout value that nearly
all IBM SAN storage recommends setting as the default value.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 42e4d35..79badaa 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3007,8 +3007,10 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (sdev->type == TYPE_DISK)
+	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
+		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return 0;
 }
-- 
1.8.3.1

