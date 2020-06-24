Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4074AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203AA2078E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G6Cwa9Ut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388664AbgFXEbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 00:31:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgFXEbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 00:31:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4VmO4056469;
        Wed, 24 Jun 2020 04:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Z8/1om2ZMwFjzMFG23xYBK1li1rUmhNYZqnGzLymclk=;
 b=G6Cwa9UtQNVdLl2Sg44gE43vg8d640u6AGmJSHAuqQY6Qk8aPSIKzwBTdoZUrTI5ar1s
 RYoVdfycd7XbUq6OycNafjldK8tnVvOg5/7Ud04anfiyXzBLHyLG/l2SyUo5R+lDr/OX
 7p1haxJQKC4CDA1d2t5AVb0F78Uo3UZe1UZytjKqjRm58HtUM7DXr1xfn9hVpAJBNT/a
 6u7qOTys6FMM4inmSXPH6eg4wNSUdfYRT0s+s0IShVUdHIDb+s75q91efBCqTdTe2jSx
 77N0ZTe9qE2yh+CRySEQctA/MYXIpUGUFMtn765YXCHtfMC8gGVFSi3LfTKKYC+PBPeJ 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uustgm32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:31:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4NGUt113394;
        Wed, 24 Jun 2020 04:29:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31uurq6um0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:29:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O4Tk0H011164;
        Wed, 24 Jun 2020 04:29:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:29:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: fix the ata_scsi_dma_need_drain stub
Date:   Wed, 24 Jun 2020 00:29:39 -0400
Message-Id: <159297296072.9797.12391129468733807444.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071302.462974-2-hch@lst.de>
References: <20200620071302.462974-1-hch@lst.de> <20200620071302.462974-2-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=746 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=777
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 20 Jun 2020 09:13:02 +0200, Christoph Hellwig wrote:

> We don't only need the stub when libata is disable, but also if it
> is modular and there are built-in SAS drivers (which can happen when
> SCSI_SAS_ATA is disabled).

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: libata: Fix the ata_scsi_dma_need_drain stub
      https://git.kernel.org/mkp/scsi/c/aad4b4d15f30

-- 
Martin K. Petersen	Oracle Linux Engineering
