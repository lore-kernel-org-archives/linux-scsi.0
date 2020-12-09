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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544E6C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E1A23AA8
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbgLIRZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:25:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732477AbgLIRY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJopo058999;
        Wed, 9 Dec 2020 17:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yVP8hzy1AwhZc1OZLvSSH4nn+zlDgukvqxfFINAXqJQ=;
 b=lcVtKhEYV0zplaRRieiJeJHn65HOLozN1+17PYagI8Ill0wFhvipZoLG+APz5SSk+HLV
 Ego7OhRRAEADILIO5olx2nTnCAOqM8CK5xNe04dWJT/Y0Vc/AtO1McNzFcYTuUmAesIi
 y2SRO2LZr0y6J3y1JRGcj3uWVHFvsuq9H88HAbl7+Rm9TGQbA3R53z7VhLV/9K6dR4oF
 aZNX0FpKaVMW9156x8DjaEcQ+yjwTKq4L7zN6FUJ0iRVWJ3mPXrigzXmiBVLUxGqrfUW
 uajF8uWDJAhr19WY8rMKBktybQi0JzMyP3mQtYFTZfEeit0WZ9da0vReLTMmRNk7PXJW Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqc1fp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:24:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKrSL100140;
        Wed, 9 Dec 2020 17:24:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358ksqdk7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:24:03 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HO2Ts014403;
        Wed, 9 Dec 2020 17:24:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:24:02 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        beanhuo@micron.com, jiajie.hao@mediatek.com,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        asutoshd@codeaurora.org, chaotian.jing@mediatek.com,
        matthias.bgg@gmail.com, alice.chao@mediatek.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andy.teng@mediatek.com, bvanassche@acm.org,
        huadian.liu@mediatek.com, kuohong.wang@mediatek.com,
        cang@codeaurora.org, linux-mediatek@lists.infradead.org,
        peter.wang@mediatek.com
Subject: Re: [PATCH v5 0/4] scsi: ufs: Refine error history and introduce event_notify vop
Date:   Wed,  9 Dec 2020 12:23:23 -0500
Message-Id: <160753457754.14816.15980863701992917932.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201205115901.26815-1-stanley.chu@mediatek.com>
References: <20201205115901.26815-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 5 Dec 2020 19:58:57 +0800, Stanley Chu wrote:

> This series refines error history functions and introduces a new event_notify vop to allow vendor to get notification of important events.
> 
> Changes since v4:
>   - Seperate patch sets according to Avri's suggestion
> 
> Changes since v3:
>   - Fix build warning in patch [8/8]
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/4] scsi: ufs: Add error history for abort event in UFS Device W-LUN
      https://git.kernel.org/mkp/scsi/c/eb3d2611df2e
[2/4] scsi: ufs: Refine error history functions
      https://git.kernel.org/mkp/scsi/c/e965e5e00b23
[3/4] scsi: ufs: Introduce event_notify variant function
      https://git.kernel.org/mkp/scsi/c/172614a9d0e8
[4/4] scsi: ufs-mediatek: Introduce event_notify implementation
      https://git.kernel.org/mkp/scsi/c/ca1bb061d644

-- 
Martin K. Petersen	Oracle Linux Engineering
