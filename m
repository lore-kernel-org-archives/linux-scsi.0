Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BCDC2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 02:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F247D2176D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 02:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rHZuKdEC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfLQCiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 21:38:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfLQCiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 21:38:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2YBQQ070641;
        Tue, 17 Dec 2019 02:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=nfKzbr+TM2kphNYaYjHYA8wSxjyrzcWM+JZBStarX/I=;
 b=rHZuKdECCsz4X5t1vXmx91/d4LTdYKPy5+B0uZuc5+mHJUizEKC1pMl8XP8/zEJRlYME
 +MoDqP6/eaMeRk3k/4V/bBlHp9MNtkLpQ5tcK/9s55JbF4oYR7BJX3tSoc1BIcApdfGD
 MpQ6scwe7fFUU37eM9xmAAaLHP+IcZdtan6soixw3m0n65AHicXlTGOIB09NJJkhYcF1
 qhaMtODERdeXbQ4ILjFrPqADP8xY6UeLV2cpWs65d7ZPYXCim+bPSZ1IANP3PMZu8yFH
 axG2x7E+pjndnesJELayeY1RU605eO2I51KyXwO6kPDiSobJPRBXwdb+UJU4MulApbj2 tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcr3h18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:37:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2ShNm142150;
        Tue, 17 Dec 2019 02:35:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wxm6xt6td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:35:41 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBH2Zdx9003006;
        Tue, 17 Dec 2019 02:35:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 18:35:38 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191209052119.32072-1-linux@roeck-us.net>
        <yq15zinmrmj.fsf@oracle.com>
        <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net>
Date:   Mon, 16 Dec 2019 21:35:33 -0500
In-Reply-To: <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net> (Guenter
        Roeck's message of "Tue, 10 Dec 2019 21:57:24 -0800")
Message-ID: <yq1y2vbhe6i.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> If and when drives are detected which report bad information, such
> drives can be added to a blacklist without impact on the core SCSI or
> ATA code. Until that happens, not loading the driver solves the
> problem on any affected system.

My only concern with that is that we'll have blacklisting several
places. We already have ATA and SCSI blacklists. If we now add a third
place, that's going to be a maintenance nightmare.

More on that below.

>> My concerns are wrt. identifying whether SMART data is available for
>> USB/UAS. I am not too worried about ATA and "real" SCSI (ignoring RAID
>> controllers that hide the real drives in various ways).

OK, so I spent my weekend tinkering with 15+ years of accumulated USB
devices. And my conclusion is that no, we can't in any sensible manner,
support USB storage monitoring in the kernel. There is no heuristic that
I can find that identifies that "this is a hard drive or an SSD and
attempting one of the various SMART methods may be safe". As opposed to
"this is a USB key that's likely to lock up if you try". And that's
ignoring the drives with USB-ATA bridges that I managed to wedge in my
attempt at sending down commands.

Even smartmontools is failing to work on a huge part of my vintage
collection.  Thanks to a wide variety of bridges with random, custom
interfaces.

So my stance on all this is that I'm fine with your general approach for
ATA. I will post a patch adding the required bits for SCSI. And if a
device does not implement either of the two standard methods, people
should use smartmontools.

Wrt. name, since I've added SCSI support, satatemp is a bit of a
misnomer. drivetemp, maybe? No particular preference.

> The one USB/UAS connected SATA drive I have (a WD passport) reports
> itself as "WD      ", not as "ATA     ". I would expect other drives
> to do the same.

Yes. Most vendors are too fond of their brand names to put "ATA" in
there. So my suggestion is to relax the heuristic to trigger on the ATA
Information VPD page only and ignore the name.

Also, there are some devices that will lock up the way you access that
VPD page. So a tweak is also required there.

To avoid the multiple blacklists and heuristic collections my suggestion
is that I introduce a helper function in SCSI (based on what I did in
the disk driver) that can be called to identify whether something is an
ATA device. And then the hwmon driver can call that and we can keep the
heuristics in one place.

If a device turns out to be problematic wrt. getting the ATA VPD for the
purpose of SMART, for instance, it will also need to be blacklisted for
other reasons in SCSI. So I would really like to keep the heuristics in
one place.

-- 
Martin K. Petersen	Oracle Linux Engineering
