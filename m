Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5EFC46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6244B208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xcP7cfdK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgJGDso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbgJGDsi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ldQp168232;
        Wed, 7 Oct 2020 03:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NghnnTiQ04L/eDU1fIJD4zEfn8ioaRXq80X7lbFGSYE=;
 b=xcP7cfdKoc5T0+WpNrkZMbu9TIjSDhHnrjbe+cFU6M84OE2e1YfuVttYLHrkEhKItU8J
 8wg8gYitphW56Rc7YSc8vOlBo/dr70d8uj00/aD8E2uYWkcEWH+MI2N5+R0ETJPtBgVa
 RZ8l3cbi3p4Ig+YSqf5EwdZzYMmnXtkYgW3hZmXgievCstNEQSNboQ76aAeBppaNa5Sa
 LLZWZ99Yfbn9UZ6HK/8aocaj7rdasw+AWicXNoND78fYNxvrsGxbnvrgKRZ5dyN1uW9G
 HiJqyVLOqrllWZGj+FfNi/Zj0TpG2tgE7mytLo8ZaQdr6gnJ9W0BXoE4avBlrPLopxQ6 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmydcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ircW194801;
        Wed, 7 Oct 2020 03:48:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410jy2s77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:26 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mOL7012544;
        Wed, 7 Oct 2020 03:48:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:23 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Pujin Shi <shipujin.t@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: fix missing brace warning for old compilers
Date:   Tue,  6 Oct 2020 23:48:01 -0400
Message-Id: <160204240575.16940.8613402806893286457.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201002063538.1250-1-shipujin.t@gmail.com>
References: <20201002063538.1250-1-shipujin.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2 Oct 2020 14:35:38 +0800, Pujin Shi wrote:

> For older versions of gcc, the array = {0}; will cause warnings:
> 
> drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_crypto_keyslot_program':
> drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: missing braces around initializer [-Wmissing-braces]
>   union ufs_crypto_cfg_entry cfg = { 0 };
>         ^
> drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: (near initialization for 'cfg.reg_val') [-Wmissing-braces]
> drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_clear_keyslot':
> drivers/scsi/ufs/ufshcd-crypto.c:103:8: warning: missing braces around initializer [-Wmissing-braces]
>   union ufs_crypto_cfg_entry cfg = { 0 };
>         ^
> 2 warnings generated

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ufs: Fix missing brace warning for old compilers
      https://git.kernel.org/mkp/scsi/c/6500251e5906

-- 
Martin K. Petersen	Oracle Linux Engineering
