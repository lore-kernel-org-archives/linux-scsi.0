Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4A5C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E02423120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAMFts (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:49:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbhAMFtr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:49:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5jDhg130811;
        Wed, 13 Jan 2021 05:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qPgT6qmqM6VWnaO5L7GXiNS/NRV+/paYlAjkqbjJaPo=;
 b=mK2uzAaO2kTQW4/wNRWJqwXub9221P4QDUUvUsg/DrmpEkrUMeWsTRl2OwZZC/xwZ69e
 Gfa7K1i82wMyy3ztxTUYRiyK0VEPqvkKSdOkuJGNmEQbOqy1ps8dk8g8O83MlW6cEyu6
 PUufFI3ENeFkrH9/1OZWOEzK9y+ZldmtVmy0T56073GhzvG4Md/meKz9HAnn3auIMGQ4
 l5VxbWHBXp/A73ZhYQb7Xa3xrmtSFSqtx3FGo3d4SF3755Sk55xrAoSKXXApo5/HaJly
 fl3nrGPa/VgG3Mj6zgScD6YFHcJMJAP0HUqXsLfJkAWTDXb9f8pg0VAKbHpOl75a1XB+ ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 360kvk1k5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:49:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5e5Db133927;
        Wed, 13 Jan 2021 05:49:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 360kf00pyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:49:02 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D5mtV7028808;
        Wed, 13 Jan 2021 05:48:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:55 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        linux-kernel@vger.kernel.org,
        Sesidhar Baddela <sebaddel@cisco.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
Date:   Wed, 13 Jan 2021 00:48:51 -0500
Message-Id: <161051681548.32710.4649918812732187400.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201225083520.22015-1-dinghao.liu@zju.edu.cn>
References: <20201225083520.22015-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=607 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=618 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 25 Dec 2020 16:35:20 +0800, Dinghao Liu wrote:

> When ioread32() returns 0xFFFFFFFF, we should execute
> cleanup functions like other error handling paths before
> returning.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
      https://git.kernel.org/mkp/scsi/c/d6e3ae76728c

-- 
Martin K. Petersen	Oracle Linux Engineering
