Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9ACC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B804206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mmnn8Wjl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHRDPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:15:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgHRDPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:15:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I37RAJ032354;
        Tue, 18 Aug 2020 03:14:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=i0Ck21e9YZG44XY0ne7BebS9dKCanyt1u1wJwiaHac0=;
 b=Mmnn8WjlkbGgXmBmv7DM5ElBm40DDiYL0PwZYhBVgYS6+G/liu3TO3w8Blu1XWWUizFU
 8IADRKG1r+U8wj2rGAemvpIJhk/Idph45IM6ouH18iBR18MOkMqNuerYMG6lWD2Ks351
 crKd+IzZkWl2Yw0RCTnqdg1FRJHTsd49bftDVvyVY1TP/jys3cyQh8F1RNhOtWVy34oH
 PwbhjSoT4JdP1jMw2aeiZRnJuMozdmjaWUPjuDPKIldl+TkcM720Y7fy0e9UNox6ir4i
 76svkmlKSOuHIFShJW2g8XP5mGfMgWtF+n+R4FJsL4LBjnFqSQ2BL1DeDxzG3O4H9tYp Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nma5mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:14:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38BAZ104642;
        Tue, 18 Aug 2020 03:12:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfraxtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I3Cksj021371;
        Tue, 18 Aug 2020 03:12:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:46 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        jejb@linux.ibm.com, alim.akhtar@samsung.com,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, chaotian.jing@mediatek.com,
        peter.wang@mediatek.com, linux-arm-kernel@lists.infradead.org,
        cc.chou@mediatek.com, kuohong.wang@mediatek.com,
        andy.teng@mediatek.com, linux-kernel@vger.kernel.org,
        chun-hung.wu@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Fix incorrect time to wait link status
Date:   Mon, 17 Aug 2020 23:12:31 -0400
Message-Id: <159772029326.19587.5344784814122261360.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200809055702.20140-1-stanley.chu@mediatek.com>
References: <20200809055702.20140-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 9 Aug 2020 13:57:02 +0800, Stanley Chu wrote:

> Fix incorrect calculation of "ms" based waiting time in
> function ufs_mtk_setup_clocks().

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: ufs-mediatek: Fix incorrect time to wait link status
      https://git.kernel.org/mkp/scsi/c/215d32670251

-- 
Martin K. Petersen	Oracle Linux Engineering
