Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C38C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F1D206D4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xI/cy3Nn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgICPhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:37:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgICPhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 11:37:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 083FXvsq194222;
        Thu, 3 Sep 2020 15:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=dtiQ03CReIpSecyBc/8ufU2knhQkZUc6ny1k7/fQ7u0=;
 b=xI/cy3NnT0NWDf8IzVxnET4UPq3vcYjpThfBixU03i/9D5Q+Ey6YL3xCNAgCmTJVAOXf
 cDjPV9QsSHsGWbCaaua9Uo0JRKwkGqQaAxyo379+JsB7CYV57FkmV9fRdHA0Nff8OhNh
 ti8ofmaExqmR2uDvVbv1NFXCGk6EUBOolWYV6912YKm3f9B36In9vV8poR2hiJit6+Ax
 9lJKf7JWpziwzVri17GtK7u6JezP6QUzqDwExhiB++2MBXr3NR/Oxlr8hC8icLDq1x8/
 TquO3wkQuLQe8UNqx72aF2siFBMieAXMV27W++wEjTuaKJyOP1NnNcX4PHSaZpH94OY2 xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmn7y33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 15:37:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 083FZHUh042782;
        Thu, 3 Sep 2020 15:36:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380krym1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 15:36:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 083Faw0o008916;
        Thu, 3 Sep 2020 15:36:59 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Sep 2020 08:36:58 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <20200903002336.083e88a4@suse.de>
Date:   Thu, 3 Sep 2020 10:36:58 -0500
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7F596A9A-2116-4BA8-8A32-E98EDE996D8C@oracle.com>
References: <20200813002142.13820-1-ddiss@suse.de>
 <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
 <20200903002336.083e88a4@suse.de>
To:     David Disseldorp <ddiss@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030145
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 5:23 PM, David Disseldorp <ddiss@suse.de> wrote:
>=20
> Hi Mike,
>=20
> On Tue, 1 Sep 2020 22:17:51 -0500, Michael Christie wrote:
>=20
>>> --- a/drivers/target/target_core_xcopy.c
>>> +++ b/drivers/target/target_core_xcopy.c
>>> @@ -68,8 +68,14 @@ static int =
target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
>>> 	if (rc !=3D 0)
>>> 		return 0;
>>>=20
>>> -	info->found_dev =3D se_dev;
>>> 	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
>>> +	if (info->found_dev) {
>>> +		pr_warn("XCOPY 0xe4 descriptor conflict for se_dev %p =
and %p\n",
>>> +			info->found_dev, se_dev);
>>> +		=
target_undepend_item(&info->found_dev->dev_group.cg_item);
>>> +		return -ENOTUNIQ;
>>> +	}
>>> +	info->found_dev =3D se_dev; =20
>>=20
>> Was it valid to copy to/from the same LUN? You would copy from/to =
different src/destinations on that LUN. Would your patch break that?
>=20
> XCOPY allows for copies to occur on the same LUN or between separate
> src/destinations. The intention of this patch is that regardless of =
the
> source or destination, if the NAA WWN could refer to multiple LUNs on
> the same target (via target_for_each_device()) then the XCOPY should
> fail and force the initiator to fallback to initiator driver copy.

So is the answer to my question a maybe but it probably will never =
happen?

If the user has multiple backend devices with the same serial, then your =
patch would now return error right? Is the reason that this patch is a =
RFC to try and figure out if that case is valid or ever happens? If so, =
the only way I could see that happening on purpose is if someone was =
trying to bypass a device issue.

For example, I create 2 tcmu devices. They both point to the same real =
device. Then export dev1 through target port1 and dev2 through target =
port2. Each tcmu device would then have it=E2=80=99s own data/cmd ring =
and locking, so you do not hit those perf issues. I do this for perf =
testing. I don=E2=80=99t think that type of thing is common or ever =
done, so I think the patch would be ok if that is a concern and it=E2=80=99=
s better than possible data corruption.

Code wise it looks ok to me.

