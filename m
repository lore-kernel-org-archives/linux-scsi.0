Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TO_MALFORMED,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079FAC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 23:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3AE23A21
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 23:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgLGXgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:36:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40982 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLGXgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 18:36:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7NTqMh094023;
        Mon, 7 Dec 2020 23:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=h6oj5MAGaXmvDRDIZly86J0Dc0Z4e2mULJAlAzoE1m0=;
 b=DBTsikTlc8kYYKkbw7p1nJZgRlTfChx+qcQzFU/h5crjMtAFxKeWdXbsVjWUFGJQQgAJ
 MUjlPR+Berpb2i0bAbqfT7ppkOxrCIwEIz7jeQHTuU6hrXyFSBhW5/k6Y2PBdxf3D5IZ
 FjcDLkX53Pg6pBGeGG4P6o7kKrhZ/zsFst1mTosjD98yf0dyKvJLBV4mFRYPLbQaYoQE
 3O6xChxKHtalTPaGvGeYwhw4QWcS6BKVWWWG1B5EekqhSgr1sHkduuFgVb2PxukdEI8Y
 pKqtZC14iNyIspIF1aAtnN5Mo3k9u8UOOtVH9d7CtEKBkuKAvBZdhdxq4a3w0LYNW6ky Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqr3y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 23:35:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7NUSdu050029;
        Mon, 7 Dec 2020 23:33:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 358m3wyxw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 23:33:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7NXV2Z026256;
        Mon, 7 Dec 2020 23:33:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 15:33:31 -0800
To:     Jintae Jang <jt77.jang@samsung>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jt77.jang@samsung.com
Subject: Re: [PATCH] scsi: ufs: Adjust ufshcd_hold() during sending
 attribute requests
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ox19a6.fsf@ca-mkp.ca.oracle.com>
References: <CGME20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d@epcas1p2.samsung.com>
        <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
Date:   Mon, 07 Dec 2020 18:33:29 -0500
In-Reply-To: <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
        (Jintae Jang's message of "Thu, 3 Dec 2020 14:25:32 +0900")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=941
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=971
 clxscore=-1004 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070155
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jintae,

> Invalidation check of arguments should have been checked before
> ufshcd_hold(). It can help to prevent ufshcd_hold()/ ufshcd_release()
> from being invoked unnecessarily.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
