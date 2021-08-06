Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6330C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA3BC61163
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243425AbhHFIw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:52:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58529 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhHFIwz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 04:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628239961; x=1659775961;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VMAZWBcCUsqdqPldfxq8YvOHvrjywNyJte+53J/X2jI=;
  b=eiaWRAaXZr9dzSq5I+zvqdD72IxOQIxuYRa/DiDGdp3CDVqvrMCqMtRK
   s6m1fGPxobEDSHdDdD07OpowPlnfMyVtbW6ck41FhonI9MOVDxFA0uPRy
   HQJjgt6opkZ12vPIqzj19jQLImL1PdCKeWM62whxENG5P1292GgFD2MJw
   XBiSs6TnPfp2E8sG63gGP9/y15UuK7kwCGAXMaDSWFHUjIs8BfqXyuTQl
   KT/IEYFW6vuULjSjCvCicyMIhAPhteQ58XAXikuD/MPjx3SmOVrv6SRi8
   dipK8Z4Cy8kr70VyQQowojcatFv/RpFjPv9yYkFy048NpD5CG4kl+bKZL
   w==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177047533"
Received: from mail-bn1nam07lp2040.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.40])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 16:52:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP4o61nNkf7ayyFvO5EXWRH1cyywGJSHrx5tzkDtfKpd3WDq2Wm5GvMhnSAWzITmbJ0Szd5FhoiKs4eLK94wsYlS1KhVCFxkjuxaAnv+CzjJSrzgoRXzY4/roA9v5bw1MkAXFUmdSffA4xMgXbZxYa8lJ0qZ1NSfICf3SV/TAVdPp//06GreDsBxQAVq6DeY+BzBHHyQo1DP3fo1+Lp0Deaij97bf00e9gVS/F1zzl1Z8r4j0oKxM6oMEHbPR0rA1BIvjFaX4h9RgLWBv7r5ClwOevfqdK+cST4BE6nrjskMwAPopSrRn3LqOI2ZANSZ/B8U14CS4k4MAfLY2DTsCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMAZWBcCUsqdqPldfxq8YvOHvrjywNyJte+53J/X2jI=;
 b=TUBwluN+u5G7TVC7gCiM3ClYnP/JJ4tptFmDrLEJ/hJ3mgFMLALneRClJ5gV/5v7F4+fVlMNVEQRReGQwSMLCDjdSauVlD/hCn/sbdKjdwDagqEXFsSoxEmT7IZ88gpbHk3Bdgj26tcR17bG4KupehBie2s16OJwL5gFZ4gqQHAKGD/LdRr0KOxMkUlEMXNKUWkOFxJwIczZYkcyLOD+0+iP/GoAs2hRJpk0P0qfBaWbUmtC833lHKAYd08manMSMnWiy17H+iT8j3hBSlBxr4cdKmx9qZ3+i4j43YToUxL3N4GRvrFuPX5duFBMI2i99tFojNQzT6bFE7W765l6pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMAZWBcCUsqdqPldfxq8YvOHvrjywNyJte+53J/X2jI=;
 b=gtz23y3iDFGDMrQTLJUwcdWU0UAdNs1NsjXwzd9Y2jDtwzJWow5PXFKF/xPUt9nlt1In6e6mYYyLEVbyfIB+9RGUTNHGMo5RLfhs2QvZe0WUcQSMKnAayq9xd6/0buXBqAxYS8Lh2D+5Eyrb9wBv+0186dkbHp0jgQiSWlXvtac=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB1004.namprd04.prod.outlook.com (2603:10b6:4:41::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 08:52:36 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 08:52:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Thread-Index: AQHXgb7nBT0SP/zb8kqWuIxTGXvQIg==
Date:   Fri, 6 Aug 2021 08:52:36 +0000
Message-ID: <DM6PR04MB7081A6623985C0F299A8AB21E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <yq18s1ffdz7.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB7081398426CA28606DC39491E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
 <c3a28f3f-52c4-e7bc-8bd7-bec2feae25fa@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc5bd84c-2c66-435f-d27d-08d958b789c8
x-ms-traffictypediagnostic: DM5PR04MB1004:
x-microsoft-antispam-prvs: <DM5PR04MB1004522F1EFA8F190CB2F5CBE7F39@DM5PR04MB1004.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W0gAHlfboK6xf5zeVpIqQ6/xlX++pHauRPhfj19BiutVnuM+xaprs3e/Is19zOIs9GqylHCzgg6cxZbKUyyQ35kd4brGdEZeRXXvtCr6nYbOvmpwRswV6oG8NKn1WPHqq8s5VbqOspYPZ/YRoWrUeFIINJ15oRrYjQMaOFnEeBFX1S2NFDS2htk4ktR24C9BMzIepdLKMRWl32HcYTJ75uOXCznM14Juf7A1cIlw5a2r/4bHDVDqomRobqCLXV5cLjjvDS/icawRNcH/SHsQ2A8B/MHT+thoek0uCwbbn4bnmajofQRYArm2BTi4Js9oOBBOYYHjEaS+OkLFOmJL6YklLKRdlL4nO0hBAY5muEa3KNR2O3egCQnV/QA2TYPN4o59LBYb2Zbd4NGihtmV8UTEgAOArwlaDoAh+NMVC1wZ28nDcCOu6jyuSXVQAHHZ+16exjb6LDWO7amf5DAlc7UaWMF8xupnIOUlb/O32Lv4rLEJKFgP09lT5v7T6O1lf0T1UvOz5K0MzRRT+Ax1jL9iDMcdMBuMgwT8yud1VGqDKk1l/6h6YmJ9xJPBxglTr+N5Xk/2rUXwff29lRWhZ0feQ32mzShAgbFICBdCnW6RYsYaNYho/LmCCLr+DBJ5oMjbWHZo5K2zfSxxXjh3lQDn2Kaf7X2eHZAJxJ4ys6sw16r3D8ZpI7cChlnoZXIbI1PUkHrXc88XNuh0aFL0l/iLDxeKVgdN/nrm85qn6h9xbDehdxPDr6wDkEH4NrVsxXWu++FAZTt5vuCbON0BTEi5l4pzn+sjffPyC1FeP+Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39850400004)(346002)(366004)(83380400001)(38070700005)(8676002)(66556008)(33656002)(2906002)(6506007)(66476007)(52536014)(55016002)(66446008)(64756008)(478600001)(4326008)(7696005)(186003)(71200400001)(76116006)(86362001)(122000001)(316002)(8936002)(91956017)(110136005)(9686003)(54906003)(53546011)(66946007)(966005)(38100700002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nc0WjaMh22GsANu7aaSQiI9ivxNS6L5AsfnYtbFzsX5PwZdlr3ONjIRWIr+A?=
 =?us-ascii?Q?9TwYT/4W0Fcq1ILSjK1Wa59KV+JSIvX6p3pNuID81qyKJOMAEFPh371+fcwU?=
 =?us-ascii?Q?pLPoqg8+h0pkRQkmpikIBEz6C6cIOpgi4/fcAE7Jn/K3eqzBHkAy0yWO2zf5?=
 =?us-ascii?Q?RBEKNBhRjD2iRs7crjnjsJW0B/x7tosWP+qlrywqGK2oQHMV5OGHODgXHClr?=
 =?us-ascii?Q?TmlNGI/VMVj3Y+mDNY92TAWyYRtuMhniScsCY7EattoHJy1SHTvdNob9NdYV?=
 =?us-ascii?Q?I0YxRJC5POO1+F7Rb6eJLulHoB9n9Smuoud6xlYeU/VDDh1jyswfjcP0tdq9?=
 =?us-ascii?Q?5657rBUohn7CDZLPxSWr3znlJs9CcOF4Edd05bu7XC9ozCmxzMgGdYGq6YuC?=
 =?us-ascii?Q?mwqBGIcyp/eCvsw2ly+J1JoxRjI7mwBCINXI+L7mFEevRIuJ2eCOgLXvOZaI?=
 =?us-ascii?Q?QcGkA2eZqX6NbvOAGM7DTs5/k4ezXIYGr+IRQ3vjqJKF71R+2ZfmOkOi86EZ?=
 =?us-ascii?Q?DfY1yeRHor6eMl3XCjGTqHgvHqzItXukNXBF1O1YLdijoZza9sGzfqemaiCl?=
 =?us-ascii?Q?s1ZKxg2fsjRhhLlQQggsBW0q0yH01ZSG1o5MA1sEszmo/zFq1ubK+7JoFL3B?=
 =?us-ascii?Q?o2UATWHro2ur3kBBCG9QroInqj92MJSv37ma+eiwFYYrao9Z+zRZ3hWZobwq?=
 =?us-ascii?Q?NP+CCQe4KyujyIEtIIVW5FYo/K098SfTk8r3CGXwn4+8wkGvjqcJCuVavIPY?=
 =?us-ascii?Q?R0U+l3X0CBMUcIOXH9zN7lc4hS7i7e5ZVIx+YNzkHtB5zFYRTMAj8+LMYj6l?=
 =?us-ascii?Q?K4g1+pfrqmFkeqADG5huvwvXUFIYen9RTwgWYdXV7xBQZSHDhowqvDbjr57d?=
 =?us-ascii?Q?/PTkN5qAK2yQFM2E9yK6jFcVMYX03ZKvqD/tlW5zxVkpnTuQ2btgCRFi1Zf9?=
 =?us-ascii?Q?4lFn/AvdtcPuAUkhYICRA1IkUp9DqJT+Ohih4e0Sq3S2O3jMgc155tM3WQxT?=
 =?us-ascii?Q?e6K++NUnPNqllFry2BvHX4ugXMIMPXLe1OXbTBbRMoXh/EM0uIwbWeGt3kZE?=
 =?us-ascii?Q?o68IVqdS4qRSjv/hEswnJaaBzDSfmrxTDgJqQIXFPXghx7B+bDFtOa8c9ojq?=
 =?us-ascii?Q?xxZGvSTVYBbYx/hn/xQc7nnzXGP/RAtPw+2TyZ6ntMLVftuyJvnremML9rwA?=
 =?us-ascii?Q?mKP7iu4C3/S5tRHmyEn9ReHt4105EcTIpKHgEmBNfLxQn1xhktoaKdMPbPfr?=
 =?us-ascii?Q?AEzRczha/xHoXo3z16xpluqisH4siMopgEL+ZiKQZDNoBci4xBKCl4C9wm7q?=
 =?us-ascii?Q?n8Iy4FvrwUQYg8clHF7j3k0L6DEUF1dZdScA1o7dDDjZniyyy1rsi4Ns0szy?=
 =?us-ascii?Q?auN9zxH7gr7hk/zZfvDFLB0Itr0FmOu4bcf40OysVQZ7Gil2/Q=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5bd84c-2c66-435f-d27d-08d958b789c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 08:52:36.1832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jf/eJBVjnCxuT2Wq2vSl0Imtks1Do+2g/rCGQEMtSyvZ0xp14Ju5gTblG0XreGX7IEzEBBMv6Q5ih5lzYKPe1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 17:36, Hannes Reinecke wrote:=0A=
> On 8/6/21 6:05 AM, Damien Le Moal wrote:=0A=
>> On 2021/08/06 12:42, Martin K. Petersen wrote:=0A=
>>>=0A=
>>> Damien,=0A=
>>>=0A=
>>>> Single LUN multi-actuator hard-disks are cappable to seek and execute=
=0A=
>>>> multiple commands in parallel. This capability is exposed to the host=
=0A=
>>>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>>>> Each positioning range describes the contiguous set of LBAs that an=0A=
>>>> actuator serves.=0A=
>>>=0A=
>>> I have to say that I prefer the multi-LUN model.=0A=
>>=0A=
>> It is certainly easier: nothing to do :)=0A=
>> SATA, as usual, makes things harder...=0A=
>>=0A=
>>>=0A=
>>>> The first patch adds the block layer plumbing to expose concurrent=0A=
>>>> sector ranges of the device through sysfs as a sub-directory of the=0A=
>>>> device sysfs queue directory.=0A=
>>>=0A=
>>> So how do you envision this range reporting should work when putting=0A=
>>> DM/MD on top of a multi-actuator disk?=0A=
>>=0A=
>> The ranges are attached to the device request queue. So the DM/MD target=
 driver=0A=
>> can use that information from the underlying devices for whatever possib=
le=0A=
>> optimization. For the logical device exposed by the target driver, the r=
anges=0A=
>> are not limits so they are not inherited. As is, right now, DM target de=
vices=0A=
>> will not show any range information for the logical devices they create,=
 even if=0A=
>> the underlying devices have multiple ranges.=0A=
>>=0A=
>> The DM/MD target driver is free to set any range information pertinent t=
o the=0A=
>> target. E.g. dm-liear could set the range information corresponding to s=
ector=0A=
>> chunks from different devices used to build the dm-linear device.=0A=
>>=0A=
> And indeed, that would be the easiest consumer.=0A=
> One 'just' needs to have a simple script converting the sysfs ranges=0A=
> into the corresponding dm-linear table definitions, and create one DM=0A=
> device for each range.=0A=
> That would simulate the multi-LUN approach.=0A=
> Not sure if that would warrant a 'real' DM target, seeing that it's=0A=
> fully scriptable.=0A=
> =0A=
>>> And even without multi-actuator drives, how would you express concurren=
t=0A=
>>> ranges on a DM/MD device sitting on top of a several single-actuator=0A=
>>> devices?=0A=
>>=0A=
>> Similar comment as above: it is up to the DM/MD target driver to decide =
if range=0A=
>> information can be useful. For dm-linear, there are obvious cases where =
it is.=0A=
>> Ex: 2 single actuator drives concatenated together can generate 2 ranges=
=0A=
>> similarly to a real split-actuator disk. Expressing the chunks of a dm-l=
inear=0A=
>> setup as ranges may not always be possible though, that is, if we keep t=
he=0A=
>> assumption that a range is independent from others in terms of command=
=0A=
>> execution. Ex: a dm-linear setup that shuffles a drive LBA mapping (high=
 to low=0A=
>> and low to high) has no business showing sector ranges.=0A=
>>=0A=
>>> While I appreciate that it is easy to just export what the hardware=0A=
>>> reports in sysfs, I also think we should consider how filesystems would=
=0A=
>>> use that information. And how things would work outside of the simple=
=0A=
>>> fs-on-top-of-multi-actuator-drive case.=0A=
>>=0A=
>> Without any change anywhere in existing code (kernel and applications us=
ing raw=0A=
>> disk accesses), things will just work as is. The multi/split actuator dr=
ive will=0A=
>> behave as a single actuator drive, even for commands spanning range boun=
daries.=0A=
>> Your guess on potential IOPS gains is as good as mine in this case. Perf=
ormance=0A=
>> will totally depend on the workload but will not be worse than an equiva=
lent=0A=
>> single actuator disk.=0A=
>>=0A=
>> FS block allocators can definitely use the range information to distribu=
te=0A=
>> writes among actuators. For reads, well, gains will depend on the worklo=
ad,=0A=
>> obviously, but optimizations at the block IO scheduler level can improve=
 things=0A=
>> too, especially if the drive is being used at a QD beyond its capability=
 (that=0A=
>> is, requests are accumulated in the IO scheduler).=0A=
>>=0A=
>> Similar write optimization can be achieved by applications using block d=
evice=0A=
>> files directly. This series is intended for this case for now. FS and bl=
oc IO=0A=
>> scheduler optimization can be added later.=0A=
>>=0A=
>>=0A=
> Rumours have it that Paolo Valente is working on adapting BFQ to utilize=
=0A=
> the range information for better actuator utilisation.=0A=
=0A=
Paolo has a talk on this subject scheduled for SNIA SDC 2021.=0A=
=0A=
https://storagedeveloper.org/events/sdc-2021/abstracts#hd-Walker=0A=
=0A=
> And eventually one should modify filesystem utilities like xfs to adapt=
=0A=
> the metadata layout to multi-actuator drives.=0A=
> =0A=
> The _real_ fun starts once the HDD manufactures starts putting out=0A=
> multi-actuator SMR drives :-)=0A=
=0A=
Well, that does not change things that much in the end. The same constraint=
s=0A=
remain, and the sector ranges will be aligned to zones. So no added difficu=
lty.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
