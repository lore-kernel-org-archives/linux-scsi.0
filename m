Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3243BC433F7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EFF2193E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kh+BkuEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGNE7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGNE7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4w6QE100069;
        Tue, 14 Jul 2020 04:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=MvOmzb2T3obRz6dBo34iF/6Oj5vZJrC530Im1gp2ULU=;
 b=Kh+BkuEjb2vJW0gHyGGrskHfrX6zuWBHG3VkLd+9U2PFlvlBaRJr4QeJbQxmcni18Lod
 Om9/T43fQA2bKlP8kjHvx9UpOFu/PyJ4mmAs9clXYhvm3dk5btCSNA2u09lLXTRs3cf2
 T983dbJ9wFAvsZY86aqa6hrpdCdvMVsIXxOrccdKDfoR7BNnGCcfgfA0wKtJhcaoff1W
 +4Dtz7KI5IDLpm/HvdVB6P1dwYNGhy/qMZyPXRYJOrJiZQE5yYxkkgVxTtU/C8zOYA0B
 8g0XVqpQi2MGhuy2vVCiniMpiOFH1cHaiJVOFonbi4B9iPSrOPVTTPbAXR2uauTFdZUT ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur2yqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:59:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vXHY173971;
        Tue, 14 Jul 2020 04:59:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb2nusf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E4wtx6025063;
        Tue, 14 Jul 2020 04:58:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:55 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, bvanassche@acm.org,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kuohong.wang@mediatek.com, beanhuo@micron.com,
        linux-kernel@vger.kernel.org, cc.chou@mediatek.com,
        cang@codeaurora.org, matthias.bgg@gmail.com,
        chaotian.jing@mediatek.com, asutoshd@codeaurora.org,
        peter.wang@mediatek.com, andy.teng@mediatek.com,
        chun-hung.wu@mediatek.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v1 0/2] scsi: ufs: Fix and simplify setup_xfer_req vop and request's completion timestamp
Date:   Tue, 14 Jul 2020 00:58:44 -0400
Message-Id: <159470266467.11195.12121628699301180933.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706060707.32608-1-stanley.chu@mediatek.com>
References: <20200706060707.32608-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 14:07:05 +0800, Stanley Chu wrote:

> This small series fixes and simplifies setup_xfer_req vop and request's completion timestamp.
> 
> Stanley Chu (2):
>   scsi: ufs: Simplify completion timestamp for SCSI and query commands
>   scsi: ufs: Fix and simplify setup_xfer_req variant operation
> 
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: ufs: Simplify completion timestamp for SCSI and query commands
      https://git.kernel.org/mkp/scsi/c/a3170376f7db
[2/2] scsi: ufs: Fix and simplify setup_xfer_req variant operation
      https://git.kernel.org/mkp/scsi/c/6edfdcfe285e

-- 
Martin K. Petersen	Oracle Linux Engineering
