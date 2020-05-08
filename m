Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01F1C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE1A320731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bx3ZzPg6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgEHCy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:54:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHCyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482rS46067481;
        Fri, 8 May 2020 02:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=O8AHGGNMkALrYrBz5fSlt6CqdAEffrJbKFHCzAsfu7Q=;
 b=Bx3ZzPg6uCNkp6lEoXYlE+eOdq5jLF4rnVjLIQ/GyxFj2cK1cSW/eUy07OBtwdocbQXi
 YXunzMmSSAZPnseIQj6L8cLRQoMF0QZ4kF86OdHHkMQHhvgd09t5uFEA/dkUu9viDf2d
 WMQvdVIuX91lMLT0XcUruLgInK7j2Ef2CY9ucm9WTo07sHIXaDlx35DXJ47Jv9z0oeI1
 Y7fItEkLgU5CeKs8mqu7JgAiI8sfvRqUn7VRzuTfaEr1KjSXE03CB7wwQpWnPCQXWPXk
 owT1ibKsacS0vU+reWTCim3g9gKzrLUHlXZFuAUfUxcCnfzrbTTtLGZB1EbC3yGhxKxs iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30vtepgrm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qhLw012709;
        Fri, 8 May 2020 02:54:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30vtefqnae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0482shg5003643;
        Fri, 8 May 2020 02:54:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:43 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>,
        QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: remove Comparison of 0/1 to bool variable
Date:   Thu,  7 May 2020 22:54:30 -0400
Message-Id: <158890633245.6466.5744996668674372337.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430121706.14879-1-yanaijie@huawei.com>
References: <20200430121706.14879-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=902 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 mlxlogscore=964 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 20:17:06 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/qedi/qedi_main.c:1309:5-25: WARNING: Comparison of 0/1 to
> bool variable
> drivers/scsi/qedi/qedi_main.c:1315:5-25: WARNING: Comparison of 0/1 to
> bool variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qedi: Remove comparison of 0/1 to bool variable
      https://git.kernel.org/mkp/scsi/c/9187745ceec6

-- 
Martin K. Petersen	Oracle Linux Engineering
