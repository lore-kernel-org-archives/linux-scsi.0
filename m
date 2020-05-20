Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ABAC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC95B207C4
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G/IlBA0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgETCab (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:30:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbgETCaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:30:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2Rjel030444;
        Wed, 20 May 2020 02:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Ye/7nUvUnwXOyEGf9U6RhV+/rNNH4ggW6zh7MyB2T1U=;
 b=G/IlBA0NXIVyUnwqS2bODcwKcoQ2t7W+WCYw07kGlxRoGXuTRHFGcFnpnDtHul3VhBWy
 9L4/92ysviRyavMaZy6P3iXGs0EOrN24O3777/7uy7XE9ePwQiy2l8wIaXv/h6JeeeTp
 LhC+Sh96CGNjhcw3gCqFAH0hP/L2FPTx5XoyIbDP57h3WxFj8P+pUssTG5BRU9UWYHYV
 3VmOf9yClAX7gfuempGTZB+1C8hNrZG7NauKaWtsEl+MwM9tufFLH4TeYtApnEqVig64
 89cqQPqm5537IIDqfmez4PNYsm6WsR2wHYrIaTf/kQKlT18nYcp457MNM2SSMsnWr21k tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284m0m98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:30:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2T3hq052213;
        Wed, 20 May 2020 02:30:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t362a0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:22 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K2UMVF028037;
        Wed, 20 May 2020 02:30:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:21 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Fix incorrect usage of shost_for_each_device
Date:   Tue, 19 May 2020 22:30:09 -0400
Message-Id: <158994171818.20861.6847855039215495249.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518074420.39275-1-yebin10@huawei.com>
References: <20200518074420.39275-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 May 2020 15:44:20 +0800, Ye Bin wrote:

> shost_for_each_device(sdev, shost) \
> 	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
> 	     (sdev); \
> 	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
> 
> When terminating shost_for_each_device() iteration with break or return,
> scsi_device_put() should be used to prevent stale scsi device references from
> being left behind.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: core: Fix incorrect usage of shost_for_each_device
      https://git.kernel.org/mkp/scsi/c/4dea170f4fb2

-- 
Martin K. Petersen	Oracle Linux Engineering
