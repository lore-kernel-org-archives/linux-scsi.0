Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CED9C56202
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B8C22256
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+D+on2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgKTDcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:32:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgKTDcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:32:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OpV8095751;
        Fri, 20 Nov 2020 03:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=h8p/eGxprONg2I24EcQmXpw8YFJpgN/ZNu2mYAE5OnY=;
 b=L+D+on2g5WNWWIuzKP7WxyUmASLDHSwznpDAJu7vTXqBd30V1pBId6SPMutdclspdK4V
 QFmNE5sENf9nbHhgiQUJSe2vSj6yGunXE7RzO+T1Zkd/jfEd5/3Vxf+/s6egMoorR6yE
 qIDK59R40SyyKp8SXBvNaq2RQA+GN5rdT+H5b20opxhYfjLV5PzGhbZ01u+yCQhfVdBr
 8Jq3Gxxto2fLTyJwji+y2+udquNlpUHscUqXPiKFxSVTsPBkD+tmqkDWBia+lG14Lyyh
 RTCNy/y8DAsste0xFZ5EZWX0TgCOx2ZfGCeXEMrCfrquqWDKg++YM05GyF/mIlEBYAka dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76m8qy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:32:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OffG029306;
        Fri, 20 Nov 2020 03:31:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34ts60whc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:31:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3Vtcr025948;
        Fri, 20 Nov 2020 03:31:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:31:55 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        cang@codeaurora.org, kwmad.kim@samsung.com, cc.chou@mediatek.com,
        linux-mediatek@lists.infradead.org, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, asutoshd@codeaurora.org,
        chun-hung.wu@mediatek.com, jiajie.hao@mediatek.com,
        peter.wang@mediatek.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org, liwei213@huawei.com,
        beanhuo@micron.com, alice.chao@mediatek.com
Subject: Re: [PATCH v1 0/9] scsi: ufs: Refactoring and cleanups
Date:   Thu, 19 Nov 2020 22:31:45 -0500
Message-Id: <160584262853.7157.6454883311543649940.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Nov 2020 14:50:45 +0800, Stanley Chu wrote:

> This series simply do some refactoring and cleanups in UFS drivers.
> 
> Stanley Chu (9):
>   scsi: ufs-mediatek: Refactor performance scaling functions
>   scsi: ufs: Introduce device parameter initialization function
>   scsi: ufs-mediatek: Use device parameter initialization function
>   scsi: ufs-qcom: Use device parameter initialization function
>   scsi: ufs-exynos: Use device parameter initialization function
>   scsi: ufs-hisi: Use device parameter initialization function
>   scsi: ufs: Refactor ADAPT configuration function
>   scsi: ufs-mediatek: Use common ADAPT configuration function
>   scsi: ufs-qcom: Use common ADAPT configuration function
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/9] scsi: ufs: ufs-mediatek: Refactor performance scaling functions
      https://git.kernel.org/mkp/scsi/c/54770cbebe2c
[2/9] scsi: ufs: Introduce device parameter initialization function
      https://git.kernel.org/mkp/scsi/c/65858014ee20
[3/9] scsi: ufs: ufs-mediatek: Use device parameter initialization function
      https://git.kernel.org/mkp/scsi/c/a4b537ea656e
[4/9] scsi: ufs: ufs-qcom: Use device parameter initialization function
      https://git.kernel.org/mkp/scsi/c/8beef54716e6
[5/9] scsi: ufs: ufs-exynos: Use device parameter initialization function
      https://git.kernel.org/mkp/scsi/c/5b3573d68d9a
[6/9] scsi: ufs: ufs-hisi: Use device parameter initialization function
      https://git.kernel.org/mkp/scsi/c/85d6d3c18953
[7/9] scsi: ufs: Refactor ADAPT configuration function
      https://git.kernel.org/mkp/scsi/c/fc85a74e28fe
[8/9] scsi: ufs: ufs-mediatek: Use common ADAPT configuration function
      https://git.kernel.org/mkp/scsi/c/e1e25d1b8996
[9/9] scsi: ufs: ufs-qcom: Use common ADAPT configuration function
      https://git.kernel.org/mkp/scsi/c/d9fa1e731e24

-- 
Martin K. Petersen	Oracle Linux Engineering
