Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76110C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 540B820873
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fPS3SYDV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgE0CQ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:16:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgE0CQZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:16:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2BjPs057175;
        Wed, 27 May 2020 02:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=p4qvcrtuW2bQGADmeQqiBGaWVrsj08iNi0oxkXFi0eQ=;
 b=fPS3SYDVFsh+c3H8EZcys574JlA89oAGvHnq3N3ieIOzmgxz2cKa/sLsZfIwHbKvqRqy
 tcKIPfofusdABQBRqsHSknxoAsTvhi72bvbGV0MGM7j8bXFKM3axK1kN5XlunQbsD9Sb
 MO+Wdy9IdZeBlUJXcGwXtjglTuN9QQKmkUdriBfSG13SJKCxAPtaGC94PvfHTpxAvn6c
 nGYqspb79ICwJr2vT2qGc9S7xt14tRJqWijl3vPIFcOXKN//zpmTSKsSIjgpqnrSOE2F
 kjWL/yvLAGdI4Ygon5MRsUkh6CA+xag5vfCOVBtwC1vYmj2OHapEhZYmaJRZRpG5e01D KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 318xbjvyqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:15:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27ZGl133300;
        Wed, 27 May 2020 02:13:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 317j5q908d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04R2DEwN024111;
        Wed, 27 May 2020 02:13:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:14 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     avri.altman@wdc.com, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        beanhuo@micron.com, linux-mediatek@lists.infradead.org,
        matthias.bgg@gmail.com, cang@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, bvanassche@acm.org,
        Virtual_Global_UFS_Upstream@mediatek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] scsi: ufs: Fix WriteBooster and cleanup UFS driver
Date:   Tue, 26 May 2020 22:12:59 -0400
Message-Id: <159054550935.12032.12783598826763830376.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522083212.4008-1-stanley.chu@mediatek.com>
References: <20200522083212.4008-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 22 May 2020 16:32:08 +0800, Stanley Chu wrote:

> This patch set fixes some WriteBooster issues and do small cleanup in UFS driver
> 
> v3 -> v4
>   - Squash patch [4] and [5] (Asutosh)
>   - Fix commit message in patch [4]
> 
> v2 -> v3
>   - Introduce patch [5] to fix possible VCC power drain during runtime suspend (Asutosh)
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/4] scsi: ufs: Remove unnecessary memset for dev_info
      https://git.kernel.org/mkp/scsi/c/3a66ae512b09
[2/4] scsi: ufs: Allow WriteBooster on UFS 2.2 devices
      https://git.kernel.org/mkp/scsi/c/c7cee3e746a5
[3/4] scsi: ufs: Fix index of attributes query for WriteBooster feature
      https://git.kernel.org/mkp/scsi/c/e31011ab3709
[4/4] scsi: ufs: Fix WriteBooster flush during runtime suspend
      https://git.kernel.org/mkp/scsi/c/51dd905bd2f6

-- 
Martin K. Petersen	Oracle Linux Engineering
