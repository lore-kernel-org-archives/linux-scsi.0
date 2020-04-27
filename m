Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16777C4CECD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF62A2078C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tc6Y/a2b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgD0UXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:23:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgD0UXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:23:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKMmkD011257;
        Mon, 27 Apr 2020 20:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/+pZx41XHArfsyFeEjJ5ld06Vs7Zx4r40s1zbN7hUrA=;
 b=tc6Y/a2b/6vXjx4G6YSPQdeK6PC894jzAMNsn9+d7fk7MiGUkH3Uffu6O3VpVZkumvEV
 +YA/78KIU5+T9VO5fnjrd5nUKrBP2gqMmMWA8Ak+8iCkJNiHl6NMrO1QRzozMzZJjrAU
 81U7IHwFKn+8Y6+RA0cs0MHHYvVzz3VADsT/kHb/1XsWgj7kCGVnNn98vT2wGw1BceS3
 eQ2XZ0D664EJXfQueFHAgzS0efh4Atho7duclpBNH2pM7we6BJTyFVzwsXug2th2H0XS
 RAnTrIUSVZjOJIcHVyHbJNcCi52yR8Pip4venk7rm1DpWiOIcdvaucSbrvOMN/i9qwle gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucfuw9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:23:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKC0GY078457;
        Mon, 27 Apr 2020 20:21:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30mxrr068c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLUVw006413;
        Mon, 27 Apr 2020 20:21:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:30 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     chaitra.basappa@broadcom.com, linux-kernel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        sreekanth.reddy@broadcom.com, linux-scsi@vger.kernel.org,
        Jason Yan <yanaijie@huawei.com>, sathya.prakash@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: mpt3sas: remove NULL check before freeing function
Date:   Mon, 27 Apr 2020 16:21:19 -0400
Message-Id: <158777063304.4076.2246391298173254384.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200418095850.34883-1-yanaijie@huawei.com>
References: <20200418095850.34883-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=794 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=850 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Apr 2020 17:58:50 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:4906:3-19: WARNING: NULL check
> before some freeing functions is not needed.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Remove NULL check before freeing function
      https://git.kernel.org/mkp/scsi/c/baf3fbf26cc0

-- 
Martin K. Petersen	Oracle Linux Engineering
