Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72510CA9EA0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 10:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4583F2184C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 10:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mSl+cMVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfJVKZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 06:25:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfJVKZT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Oct 2019 06:25:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MADOuK036193;
        Tue, 22 Oct 2019 10:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=uLCjLsoZs+or6hFhBZCz+RZJZNAnAAiAx/wXBjU68bo=;
 b=mSl+cMVqCfx57gymLMW5HYnrw4j+XPvG6RdEbT1hmJMh1z2gur2Mp1SaqbJuS8ASxvNF
 D2GaD9gzL+Dh5sYhXsRhbXg3KNKv/iomrKi4o++mKjK4tDlwg2t24jfEFfDwntIiCwqt
 bcaZfns9fp0E9os1Gavn2U/ST+FGUA7nvEHRkBLmKWM/Z97gba7o09ldIIqaV1X9MysY
 VBDaZQCJDMEr13OB/02s2f4yvEpT4eoWgGoh1VDANx915xg+Q5C+VAEpPq71NMCVl0K6
 IMAiDO3tySQzLSLwuVDXgo6A5RMBDbcjGJKWKXhu72ENwJUzFcQKFy1C7by7IW92mioN 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtdrpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 10:23:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MANHkx018269;
        Tue, 22 Oct 2019 10:23:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsx2qfwge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 10:23:34 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MANWZS029232;
        Tue, 22 Oct 2019 10:23:32 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 03:23:31 -0700
Date:   Tue, 22 Oct 2019 13:23:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bradley Grove <linuxdrivers@attotech.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [SCSI] esas2r: unlock on error in esas2r_nvram_read_direct()
Message-ID: <20191022102324.GA27540@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220093
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This error path is missing an unlock.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/esas2r/esas2r_flash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 7bd376d95ed5..b02ac389e6c6 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -1197,6 +1197,7 @@ bool esas2r_nvram_read_direct(struct esas2r_adapter *a)
 	if (!esas2r_read_flash_block(a, a->nvram, FLS_OFFSET_NVR,
 				     sizeof(struct esas2r_sas_nvram))) {
 		esas2r_hdebug("NVRAM read failed, using defaults");
+		up(&a->nvram_semaphore);
 		return false;
 	}
 
-- 
2.20.1

