Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAA7C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4327F2071B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wou5EVI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgC0RuL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:50:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0RuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:50:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RHnEMe180416;
        Fri, 27 Mar 2020 17:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=0xKthIknca1Pah4jZh51Dfw//I07AtrP1166tmQeLpU=;
 b=Wou5EVI1yK3LYYNSVvNPPkgPJCc/EMCcvCTPhDK2UAUhr+ihzydXN8hzc6cvdQzWalWc
 MwOQPFdZ9Bb+EFu50yXAUj/cXSi3vWcCYI+FZzShz2tQwWSXEAYHh4BSvizf4+7rzCw7
 Pzy3tLdLx1FIVW6/TlXXuQDIjGtXoPEYEMrjXveK+zXZeggwVToGb2JDWm3ZVOk7Q608
 w4E/ZEVC1bsdp0zX/oOiQoaC9f5O1zkAMp+4TW/FViMxzwH4nlhWtcAmw69xQ3g3lQcR
 8HypyqWoWMtvGPL0+cpYh3ztXwyUlUWlmFh50qBULHYwMbDqEQYhY8vM2ffm8kJLvtxe QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 301m49gqp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 17:50:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RHo5ZH065319;
        Fri, 27 Mar 2020 17:50:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3006rap5nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 17:50:05 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02RHnuOn001779;
        Fri, 27 Mar 2020 17:49:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 10:49:55 -0700
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Subject: Re: [PATCH v3 0/5] scsi: target: XCOPY performance
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200327141954.955-1-ddiss@suse.de>
Date:   Fri, 27 Mar 2020 13:49:52 -0400
In-Reply-To: <20200327141954.955-1-ddiss@suse.de> (David Disseldorp's message
        of "Fri, 27 Mar 2020 15:19:49 +0100")
Message-ID: <yq11rpdbscf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270149
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

> These changes remove unnecessary heap allocations in the XCOPY
> READ/WRITE dispatch loop.
>
> Synthetic benchmarks on my laptop using the libiscsi iscsi-dd utility
> (--xcopy --max 1 --blocks 65535 src=dst) against a target backed by an
> 8G zram (DEBUG_KMEMLEAK=y) iblock backstore (avg across four runs) show:
> before: 5.30845G/s
> after:  5.99056G/s (approx. +12.8%)

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
