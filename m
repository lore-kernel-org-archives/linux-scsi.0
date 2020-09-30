Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77213C2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290162076D
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W9iYzWAS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgI3DeD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 23:34:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgI3DeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 23:34:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3Q7PY125054;
        Wed, 30 Sep 2020 03:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4cVhTdG3zorw6QjJt5z3I67vupn2zO/nb+w7JYhBzXg=;
 b=W9iYzWASkWTjuYAZ0aZjawAkk3jXhgNFNV/yeB5Sd8spCOV+L9F965LkMGtUqkoFPZeG
 J+BLuk0DvUl5Cz3CbhFVwqncjGZx2El2N4pER+Z3L0UNjXXoyVMFLNZV4cB4TY+WDbvT
 8Q8sYtqW8dJ3y42WNED62SnZ6T+TU6pgxcJedTEN9czQZjsTYqXODxQuEPgqMieXlAzb
 aFpNEIs1T32b9rLDg0xXwVw30Ch+ol5hrqWy7/cm8XQbfAfghV/9UsdKauA4rUWDdgfN
 PGTZl7EhY3l7iR7RodpwmP53/czyjL02UUV12lwz3ten7Af71+5htDjZxAq4LUs1B6K1 tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9n675k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:34:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3QV7C064809;
        Wed, 30 Sep 2020 03:34:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhygkg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:34:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08U3XxQQ030091;
        Wed, 30 Sep 2020 03:33:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:33:59 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        michael.christie@oracle.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        ssudhakarp@gmail.com
Subject: Re: [PATCH] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
Date:   Tue, 29 Sep 2020 23:33:58 -0400
Message-Id: <160143682620.27626.3126650527213630749.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=908 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=934 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Sep 2020 23:54:31 +0000, Sudhakar Panneerselvam wrote:

> transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
> for the lookup. Hence, update this field directly for the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG case.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case
      https://git.kernel.org/mkp/scsi/c/149415586243

-- 
Martin K. Petersen	Oracle Linux Engineering
