Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C075C32751
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A2C2184E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BR78CQ8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389637AbfHHBhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:37:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389558AbfHHBhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:37:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781YKaj128456;
        Thu, 8 Aug 2019 01:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=7ZhkOH/5wLpZN4GHA14PNhbdaVQgds5N9ha5vVa7pNM=;
 b=BR78CQ8Lu5wTrEKzzsNOTKS9LepafkjSZnHh0XNpsX1rRX3k940wDuEQh1w/DCh/WM/Z
 Jo2YSknijofQ+oH1KcBEhWGq2JjwV4h9ooSJ8NEdYUClF3zgoKcRyt3rP6aKyYMbbrix
 I7r250m8hWISmvBShJNQ197L1DhWDHrZNm3qqgtbpZMQzPkl3SkxlejYY0TpyghbMKmH
 Dd+Uw0IMx4kiM3ZKQfIg4sSzfwXjGZBjc5HF5NCFqy65fFE82EdKhIIQ2fbhngf1Wtb3
 y9dOUfoweqCZj9U/pQk5Sod3Ezq47+5kQxiJlAZ45usjQ5vU7vLGF9mOtSprXjmUCaFB Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pyfsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:37:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781WpgQ110367;
        Thu, 8 Aug 2019 01:35:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u76689km3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:35:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x781Z802027625;
        Thu, 8 Aug 2019 01:35:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:35:07 -0700
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: sun3_scsi: Mark expected switch fall-throughs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190729143007.GA8067@embeddedor>
Date:   Wed, 07 Aug 2019 21:35:05 -0400
In-Reply-To: <20190729143007.GA8067@embeddedor> (Gustavo A. R. Silva's message
        of "Mon, 29 Jul 2019 09:30:07 -0500")
Message-ID: <yq1ef1we8xi.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=675
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=731 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190808013505.d190MkDxpjMqvEKKv53TPMOE-0vh7lF6WuWAOfx0lZU@z>


Gustavo,

> Mark switch cases where we are expecting to fall through.
>
> This patch fixes the following warnings:
>
> drivers/scsi/sun3_scsi.c: warning: this statement may fall through
> [-Wimplicit-fallthrough=]:  => 399:9, 403:9

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
