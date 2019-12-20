Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD480C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 03:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CBFE2467E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 03:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bdY039DL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLTDge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:36:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLTDge (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 22:36:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBK3YnhZ042221;
        Fri, 20 Dec 2019 03:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=zoMuSZvtvFAWIMEVfR8sDF83B9yZipWb2/Ob6cXBjQA=;
 b=bdY039DL6XUcacxEAx2zGirOrR2ViG+qDNmAT3Icp64tPDLJ+zLrXw2kQabtrgVnln7B
 yd5kWzeC5CrrlO1Jbm72wNb4sFIEY8PiGbNzourtJMXaKUlytqopE+mhnmLuuRskBk1Z
 /LQ25MzulsWTu8zUMqLFvj9fDAbfLcFs2yoTtLqNQjkYlzzKKiET4d2BqKkQgINf29S5
 yjm8rqG5hqhtkNQtDzmz8M0jIfI0yPUly6YnWolgqepYgnvcgC15Ye+CZD7qxC8I5ARB
 BNgLHwEdsjZthmx642sYG/SCT4NvmXt/LxGtyTRiDyA6kgvwgt/bpogz0YxBlf+YR8ab uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x01knpdyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 03:36:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBK3YK30050556;
        Fri, 20 Dec 2019 03:36:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x04mt7sbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 03:36:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBK3aPvI003586;
        Fri, 20 Dec 2019 03:36:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 19:36:24 -0800
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/14] qla2xxx: Fixes for the driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191217220617.28084-1-hmadhani@marvell.com>
Date:   Thu, 19 Dec 2019 22:36:22 -0500
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com> (Himanshu Madhani's
        message of "Tue, 17 Dec 2019 14:06:03 -0800")
Message-ID: <yq11rszacsp.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=964
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912200024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912200024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> Please apply this series to 5.6/scsi-queue at your earliest
> convenience.

This had a few conflicts due to the large qla2xxx series that went into
5.5/scsi-fixes.

While the conflicts were relatively easy to fix, I ended up rebasing
scsi-queue on top of v5.5-rc2. I had to redo my tree anyway to drop the
MediaTek patches so I decided to take the opportunity to minimize the
qla2xxx delta.

Applied to 5.6/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
