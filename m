Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA24AE7D0B7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjIUWyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjIUWyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB8114
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:43 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMd05H002859;
        Thu, 21 Sep 2023 22:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PZrbk2uQRAPllTH/k48FiMyNZcBMqCXWiUYGpge7Bho=;
 b=aM5cxXJIJDB5tE0thLE7ISjw79zAYkY1GOThf7LS4yD0U+0A60WqTkE5lAEx+s6jawxJ
 BTlKBAa+90jEtsuDJQqNGYE9cBDFVzyXBr4XuqO0d+x176+4Etwa9oHI0PePDKjW+Ayj
 Iea2DKdXRM76Wld/uyX8C30olGt4YJFT3Jg42+KbGCDnDF1yBvf1r42vpxLe2YdA8eox
 K0qwp7Ultfgrq1q/AUHiee7MvpWgrEcFzuFgm/adaEJwHnP4iYKAbxSod1HnuEYX1n22
 UieKwWvuPuO4XIU8PUSBsc9VfjuCnUIMB4rfvqrXrRm63kkX+t1wXdBQyuOdut4jFO1g Sw== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8vx9jjfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:40 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLvLSl029366;
        Thu, 21 Sep 2023 22:54:39 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t8tsnm755-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:39 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMscQZ9110150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:38 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7999358051;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 458745805C;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:38 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 04/11] ibmvfc: fix erroneous use of rtas_busy_delay with hcall return code
Date:   Thu, 21 Sep 2023 17:54:28 -0500
Message-Id: <20230921225435.3537728-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230921225435.3537728-1-tyreld@linux.ibm.com>
References: <20230921225435.3537728-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xtttwX3hCUcLnKD0ylwJWsCvWmpfxgJe
X-Proofpoint-GUID: xtttwX3hCUcLnKD0ylwJWsCvWmpfxgJe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=996 impostorscore=0
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 0217a272fe13 ("scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ
during cleanup") wrongly changed the busy loop check to use
rtas_busy_delay() instead of H_BUSY and H_IS_LONG_BUSY(). The busy
return codes for RTAS and hypercalls are not the same.

Fix this issue by restoring the use of H_BUSY and H_IS_LONG_BUSY().

Fixes: 0217a272fe13 ("scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ  during cleanup")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 2bfeeb9ace01..30baa046ae5b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -22,7 +22,6 @@
 #include <linux/bsg-lib.h>
 #include <asm/firmware.h>
 #include <asm/irq.h>
-#include <asm/rtas.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -5952,7 +5951,7 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 irq_failed:
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rtas_busy_delay(rc));
+	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 reg_failed:
 	LEAVE;
 	return rc;
-- 
2.31.1

