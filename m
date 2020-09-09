Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F83C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE32F20936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xhy3Sus3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgIICR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:17:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgIICRt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:17:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892EQ6C169764;
        Wed, 9 Sep 2020 02:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4gZNegwhoNBDQ8GhZYl9HUGOEPK0jYXU8Y5M0/Wa52E=;
 b=xhy3Sus3CQwlpqZWw4+Fkcf8/Q+kccPhUUWU1VkpXfu0eNFrN2vUVFIgadRKxMA126bv
 XO7bR5M4zkYKo/o4x3APy4O5amlmHyKUOTSLVgyJOaUQjgtF3/Tle6TrRDbxFkL6q7cF
 HfefRyAUSQSefKgp2yLZfmBPvbDEJTxT/VFXhDpjClNf0UZpv6x4YKjyYjqgHgCnATlt
 kfxZ9S4236DE7YIIeW542ao9JyDIJ7q8xqyWYZIjq7q5srliib/UMKTLHwLt/xqlyHl1
 2zo7Zq0OyqI3cgLm0Z8ZL+QH43UkCdBUC7ajwYwDfbhQJM/pxjTqC28CF/lkBv1xLsQu 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amxuan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:17:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FRoX026658;
        Wed, 9 Sep 2020 02:17:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmerxmkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:41 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0892Hcb0015271;
        Wed, 9 Sep 2020 02:17:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        bvanassche@acm.org, hare@suse.de, jejb@linux.vnet.ibm.com
Subject: Re: [PATCH v2] scsi_debug: implement lun_format
Date:   Tue,  8 Sep 2020 22:17:24 -0400
Message-Id: <159961781205.6233.7458613570852747634.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200821042249.5097-1-dgilbert@interlog.com>
References: <20200821042249.5097-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 Aug 2020 00:22:49 -0400, Douglas Gilbert wrote:

> Implement 'flat space LUN addressing', which allows us to raise
> the max_lun limitation to 16384. The maximum number of LUNs
> prior to this patch was 256.
> 
> Changes since version 1 [20200529}
>   - rebase to Martin Petersen's 5.10/scsi-queue branch
>   - implement review comments from Bart Van Assche

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Implement lun_format
      https://git.kernel.org/mkp/scsi/c/ad0c7775e745

-- 
Martin K. Petersen	Oracle Linux Engineering
