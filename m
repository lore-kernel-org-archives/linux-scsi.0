Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AB9C5DF63
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C642166E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RYbA5wmN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbfKFE3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:29:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbfKFE3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:29:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64TUcb067719;
        Wed, 6 Nov 2019 04:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=zourGBTajg+fKPY9DIL9f48yj/GWrRizjJDdFnz40Lo=;
 b=RYbA5wmNq1/vY4BpXH9zeHGcve+tuNe0DIo4L5K2hpPDaY50Ku+7OQ8lhPC66EJzZVy+
 u5Xw8dzHEA6Fkp2tWao20+iUx70Ml1whZnwZYza9Wf3nmeXq/5epfdBAkVcyqvZkvWKc
 6dIwshS8bt8XfznGDRP99opW+ZAk431ozt1M59JRy2ejTqkzZl6iWCeN24rarxn/7zQs
 80+olupYL+OijJgBytnhZA+DMnzGaiLqc79aNekCpRdq6PD77QXtbwIXj0nNE3zNCYiF
 21UFEkdkcXJSo/vcrOzDy/7kEND9mwSEIF9eTeRrbbQDPVah5ZdeAtW4v8Jb+9oKX3fS PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12erawaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:29:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64Sutr190816;
        Wed, 6 Nov 2019 04:29:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w2wcnm6df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:29:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA64Tg47032263;
        Wed, 6 Nov 2019 04:29:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:29:42 -0800
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHES] drivers/scsi/sg.c uaccess cleanups/fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <CAHk-=wgWRQo0m7TUCK4T_J-3Vqte+p-FWzvT3CB1jJHgX-KctA@mail.gmail.com>
        <20191011001104.GJ26530@ZenIV.linux.org.uk>
        <CAHk-=wgg3jzkk-jObm1FLVYGS8JCTiKppEnA00_QX7Wsm5ieLQ@mail.gmail.com>
        <20191013181333.GK26530@ZenIV.linux.org.uk>
        <CAHk-=wgrWGyACBM8N8KP7Pu_2VopuzM4A12yQz6Eo=X2Jpwzcw@mail.gmail.com>
        <20191013191050.GL26530@ZenIV.linux.org.uk>
        <CAHk-=wjJNE9hOKuatqh6SFf4nd65LG4ZR3gQSgg+rjSpVxe89w@mail.gmail.com>
        <20191016202540.GQ26530@ZenIV.linux.org.uk>
        <20191017193659.GA18702@ZenIV.linux.org.uk>
        <yq1muda53er.fsf@oracle.com>
        <20191105052554.GT26530@ZenIV.linux.org.uk>
Date:   Tue, 05 Nov 2019 23:29:40 -0500
In-Reply-To: <20191105052554.GT26530@ZenIV.linux.org.uk> (Al Viro's message of
        "Tue, 5 Nov 2019 05:25:54 +0000")
Message-ID: <yq1ftj139vv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=666
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=748 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060046
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Al,

>> What's your plan for this series? Want me to queue it up for 5.5?
>
> I can put it into vfs.git into a never-rebased branch or you could put
> it into scsi tree - up to you...

Applied to 5.5/scsi-queue with Doug's Acked-by. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
