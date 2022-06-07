Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFCFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 09:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbiFGJhU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239791AbiFGJhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 05:37:17 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7251FC2
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654594634; x=1686130634;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=67K0cxBN7GBzGZJUTP3S1P77IR8YduS4rkNBUrHWZAs=;
  b=n2G/ieMryM6qSETlAoal4uaLBONq+TVZHo8fMBximHRCtLAlevh58uPN
   GtECjk1YPJ7YOtRBbl74/XZWU3zbjS7608aX8g+Vq2j0qZsAbTL9NyYhE
   fdloXZG0UpD1IKt9BGG5npIykIiw0AUVdSDclJq5/fjMdDAYKJeD6JJEE
   xMbCrH5KEdgc/Wgx/7rzXcbJFH/aIwR3TA1HTLqj308WZmRwMMbFo+Cer
   m6oT41YC7x5he6R5KM6ciwZ7i6HVP1Kjw2oCKniyBOBI2GchGfbZjY95P
   Fiupl/nESp7UWoADLN9diLevlMZnTZPCj0qPXt9FIFVUT8oPyCj7Iyo7Z
   A==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647273600"; 
   d="scan'208";a="306741516"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 17:37:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWDZ2zqBKWkkzRfFKssdtf6IoRg8D6mkow1Wi/QVr1hb8nSS0KuuGKFkubp9wBFum3LAXhK7+p4j36egVrLo9WMWvx9VT3hG4PckczXFhJ1AwBZQdq+JYX/RCdkVepgGs/AWF9SBDqxAjifUTVP4DCC52MwCJ1k2R7LjG7XaeFS5OOaCkVlOudhbZoZhBEnGgxcrtvCwOjlitEwJAou4YBw6GXffNSpLfdiKa9ltVAmfgYU2gHvfRoVR1E7JCHfJOWZ1vrtX0AGJmtDo7EXahi/bXLRDCKCt8R0XeBMKnrdLRoxkqiF7KW9kqL7F1KlJinI8YFYFW8HLh6W32NIJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPTLKqP+yOVAbm7c7tvFDvhM4NJU/3CGE5fUn80r8AM=;
 b=hdPYLdwZvHutZWhK2Ji+Lu6EOBhSfENXQJTeLGHlz7twxW5qYg44bVORvJ06scDX1iGxc+sMbgsIUGDcXUeIPrUFvw2wyIVXYad2hn0wrMliEic37U5JVMaL11x7QZ73EDpmhBCElAE0yhHoUbgNx7Bu8pDIy3V7uZuFWPosfFcFTcY//3bua2yeqyiG6PvpCPhS4KtExGy70plEF6en1E++jpa2xSEYm2mZhlrP5xjKj1HsQpv5hlWrjRGlPE4TAXUZHyJcyUU+IoBA3Wz+ZPN/0VMgpupKFQKj7zoYWjibZyPKeMLHeLQ2tT7Kgc/2Eoo6lNwE91OyIMtQF+8qGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPTLKqP+yOVAbm7c7tvFDvhM4NJU/3CGE5fUn80r8AM=;
 b=LZSjAEFKKqUk6fdz3Ot9Phrx7f4y6laqcTwsw8qnhvimaG3wJPWYPxQxSitI+JOMXSrhvh033YtyzGBKzL5raoDODRrk8TR25hCb86nVNRm2yYE1GSb32CrJ5lWnsWMgufinzrxbpad1Kw6JXZ5q4UH+fhUW0wk+kqZvyHZVkvg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5021.namprd04.prod.outlook.com (2603:10b6:805:9f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Tue, 7 Jun
 2022 09:37:10 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617%3]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 09:37:10 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Thread-Topic: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Thread-Index: AQHYek88ElC509gMvE6mTbpf/6AP0q1DrIKAgAADMIA=
Date:   Tue, 7 Jun 2022 09:37:10 +0000
Message-ID: <Yp8cRb77m3f7zZTH@x1-carbon>
References: <20220607014942.38384-1-damien.lemoal@opensource.wdc.com>
 <Yp8XXXX/vYKvuvSS@x1-carbon>
 <a2ca3cc1-f948-e9bd-c335-3b75190fac49@opensource.wdc.com>
In-Reply-To: <a2ca3cc1-f948-e9bd-c335-3b75190fac49@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e702c234-cb54-4731-92ab-08da48694bb0
x-ms-traffictypediagnostic: SN6PR04MB5021:EE_
x-microsoft-antispam-prvs: <SN6PR04MB502136135EA1FF84CA0C6818F2A59@SN6PR04MB5021.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b2wKzfvEpwEkehJdlaOtWJlVRKG+p8LVOOnOqgLLq4ANV1NncApnTYW+zzgUCca7SLtrjz4FuEu09hICPAc6fOdZUlPHa/DpmeX0hKzqSdOdFX9g28yuyLBC9I95nQwZcEbIf6MnILj4hvRRihnvS9ZbN2bxJ2q6j5ETIOTn7qzgxHtumnQ2xsN7b2vW2AC37/OPJMjAlJ7PdCffmxgm7YuKVIK3bdy1X9ZnPubgheSMigg3McguPNpsHm8KLigqkhEhmzkhmW09yyHmV+lM8p/YoJp/GBz3NFIwJRV5Bum+HIG6TNkW9kSyo+lC/lgRHlWV7tniqX5kg1B2yLbnrcVZJMP07c2ut8FFVDltXDENOR9i+ORWUHAZmL7cYHGBg4sO35WFX/O8a3EBPJ54BhQDeNl3cUYczuNuSol1fFSOR4EZO7VfDLet5XGCY8nX7EAviMSernS5kpRtheMZM1oPq6ICUuNJbK8IhBuHJq+RmaE4R7nvXzBkOONDTHC/SrI187kUz9kHIyo8tfCPpTcXkYSYBRPZVsYZIZ5bSVNJIgEV4E7p+8ca5Quze9XaMSnL/2coNYD1fe7Gq/IUhdDhvn7R7wY/u27VGjj2FpuRb+FvGcmhtituK42AFAdMT1BxBiBehmgGDnThjC8AiESCIb00qUOmb7B4v2dv06MrpUNA96i4uEbRiENzqqVyFdxx9cBPFitvztYhpezWEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(4326008)(26005)(91956017)(66946007)(76116006)(8676002)(316002)(66446008)(66476007)(66556008)(64756008)(38070700005)(54906003)(33716001)(71200400001)(186003)(38100700002)(82960400001)(8936002)(83380400001)(6862004)(2906002)(5660300002)(9686003)(6486002)(6512007)(86362001)(6506007)(53546011)(508600001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vKlLIsDkJVTD4L9JABByII6g7B26jLhn9XDcLwFVu3NstyuTS/U+M7c2yxKM?=
 =?us-ascii?Q?RN+2QvV/sglZfG8O42/u5wMri4DkLMqWRsWAbGI/rRfAZV9KZk2m1XIaqcqW?=
 =?us-ascii?Q?RxQlwrgHM7YzYt5QG+nRqfpKxQHviLXYTTVdO+yvT0bYN3PziNYYVcGUBUhT?=
 =?us-ascii?Q?a/b/HqVv08dD1siSGDriQq7PqCas+g/aKLrQ7MazwB29IKaoXbHcFlZ3Dh5j?=
 =?us-ascii?Q?N2fsgF56Be35PYBWj5jwPpLfTZDScU1KQrCPAhZmUqWaGhEWb66TOKONduDN?=
 =?us-ascii?Q?L+3wvcdxfFrsjqPqIDYvDso6HCMAjKhsr0nsnnTv/IxYSKi9CHw71BRIEXRl?=
 =?us-ascii?Q?PjMIROJ0tpcfcxVDeBJbxFhXToq5NFYi6cPcMPVhff8pugxUfaDlhPxTW/wq?=
 =?us-ascii?Q?ZIGfBP9h1t4/6V1YtpR01shuwSPSlO4GBSj5jvRNZdCJXxAzI8Q7MWtfwml0?=
 =?us-ascii?Q?2fXzUisGXfhlGLaef4wRRpQ40HqZVKJEOIwtvmobs+BlZT5tjySsfOOPMLsj?=
 =?us-ascii?Q?iy/U8qDEaIFptrXMwl4vdeQuw/0dWykIWiQglYXFQxOcgfoBjaHVdWAz4WI7?=
 =?us-ascii?Q?iMfx1IFQGQ8mpCnqdGKub1bGFBU/PurgJ/x2k8HMHp2Mqg+QrqiIgB0rRLLE?=
 =?us-ascii?Q?GjVzzDr1UrVhghotP5rHllkckb0iANIf+JbgJ49JmeOqyvG0cvjRgFu8nCkB?=
 =?us-ascii?Q?jDNtju5M/QBrFKLIbLhcRh3/5AMd2mlnbxQQRfMGzED0qxT155+q91MemEF0?=
 =?us-ascii?Q?8nYbbi0bOQJrIdu2t/uZX7SHO8mD1qq2aAadmHeLTMkx7xMGyBKXIvOEcY5o?=
 =?us-ascii?Q?enbd9ZZCe8SjWu4wMH7QbGKLtFthfuPmDqGEcKxn6qz1P5198KELGQQs27dj?=
 =?us-ascii?Q?d60qUVMffTA1VWEp2KuBe5+Ictx0btO6IdauMMjXbUA5upj4l1gZWR2im6fM?=
 =?us-ascii?Q?snwytMg7V+yJDQD3xj6KjGYrtuLttfEPHSy7PGiM3/BMVOKhOpXRTxO2QN6z?=
 =?us-ascii?Q?JzhdXWF/WikwgDdDlsRjljrm3J4ZHqVHaZjNaMJN41tpo5R1aNBkHjKhnsO1?=
 =?us-ascii?Q?w1MkEPDQaqRQdkJVBKHsnO0LA0pzxr6VP+Ammuf0YfJ27u/vhELRNZgbZlB9?=
 =?us-ascii?Q?5ZHTgo0SisjAa7a9Zc57RTn/wpQGUDnuTTfCDoLjwAfd1JzzAH9DRIebT/d5?=
 =?us-ascii?Q?Ch4uJwTFgSQnYLprupukx9n838ZmMbBsF5RmkRE2Pkwlql57h1TnQEQ17b8Q?=
 =?us-ascii?Q?YqeUpJtrlo7VLrEgowe8j6JuNjOXFVP1LUauK5HIbeIN3NIs6mJbDXigrGDw?=
 =?us-ascii?Q?XBPnS3KU0IFGfHgKzo59NucxP5toT84j8gDOXqgSRTooo9iK6L6OZXIWmA1v?=
 =?us-ascii?Q?gXWsYWkK1e1+FNiy2L4dgHeBkvez48QawbAWTHUiL1djEEzVI8C1pXxF+uu4?=
 =?us-ascii?Q?gfNA8v/y+ZFzIG/VmcW4M/M4AhXTTtdxDcb8DdQqcjMSpoG2ajbvJvgsMvtr?=
 =?us-ascii?Q?IwnRXGwy54jGBm1djtZK+gR+2YDH3jPgqa5jK4HOsToPddHKanLzp0WkR4s/?=
 =?us-ascii?Q?OpvYTK5J//ve8jwG9Ek9QddY8IsKWc8159aD6Rfvda80BkFcIUuYg78DBNlb?=
 =?us-ascii?Q?TEnCNuOfQvbIJziGJlg8zgYb5KWvNKDkoo5ySMmnjYT/dV8rdoFBzACkavL9?=
 =?us-ascii?Q?pXLcWj124r5dw1ay5os1ZbT36qCelh476PTafwJLNKApYpckEEKio17zD00C?=
 =?us-ascii?Q?JMZHKfMnQENrFYSuvPhwRE9T5EoY56I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <291D19C873750E4B8EB2D050902D4A44@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e702c234-cb54-4731-92ab-08da48694bb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 09:37:10.4350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EbSji2rWsljnLYA6o1r9wrkqpeQG+NX6t5JwZgCD5zQlGnDzmchrMpoyL2xRO5qsZ7HG1wUXBGM5F3eH4QKOcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 07, 2022 at 06:25:45PM +0900, Damien Le Moal wrote:
> On 6/7/22 18:16, Niklas Cassel wrote:
> > On Tue, Jun 07, 2022 at 10:49:42AM +0900, Damien Le Moal wrote:
> > > When a write command to a sequential write required or sequential wri=
te
> > > preferred zone result in the zone write pointer reaching the end of t=
he
> > > zone, the zone condition must be set to full AND the number of
> > > implicitly or explicitly open zones updated to have a correct account=
ing
> > > for zone resources. However, the function zbc_inc_wp() only sets the
> > > zone condition to full without updating the open zone counters,
> > > resulting in a zone state machine breakage.
> > >
> > > Factor out the correct code from zbc_finish_zone() to transition a zo=
ne
> > > to the full condition and introduce the helper zbc_set_zone_full(). U=
se
> > > this helper in zbc_finish_zone() and zbc_inc_wp() to correctly
> > > transition zones to the full condition.
> > >
> > > Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
> > > Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > > ---
> > >   drivers/scsi/scsi_debug.c | 27 +++++++++++++++++----------
> > >   1 file changed, 17 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > > index 1f423f723d06..6c2bb02a42d8 100644
> > > --- a/drivers/scsi/scsi_debug.c
> > > +++ b/drivers/scsi/scsi_debug.c
> > > @@ -2826,6 +2826,19 @@ static void zbc_open_zone(struct sdebug_dev_in=
fo *devip,
> > >	}
> > >   }
> > >
> > > +static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
> > > +				     struct sdeb_zone_state *zsp)
> > > +{
> > > +	enum sdebug_z_cond zc =3D zsp->z_cond;
> > > +
> > > +	if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> > > +		zbc_close_zone(devip, zsp);
> > > +	if (zsp->z_cond =3D=3D ZC4_CLOSED)
> > > +		devip->nr_closed--;
> > > +	zsp->z_wp =3D zsp->z_start + zsp->z_size;
> > > +	zsp->z_cond =3D ZC5_FULL;
> > > +}
> > > +
> > >   static void zbc_inc_wp(struct sdebug_dev_info *devip,
> > >		       unsigned long long lba, unsigned int num)
> > >   {
> > > @@ -2838,7 +2851,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *=
devip,
> > >	if (zsp->z_type =3D=3D ZBC_ZTYPE_SWR) {
> > >		zsp->z_wp +=3D num;
> > >		if (zsp->z_wp >=3D zend)
> > > -			zsp->z_cond =3D ZC5_FULL;
> > > +			zbc_set_zone_full(devip, zsp);
> > >		return;
> > >	}
> > >
> > > @@ -2857,7 +2870,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *=
devip,
> > >			n =3D num;
> > >		}
> > >		if (zsp->z_wp >=3D zend)
> > > -			zsp->z_cond =3D ZC5_FULL;
> > > +			zbc_set_zone_full(devip, zsp);
> >
> > Hello Damien,
> >
> > In the equivalent function (null_zone_write()) in null_blk,
> > we instead do this:
> >
> >	if (zone->wp =3D=3D zone->start + zone->capacity) {
> >		null_lock_zone_res(dev);
> >		if (zone->cond =3D=3D BLK_ZONE_COND_EXP_OPEN)
> >			dev->nr_zones_exp_open--;
> >		else if (zone->cond =3D=3D BLK_ZONE_COND_IMP_OPEN)
> >			dev->nr_zones_imp_open--;
> >		zone->cond =3D BLK_ZONE_COND_FULL;
> >		null_unlock_zone_res(dev);
> >	}
> >
> > Isn't it more clear to do the same here?
> > i.e. set the state to FULL, like before, and simply decrease the
> > imp/exp open counters.
> >
> > zbc_set_zone_full() does some things that are not applicable in
> > the write path, specifically this:
> > > +     if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> > > +             zbc_close_zone(devip, zsp);
> > > +     if (zsp->z_cond =3D=3D ZC4_CLOSED)
> > > +             devip->nr_closed--;
> >
> > e.g. with this new helper, if we are in e.g. IMP OPEN, we will now
> > set the zone state first to CLOSED, increase the nr_closed counter,
> > decrease the nr_closed counter, and then set the zone state to FULL.
>
> Yes. I am aware of this. It is indeed a bit inefficient, but this makes f=
or
> a simple bug fix by covering all call sites (finish and write). If you lo=
ok
> at zbc_rwp_zone() for zone reset, something similar end up being done, th=
e
> closed condition is used as an intermediate one. So that one should be
> cleaned up too.
>
> We should improve this, but I think this should be done in a followup
> patch(es) and I prefer to keep this bug fix patch small.
> Unless you insist :)

I just saw that zbc_rwp_zone() does the same after sending my email.

I also saw that zbc_close_zone() does a:

	if (!zbc_zone_is_seq(zsp))
		return;

(Although I don't see a similar check in zbc_finish_zone())

So one has to ensure that both SWR and SWP are still handled correctly
when doing this cleanup, so considering that this fix solves the problem,
it is probably better to leave the cleanup to remove the extra (and at
least in my opinion, confusing) state transition in a follow up series.

Therefore:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
