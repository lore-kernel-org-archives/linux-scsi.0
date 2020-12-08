Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91896C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 23:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7B623A7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 23:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgLHXBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:01:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731346AbgLHXBE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 18:01:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MxYgQ174711;
        Tue, 8 Dec 2020 23:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=UKIpCLyq86FD/vEZULNoi77OT/RfJlrkZ8arCUSHerQ=;
 b=EHUGj4mG4pGYWdXdCGt7EcgDjmEIc6v4M54hAP5+N7iOr5kjklQxSL03ays/jnsp7euO
 g7YTsLWIm1q6gDqAhpkBa35/bRzAO3JtsugWMxm4ebWE6E2QmxZ3C4Ki4s1vkhLeu5ta
 ktMcZJoJWb6jyWXBdxg/wf4WlaWSKG1DQVr5s5RJqv2z44MR30FCgu81/iD1C6gPeIOz
 YwCZWFOqpPiXACvtL0ocRp/HkLMP/eyU9QSbMMw9PpBDDVblKzhyEvkY8tUwDshRXBaH
 QptdUUQBJf7r3D/MSJZeB8QXMadQm44fxNuRNDjAZ/ucUWexIADUMclDtzgxi7ASfSSE Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m5egj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 23:00:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8MogdU046201;
        Tue, 8 Dec 2020 23:00:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kytn090-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 23:00:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B8N05AG016439;
        Tue, 8 Dec 2020 23:00:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 15:00:05 -0800
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Julia Lawall <julia.lawall@inria.fr>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: problem booting 5.10
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ovucnq.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
        <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
        <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
        <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
        <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
        <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
        <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
        <ca63ada5-76a6-dae9-e759-838386831f83@kernel.dk>
        <yq1mtynud0n.fsf@ca-mkp.ca.oracle.com>
        <CAHk-=whCChtPRmGZqZM8XeCAFhfRzX8ts4RFKeXgGUyuNtWGMQ@mail.gmail.com>
Date:   Tue, 08 Dec 2020 18:00:02 -0500
In-Reply-To: <CAHk-=whCChtPRmGZqZM8XeCAFhfRzX8ts4RFKeXgGUyuNtWGMQ@mail.gmail.com>
        (Linus Torvalds's message of "Tue, 8 Dec 2020 14:56:24 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=865 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=855 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080144
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Linus,

> I'll take this as an "ack" for the revert, though ;)

Indeed!

-- 
Martin K. Petersen	Oracle Linux Engineering
