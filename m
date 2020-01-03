Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6216C3276F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 03:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE7222525
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 03:00:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="alPFXMvn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbgACDAN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 22:00:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbgACDAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 22:00:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032xQCD081913;
        Fri, 3 Jan 2020 02:59:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=yQuBYj9lTweXO0mujRhwwsVZL/A5k0NPhbYSVXN9W/I=;
 b=alPFXMvnrCVxVoxo5gOpf3yv2rMI5ol1j5QkovRClw0xhZDZtHokpAXDv5TDG2XpED9B
 nWiN0gUW6+djWEJSWV3s9DiRyZ/ekPMg7BwNjLAKS93gDd1AwjF7qJ+HhqUHT5zgHAmE
 LL9kzjeqD5nPdtHgXaBIQCyiXO7j2XkIp1Gj+QWYCaLGIrMcLRQS+EzKfv5OVsQqJHdv
 UdUxJGZSGrwpjvFjwSqVuDeFFKD1jYuqch2Wc3sQFRv4fWaoVAVLP9n88e8zTlyaQuAf
 xOdlHArwJNTVtZYeuRXkgl9foJr0HqQDhC3JmssRSbXdmajYo6l5gBBZN6d1lpVYTlVW rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0ptanx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:59:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032xFib182529;
        Fri, 3 Jan 2020 02:59:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gjbbbt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:59:53 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0032xpPt012906;
        Fri, 3 Jan 2020 02:59:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 18:59:50 -0800
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <f.fainelli@gmail.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <leon.chen@mediatek.com>
Subject: Re: [PATCH v2 0/6] scsi: ufs: add MediaTek vendor implementations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
Date:   Thu, 02 Jan 2020 21:59:46 -0500
In-Reply-To: <1577683950-1702-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Mon, 30 Dec 2019 13:32:24 +0800")
Message-ID: <yq11rsh5jod.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> This series provides MediaTek vendor implementations as below,
>
>     - Device reset
>     - Reference clock control
>     - Auto-hibernate enabling with customized timer value
>     - Clk-gating enabling with customized delayed timer value

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
