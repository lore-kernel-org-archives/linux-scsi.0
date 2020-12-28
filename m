Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24604C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 15:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6923207CF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 15:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406601AbgL1P67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Dec 2020 10:58:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8627 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387930AbgL1P6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2020 10:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609171129; x=1640707129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wonk0+v1iVdRHX2zXpVU1PIKn+JTKFl5v6gncDJh5B0=;
  b=i2o9mn5BpD5D7xmpuuAyA21DXzq0S9ovwO4UCYGOFy/L7TGGfJ2NiOVC
   /kfAvzexv3/K1JVXlxvgZYUTCHE8Gmn9w7G8q6Pa4PvVK8kmh/JUscxzc
   7De9F/uGGT375ZWAGMLKIu3JvJNt9SZGeUfnT0Wte3+3/LeYC0tSqlSx9
   x+I/j4xWDV/yzUn3+nxzE+nEslr5UgrNkvSkVY7xxXJFi353f0yDaiqQA
   espjgG98jP7W04dI2hkhLZ+dVtv8wr2juA0IJSDoAUeWR/IYvNpnV/abZ
   9JHg59X6LqsHefS3Q5Fu75pdXLwG8cP7DSaA1lEbjwLZsIexM0ErS9vf1
   g==;
IronPort-SDR: raNhneSfbNSjmfvp31Fyyn4SiQSEUHcry8OzFXfHBODeyl3LZNfjgTfEtte/0XCQ/a1PzCTqkd
 wYZEiHdTCpsvtSCdOgL/2hnCAeuEwH/ZxgzdAk6gDucj+OpNvVcBSs7vzFWn9kyZQLrchPHc1f
 nOViX2b0+XR05Yj8AHXH36S3Be4edbMMNm0LLcK2neqnbVEBDGq1eGVIsCsutvvJw0vkHFy/ju
 twr4ybwBqTDKmlId+9784/XYwVVNuuWimnmuXfcv4d5aLzSafb/aGgH1tFWLNrhi2qh/hy14Er
 Qfc=
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400"; 
   d="scan'208";a="101189599"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Dec 2020 08:57:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Dec 2020 08:57:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 28 Dec 2020 08:57:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CX8iJSIlYilKiwGEsixuIEOa5QEedgzsN+9N6kHyJFzEsK40GmMOyAvvSusqTFsauBGQcDe1vTTE4DXwSzKfbBUu2+aZ05h3FqfOUBgSZ2YKk1sAZRCb0vN+uSitsmO4K5iTUxgpW9URtvho5sbiOs8pH90UTQEkXdARF2GznLHeSgCXTVt7jC1BzgMzaoR1jSm6MDxnVHcOl2DyfM70WzWMeTV/Hs95sVAlK1MZxBfzAMj8DJk3n/TJJC1beqbboJgjwkEyklSovFjg5GdGU+be/DSCTBpLnVG7+fjNk6+NJ2B5JAE9dTRSvsKFC/IVeVX9EO0/I/DgXkP6z3eFWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBcbZTs8QLzTKl4iwcALgICowr99oVfWH+x7a2QoSwg=;
 b=WOegNex+7fQisrMTDAs4p4VjyxzDggeKbsguyh4K9Wtvy6e4+kUiPORJM1nxzBdLMS1XTbJaS7OMcu8lTI3S05wsVb3yug5xw/KSuhy18bGTNgx83rH5J/qmv5PKEaJDBuENmiOrL9ZCbyXWK7Sn3WblRDMpnK3eLN6koogFTYB+VZ+p0G+Fn9N5+O9TWTaLV5Maezzv7Ff8GUrpe/ru+eS7ByLFVHRm+d+KzicJVkiKjUV2QPACxKxS3YgWKjrkp/WT8f5olD7zxSTJEImUp5EgQeMTY8+eewSW/6xMjYWmsN8e9A0uJv6jcyft1Ho25ZGrydzy4dTX2bLFE3GyWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBcbZTs8QLzTKl4iwcALgICowr99oVfWH+x7a2QoSwg=;
 b=QCeSfirbYGFxxJ4xvQAEb15Py20kpef3GY2ufXaMdvsz/jPJik+UrX9fbviiuwLgR2frnucBITBAlZ+8PnmRyBT7/bHq1Nnf930HIA9FKDMGb0rGBbpfar5yAkvjj67KKU2NdBTWUv1ozsB4Zm4zvJjwLf4xibfe2akk2qnrV84=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27; Mon, 28 Dec
 2020 15:57:31 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 15:57:31 +0000
From:   <Don.Brace@microchip.com>
To:     <buczek@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux@molgen.mpg.de>
Subject: RE: [PATCH V3 00/25] smartpqi updates
Thread-Topic: [PATCH V3 00/25] smartpqi updates
Thread-Index: AQHWzzSzGI7ouT8i+kC1pswzIdhAL6oBrZqAgACWNxSAAOZVgIAJl8zw
Date:   Mon, 28 Dec 2020 15:57:30 +0000
Message-ID: <SN6PR11MB2848F95706C20BFBBCCADFACE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <788f6ba0-2584-5109-0532-868e37e8f666@molgen.mpg.de>
 <SN6PR11MB2848D8C9DF9856A2B7AA69ACE1C00@SN6PR11MB2848.namprd11.prod.outlook.com>
 <6436abc3-7200-fb06-bd79-cb71f1fd1037@molgen.mpg.de>
In-Reply-To: <6436abc3-7200-fb06-bd79-cb71f1fd1037@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 182f220f-d160-43ab-9a77-08d8ab4948e1
x-ms-traffictypediagnostic: SA0PR11MB4720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4720FCCC7023B0CD8458BC26E1D90@SA0PR11MB4720.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oQjTc8Z6UhbwAi+Wah42Gy31Kw4/sUb3M+mRzJijiRKU0EVbKra3cuBwEasljUcwu8M2I4ChQuYhPsNZWjgJI32wDPq3PDCnhirlRkX0mrp4lnUJ6slE+W7dJlGONIrCdBNhZFi03Df8JNtuODwv3w70XbWhFVaAuHIfbzWHFOLeeD1N44PIHr/eFfssAVJ7kh7Wp+B8eLc3QBOzLLRlbAw+5l8w33Yvee+oOp5EmONKQZStRALk4sucnWiycDbNRX4nuFyK1KAdLbysA+SSd0xEVFcqX+/U7nCqwa6jxyrq1B4ukB4XiDw6gqnPQzs76gv6+Lcf4XC9yyGQJSJXWEaCczB+fuO/48PTRYEqhIJm2913/y5b0IBFU74eUpAcv/mENX/paLv0o+LHD54QHo9IDfRKlUPDQZ2dokERADhw2N3nSlk/kIKgyN0ETUSa57UqOEFYhpfv7uCFpsT5ViIETFGg3ItUomNovcxsMSb22YuQ1GXEotRiEr4TEEn9hKPl4p8nSIJ8vTbqlMJ11A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(66946007)(76116006)(54906003)(6506007)(53546011)(2906002)(5660300002)(71200400001)(478600001)(110136005)(8676002)(33656002)(66556008)(7696005)(52536014)(966005)(64756008)(66476007)(26005)(15650500001)(186003)(86362001)(55016002)(4326008)(921005)(316002)(8936002)(66446008)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?XzM21cBBIwe7N15DK4ue45aAXgthcJ8YNM4wOKSxAnh3oHizoceNZbCPIV?=
 =?iso-8859-1?Q?6pqOsszTWVc1dX1YC3UbidmwD49Kx6Bty9K6vc/NDWT5rW2cRwR1LtL6VG?=
 =?iso-8859-1?Q?aG4LuJ3NHRA90/HwBgcLfohIl3p9W6zaWWFIJ34ZE5DoygC/1vg3tKTFB9?=
 =?iso-8859-1?Q?g+UPknv9XMoLquTeo5fBR2mMXdhofME4E9WBqcCKmTvAqixGCwTRfsnRRz?=
 =?iso-8859-1?Q?IA/Uqnm4k9PgrZL37ajbEd6VMc7QZ8R4N8Bx+s+LiPfiIwjXMspjDRjkud?=
 =?iso-8859-1?Q?ROFUk+TgRZ2XqJ3DIWqJD7qtsofFjypBlsfQ97sLlSQJSwCNteS/EM1+Gb?=
 =?iso-8859-1?Q?FvccqMjTlE/mMV2in5vLN4aCgHoNFZ/qepIbtymmDhii8Hi4z29/0MkAP7?=
 =?iso-8859-1?Q?fmnwECbAf530/CpQihEoa43QycJaM17iADmg31gtnsNwrS/VAy+yVlCSt8?=
 =?iso-8859-1?Q?Dj7GzThH0PwzX0F1ptIYIDorOWlzn3iJbi5RBlzTccRd3gu+dWJFofWAK7?=
 =?iso-8859-1?Q?YMuiP2kWDWYzvI17fGKDLYSOruyde+bfVw0TsGK/Kk9jk7WgKVHBtBLN06?=
 =?iso-8859-1?Q?jWBmKdC+9T4u0zeKwZsAO3vNDa9I55Ng9L5hmCZoxhr6aDVFSZz2aDp5rg?=
 =?iso-8859-1?Q?DI2pGrtFgW15XG6ipivykdG22vKkOz2+W28cbMjATTuA6xVlGGYahjDAEf?=
 =?iso-8859-1?Q?S73FaKY+o4j7JmBYEi5mol/8Dqo6dgXMGf7jsrlriOoCWNpsi9+MyvQYDy?=
 =?iso-8859-1?Q?a5o0aEJTl9EC9AC5LAZEtL4S0krrflm3Niu3mel9aue5abNNDkUFh4fmjJ?=
 =?iso-8859-1?Q?yM7FnwmP0S6vpjZH0CbM9V7/5E1Y5UKNgqh7/3kTQYqanVHEK/QeVKGdGv?=
 =?iso-8859-1?Q?Z4ZEksXn1EFOK5rnLe2YnfExNHBcSZ/hh9fCTyRUgHH4c05trdUHFHywh/?=
 =?iso-8859-1?Q?tiTohyLZijc+P5193jaiWe1gdzArtUfRvJL85xmClWxFcloBGA7EvYVwg/?=
 =?iso-8859-1?Q?4q7S7EvS+iOEMqYbo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182f220f-d160-43ab-9a77-08d8ab4948e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2020 15:57:31.0595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2g8jjD6+rpyC5YlaQFT2c6gXSm1EdwAiUrYLR43BnuOnCOm3TOhBq4LuyN+wpJe1q7QhGSwL7s0OjKY6cZxyUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Subject: Re: [PATCH V3 00/25] smartpqi updates

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On 22.12.20 00:30, Don.Brace@microchip.com wrote:
> Can you please post your hw configuration and the stress load that you us=
ed? Was it fio?

Testsystem is a Dell PowerEdge R730. with two 10 core Intel=AE Xeon=AE Proc=
essor E5-2687W v3  and 200 GB memory.
Adapter is Adaptec HBA 1100-8e, Firmware 3.21 On it two AIC J3016-01 Enclos=
ures with 16 8TB disks each The disks of each jbod are a combined into a ra=
id6 software raid with xfs on it.
So I have two filesystems with ~100 TB ( 14 * 7.3 TB)

Unfortunately, for the time being, I was only able to reproduce this with a=
 very complex load setup with both, file system activity (two parallel `cp =
-a` of big directory trees on each filesystem) and switching on and of raid=
 scrubbing at the same time. I'm currently trigger the issue with less comp=
lex setups.

I'm not sure at all, whether this is really a problem of the smartpqi drive=
r. Its just the frozen inflight counter seem to hint in the direction of th=
e block layer.

Donald

>>Thanks for sharing your HW setup.
>>I will also setup a similar system. I have two scripts that I run against=
 the driver before I feel satisfied that it will hold up against extreme co=
nditions. One script performs a list of I/O stress tests (to all presented =
disks (LVs and HBAs): 1) mkfs {xfs, ext4}, 2) mount, 3) test using rsync, 4=
) fio using file system, 5) umount, 6) fsck, 7) fio to raw disk.

>>The other script continuously issues resets to all of the disks in parall=
el. Normally any issues will show up within 20 iterations of my scripts. I =
wait for 50K before I'm happy.

>>I have not tried layering in the dm driver, but that will be added to my =
tests. There have been a few patches added to both the block layer and dm d=
river recently.

>>Thanks again,
>>Don.



>
> Dear Don,
>
> just wanted to let you know that I've tested this series (plus the three =
Depends-on patches you mentioned) on top of Linux v5.10.1 with an Adaptec 1=
100-8e with fw 3.21.
>
> After three hours of heavy operation (including raid scrubbing!) the=20
> driver seems to have lost some requests for the md0 member disks
>
> This is the static picture after all activity has ceased:
>
>       root:deadbird:/scratch/local/# for f in /sys/devices/virtual/block/=
md?/md/rd*/block/inflight;do echo $f: $(cat $f);done
>       /sys/devices/virtual/block/md0/md/rd0/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd1/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd10/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd11/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd12/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd13/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd14/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd15/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd2/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd3/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd4/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd5/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd6/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd7/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd8/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd9/block/inflight: 1 0
>       /sys/devices/virtual/block/md1/md/rd0/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd1/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd10/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd11/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd12/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd13/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd14/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd15/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd2/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd3/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd4/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd5/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd6/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd7/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd8/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd9/block/inflight: 0 0
>
> Best
>     Donald
>
> On 10.12.20 21:34, Don Brace wrote:
>> These patches are based on Martin Peterson's 5.11/scsi-queue tree
>>
>> Note that these patches depend on the following three patches =20
>>applied to Martin Peterson's tree:
>>    https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>>=A0=A0=A0 5.11/scsi-queue
>> Depends-on: 5443bdc4cc77 scsi: smartpqi: Update version to 1.2.16-012
>> Depends-on: 408bdd7e5845 scsi: smartpqi: Correct pqi_sas_smp_handler=20
>>busy condition
>> Depends-on: 1bdf6e934387 scsi: smartpqi: Correct driver removal with=20
>>HBA disks
>>
>> This set of changes consist of:
>>=A0=A0=A0 * Add support for newer controller hardware.
>>=A0=A0=A0=A0=A0 * Refactor AIO and s/g processing code. (No functional ch=
anges)
>>=A0=A0=A0=A0=A0 * Add write support for RAID 5/6/1 Raid bypass path (or a=
ccelerated I/O path).
>>=A0=A0=A0=A0=A0 * Add check for sequential streaming.
>>=A0=A0=A0=A0=A0 * Add in new PCI-IDs.
>>=A0=A0=A0 * Format changes to re-align with our in-house driver. (No=20
>>functional changes.)
>>=A0=A0=A0 * Correct some issues relating to suspend/hibernation/OFA/shutd=
own.
>>=A0=A0=A0=A0=A0 * Block I/O requests during these conditions.
>>=A0=A0=A0 * Add in qdepth limit check to limit outstanding commands.
>>=A0=A0=A0=A0=A0 to the max values supported by the controller.
>>=A0=A0=A0 * Correct some minor issues found during regression testing.
>>=A0=A0=A0 * Update the driver version.
>>
>> Changes since V1:
>>=A0=A0=A0 * Re-added 32bit calculations to correct i386 compile issues
>>=A0=A0=A0=A0=A0 to patch smartpqi-refactor-aio-submission-code
>>=A0=A0=A0=A0=A0 Reported-by: kernel test robot <lkp@intel.com>
>>     =20
>>https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/VM
>>BBGGGE5446SVEOQBRCKBTRRWTSH4AB/
>>
>> Changes since V2:
>>=A0=A0=A0 * Added 32bit division to correct i386 compile issues
>>=A0=A0=A0=A0=A0 to patch smartpqi-add-support-for-raid5-and-raid6-writes
>>=A0=A0=A0=A0=A0 Reported-by: kernel test robot <lkp@intel.com>
>>     =20
>>https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZC
>>XJJDGPPTTXLZCSCGWEY6VXPRB3IFOQ/
>>
>> ---
>>
>> Don Brace (7):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: refactor aio submission code
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: refactor build sg list code
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for raid5 and raid6 writes
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for raid1 writes
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add stream detection
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add host level stream detection enable
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update version to 2.1.6-005
>>
>> Kevin Barnett (14):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for product id
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for BMIC sense feature cmd an=
d feature=20
>>bits
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update AIO Sub Page 0x02 support
>>=A0=A0=A0=A0=A0=A0  smartpqi: add support for long firmware version
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: align code with oob driver
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: enable support for NVMe encryption
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: disable write_same for nvme hba disks
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: fix driver synchronization issues
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: convert snprintf to scnprintf
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: change timing of release of QRM memory du=
ring OFA
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: return busy indication for IOCTLs when of=
a is active
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add additional logging for LUN resets
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: correct system hangs when resuming from h=
ibernation
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add new pci ids
>>
>> Mahesh Rajashekhara (1):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: fix host qdepth limit
>>
>> Murthy Bhat (3):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add phy id support for the physical drive=
s
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update sas initiator_port_protocols and=20
>>target_port_protocols
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update enclosure identifier in sysf
>>
>>
>>=A0=A0 drivers/scsi/smartpqi/smartpqi.h              |=A0 301 +-
>>=A0=A0 drivers/scsi/smartpqi/smartpqi_init.c         | 3123 ++++++++++---=
----
>>=A0=A0 .../scsi/smartpqi/smartpqi_sas_transport.c    |=A0=A0 39 +-
>>=A0=A0 drivers/scsi/smartpqi/smartpqi_sis.c          |=A0=A0=A0 4 +-
>>=A0=A0 4 files changed, 2189 insertions(+), 1278 deletions(-)
>>
>
> --
> Donald Buczek
> buczek@molgen.mpg.de
> Tel: +49 30 8413 1433

--
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
