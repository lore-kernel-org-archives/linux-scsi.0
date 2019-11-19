Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBA7C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 03:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221C6222A4
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 03:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gxj9sbc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfKSDf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 22:35:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41604 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfKSDf1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 22:35:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ3Z3XQ028945;
        Tue, 19 Nov 2019 03:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Q4SlwOjqPqVKXdXYgzxqusnsqg/vT7ItiaDh+4Z8U5Q=;
 b=Gxj9sbc7dvMqDqf1cQPV41KI7zG7FB96Zgsh9rcsS7idKuC7/hTgLRK+iEqVylYiWMWJ
 nfeulmDqFrmHX3U6F3z4Jya4qfLYn+LlGH5ik64BzHUBf/fXPkK4N/Fl2rpqEupcBOzo
 or+pxMzR2V+5SRL0nkgjH7sIxUdmidJiJpYsKm6NF8iGH8pGvlbHzYRYu/vH1CMAEXSi
 Kf4t6jp5x0cxEt8QWiQkN5EJcq3tsiYsgaLLhEKSkeFSqVr1Own3GK5my+jBlzUDw186
 FkZq/InCTwJ1m5jng8fRcPMys1yX6jkm1iJCNu0Tj6FPqgW21IpuFYzGqFSHjfYH8N4o xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqc3v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 03:35:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ3TCPg087062;
        Tue, 19 Nov 2019 03:35:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wc09wn8s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 03:35:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJ3ZBI7026570;
        Tue, 19 Nov 2019 03:35:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 19:35:10 -0800
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCHv3 00/52] Revamp SCSI result values
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191104090151.129140-1-hare@suse.de>
        <5fa00739-0f30-56fa-426e-1847457cc1dd@suse.de>
Date:   Mon, 18 Nov 2019 22:35:08 -0500
In-Reply-To: <5fa00739-0f30-56fa-426e-1847457cc1dd@suse.de> (Hannes Reinecke's
        message of "Fri, 15 Nov 2019 08:42:19 +0100")
Message-ID: <yq18socles3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=908 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Hannes,

> Martin, ping?
>
> I've got another patchset queued for splitting off the 'result' field,
> which kinda depends on this one...

It's a pretty big and intrusive change. And even though we (somewhat
unexpectedly) got another week, I still think it's too risky for 5.5.

I plan on merging it first thing when the queue for 5.6 opens.

-- 
Martin K. Petersen	Oracle Linux Engineering
