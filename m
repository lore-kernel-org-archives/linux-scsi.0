Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B08C4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 23:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 494F8207E0
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 23:26:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="khFTh82D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfIZX0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 19:26:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfIZX0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 19:26:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QNJus7133520;
        Thu, 26 Sep 2019 23:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=zMRcyjg9Ib9Y0L3wY0EgQLeSsYjfcQVSQOaWEYjiZn4=;
 b=khFTh82DpP6RnqRNe811iuGeeScu9iaP/yd4/ZD/yv+4+jhxgAdmcG8fZeFeHfqO2hsg
 SYecCkQMrvsm3yCZ2thLVG9pt2e43UZ128V/sgCKg9psH8IWgjEIvAVyDAG2cyhz+yht
 UvfO7UrZn009uzUk134wbl2ho8IAUlH+QHs/Xm/tL9N42ZV0bAdUWnCvPwuQ21ON36h/
 WODR/9ZpSscjr2mugbbImSHrfsjtc3lsKvNFkAAXO8JcjH0/2CAGCWJ13w+XFu7NA4yr
 Rn+dMryA3xDs5+ArHwYMVa0lpwQdk0SR95aq6RjevwZbj0iZVW/mozwLtKpjZuuVfb8k Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9u6u4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 23:26:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QNNgk8005649;
        Thu, 26 Sep 2019 23:26:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v91bu3m0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 23:26:21 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8QNQKxv028111;
        Thu, 26 Sep 2019 23:26:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 16:26:20 -0700
To:     Andrey Melnikov <temnota.am@gmail.com>
Cc:     Zhong Li <lizhongfs@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC,v2] scsi: scan: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
        <8A2392BA-EDD4-4F66-9F76-B43C8F6EA4FB@gmail.com>
        <CA+PODjpG7NLTH8wp9qw08ACj4=8sUusmkZv6X7QWHtdbNJ1S0Q@mail.gmail.com>
Date:   Thu, 26 Sep 2019 19:26:18 -0400
In-Reply-To: <CA+PODjpG7NLTH8wp9qw08ACj4=8sUusmkZv6X7QWHtdbNJ1S0Q@mail.gmail.com>
        (Andrey Melnikov's message of "Thu, 12 Sep 2019 15:37:20 +0300")
Message-ID: <yq1h84y1vxh.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=804
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=883 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260184
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Andrey,

>> > This patch break exposing individual RAID disks from adaptec raid
>> > controller. I need access to this disc's for S.M.A.R.T monitoring.
>
> adaptec report hidden luns with PQ=1, PDT=0 - now it skipped.

>> > Please find other way to workaround bugs in IBM/2145 controller.

Spent some time on this today and I'm in agreement with Zhong's
interpretation of the SCSI spec.

What puzzles me is that aacraid already supports the no_uld_attach
feature so I'm not sure why it also sets PQ=1 for physical devices?

We could either have a SCSI host flag to override the behavior or
consider masking PQ in the driver. Unfortunately, I don't have any
aacraid controllers I can test with in my test setup so I'd have to
synthesize a setup with scsi_debug.

-- 
Martin K. Petersen	Oracle Linux Engineering
