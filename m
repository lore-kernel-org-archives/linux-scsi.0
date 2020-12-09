Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D0FC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 02:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D943523715
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 02:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgLICrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 21:47:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36174 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgLICrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 21:47:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92jP1O005763;
        Wed, 9 Dec 2020 02:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=uVVZYatFC2fO6YB80YgckEZtVowLfXp1IQQBuIfl10s=;
 b=cz/Y1Gc1ThoHFN6xZRfHXnFWHFfVnfJ14pJnXk8l86ggosh6u0DLo0NBBbHRFxl/vZuX
 mhPubvtAxOAKKiBtpl2a2C4sb1wtFVXFD1grOuDetde6L5CkTjxs98eu5KZnhIoGDJbE
 BDrYKrk+ijl+sCTVsyPXLPahdAEN8d3ldHQbb+WYc7hYo0Axwuehh2jL2xVIPaIjdaoZ
 ojuxN6U/xqWG+xC/DQPeYUAiZzG9uAE9oXkG09Igdx86pwAg20X2w5HUlQ2AXz2wPt88
 UXELrcu2fyodGVNkfaqCoNOTncepwuSNqgyQ5STMxcfMCq8RUOoFpbNvSOgA3GM/azCq SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbx2js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 02:46:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92ifwB035887;
        Wed, 9 Dec 2020 02:46:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kytw38n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 02:46:25 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B92kN1F025988;
        Wed, 9 Dec 2020 02:46:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 18:46:23 -0800
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH 0/4] scsi: ufs-pci: Fixes for Intel controllers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8j3snm2.fsf@ca-mkp.ca.oracle.com>
References: <20201207083120.26732-1-adrian.hunter@intel.com>
Date:   Tue, 08 Dec 2020 21:46:20 -0500
In-Reply-To: <20201207083120.26732-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Mon, 7 Dec 2020 10:31:16 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Here are some small fixes / amendments.
>
> Adrian Hunter (4):
>       scsi: ufs-pci: Fix restore from S4 for Intel controllers
>       scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()
>       scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers
>       scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
