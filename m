Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214CACA9ECF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8DFB21897
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iTMsDpQR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfKBAnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:43:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48076 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfKBAnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 20:43:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA20dpdX018732;
        Sat, 2 Nov 2019 00:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=7/dPjeS6ahLzdiFUq6WPcXJrrLX3EVhCrIxKnT3GrlQ=;
 b=iTMsDpQRZNJCGFdGBl1H0E8Zf6+dQbV1YVbg/6qCIcpngFCSnABZ/PwnGPggLkBi/e2u
 uF7LX2p8ucJsQLJtbiTEYW7mdYo8xxxqoK7Tw6A0xJwauEJI+Gq+slmIqDIPk64wTxeP
 p1k2Mip7RRZnU024KAAta6YKyWEhqj2i11hMqVCZeWe42VgtIFsh4Hu004OKcupEg+7d
 tg29OAk+OnJiaeUH8lkxRfnzXpcH59zvYeSqHmM0sDCGoejc+zVSUj5k5txiofEsOxBH
 qd3inzcBcFlzMSPJMewI7YSWezOlgWF7AQT+fGG20XTh7Rgx/kYLR+3AIPqzzMi9/i96 sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vxwhfvn5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:43:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA20cOeW149071;
        Sat, 2 Nov 2019 00:43:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w0uth1q6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:43:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA20hbb4029549;
        Sat, 2 Nov 2019 00:43:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 17:43:37 -0700
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 6/8] scsi: sd_zbc: add zone open, close, and finish support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
        <20191027140549.26272-7-damien.lemoal@wdc.com>
Date:   Fri, 01 Nov 2019 20:43:33 -0400
In-Reply-To: <20191027140549.26272-7-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Sun, 27 Oct 2019 23:05:47 +0900")
Message-ID: <yq1ftj75cqy.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911020001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911020001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
> support to allow explicit control of zone states.
>
> Contains contributions from Matias Bjorling, Hans Holmberg,
> Keith Busch and Damien Le Moal.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
