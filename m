Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DF2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54CE23AC9
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgLHWys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:54:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731025AbgLHWyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:54:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MnJuE167148;
        Tue, 8 Dec 2020 22:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=hAIubkLRTmjxI2uaTzm/opTnOUm9VcffeoFejA8gEzw=;
 b=Y4TP2qsJuoeEkKBeE7LjRoRkO/abjtUGLaXwS5/KVk2i6OK5cCEKJnAuoMeoqGPvU9Wx
 4lvcchXLKvIulhId2m2TduuVGOXFIH4tCxz5cAb7OrIgxuNYhB5bfCwS036lWEb3FIwo
 cXBmoZcb4YPtlvp6IRFfKb3u31ldXAGCIziDD4JbkF2+js1aWBZCsoXbhaE71FetyFfs
 jNlhAjJPMzuQ/u0SXiOB08pZXOGv1+3x+tfAoW/JrBa64n6t7fLo6B7581e1pRkGRmqc
 yx89NkKyGU7rThUbiu6bSoaLvb9Qkim94yM80Zse/4JWnh4mIglHYljggC+Br2Of2bYB 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m5du4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 22:53:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MofXq046047;
        Tue, 8 Dec 2020 22:53:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kytms2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 22:53:45 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B8Mrh9S016961;
        Tue, 8 Dec 2020 22:53:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 14:53:43 -0800
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Julia Lawall <julia.lawall@inria.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <yq1mtynud0n.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
        <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
        <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
        <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
        <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
        <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
        <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
        <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
Date:   Tue, 08 Dec 2020 17:53:41 -0500
In-Reply-To: <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk> (Jens Axboe's
        message of "Tue, 8 Dec 2020 15:47:00 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> Thanks for testing! Linus, do you just want to revert this, or do you
> want me to queue it up?

Oh, I just realized the megaraid patch went in through block.

-- 
Martin K. Petersen	Oracle Linux Engineering
