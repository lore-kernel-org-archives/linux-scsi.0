Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEDBC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2772082F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NrEF6i/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgFPEAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:00:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgFPEAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:00:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3x7Hk195261;
        Tue, 16 Jun 2020 04:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=WCUhN94eoOku1+k3rSNEpLPDTZnjBYL2UylmBfw0T1s=;
 b=NrEF6i/WPI6mRZlBtiSuc80dJEZ8fMw8uud9MG/3nLfqrX7LqZJS4U1a4qso/A/oPt4N
 V/NXy7NNTZZqrsh6omloaDD8SD6POTRaxTKyAckG75SIi/o3pc42BgiEmsG/3jg/zgNQ
 brXy7hecxgguL8oMWf0CnfLy894rfQPLYE0kJ+YwCDDk5D0xpADI6/QgQqkMSyYbbW3K
 8cG9oOOWevdtW1Qx9siqtD/7jbR8CRrckYS2R9rpxV2VugnDXxoE5rvglvxABYRaqoiX
 jFqOcLrY3vI9KO+quzwEQ5xi8cBah2vX+sGfmfj5L1zLepAXOvYFPh6qPIxNgR6NjBnf bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31p6e5vdan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3x2a6020916;
        Tue, 16 Jun 2020 04:00:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31p6s6hmcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05G40KmY001266;
        Tue, 16 Jun 2020 04:00:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:20 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        avri.altman@wdc.com, Stanley Chu <stanley.chu@mediatek.com>,
        asutoshd@codeaurora.org, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com, beanhuo@micron.com,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, andy.teng@mediatek.com,
        cc.chou@mediatek.com, cang@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, kuohong.wang@mediatek.com,
        chaotian.jing@mediatek.com, chun-hung.wu@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v5] scsi: ufs: Fix imprecise load calculation in devfreq window
Date:   Mon, 15 Jun 2020 23:59:59 -0400
Message-Id: <159227986423.24883.5364281872549678357.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611101043.6379-1-stanley.chu@mediatek.com>
References: <20200611101043.6379-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 Jun 2020 18:10:43 +0800, Stanley Chu wrote:

> The UFS load calculation is based on "total_time" and "busy_time" in a
> devfreq window. However, the source of time is different for both
> parameters: "busy_time" is assigned from "jiffies" thus has different
> accuracy from "total_time" which is assigned from ktime_get().
> 
> Besides, the time of window boundary is not exactly the same as
> the starting busy time in this window if UFS is actually busy
> in the beginning of the window. A similar accuracy error may also
> happen for the end of busy time in current window.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: Fix imprecise load calculation in devfreq window
      https://git.kernel.org/mkp/scsi/c/b1bf66d1d5a8

-- 
Martin K. Petersen	Oracle Linux Engineering
