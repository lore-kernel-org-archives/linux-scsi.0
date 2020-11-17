Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E35DC388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2831520643
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PQZ6z6cO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKQDkj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:40:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:40:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3e7DP137431;
        Tue, 17 Nov 2020 03:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=8ZstDP7D2WsvuoeBmp7WXVlFicnWnp6/KwgjpoKFzow=;
 b=PQZ6z6cObqoPZKwUS6QbXqaAriP+bHdET5KjIAQN4td6enqxC7TXjsvX9NRVoig35t8y
 OGWUbi5wVAX0be8ON4BvAJ3yt3XxGz07Yk8HMY8bHxuQhMZRSEfy4KkV8iwuDCNx4hqG
 qIxJDpBAe5sA2DS0+J8Tsq3pldjBlhgevRpt4flhHVRT+5f1/9f41YcqAmmfjMdoCl23
 mxpNnWIqy84yjP3WvaeCEC50swaPwH/R2QGodJBKgQwlkf96ID+Wxb0hXK5rDb6E/1Eo
 YH6lWmcJpNGLiSQWCDiyDPj7xOvP0KIq47Q4UtpPayfi7igAf9MwPW5mErCZjsm3ztD2 KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76krcw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:40:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3eUgK103737;
        Tue, 17 Nov 2020 03:40:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34ts5vh7hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:40:31 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH3eSxu027180;
        Tue, 17 Nov 2020 03:40:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:40:28 -0800
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Leo Liou <leoliou@google.com>
Subject: Re: [PATCH] scsi: ufs: show lba and length for unmap commands
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1os648z.fsf@ca-mkp.ca.oracle.com>
References: <20201112165950.518952-1-jaegeuk@kernel.org>
Date:   Mon, 16 Nov 2020 22:40:26 -0500
In-Reply-To: <20201112165950.518952-1-jaegeuk@kernel.org> (Jaegeuk Kim's
        message of "Thu, 12 Nov 2020 08:59:50 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Jaegeuk!

> From: Leo Liou <leoliou@google.com>
>
> We have lba and length for unmap commands.
>
> Signed-off-by: Leo Liou <leoliou@google.com>

Doesn't apply to 5.11/scsi-queue.

Also needs a Signed-off-by: tag from you.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
