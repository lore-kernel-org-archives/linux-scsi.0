Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3138EC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CD72071A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SpFlqXkN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfK0CgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:36:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfK0CgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:36:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2YnSI033614;
        Wed, 27 Nov 2019 02:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=GMq7BI6yWZXEOrRRFaFNchE5PxIsS7THCXUCjNpndkY=;
 b=SpFlqXkNjt2o4jE8S43sNGpMzNnUt0gPFOpv2W2yUFWYuCBko80n0gJC0bW4Drgn9srW
 x5LPYhLbwyB3RuczKiBul+45Yxe0ZMp/z2SpxPSxpSo95dzTGG+HEKxzHX9E/dGYxcaR
 FedffhBgpGNcdLDkUN4/dpN/J3Lg543mkpYJ3Rnlat1VAhwrj80+F71Ndz2hXp1L8ZsV
 U8wwsuzlIpPnRhny+xiKJIW7/Jbss2lCcAbjTQkrdlBr6DTYVbMCBk7CQIFgkhUOD+YX
 5xK2DhmqNyqFGjZa5YLHgHVKZIhqmvFCIRcDYYGosDQZzYbz1ekizYpLu8rXqX5ZX7pz zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wev6uafvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:34:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2Y0Xp154064;
        Wed, 27 Nov 2019 02:34:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wh0rfg3du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:34:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAR2Ylv6022860;
        Wed, 27 Nov 2019 02:34:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 18:34:47 -0800
To:     Martin Wilck <Martin.Wilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Hannes Reinecke" <hare@suse.de>
Subject: Re: [PATCH 0/2] scsi: qla2xxx: Fix rport removal after unzoning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191122221912.20100-1-martin.wilck@suse.com>
Date:   Tue, 26 Nov 2019 21:34:44 -0500
In-Reply-To: <20191122221912.20100-1-martin.wilck@suse.com> (Martin Wilck's
        message of "Fri, 22 Nov 2019 22:19:19 +0000")
Message-ID: <yq1tv6q82t7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> These two patches fix similar problems that occur if an initiator port
> belongs only to a single zone, and this zone is removed in the fabric.
> The driver doesn't notice the ports being removed, and the device
> nodes persist in the host, yielding IO errors when accessed.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
