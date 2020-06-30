Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488E4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F342078B
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fyxpam+W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fGwpmiaz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgF3BFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 21:05:16 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:51518 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgF3BFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 21:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593479114; x=1625015114;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=EiUt6RAqHhM3dWT9AJbfYwKUQxCaEALNGYgk1m8TI5Q=;
  b=fyxpam+W6xarhW6Tmn0wfX00FF0fESRjOUzDCG7d576YpSepaOkGNCoz
   6Ut++8pU54Uc+ybrIWLHq+zo3FScDUepALB6wl73ZOMK2PTRbLg65983e
   VFoi9AvSFN2tFCkIlrugP3Adk2Q8MpTEo2bjIxtQPXPcSD9orY7sIIs21
   N+SomZ/JUcmz4rxZp/5jACCk4pkM+PQy/Ul9+h1NyTC7Yqgc7MeLZgsxr
   0Rj8UlmCMeBlsz4QNKbREzZvArt4pkgPBL6i+2ZL5nHgQu5WSRSslb1gq
   jER8KY0qA7yUykJgXp3g+hcseT1gFTtrhoX7iIGF6f0BwY0L1r7s9ye1y
   Q==;
IronPort-SDR: TTsaQgzdbj+tNhEmE5rnt2Lf4aJZ0hMdXpRBkv0bkrI0X7tXlkozCKhvmHrUHFzkpIy+FJRbZp
 nQmPia+FcTPujBVUPaBCQ4q3JeCgLku63VYBOJfnSz3oDgkLR2ntFY7z7wweQ4WOPOU5m5AJz9
 81F316S+1B/FbnEmoe7GQbW7GX/5NxyRgeXv/f/HRNOJyApcQSezBTU59e7sRU4G/o/eEPVX6P
 DKSs+nToVJ+OgtjzIxksOg5iHDgoJbnPCBgmHc2AvZMDdiN+U1Z27eFABFjnZsm3ic4z+jX6Y4
 mKU=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="250460489"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 09:05:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/PIGug/xvEOF9WcOAac7baej4kuOjaY8x5jLHfEII0hBTYRyNw/IBywebjLyO+gVxTbSVNsF+b1bjapQDpP5W1zjUry5pLeN/oql9KDSCjRox65k7FMcRtNU6KBDATK96T/OygGoDZAA686MxCsC81nS7lOOyOk/1wi/vwaOdW0BKSRKYb6/xWgO3RPlrYSva5dIctpyVNJOIq1BrJ/woUO+EaJkBueGtD8mFyPXTHCLsKd2SXjEMsAVBxh3Pl7uUQTjigKxQZjBb0jxwdmguzdtLtG54tu/sROcEj+zh9mIJJHlgOiCQa6LPBgaHQfsrLqe8bbdOJTWsGfIEZUTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiUt6RAqHhM3dWT9AJbfYwKUQxCaEALNGYgk1m8TI5Q=;
 b=TiNOG1YOdU1MS0NJ9E9yoNwTsnAtKJ2BkLe5sTQGqpS7odImPhloIxH4X9a9KIP8AqjmWm1f01sNlw/HLzKz/d8N9Rh7hlkoZ7BuLJd/JF/hUFqjbs2CpV1wRNpUVExzUyH9MiV3LL+HCI9BADGMxjy8YF2E9xkF/O6ljEpBYRqosvKTNgam648R5AiypcdRnZ8I6pCn8dVR2blPkMwQXZn8uuo2k5d+tDtySvfJiycg0V4A2yslfRraG3tHN0ur6/DxC9Zr5BZQurAAHMJA4istqB7PpAPVJJVRetbVngpV9ojQLu0nn2keMymuayRHHAGdZTcxGojmt8OMHgthhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiUt6RAqHhM3dWT9AJbfYwKUQxCaEALNGYgk1m8TI5Q=;
 b=fGwpmiazIp8x5k0du4O8lyZVGJbGlZDDomuOHTNefHVoBtCgApTgdZGfHGbYE+f2a9EWQjNuPVuv3V/4XLiWEP2YHaOFF11FmU9bCTJGQYU+Sfm/+bkoBl6uxvvaiae0skL8drK1JLkDsTyZ82IqO8qPhvo+2PTCeGeQXwcy1ak=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY1PR04MB2220.namprd04.prod.outlook.com (2a01:111:e400:c60e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 01:05:12 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 01:05:12 +0000
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
Date:   Tue, 30 Jun 2020 01:05:12 +0000
Message-ID: <CY4PR04MB37512529D146054814111270E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <18da4d78-f3df-967f-e7ea-8f2faaa95d6b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB375112FC181C9A625137DB94E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <fff9e48d-e9a5-632d-5d84-a0aaa68f92a9@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: octiron.net; dkim=none (message not signed)
 header.d=none;octiron.net; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d6e2ba6-5c46-4f00-b9b0-08d81c91a475
x-ms-traffictypediagnostic: CY1PR04MB2220:
x-microsoft-antispam-prvs: <CY1PR04MB2220EED54A5194087865DED4E76F0@CY1PR04MB2220.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /jQwohnL7Pjl+R1jzCKGO8zyfBFtEdZG5eWlL5iw+NwYoyhbsbI3K+DNCjzSamfHhj7++uuwhzVdswDLy2T9e3oArFce4QQlinfvBC0YklIJBpm5r+Mc22YsXt/QQTF0odUsOWqnPuQbU08ULVI2ssqTRK+P0FHMI5xmTIBZTdayiE2omLT53Z9M7yvESqxsNZ7cN7KF4ROO9znYhWhs8bFGSFCdeK8UA6ttXR/bii96JkRLMQ2ya+p+RAXPUxCXmqABdSxTMk01NHgY+5KM8fTV/2Y2BC/Nt653L5jPhAo6sPnbx1uHClV90DbfqYg59VMAg1yDfj3u4t+/TxmM2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(7696005)(186003)(52536014)(26005)(55016002)(86362001)(9686003)(83380400001)(8676002)(64756008)(5660300002)(53546011)(478600001)(66446008)(2906002)(76116006)(91956017)(110136005)(66556008)(66476007)(8936002)(66946007)(316002)(71200400001)(33656002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZdrzdsYO01oHnzvdBBgWXmVoPth1lGZgarF6lqboQPSf3o1HtzhdDQVWtxZA5cNYL2gpm7cmrRiBYDk45CEwF7riX5ErFqpek2wVzLmJZRVsZIKkTDGykR/rxdk7CS1d7DNFZIk2TBx/jsNRpadOzBPoOe0hfe7Kbk6t0tSGRZQkfMTs8RKFosCvF2QvlqvNogj04pTl7iLLmplxVkxodfD7EojwiTKLPFkmGTxxziBUmVYrufeuAsEGim/DtwDBuDS9KXl7rPSonaOjFxadVFmYCdEPGi9EXg+xhxBoxlqqL0R6iW5f0bUXxCstkMhSZ0GFj2/WL7WGVnYkZcEugbPgWIj7UOXtimlpAS30nzIzajflrZcoPr/ZZOCJASGY9r3RyqhBm5vaiouTcGEiLggVkE5ztpP7o46/7RljkufoTCTYdjdvge9rtxS01Ic9yZZp/liT3S7r0HVGNEHKHUSN6x5yV12gmJSyOLWUW6A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6e2ba6-5c46-4f00-b9b0-08d81c91a475
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 01:05:12.7079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j6vfLIRC1cW+MAOxSjT+DO68c2vVf4lbvojMkUg/uUpf1PY0HqAmHZpZYO4KbVyzLZO6U7/+78UwBQVXSj9r6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR04MB2220
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/29 3:23, Simon Arlott wrote:=0A=
> On 19/06/2020 00:31, Damien Le Moal wrote:=0A=
>> On 2020/06/18 21:26, Simon Arlott wrote:=0A=
>>> I haven't verified it, but the BIOS leaves the power off for several=0A=
>>> seconds which should be long enough for the HDDs to spin down.=0A=
>>>=0A=
>>> I'm less concerned about those suddenly losing power but it would be=0A=
>>> nice to have a stop command sent to them too.=0A=
>>=0A=
>> OK. So maybe the patch should be as simple as changing SYSTEM_RESTART st=
ate to=0A=
>> SYSTEM_POWER_OFF if reboot=3Dp is set, no ? Since that is consistent wit=
h the fact=0A=
>> that reboot=3Dp will cause power to go off, exactly the same as a regula=
r=0A=
>> shutdown, it seems cleaner and safer to use SYSTEM_POWER_OFF for the ent=
ire=0A=
>> system, not just scsi disks.=0A=
> =0A=
> That could be a bit misleading because the power isn't going to stay=0A=
> off. Some of the network drivers have specific WOL behaviour changes=0A=
> for a power off.=0A=
=0A=
The point is that the power goes off, same as for a SYSTEM_POWER_OFF shutdo=
wn.=0A=
It do not think it matters how long it will be off before your BIOS restart=
s the=0A=
laptop power. And actually enabling the NICs WOL function would I think act=
ually=0A=
be a very good thing: if the PSU power cycling fails, the machine can still=
 be=0A=
remotely woken-up as configured by the user.=0A=
=0A=
> Power cycling the PSU is not something that every BIOS will do, so it's=
=0A=
> not that simple. It could be a module parameter but I'd be concerned=0A=
> that some other code will assuming the system should be powered off and=
=0A=
> all of my reboots will become power off events.=0A=
=0A=
Or define a SYSTEM_RESTART_P that essentially does what SYSTEM_POWER_OFF do=
es +=0A=
the addition of telling the BIOS to restart the PSU, if the machines suppor=
ts=0A=
it. What happens if one does a reboot=3Dp on a machine that does not suppor=
t it ?=0A=
Does this become a shutdown, or does it become a normal reset ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
