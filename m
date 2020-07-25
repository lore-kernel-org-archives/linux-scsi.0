Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46B2C433EC
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B6D20748
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y3HDXur8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGYCvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgGYCvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2ljM9049082;
        Sat, 25 Jul 2020 02:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Nk9Y4P1lBGMoakEF/1P13Rylbj7xhKtTYPpTXEOLdd8=;
 b=Y3HDXur88RDoMriRCmdH7z4RSs4dFTLKk6mfrCCuJMen8NQfnkal0VGZQgNoImD2Z8vq
 NSZbpJTF572QzaeDN5hljqPVfnw8UwYGqlMKRoymrrL7lqYc5vjLkYzdD7v5c23JdJEf
 hkAq913tiOEMS3SM8rCeERWF6KIhUpP6PxXoJJEld94MdibL6S3LpSPSPdlpYr9PBckQ
 ANqAPjNf9ZkgO7PA5rjvioBepOPEeYIebLsGkqKSCG9L+Gu6KeS/sT3EBLmsIqCU51jz
 JL0pJ2S7N+aMC/vRvFoTw1TUwOm5bUoq4PoByo6iyo3lvf618WJG2kUoc4BwGcznNT3b 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6kt641y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mPlG001438;
        Sat, 25 Jul 2020 02:51:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32gam27gs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:03 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2p0DQ000946;
        Sat, 25 Jul 2020 02:51:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:51:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v3] SCSI and block: Simplify resume handling
Date:   Fri, 24 Jul 2020 22:50:41 -0400
Message-Id: <159564519422.31464.4004746407722721245.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706151436.GA702867@rowland.harvard.edu>
References: <20200701183718.GA507293@rowland.harvard.edu> <9e824700-dfd1-5d71-5e91-833c35ea55eb@acm.org> <20200706151436.GA702867@rowland.harvard.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 11:14:36 -0400, Alan Stern wrote:

> Commit 05d18ae1cc8a ("scsi: pm: Balance pm_only counter of request
> queue during system resume") fixed a problem in the block layer's
> runtime-PM code: blk_set_runtime_active() failed to call
> blk_clear_pm_only().  However, the commit's implementation was
> awkward; it forced the SCSI system-resume handler to choose whether to
> call blk_post_runtime_resume() or blk_set_runtime_active(), depending
> on whether or not the SCSI device had previously been runtime
> suspended.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: block: pm: Simplify resume handling
      https://git.kernel.org/mkp/scsi/c/8f38f8e0a30e

-- 
Martin K. Petersen	Oracle Linux Engineering
