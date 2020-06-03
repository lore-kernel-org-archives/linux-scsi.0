Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE48C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2658420772
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JNyoW3TG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCCbu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:31:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCCbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 22:31:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532S5tV185727;
        Wed, 3 Jun 2020 02:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=wTAHXXa0EyWEas0pGztCxaujO0q6c7ui61QKlcPS1Hg=;
 b=JNyoW3TGBa63StE4l3BZtbBk5S9HsHJ3dXNWVNYvmeFszazZFzs3eDKQOLN2tCt/3HSc
 8F1EyMhjavhqVBOIWXOyB48W4H/ZZO8ebx/XZ7GnCm/30rNIiMLdzDMIp0OUZztgGgNv
 FoOBynjK8yi8TVBwD5YpHL0n0kiz1BbscpOs24hCyJA2O/+hX9spLXQK/bEz/ZbfPt0W
 2oOtbLr6ZbSfmi867i79iT2E6iHvxofgDWQIKdG/I82aVI8gLIPGOG0REAYVZ/n7fteT
 ine7v3klvQCjsnA8SRF2VjlzbblAsRBQz+Z5/P6qI5bKqezeO8xwQBv5JVvUIOwWM8SA +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31dkrukvrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 02:31:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532S0SA087059;
        Wed, 3 Jun 2020 02:31:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31dju2f0bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 02:31:44 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0532VgYQ023454;
        Wed, 3 Jun 2020 02:31:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 19:31:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mchristi@redhat.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range
Date:   Tue,  2 Jun 2020 22:31:33 -0400
Message-Id: <159114947916.26776.943125808891892721.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:

> 1) If remaining ring space before the end of the ring is
>    smaller then the next cmd to write, tcmu writes a padding
>    entry which fills the remaining space at the end of the
>    ring.
>    Then tcmu calls tcmu_flush_dcache_range() with the size
>    of struct tcmu_cmd_entry as data length to flush.
>    If the space filled by the padding was smaller then
>    tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>    an address range reaching behind the end of the vmalloc'ed
>    ring.
>    tcmu_flush_dcache_range() in a loop calls
>       flush_dcache_page(virt_to_page(start));
>    for every page being part of the range. On x86 the line is
>    optimized out by the compiler, as flush_dcache_page() is
>    empty on x86.
>    But I assume the above can cause trouble on other
>    architectures that really have a flush_dcache_page().
>    For paddings only the header part of an entry is relevant
>    Due to alignment rules the header always fits in the
>    remaining space, if padding is needed.
>    So tcmu_flush_dcache_range() can safely be called with
>    sizeof(entry->hdr) as the length here.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
      https://git.kernel.org/mkp/scsi/c/8c4e0f212398

-- 
Martin K. Petersen	Oracle Linux Engineering
