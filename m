Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D8AC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 02:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A7302467E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 02:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="poW5hJS+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLTC0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 21:26:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLTC0C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 21:26:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBK2ORHs014980;
        Fri, 20 Dec 2019 02:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=WSCbW5n/K+yFGCoIIv9tAuO/xX8+MPhvcwwEKLbt9vE=;
 b=poW5hJS+wECdnuMxfG11NUFx9St59HnR7ne0jkok0MlqTrA50wUfBKNWX6Uq9Qp61myQ
 Nm8b+7YZCAxgef8/sZpA4t831WR6DFl79bXSTVd7kmlIhemIVQbUEl4TrPz3P2l6r8iz
 n6coFJrbqJC2ZmtnvnOE4VzJVb8XRARhtVL3FI0WC+A7devGDFCA4Cdga6GTxbz/3VUX
 /EeIvgoHG3acPA+nFmmQbUVIMDpPx+w+w98DY6G/y22IGD/0rIQTdjr7gCUAZQAXDD/I
 ixvqhcvsXCeEPaze6LSfRasooS7ZlAL597543gNzly1ooxP41Ehb8U59lc9Fq+woBWbl eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x01jae86b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 02:25:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBK2OPH3021922;
        Fri, 20 Dec 2019 02:25:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x0bgmsq91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 02:25:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBK2PV96027350;
        Fri, 20 Dec 2019 02:25:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 18:25:31 -0800
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <andy.teng@mediatek.com>,
        <jejb@linux.ibm.com>, <chun-hung.wu@mediatek.com>,
        <kuohong.wang@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <avri.altman@wdc.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <alim.akhtar@samsung.com>,
        <matthias.bgg@gmail.com>, <pedrom.sousa@synopsys.com>,
        <linux-arm-kernel@lists.infradead.org>, <beanhuo@micron.com>
Subject: Re: [PATCH v1 0/4] scsi: ufs-mediatek: provide power management
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
        <yq1tv5vc3ci.fsf@oracle.com> <1576805118.13056.31.camel@mtkswgap22>
Date:   Thu, 19 Dec 2019 21:25:27 -0500
In-Reply-To: <1576805118.13056.31.camel@mtkswgap22> (Stanley Chu's message of
        "Fri, 20 Dec 2019 09:25:18 +0800")
Message-ID: <yq15zibag2w.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912200015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912200015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> Otherwise missing header "include/linux/soc/mediatek/mtk_sip_svc.h"
> will cause build error if MediaTek UFS driver is enabled.

Thanks for the heads-up. I obviously don't have an easy way to verify. I
did check after applying to see if there was a way I could trigger a
build of the driver on a non MediaTek platform. But that didn't appear
to be trivial.

-- 
Martin K. Petersen	Oracle Linux Engineering
