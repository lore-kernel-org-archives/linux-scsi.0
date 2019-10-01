Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0D6C32792
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B5D12087F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cAUQHJBn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbfJADC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:02:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfJADC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:02:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912wgD1123860;
        Tue, 1 Oct 2019 03:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=njwwrnTifs8mrKE8jnEn5CkrqleEPai9Gly5Yeav8D0=;
 b=cAUQHJBnGzWF7MI4SCB1phb0aN5MTzD42w+hscUrp5YyNRo0SBAeDZk7p6XUlx9A1YvJ
 a5fFO5Xf2uJqyeg+74iX3oia29430BC8/AeBFGmwwJs8+JN5RZxKxgg7wm6vjZu20YbQ
 7/fva448QrBWI+oM1APP7CNCXfqhJD8QgJ9/SxoJiI3StDqrLPB0ZWiiillxyvrRUJ4D
 4tipgv2m8KYHQgMnBQfi7Z8N6W1JGpHtNPJHzmtwUDM7GRGx9HPXlr5G6hcYCxCo8yXz
 c/HFJsggWJCdai0yZ/zGCogwfyTOeTeyoxXq3BQ+hT9qMPpMPEPtWIijsBKelYZAqGcg aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05rjtda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:01:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912whdC038056;
        Tue, 1 Oct 2019 03:01:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vbsm13ssp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:01:54 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9131nkm005437;
        Tue, 1 Oct 2019 03:01:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:01:49 -0700
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <sthumma@codeaurora.org>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel-team@android.com>,
        <matthias.bgg@gmail.com>, <evgreen@chromium.org>,
        <beanhuo@micron.com>, <marc.w.gonzalez@free.fr>,
        <subhashj@codeaurora.org>, <vivek.gautam@codeaurora.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>
Subject: Re: [PATCH v4 0/3] scsi: core: allow auto suspend override by low-level driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568649411-5127-1-git-send-email-stanley.chu@mediatek.com>
Date:   Mon, 30 Sep 2019 23:01:45 -0400
In-Reply-To: <1568649411-5127-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Mon, 16 Sep 2019 23:56:48 +0800")
Message-ID: <yq1o8z1xj6u.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=893
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=973 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> Until now the scsi mid-layer forbids runtime suspend till userspace
> enables it. This is mainly to quarantine some disks with broken
> runtime power management or have high latencies executing suspend
> resume callbacks. If the userspace doesn't enable the runtime suspend
> the underlying hardware will be always on even when it is not doing
> any useful work and thus wasting power.

Applied to 5.5/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
