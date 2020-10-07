Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4647C46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94EB621527
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lK/9bLNs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgJGDs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48314 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727155AbgJGDsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973kVoB175241;
        Wed, 7 Oct 2020 03:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OMmGdkYyrOjvRqwoy+3rv1D/4QKBFrLbQ4HO+65ZcWY=;
 b=lK/9bLNs8Rs/BhjexZ+QhDjd8XRS95ARsAF4J5sqyzOwGqn2ewCZnsvWNXaZnA91vCkf
 n9/zUcAMok5XcOxttVElB8O7cFgb+X0b2eooteYhKsBkxo+LwNIk530y/JR1/+aBWtNa
 KP4DeXmI4fB/wGauJhhg7EGFRtSQbLOf3mH24q62IHc65d51tDn/m38/9CNUb8Xu3GoD
 hWG3n+eGYXL9aedgv2dClj7cTHl6MrfDcmdAop09SSz3A36KCngFBVCBi9iUo7hglKTv
 3lnVOHOx2oVJR9W4PDN9sns47BI6i6Ugunkuh2i4rN180+mQ/1hO7SwyXgPY03A8Nd4Z Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetayn7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ip6h194729;
        Wed, 7 Oct 2020 03:48:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410jy2s20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mBGX012418;
        Wed, 7 Oct 2020 03:48:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:11 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] lpfc: drop nodelist reference on error in lpfc_gen_req()
Date:   Tue,  6 Oct 2020 23:47:50 -0400
Message-Id: <160204240579.16940.18114242753901144761.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910084059.138507-1-hare@suse.de>
References: <20200910084059.138507-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Sep 2020 10:40:59 +0200, Hannes Reinecke wrote:

> If we fail to issue the iocb in lpfc_gen_req() we need to drop
> the nodelist reference.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: lpfc: Drop nodelist reference on error in lpfc_gen_req()
      https://git.kernel.org/mkp/scsi/c/962d359c4d3b

-- 
Martin K. Petersen	Oracle Linux Engineering
