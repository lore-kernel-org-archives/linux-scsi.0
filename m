Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAC8C33CAC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 11:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE29320838
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 11:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IgRIx0y1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hw1NLI1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgBCL5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:57:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27343 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgBCL5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 06:57:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580731041; x=1612267041;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gj/uQW7xpP7ts4drMmgqU3lWyN2fQZfJQnidJjrISBY=;
  b=IgRIx0y1wIYKBs0FSL4gPKtcQ2ezJvM9MrvF2kTpY8yHaW0uxHrUXYq6
   cijuo0j/WCBjFegOb4CxON1aJhwIEQBqbfWcgbV8hJcKerypkbtWLxSIh
   dfSWZIgADoCJxHrFRP7JmVY2GtWhEHplKWBfDNbWFvT2nuWpcvgFwqMlh
   QkSzVKPOF1hdV+EmALHu/PF8MRKZNff8t4+pvGNb2O00KvODxYEvvzGX9
   Y9I4xGGZGhaJsPx4HcL1z7ACVSAsfBETFR62XQLCt6F1S0JHKzk88Anhn
   VwJt0wJ71o4pGMl/kB6Ozf+/KYOFD6h97RuALM0yLrm/kslXAcsMDF6Na
   A==;
IronPort-SDR: 2GbKT/VjuBosUULWXJAjtk1xtrvwwrexE16bFfp5An0gW4hTQqd/bTDdDzlKgZtVmCUpMPzgbF
 YGmhsXmByzFZmW2qhekWgBWLVM2OwsQu3qRjNtCVlXJpdb0BBrp6G5czfaCCmVHBFE90j0ymhW
 D+YHPBP3ECIaNIXbKw7PWnSVyYCKOV6aVonLBgggoJX/+3mYdPIol+w34ZUF752bsxIK9Wss6y
 SaWVxHkY6+S6boXkfb1JtBLMt8TXIJCVu4SZPdnJ6ToVqaziP5xcP00fXrs3YKSFrGte6Zp1pm
 obU=
X-IronPort-AV: E=Sophos;i="5.70,397,1574092800"; 
   d="scan'208";a="129525891"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2020 19:57:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDST02TbSBNHnkFhX8xR7p+D2LNqnzmgItlMf3pnaiaFPCQUn8m9uUV3cHCEEdMbt7YIBI338GXrFn9bqtWk6yRLntEQQvV4HFiO85Z1VDN/ruwOkpne72CszJmho0tDx7LD13NVCIu4NTcT6JZzBzP/8jyprzahw35u+umjMjI76Ov5wBIhrcUgyzpztHM85r75CQSmso/sSahrR3JdqOJKcNbmwM4xLKcqF+F4dFWCIEYrj00rqM6uz6nBAMJ36Jofm7yC8ktKX5ziQqpJHtexIVzxFsvSNav72+95lNNKLhRRSzeA+5qZKH2ktlT0jhO2hoEwAdlXQEnDdeoZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCH8iSWWC3A5z0Ej/DanXDXCGE9VBlGy6H7ClXwrNhU=;
 b=mh2mNcAASlqEpdiptvvOe5cMdORMOTxC+0MLtYu3heK853aTpcKssVTLRzM9b+W8bFTBPMmMG0kz5lbRVcS5fOdiBpMP5z7HEXH0unTTUKeVY/rBe5mscEX0/iy2Fmtq0vlq11cdPkFwktNmOlN/iVPV4s7UXZU9rVaeEb/y6C9YU9Xi2OY1k7yFE44APOyn8p3QsMGKcwTh5iqheM5MCQnSstFkulSQtMwPx0KzycdrNzsMe2fvY+w9ADZynnLIGFEwFtwOOv1FI19rzjPsxv0DqGyfz5aBv7sfa9zPAErTM2DyxPRdrjXbbea0UfrMiucL14Mtphv13nJHqyy7Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCH8iSWWC3A5z0Ej/DanXDXCGE9VBlGy6H7ClXwrNhU=;
 b=hw1NLI1w9bj0SmJoceO+X/4y7RWHUz2X8yMWVIkYThI0ZiAVRKW1DR/dvRVQDqLXl2hN5H/zRblYZBblhvcdpgD9hozw/wQ+fxDvVEVmoHZNRRQ1UY2VDnafRk22vwRaxV6pRPEg7xMXYaf0/6mmkoad7+YBofTujqkyL3tDYxg=
Received: from MN2PR04MB6190.namprd04.prod.outlook.com (20.178.247.224) by
 MN2PR04MB6685.namprd04.prod.outlook.com (10.186.147.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Mon, 3 Feb 2020 11:57:18 +0000
Received: from MN2PR04MB6190.namprd04.prod.outlook.com
 ([fe80::940c:d0bb:3927:fdca]) by MN2PR04MB6190.namprd04.prod.outlook.com
 ([fe80::940c:d0bb:3927:fdca%7]) with mapi id 15.20.2686.031; Mon, 3 Feb 2020
 11:57:18 +0000
From:   Avi Shchislowski <Avi.Shchislowski@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYg6ExsysKG0EeYEdSzahFFuKgISGeAgAEWP7A=
Date:   Mon, 3 Feb 2020 11:57:18 +0000
Message-ID: <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
In-Reply-To: <20200202192105.GA20107@roeck-us.net>
Accept-Language: en-US, he-IL
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avi.Shchislowski@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31105a18-7f74-48b3-a7d7-08d7a8a037e7
x-ms-traffictypediagnostic: MN2PR04MB6685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB66851A45EA18CF537C6CA1539A000@MN2PR04MB6685.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(189003)(199004)(66476007)(64756008)(66556008)(66446008)(52536014)(33656002)(66946007)(76116006)(5660300002)(9686003)(4326008)(54906003)(7696005)(55016002)(316002)(186003)(26005)(6916009)(8936002)(81156014)(81166006)(6506007)(53546011)(86362001)(478600001)(71200400001)(2906002)(8676002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6685;H:MN2PR04MB6190.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rRBjAPUfKblY9lcOKkucWe0x70LvSHK3a0Z1aTHa93mtpyW4EijLORFcrwUPAqvNmHBbudJtGV/8azZN48a+vgkAY06fUJLq6/lPTMcsUOYCuA7a/XGk0W864P0z8n+/WxBz8EXbkuTyASrjPtaW+++zejcoLesTyWmzrDZqXnvBH6/QNhTP05mKBJjq3GtOO5XBxwHcLz10FzbcBIeBwbBejFhin6kU4t+qffwdvpuoabO0LWP+k8dP52S5W5c1pSFbmsov44Hd8K8YVf7EiUjzGihA6r71lDP8hvx+jwrIrqv9X0gvfoYoSW1scwyFnwDTAncdiUr7V7noyCezuGLzt1p2iPeJa7Cw1a3bi1pKPQVibSw5vqJKagrJZ5yOjDuQeJPJpXPmvaS35hl6jpHKlh6+D87WT8l4vMG2RcTUy7n6XZbPU4+Jk12G/+So+2gMJKO77XQUZgIt/IGufqdgZD/9rRMALbhE1FyuFJ8MQ/cErtMZ1AOrs+MuEKuf
x-ms-exchange-antispam-messagedata: oEHJGq05mGjzCCW58WA6V08EBcvRu1OmD/q8hcchkHOEsg8s8D1B4TNOTWY0oHZW8EFmX8XIz3FJFrJbykD5zN2zOZWT7Wzf7gWGEzFYLy83ZtQ7gga5L+5Ml3YsqCxJlRIInjNXsothJYBsNZkXPw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31105a18-7f74-48b3-a7d7-08d7a8a037e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 11:57:18.1337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wZaOkMNxmKxchIdTOSm5SqZcpxJul4gLyaKNYJDJFW0xI9ZVk8ssiNfXUUf6WnUFQ0+BWVNaeR2fTwbEHjE9V2V32g3pL7hKUGlu0vvHfKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6685
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Guenter Roeck <groeck7@gmail.com> On Behalf Of Guenter Roeck
> Sent: Sunday, February 2, 2020 9:21 PM
> To: Avi Shchislowski <Avi.Shchislowski@wdc.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
> <Avri.Altman@wdc.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
> Martin K. Petersen <martin.petersen@oracle.com>; linux-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
>=20
=20
> On Sun, Feb 02, 2020 at 12:46:54PM +0200, Avi Shchislowski wrote:
> > UFS3.0 allows using the ufs device as a temperature sensor. The
> > purpose of this feature is to provide notification to the host of the
> > UFS device case temperature. It allows reading of a rough estimate
> > (+-10 degrees centigrade) of the current case temperature, And setting
> > a lower and upper temperature bounds, in which the device will trigger
> > an applicable exception event.
> >
> > We added the capability of responding to such notifications, while
> > notifying the kernel's thermal core, which further exposes the thermal
> > zone attributes to user space. UFS temperature attributes are all
> > read-only, so only thermal read ops (.get_xxx) can be implemented.
> >
>=20
> Can you add an explanation why this can't be added to the just-introduced
> 'drivetemp' driver in the hwmon subsystem, and why it make sense to have
> proprietary attributes for temperature and temperature limits ?
>=20
> Thanks,
> Guenter
>=20
Hi Guenter

Thank you for your comment

The ufs device is not a temperature sensor per-se.  It is, first and foremo=
st, a storage device.
Reporting the device case temperature is a feature added in a recently rele=
ased UFS spec (UFS3.0).
Therefore, adding a thermal-core module, in opposed to hwmon module, seemed=
 more appropriate.
Registering a hwmon device look excessive, as no other hw-monitoring attrib=
ute is available - aside temperature.

Using Martin's tree, I wasn't able to locate the 'drivetemp' module, nor an=
y reference to  it in the hwmon documentation.

> > Avi Shchislowski (5):
> >   scsi: ufs: Add ufs thermal support
> >   scsi: ufs: export ufshcd_enable_ee
> >   scsi: ufs: enable thermal exception event
> >   scsi: ufs-thermal: implement thermal file ops
> >   scsi: ufs: temperature atrributes add to ufs_sysfs
>=20
> attributes
