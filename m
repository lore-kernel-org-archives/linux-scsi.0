Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393F3C4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F072620796
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZvjHO4N7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgJCBZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:25:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgJCBZU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 21:25:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931Ovah024776;
        Sat, 3 Oct 2020 01:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=HiDonggRQ8JlxsajXB85uBIozSr+fg3QMRuX4W0IOqw=;
 b=ZvjHO4N7iR/xgW5vZDciG+gffm9dUknsBnSogrggTuO+jqdIMHy1N9DhPpIlcFEr2a68
 YxNg0sOnqHe6PP2xmD5k2kRCLBxSXublXY/fQFv/auelhLE8UxXaAAO5sIGn2YudiLeP
 6atpt7NwEF7OvBSSh0bhWJd4/Swd1ysbMDYqe+3gMpcJ3fmVHJtHLbMIH1UUNL/ogJoP
 psi+ZCd1BUnRM6HMZCgJPnBuyaPKcDX9V70sfVsTM+AcMaWlD8s9VxIFv2abSmpBDEE9
 F1yMKiWTSiKrVwYNkRjxuLzo0Lg/B+P8MWYLuGxp3sIAvLBSwtlTc1iz2OTDuSiKhYUw uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkmdfxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 01:25:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931Jsni162137;
        Sat, 3 Oct 2020 01:23:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33xeds2et4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:23:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0931NB2B026108;
        Sat, 3 Oct 2020 01:23:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:23:11 -0700
To:     john.p.donnelly@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        bstroesser@ts.fujitsu.com
Subject: Re: [PATCH ] scsi: page warning: 'page' may be used uninitialized
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wo08cdco.fsf@ca-mkp.ca.oracle.com>
References: <20200924001920.43594-1-john.p.donnelly@oracle.com>
Date:   Fri, 02 Oct 2020 21:23:09 -0400
In-Reply-To: <20200924001920.43594-1-john.p.donnelly@oracle.com> (john
        p. donnelly's message of "Wed, 23 Sep 2020 17:19:20 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=893 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=3 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 mlxlogscore=907 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> corrects: drivers/target/target_core_user.c:688:6: warning: 'page' may be used
> uninitialized

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
