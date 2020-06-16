Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39A4C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 03:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5A1620776
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 03:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bs4Cbg3v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgFPDso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 23:48:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFPDsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 23:48:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3foSZ186488;
        Tue, 16 Jun 2020 03:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XgO9rozhzUb4b1RJT0FSSZ2lSj+Tsv9oHAVRK4CoEjo=;
 b=bs4Cbg3vVEmK2ks7O2GpJesNeGyTQfc/FRhuxRXlET/MBWhgC87d1+4b+O+/oj06zOr5
 G1uDDj0AGGwM7JH84lU1buqu+BSVB9jeLUapEsHrtm2EEwRqVxBzPFCsRwsyFF27FeGM
 Lsu2Rshw6kfpjKPjl4/ZoB8gJ040JDhrQjENbdgt2MOa9YCnSH3HOr/Gbj/Fv/ZUxScd
 WItajTxODnbjgLtP8QB3i1zz3b5e6O6V1gKsGY+Ssyzp0gMX/pBry2V7IKiDDvJajknb
 zfc3mA7Lxi9LHByVE2coP8zPplDLd6jV2d/AoPSCc9gesclEcTEEVrModpeEQK3ZGp5c qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31p6s249h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 03:48:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3h22d185023;
        Tue, 16 Jun 2020 03:46:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31p6s6hb3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 03:46:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G3kM2L015942;
        Tue, 16 Jun 2020 03:46:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 20:46:21 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        brking@us.ibm.com, jinpu.wang@cloud.ionos.com, mpe@ellerman.id.au,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] libata: provide a ata_scsi_dma_need_drain stub for !CONFIG_ATA
Date:   Mon, 15 Jun 2020 23:46:19 -0400
Message-Id: <159227896596.21874.13848984426600233866.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615064624.37317-2-hch@lst.de>
References: <20200615064624.37317-1-hch@lst.de> <20200615064624.37317-2-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 cotscore=-2147483648 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2020 08:46:23 +0200, Christoph Hellwig wrote:

> SAS drivers can be compiled with ata support disabled.  Provide a
> stub so that the drivers don't have to ifdef around wiring up
> ata_scsi_dma_need_drain.

Applied to 5.8/scsi-fixes, thanks!

[1/2] scsi: libata: Provide an ata_scsi_dma_need_drain stub for !CONFIG_ATA
      https://git.kernel.org/mkp/scsi/c/7bb7ee8704fe
[2/2] scsi: Wire up ata_scsi_dma_need_drain for SAS HBA drivers
      https://git.kernel.org/mkp/scsi/c/b8f1d1e05817

-- 
Martin K. Petersen	Oracle Linux Engineering
