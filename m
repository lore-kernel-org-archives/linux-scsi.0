Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD3DC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF95E20774
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O7/mtpNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFJCFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:05:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:04:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A234K5103033;
        Wed, 10 Jun 2020 02:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=FUdwjuiVg3XI+SCI7aOabvDXllYR84w4agJas1BGNQ4=;
 b=O7/mtpNr7Sxnp1ls3GcRwR5mz1EaSvsf56KLo8rwx6CbGwjBRXeZt6L9l7mPl7j6FYsK
 qv5SmgF5GLjkuF5x+VhT3KoGv0l+W7+3SYbBZ8fbulqdpcIZby8tAhHhPxVU4QzBbAgh
 QD/4jAZ+XURr8BOVn30ynBQTBKA2BZV7iZ8P5QG53vuYfXvtn41SzvvmNxewI1dVeDtW
 U8VgmLbBLx2+3GlKvazzP9E8ACQrn5MmG50kMbW9uJhFvt++Z1GNHyciZ3SCzPH/0A1t
 J79Tqtb0gYF5N9tmGBDEyq4gBcFDNF04ukvYOp0Eb92zdIw2KQVUUU/Sl5hH5+TpLyTN jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smyr77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 02:04:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A1wUNM021302;
        Wed, 10 Jun 2020 02:02:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwsbn9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 02:02:54 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05A22rdK018484;
        Wed, 10 Jun 2020 02:02:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 19:02:52 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Denis Efremov <efremov@linux.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-hyperv@vger.kernel.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: storvsc: Remove memset before memory freeing in storvsc_suspend()
Date:   Tue,  9 Jun 2020 22:02:45 -0400
Message-Id: <159175452258.16072.9133246889327928354.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605075934.8403-1-efremov@linux.com>
References: <CAA42JLat6Ern5_mztmoBX9-ONtmz=gZE3YUphY+njTa+A=efVw@mail.gmail.com> <20200605075934.8403-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=879 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=918 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Jun 2020 10:59:34 +0300, Denis Efremov wrote:

> Remove memset with 0 for stor_device->stor_chns in storvsc_suspend()
> before the call to kfree() as the memory contains no sensitive information.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: storvsc: Remove memset before memory freeing in storvsc_suspend()
      https://git.kernel.org/mkp/scsi/c/f47c24033a1a

-- 
Martin K. Petersen	Oracle Linux Engineering
