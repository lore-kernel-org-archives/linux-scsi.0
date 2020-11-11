Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10794C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE0920797
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ij9hEpps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgKKEBJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 23:01:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgKKEBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 23:01:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3tH0i162285;
        Wed, 11 Nov 2020 04:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=FK9shu8RUlGxCAwUEewnYhWWXOc2jguPBEl+vnkRGSA=;
 b=ij9hEppsPctIsqiDCTmL/h2Ds0lw/xpybQR+CIenMnx+YpI0TR6z+TAb1PIVP2M5n0RL
 2I3O1i4GUslbtgRusNLFHMCoUvm8beKBv4URQVkacmy5DpFSL0ufwMc/ZeG3S5MQDjA4
 fzoBV5jY86O5tHS5lIXgaH8u0nZcvFANI3bzJgkMtwrI29Px8aRewuS7GJStgIKLr+r/
 HZLU2byB6IHaMGmTluXalgDqW7DQe0psJjb06zVuAQvGP0xrEbYVqrF+aSAKpD+cLR23
 Bzv7JN/cXmoH/XkDJkTAnMuRS/iH30BDG9aiogZ6qtfvfYPSJPJVBZ9iXRN2ipVvh7PB GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72en7yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 04:00:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3t5p7134879;
        Wed, 11 Nov 2020 03:58:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7r1eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 03:58:56 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB3wsCB023323;
        Wed, 11 Nov 2020 03:58:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 19:58:54 -0800
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] scsi: remove devices in ALUA transitioning status
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtzofssy.fsf@ca-mkp.ca.oracle.com>
References: <20200930080256.90964-1-hare@suse.de>
        <71160d6ae57867312c60ac5a14ef6df2ece21d84.camel@redhat.com>
Date:   Tue, 10 Nov 2020 22:58:52 -0500
In-Reply-To: <71160d6ae57867312c60ac5a14ef6df2ece21d84.camel@redhat.com> (Ewan
        D. Milne's message of "Fri, 06 Nov 2020 19:02:56 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=1 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan, Hannes,

>> during testing we found that there is an issue with dev_loss_tmo and
>> devices in ALUA transitioning state.  What happens is that I/O gets
>> requeued via BLK_STS_RESOURCE for these devices, so when dev_loss_tmo
>> triggers the SCSI core cannot flush the request list as I/O is simply
>> requeued.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
