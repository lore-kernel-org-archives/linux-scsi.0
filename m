Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7839C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 16:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC9D620E65
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 16:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbhACQwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 11:52:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12630 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhACQwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2021 11:52:50 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 103GVosu166020;
        Sun, 3 Jan 2021 11:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=rd017k6Pof1ZGuLaMQhs2YaGZrs3MPqmJDfcCVWDomU=;
 b=OoYa7IpY0QfZvLHTHTTpN+AxVU2bOPx3/Wv5pPuSuPjBXXmHvAmlnkSc3LodvdATymAX
 u3ahleTOtqigEWTkMPqsstPMkAqVR/2ahDFSGuAG0hhsTR713vDhMmAhrpan0Mb92Xiw
 3CDZJLko/OmkU2L1EfqsdC+hTTm5YZsgkp2EgPO1n2GXkOiJ10c0LUSLVF3tdRT6wgY2
 nyN8vjDvS1jrRryBHFonoq0D2mcgJ2QWCJD3b0BbKF7WtuthfkKNrHfv0ngfJscr04gx
 XGDeKZsmCQyNByMK1Olmm+o+i/IR/xL7z9v4qIHc6TfNp5MNDNXJVu0G5bav1TwHmdUD vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ug4y99a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 11:51:56 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 103GWVif167071;
        Sun, 3 Jan 2021 11:51:56 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ug4y99a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 11:51:56 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 103GoScS012378;
        Sun, 3 Jan 2021 16:51:55 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 35tgf8guyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 16:51:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 103GpsUv26280296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 Jan 2021 16:51:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 806ED7805C;
        Sun,  3 Jan 2021 16:51:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09FA07805E;
        Sun,  3 Jan 2021 16:51:51 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.172.80])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  3 Jan 2021 16:51:51 +0000 (GMT)
Message-ID: <75ecb62269cf425164d0fb6f2717d1d0136f43cd.camel@linux.ibm.com>
Subject: Re: [PATCH] cxgb4: fix TLS dependencies again
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Arnd Bergmann <arnd@kernel.org>, Karen Xie <kxie@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Seewald <tseewald@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 03 Jan 2021 08:51:50 -0800
In-Reply-To: <20210103140132.3866665-1-arnd@kernel.org>
References: <20210103140132.3866665-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-03_07:2020-12-31,2021-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 clxscore=1011 mlxscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101030101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-01-03 at 15:01 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A previous patch tried to avoid a build failure, but missed one case
> that Kconfig warns about:
> 
> WARNING: unmet direct dependencies detected for CHELSIO_T4
>   Depends on [m]: NETDEVICES [=y] && ETHERNET [=y] &&
> NET_VENDOR_CHELSIO [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n) &&
> (TLS [=m] || TLS [=m]=n)
>   Selected by [y]:
>   - SCSI_CXGB4_ISCSI [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI
> [=y] && INET [=y] && (IPV6 [=y] || IPV6 [=y]=n) && ETHERNET [=y]
> x86_64-linux-ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in
> function `cxgb_select_queue':
> cxgb4_main.c:(.text+0xf5df): undefined reference to
> `tls_validate_xmit_skb'
> 
> When any of the dependencies of CHELSIO_T4 are not met, then
> SCSI_CXGB4_ISCSI must not 'select' it either.
> 
> Fix it by mirroring the network driver dependencies on the iscsi
> driver. A more invasive but also more reliable alternative would
> be to use 'depends on CHELSIO_T4' instead.
> 
> Fixes: 659fbdcf2f14 ("cxgb4: Fix build failure when CONFIG_TLS=m")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/cxgbi/cxgb4i/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig
> b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> index 8b0deece9758..2af88a55fbca 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
> +++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config SCSI_CXGB4_ISCSI
>  	tristate "Chelsio T4 iSCSI support"
> -	depends on PCI && INET && (IPV6 || IPV6=n)
> +	depends on PCI && INET && (IPV6 || IPV6=n) && (TLS || TLS=n)
>  	depends on THERMAL || !THERMAL
>  	depends on ETHERNET
>  	depends on TLS || TLS=n

I thought all separated depends statements were the equivalent of && in
a single statement.  If so, how does repeating TLS || TLS=n twice fix
the problem?  This sounds more like we have some sort of bug in our
Kconfig apparatus.

James


