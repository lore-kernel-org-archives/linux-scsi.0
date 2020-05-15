Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63913C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 08:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F96D206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 08:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hNoS6Mtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgEOIcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 04:32:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgEOIcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 04:32:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F8WaCV061056;
        Fri, 15 May 2020 08:32:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=qabFLrPBdCY3XzQ1h1tsRNJ4eGD+6UXRbZdhAcUiFI4=;
 b=hNoS6Mtp3jr5/HiRadwKCuRNDibTlfSTKmSX3zVlln2xorHymhFdluq4r4rM6o0ZegcE
 Qc3z5H4/waSb8c+rYF6OCknwMeGf289CEl6ca34tFt8PYfCVTtLs9sZgwL1XnvaWGZPb
 sjXMkN8ca8inddOsT0EuwTfyG6g9vT7Q686AKH9sh0fBrES2U+VCuXyB1FNBMBKZYpzA
 QJK/BKtuHYUiRSff1LxM0RxY/2IYKMtRDp+w2EYUC7vOsAaHf5WltXA6iBEmnRTbRKRc
 J6oa70PhEWIInzoBaee0cp9hoN0facjCK2NMtKNNSS6ARco2IPxKNMOJLNfx6ZVl8e3p KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3100yg986d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 08:32:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F8Sk8J123706;
        Fri, 15 May 2020 08:30:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3100yr3jp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 08:30:31 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F8UUCh002457;
        Fri, 15 May 2020 08:30:30 GMT
Received: from gms-target-03.osdevelopmeniad.oraclevcn.com (/100.100.242.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 01:30:30 -0700
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
To:     gulam.mohamed@oracle.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Correct-the-type-of-arg-to-scsi_host_lookup
Date:   Fri, 15 May 2020 08:30:16 +0000
Message-Id: <1589531416-3852-1-git-send-email-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150075
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The data type of the argument, hostnum, to function
scsi_host_lookup(unsigned short hostnum) is unsigned short but the
hostnum sent to this function from callers functions is uint32_t or
unsigned int. Correct the data type to unsigned int to avoid the
wrapping of the hostnum value after 65535. Also change the data type of
local variable hostnum of the function __scsi_host_match() to unsigned
int.

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
Reviewed-by: Joe Jin <joe.jin@oracle.com>
Reviewed-by: Fred Herard <fred.herard@oracle.com>
---
 drivers/scsi/hosts.c     | 4 ++--
 include/scsi/scsi_host.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7ec91c3a66ca..c5c1534eb6e7 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -510,7 +510,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 static int __scsi_host_match(struct device *dev, const void *data)
 {
 	struct Scsi_Host *p;
-	const unsigned short *hostnum = data;
+	const unsigned int *hostnum = data;
 
 	p = class_to_shost(dev);
 	return p->host_no == *hostnum;
@@ -527,7 +527,7 @@ static int __scsi_host_match(struct device *dev, const void *data)
  *	that scsi_host_get() took. The put_device() below dropped
  *	the reference from class_find_device().
  **/
-struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
+struct Scsi_Host *scsi_host_lookup(unsigned int hostnum)
 {
 	struct device *cdev;
 	struct Scsi_Host *shost = NULL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 822e8cda8d9b..59742fb6fcd7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -731,7 +731,7 @@ extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern int scsi_host_busy(struct Scsi_Host *shost);
 extern void scsi_host_put(struct Scsi_Host *t);
-extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+extern struct Scsi_Host *scsi_host_lookup(unsigned int);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_host_complete_all_commands(struct Scsi_Host *shost,
 					    int status);
-- 
1.8.3.1

