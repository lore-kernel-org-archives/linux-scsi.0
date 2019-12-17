Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DB5C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 02:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629A021D7D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 02:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZJbSmQl+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLQCtk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 21:49:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfLQCtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 21:49:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2nBuE100388;
        Tue, 17 Dec 2019 02:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6Dw/6QEafOj9ykXN3RsietDgQiqYwUUa6oCGWlOI9fs=;
 b=ZJbSmQl+XH3G2lwSkWZa3gaZGw20awPAyLL+jFuZUQ6ULqkVokJoxMQWoAiD8SQo3zy2
 OsnQqQ0fa1YUksLR+gm5rWZ5A7FBkUMawhXvn6ZPmWjZShz1yk2k2gTvyjwW04GLwh9O
 5eBtE02PAKs40mnebuYG/p4NGIQKi4SlhXrQiyRPFZMt+2eAipbDR2kd4i0d3K5PokhC
 IwmIzrwXrSMIOmXCXfZ08Ura5OFL1OCoeWbBIUT69WIXzq26bBfI+rLIrk//nvIFhE3u
 ltKXJu4loZDVDSODA6ESD0xjSZPseMr9/mELJUn621GbT2FKHUL60rv+ENR3WZQ9ujMA ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wvq5ubpy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:49:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2i9A6105960;
        Tue, 17 Dec 2019 02:47:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wxm5j5bu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:47:15 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBH2lDq9013230;
        Tue, 17 Dec 2019 02:47:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 18:47:13 -0800
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
Date:   Mon, 16 Dec 2019 21:47:10 -0500
In-Reply-To: <541a7ddd-f4c9-5d5f-4f43-0ae5bc46aef6@roeck-us.net> (Guenter
        Roeck's message of "Thu, 12 Dec 2019 20:18:11 -0800")
Message-ID: <yq1tv5zhdn5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> Not sure I understand what you mean with 'bazillions of sensors' and
> 'sensor per scsi_device'. Can you elaborate ? I see one sensor per
> drive, which is what I would expect.

Yes, but for storage arrays, hanging off of struct scsi_device means you
would get a sensor for each volume you create. Even though you
presumably only have one physical "box" to monitor (ignoring for a
moment that the drives inside the box may have their own sensors that
may or may not be visible to the host).

Also, multi-actuator disk drives are shipping. They present themselves
to the host as a target with multiple LUNs. Once again you'll probably
have one temperature sensor for the physical drive but many virtual
disks being presented to the OS. So you'd end up with for instance 4
sensors in hwmon even though there physically only is one.

It's a tough call since there may be hardware configurations where
distinct per-LUN temperature is valid (some quirky JBODs represent disk
drives as different LUNs instead of different targets, for instance).

How expensive will it be to have - say - 100 hwmon sensors instantiated
for a drive tray?

-- 
Martin K. Petersen	Oracle Linux Engineering
