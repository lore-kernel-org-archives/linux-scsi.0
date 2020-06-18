Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF665C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 23:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8724420888
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 23:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XFBw77T0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RgcNnTc1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgFRXcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 19:32:17 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49666 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRXcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 19:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592523136; x=1624059136;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UqfiOlZyJC7ZjASMHI7+j2IPcTjyHAI4KmqEmS1Hd28=;
  b=XFBw77T0yFf51d2KTPW+HEv8UAPfc0PEwaMgKE8j/43bfWzvoXPxlHlj
   sDIExGWUFM0vgq9hqJ9V/iI+xs0ab8OQy5JYgWWCERA8LHrdQ8FhwSEMx
   IDwIN6CHVn/E3RYSukoUWAXXm2UdT99kabyZhz1JFMEFNgy49bbgWElLe
   Y8Ef8wLSJ7GkQ1NVdcxwxoxjBvkI2YZtDKTPmTGhHIwpCAAozs3dFUV6K
   1eDk6+oeuilxpiJYm8GoJHDw4sBhCVQt7uP1viZskaKvk7hzbpBIEj19E
   Gx7SGG4gReYTeEHTeXWDv7KH0EtfDX8Gv8vR+uBuPzH6aMzkFoo4G37D+
   Q==;
IronPort-SDR: 5dsU7ztvmSiiSzrz5HzNYiLDKSarTsQ13OUGFlBHdr8lOpoJkYir4Ht22EHMtnuFHK0ouVdOJr
 KeCc0JpNbQ/Ej0FZeDjqNhXxmpAJKd4bUHYfRHZwTwdpazN/VqCx+kWu2EtBOUw15IHwre2+B2
 s3RmY8KJNUh5TAhEWeC3lib+aGfOCpX1UXinWliKnmvWoRrWybZROA4lpNUDL5KNe3Jz7XkcxL
 y+PjPwGaxpUgLwFze4Gfxacw2wt5z9ZnhRVKrgtp4GDD+PY6eHix3iXjC4d2cS73lgvGsFGywI
 ckM=
X-IronPort-AV: E=Sophos;i="5.75,253,1589212800"; 
   d="scan'208";a="141750110"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2020 07:32:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQEq9PAaCRXoSVBYk/jrE8sIrCCXvono1+im/Y08PRy2aydyZGRYU+HqSB4/Zc8YFy86tG/9TNM3zKT+J7gZHQsEmECZHZ6GnFBNyrZRBmlounmB6mLHgdIHjimCUkgXOkxzWiveJ8/h8HcGJdz1PN6lJbp3uMlP770KDdArCzzjlLtXq3exHkGUBHvCsP8juxRlkK5TcdUWzCYrDLTg0eSk4KeL1ruZvQjlPeRaOoR3uKvLtEkdSET1n/DKW9PByTiSG+yKqPJq5xArrSJWC//jmnqZr0x1iKHEPjoenFNi8lKMXm7XJewBjDiHQx8seHaSwutgQnZGWtsg49ucRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqfiOlZyJC7ZjASMHI7+j2IPcTjyHAI4KmqEmS1Hd28=;
 b=ljBOSl0tbukbbylnZeW8xVQHwYQKEqpfsgSlspMuPyrzDQbcXo+tZSHffvVbSLw/bAtdZH4MY4h4V650SUIt+kmjsjZ18bFYU/0izCGB/UuD5niAX4u2aIeOV1af08lyoHEqjpYo+A3zACgreElzB0jdnhDyyeDP0aDG6wadgF7gu72vOZNI3/M1Q1+7RYaZV4zSkltdY66kN9gn9WIXbfdDU/Vh8YYf/N+l9OcUDCjCY1RY0ZbaQfC/dySlPN+CNp6XzZNBp4uI38ZEWDQMliVGKzvqmPqEe1MMy8S7GxeSkpj2ik2Fe/V/2r5Z3d4MxS0o8CWDM7bIi8c35IrpYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqfiOlZyJC7ZjASMHI7+j2IPcTjyHAI4KmqEmS1Hd28=;
 b=RgcNnTc160YP/P3aWVIpAbc/vcFVBeUcwUNQQT2Kklsdn09hA9WkPV5AixtkLhnnMfcXpj3eLczocwWMsHDyderYhKkBjXTbAVwEfDgFY9OAa5gEP4yFdMKepem6CnNoVFzildXvpklKB2O1nf0TVTienTkgeHdYuK5A+X0Ax2k=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1254.namprd04.prod.outlook.com (2603:10b6:910:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Thu, 18 Jun
 2020 23:31:59 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3109.023; Thu, 18 Jun 2020
 23:31:59 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Thread-Topic: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Thread-Index: AQHWRNgorE8Ue5/pcEOqVFi0S2b5Lw==
Date:   Thu, 18 Jun 2020 23:31:59 +0000
Message-ID: <CY4PR04MB375112FC181C9A625137DB94E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <18da4d78-f3df-967f-e7ea-8f2faaa95d6b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: octiron.net; dkim=none (message not signed)
 header.d=none;octiron.net; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d700c41-35d6-48cd-26d8-08d813dfcc0c
x-ms-traffictypediagnostic: CY4PR04MB1254:
x-microsoft-antispam-prvs: <CY4PR04MB12547CE84C53DB24AD118067E79B0@CY4PR04MB1254.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NvPNsmX6Q/KUK16wwREm63l9KFDEUxoxUrjP/MCUrjjffk3eroALRSDWTqC1VtWVH750Bl3CHcmVk7xf3lZbNZch1YwWVaJBW1n0dMiaYF3bKetZr8MoRfB4jiaOabQLzI7DrCjP6YRi4/1cQriOEadhkUzTcKDnnYJCikTN0tC7+USbkiGKb+Pb8bkaTuBfuSqY13MH/ka4aq2coasysR34O0ffwOMpZmDJJWW330f29cKFFQJyjml+hgU2tbc8u3sVhOMxK9iMNLZEuahPHizGj9uRKPtlBv9Gox4ecsL6IGydTjGuSUWTxuOE3rOSXFsFL2afIP6ABkLK6v29ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(5660300002)(66556008)(66946007)(76116006)(186003)(66446008)(66476007)(8936002)(64756008)(8676002)(26005)(2906002)(33656002)(478600001)(71200400001)(91956017)(316002)(110136005)(9686003)(7696005)(52536014)(86362001)(83380400001)(6506007)(55016002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: haORWR8CB2zUSq/Ggesqv/aQ/Hg+PY2OP2nOJ0mVQ4a7Kf3B3yZMqQDF1wrZCddD5O1KrJsWGVDIYVVptCBRfhmhFxIea/zcVk7SWrzWJJf75+gD/sVltWddqxPqTpOPk479k7YjcrM8EQ3VlC3M4K7rF9VoCHyMN9gh/z0lfNzninfaKTjtXTMcaL0JzbDWOUk1i2croqO8NoYQktK7ksi7QRnOkEq8MSJAwKSwP7RQ8N4wVTc5mcXuC4yzcnJiHCMm00hcRWLPg6hypB8+kh53NxI+cmf/WZkSUBn2t8YfSy2U726hnb25WmtnA29pojKbhkANj6GLLDFGoVBsg+ex1X/l5IhCBD/cMOn5i/c6vAy0vq4QkhsymulIWfqp4GwUgrLypOnIO3ojMbHriv6gygoEZioNT2E+0WGKna+a5vkOMs3wezKgLA4U6zO5j9z/q9ZTFhu6lgaVqhxEgRRl6DB8IjrQXsMZM6M6AjkyekToI7o5Rg3jjM+rx19y
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d700c41-35d6-48cd-26d8-08d813dfcc0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 23:31:59.3329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pa8lcoICFcE2RsC7ktNhiHhlObsyYlQGykbSu+VQ5+3nciwOOVyti4Y29sM20CSAbP3Yno3dXY5UOQaVyYKMBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1254
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/18 21:26, Simon Arlott wrote:=0A=
> On 18/06/2020 09:36, Damien Le Moal wrote:=0A=
>> On 2020/06/18 3:50, Simon Arlott wrote:=0A=
>>> I need to use "reboot=3Dp" on my desktop because one of the PCIe device=
s=0A=
>>> does not appear after a warm boot. This results in a very cold boot=0A=
>>> because the BIOS turns the PSU off and on.=0A=
>>>=0A=
>>> The scsi sd shutdown process does not send a stop command to disks=0A=
>>> before the reboot happens (stop commands are only sent for a shutdown).=
=0A=
>>>=0A=
>>> The result is that all of my SSDs experience a sudden power loss on=0A=
>>> every reboot, which is undesirable behaviour. These events are recorded=
=0A=
>>> in the SMART attributes.=0A=
>>=0A=
>> Why is it undesirable for an SSD ? The sequence you are describing is no=
t=0A=
>> different from doing "shutdown -h now" and then pressing down the power =
button=0A=
>> again immediately after power is cut...=0A=
> =0A=
> On a shutdown the kernel will send a stop command to the SSD. It does=0A=
> not currently do this for a reboot so I observe the unexpected power=0A=
> loss counters increasing.=0A=
> =0A=
>> Are you experiencing data loss or corruption ? If yes, since a clean reb=
oot or=0A=
>> shutdown issues a synchronize cache to all devices, a corruption would m=
ean that=0A=
>> your SSD is probably not correctly processing flush cache commands.=0A=
> =0A=
> No, I'm not experiencing any data loss or corruption that I'm aware of.=
=0A=
> =0A=
> We can argue whether or not any given SSD correctly processes commands=0A=
> to flush the cache, but they are expecting to be stopped before power=0A=
> is removed.=0A=
> =0A=
>>> Avoiding a stop of the disk on a reboot is appropriate for HDDs because=
=0A=
>>> they're likely to continue to be powered (and should not be told to spi=
n=0A=
>>> down only to spin up again) but the default behaviour for SSDs should=
=0A=
>>> be changed to stop them before the reboot.=0A=
>>=0A=
>> If your BIOS turns the PSU down and up, then the HDDs too will lose powe=
r... The=0A=
>> difference will be that the disks will still be spinning from inertia on=
 the=0A=
>> power up, and so the HDD spin up processing will be faster than for a pu=
re cold=0A=
>> boot sequence.=0A=
> =0A=
> I haven't verified it, but the BIOS leaves the power off for several=0A=
> seconds which should be long enough for the HDDs to spin down.=0A=
> =0A=
> I'm less concerned about those suddenly losing power but it would be=0A=
> nice to have a stop command sent to them too.=0A=
=0A=
OK. So maybe the patch should be as simple as changing SYSTEM_RESTART state=
 to=0A=
SYSTEM_POWER_OFF if reboot=3Dp is set, no ? Since that is consistent with t=
he fact=0A=
that reboot=3Dp will cause power to go off, exactly the same as a regular=
=0A=
shutdown, it seems cleaner and safer to use SYSTEM_POWER_OFF for the entire=
=0A=
system, not just scsi disks.=0A=
=0A=
Thoughts ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
