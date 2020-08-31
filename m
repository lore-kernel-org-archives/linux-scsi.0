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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F5AC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74B72071B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BNO6fdnM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgHaRlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:41:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34412 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgHaRlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:41:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHU4sM143395;
        Mon, 31 Aug 2020 17:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=sdMVqMid/g3wPdDjL6h1OE4R752vt7FE0OPwRbalVCE=;
 b=BNO6fdnMgyfjmiTNRF8k6PUZgR777x6xOOSg9nEs/WszXWJdIeMYEf9Y99kGzFZSCW6o
 1F/c9kb6tEgoOhYfCONXsOM0oC9CW/iFF06vZn/oIpOkvRcXMSQwv/uuv7kMqbaIYV8G
 FdcMQk6uMsRUKP1V7mE2naancSXErmYpBFYHT1rHLxs3qKDwy4QUbVD3T7RxBRYHd/pA
 zYLuvivPouVo25CXJoNWRPGsM3nr8w71kY7fOdFI51lPEbuymk21f22TkcCq/xgmV4U/
 H4tG9bi/7J9rEzzxNKcPQl2Ep/cIUXpCTE/5QkNpAN3dGOlTx4jq5geoJSR6kgKtcOga 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eykyjg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:41:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHeY3D165590;
        Mon, 31 Aug 2020 17:41:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x0v0u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VHfF7K018200;
        Mon, 31 Aug 2020 17:41:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bradley Grove <linuxdrivers@attotech.com>,
        linux-scsi@vger.kernel.org, Alex Dewar <alex.dewar90@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: esas2r: Remove unnecessary casts
Date:   Mon, 31 Aug 2020 13:41:02 -0400
Message-Id: <159889566025.22322.2756105346317546336.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820181411.866057-1-alex.dewar90@gmail.com>
References: <20200820181411.866057-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 20 Aug 2020 19:14:11 +0100, Alex Dewar wrote:

> In a number of places in esas2r_ioctl.c, the void* returned from
> pci_alloc_consistent() is cast unnecessarily. Remove casts.
> 
> Issue identified with Coccinelle.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: esas2r: Remove unnecessary casts
      https://git.kernel.org/mkp/scsi/c/32417d7844ab

-- 
Martin K. Petersen	Oracle Linux Engineering
