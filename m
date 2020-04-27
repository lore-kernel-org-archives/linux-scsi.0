Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87718C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D03C2087E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sUElo6wU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgD0UXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:23:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgD0UXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:23:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKNS7s144896;
        Mon, 27 Apr 2020 20:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EudmnGcySPS8EIjkWcSXHuZ7qHQcbnqbMBBI5yHftsQ=;
 b=sUElo6wUAEcHtFAoSgnNRQrL4DdMYpYptxr/4Z5zIoenWIFF+75KBc6qhviTfeT0KMiP
 n/0VDmK/z+UQPP8Ykn2TeWuo4KoYaSRnh2wC7p0VyAdRcFefDmJPT1BbIC09DxR26DQ2
 pXmwu1JT+y/SSmLl36H2qD1LIqyufNnPH1/ypKza9weNlccSQCWag+w/Uk6LdxmEU3gN
 stY+vjruuEmh6SZbttzOYIHK9oLTgcl0h16IxodMWEz3v+GExGlZRUhiggKdTrXOI1zB
 /eUvXMzI5p/4cCWAHzalpbWfPofog0/tyYadRf/xcnBZTXE8cGrAbS4+EQjjEaVWIzji Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p01abt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:23:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKBwhR078266;
        Mon, 27 Apr 2020 20:21:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30mxrr066w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLSZ3006401;
        Mon, 27 Apr 2020 20:21:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:28 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     brking@us.ibm.com, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        Jason Yan <yanaijie@huawei.com>, ming.lei@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: ipr: remove NULL check before freeing function
Date:   Mon, 27 Apr 2020 16:21:17 -0400
Message-Id: <158777063304.4076.4058045292916633331.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200418095903.35118-1-yanaijie@huawei.com>
References: <20200418095903.35118-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=841 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=912 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Apr 2020 17:59:03 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/ipr.c:9533:2-18: WARNING: NULL check before some freeing
> functions is not needed.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: ipr: Remove NULL check before freeing function
      https://git.kernel.org/mkp/scsi/c/2e9ef0fcac01

-- 
Martin K. Petersen	Oracle Linux Engineering
