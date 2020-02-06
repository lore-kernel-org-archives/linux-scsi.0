Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F95C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 10:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A302420730
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 10:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="btd+2q4v";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VWh7Th0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgBFKkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 05:40:06 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:7593 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgBFKkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 05:40:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580985604; x=1612521604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YQW/0UvMK/wKaAdm6SRKbzf0VWTs7iFzwwunWFwm3Nk=;
  b=btd+2q4vphPiF/zgdUs4Ri4Lp6aajZ0vR75E/7EcssgcTLWCP+he9BkS
   HredOgMoVdBTxe8zLQeUUPPeW2Hjq4+ULhYAROtak74DTYCezpaCphuPw
   Eu5duwqeelzzPVvt2jxAJJYSsPvJoIWxyimKJ13CSvkMe0ZysoV0IN5B1
   nFxvEmT+8L45tCHOwUYFfDH2r/zDp6AW02Q/0XFNg67NYaWZdYwWR39gB
   7QB+6pUPpR4UJ4IOEkBZCyh2UNfY32ek7Az/NbvlubzysvGLI7sRbH+sP
   iQazLVHNF0Ki2H2Z9U8p3vvtGDWAfHV+sLkd65IGQVPqh+owQ8JFPU+ie
   g==;
IronPort-SDR: FTvuon9J4JofATOfz/4Of/idmexQkUI5ifKQgkApqdDZAlhCqbo5A873tmhXktkFTbdm/Leucy
 XEXm2y0e2c34LvfKUDq5ErouQ/OO+afBuwRr7dJJPRgq5L95EYGYML+Fv3Zs66CSEdHIbkhz9M
 f450ujli7N60ZrFctrYNsEZwrkHS56GJvOl24TtPLfF5QwDzOBKP/4Cobqsonj3q3JNT/5QwYa
 pTX5a0dVQTG68rBl+gSCjugOL/g20yNkP5z7Eg//7vpAJTvIdO8ok/OMqnaTGFX9UOxrL3mBhl
 mvc=
X-IronPort-AV: E=Sophos;i="5.70,409,1574092800"; 
   d="scan'208";a="129241344"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2020 18:40:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALEGUqgJ+lffb7Ly3Hi6z/blATI1EYXL1+AsRv7sI3wUudZ7JjFAzgcuFxEiKs5wv0eIWrE9FnDQCUxol9SdBKZLurJJMG3EslLjvbLAAJHJrwugf5XtqsWjDFYJAaivFF5wjQpJ794neQt/2t4shWG+oIKcQ1g9MqsITx5Ce+ribhzvT42opyx+haPN8Mic+bYw4QMUkj9r0agDr/3dgog//cBJKH/MX4o29vG4uI0mBWuDC2fh9k6LQqo8h1I6e9ISSm+7zvjcGcCdgSj88lyV4C92io91L2Ab8I+p3wvlIUVGkrD0PZaaNuv7V/K667bKevjW2vcTYy8UTrBOKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQW/0UvMK/wKaAdm6SRKbzf0VWTs7iFzwwunWFwm3Nk=;
 b=jM6ssAwPqUMDWa8yWrC/zD8hp4tU5FR5Ne+FkSP/6EeAtn9m5Tg+k33R6TFk1d7XVxcd5Asr1i1fD/j/u+QYw6dHqjmgjrbxSeIWb6T57AvD1XfuoLqJt9net/y4TBgiSI6hmW9/toWB9fKHw09h0kRNE49NM1/j7ZP/XKVxkMbKhzpjvI/XHi+CY8oQvf2+qAKoDurQwzN4i4toSUVr990JaIgsGxCNKBu8Os6kqVEfyyvCUSi6ca1ipta4bhhHC48KJeVkBv/ERKdCYjFueVmfeP8ZLBxujCTWyhD7wSiYFZFkhyJQlRyfOu3OPDrTk1RI1NFKICw+OgITaBegvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQW/0UvMK/wKaAdm6SRKbzf0VWTs7iFzwwunWFwm3Nk=;
 b=VWh7Th0MF0sxBvJu5v9naPWx4nhh+KN7XZJC7xS41T0qw6xVJalnGMeqn+ibUIbXdrHBftK4SlalSG8119tfYaG5kW50eCDakh7UaPhytiLFnHJ1tA1Dmb2lWDQRlVJrVM2PN1PSSiCmWBe4JQZRJPiQSDNQ1sj+nZIwpd4HpO8=
Received: from MN2PR04MB6190.namprd04.prod.outlook.com (20.178.247.224) by
 MN2PR04MB6893.namprd04.prod.outlook.com (10.186.147.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 6 Feb 2020 10:40:03 +0000
Received: from MN2PR04MB6190.namprd04.prod.outlook.com
 ([fe80::940c:d0bb:3927:fdca]) by MN2PR04MB6190.namprd04.prod.outlook.com
 ([fe80::940c:d0bb:3927:fdca%7]) with mapi id 15.20.2686.035; Thu, 6 Feb 2020
 10:40:03 +0000
From:   Avi Shchislowski <Avi.Shchislowski@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Guenter Roeck <linux@roeck-us.net>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYg6ExsysKG0EeYEdSzahFFuKgISGeAgAEWP7CAAC/CAIAAcFWAgAAE64CAAI5eAIADbglQ
Date:   Thu, 6 Feb 2020 10:40:03 +0000
Message-ID: <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
 <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
 <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
In-Reply-To: <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
Accept-Language: en-US, he-IL
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avi.Shchislowski@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7db13c2c-1c8e-4b7c-2db2-08d7aaf0ec64
x-ms-traffictypediagnostic: MN2PR04MB6893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6893DD412A3FE0974715CF9D9A1D0@MN2PR04MB6893.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(189003)(199004)(55016002)(66476007)(66446008)(76116006)(64756008)(66556008)(66946007)(316002)(478600001)(5660300002)(9686003)(52536014)(54906003)(110136005)(86362001)(186003)(33656002)(71200400001)(6506007)(8936002)(26005)(8676002)(81166006)(81156014)(7696005)(2906002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6893;H:MN2PR04MB6190.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQ0MFRjJy9DCAISIJUtt2oY87JyJXA4Qhj+PNH97sxB4CzWSkzPRIKqZi5b6XrwePgzZng0Ps0vyY80julg1Q3ioEEmP44Q9AiIByjfTk3CoupsTPR92mo3j9SjjxcHcprHelItj9sU2ZfU3fatlBoL16BHWDjRnhkV1+TT8EdtfR6z+iZBZaIIDu2G9nnyNNeJ1kYg1aY6J5Jo5tgnSDp7oATGQWl8GAT/VySCkSJyE94z9qnk202N44OpNDxysniecITwrURq+ksMLGQFWaUeDJlQQxPu//zWRM4jqsJV3ksnA8imNK2HQO5S2DPI/TTF2wHekGGBZ3qQ97SP4591M9HuVJ+LfpNV4ZthNPUI02lFVt/OposGdeJY5ECZcW0Yy8IJ601GxPXFw/gJXefrE72kH7IQsV2qNM1YMJ85wxsSfXGYUYaOdDmlI6cSy
x-ms-exchange-antispam-messagedata: h9WThi490JrD9M3IJEeV+X6Xh5KQWnLw74Dlc3eeEl3CNoeZwpSm76Dz0UMex3TEXUIjmM1rqm6q+c/rf0eyIvVRDUbYr8R5fGp0XwQztbR1k9m495ZMWjYK3eBJmMvdkx9Ke1dbSUMJf0IGO0eDHg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db13c2c-1c8e-4b7c-2db2-08d7aaf0ec64
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 10:40:03.0346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+Hx8/SAx9pwiIHX6O7SbE8ln6pnin1nS+ly6f/yHWanqKCWYt3nrdz0Q4nzpwGxE8Wh8xFqFmWwKsV6czO8hfM/1U+G7yupmb6HxvDIJOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6893
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As it become evident that the hwmon is not a viable option to implement ufs=
 thermal notification, I would appreciate some concrete comments of this se=
ries.

Thanks,
Avi

>=20
> > On Mon, Feb 03, 2020 at 09:29:57PM +0000, Avri Altman wrote:
> > > > >> Can you add an explanation why this can't be added to the just-
> > > > introduced
> > > > >> 'drivetemp' driver in the hwmon subsystem, and why it make
> > > > >> sense to
> > > > have
> > > > >> proprietary attributes for temperature and temperature limits ?
> > >
> > >
> > > Guenter hi,
> > > Yeah - I see your point. But here is the thing - UFS devices support
> > > only a subset of scsi commands.
> > > It does not support ATA_16 nor SMART attributes.
> > > Moreover, you can't read UFS attributes using any other
> > > scsi/ATA/SATA Commands, nor it obey the ATA temperature sensing
> conventions.
> > > So unless you want to totally break the newly born drivetemp -
> > > Better to leave ufs devices out of it.
> > >
> >
> > drivetemp is written with extensibility in mind. For example, Martin
> > has a prototype enhancement which supports SCSI drive temperature
> sensors.
> > As long as a device can be identified as ufs device, and as long as
> > there
> The ufs device does not identifies as such, e.g. by INQUIRY or other.
>=20
> > is a means to pass-through commands, adding a new type would be easy.
> I am unaware of any such option.
> Device management commands are privet to the ufs driver.
>=20
> Thanks,
> Avri

