Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74CFC433E5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858272070E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dwavi3Tz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgGYCxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:53:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57738 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYCxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:53:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2m20D043206;
        Sat, 25 Jul 2020 02:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=g2xSZwKdfwHJtPVtvYIDrku+lieMFbr+21h4tY2QBQQ=;
 b=dwavi3TzZnex5zZq+2HAB2ewDokkEyvAf60WX5Tr2EizKFwd5IR44hyaVvLdE78ZUtgT
 ug+PU9gTtJ6imJgbJc7o7REjYa5Z+Jaf2kE5gC61dV/O2jYUQrkd8Y1Mn/BP/jS1Tw0/
 2vllAuWNnQ609P0sFqo7de9AdVvIkGirj5ZWveV+Ic8o6fqL3PJgJdL/EsPQuV+mSwQ7
 Tn6RjYLUPvtt5uH1F+/WVkC6eWxjJ56VRiKA7F3tp8sk5AFBlhOoNohs/knLBsk5PhpI
 AxV8JAsz1Z3C2kzh2wB1PTOZq/XDOkilXPDwsuyuS+3rmO/uYMFjp5Q2wUEOMEMEvVD8 aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32bs1n1uvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:53:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mVZ0092342;
        Sat, 25 Jul 2020 02:51:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32gaseas7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2oxQi000945;
        Sat, 25 Jul 2020 02:51:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:50:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Luo Jiaxing <luojiaxing@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, john.garry@huawei.com,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        yanaijie@huawei.com, chenxiang66@hisilicon.com
Subject: Re: [PATCH v1 0/2] scsi: libsas: An improvement on error handle and tidy-up
Date:   Fri, 24 Jul 2020 22:50:40 -0400
Message-Id: <159564519422.31464.1740905503467302536.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1595408643-63011-1-git-send-email-luojiaxing@huawei.com>
References: <1595408643-63011-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1011
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Jul 2020 17:04:01 +0800, Luo Jiaxing wrote:

> This patch introduces an improvement to reduce error handle time and a
> tidy-up, including:
> - postreset() is deleted from sas_sata_ops.
> - Do not perform hard reset and delayed retry on a removed SATA disk. This
> can effectively reduce the error handle duration of hot unplug a SATA disk
> with traffic(reduce about 30s depending on the delay setting of libata).
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: libsas: Remove postreset from sas_sata_ops
      https://git.kernel.org/mkp/scsi/c/3a243c2c3500
[2/2] scsi: libsas: Check link status in ATA prereset()
      https://git.kernel.org/mkp/scsi/c/386533796574

-- 
Martin K. Petersen	Oracle Linux Engineering
