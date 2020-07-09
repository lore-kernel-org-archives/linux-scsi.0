Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0973FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 11:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2DA7206A1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 11:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HUH7g2mH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgGILAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 07:00:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgGILAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 07:00:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069Av27o059291;
        Thu, 9 Jul 2020 11:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=2/E24BwHYdBWkIVwfhn7rsbLeVqLPZ3duUM3HVy/GqA=;
 b=HUH7g2mH/MnRytNSHWwQ+QbtH6KVKQrgv+wUIrxg0SSYYBB5sS4bPJrxVy4WJfxn4tOf
 r7KB6vNy9zJuINmxaGeaW2Kq6S3HxKQbA47SDZX4DZd4t28AFPeaNcZ9QokNmqwK77oj
 raCjhomoc0Zbu+UfSWyMii0NpzNypgXswfDpXtDpdfPz2Vp6plwfymeSPMsIgNMyOfKv
 oTvfRHpzwvTvH9uXE4gANc9fL44mesQxI9fQBE4xNLYw6+fv0iX/R9XySJjNrJbF0LXd
 IOozQGKrEXz9mJmv8VLSEiF/yGCDryReeT4MMcmQSRO9shCPn3JkOLhaCWdh/RtD4fWp ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 325y0agy84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 11:00:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069AnFXm037415;
        Thu, 9 Jul 2020 10:58:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 325k3ggxea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 10:58:35 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069AwXKU018531;
        Thu, 9 Jul 2020 10:58:34 GMT
Received: from kadam (/105.59.63.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 03:58:33 -0700
Date:   Thu, 9 Jul 2020 13:58:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] scsi: lpfc: Fix a condition in lpfc_dmp_dbg()
Message-ID: <20200709105826.GH2571@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709105628.GG2571@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090087
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These variables are unsigned so the result of the subtraction is also
unsigned and thus can't be negative.  Change it to a comparison and
remove the subtraction.

Fixes: 372c187b8a70 ("scsi: lpfc: Add an internal trace log buffer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  I reverse the if statement in v1

 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7285b0114837..2bb2c96e7784 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14152,7 +14152,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 		if ((start_idx + dbg_cnt) > (DBG_LOG_SZ - 1)) {
 			temp_idx = (start_idx + dbg_cnt) % DBG_LOG_SZ;
 		} else {
-			if ((start_idx - dbg_cnt) < 0) {
+			if (start_idx < dbg_cnt) {
 				start_idx = DBG_LOG_SZ - (dbg_cnt - start_idx);
 				temp_idx = 0;
 			} else {
-- 
2.27.0
