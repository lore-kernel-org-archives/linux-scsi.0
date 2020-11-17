Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF29FC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7229C2468B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:57:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XajkD24v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgKQD4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:56:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgKQD4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:56:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3dvHZ166136;
        Tue, 17 Nov 2020 03:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=k78HJVH6abX6dGonUUcLQUJZtzYGy/GNj74+82yaRGk=;
 b=XajkD24v0gKNwpvuAJQznAsfeMmscrSVcbHIZT0Qs8CyT9gmHUDXfSxGHX2Z1qvwJ3D8
 9mzlXB4RPbJJIeN3GSlM2dPhuOjQK234IrXCQ7B3LB+zG7LA3euqL7/Mkg18Y2jA115n
 W+h0nR3dVa2nUmGNAtWbZIUYL0h7EBUmeneowhzyDg+OSKn+WmcVxPx2uvur+iHdAJVg
 tQRPpv55/W74wcA/6gtTyUg748jViM8G1OtuTGw6T5GHHU5ovn/ektUyHTHV1Md11CR9
 jF4Ju2vcpk+AG7/bu38j0Ze7bh88TegGV7WG5o+Y/9wbspQsFu8CsbebQORDIg/pT/z/ EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34t7vn0cdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:56:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3db4f117417;
        Tue, 17 Nov 2020 03:54:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34uspsu1ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:54:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH3sJhq022399;
        Tue, 17 Nov 2020 03:54:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:54:19 -0800
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: remove obsolete variable in sd_remove()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft5863ku.fsf@ca-mkp.ca.oracle.com>
References: <20201116070035.11870-1-lukas.bulwahn@gmail.com>
Date:   Mon, 16 Nov 2020 22:54:16 -0500
In-Reply-To: <20201116070035.11870-1-lukas.bulwahn@gmail.com> (Lukas Bulwahn's
        message of "Mon, 16 Nov 2020 08:00:35 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lukas,

> Commit 140ea3bbf39a ("sd: use __register_blkdev to avoid a modprobe
> for an unregistered dev_t") removed blk_register_region(devt, ...) in
> sd_remove() and since then, devt is unused in sd_remove().

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
