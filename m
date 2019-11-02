Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE90CA9ED1
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3606A21897
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S8Vj9IUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfKBAmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:42:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41584 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKBAmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 20:42:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA20dTF3004856;
        Sat, 2 Nov 2019 00:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=t3d7xeWdGyMMWUSqoY0kLd/hJVMSXOD6Uv9p01WX4iI=;
 b=S8Vj9IUI4I9+CsKPuldTRe5YJIddBMrpCoO7+B3OUYqeQor9mfmbCoLnngEV8W4roQrJ
 F2J+v9WB9ao99v16gIwl8lbp9uyM6CLSAerqtKIN+63SosYuwghSro6sIGUBX8AOHdiu
 aNjR2dluJ1E5K9MTz6LSTTZic8Qraxax3HxjUEXmkc3Ldw5CHHYm64eE3Ttp4+6JWOgx
 rkBGD23B3Q3soiq8LOANbu1jRyArKfe4+yySuIABR0qOqb7PVtKUO1+QvoSgw6SmuZsb
 b3w1AY1zwoNEfBIvECkWzeCOn5IrZHxenoeybQN4WGUqHu5F3rLIKtY/aB6GIEeh+l7N Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhg4hyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:42:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA20biEM186416;
        Sat, 2 Nov 2019 00:42:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w0rusg813-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:42:25 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA20gNBC029418;
        Sat, 2 Nov 2019 00:42:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 17:42:23 -0700
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
Subject: Re: [PATCH 3/8] scsi: sd_zbc: Fix sd_zbc_complete()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
        <20191027140549.26272-4-damien.lemoal@wdc.com>
Date:   Fri, 01 Nov 2019 20:42:19 -0400
In-Reply-To: <20191027140549.26272-4-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Sun, 27 Oct 2019 23:05:44 +0900")
Message-ID: <yq1k18j5ct0.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911020001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=995 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911020001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The ILLEGAL REQUEST/INVALID FIELD IN CDB error generated by an attempt
> to reset a conventional zone does not apply to the reset write pointer
> command with the ALL bit set, that is, to REQ_OP_ZONE_RESET_ALL
> requests. Fix sd_zbc_complete() to be quiet only in the case of
> REQ_OP_ZONE_RESET, excluding REQ_OP_ZONE_RESET_ALL.
>
> Since REQ_OP_ZONE_RESET is the only request handled by
> sd_zbc_complete(), also simplify the code using a simple if statement.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
