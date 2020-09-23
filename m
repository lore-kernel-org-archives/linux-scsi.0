Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8D7C4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E322238D7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:39:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NmE5pRHJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgIWAjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:39:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgIWAi7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 20:38:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N0StEm100661;
        Wed, 23 Sep 2020 00:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Xey5ieFSyN8kbwbiKUIJyF1Q0BSSLa8Dkq0jcaaZFxY=;
 b=NmE5pRHJvYwdCW2JbFjO1Zyt8jHcCzv5khwfhfzPaqUeHz0fN4p4X415v5f4ZqTgS9DS
 xzNK25pcyRiOPhhsqZ+TTHsZ68isy+vhjLeJT3gKADCdKsbv+u9K8LhgzpckWexduVNi
 LvlheGG9eLhebbA9JxSimEop92glp9dz/X/Q/BpTqptRsa3vsKocweXy9JpBBfdiNgWt
 Rc7C1PyDrTrQkkTH8SS+3hd62uOHOazcjiqX1D4RBpB4zR1efXmhT/2Q0Yg5K1bEF5lE
 lR4ol8cCEja0wQi0KrHn0qd1fzvrffAAl83xlOTBqOkugcuspuAhYREMbBthIO5petZW vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnufs0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 00:38:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N0QDgT163738;
        Wed, 23 Sep 2020 00:38:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33nuw5c3d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 00:38:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08N0cOZW004102;
        Wed, 23 Sep 2020 00:38:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 17:38:24 -0700
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <chunfeng.yun@mediatek.com>, <yingjoe.chen@mediatek.com>,
        <kishon@ti.com>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <vivek.gautam@codeaurora.org>,
        <liwei213@huawei.com>, <linux-mediatek@lists.infradead.org>,
        <matthias.bgg@gmail.com>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <arvin.wang@mediatek.com>, <henryc.chen@mediatek.com>
Subject: Re: [PATCH v3 0/2] scsi: ufs-mediatek: Support performance mode for
 inline encryption engine
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq13639nx8z.fsf@ca-mkp.ca.oracle.com>
References: <20200914050052.3974-1-stanley.chu@mediatek.com>
Date:   Tue, 22 Sep 2020 20:38:19 -0400
In-Reply-To: <20200914050052.3974-1-stanley.chu@mediatek.com> (Stanley Chu's
        message of "Mon, 14 Sep 2020 13:00:50 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> This series adds high-performance mode support for MediaTek UFS inline
> encryption engine.  This feature is only required in specific
> platforms, i.e., MT8192 series.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
