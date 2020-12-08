Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303D4C19437
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D3823AC9
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgLHUai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:30:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgLHUad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:30:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8ItVTP193430;
        Tue, 8 Dec 2020 18:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7qzXZe0gMYZQ/xhFXJ1/oXcs7VbDKuFEC3Igf2zwT+E=;
 b=k1kZayqwsoOm1cXk/dUfWUcR9cm6x1JlMoXC4Zn6sl9h1LF4gm6RQL/MzZ7woIUv/cGO
 w6PYKyK5k8MCvUrfIbxGGin41bykvY3AAMQobARud8H+nPZ2tdNYrvUkZ60iBZUtXY/b
 8Y/fpSN6XH559/jY4b4OJawjR6mQiPuLaJ02cQFN9Cbe4Kc29HoBZ79dh/459eBen1yl
 FbKYTGv1hfsIx/YCN17VDmwUj+0WLSn/hXp25xbTmk7xAR6SlrALyGQpuw2VvXhAnURa
 Im1B+qt6FiY5cO4iN4/vvcJFv+9tRyGzwThwDQwJaP9Hxr/WVkIB6M9IIVaswIis7i0F 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mqvep4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 18:59:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8IsnfF150260;
        Tue, 8 Dec 2020 18:59:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksp082v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 18:59:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B8IxD5U019445;
        Tue, 8 Dec 2020 18:59:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 10:59:13 -0800
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: problem booting 5.10
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
        <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
Date:   Tue, 08 Dec 2020 13:59:11 -0500
In-Reply-To: <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
        (Linus Torvalds's message of "Tue, 8 Dec 2020 10:31:49 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=942 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=956
 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Linus,

> So I'm adding SCSI people to the cc, just in case they go "Hmm..".

Only change in this department was:

831e3405c2a3 scsi: core: Don't start concurrent async scan on same host

which went into -rc2. I can't think of anything in -rc1 which would
affect scanning.

I'll take a look this afternoon.

-- 
Martin K. Petersen	Oracle Linux Engineering
