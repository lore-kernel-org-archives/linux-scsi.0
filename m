Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86793C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB4B207DD
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DsdcHHi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEHBNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 21:13:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHBNR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 21:13:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481CEOX134982;
        Fri, 8 May 2020 01:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Jm7eM0CBpqIC72WVxHpncLVhSVpIqeAoQG2VS1okfMg=;
 b=DsdcHHi+QoBSpPGFJJSjOQWE0UzCxsHru+9/2TlNOjV3zgE1n2nCUfvt+vnsY96gtVJ8
 Ifp9+skBnZOGgkPuuJHGN7lXFg3vTmzHjpBPUyO2vDE9L/VQNTa7WBuO4P5J9UZfB0ZM
 Os+ZfrYCwRdBz4IYNFhPVuSpwWYyEH9tXvBOJ0w+/ETfD4Nq8lHy1ttoKWUaIHsv0Qhd
 /i9q/I9atR/Bljp61IFBncFakGQTRRMd8DvrFeg2EQgZlpbp3V2EGcIqIk2vH7obSRaL
 pzf9yYafkJBe9s56cXE1Zo2/y7vSwXkkDG/QGj3zcS4Bliq2TsR5Sqx9gAUu75ZJELM8 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30vtexrh92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:13:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481BqDo153977;
        Fri, 8 May 2020 01:13:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30vtebc11g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:13:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0481D4Bt029176;
        Fri, 8 May 2020 01:13:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 18:13:03 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: remove 'list' entry from struct scsi_cmnd
Date:   Thu,  7 May 2020 21:13:03 -0400
Message-Id: <158890033829.32194.11659940518365393598.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507062642.100612-1-hare@suse.de>
References: <20200507062642.100612-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=738 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=799 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 May 2020 08:26:42 +0200, Hannes Reinecke wrote:

> Leftover from commandlist removal.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: core: Remove 'list' entry from struct scsi_cmnd
      https://git.kernel.org/mkp/scsi/c/646d4b507626

-- 
Martin K. Petersen	Oracle Linux Engineering
