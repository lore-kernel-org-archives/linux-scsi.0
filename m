Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A4BC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA5020BED
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cyVeSnv+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgIJCSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:18:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730108AbgIJCMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:12:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2ASsc101063;
        Thu, 10 Sep 2020 02:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=xq8O6+Mkgoe5Tzj4VMvD/cUTVj2LNoCaJIQm11Ox3Mo=;
 b=cyVeSnv+W7Pb7yBAVNTmNuHsztNisGUgWm/bSy4TWYjmbz5P7L33JcLUFzPVHBu4ijZT
 Fcdk0sR5HJcw9x7eN77FnF5g5oRJbfwG5nVHxQcucpVkHCnLvDiuE7ba8ZamTXL6y4Tp
 tX2C7Wg1meGGM6Wb1rDeu5GpDm8eU1LHNy4qkWUEUsHglaOtZfFDoLBCnYhwNfZ8oAFT
 0FqqOpU6CG5MDwvUQRwavvCGr1SyC+QvPV2Gp31asoJEhWaQjeRMhpbMWY4FTyoZ/oTG
 Yee+G90aFAI1Vt96/xVX+zU72Bw4S1s8qgtv4tGqjy5/4SYsWdOLPO54QpZ5m3XDIpOF lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33c3an548v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:12:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2Bdd0168544;
        Thu, 10 Sep 2020 02:12:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33dacmdwtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:12:29 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08A2CRj1030256;
        Thu, 10 Sep 2020 02:12:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:12:27 -0700
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH v3 0/4] qla2xxx: A couple crash fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfhi2xdv.fsf@ca-mkp.ca.oracle.com>
References: <20200908081516.8561-1-dwagner@suse.de>
Date:   Wed, 09 Sep 2020 22:12:25 -0400
In-Reply-To: <20200908081516.8561-1-dwagner@suse.de> (Daniel Wagner's message
        of "Tue, 8 Sep 2020 10:15:12 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> The first crash we observed is due memory corruption in the srb memory
> pool. Unforuntatly, I couldn't find the source of the problem but the
> workaround by resetting the cleanup callbacks 'fixes' this problem
> (patch #1). I think as intermeditate step this should be merged until
> the real cause can be identified.
>
> The second crash is due a race condition(?) in the firmware. The sts
> entries are not updated in time which leads to this crash pattern
> which several customers have reported:

Applied to 5.10/scsi-staging. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
