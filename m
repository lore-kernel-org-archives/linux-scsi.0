Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA355C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 913C622A85
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aRq40Yrz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgFTDvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:51:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFTDva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:51:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3hGS9044000;
        Sat, 20 Jun 2020 03:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=N5U1WxM+JpgZfuqkIOoNIcBd1VwkSQEqb7cWqK8s+tY=;
 b=aRq40YrzNovRYbhSNGqvGNE/b9RC2VwMamxYgaYqWAs2VFhQKGq4VxidfbgIzYqEqE7/
 twGBpLLt6LWfOYOAHVIHTYzFvfuNqdkuIyZoe89eA3OobdAdpwpWCCpq7l+ixt6GxDHP
 UCsXKAeUwknSUbPhZNVfK7s9jViLJ0ZGIjrLLXgpTxh6miYTnY/oqf6oqda6DAsYzcX9
 3/AdJKxJP/dZhUn3GH56Uii1u8QGrJuBJwLP3LCXYL1YYLTv4mNnt7Os5sFAhuQG1n1W
 InHzTRZBIZEX2xzae7/ydsx9RRGWRw3TO512auaZMl7nSZPxkM84OCyj4+PDb0e4dBWO fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31s9vqr2vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:51:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3hSPV065100;
        Sat, 20 Jun 2020 03:51:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31sa8yjumw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:51:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3pChR020650;
        Sat, 20 Jun 2020 03:51:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:17:51 -0700
To:     Avri Altman <avri.altman@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v2 0/3] Inline Encryption support for UFS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
References: <20200618024736.97207-1-satyat@google.com>
Date:   Fri, 19 Jun 2020 23:17:49 -0400
In-Reply-To: <20200618024736.97207-1-satyat@google.com> (Satya Tangirala's
        message of "Thu, 18 Jun 2020 02:47:33 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=697 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 suspectscore=1 priorityscore=1501
 mlxlogscore=731 mlxscore=0 phishscore=0 cotscore=-2147483648 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> This patch series adds support for inline encryption to UFS using
> the inline encryption support in the block layer. It follows the JEDEC
> UFSHCI v2.1 specification, which defines inline encryption for UFS.

I'd appreciate it if you could review this series.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
