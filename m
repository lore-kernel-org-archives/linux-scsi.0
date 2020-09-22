Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD8BC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107DC23A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m5GsWMwv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgIVD5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgIVD5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nQ3j077430;
        Tue, 22 Sep 2020 03:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BOeJpepI4s3LsvoeUB3ZfcZusxYYuPdpsSR2ZKORuC4=;
 b=m5GsWMwv6TJmigfyZGeJVq1fMfu66re4LyzuVcUtQH3kzVeGrOPVcp2W+DeTv0k5zg+Z
 VJNk+/CM89t4WxKdx5fXqO4h29Ln90vWN6yRmxRzn/WTk/tgZZXRRzj3mGygZG+hUn+c
 A5lj81lgksfvLQg5LDxNHLHzl9Vay5/FC9yKtJVs2DjmRCoNQUYpUGy543WsWI4RFyGc
 ghQlcG8AoHs+l4gd32ybqDFw4PijimTygesM//wMxiu29/8uVWhFVV8UG0rQ7lAWJloK
 nymI50/vhUYFkvMOek51P3LT/UvqQo6VJ15Bi/Nne3d6sUF6En3yodjz22IN3Av2NZzY zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33q5rg8t6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tLHG020816;
        Tue, 22 Sep 2020 03:57:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33nuwxk72c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:17 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vH1g032465;
        Tue, 22 Sep 2020 03:57:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] Improve error handling
Date:   Mon, 21 Sep 2020 23:56:48 -0400
Message-Id: <160074695010.411.930812991107872093.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910074843.217661-1-damien.lemoal@wdc.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=819 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=834 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Sep 2020 16:48:40 +0900, Damien Le Moal wrote:

> A small series to improve command error hadling.
> 
> The first patch is a simple code cleanup. The second patch updates
> asc/ascq sense codes list. Finally, the third patch adds zone resource
> errors handling for zoned block deives to return BLK_STS_DEV_RESOURCE,
> similarly to what the NVMe driver does for ZNS devices.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/3] scsi: core: Clean up scsi_noretry_cmd()
      https://git.kernel.org/mkp/scsi/c/342c81eeaaf0
[2/3] scsi: core: Update additional sense codes list
      https://git.kernel.org/mkp/scsi/c/46c9d608f989

-- 
Martin K. Petersen	Oracle Linux Engineering
