Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9952CC54E49
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 812EA20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgEHRXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727896AbgEHRXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:48 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H4F8f149939;
        Fri, 8 May 2020 13:23:45 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtw5umaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H4x37028623;
        Fri, 8 May 2020 17:23:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5wuk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HNeB98782162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:23:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D70E1A404D;
        Fri,  8 May 2020 17:23:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4696A4040;
        Fri,  8 May 2020 17:23:40 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 17:23:40 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6ip-002wrt-VD; Fri, 08 May 2020 19:23:39 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 7/8] zfcp: fence early sysfs interfaces for accesses of shost objects
Date:   Fri,  8 May 2020 19:23:34 +0200
Message-Id: <ef65366d309993ca91b6917727590ca7ca166c8f.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When setting an adapter online for the first time, we also create a
couple of entries for it in the sysfs device tree. This is also true
even if the adapter has not yet ever gone successfully through exchange
config and exchange port data.

When moving the scsi host object allocation and registration to after
the first exchange config and exchange port data, this make
the `port_rescan` attribute susceptible to invalid pointer-dereferences
of the shost field before the adapter is fully initialized.

When written to, it schedules a `scan_work` item that will in turn make
use of the associated fibre channel host object to check the topology
used for this FCP device.

Because scanning for remote ports can't be done successfully without
completing exchange config and exchange port data first, we can simply
fence `port_rescan`, and so prevent the illegal access.

As with cases where we can't get a reference to the adapter, we also
return -ENODEV here. Applications need to handle that errno today
already.

After a successful allocation of the scsi host object nothing changes in
the work flow.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 7ec30ded0169..8d9662e8b717 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -216,10 +216,22 @@ static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+	int retval = 0;
 
 	if (!adapter)
 		return -ENODEV;
 
+	/*
+	 * If `scsi_host` is missing, we can't schedule `scan_work`, as it
+	 * makes use of the corresponding fc_host object. But this state is
+	 * only possible if xconfig/xport data has never completed yet,
+	 * and we couldn't successfully scan for ports anyway.
+	 */
+	if (adapter->scsi_host == NULL) {
+		retval = -ENODEV;
+		goto out;
+	}
+
 	/*
 	 * Users wish is our command: immediately schedule and flush a
 	 * worker to conduct a synchronous port scan, that is, neither
@@ -227,9 +239,9 @@ static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
 	 */
 	queue_delayed_work(adapter->work_queue, &adapter->scan_work, 0);
 	flush_delayed_work(&adapter->scan_work);
+out:
 	zfcp_ccw_adapter_put(adapter);
-
-	return (ssize_t) count;
+	return retval ? retval : (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
 		     zfcp_sysfs_port_rescan_store);
-- 
2.17.1

