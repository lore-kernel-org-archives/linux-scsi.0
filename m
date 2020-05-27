Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0A0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B06F2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jGfagUdh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE0CNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgE0CNV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2Bbvj092013;
        Wed, 27 May 2020 02:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=bkxdgMXnQsFkc/GlabFElXptbPZB2QodVCWZ/poltOI=;
 b=jGfagUdhSzFkBTVjWsuupq3CuCx3md4yMFKUIV96tsRgdJ6ofdbGUj62ExhT1v+SZnkD
 91k4xJ+aE2ysGrXiWngYmiWWPD9jPBYJkJAOKEgyZgNtpGYDgRaIUdVheLrce7zhLYWV
 4wV4LKKUW04NvjR/3N1WHxNgMbIJuPZqklLbCAvCzFlzfMWionjQx/0/w3dnGYaEDZw7
 jZy36z1OML4q/Vb/lnALctjFxh5h2mQn+HYkhm607SjaOm6KtOgHsFQ8aL/zvwdheKyX
 lHWcH0fDOkK+YllRMOhc7A0G4eCIx9U1Q+SAegbmaZvll7pNMh8xP4SQUGGhkJiA/DMY SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8qvxhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27Ziw190059;
        Wed, 27 May 2020 02:13:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 317dktheh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2DGhD020388;
        Wed, 27 May 2020 02:13:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, thenzl@redhat.com
Subject: Re: [PATCH] mpt3sas: Fix reply queue count in non RDPQ mode.
Date:   Tue, 26 May 2020 22:13:01 -0400
Message-Id: <159054550934.12032.9460216996686926621.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522103558.5710-1-suganath-prabu.subramani@broadcom.com>
References: <20200522103558.5710-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 22 May 2020 06:35:58 -0400, Suganath Prabu S wrote:

> For non RDPQ mode, Driver allocates a single contiguous block of
> memory pool for all reply descriptor post queues and passes down a
> single address in the ReplyDescriptorPostQueueAddress field of the IOC
> Init Request Message to the firmware. So reply_post queue will have
> only one entry which holds the address of this single contiguous block
> of memory pool.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix reply queue count in non RDPQ mode
      https://git.kernel.org/mkp/scsi/c/f56577e8c7d0

-- 
Martin K. Petersen	Oracle Linux Engineering
