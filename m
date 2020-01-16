Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735F3C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB7E2084D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJBkhnue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgAPDYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 22:24:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAPDYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 22:24:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3DudA080521;
        Thu, 16 Jan 2020 03:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=QrxvPbffJUGUOyHbYVqA0XbXQBPLyN1MOfRE3ofpSqE=;
 b=YJBkhnuetFcADbYmdE9J+x0uM7uSbl//6PT2F6e0KpyTx1kTb6kTTgrzP8zHm8F+tp5L
 EOo48Ikj3bKoYdZcYptgABuv7EYKbeNDhg4C4fyDl2dcQC9avuySp436vxH0exWmuDLb
 pES/cURk+q8Tf0P28NIMZe+oYfxA2HMLyciEnEjDjDlavqwyYRr48fQ2VdNmXs4DgUR4
 eyuKEaJagrFpiqw3VOFlyMtAIUp4uTqy/O6eCZ0+qX06z7FxERUaF7ywjj/lt0SIyyQh
 pfpoeWnXyd2nhpy4MMDApmva/IlRYm4doL2/JZkmImYEPozukeLD2VslQsC3YvBj4Hxc 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73tyvj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:24:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3EZ5G106041;
        Thu, 16 Jan 2020 03:24:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xj61ktkmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:24:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G3OAK4024011;
        Thu, 16 Jan 2020 03:24:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 19:24:10 -0800
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
Subject: Re: [PATCH v3 0/2] scsi: ufs: pass device information to apply_dev_quirks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
Date:   Wed, 15 Jan 2020 22:24:06 -0500
In-Reply-To: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Sat, 11 Jan 2020 15:11:45 +0800")
Message-ID: <yq136cgozhl.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> Currently UFS driver has "global" device quirk scheme to allow driver
> applying special handling for certain UFS devive models.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
