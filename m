Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EB9C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46D62168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pmqVRfGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgKKC7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:59:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgKKC7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:59:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tPQL060479;
        Wed, 11 Nov 2020 02:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=POuA8wsCyFofRgx0QK/htePzZ38pdmuCLsGk+bYlo5c=;
 b=pmqVRfGglxw2BzIdpbgWYUse1uTUV2bIo9y58rZf+KZA9++AtDAzRCgl8b7NkKrfmgpt
 FoojA6UVQFXYqZd9ruJNf0Ytq75BdSJ+vDmvBfChRuJiOSHDTPdO3oRccxSlrAu+KBxD
 zjji7bKavBR9w4CHLZDAXGBpHx/4GXcR7hUymKea4RazVYv98mOp3ACLWhsilnfLMaB8
 yhIijMr7D8Cr+m+4ZVB+L0izEREHEQskJoxomx3PBZ1wHQ/HW2s2nrgfIKOH50GBEryB
 uss3Aujst6NLxfmiSOXX1PC6ufTRTDFq9KxEF+GczSOI86hOyu69vUb3nn/BrdchsNk0 fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72en4c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:59:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tDMC057896;
        Wed, 11 Nov 2020 02:59:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55pdnwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:59:16 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2xE9L024559;
        Wed, 11 Nov 2020 02:59:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:59:14 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sathya.prakash@broadcom.com, "trix@redhat.com" <trix@redhat.com>,
        sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] message: fusion: remove unneeded break
Date:   Tue, 10 Nov 2020 21:59:09 -0500
Message-Id: <160506354082.14637.448922426128665277.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019191950.10244-1-trix@redhat.com>
References: <20201019191950.10244-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Oct 2020 12:19:50 -0700, trix@redhat.com wrote:

> A break is not needed if it is preceded by a return

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: message: fusion: Remove unneeded break
      https://git.kernel.org/mkp/scsi/c/b9dd44fd79a1

-- 
Martin K. Petersen	Oracle Linux Engineering
