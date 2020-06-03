Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C23C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023F1206E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RkoCDwAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgFCCee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:34:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCCee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 22:34:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532SsfC186047;
        Wed, 3 Jun 2020 02:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5GmeQZysT7OXDXCPVrq0Gz+WWUQybEphX3DXqlt8Mzw=;
 b=RkoCDwANhsH+H214bP7SVpmxInV9sD+FYb5O4fWYPamRVZyNdb+3yBBNDYHX6Dn0Zn+d
 2sI57lunXJ6fYSkTzueHHYSRhTnrJ4+5PeTupmLhwvcYuGnaq3UcK+tOVG8bA94hcd3L
 uH0huQIJwriSGGaYxgMEEYAmwqbAJUA7yCkkK4aDhhs//NVIZ5//HsdahkYtDFYtNXbs
 hmuZOHpnCufn3/BeTGgaclxuFI5whUOpjCK/i2GLG1Arh7EEEWthFAcGM4SCzqvpBki/
 spNJKk4p8XPQmH2JrFdAIeS772qhdTYbwZsQKp/jo2B+aNu9GHODKFTk5YEwBQhEfeZQ /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31dkrukvy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 02:34:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532TG6o131916;
        Wed, 3 Jun 2020 02:32:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dy84db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 02:32:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0532WLuD023670;
        Wed, 3 Jun 2020 02:32:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 02 Jun 2020 19:31:47 -0700
MIME-Version: 1.0
Message-ID: <159114947917.26776.13243682219428913589.b4-ty@oracle.com>
Date:   Tue, 2 Jun 2020 19:31:37 -0700 (PDT)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, thenzl@redhat.com
Subject: Re: [PATCH] mpt3sas: Fix memset in non-rdpq mode.
References: <20200528145617.27252-1-suganath-prabu.subramani@broadcom.com>
In-Reply-To: <20200528145617.27252-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 28 May 2020 10:56:17 -0400, Suganath Prabu S wrote:

> Replace dma_pool_alloc and memset with dma_pool_zalloc.
> This fixes memset accessing out of range address when reply_queue
> count is less than RDPQ_MAX_INDEX_IN_ONE_CHUNK (i.e. 16) in non-RDPQ
> mode.
> 
> In non-RDPQ mode, the driver allocates a single contiguous pool of
> size reply_queue's count * reqly_post_free_sz. But here the driver is
> always memsetting this pool with size 16 *  reqly_post_free_sz. so if
> reply queue count is less then 16 (i.e. when msix vectors enabled is
> less then 16) then the driver is accessing out of range address and
> this results in 'BUG: unable to handle kernel paging request at
> fff0x...x' bug.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix memset() in non-RDPQ mode
      https://git.kernel.org/mkp/scsi/c/61e6ba03ea26

-- 
Martin K. Petersen	Oracle Linux Engineering
