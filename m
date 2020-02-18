Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22BFC34031
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 05:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B66CC20659
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 05:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jywe23hx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgBRFMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 00:12:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgBRFMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 00:12:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01I54CnS175177;
        Tue, 18 Feb 2020 05:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mDBhJkAAKAVLnoy/Bm0ou+gOQNh+hYVLB0LO2jgIz7I=;
 b=Jywe23hx2YSbd1UeW5F14Ctm9r0y0l50BbrH3SBXl/WKM83drCrGl2yLiIGq/5GDRhOj
 CUKXGM0OA4XirYi2hIbgOkNZgDZxVdTGUjErXY2tw5lwF3yVeloNP4+83O960qFS+jyq
 VRU+H/Vr+X9xfGYciD93EDaDqCZUSz6JtoT+57k8v0y5dbg3ZjyCATfIISEkRwicBAo1
 Fo97CDic8OnVWQcVzkNvyP84vk+tlk6eGTP3ZkgPXFsa4t2gK6SsOSKGYvE22cNjcYD9
 ymySsqKfx70CaTMeLdnigs7NQFpwC8Is2wLfLldBLgugbiNd3HH7mVZZJ02HximpYnlb Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y699rk3s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 05:12:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01I5BhEd076075;
        Tue, 18 Feb 2020 05:12:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y6tent1bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 05:12:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01I5CTDm031090;
        Tue, 18 Feb 2020 05:12:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Feb 2020 21:12:28 -0800
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] lpfc: Add Link Integrity FPIN registration and logging
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200210173155.547-1-jsmart2021@gmail.com>
Date:   Tue, 18 Feb 2020 00:12:27 -0500
In-Reply-To: <20200210173155.547-1-jsmart2021@gmail.com> (James Smart's
        message of "Mon, 10 Feb 2020 09:31:53 -0800")
Message-ID: <yq1eeusmqbo.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9534 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=867 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9534 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=936 lowpriorityscore=0 spamscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> This patch adds the RDF ELS to the driver to register to receive Link
> Integrity FPINs from the fabric.  The driver also adds logging of the
> elements contained in the FPIN before delivering it to the scsi fc
> transport.
>
> As part of the patch, the uapi/scsi/fc/fc_els.h header is updated with
> the FC standards definitions for the RDF and FPIN ELS and their
> components.

Applied to 5.7/scsi-queue with kbuild fixed rolled in. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
