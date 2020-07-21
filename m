Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555C3C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34DE3207DD
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2LiRLDr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGUDmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:42:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgGUDmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:42:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3cHj8111710;
        Tue, 21 Jul 2020 03:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=SNhFR3I1kr+9D/WvtQLSjyzSMnHaUYxgte49Q6HYWuQ=;
 b=R2LiRLDraiWhE+8yPhX532eD+q2yZE3PuOXDxozICl5DQlthinvNzo5I+CbFIxncFzFk
 XK/VL3H9+j+OETIcooDMD+Wm9JpzsickvHgrsoaUPqPbng1XzaXLVjCqFii8/oeb1KTR
 gRPJ0MutXEXlMZi5Iie1LqhG+kMjdvMETnQexj7zLArTdS5c3YDdF+5H5w91Yz3Rka9r
 rfuGcu56Aee7+08Oh8d+gyXRNtWwjAqS9YDU1xNhZpJSZJD+rfx4kDMX4RQCoDpYTa9Z
 y+/7HfuDxuAQjwFBQLq2pVii0bd7n/qD3oeSWHBZM9agXgYroqdPO4SEzhbBV5Z8BZpL fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1madya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:42:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3ftl7016892;
        Tue, 21 Jul 2020 03:42:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32dnafps9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:42:01 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L3fYb9015299;
        Tue, 21 Jul 2020 03:41:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 03:41:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org
Subject: Re: [PATCH V2] scsi: core: run queue in case of IO queueing failure
Date:   Mon, 20 Jul 2020 23:41:33 -0400
Message-Id: <159530287457.22446.16464616944935759536.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200720025435.812030-1-ming.lei@redhat.com>
References: <20200720025435.812030-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Jul 2020 10:54:35 +0800, Ming Lei wrote:

> IO requests may be held in scheduler queue because of resource contention.
> However, not like normal completion, when queueing request failed, we don't
> ask block layer to queue these requests, so IO hang[1] is caused.
> 
> Fix this issue by run queue when IO request failure happens.
> 
> [1] IO hang log by running heavy IO with removing scsi device
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: core: Run queue in case of I/O resource contention failure
      https://git.kernel.org/mkp/scsi/c/3f0dcfbcd2e1

-- 
Martin K. Petersen	Oracle Linux Engineering
