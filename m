Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3FAC5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562832084C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EztTRunr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfKFFsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 00:48:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfKFFsx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 00:48:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA65htkD146321;
        Wed, 6 Nov 2019 05:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=1s/WOj1D/65zsf2ks9jwORllF6wIRnqXsJmRtiDBg1c=;
 b=EztTRunrq6F4WCBaegG73E+fulbC3InsIkBWNtpaWMg7edlMrIIYQua3T833qLIM+zox
 u5ZAhsDK31NncfYJ+pEsqVJ4pN9ib7aJwjRW7ABliKxuozxA7T+tm+grdXI8/k5cMl8Y
 yfgqME26uRAnrdZxEv5xNGgg+PxQv8jyvq5RXTJL1Fk7NX0JNj6XfHA39Ci/P89EPOZ4
 tCz1npYqmzIb/WK/JzYFdbuCCx8QRs0rpsQNTUdathRq8A1oNN5PXMLZ/LjDqf5zGZsX
 xJFCqzJW1iusQBnwEaAqb07sN0F9B3NmEErtZApaL21JDBljrdqrmHCD7dKLlVrCaYdj +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117u3c6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:48:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA65hvkA041395;
        Wed, 6 Nov 2019 05:46:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w333wmkx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:46:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA65kecJ000998;
        Wed, 6 Nov 2019 05:46:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 05:46:39 +0000
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, schmitz@debian.org,
        Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: scsi-lib.c: increase cmd_size by sizeof(struct scatterlist)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1572656814.git.fthain@telegraphics.com.au>
        <1572922150-4358-1-git-send-email-schmitzmic@gmail.com>
Date:   Wed, 06 Nov 2019 00:46:37 -0500
In-Reply-To: <1572922150-4358-1-git-send-email-schmitzmic@gmail.com> (Michael
        Schmitz's message of "Tue, 5 Nov 2019 15:49:10 +1300")
Message-ID: <yq1h83h1rr6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=800
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=903 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060059
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Michael,

> In scsi_mq_setup_tags(), cmd_size is calculated based on zero size
> for the scatter-gather list in case the low level driver uses SG_NONE
> in its host template.

Applied to 5.4/scsi-fixes. I picked your version since it is small.

I still intend to queue Finn's SG_NONE cleanups for 5.5. In a way these
are orthogonal.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
