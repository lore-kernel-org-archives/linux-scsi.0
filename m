Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2591C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 23:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5465214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 23:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="owIJkdWZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbfLLXWT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 18:22:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730965AbfLLXWT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 18:22:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCNJ09m104641;
        Thu, 12 Dec 2019 23:21:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=gL2RVRF5gBvNEMpviEan8qRutQzV9WYQZ6sHqExKWQQ=;
 b=owIJkdWZzawlLdlC4lX52lWskCIAPJTexKl1L09ghjDSYGPxzDys+YG4DCE7W+N3jh6M
 ih0atxUd1KmFDdYYVmqHsoSDSKzUlfkAs5y+Wh4YnG0Xz3mv6pJ+AZUqjz8CmRqs0WpD
 sM+JzUUhx/pzELbcFRsuUrZFB2ym79lCCpuC7+DZFb1mtepd0BmPy0QUr2Yi0UgoUU6Z
 6NFBSsxGF+/aGEEa/Iaoj2VLakJM0G4A0AU9stxR21kPJk0l2Der2domtwnjpsRlbvz7
 BW5BP/hh/xl8nJOXXGzvwqD6laRuzbK16f7xhISWItnF+4Dx1IEfgptvyfSE7AxaoEMM nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4njxat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 23:21:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCNJgtf175278;
        Thu, 12 Dec 2019 23:21:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wumsa5jqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 23:21:53 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCNLqoa015393;
        Thu, 12 Dec 2019 23:21:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 15:21:52 -0800
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
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
Date:   Thu, 12 Dec 2019 18:21:49 -0500
In-Reply-To: <CACRpkdYjidQHB0=S_brDxH3k+qJ2mfXCTF9A3SVZkPvBaVg6JQ@mail.gmail.com>
        (Linus Walleij's message of "Thu, 12 Dec 2019 23:33:21 +0100")
Message-ID: <yq1wob1jfjm.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120179
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Linus,

> It's a nice addition with the SCT command, I never figured that part
> out. Also nice how you register the scsi class interface I never saw
> that before, it makes it a very neat plug-in.

Yep, I agree that the patch looks pretty good in general. There are just
a few wrinkles in the detection heuristics I would like to tweak. More
on that later.

Yesterday I added support for the SCSI temperature log page and am
working through some kinks wrt. making this work for USB as well.

> When I read the comments from the previous thread I got the impression
> the SCSI people wanted me to use something like the SCT transport and
> the hook in the SMART thing in the libata back-end specifically for
> [S]ATA in response to the SCT read log command.

Our recommendation was for libata-scsi.c to export the SCSI temperature
log page, just like we do for all the other ATA parameters.

However, in tinkering with this the last couple of days, I find myself
torn on the subject. For two reasons. First of all, there is no 1:1
sensor mapping unless you implement the slightly more complex
environmental log page. Which isn't a big deal, except out of the
hundred or so SCSI devices I have here there isn't a single one that
supports it it. So in practice this interface would probably only exist
for the purpose of the libata SATL.

The other reason the libata approach is slightly less attractive is that
we need all the same SMART parsing for USB as well. So while it is
cleaner to hide everything ATA in libata, the reality of USB-ATA bridges
gets in the way. That is why I previously suggested having a libsmart or
similar with those common bits.

Anyway, based on what I've worked on today, I'm not sure that libata is
necessarily the way to go. Sorry about giving bad advice! We've
successfully implemented translations for everything else in libata over
the years without too much trouble. And it's not really that the
translation is bad. It's more the need to support it for USB as well
that makes things clunky.

> I don't understand if that means the SCT read log also works
> on some SCSI drives, or if it is just a slot-in thing for
> ATA translation that has no meaning on SCSI drives.

It's an ATA command.

One concern I have is wrt. to sensor naming. Maybe my /usr/bin/sensors
command is too old. But it's pretty hopeless to get sensor readings for
100 drives without being able to tell which sensor is for which
device. Haven't looked into that yet. The links exist in
/sys/class/hwmon that would allow vendor/model/serial to be queried.

Oh, and another issue. While technically legal according to the spec, I
am not sure it's a good idea to export a sensor per scsi_device. I have
moved things to scsi_target instead to avoid having bazillions of
sensors show up. Multi-actuator drives are already shipping.

If I recall correctly, though, I seem to recall that you had some sort
of multi-LUN external disk box that warranted you working on this in the
first place. Is that correct? Can you refresh my memory?

-- 
Martin K. Petersen	Oracle Linux Engineering
