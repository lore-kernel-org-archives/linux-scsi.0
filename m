Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06CDC4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB5821481
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RZsWjsJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgJGDsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgJGDs1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973iwaF045291;
        Wed, 7 Oct 2020 03:48:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fmGA/xZPWTu4wOA8XI1fo1RoyuErS+srXeBAU0pTUpE=;
 b=RZsWjsJuWLD+Ghbvfwbu9SQskMX2hB3oYnFrmMOtFhREr4WnKknYTij+I1OGkESbqKzy
 K46CWkns9FtUq182COgeVMCaxG2lWU1m04UyWtM5mEbC6IgUU0qV1F+qTdQWI0GOd/56
 U3Sv7yG1gQsU4gywaXFPzra08qYRj5BhqRVrsNN4x0e8/cX/Nw1gxS1coXxOKLpCQlRF
 l7mmHhLqdYgthNrt2r3iQNU+IQw0txXvqJbRugCOIs2kNSsId9HJwdF+Av5fS6MY6RWg
 KC20L6XtGXtjDrZRktr0agCiLztYQ7T0V9Lbl7KI3VuWjh+DiaAp0+no1hRSitjWo1HD Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34mjy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973kALO160373;
        Wed, 7 Oct 2020 03:48:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y37xyvkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973mJtG025077;
        Wed, 7 Oct 2020 03:48:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bvanassche@acm.org, Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: Add limitless cmd retry support
Date:   Tue,  6 Oct 2020 23:47:58 -0400
Message-Id: <160204240574.16940.8154556654384956733.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1601566554-26752-2-git-send-email-michael.christie@oracle.com>
References: <1601566554-26752-1-git-send-email-michael.christie@oracle.com> <1601566554-26752-2-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Oct 2020 10:35:53 -0500, Mike Christie wrote:

> The next patch allows users to configure disk scsi cmd retries from
> -1 up to a ULD specific value where -1 means infinite retries.
> 
> This patch adds infinite retry support to scsi-ml by just combining
> common checks for retries into some helper functions, and then
> checking for the -1/SCSI_CMD_RETRIES_NO_LIMIT.

Applied to 5.10/scsi-queue, thanks!

[1/2] scsi: core: Add limitless cmd retry support
      https://git.kernel.org/mkp/scsi/c/2a242d59d6b9
[2/2] scsi: sd: Allow user to configure command retries
      https://git.kernel.org/mkp/scsi/c/0610959fbbca

-- 
Martin K. Petersen	Oracle Linux Engineering
