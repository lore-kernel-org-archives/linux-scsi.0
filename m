Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41C8C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58952071B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nj+6NVri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHaRlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:41:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49096 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbgHaRlc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:41:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHSoB2072919;
        Mon, 31 Aug 2020 17:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ppdI0bU9T3xIdDRNDJWiuU88Uzl11Ev83OjU2rF7BY8=;
 b=Nj+6NVrikD/7/bA+w0yuFr8PFGGDOTdN6e+si95W6okgfUhHoMqVI6sgwGBM4Ly9tTVz
 l1HV9CG2h+SaeNQKvPAsriuezjej8zBaUU2jMECQWTG8CEqNUML7XNGLSAhlNt+Wk/Rn
 S54G5Z8KcKquGIOfxipjcE2anOuBrRI+VR6T5pDW+e+CIfuLdJLH9cVqDIiSdFdTXPKo
 ci4OdW0PZvG9AlY37CPGfUL+JNIO54FCDWk3Gm55tI77vn3lKJQW8OYKCARAvt554ujU
 6A9oST1RZBkpPvAEq0xjEDIWej9Z6a+mqMomBOmfBXCSio12NzTtQm6o+ov2hZDyed5F iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqqmh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:41:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHdb8X091987;
        Mon, 31 Aug 2020 17:41:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3380xv3wx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:28 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VHfRTk007630;
        Mon, 31 Aug 2020 17:41:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:27 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Suraj Upadhyay <usuraj35@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] scsi: Remove pci-dma-compat wrapper APIs.
Date:   Mon, 31 Aug 2020 13:41:13 -0400
Message-Id: <159889566023.22322.6479632795302279469.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=974 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=977 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Jul 2020 23:35:29 +0530, Suraj Upadhyay wrote:

> Hii Maintainers,
>         This patchset replaces the pci-dma-compat wrappers with their
> dma-mapping counterparts. Thus, removing possible midlayering and
> unnecessary legacy code and API.
> 
> Most of the task is fairly trivially scriptable and done with
> coccinelle. But the handling of pci_z/alloc_consistent needed
> some hand modification in replacing the flag GFP_ATOMIC with
> a proper flag depending upon the context.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/7] scsi: aacraid: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/e555cd5f17be
[2/7] scsi: aic7xxx: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/daf4b00b7576
[3/7] scsi: dc395x: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/ece0eeff4c72
[4/7] scsi: mpt3sas: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/a5a20c4a294e
[5/7] scsi: hpsa: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/8f31fa53d36b
[6/7] scsi: qla2xxx: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/8d1f1ffaeb27
[7/7] scsi: megaraid: Remove pci-dma-compat wrapper API
      https://git.kernel.org/mkp/scsi/c/ec090ef8cd1c

-- 
Martin K. Petersen	Oracle Linux Engineering
