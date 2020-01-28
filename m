Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBC6C33CB7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 03:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6201724656
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 03:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sQNWsJ+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA1DUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:20:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36158 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1DUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 22:20:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3D7xW166417;
        Tue, 28 Jan 2020 03:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=NGwTCjUj/jozdaP1xR6tdGJJbqCxCsMQT75zlqPA0JA=;
 b=sQNWsJ+TtQYEqGlqwmQDKIBuhsZHlxcnCzwu59eOaMGbrb71pKFzCRdxR8/n5L0YlDZO
 qjbqUkkdJ4LJCNeFHFs5xtdqECxQ1Vpwfc+Cb13RcofGhc5zA6Vyj17bXV8q9Ep1hm/u
 48wIE41vxtl/9DUefa7YRS2cR+Omk902C1V3UWBCBNMT08EnprqQJ1LNJC/weUolaMKW
 iW1go5pA/ftlcN/SnWnD0ixKKnOP7uq5a+AWSws0QmD+flbHrSr4Sc+NxLXzoureYgd2
 mNpnbUx6eghwM0lQjsNYagxXQsZSw4FE70GZIeJfmz4DrY8o1fYsLTKVzwi6CgOqHAjP Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xrear388m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:20:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3E4GO178941;
        Tue, 28 Jan 2020 03:20:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xry4vpauk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:20:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00S3KBu9029172;
        Tue, 28 Jan 2020 03:20:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 19:20:10 -0800
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Lee Duncan <leeman.duncan@gmail.com>,
        open-iscsi <open-iscsi@googlegroups.com>,
        Lee Duncan <lduncan@suse.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, Bharath Ravi <rbharath@google.com>,
        kernel@collabora.com, Michael Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Dave Clausen <dclausen@google.com>,
        Nick Black <nlb@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Anatol Pomazau <anatol@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Frank Mayhar <fmayhar@google.com>, Junho Ryu <jayr@google.com>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH RESEND v4] iscsi: Perform connection failure entirely in kernel space
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200125061925.191601-1-krisman@collabora.com>
        <F29720C3-86AC-407A-8255-9186E3AE0676@gmail.com>
        <8536c3ctu8.fsf@collabora.com>
Date:   Mon, 27 Jan 2020 22:20:07 -0500
In-Reply-To: <8536c3ctu8.fsf@collabora.com> (Gabriel Krisman Bertazi's message
        of "Sat, 25 Jan 2020 12:46:23 -0500")
Message-ID: <yq1h80gb72w.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gabriel,

> Thank you very much for the quick response!  I checked here again and
> I didn't get the previous email, but I see it made into the ML
> archive, so my apologies, it must be something bad on my (or my
> employer's) setup.

I didn't get it. Patchwork didn't either.

In any case: Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
