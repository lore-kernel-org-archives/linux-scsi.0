Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8B0C35640
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 09:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5420207FD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 09:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e2lKLPnT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0Mp3CXoI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBUJoh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 04:44:37 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56196 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgBUJoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 04:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582278279; x=1613814279;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=pAYeR64yOJmk7Rc/1QASI4kxzERVP081D7Kw+ppkofg=;
  b=e2lKLPnT88t7ejQFPx0dlZy4aqKQl+ZxlWRcpuS7UOBgue+EGloyq3i5
   x1JG/lSEOUPZF6pZBWCgXbOvPbqD9g2U8IHOr3u5QeT09hv1wBNgz+kzo
   DDJ+zR8z2MNPWkrNDvdSME+zILCnYqr7Dx+VZCIQ7vcbPrihUx2UTsg/k
   iuAomuHXwDXLB6+ucvJOTOu4bJo6YXPox2rdPj4xpje8GMU4+q67RjXIn
   /9OiZqBE5FwLxDAMCEojCr2UZASZsz4dj9veylxJD9+x1Omj1OSDG9haH
   5RBNQzSMVvRAEcUXvswuseGAUKDu178FZVUMxgJ46B4OIQDxkbxu7JoZp
   w==;
IronPort-SDR: zPh6c78B/HrSWf7d0pK3HNEFqR6pWIP20Q7plEwGKBC2ca2sWhCDoAXTttOGYb+siU3SZ6gfha
 /0ZVx17+3KVhSUoS+6nmgY8fci9ZwtFEiH90XJG7FrytJobQmNBoCQZW1esEVP4TSgw5s9vZbY
 aLj4GUT7EvTfp1nRbusUDFqxePJzRywvbnYCd6QrFM2W9Adp6LOvKaqowOi3nLOU0YfJA1uklr
 eHRJcmDnTDJVG/gaH/dXXrhJIyi8CTl4scUiPvqmh97DP8YqiYa78VgBdJt4MPQpEAImN2goO8
 +fQ=
X-IronPort-AV: E=Sophos;i="5.70,467,1574092800"; 
   d="scan'208";a="232247934"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2020 17:44:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixmy0bUHf1puO0Nz2259j5H26HAzv4irjQwzYNgHzP+hC8PrWg/hUkPaiVtr5obE33xf7UmuB2kNR8/kfm55EXI1M5x0zkri3Gz/DtyStXn7BKsGKbhwrrnDTrtymVCWTkoHDqWxggLJHztpQw/uywmdjSvoGnb8rPeEvAetFFHKg2Y3RnODigcG41DYydeBAYm1oOuUeku0qkpe18uKpVPcE4meceXKbqnELJww1uVoTnN/fEHsZqLDlcXtoWdencjUfRxdftmYxtpyYlI7HVSR0kaJro5KaSJHTioD4QyveWeux2QsabkHxhKaZuNOzcRNxb0zXf+mHfKNlvIsBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aU8C+y+MN9hue3i2Suf8wiUyHskzEhWrJntKR7y99dQ=;
 b=n4x6HXwRYZBOcguC+/nbr6AkHeNR5tiwY5X6o3l2QZk4maJw9Ou6EINybov3an8z3IDa/ImY8I4IjZPXsBhOogkgF8IbcOn8jIAW/bJtpumTP5hybqp4AI43knzxyXTTndvmZJchH5yW6EcKmPFUY4hWa+IWy7wyTTH6HfWp4ZWmu0RVnjFONhVlC9zvIaVcVd8bPNcRyK8s2ttJyXpu6NBItQ5uo+kD5BoXTXP+/fyP7JQnkv/WiBcAKyJxmIJ2pyR+xVQhvvYCtl2lIC3PT4Q0LZtLO7ygjAd2PLck8HXHBoJmfa8VDrSp9HSB0epIqRaat3r7BRQqRUWaMgRPaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aU8C+y+MN9hue3i2Suf8wiUyHskzEhWrJntKR7y99dQ=;
 b=0Mp3CXoIIW9cHjGbX5c6zqx9VmeNLWfU9ckLCMHB29B6v/FjAnDHvRpBDSe4kBXYPy2rc9dV8OKSiaPfQFSdHU2j23oSaxuu3jawDRqhZCsA4H/WGm5dDbUZz3j+Y29XKJU9D8aGwXEh+8Hbyhp65ScHcayaC9pEvsLAep+EcZE=
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com (10.167.109.143) by
 DM5PR0401MB3672.namprd04.prod.outlook.com (10.167.106.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.29; Fri, 21 Feb 2020 09:44:34 +0000
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::2481:ca52:b929:3077]) by DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::2481:ca52:b929:3077%5]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 09:44:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 08/15] scsi_debug: add zone commands
Thread-Topic: [PATCH v3 08/15] scsi_debug: add zone commands
Thread-Index: AQHV6Cmadt7C6nvB00WXcBqejE3Fgw==
Date:   Fri, 21 Feb 2020 09:44:34 +0000
Message-ID: <DM5PR0401MB3591D78A720DD1CC1696241D9B120@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
 <20200220200838.15809-9-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [46.244.193.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 800fbb61-d7aa-46fd-ba72-08d7b6b2a8d9
x-ms-traffictypediagnostic: DM5PR0401MB3672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0401MB36729BFCB6C5D29D2020CF6B9B120@DM5PR0401MB3672.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(53546011)(186003)(110136005)(6506007)(478600001)(316002)(26005)(33656002)(86362001)(4744005)(5660300002)(64756008)(71200400001)(8936002)(54906003)(81166006)(8676002)(81156014)(66556008)(4326008)(66946007)(76116006)(7696005)(66476007)(91956017)(66446008)(52536014)(2906002)(55016002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR0401MB3672;H:DM5PR0401MB3591.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ItZy/CrKYfRRUzsjNZddijZxtwqdwGEaPYL+xcYUCmoCs6qqrkjBSX6BP1y9sYgFH5CPF55f9TBAMUjvt/tgsFXoqAqwM6937IK76SHkr6pkVlfqWHQ8dC6lGMIyKKJJvGrXi37+If+/yH4kITEOSEDKO9V8wxsv4I7ByMqp398Zuw5q7Ff5YrCF+TaocZAdaKKoEs6WWlO74N3yEGgbMKcC/GUIv957HUwouYGDy5fkE9uzLdoZFF5XaEHD5txg6uPCtpV971Wxnk+jKbiSbnS8b2o2MO8m5T9lPhXBcNDtDjOwCMR1qg7VWD9NFqWrmcJxVtKxnadS8ORzBh9ibAfCIWRGiW126yleew9nqKZPG4eUdiAn1csKo3j3j+4jN1wpy81BW/Gbk4OdL6KPjRtj7Z3m64kWTagM5F7Gih1L5XXOtrBJuOtjoFIx95QG
x-ms-exchange-antispam-messagedata: HDgXSAjWxPDIfnAVmNCe0jCm+ZSdmle0G+/TLjnKr+0pVAuzQdlUiFPQNQi/NzZNj8lKSuUcDazWc9qcl/7n4bpdNus5YerIPqxMxpgJh1eoTQR1dmIPmzwTArieRZBzTzgxh04wLOzoojoqB5/rqw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 800fbb61-d7aa-46fd-ba72-08d7b6b2a8d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 09:44:34.8980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uJ280pXY30vIzF9iB7UV99DY/tqa4KWyWfsmHnMbzQghlec8tUtF8hu8gFnEiqrRE+sODT3CuI/36dYvAUeCk5khdXo2RwuVkBHKqimw+mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3672
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/02/2020 21:09, Douglas Gilbert wrote:=0A=
> +enum sdebug_z_cond {	/* enumeration names taken from table 12, zbc2r04 *=
/=0A=
> +	zbc_not_write_pointer =3D 0x0, /* not in table 12; conventional zone */=
=0A=
> +	zc1_empty =3D 0x1,=0A=
> +	zc2_implicit_open,=0A=
> +	zc3_explicit_open,=0A=
> +	zc4_closed,=0A=
> +	zc5_full =3D 0xe,	/* values per Zone Condition field in Report Zones */=
=0A=
> +	zc6_read_only =3D 0xd,=0A=
> +	zc7_offline =3D 0xf,=0A=
> +};=0A=
=0A=
Haven't checked the rest of scsi_debug, but I'd write these enum values =0A=
in all caps. Furthermore I'd just call them EMPTY, OPEN, READ_ONLY, =0A=
FULL, OFFLINE, etc..=0A=
