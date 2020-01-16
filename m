Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C35C33CB2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4871B24656
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XeFvjIGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgAPDBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 22:01:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgAPDBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 22:01:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G2s9po082540;
        Thu, 16 Jan 2020 03:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=pYqAmex2w8tiqRFaW1jCj7M1ge+Xb9hYqrytKH/JEAk=;
 b=XeFvjIGUPyf29kMh8ImLl2O8tLws5Dpngfve2rdjFNyrahC6qPrSwT8uP8DTIDrzVt9E
 TdfEszW+xlQMWpnA4ymFOwYi/XayCp6Hat9P6r23Kho90QjA7bDi/1mSgAHA1fhdCkaC
 Rf1Tyb0++XNvC7lNs4dG23GsJxSdm02oCP97k6gkturjqDOx8fBg/7r1rJb6btxniAOv
 zCrYvaR2Uon48gIymJ+oVr7HKhB0HjibEIOTdy1VlbLkr6sskl3VMoIKmmVm9fis0k3x
 Ylag6tlfcc/IdygHQrjwvL6sVhdNfLLL09vSeUrEZyRJ0QWm+QWptGdEYNTuXB3lE/wy fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yqvvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:00:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G2sbY5151689;
        Thu, 16 Jan 2020 03:00:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xj1asnarp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:00:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G30QFJ026830;
        Thu, 16 Jan 2020 03:00:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 19:00:26 -0800
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Subject: Re: [PATCH v1 0/3] scsi: ufs: fix error history and complete device reset history
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
Date:   Wed, 15 Jan 2020 22:00:22 -0500
In-Reply-To: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Sat, 4 Jan 2020 22:26:05 +0800")
Message-ID: <yq1ftggp0l5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> This series targets on UFS error history fixes and feature add-on,
>
> 1. Fix empty check logic while outputing error history.
> 2. Add device reset history events for vendor's implementations.
> 3. Remove dummy word in output format.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
