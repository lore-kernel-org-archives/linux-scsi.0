Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FB2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29CE220786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="egh1QhFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgGHGHR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGHGHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068670fT045761;
        Wed, 8 Jul 2020 06:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BpAejjNrXOGz/rfEwLFUwZE4XzC/WNmhEc3f1yT+1bc=;
 b=egh1QhFJ6ClkNFUGK4O3YKDh9jBOUWEqsg+63pq6xiZDrC6eR9IwihF9NCnWST8ZBocG
 V9x+e7jyuPoRj4apCGbcy7hzMBcltk/rWvBNK9Fb0SMlDATfq1sIUYAIrR/on9sU+kCy
 1tOaNv8gfU5s3FGP4G8T4Xk1ocPl7HokoMSOqJXUsuHkp+dxc+8e12aG5Le6sJOwHnq6
 qsPqgeA6RRsxKS1ffQTlelPvMp87RwGXSiRUWeJbyOK0i1eCukkn7DXMZyKgRKlgW2Pg
 4JpXkL5XWAhStzcA9/YPBaKS9IkJPi4n1xBeOVseePGLsXZIw2k2iev1nVfcyuldVXao qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 322kv6g9hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685xB2F063801;
        Wed, 8 Jul 2020 06:07:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3233p4k2sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 068677eq011522;
        Wed, 8 Jul 2020 06:07:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:07 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        Andres Beltran <lkmlabelt@gmail.com>, wei.liu@kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        mikelley@microsoft.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, parri.andrea@gmail.com,
        linux-kernel@vger.kernel.org, skarade@microsoft.com,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH] scsi: storvsc: Add validation for untrusted Hyper-V values
Date:   Wed,  8 Jul 2020 02:06:52 -0400
Message-Id: <159418828151.5152.8891996577117678598.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706160928.53049-1-lkmlabelt@gmail.com>
References: <20200706160928.53049-1-lkmlabelt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 12:09:28 -0400, Andres Beltran wrote:

> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that
> Hyper-V has sent to the guest. Ensure that invalid values cannot
> cause data being copied out of the bounds of the source buffer
> when calling memcpy. Ensure that outgoing packets do not have any
> leftover guest memory that has not been zeroed out.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: storvsc: Add validation for untrusted Hyper-V values
      https://git.kernel.org/mkp/scsi/c/0a76566595bf

-- 
Martin K. Petersen	Oracle Linux Engineering
