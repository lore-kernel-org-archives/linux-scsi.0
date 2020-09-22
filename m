Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C58C4727E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 21:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5D5238A1
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 21:48:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gby6ot6f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIVVsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 17:48:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVVsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 17:48:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MLinPY025484;
        Tue, 22 Sep 2020 21:48:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=kOFwo0AKDlbaaVc1Roe2utwhJxrlM2QMekMD8jMCAQY=;
 b=Gby6ot6fE+vkkDLMBs7m1wK0NLdG6VFPv8Boq488cU/XoTBGmakubebCFKaI/2XK18xb
 sgC7/0sWrCS85XHD9oRWOtkglltiw6CuqeD3Le4cx+aWGShmY6vNtRI3w1LZZnKMmyVW
 EfAiS3K5ZyKzIJeBUx27aQH1A+aOyAwnRVHa8PZKbEpYBiUqG4Iu2N8zNccUAH5NtweS
 9n3lmBhj8edKcRFvmsneIEHMg8q4SJV5MHDZMRc1Eah4W46Z8mq1TkSVcVHaY53OVQjP
 0QJVz77oxmcS288R3YCibRm0NC6J361E98nXD4dS1MIiNXjX8hwOKUbF6MlL4w0FVZ9C QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnufc98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 21:48:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MLkNgt027621;
        Tue, 22 Sep 2020 21:48:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33nurtm7qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 21:48:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MLmLdx014752;
        Tue, 22 Sep 2020 21:48:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 14:48:20 -0700
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCHv3 0/4] zoned block device specific errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh5ho585.fsf@ca-mkp.ca.oracle.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
Date:   Tue, 22 Sep 2020 17:48:18 -0400
In-Reply-To: <20200917231841.4029747-1-kbusch@kernel.org> (Keith Busch's
        message of "Thu, 17 Sep 2020 16:18:37 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=799 bulkscore=0 mlxscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=831 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Keith,

> Zone block devices may have some limits that require special handling.
> This series provides a way for drivers to notify of these conditions.

This looks good to me. I already queued patch 3 so please send a v4 with
that patch removed. The rest should go through Jens' tree.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
