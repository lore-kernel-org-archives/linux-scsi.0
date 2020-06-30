Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6E9C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 03:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E12206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 03:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bjSm9L24"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgF3DZa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 23:25:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53060 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbgF3DZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 23:25:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05U3IFam019543;
        Tue, 30 Jun 2020 03:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=E2/cZwzntc6UkA4LxFJ4tJ6SugI2EpiQCMXc3JYXnUk=;
 b=bjSm9L24TOhRSB54hMOBjGmaBnJ7qWcjGn1rZkYfm6Y/+xYgJnp0TDnRp0wWNtN8CMkv
 WgJgHdi2imjYW0KUVp43mxHBJFYSXQalxoF3wNTFl2anH5DSRNvIUkRLbV0NKe5kx9gi
 rnVVdHeXDzHZMhEu35DmwQ/8bjkxC0sNCoW6P3Xj+vosWvcxFNqJKUKSqgs6u3uBs0cD
 EJC35OdMnSHOBP6EQKKAeBHB50cNOeLWbRTCOOtiC4gO9fGCPqumEvSCGD8/PYEh72kL
 uEN6+XA6rZSoKSYk0IW1QgwXxy97ieyddTj/OHfITtSmMyeqyo2ZGq2Mc5CPpdqOXT1R og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31wwhrhrvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 03:25:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05U3Ie00008179;
        Tue, 30 Jun 2020 03:23:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg123xrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 03:23:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05U3N529001961;
        Tue, 30 Jun 2020 03:23:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 03:23:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        JiangYu <lnsyyj@hotmail.com>,
        Henry Willard <henry.willard@oracle.com>,
        Daniel Meyerholt <dxm523@gmail.com>
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix crash on ARM during cmd completion
Date:   Mon, 29 Jun 2020 23:23:03 -0400
Message-Id: <159348736490.22355.1210827363211730704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629093756.8947-1-bstroesser@ts.fujitsu.com>
References: <20200629093756.8947-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Jun 2020 11:37:56 +0200, Bodo Stroesser wrote:

> If tcmu_handle_completions() has to process a padding shorter
> than sizeof(struct tcmu_cmd_entry), the current call to
> tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as
> length param is wrong and causes crashes on e.g. ARM, because
> tcmu_flush_dcache_range() in this case calls
> 	flush_dcache_page(vmalloc_to_page(start));
> with start being an invalid address above the end of the
> vmalloc'ed area.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix crash on ARM during cmd completion
      https://git.kernel.org/mkp/scsi/c/5a0c256d96f0

-- 
Martin K. Petersen	Oracle Linux Engineering
