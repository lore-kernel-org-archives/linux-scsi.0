Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B152C433E2
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 12:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5817F2078D
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 12:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C+tfuZwF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgIEM7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 08:59:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEM7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 08:59:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 085CnCi4046008;
        Sat, 5 Sep 2020 12:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Vj60FdFGrdN1xqqhG4Jd+vM2EQRmJxPbV74Q494MvAE=;
 b=C+tfuZwFUeU+AxSoDuPD5WTgWEw61hSrN1BRwj/nim6HRv14Stocw9g/ea8qw7uWrkxA
 t9/c8hY5zGTFa+N3pNcC4u2YmRRMPdlDN7fnhwiACtXwwW5EmKFQdnPgSw4xWiD/292f
 /vczGtf1xTsT5NtwZKSiGf8lIIajRn+5mN2iucD9QvjbSzOBANJC7uWWnNi8jZMFahIw
 TG+xSjf4397ye1vQWn3juraFzJ4r1bmtk411sVsmwfnFKoAkeDeoZwt+pCY3uKKmoSFa
 Vu35sLC+LNpzvaezZruvZjc6/rvZDaNlWeUHwTB9x+kCyJ95kJP8I9Iu6ORFaFBhwRBJ Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33c23qh7mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 05 Sep 2020 12:58:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 085Cu7ki025610;
        Sat, 5 Sep 2020 12:58:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33bysqqsfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Sep 2020 12:58:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 085CwiWW003757;
        Sat, 5 Sep 2020 12:58:44 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Sep 2020 05:58:43 -0700
Date:   Sat, 5 Sep 2020 15:58:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: libsas: Fix error path in sas_notify_lldd_dev_found()
Message-ID: <20200905125836.GF183976@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009050123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In sas_notify_lldd_dev_found(), if we can't find a device, then it seems
like the wrong thing to mark the device as found and to increment the
reference count.  None of the callers ever drop the reference in that
situation.

Fixes: 735f7d2fedf5 ("[SCSI] libsas: fix domain_device leak")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/libsas/sas_discover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index cd7c7d269f6f..d0f9e90e3279 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -182,10 +182,11 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 		pr_warn("driver on host %s cannot handle device %016llx, error:%d\n",
 			dev_name(sas_ha->dev),
 			SAS_ADDR(dev->sas_addr), res);
+		return res;
 	}
 	set_bit(SAS_DEV_FOUND, &dev->state);
 	kref_get(&dev->kref);
-	return res;
+	return 0;
 }
 
 
-- 
2.28.0

