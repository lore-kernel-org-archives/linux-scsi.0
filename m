Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16B7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E56C2078A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:09:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bb32ir4B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGHGJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:09:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgGHGJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:09:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0686703Y097509;
        Wed, 8 Jul 2020 06:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=DAaz/FHwX3GCxO54YXJCsA3hVpbYTWyiFcrmoUtYGbY=;
 b=bb32ir4BRw9u+h5SQGIWraBV3L2FdH3fAJNO7Wt+6gcJh7CSt5WBytmEvE1Zg/kctJAE
 M2Lu94G+dI58ttkdWT+vWoo0wcHK4WH79pNkwxss+BPeYsfOrbQWDoQCmJ4eqsBnEu6i
 sTdiDIGbtToaCFCoj+DHmeNFn2J7ApCFRxRhXFJfIM/9TM9XAIiX8QMHak9CJxbAlLUV
 aTWXgHJ8L6p5ws+ZQBUeiXRgMKtHBwXXEj2xpBncn7umpU9mJbdON5D3iHBNKi4GlmH8
 ovIm0K5OvbRKLJO1V1BL+nv2sTdN7lMI05YHftUODqLUYWwoHqAQW6VU2g8wcA6KEghK YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 323sxxvr1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:09:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685x9q0145363;
        Wed, 8 Jul 2020 06:07:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 324n4se4vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:16 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06867FEM016690;
        Wed, 8 Jul 2020 06:07:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, ganji.aravind@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH] scsi: cxgb4i: add support for iSCSI segmentation offload
Date:   Wed,  8 Jul 2020 02:06:56 -0400
Message-Id: <159418828151.5152.15429975254620686981.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1593448871-2972-1-git-send-email-varun@chelsio.com>
References: <1593448871-2972-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=667 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=687
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Jun 2020 22:11:11 +0530, Varun Prakash wrote:

> T5/T6 adapters support iSCSI segmentation offload.
> To transmit iSCSI PDUs using ISO driver provides iSCSI
> header and data scatterlist to the adapter,
> adapter forms multiple iSCSI PDUs and transmits them.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: cxgb4i: Add support for iSCSI segmentation offload
      https://git.kernel.org/mkp/scsi/c/e33c2482289b

-- 
Martin K. Petersen	Oracle Linux Engineering
