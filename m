Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F42C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 15:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiGFP7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiGFP7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 11:59:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C564521810;
        Wed,  6 Jul 2022 08:59:50 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266FraYL007171;
        Wed, 6 Jul 2022 15:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=b5mSK2qdEaaIeywLwgD86cIPxSvtMuGUpZSjnRg92tw=;
 b=KI6qrbrm6BQKTZYBrqo9KpDCvieXSegb5JDQppJo0af0DTKG9BgSxv7kecnqtdR9EYPb
 xtb3m1Jj1rGBwfAaIoTCqpnieEKCGHt7vkCcjO9rMWDioJr3FMUbvJLtB9Q1nCpH8lLa
 r4AW0uQcpxL7W1ggDTsul9aFt1quHfKYXhqFOMKtvzxnQ/ASuqD/xVD/OnKg84HbOma7
 B/qtN1wZDUW5unSj3T4mLS8QirGtbNLCVVFIrQ9LxMxyAeEHoThkg8wBmwrmDRB+hBhZ
 IQ919GpfFt9nfySBy+6vQzB3GdQkHhp9Nt0i0ILA+UOZOZ+NM39DOYI3Xm2pscgaYkoI aQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h55gjvw77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:59:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 266FqSiD004816;
        Wed, 6 Jul 2022 15:59:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujshbn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:59:45 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 266FxfEo18022800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 15:59:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EF59A405B;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C3C7A4054;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.132])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1o97RE-005M3r-WA;
        Wed, 06 Jul 2022 17:59:41 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 1/2] scsi: zfcp: declare zfcp_sdev_attrs as static
Date:   Wed,  6 Jul 2022 17:59:39 +0200
Message-Id: <0791b9149ebfa39e6b8eab093113cd2527dbf3d3.1657122360.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657122360.git.bblock@linux.ibm.com>
References: <cover.1657122360.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Jz5-ulQeGG1SDvU8TMk8hx6YpgQdzpap
X-Proofpoint-GUID: Jz5-ulQeGG1SDvU8TMk8hx6YpgQdzpap
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207060062
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

These attributes are now only accessed through the
zfcp_sysfs_sdev_attr_group.

Fixes: d8d7cf3f7d07 ("scsi: zfcp: Switch to attribute groups")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index dbf3e50444e6..cb67fa80fb12 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -672,7 +672,7 @@ ZFCP_DEFINE_SCSI_ATTR(zfcp_in_recovery, "%d\n",
 ZFCP_DEFINE_SCSI_ATTR(zfcp_status, "0x%08x\n",
 		      atomic_read(&zfcp_sdev->status));
 
-struct attribute *zfcp_sdev_attrs[] = {
+static struct attribute *zfcp_sdev_attrs[] = {
 	&dev_attr_fcp_lun.attr,
 	&dev_attr_wwpn.attr,
 	&dev_attr_hba_id.attr,
-- 
2.36.1

