Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72ECC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97DA82075D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QENi2opK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgHEBR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:17:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHEBR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:17:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751C2qD135547;
        Wed, 5 Aug 2020 01:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zQs+pT64RxtSTUDQB3wwLi5w19TqBgvgH2P7d1bcsn8=;
 b=QENi2opKS30oyF+rgsyk/LrC/9vw7OfxHSUv82OYKDuD8z3yDdDgVwVD7D18JH8xU8Ps
 P7gCdbz/iOufV1NiCldNsoJ6hGitubgRUOGZePwkmGRAPbEEPrgM9x0/k7VLJ8S6YBQk
 zOd2dckptIynRvEyMcfD2aKRJA7wO5HaqxiW1OuEM8nu7Dd/yA4NouEbjLnrCW5hlqEX
 6rMbgyz9bQxJJlxHqrtDfi1bbGM7t8n8jZvxxnjEyGHzneFtXQbd0EoUt4AFv8dnN2mF
 q1D4rjU0boRzsO2rqBRMFUtJeWmvgA3nb5Y7ca1nRvqm74qpYpdKw9WwSA9F7bcsQFfG tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32n11n7aps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:17:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075198kM088131;
        Wed, 5 Aug 2020 01:17:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32p5gt1mxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:17:43 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0751Hf0C007535;
        Wed, 5 Aug 2020 01:17:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:17:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sagi@grimberg.me, target-devel@vger.kernel.org,
        michael.christie@oracle.com, linux-scsi@vger.kernel.org,
        bvanassche@acm.org, Max Gurtovoy <maxg@mellanox.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        oren@mellanox.com
Subject: Re: [PATCH 1/1] target: make iscsit_register_transport() return void
Date:   Tue,  4 Aug 2020 21:17:33 -0400
Message-Id: <159659019689.15726.3035694434346153928.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803150008.83920-1-maxg@mellanox.com>
References: <20200803150008.83920-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 3 Aug 2020 18:00:08 +0300, Max Gurtovoy wrote:

> This function always return 0 now, we can make it return void to
> simplify the code. Also, no caller ever check the return value of this
> function.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: Make iscsit_register_transport() return void
      https://git.kernel.org/mkp/scsi/c/a8ac78357d9b

-- 
Martin K. Petersen	Oracle Linux Engineering
