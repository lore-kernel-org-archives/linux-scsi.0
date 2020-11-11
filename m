Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1ADC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD71F20797
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 04:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="svDd6dU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgKKEEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 23:04:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35376 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgKKEEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 23:04:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB442P8090288;
        Wed, 11 Nov 2020 04:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=V5ePjViCRr23kx/T8WxrIkVMuE+GuaYuOU6AhJaCWqs=;
 b=svDd6dU7ZqMaPCMepfgK33jmAw1aA9xrxb7YtwFlABkXncMvms3qoTrbazZesOm0N0eM
 GnyQZ0N+kjlN8wIagNwXrl0yVOxXgXNC0SVzpha5XvzJzoDAqmjBBINfOTYPbHrfxDrP
 hmiCcKD5ivJfs3dB5mYctYmwNTAo6kN9cODsEfmPYpz/so+3j1finA33iAdph+fcyc+0
 159knvpM3/uOzeAtCPqKReIm62xJHKQLKL5Lzs8I+CMWFX4hXJcLheACAN9/Zda5hHUt
 xKE6lcWyvAGzKBuz/hNQ2yDgHRh+QuBV+nR9sievwOdSBHMVXwb/dfwCB8jL60MBjScb Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhky1qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 04:04:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB40tHL113439;
        Wed, 11 Nov 2020 04:04:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34p5g16ym2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 04:04:16 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB44F45025455;
        Wed, 11 Nov 2020 04:04:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 20:04:15 -0800
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Subject: Re: [PATCH v1 0/6] scsi: ufs: Add some proprietary features in
 MediaTek UFS platforms
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7pwfsju.fsf@ca-mkp.ca.oracle.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
Date:   Tue, 10 Nov 2020 23:04:12 -0500
In-Reply-To: <20201029115750.24391-1-stanley.chu@mediatek.com> (Stanley Chu's
        message of "Thu, 29 Oct 2020 19:57:44 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=968 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=982 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> This patch series provides some features and fixes in MediaTek UFS
> platforms,

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
