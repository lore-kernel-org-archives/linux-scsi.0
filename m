Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CAFC35247
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 22:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD96217BA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 22:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Nqo4nnbq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OFBl0c9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgBFWVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 17:21:14 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14886 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgBFWVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 17:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581027673; x=1612563673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IppJlInxQi4TqgBXjg302IRrOc8R3MukhW6MWpVRnKY=;
  b=Nqo4nnbqqJ9zwhWW7xRAGMTvMC+sJdYzOfRWBYKwRcxyEcC32bxYjZpX
   u+WqM0fBJ2x7SuCi0V5t3Ekn2shfpuLoDb2A+r+NEJa8ljD4FEGhbqXK3
   23LJuZ3yFqJnONfd/xUHiNHDHzLUC0U/uc8C5QeuDYjAp5BG5NwK/1RxZ
   HvjQe8OIb4gd66jDGEFPJ6CJxwa8j+fdW6NzWDXR36lLCB1DlYK8aDts7
   Do7JiMddR+GZ17ePTz8hKExLXhUOIbWAYszi9Sza6GpZzWJAv/Ex/iCiR
   ojURB9lD3wzzZrrNZTJvsdAHaCtlahdKWEB9be33AFudqH/dRn4axueca
   g==;
IronPort-SDR: n7YcpzwPFR4QuLG9U7ynn7m5YaaVbEH2hZVO0GBm+y+moUbi8pbvNc+J6J4J5VJjlv+r1f9Gep
 1CG+cWJlqWeXtQNuw8vXa/ZtS+DD2l8ztAgX4Qgta3xYpw53Zx9JjbpiT1jd1fdbbbM70Ws0Gr
 hrBpubCMtxPBTiSuGAYo2OMWE7zO3+0Lmk1F1kuJXKv/lem5uSum6Hf2RJ1wl1R0GqsbqUoYpt
 1YWKpww3Y6GBsCNDiTPyk4lOIu9rbzork+G34i3554CEr7oTFcmRt6NjGQMrYMaW1Kr8yi3N9X
 Wr8=
X-IronPort-AV: E=Sophos;i="5.70,411,1574092800"; 
   d="scan'208";a="129299185"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 06:21:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrW1vazuAHfqdKllBNS6WlRIetQ/NuQ0YRJkTxlmrDkr+zOi9xoLL1pQ27PBuZBMBxWjtpHXjYafbsiSzT1X3Rtb4RJ59ONwuwoduhGlTMZwGhmq6Cy9U2ZfBL7Hj4U6vXOhYatSl79C3teF4UQ4keZWJDIUNZJemSNF/PQKsbg1p/4GNh2Dcj3JwSo635bTTZ/LNMBpQXwsVmp4ygRgAFBTUwbd9twLGDXx1fJIy5WlT9/EXrOkpeoCXdig7ZuFKjgHUezLtitkXUlIq19oY3Hr/CNCqxh/c0vroDQItCFSsPG93APJV+WLgSb8eb/BGdF6ewQLGOlvyoUZAuFDRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMnQqT+czsrhAXt9+Rv2oGuq5ED/SqeImE8o880dhLE=;
 b=U+XowEPzILtBJIbtFd1ShMp0ICcWBIKM39ejeUp0G4aUKNyk44ERq2Eh8evs+jauYqbEPRXmKeco/0lmwmcMBxlN2wHCsGpwInOIVNQXOmHE9UIZJCJ1DpN9vtxewYdcEbM/HJLAi1z2kkYyKDjljwnYf/JYWrLpzKs1g9g72KUSZV81BuqT0351hTNdhstjCEZXIaCBLzJTWRjxtNc6NsCM5q7Hj7UUBbqI08Cm+RCAxG/yw1EYD9cFA6Zm+TOPWpLhITJOD0bQlr/nW6p9NWAHDYG8QDN18NgXUY03EmpJ3R4y3GrPvsIIYbQLH5LVWCpLRq5Fl7wMl4M1y2hOig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMnQqT+czsrhAXt9+Rv2oGuq5ED/SqeImE8o880dhLE=;
 b=OFBl0c9OdSjy7HIURsTqoYb9QC+FJ/W7WKWieF9kGaWc7EheywAB54J7qnkgYKFNFfYeFNnoY3LPRvyWs7QN2BbgO+10A9yci6kA4wNL0z7Um3WFVcRW73oqkyvddiu9gmEsDKij+IWVuXlqcyNlxIEY5nyY1pKfZoosl8kjQxQ=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5582.namprd04.prod.outlook.com (20.178.248.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 22:21:10 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 22:21:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Julian Calaby <julian.calaby@gmail.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYgyCYLCd8TvkGCDJX1L0irp6gISGeAgAEWVwCAAC+qAIAAZ98AgAANYYCAAIzHgIADb7iAgAAQtgCAAAb1sIAACmKAgAAMGmCAAChwAIAANn2QgAAbMYCAABlPEA==
Date:   Thu, 6 Feb 2020 22:21:10 +0000
Message-ID: <MN2PR04MB69913DA014B665CFAC3AF8FFFC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
 <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
 <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
 <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgWob+0t35AYXfzCqKtLjBgw=p8MhqDCKF=5_JGe5veqtQ@mail.gmail.com>
 <MN2PR04MB699192FB02C86DE567785A83FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200206204218.GA23857@roeck-us.net>
In-Reply-To: <20200206204218.GA23857@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.114.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3679e70e-5011-4ca4-d89e-08d7ab52de61
x-ms-traffictypediagnostic: MN2PR04MB5582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB55826AA0099FF91FE64F6E48FC1D0@MN2PR04MB5582.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(199004)(189003)(4326008)(186003)(6506007)(53546011)(54906003)(26005)(316002)(52536014)(8676002)(5660300002)(8936002)(81166006)(6916009)(81156014)(55016002)(2906002)(86362001)(66446008)(33656002)(66556008)(76116006)(66476007)(66946007)(64756008)(71200400001)(966005)(478600001)(7696005)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5582;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9lN/Uz9F0mBkZk72Hr/Fbwn1V6jEwpzx3uec0fWHN8dUml1D3eCc34/6b8/XeZ767R22hbqn+dLuAjaknnexxvZJVKnSaZFmo8JwijvFTh8mT2ekBovvyXmNZTWqLWZwxEKwmcoj/OtJkj4CLqJ5VZxgH4vuSAxkCArz29hQwEbXZMNmN+jFkmdJ/5HooiqY5pk3Fy7GLW3nEaIinfjljrCkaXcvJTWegqvggH7AAzpaHWqz7S8vXbjBU6M5krLnoYru5HVOqbh2b1Z++cmaqHxxCscWMHRt8ABC5U3loSn95xe1ifwnOSgDfniRlUydqZBgRCq7EtvpgQ9YNXUN1UlVrcITqBpGD+VoaY7DILIhgKpEe42MK1lGMHqgh1ngE0U59HfcQ5ElHVluq8l4RHoDsJIMN4l4gK88a6qnvUtGTWn6H+6KTMwFANu20ctjfVjCSnGHlVlYvIf61r/6B9jvf5EgDHXJRQBgkArqnJRwy8oC1ld1c79mDXe9+XH1CoGt9vef1SM8gYiVmohow==
x-ms-exchange-antispam-messagedata: o+oqFmdmFAbvrqQeKbUmVdjpETHMnsjhBEWQu2VKn1XF4hkNIrGVhy5oPYTE8W4LNlR48V26s4mlLqMYvu4xke7pACwg8gnMLGGzo+KWYV/847R0h701X6zMUkmPFCp+qu+3vWLlvyySWUiOrfucyA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3679e70e-5011-4ca4-d89e-08d7ab52de61
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 22:21:10.0586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lp1vCYBriIr4JIOG46QiAJ4CIdaSMmg7z9aZchE8zAMvFiTo24hkmava9JBUFwI4hNr3bwOMq4g0wbGoEW3c4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5582
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Thu, Feb 06, 2020 at 07:32:12PM +0000, Avri Altman wrote:
> > Hi Julian,
> >
> > >
> > >
> > > Hi Avri,
> > >
> > > On Fri, Feb 7, 2020 at 12:41 AM Avri Altman <Avri.Altman@wdc.com>
> wrote:
> > > >
> > > > >
> > > > > Hi Avri,
> > > > >
> > > > > On Thu, Feb 6, 2020 at 11:08 PM Avri Altman
> <Avri.Altman@wdc.com>
> > > > > wrote:
> > > > > >
> > > > > >
> > > > > > >
> > > > > > > Hi Avi,
> > > > > > >
> > > > > > > On Thu, Feb 6, 2020 at 9:48 PM Avi Shchislowski
> > > > > > > <Avi.Shchislowski@wdc.com> wrote:
> > > > > > > >
> > > > > > > > As it become evident that the hwmon is not a viable option =
to
> > > > > implement
> > > > > > > ufs thermal notification, I would appreciate some concrete
> comments
> > > of
> > > > > this
> > > > > > > series.
> > > > > > >
> > > > > > > That isn't my reading of this thread.
> > > > > > >
> > > > > > > You have two options:
> > > > > > > 1. extend drivetemp if that makes sense for this particular
> application.
> > > > > > > 2. follow the model of other devices that happen to have a bu=
ilt-in
> > > > > > > temperature sensor and expose the hwmon compatible attributes
> as
> > > a
> > > > > > > subdevice
> > > > > > >
> > > > > > > It appears that option 1 isn't viable, so what about option 2=
?
> > > > > > This will require to export the ufs device management commands,
> > > > > > Which is privet to the ufs driver.
> > > > > >
> > > > > > This is not a viable option as well, because it will allow unre=
stricted
> > > access
> > > > > > (Including format etc.) to the storage device.
> > > > > >
> > > > > > Sorry for not making it clearer before.
> > > > >
> > > > > I should have clarified further: I meant having the UFS device
> > > > > register a HWMON driver using this API:
> > > > > https://www.kernel.org/doc/html/latest/hwmon/hwmon-kernel-
> > > api.html
> > > > >
> > > > > *Not* writing a separate HWMON driver that uses some private
> > > interface.
> > > > Ok.
> > > > Just one last question:
> > > > The ufs spec requires to be able to react upon an exception event f=
rom
> the
> > > device.
> > > > The thermal core provides an api in the form of
> > > thermal_notify_framework().
> > > > What would be the hwmon equivalent for that?
> > >
> > > My understanding is that HWMON is just a standardised way to report
> > > hardware sensor data to userspace. There are "alarm" files that can b=
e
> > > used to report fault conditions, so any action taken would have to be
> > > either managed by userspace or configured using thermal zones
> > > configured in the hardware's devicetree.
> > Those "alarms" are  implemented as part of the modules under
> drivers/hwmon/ isn't it?
> > We already established that this is not an option for the ufs driver.
>=20
> You have established nothing. What exactly is not an option ?
> To create alarm attributes ? No one forces you to create any of those
> if you don't want to.
>=20
> >
> > >
> > > thermal_notify_framework() is a way to notify the "other side" of a
> > > thermal zone to do something to reduce the temperature of that zone.
> > > E.g. spin up a fan or switch to a lower-power state to cool a CPU.
> > > Looking at your code, you're only implementing the "sensor" side of
> > > the thermal zone functionality, so your calls to
> > > thermal_notify_framework() won't do anything.
> > Right.  The thermal core allows to react to such notifications,
> > Provided that the thermal zone device has a governor defined,
> > And/or notify ops etc.
> >
> > Should the current patches implement those callbacks or not,
> > Can be discussed during their review process.
> > But the important thing is that the thermal core support it in an intui=
tive
> and simple way,
> > While the hwmon doesn't.
> >
> > We are indifference with respect of which subsystem to use.
>=20
> Not really. Quite the opposite; you are quite obviously heavily
> opposed to a hwmon driver.
>=20
> > The thermal core was our first choice because we bumped into it,
> > Looking for a way to raise thermal exceptions.
> > It provides the functionality we need, and other devices uses it,
> > Why the insistence not to use it?
> >
>=20
> As mentioned before, the hwmon subsystem lets you create a bridge
> to the thermal subsystem, it creates standard attributes to report
> temperatures instead of the private ones your patch provides,
> and it would result in simpler code.
>=20
> Why the insistence to _not_ use the hwmon subsystem ?
I am not. Please, guide me through it -=20
We'll register a hwmon device and implement its read ops.
Since read is confined to the ufs driver, we'll still need to have the ufs-=
thermal module that we've created.
Next we need to respond to a thermal exception event raised by the device -=
=20
We are expected to pass such notification onward, for whatever governor/min=
d to  take an applicable action,
Should such mind exists.  How do I do that?

>=20
> Guenter
