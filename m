Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F77BC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9172074D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:12:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r90k8Xic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEOBMx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 21:12:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgEOBMx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 21:12:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F13BU9130944;
        Fri, 15 May 2020 01:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=iP+CAPe6xqTX3quF8Qdp4lFGocslpJ7Wa4UEt8Vsb1s=;
 b=r90k8XicwuZ0No3D35nhmnkNtqZpNxETjbkZn5qi0U7X2YRGMAYlTTLbi4HrdIT8Qelp
 i4fqXUzs3LMU3hDjYPGf6vcdjmD0eF87TWjmxn0s7HkP5nvCCONDqjAqh6PKBRWA/mnq
 QqQ71C5lvIzk9+1XMy9cGivk6eAY7gOucgp5ukcMrsXQEEeVe1bfAJ06NQ/SWx9oAANp
 /rbL7BSuVVRSE6/yDRGnWr3lYDoN4Fb/xrufw4NoHs/ELOPx0JYZivRdl4VQPMxF94cF
 TikeuAAvg6XbgtchKg9YM2auwvcWNqMdnxtpnPVreke05yn4GxiM3J158YYNM0xA7hoa Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3100xwxqbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 01:12:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F1474T014928;
        Fri, 15 May 2020 01:10:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3100yds35r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 01:10:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04F1AaQO014050;
        Fri, 15 May 2020 01:10:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 18:10:36 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, Stanley Chu <stanley.chu@mediatek.com>,
        asutoshd@codeaurora.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com,
        linux-mediatek@lists.infradead.org, peter.wang@mediatek.com,
        beanhuo@micron.com, matthias.bgg@gmail.com, andy.teng@mediatek.com,
        bvanassche@acm.org, cang@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/4] scsi: ufs: allow customizable WriteBooster flush policy
Date:   Thu, 14 May 2020 21:10:29 -0400
Message-Id: <158950485295.8169.36549719949053326.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509093716.21010-1-stanley.chu@mediatek.com>
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 May 2020 17:37:12 +0800, Stanley Chu wrote:

> This patch set tries to allow vendors to modify the WriteBooster flush policy.
> 
> In the same time, collect all customizable parameters to an unified structure to make UFS driver more clean.
> 
> v1 -> v2:
>   - Squash patch [3] and [4]
>   - Remove a dummy "new line" in patch [3]
>   - Fix commit message in patch [3]
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

I had to combine patches 1 and 2. Otherwise you'd get compile
failures due to the fields moving inside the struct.

[1/4] scsi: ufs: Introduce ufs_hba_variant_params to group customizable parameters
      https://git.kernel.org/mkp/scsi/c/90b8491c0033
[3/4] scsi: ufs: Customize flush threshold for WriteBooster
      https://git.kernel.org/mkp/scsi/c/d14734ae3ae7
[4/4] scsi: ufs-mediatek: Customize WriteBooster flush policy
      https://git.kernel.org/mkp/scsi/c/f48b285ae658

-- 
Martin K. Petersen	Oracle Linux Engineering
