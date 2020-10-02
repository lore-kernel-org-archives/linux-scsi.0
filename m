Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABE0C35257
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 23:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7972074B
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 23:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iGDW9y7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJBXN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 19:13:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 19:13:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092NDoeK196434;
        Fri, 2 Oct 2020 23:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3lpI1woH0cv0a5jLvlB18IMe4gj/GlxhtKbQwyvPpUE=;
 b=iGDW9y7mKjHw/KJONAqn3CeoiAcv2Jz6CfTnvu6OmESo6vqJt0HgV/HL9ZfrYNJ0ZrPC
 n13YsgJuIaCU2tdEH8oyLBXIaZru+fXG95VsJsTLVRy5xT+p6aipdyYcPcqOzaOdezp1
 DdpSh/2nhMmAhzqsx3JRd4UF8w0XvxXHmIyg74VJ8HzcrzLw2zLTtr9C6XiXtySQCmbp
 1La/EJj+86qAlp3j4TYwQku9np+inh0V8QcMKj8DdahY/yPuhfRMk76GhB3a7tSubsW+
 x2drwR9UYYT2AnFBAZuXDuqkerYSMiW+H89j7J6VV6Tl7AEFt99ed55ZeLDHC1m1mCo9 eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkmda8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 23:13:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092NAvB9090863;
        Fri, 2 Oct 2020 23:13:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdy9tbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 23:13:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092NDkCE027170;
        Fri, 2 Oct 2020 23:13:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 16:13:46 -0700
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com
Subject: Re: [PATCH v2] scsi: ufs: fix missing brace warning for old compilers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0w8dxwh.fsf@ca-mkp.ca.oracle.com>
References: <20201002063538.1250-1-shipujin.t@gmail.com>
Date:   Fri, 02 Oct 2020 19:13:42 -0400
In-Reply-To: <20201002063538.1250-1-shipujin.t@gmail.com> (Pujin Shi's message
        of "Fri, 2 Oct 2020 14:35:38 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020178
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Pujin,

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

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
