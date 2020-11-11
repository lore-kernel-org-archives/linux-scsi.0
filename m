Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB79AC55ABD
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F0120809
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ckcJB5Sy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgKKC6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgKKC6i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2rsO0158208;
        Wed, 11 Nov 2020 02:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=l/00b1r6ntz3i0di6dsQ8mSyZqI9GlYlY+lhOWyr6gA=;
 b=ckcJB5Sy7jv16kQOanduCFVene6L9zBKscaho7V2Vif7+d/GfDsjmJh1rvY6Mp/iKZDG
 y28+I6N+yz2h8Mcn+4jqnmnaQHZjcU4pszhHfsOuK+3H8mW4q5DBuv2gFguxswn/M5O0
 /9lmCtJ1RmOTqqTrOUhtg5ORbOf5oTMa6ogSTp8BwWidMQ70/h52P6wIO5uvn5fluVG1
 CS3gZTIZY71AobMAZ4iSTxCEE1nm0bcQeIAqHoEq9JOHayixaXZwv5cAYC/XBrKbd6V9
 E3IG0+AKXrKIpgaT5Ar3/PrSo6NVDr8coSawlfdMieidq8qt4y1IYtppLuCYf1XkEFFQ 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhkxwps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2u88p078991;
        Wed, 11 Nov 2020 02:58:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34p5gxt5q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:34 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2wXtS017725;
        Wed, 11 Nov 2020 02:58:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:33 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1 00/14] mpt3sas: Add support for multi-port path topology
Date:   Tue, 10 Nov 2020 21:58:24 -0500
Message-Id: <160506295512.14063.14383177524011081284.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Oct 2020 18:38:33 +0530, Sreekanth Reddy wrote:

> Multi-port path topology example:
> 
>          Zone 1             Zone 2
>  |-----------------|   |----------------|
>  |  HD1 ..... HD25 |   | HD26 ......HD50|
>  | |==================================| |
>  | |               |   |              | |
>  | |              Expander            | |
>  | |==================================| |
>  |           |     |   |    |           |
>  |-----------|-----|   |----|-----------|
>            x8|              |x8
>       _______|______________|_______
>       |            HBA             |
>       |____________________________|
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[01/14] scsi: mpt3sas: Define hba_port structure
        https://git.kernel.org/mkp/scsi/c/b22a0fac8c05
[02/14] scsi: mpt3sas: Allocate memory for hba_port objects
        https://git.kernel.org/mkp/scsi/c/e238e71b6cb2
[03/14] scsi: mpt3sas: Rearrange _scsih_mark_responding_sas_device()
        https://git.kernel.org/mkp/scsi/c/78ca700342a5
[04/14] scsi: mpt3sas: Update hba_port's sas_address & phy_mask
        https://git.kernel.org/mkp/scsi/c/e2f0cdf75253
[05/14] scsi: mpt3sas: Get device objects using sas_address & portID
        https://git.kernel.org/mkp/scsi/c/7d310f241001
[06/14] scsi: mpt3sas: Rename transport_del_phy_from_an_existing_port()
        https://git.kernel.org/mkp/scsi/c/c71ccf93c00c
[07/14] scsi: mpt3sas: Get sas_device objects using device's rphy
        https://git.kernel.org/mkp/scsi/c/6df6be9168f5
[08/14] scsi: mpt3sas: Update hba_port objects after host reset
        https://git.kernel.org/mkp/scsi/c/a5e99fda0172
[09/14] scsi: mpt3sas: Set valid PhysicalPort in SMPPassThrough
        https://git.kernel.org/mkp/scsi/c/9d0348a9d8e3
[10/14] scsi: mpt3sas: Handling HBA vSES device
        https://git.kernel.org/mkp/scsi/c/ccc59923ba8d
[11/14] scsi: mpt3sas: Add bypass_dirty_port_flag parameter
        https://git.kernel.org/mkp/scsi/c/34b0a78532f6
[12/14] scsi: mpt3sas: Handle vSES vphy object during HBA reset
        https://git.kernel.org/mkp/scsi/c/ffa381d6373b
[13/14] scsi: mpt3sas: Add module parameter multipath_on_hba
        https://git.kernel.org/mkp/scsi/c/324c122fc0a4
[14/14] scsi: mpt3sas: Bump driver version to 35.101.00.00
        https://git.kernel.org/mkp/scsi/c/2030745877bd

-- 
Martin K. Petersen	Oracle Linux Engineering
