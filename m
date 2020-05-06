Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA3CC47256
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 03:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF74C2082E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 03:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LRW3T0bv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgEFDZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 23:25:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46680 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgEFDZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2020 23:25:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0463JLEp137684;
        Wed, 6 May 2020 03:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3dzvCOrBHdmxYrucJrODcoh+LS2TSuy2nuN5tRQD+qM=;
 b=LRW3T0bvqwJ4arIjBEU72TnqcfvwIQIlyqfpFFUf8Y8QHImOt0EMSxYTwcvpUsdBGIuF
 cQa0kMC698Dp1eY4ohNAoYQI9mUxM1iY/X1sK4NKs5XLauSSSrx8UW+In2sqyBKseSBY
 BpJYFEv6oiJcKtDJwO2UK6o4pHYILOWCzgc1Ux6lj0FvxTuq0YAOy18d71rndNOy4JER
 rYrBfMs1jaaQCCQh98JZo8Ww+FU6yGFbWiCWAl+1XAvwc7VmOngLvePgwCaMu7SfuHkw
 UWAzWuguhLRebc8nUajHgDS2Gj/jBwvkSARufC+dxu2vdH0EVcVFAWaa9o4QG9s0n8W6 iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tmg1ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 03:25:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0463Gl0Y139450;
        Wed, 6 May 2020 03:23:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdueh75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 03:23:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0463NFlV022146;
        Wed, 6 May 2020 03:23:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 20:23:15 -0700
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v9 10/11] block: export bio_release_pages and
 bio_iov_iter_get_pages
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200428104605.8143-1-johannes.thumshirn@wdc.com>
        <20200428104605.8143-11-johannes.thumshirn@wdc.com>
Date:   Tue, 05 May 2020 23:23:13 -0400
In-Reply-To: <20200428104605.8143-11-johannes.thumshirn@wdc.com> (Johannes
        Thumshirn's message of "Tue, 28 Apr 2020 19:46:04 +0900")
Message-ID: <yq1r1vx9272.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=886 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=931 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Export bio_release_pages and bio_iov_iter_get_pages, so they can be
> used from modular code.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
