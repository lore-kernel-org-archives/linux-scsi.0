Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6C9C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7D72065F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xjsk9G6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgGOWOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:14:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47638 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgGOWOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 18:14:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMCx5c130183;
        Wed, 15 Jul 2020 22:14:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=s5J1hHyggPE1UvQsKEZfQqAqW9duy7M6hd/ZEcyIQoY=;
 b=Xjsk9G6CEKeMhKhSSQ/aTfbKnwqFkV4ssiGZlob+ILYyAkKI9qHatReUUx0eyBM0C5+B
 d+evrZ5hER4psvOg/GNu10vmS/4AccAPBgNyJMeVyUf1CcanvmRXo9/h+lodijuEl1N5
 tYg5HcmzgKH7/Tg4S7WgRw2gOb2xt3jHgVLD+u39Zy6kk+lfFXoIcRGtA9hwtSLv96Xj
 G9uwEWkkAeXf4Bf7vS1pp1UzTgwBhnNYuTdBzkVitWCLHW2pquuYfuE0RXJ/OejkNOt1
 udqxhu7HZ7uXwQjqfIbPRaqRWo0+puKOcH8GKTJsWgV8z8w16TkiDZbE8exPjcEv6ri9 hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cme19k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:14:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDkWH087579;
        Wed, 15 Jul 2020 22:14:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32a4cretjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:14:41 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FMEdlQ006002;
        Wed, 15 Jul 2020 22:14:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:14:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Anton Blanchard <anton@ozlabs.org>, jejb@linux.ibm.com,
        dick.kennedy@broadcom.com, james.smart@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] lpfc: Quieten some printks
Date:   Wed, 15 Jul 2020 18:14:31 -0400
Message-Id: <159484884354.21107.10639014399660363650.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713083908.1104927-1-anton@ozlabs.org>
References: <20200713083908.1104927-1-anton@ozlabs.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jul 2020 18:39:08 +1000, Anton Blanchard wrote:

> On a big box the lpfc driver emits a few thousand "Set Affinity" lines
> to the console. Reduce the priority of these from KERN_ERR to KERN_INFO,
> and also fix a few printks that had no log level.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: Quieten some printks
      https://git.kernel.org/mkp/scsi/c/bc2736e98e02

-- 
Martin K. Petersen	Oracle Linux Engineering
