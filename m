Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9538CC43611
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71CCA6105A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhDNRIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:08:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30291 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233037AbhDNRIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:35 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH3wQL152776;
        Wed, 14 Apr 2021 13:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=k43Zfe+NtYH223HGmDad5Wa4AQg5jyYwX5yqONuaGQM=;
 b=W7W1wHPYfitjFk9/O4VaYu1ZkQXKou4ESVu4+l/FZH9zKUSi+9vI0fzdVNzO2JWXcnyO
 kbnHO7zw09xShS6TFDKkT6rQU5IUzXAMLd26ApMiNuThBzxZlIX/Fwx4JDXkVeSSIcIu
 9isumbXMQh2g+pVvR4w6ibdZLQ/46bl0rcn1cLwioG++rCeud0xWeBIDQ2ELVlBI05aG
 LvtzWebizIZedDaZ86GOFbF6BATyUKzpLT5BoG/TBfh9WZMdChVsCzWiEWbe5GTcTZtG
 RNi4QXVmWE5kRiHFakvST5UoDA3mkY/dhIFR5NrOihhfbq5zMhVL3HBC09phQXUuRxpJ eA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37wvvydxeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH2YSk007942;
        Wed, 14 Apr 2021 17:08:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8ue3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH7gLE36766068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:07:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD865A51EA;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1CCDA51E5;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b2v-Bq; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 3/6] zfcp: fix sysfs roll-back on error in zfcp_adapter_enqueue()
Date:   Wed, 14 Apr 2021 19:08:01 +0200
Message-Id: <790922cc3af075795fff9a4b787e6bda19bdb3be.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rOFDfkKz4iNcefC03gruVXFDah_liHg1
X-Proofpoint-ORIG-GUID: rOFDfkKz4iNcefC03gruVXFDah_liHg1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

When zfcp_adapter_enqueue() fails to create the zfcp_sysfs_adapter_attrs
group, it calls zfcp_adapter_unregister() to tear down the adapter state
again. This then unconditionally attempts to remove the
zfcp_sysfs_adapter_attrs group, resulting in a "group not found" WARN
from sysfs code.

Avoid this by copying most of zfcp_adapter_unregister() into the error
path, allowing for more fine-granular roll-back. Then skip the sysfs
tear-down steps if we haven't progressed this far in the initialization.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 768873dd55b8..abad77694e72 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -418,7 +418,7 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 		goto failed;
 
 	if (zfcp_diag_sysfs_setup(adapter))
-		goto failed;
+		goto err_diag_sysfs;
 
 	/* report size limit per scatter-gather segment */
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
@@ -427,8 +427,24 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	return adapter;
 
+err_diag_sysfs:
+	sysfs_remove_group(&ccw_device->dev.kobj, &zfcp_sysfs_adapter_attrs);
 failed:
-	zfcp_adapter_unregister(adapter);
+	/* TODO: make this more fine-granular */
+	cancel_delayed_work_sync(&adapter->scan_work);
+	cancel_work_sync(&adapter->stat_work);
+	cancel_work_sync(&adapter->ns_up_work);
+	cancel_work_sync(&adapter->version_change_lost_work);
+	zfcp_destroy_adapter_work_queue(adapter);
+
+	zfcp_fc_wka_ports_force_offline(adapter->gs);
+	zfcp_scsi_adapter_unregister(adapter);
+
+	zfcp_erp_thread_kill(adapter);
+	zfcp_dbf_adapter_unregister(adapter);
+	zfcp_qdio_destroy(adapter->qdio);
+
+	zfcp_ccw_adapter_put(adapter); /* final put to release */
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
2.30.2

