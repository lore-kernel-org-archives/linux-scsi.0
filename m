Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582D1C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF71246A5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rHI+0fKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgKQDeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:34:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48674 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDeU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:34:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3OCiV069379;
        Tue, 17 Nov 2020 03:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=H82J0ueyDaWBzhvDdYKhMwH3WryqxDEz4KhE3KN/5mw=;
 b=rHI+0fKLGfatv6Ba153OAbpu1pxCT736YSVRuG2I+bb1OQzMS6G2TslH011RS6Qi1KxG
 9PemXUjeHtlb8B8A7sNQI/KlDDYXnXZjD9mP+vMemLWE/a9rVIMZsucx3xk6WzVI97F/
 mZoIYXNBfEKRHtBEargWk5GU4bOkRHEfF8WxeQ/E90gYypS17j9AU5kKmEEg4IAUP6wx
 BrbeLj4+kFEqm3S4V0LX9W5Blsv1ahyhQgSIsiSfvPQgQH3jpdENQmYLDxB1MNOweY0o
 /wjUIJ/OA8MZEXY16bavcGJmt+PfCCgXn52gwudCBuN5xHddS4f3N30OIXxH6QMFfVdD Vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34t4rarghq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3PQEw087421;
        Tue, 17 Nov 2020 03:34:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0qahvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:34:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH3YBS8014723;
        Tue, 17 Nov 2020 03:34:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:34:10 -0800
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] scsi: core: fix -Wformat
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnyk64id.fsf@ca-mkp.ca.oracle.com>
References: <20201107081132.2629071-1-ndesaulniers@google.com>
Date:   Mon, 16 Nov 2020 22:34:08 -0500
In-Reply-To: <20201107081132.2629071-1-ndesaulniers@google.com> (Nick
        Desaulniers's message of "Sat, 7 Nov 2020 00:11:32 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nick,

> Clang is more aggressive about -Wformat warnings when the format flag
> specifies a type smaller than the parameter. Turns out, struct
> Scsi_Host's member can_queue is actually an int. Fixes:

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
