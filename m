Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E00C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65382082F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kESvkjPn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgFPEAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:00:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgFPEAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:00:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3umc2054141;
        Tue, 16 Jun 2020 04:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=tog6p+jhHv1MMPC5xFRis+xy2D7mIFMgOiTv3S7un+k=;
 b=kESvkjPnMz7HzI8reMaO92Zj5+1KoqISZ+p0/cI2ogRq0iXsGcJU8TSSuvGJuO3pSVfr
 GEU0flLEFA53KNwY6uH2rK3pBW3MsI8lm9j23GRDjdcdVdy75Pnx+BbTJ/tihgA+Tfrt
 KLWqFOjYinRBKYdA7DuArPJhdU/361V9lr3cfYdF6OQyfUAIkqYRLofHR9WSEWhdFJiA
 PzCsms6vGXfKiaWebBi9rANKbqT9v/XZIG09ErcMR6HJ3jMHnafC2JfEAkTaMxACzjbU
 HckDkrys1+rksF+xWxGnNlzh+S+KygsiHEluUgGSE4ZIByWg5SQHTALGwQ+kL7M4R+UC aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31p6e7vdma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3xO22131197;
        Tue, 16 Jun 2020 04:00:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31p6dcae83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G40I22023320;
        Tue, 16 Jun 2020 04:00:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        Stanley Chu <stanley.chu@mediatek.com>, avri.altman@wdc.com,
        alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com, beanhuo@micron.com,
        matthias.bgg@gmail.com, bvanassche@acm.org, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, kuohong.wang@mediatek.com,
        linux-kernel@vger.kernel.org, cang@codeaurora.org,
        andy.teng@mediatek.com, linux-arm-kernel@lists.infradead.org,
        chun-hung.wu@mediatek.com, asutoshd@codeaurora.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 0/5] scsi: ufs-mediatek: Fix clk-gating and introduce low-power mode for vccq2
Date:   Mon, 15 Jun 2020 23:59:58 -0400
Message-Id: <159227986421.24883.1728950810873542033.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601104646.15436-1-stanley.chu@mediatek.com>
References: <20200601104646.15436-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=655 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 mlxlogscore=685 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 1 Jun 2020 18:46:41 +0800, Stanley Chu wrote:

> This series fixes clk-gating issues and introduces low-power mode for vccq2 in MediaTek platforms.
> 
> v2 -> v3:
>   - Fix (add back) linkoff support in patch [4] since previous version incorrectly removed linkoff support
> 
> v1 -> v2:
>   - Add patch [4] and [5]
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/5] scsi: ufs-mediatek: Fix imprecise waiting time for ref-clk control
      https://git.kernel.org/mkp/scsi/c/fb43337cd4cf
[2/5] scsi: ufs-mediatek: Do not gate clocks if auto-hibern8 is not entered yet
      https://git.kernel.org/mkp/scsi/c/9006e3986f66
[3/5] scsi: ufs-mediatek: Introduce low-power mode for device power supply
      https://git.kernel.org/mkp/scsi/c/488edafb1120
[4/5] scsi: ufs-mediatek: Fix unbalanced clock on/off
      https://git.kernel.org/mkp/scsi/c/561e3a8726b2
[5/5] scsi: ufs-mediatek: Allow unbound mphy
      https://git.kernel.org/mkp/scsi/c/fc4983018fea

-- 
Martin K. Petersen	Oracle Linux Engineering
