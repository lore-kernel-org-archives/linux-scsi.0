Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB11C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D0420721
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BUJ79T52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfLIXyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:54:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfLIXyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 18:54:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9Ns6Da020005;
        Mon, 9 Dec 2019 23:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=XzMqQu7kZ/XxO7GcqW1UhqKiq2YGQamaLJHgV1aUj4A=;
 b=BUJ79T52cDW4n1P8RLQUbsdp0de7pmKKaTsUye1zSFXJjYWEPXRQDZ3igTUiOVof8GhQ
 8V/rePW0u3psBfzdk0MHrxYjp5RpA79+I9lFdaH7lA9smBfwdh40tDlIkXfsRmb7RSgL
 O9fey1kcfVqRxm5icxNfBZcOch3Eu0OaDhGHXcr3AwU2OiyFO2wZXJhk9o1jPWOVu6N0
 TGPexbF0lpz48d9BE6iVVohIKdSwEOke783Gdk1NUTT/UIfwmZypI0A6SW8QDM0eNmrm
 YeLYDdd+aTFfmJLNDC7qfiCHHJUZ0YiyZ0Nd/eZwIrz6tx6iJWJqD4Vl3pU75eAmkpVL +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qrarss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:54:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9Ns9C2037866;
        Mon, 9 Dec 2019 23:54:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wsru838s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:54:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB9Nrkjb027569;
        Mon, 9 Dec 2019 23:53:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 15:53:46 -0800
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Evan Green <evgreen@chromium.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <0101016eca8dc8ee-d58c2ce0-2c25-40ee-8ae0-237fce4fa82d-000000@us-west-2.amazonses.com>
Date:   Mon, 09 Dec 2019 18:53:43 -0500
In-Reply-To: <0101016eca8dc8ee-d58c2ce0-2c25-40ee-8ae0-237fce4fa82d-000000@us-west-2.amazonses.com>
        (Can Guo's message of "Tue, 3 Dec 2019 06:58:40 +0000")
Message-ID: <yq1y2vloy2g.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=630
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=683 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090189
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

You seem to be sending duplicates of almost every mail which makes it
hard for me (and patchwork) to track your series. The mails are
identical except for Message-Id:.

Also, don't resubmit patches just to add Reviewed-by: tags. Patchwork
will pick up the tags. Only resubmit if you are making changes. And if
you do, use -vN to bump the version.

> Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an
> unique ID by appending the scsi host number to its device name.
>
> Fixes: df032bf27 (scsi: ufs: Add a bsg endpoint that supports UPIUs)

Please use 12-char SHA and enclose commit summary in quotes. See:

	Documentation/process/submitting-patches.rst

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")

> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
