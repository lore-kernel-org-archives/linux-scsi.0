Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAD5C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 03:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00C720EDD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 03:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vrOUJHag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIIDVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 23:21:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIIDVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 23:21:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08939wEN051320;
        Wed, 9 Sep 2020 03:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=jU4Hp4JZptYH1gBL0RkAqCo4MUfBCPydOwAsit9iLnE=;
 b=vrOUJHagXwIKf58O07Qs73RU0Loj0Z2gwcSXQMsGfQH3j1DXgOp2/Ep2JNeGmA3tGi6K
 lUTHKhuCSHBn9/psmqxKgMFJn/0GFVAesEPAg5lcZoKKw2ySTVo8lus7NKNVYJ7avT9s
 zaJJ8DVonlqFtB8Mdg83aTguQ6ppLA6cW/ffGyJ9rDRZfkk+fi6me+M2ECskUL7VbI6t
 yIZ1BAVv7dq0Cf+xjqWFg2MZ2GONhrggUDxFF4TcPXiJrhsK0Spjf0D0+fuD8MEHiATp
 +GIjvWNas+H8Xxk/h8adpBUbYC1AN4u54AhEE8VvkMEruxa2eLvKIP7PvC9P1FOk9eH2 kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amxyyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 03:21:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0893BSpR172033;
        Wed, 9 Sep 2020 03:19:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmes1fk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 03:19:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0893JDRQ001902;
        Wed, 9 Sep 2020 03:19:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 20:19:13 -0700
To:     Javed Hasan <jhasan@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/8] qedf: Misc fixes for the driver.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dt34p3i.fsf@ca-mkp.ca.oracle.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
Date:   Tue, 08 Sep 2020 23:19:11 -0400
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com> (Javed Hasan's message
        of "Mon, 7 Sep 2020 05:14:35 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=935 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=951 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Javed,

> This series has misc bug fixes and code enhancements.

Applied to the 5.10 SCSI staging tree. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
