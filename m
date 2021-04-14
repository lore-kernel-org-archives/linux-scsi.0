Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9C7C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6186105A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhDNRKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:10:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27972 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233961AbhDNRIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:50 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH3FOn072290;
        Wed, 14 Apr 2021 13:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=5nDI0qeM5SlSq2HThYNZ0x0eEt1bUIF+PotuEgqicyA=;
 b=Th8dJxEEcKWpY8BpDrP2ejYgjQ3aAo5N02IsdIBA7rwNqqxe1pIAgPG6MvnjH0WkkpV1
 XdjGP7+g5+mMaKDyWhcl7M+D1zaTAUxXf2f0o4qjhGuX+3b247DDbXoSbEM54IJ2MfCs
 km/tUeV+QF0pBN+xjjcWHfH9XdjkumPb1BXhlzsmyFBAf9AeZiwafn+wlCl0K/gMitB6
 9l6Ml2mBKp/cw7Nl3n61nNIdt6m9vM8M1LIVXgrIa9NZXVc6PZvOuOPhRVtpBO3mVAGJ
 IIhkU9T9+vNUUj0BKBAGjF2krYs+jDhQ1K15aGH8mmG9qeQMk55sRVCQefia0XJ0GIZ9 rw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x46u8j4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:20 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH4MPs019328;
        Wed, 14 Apr 2021 17:08:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 37u3n89u5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH8DXN18285002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:08:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CE7A681F0;
        Wed, 14 Apr 2021 17:08:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EDC7681F6;
        Wed, 14 Apr 2021 17:08:06 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:06 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b31-EM; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 5/6] scsi: zfcp: move the position of put_device
Date:   Wed, 14 Apr 2021 19:08:03 +0200
Message-Id: <0a568c7733ba0f1dde28b0c663b90270d44dd540.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -Bs1JvDnJv30AJi62omzHOtk2aZZVyb7
X-Proofpoint-ORIG-GUID: -Bs1JvDnJv30AJi62omzHOtk2aZZVyb7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

Have the `put_device()` call after `device_unregister()` in both
`zfcp_unit_remove()` and `zfcp_sysfs_port_remove_store()` to make
it more natural, for put_device() ought to be the last time we
touch the object in both functions.

And add comments after put_device to make codes clearer.

Suggested-by: Steffen Maier <maier@linux.ibm.com>
Suggested-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 4 ++--
 drivers/s390/scsi/zfcp_unit.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index f76946dcbd59..544efd4c42f0 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -327,10 +327,10 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 	list_del(&port->list);
 	write_unlock_irq(&adapter->port_list_lock);
 
-	put_device(&port->dev);
-
 	zfcp_erp_port_shutdown(port, 0, "syprs_1");
 	device_unregister(&port->dev);
+
+	put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
  out:
 	zfcp_ccw_adapter_put(adapter);
 	return retval ? retval : (ssize_t) count;
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index e67bf7388cae..59333f0257a8 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -255,9 +255,9 @@ int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
 		scsi_device_put(sdev);
 	}
 
-	put_device(&unit->dev);
-
 	device_unregister(&unit->dev);
 
+	put_device(&unit->dev); /* undo _zfcp_unit_find() */
+
 	return 0;
 }
-- 
2.30.2

