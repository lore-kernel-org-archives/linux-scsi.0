Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE57C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC3123A7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbgLHWwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:52:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgLHWwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:52:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MnJ4h167149;
        Tue, 8 Dec 2020 22:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3+QUZSt2q2jWmzvwsgmOVm1eKlyky2fgihAM4ea9S5I=;
 b=yBJMH4oZbyn/4+iPwjViFVp2Zl4jHs29sXx9X1EaGJn3ya6cN8MlCQbmXrABTdEpPz/3
 MFpg6gLFNe5LqG3zdoTIriY/LX50N57vjRmAUJivn0J2PnkpgDN1sgy/kUAD0zGn6HHP
 NCImuuwuiMGPaE14DJAq4mDpOJ4JBhmi+OYjjw98GOhcKuckG9z/KQ+noaCg/4ZfQhKx
 d6UsTKZlWtAM2IFt8xh0q405PJ3OGpDCoWa7wp+CWEPhjx7secUq0NYPSj4i6YGf4Haq
 OQVQVJ15kw6v2b3dUv8IsUTtWlbKLHgzEpsEffnh40n8Q/iobcmkKqZIYgr+Rnr6/l37 eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m5dm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 22:51:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MofZP046160;
        Tue, 8 Dec 2020 22:51:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kytmpc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 22:51:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B8MpAZq015951;
        Tue, 8 Dec 2020 22:51:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 14:51:10 -0800
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: problem booting 5.10
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg8fud7y.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
        <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
        <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
        <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
        <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
        <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
        <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
Date:   Tue, 08 Dec 2020 17:51:07 -0500
In-Reply-To: <alpine.DEB.2.22.394.2012082339470.16458@hadrien> (Julia Lawall's
        message of "Tue, 8 Dec 2020 23:40:44 +0100 (CET)")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=852 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=863 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Julia,

> This solves the problem.  Starting from 5.10-rc7 and doing this revert, I
> get a kernel that boots.

Thanks for testing!

I'll go ahead and revert 103fbf8e4020 in 5.10/scsi-fixes. We can revisit
this change in 5.11 when Ming's fixes are in place.

-- 
Martin K. Petersen	Oracle Linux Engineering
