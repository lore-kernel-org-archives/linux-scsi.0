Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB34C17440
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 01:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9444D222CA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 01:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ixDJXdjz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKMBsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:48:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49028 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfKMBsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 20:48:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD1jUxi010736;
        Wed, 13 Nov 2019 01:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=3YrFERbsr0dX0JOQWz/1uKzLQS6DAn/XlnRevr39op0=;
 b=ixDJXdjzvKV7mWJdrgXv+tqaBIgjLvGjT2AuuY/uWMeuPyNBYXWZ0NpHLD+7UElXHYE6
 1j38dPKL0ge5dzPCaQHo+wYfjpIqtCy3RqnY1CYMce9Rkq62UVH/bPDxQC8xR+N9AT7K
 sGY9sbV9L51N8+beWW/PhAEVth3hS1hlcsJxHBVZ3eTgNgzY104nFFL1cFBT4A3yaiea
 5rAFN2iwMryr5TPo4cQsf8AKq35A9ACRzGuRrDPsFUiMAi2WxoS1NrQmzykAinymF1TX
 6sYX7BGSezWtnaTArDZOOpAWy39mGlij63npGDjXgxa+GnO4sdC1WlZBJs34Hcf2RYp3 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qrqu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 01:48:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD1cJue070559;
        Wed, 13 Nov 2019 01:46:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w7j046fan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 01:46:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD1k9Vu012008;
        Wed, 13 Nov 2019 01:46:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 17:46:09 -0800
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v2 8/9] scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
        <20191111023930.638129-9-damien.lemoal@wdc.com>
Date:   Tue, 12 Nov 2019 20:46:06 -0500
In-Reply-To: <20191111023930.638129-9-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Mon, 11 Nov 2019 11:39:29 +0900")
Message-ID: <yq1woc4r1k1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=932
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=998 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130010
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> There is no need to arbitrarily limit the size of a report zone to the
> number of zones defined by SD_ZBC_REPORT_MAX_ZONES. Rather, simply
> calculate the report buffer size needed for the requested number of
> zones without exceeding the device total number of zones. This buffer
> size limitation to the hardware maximum transfer size and page mapping
> capabilities is kept unchanged. Starting with this initial buffer size,
> the allocation is optimized by iterating over decreasing buffer size
> until the allocation succeeds (each iteration is allowed to fail fast
> using the __GFP_NORETRY flag). This ensures forward progress for zone
> reports and avoids failures of zones revalidation under memory pressure.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
