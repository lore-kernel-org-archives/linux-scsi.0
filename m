Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DB7C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C0E22256
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lWHAHkAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgKTDbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:31:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgKTDbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:31:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3POrJ096713;
        Fri, 20 Nov 2020 03:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jpMD3b1qJW/Kul31vRtcwfkmxhU26skq+zg6BUmega4=;
 b=lWHAHkAD0KmpcibgC0Z1+H2PrV/CUbDLr7rie2WaMBxfIjbR1dwusGS4rZvG/W1kP5kp
 tt9mQYoNNZXX+iGSciu29U6CbSQvuXQZdT6oxsl497RxZwA31oFsRvkthsZnf7XSEG3E
 FkKTztrFIwFclkJ2oSzL/rtkzFbO1c3TWKyNE4QlikmIHN08lVNqoZdKdnZfHk/IWKbA
 aQ+xuJyTXjy9hZBcPz2TG0/HleMRX+JjFEL0lgDiyKNqcjenxtnZyw6ZMb4ciDzXbCV5
 Bfa6sA7qBh8qGuYlqNgicogwawemTPLGc8zPG41ctu4uWVuZcB0ji1KTvOTg6h4APdDx Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34t76m8qvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:30:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3PjYv032437;
        Fri, 20 Nov 2020 03:30:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34uspx2hq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:30:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3UaPc017127;
        Fri, 20 Nov 2020 03:30:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:30:36 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, jejb@linux.ibm.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        bvanassche@acm.org, cang@codeaurora.org, peter.wang@mediatek.com,
        asutoshd@codeaurora.org, chun-hung.wu@mediatek.com,
        alice.chao@mediatek.com, matthias.bgg@gmail.com,
        chaotian.jing@mediatek.com, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kuohong.wang@mediatek.com,
        jiajie.hao@mediatek.com, linux-arm-kernel@lists.infradead.org,
        andy.teng@mediatek.com, beanhuo@micron.com, cc.chou@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs: Fix race between shutdown and runtime resume flow
Date:   Thu, 19 Nov 2020 22:30:34 -0500
Message-Id: <160584260540.532.6488395968913616505.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119062916.12931-1-stanley.chu@mediatek.com>
References: <20201119062916.12931-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Nov 2020 14:29:16 +0800, Stanley Chu wrote:

> If UFS host device is in runtime-suspended state while
> UFS shutdown callback is invoked, UFS device shall be
> resumed for register accesses. Currently only UFS local
> runtime resume function will be invoked to wake up the host.
> This is not enough because if someone triggers runtime
> resume from block layer, then race may happen between
> shutdown and runtime resume flow, and finally lead to
> unlocked register access.
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix race between shutdown and runtime resume flow
      https://git.kernel.org/mkp/scsi/c/e92643db5148

-- 
Martin K. Petersen	Oracle Linux Engineering
