Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7814C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2E82465E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A5y+FHPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLSXvZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:51:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfLSXvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:51:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnLiX109170;
        Thu, 19 Dec 2019 23:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=MBhXGEg1ncXHS1NIT2ZlhXy3anJavD7EHRHX/F7DWrI=;
 b=A5y+FHPPQxUJHUbop87w+8ISrA9lyk8Z55g9MOwGjKAyxTAaw4Dey5iSKpHvVHm+yhxl
 QbOj0Vc7sahRKk3GgpKD1LQtA906BzdEpJ5Ej5LP4hfzDDFlYSzOo/09vTrnoYcjtw1v
 mJdlsT6O2qtgK/bjI7HLF1xasTjby7ukdnoV0h4k4r4lB+I7CRGl2dKSXumlmC4/6n8C
 LV5S48FyrW8GA2PEg1ZVdwYDEISsp8ehg4iWlFVgpHapkpN7ytwDiRKzy9PTPWaK9GGk
 kKYZIa4yLB2fM8tz/kbgwxb/ef92hxcz6SpPBrzHgE39Sjwj+kx0DfBTo2vcFxlwZrTi sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x01jadv6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:51:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNncQe143672;
        Thu, 19 Dec 2019 23:51:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wyxqjfc40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:51:06 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJNp5Mt013380;
        Thu, 19 Dec 2019 23:51:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:51:05 -0800
To:     Israel Rukshin <israelr@mellanox.com>
Cc:     Target-devel <target-devel@vger.kernel.org>,
        Linux-scsi <linux-scsi@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target/iblock: Fix protection error with sectors greater than 512B
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1576078562-15240-1-git-send-email-israelr@mellanox.com>
Date:   Thu, 19 Dec 2019 18:51:02 -0500
In-Reply-To: <1576078562-15240-1-git-send-email-israelr@mellanox.com> (Israel
        Rukshin's message of "Wed, 11 Dec 2019 17:36:02 +0200")
Message-ID: <yq1r20zan89.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=771
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=832 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Israel,

> The sector size of the block layer is 512 bytes, but integrity
> interval size might be different (in case of 4K block size of the
> media). At the initiator side the virtual start sector is the one that
> was originally submitted by the block layer (512 bytes) for the Reftag
> usage. The initiator converts the Reftag to integrity interval units
> and sends it to the target. So the target virtual start sector should
> be calculated at integrity interval units. prepare_fn() and
> complete_fn() don't remap correctly the Reftag when using incorrect
> units of the virtual start sector, which leads to the following
> protection error at the device:

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
