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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53BBC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A872C23AA8
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbgLIRZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:25:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbgLIRYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJjBu111648;
        Wed, 9 Dec 2020 17:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Krnm1gBj032vtaGUPm7ProEmQ8tj5X6aneGdqw5G3cc=;
 b=n7M15kqn82ZJG8iDK3zj7Q1jQ89Z/bIBV2Ymtzp7PYGGQ0SrjGc1DzCsqR6NdNa0Zr6t
 tWfChNHXG79lHtiNcMgDmQ2s9vY2tS4FFHH8rzM/FiIB9ZtJ6Z07+R/VYP256kae5CNV
 9fSKiVk217edJEvTIfgMc3s0aOyS1lWG1JjC+lr/zeUzQhR+SKdVsNs/zl1PwdwsWvbk
 cFt5LjNsyj32Vc1h2vkw0XHG2a+VcMXU03t2jQ5BHwnkrT6BYShK0ivEQd2D3ADUmCCQ
 apJ27b1eZ87kuzuQp7HPMUJOcxTgn908KaYEMTwO02YT//PhrKpjnJqXzOlnJRRupbsl Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825m9cv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:24:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJlCx075705;
        Wed, 9 Dec 2020 17:24:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 358m50wh3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:24:00 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9HNwd6017969;
        Wed, 9 Dec 2020 17:23:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:58 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jiajie.hao@mediatek.com, beanhuo@micron.com, cc.chou@mediatek.com,
        chun-hung.wu@mediatek.com, asutoshd@codeaurora.org,
        chaotian.jing@mediatek.com, matthias.bgg@gmail.com,
        alice.chao@mediatek.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andy.teng@mediatek.com,
        bvanassche@acm.org, kuohong.wang@mediatek.com, cang@codeaurora.org,
        linux-mediatek@lists.infradead.org, peter.wang@mediatek.com
Subject: Re: [PATCH v1 0/4] scsi: ufs: Cleanup phy_initialization vop
Date:   Wed,  9 Dec 2020 12:23:21 -0500
Message-Id: <160753457754.14816.2032676444493914271.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201205120041.26869-1-stanley.chu@mediatek.com>
References: <20201205120041.26869-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=959
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=979 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 5 Dec 2020 20:00:37 +0800, Stanley Chu wrote:

> This series simply cleans up UFS vops and shall not change any functionality.
> 
> Stanley Chu (4):
>   scsi: ufs: Remove unused setup_regulators variant function
>   scsi: ufs: Introduce phy_initialization helper
>   scsi: ufs-cdns: Use phy_initialization helper
>   scsi: ufs-dwc: Use phy_initialization helper
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/4] scsi: ufs: Remove unused setup_regulators variant function
      https://git.kernel.org/mkp/scsi/c/ade921a891de
[2/4] scsi: ufs: Introduce phy_initialization helper
      https://git.kernel.org/mkp/scsi/c/92bcebe4b6d6
[3/4] scsi: ufs-cdns: Use phy_initialization helper
      https://git.kernel.org/mkp/scsi/c/885445736bc0
[4/4] scsi: ufs-dwc: Use phy_initialization helper
      https://git.kernel.org/mkp/scsi/c/ab98105484fc

-- 
Martin K. Petersen	Oracle Linux Engineering
