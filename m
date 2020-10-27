Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADD7C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 21:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DFDC2223C
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 21:18:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="BK7HasRd";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="g54saqVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373725AbgJ0VSf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 17:18:35 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:25307 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373460AbgJ0VSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 17:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603833514; x=1635369514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7KD75BZvEvM0m3AFgzVFpuc2CTtccZve36+vbuoyV5A=;
  b=BK7HasRdb65gHPkwUa7/xADvMze5uKZ1UaBHkYEXuzPHuQtvuVUXriPL
   m2ZKJEipiLoFZMTqIfFlRkPkMYNyiYXRXxakBBAUP/9lCVOfbQAF1eIoI
   BheT/QzGbimkKtwlFHCTGH1ux8J5lFY5LruAvftwdcVij6sIpNBSU4XG8
   Wn3w3V8THK2NlPq7k6Izw7J8rDXs18jsykmI00BAH/ZaWD20VglfOln6w
   0jgfAdBTaOXo0vlSH5IUkvEdKAc1CUK/+fYe2DXBF+QNGhxgDm/8Ar/vk
   RPvRed8oyThMhPfjbErvzITRzO218gVmO0Ri5IFbKYDJSZ39bSlTBpcN4
   Q==;
IronPort-SDR: P9WzN3MbQzRVphsgwDnRFndEEK6Fl92ppA8Wfc44vxfWBw5FVpBIyy1EG/R0dC5jWW0gbv9t7U
 oRSBm71MCrIOqKxYJYyZaAhC0FcaxeQqYEGq4vq5BMhw/LStzUKV1IV05yeuh5L9sCJ0gZJEoZ
 SPZl2DdyyZQzE4NXruPPddSAOayYY9AoJjirXMRn0SpFMOTZJChL1ebX8nTQD+XR74cAqFb8Yv
 M45KztZAbW2loVQEvUovzOjNlfYxQyWrWlPhFAjPCsogjdU9kqLDaiBq8C/fZstVHoW0oRI2jr
 lJI=
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="96211561"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2020 14:18:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 14:18:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 27 Oct 2020 14:18:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8fBC2DjYB3BU3xUucN7u1mDct8sbotd4CXzrrBuhswb7dPF5atWZ1UZKcIcfNWmW7O1Y08FYpSSu0jj2eRHUeDOVXugpmEReNt6Ck8sSgMbOKATr/N9Xtldi8tRLPAorxz64ohzHEcYxuotN7EOKCpKnXwpkvdgZWFSRhccDf1PpWr2wZ8Xvoy6ofOFigwlTqcs3Ly/b6SMni8PJF/DrEYY5LFJ1RHhoLsUXh+gHrZAanX6xzHKTDsqjau3QJojtJHhsZW8PBen0tSw7jYAyCVDIUH4ZnoogksPpPP/7HhROfSEP367cb5QFET9WAG2qXiHtICkTWnYHmPIuYBlKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OW5IAIFV+m1ZL8Fm0eUIC0ckfIfg357Nfk4ATzdQqc=;
 b=e0yApETorPp5WCrmhcGyagWxrqL7XpZqruFXz2J0ht1eeAsSrC1orsh4JbzgBvyZzpbu92pbMHxLiHnpZRXLDTLSCeQD3Mujmj0lkBeDMa6ry5KwZmXk2F6Q3SnqijT4fvAWF4SrqL2ZkUahpcDPbWph008PdWs3aUv8zi/feYf0aJIiyryiO1faG9PhJP/lM6js8aAI0or+a6p3pynoXEetKV/VH8qN1B6wnA3WMB56HgJum6R4b0fCwx/eEFgnPf6uM1uDEQVjgZ8hvlk6s4a/ciAfaC70P/wEova/4Wrz20dmkjzfS8VNaMHKDdD/lmEFlrpjfNqpMTMMszMNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OW5IAIFV+m1ZL8Fm0eUIC0ckfIfg357Nfk4ATzdQqc=;
 b=g54saqVS5+I7/ahDkd67lQ5kt8Sida4o0c4nzAudCPHoEVSinK5mvtwZgh2gsAWzsM8M0Zm+XL/S+u34SFvhn2vg8rwxusfiRRMdGc6Yhl/tDGwL8eVoIa/iBgdxyUMmgSr8IX3EZxvq0jLv5oljz/VLycVQbc/lbbxp0PepTsg=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by SJ0PR11MB4829.namprd11.prod.outlook.com (2603:10b6:a03:2d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Tue, 27 Oct
 2020 21:18:31 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::fca2:8bf9:e390:a0dc]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::fca2:8bf9:e390:a0dc%7]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 21:18:31 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <martin.petersen@oracle.com>, <david.partridge@perdrix.co.uk>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: Adaptec ASR-51245 and aacraid driver timeouts
Thread-Topic: Adaptec ASR-51245 and aacraid driver timeouts
Thread-Index: Adann+LHqUCdaxUGR2KKa89As+/XGAERfSDfADArLGA=
Date:   Tue, 27 Oct 2020 21:18:30 +0000
Message-ID: <BYAPR11MB3606DC1784D91F9337E016B1FA160@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <007e01d6a7a1$fed7d820$fc878860$@perdrix.co.uk>
 <yq11rhk8wre.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq11rhk8wre.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [98.207.105.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2531144e-235b-464f-f5ce-08d87abddabb
x-ms-traffictypediagnostic: SJ0PR11MB4829:
x-microsoft-antispam-prvs: <SJ0PR11MB482986E3783E45DFF11C8E9EFA160@SJ0PR11MB4829.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nu9BFCInILxOaATTR/yu8ioUinyxWxzzE3PmYkyP4vWCl3VIALOI8OEuWM8Cx/GdR6g7bNLk5WQt5ux86ysj3C2skFET/qLwXnQDS88Lo2cRUCWUgvbOHFLDt2djRqhm1FFGk3GMjOEA+aX+Dpd3Ucz3bxhwcoucNXZNUP7fMNL2Q6odpgPIkXngnZmO+0FzrWE5xBDMqylEURLJ0FXWSnicmu7QU0kEFYWsr6oF2QeQ5SIEsSwCYp91+gx3jx+JsWTualOALYzUOjmp9HStR99+0/eBQkVesR6U8hdALDAdBQ+kgQdmeuMY4NAqUaKFw+5S+jskhDDzM9+UWYx4A/Wyt1eV1m8JXRuYTnILpvek65ubCPNF1oDvTO13jVPYb8s6NH83xEBnMAHFS+W6xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(136003)(376002)(26005)(66446008)(83380400001)(7696005)(8676002)(316002)(9686003)(52536014)(53546011)(5660300002)(478600001)(110136005)(966005)(4326008)(71200400001)(76116006)(6506007)(64756008)(33656002)(8936002)(186003)(66476007)(66946007)(66556008)(86362001)(2906002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YXGyLIQgAOTY+xzXJajP5ZF9mM9R/wzABOoHdbbr+k5qzZ5UhRhcyHYID3jERSrz7fBrTpaZXI1zbQhw/8SYBUqc5ghkCvHMZpx3aLXAvtG/GZjLftebNbXylkcBKtGyyf5sJBIsCCGo7Jp23gDYi5UqDXU8YDFLqlHXoqKaD2r7SSCdNCnyYOOwsucvV60SJtJJ7S1Rr3zRB/oVXzVUvbFatA/G4vEmjlH2wcVsDjkslGBha/vnslBCDrvt3u8lg2Kb8L9M+CUd/tgqijRV/roPw8AUrta1y1unr074m9pEd0Rkvsq0Ik82sj9xAUG6h72o/I4dUWbmp9zyoIV6CiIxaKl4qQr5NUest+uXv2K4UsSe5VAwFgFbzFBP2oe3GTRL3VKFO3I2E92yvmGxN7k02sRSZXcKd+//SIALzE+uScoTO547lXi7j8I6ivqvC3WCB1VecV3P2qyv/3b7UiDIud2Y/ctKcV1O58pkfY3T/Tjuwdbx6XCsDw9X0kUJa0KSaoGFOIaL0jDviwmp9P8X1ZhlZCJfnqqzxB1Pe8WKdfVYE1bw3N7ljASMtxs9TExBup7SCNs04IpCphD1FDwRLVzrfAzhCenG8AKn2Jfq6Q6OpGR1TlCALl9mat9yCk/WmxhldBd8iJJjxROFzg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2531144e-235b-464f-f5ce-08d87abddabb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 21:18:30.8764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vRa9IlgtjqGHSlZpU8vR7q2OftZJPEy2bjrt1zt+kb86xXNHbdcUDWrJHtnMSYRBFWjWmp/AXseQwO/sXnTgHrhCvjTqadgmvyxFNsGPT6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4829
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi David,
Apologies for the delay in response.

It looks like the firmware failed to spin up the drives.=20
You can try "arcconf  RESCAN <Controller#>" and see if it spins up the driv=
es. (arcconf can be downloaded from https://storage.microsemi.com/en-us/sup=
port/raid/ )

From the description - I see you are using a Series-5(ASR-51245) controller=
, which was marked EOL in 2012. The last version of Ubuntu supported for th=
is product was 11.04.
Since there have been so many submissions (both kernel and driver), there c=
ould also be some compatibility issues between 11.04 and 20.01.
Microchip no longer supports this product.

Thanks
Sagar

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, October 26, 2020 3:15 PM
> To: David C. Partridge <david.partridge@perdrix.co.uk>
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Adaptec ASR-51245 and aacraid driver timeouts
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> David,
>=20
> > I'm running LUbuntu x64 20.04.1 kernel 5.4.0-52-generic with an
> > Adapted ASR-51245 hosting a RAID-5 array.
> >
> > If I configure the card to power down the drives in the raid array
> > after a period of idleness, the next time my server attempts to access
> > the logical device I get:
>=20
> If card firmware decides to power down the drives, why doesn't it spin
> them back up on access?
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
