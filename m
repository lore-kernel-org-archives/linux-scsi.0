Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923C9C432C2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 652E02064A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C26j9Gli"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408511AbfIXC1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 22:27:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408485AbfIXC1G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 22:27:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2NweF103631;
        Tue, 24 Sep 2019 02:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=WWWsc3hud/ujqHoGG9ItTT3NOPVXdOVdxQNDHJgUDrA=;
 b=C26j9Glip/SHVg1MIjC+xmFn7g3kJcsDfFwzktmKGqvPAcMKLSCNr/tJT1B4CJntqUpt
 oUrDOT8P7feqH1WLsDWBK2QvDn/f2BQ+A3MMhq9NRT58ZFqEcs6VTMBG77hXJXPvD6jN
 G37uE4wIDFV80c3t9QyGhl2IbVvXcVdaj6hQjFScoDm5u7EdVkbGLSHVj6zZrNcXZGYZ
 meG+SmKIBfTUVyaT7Wk3R2CnYdHA3jhr5ClNjWFUeTAX4THL049yRRh+JFtdPpUUFOHU
 nhXwsuftZmFjAdiYp5Lf2/hAamRbXaT0xsT7ALogOMuzDAu4Sk0EW45vwgw7lZwDXO0s fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgqtpqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:26:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2IILc099073;
        Tue, 24 Sep 2019 02:24:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v6yvqn34d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:24:46 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8O2OiLI019172;
        Tue, 24 Sep 2019 02:24:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 19:24:43 -0700
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <beanhuo@micron.com>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Subject: Re: [PATCH v1] scsi: ufs: skip shutdown if hba is not powered
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568780438-28753-1-git-send-email-stanley.chu@mediatek.com>
Date:   Mon, 23 Sep 2019 22:24:40 -0400
In-Reply-To: <1568780438-28753-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Wed, 18 Sep 2019 12:20:38 +0800")
Message-ID: <yq1sgom4ejb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=931
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> In some cases, hba may go through shutdown flow without successful
> initialization and then make system hang.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
