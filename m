Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF240C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7258220B1F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:49:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U8bJMaJT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgJGDso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgJGDsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973k1WA167305;
        Wed, 7 Oct 2020 03:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hqw996zbortsDFaupHZQHJr1/zfBNxFfhhGoG/eXvwA=;
 b=U8bJMaJTUOb1qO3GjnQ3t1pYsaX0xhwCcrbBi4G5a/r9e1JJta8qoSEPBDToBtgTV7o9
 zptX1IZMVHONPOuH4IFbOZLaHNgQUi7+QCwBnJ9P1dRGjW4emqpxJixTrpNnxMZmtuUl
 qDG6ucwuNsE9yaOCP7I+CHW66Sie3QNydcot0oUAlSnO1qWu589GpwjHvsJTv85J3nii
 mvZIZ/r70kRkqbom0RcQ9xpDskKoJ8QkmiszePCdQ6IlDpU1MnpfIPQGwb9rdyDLkI4U
 zTxTR5nFn66zfEBAVOWNOvBlZ83cnKSHTlq+AU4dg024sb0vqSPyi/RP6MP5Q/e8wukI Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmydcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ip9A194632;
        Wed, 7 Oct 2020 03:48:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3410jy2s7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973mQFj002433;
        Wed, 7 Oct 2020 03:48:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:25 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, Ye Bin <yebin10@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Fix inconsistent of format with argument type
Date:   Tue,  6 Oct 2020 23:48:03 -0400
Message-Id: <160204240574.16940.5778977781778439147.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930022515.2862532-1-yebin10@huawei.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Sep 2020 10:25:12 +0800, Ye Bin wrote:

> Ye Bin (3):
>   scsi: qla2xxx: Fix inconsistent of format with argument type in
>     tcm_qla2xxx.c
>   scsi: qla2xxx: Fix inconsistent of format with argument type in
>     qla_os.c
>   scsi: qla2xxx: Fix inconsistent of format with argument type in
>     qla_dbg.c
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/3] scsi: qla2xxx: Fix inconsistent format argument type in tcm_qla2xxx.c
      https://git.kernel.org/mkp/scsi/c/7f5523f69709
[2/3] scsi: qla2xxx: Fix inconsistent format argument type in qla_os.c
      https://git.kernel.org/mkp/scsi/c/250bd00923c7
[3/3] scsi: qla2xxx: Fix inconsistent format argument type in qla_dbg.c
      https://git.kernel.org/mkp/scsi/c/72e813d9a1b7

-- 
Martin K. Petersen	Oracle Linux Engineering
