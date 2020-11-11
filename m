Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B27C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125A221741
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKV6PNYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgKKENV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 23:13:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgKKENU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 23:13:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB49Qgb187059;
        Wed, 11 Nov 2020 04:12:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=GXywq9HLAQiBosLvOQf2KY95yYBv7vb8SnQzxwOZPww=;
 b=MKV6PNYtI1LkB9cs15AkR4FXKxMo7gDRqf926JJ4LSHXTr5XRTM4HtXpt1pdKLTXI9lL
 JKzEvnHtiM+gGuXDZ+Pft/27vIA+n4j+sBhuLLFEmAIfM7/VPhDKMlNe/fshrMi5HQbo
 ixugH2OMIuly5nxTN5YoFaYB4OEN3nqeh/F/wIbg1PAbEmXZ2nu9hxmLgPNLgj952pc1
 sAUD98Hh6IHUnK95ITzEGtuTp/CE0nb3/bn02EVLfou50NkZj8EAGJvRHhGsCZBg+m10
 nljOy6EkXyFl1WQZAyeZDTBzTFPkFxO+CTGfB+GRQw4wveFabocDAfR/sQP+gDaI9zt1 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72en8rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 04:12:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB40tJ6113461;
        Wed, 11 Nov 2020 04:10:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g173ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 04:10:21 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB4AI24022627;
        Wed, 11 Nov 2020 04:10:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 20:10:18 -0800
To:     xiakaixu1987@gmail.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] scsi: bnx2fc: fix comparison to bool warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z6cfs9w.fsf@ca-mkp.ca.oracle.com>
References: <1604767920-8361-1-git-send-email-kaixuxia@tencent.com>
Date:   Tue, 10 Nov 2020 23:10:16 -0500
In-Reply-To: <1604767920-8361-1-git-send-email-kaixuxia@tencent.com>
        (xiakaixu's message of "Sun, 8 Nov 2020 00:52:00 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=882 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=913 mlxscore=0
 malwarescore=0 suspectscore=3 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


xiakaixu1987@gmail.com,

> ./drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2089:5-23: WARNING: Comparison to bool
> ./drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2187:5-23: WARNING: Comparison to bool

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
