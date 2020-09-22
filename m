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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44475C4741F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1135823AA1
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GFCil31o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgIVD6C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:58:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42264 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbgIVD5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3o1eI149398;
        Tue, 22 Sep 2020 03:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qOodk0KQk1vZKQ2xlK8cUNmUPGu1NbLH+8W31/Ai1/E=;
 b=GFCil31o+lMjvSUOiS90nfBLGXbzek3tBZmSjmodsdLVLJPEz59jcxebZyZyLs4HavzM
 9Mft9+feC0vpjL4SaoRpSVgfVvmyLbWFnAZj4HIrTWGyOvUSE80wc9ZvGifB6HVBCMka
 WNdXXk6MQSr6mdmc9YN3kpaxZ0H84YuvxaU45m4AZ8lcGy4hwfCH/N+QOHVwLqtYbwd0
 E3m7K9HKxtpijJi8FI0YPxX99V6TuY51icHVXmzbSag+RLHcEOiWBkqF2cxaDXQrypmf
 TaK2y93fClJtuXb4nYx73UJ8Yr2UjMrLKP9reny19bDRuq5pRH+7/K4zqc+EXGKet3V/ mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33n7gad5ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uJru149825;
        Tue, 22 Sep 2020 03:57:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33nujmm8ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:43 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vgcV000334;
        Tue, 22 Sep 2020 03:57:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        willy@infradead.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sym53c8xx_2: Delete useless if-else in sym_xerr_cam_status
Date:   Mon, 21 Sep 2020 23:57:07 -0400
Message-Id: <160074695010.411.11566667693725085662.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902061646.576966-1-yebin10@huawei.com>
References: <20200902061646.576966-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Sep 2020 14:16:46 +0800, Ye Bin wrote:

> Only (x_status & XE_PARITY_ERR) is true we set cam_status = DID_PARITY,
> other condition we set cam_status = DID_ERROR. So delete useless if-else.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: sym53c8xx_2: Delete unnecessary else-if in sym_xerr_cam_status()
      https://git.kernel.org/mkp/scsi/c/bb1932dbb83a

-- 
Martin K. Petersen	Oracle Linux Engineering
