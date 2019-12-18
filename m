Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7355C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 03:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCFF621835
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 03:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jVGSSstu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLRDkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 22:40:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLRDkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 22:40:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI3dbKd117311;
        Wed, 18 Dec 2019 03:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8IAu41A0ROVfnDWMZhCpBuGeJC+jZ2Wigf/4tr6lnzM=;
 b=jVGSSstumhiA6eWydK51KgVcr9RgGcwslrbhh28s0pNJalGmNqBqg2x8/GDGsslkrH9E
 Suzgnc7JfszD2CH+QQ1vgu0XAAHZFVLXbiyr0BzZqeP3ypK9g7SknPmnpE6uPqanM7lT
 UaykzEV+5ZG0i7OFamBFq7NUm+DufGD2i2awn+/YXlE+PBfc1U0kWxPwCEPU0Sts+X+3
 K6kN27SlC+i8DXVvudga8LXIuqzdO91Bgu1S17UCUOtfGcqvwq7aRAXS3AbBlt8p5X7D
 PSXnO6FONm3LwqSUR7Sao8c4pOCYJMwUeuM0nxhnpyTNX7/eo4ngl3u192OPEr7M+0bE wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wvqpqav23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 03:39:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI3dPB7078330;
        Wed, 18 Dec 2019 03:39:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wxm5pbcdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 03:39:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBI3dTJu021649;
        Wed, 18 Dec 2019 03:39:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 19:39:29 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191209052119.32072-1-linux@roeck-us.net>
        <20191209052119.32072-2-linux@roeck-us.net>
        <CACRpkdYjidQHB0=S_brDxH3k+qJ2mfXCTF9A3SVZkPvBaVg6JQ@mail.gmail.com>
        <yq1wob1jfjm.fsf@oracle.com>
        <541a7ddd-f4c9-5d5f-4f43-0ae5bc46aef6@roeck-us.net>
        <yq1tv5zhdn5.fsf@oracle.com>
        <c5689126-46bc-b551-11d7-e5bd8c01f82c@roeck-us.net>
Date:   Tue, 17 Dec 2019 22:39:26 -0500
In-Reply-To: <c5689126-46bc-b551-11d7-e5bd8c01f82c@roeck-us.net> (Guenter
        Roeck's message of "Mon, 16 Dec 2019 20:20:57 -0800")
Message-ID: <yq14kxygv4h.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=790
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=848 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> If there are 100 physical drives, you would actually want to see the
> temperature of each drive separately, as one of them might be
> overheating due to some internal failure.

Yep. However, for "big boxes" you'll typically get that information from
SAF-TE or SES enclosure services and not from the drive itself.

SES allows you to monitor power supplies, drive bays, hot swap events,
thermals, etc. We have a SES driver in SCSI that exposes all these
things in sysfs. It is not currently tied into hwmon.

> If the storage array is represented to the system as single huge
> physical drive, which is then split into logical entities not related
> to physical drives, I guess that would represent a problem for system
> management overall.

Yep. That's why there's dedicated plumbing in smartmontools to handle
various RAID controller interfaces for accessing physical drive
information. It's typically highly vendor-specific.

> I would not mind to tie the hardware monitoring device to something
> else than the scsi device if the scsi device does not always have a
> physical representation. Is there a way to determine if a scsi device
> is virtual or real ?

Not really. Target is usually a pretty good approximation, although some
arrays introduce virtual targets because of limited LUN (scsi_device)
numbering capabilities. However, arrays generally don't support per-LUN
temperature because it makes no sense.

I'm trying to gauge how much a pain potentially redundant sensors would
be for userland monitoring tooling vs. how many oddball devices we'd not
be able to support if we were to use scsi_target as parent (or restrict
the sensor binding to LUN 0).

-- 
Martin K. Petersen	Oracle Linux Engineering
