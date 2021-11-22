Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56902C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 05:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhKVFZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 00:25:46 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9782 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhKVFZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 00:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637558559; x=1669094559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IU/iPo5mwK3wcKXQyPMZobD87IvKNXMbQXZUluw7+fA=;
  b=B4X/2OsXOGZumrb6FgJhxJckfOhjx9tchyayicodCu9Sv7csboHvfAZQ
   AfgoOo4HhLM230XIvEUcI2IgXLqLRy50k3wBAf6crJlRfzKOAyn8bvL8Y
   0xm0EJDdyCWrlr5uwYavt7eh+QXe1Pv3i7QgBHAu5KZpPhT+K9DHkzeH/
   zQpi0dcNqHSRJPjtjn4p2VvkZc0k/hNn4BOp8y+KsQhvjXsJH6AgzRQCI
   IMOE6Lt+U4N0czFvX10Nra3hFHpLyDlFetCahaollkBaBxXZIwSytmrN9
   hD3Y3hLeonD80La7zGenMd6toLi1CcSaTUBxKxUVApjR/0GBAH/RKTG9b
   w==;
X-IronPort-AV: E=Sophos;i="5.87,253,1631548800"; 
   d="scan'208";a="191085362"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2021 13:22:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQFsS7jO6S6HpXGoJ333yxLg+JBBjrxspaULQOSXiH5C9KJg4MxBU6lyRyW/F78nTL1UD4H9xLiQUWCweZUgnSuewCvNTfQdWdz6QC7yduEVmIOqx+vvbx+eavd7M9mTQwxyXjnAVm5lzX540A4s5gRv0EK05oa08RJlx5tKRAF8eBz/bvDb0Woq5AfgINeDayzxDqMF8HZ+yL7unpx8RaOBywSh+zm/YfET0N9kX0UuDStWbiEHBZe1oK4R4rlUDrdoU8LMW69TF30c9PrbVXUG2EGMEohv/W6a1FapaJNaXHedZKUut1a2nCzu4JbBoAQryYVsiJ21XGGYn0o7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYDLoz86ZRs9LXv/OWVkWwi2pW0mP6bCYf4kOwhkOVQ=;
 b=CBJOIeyuK72WgIiYHwHCqDHqlK7fuDbs+3GMuLpUNkpLqTrAXXc4ni8R5LBPYdPQ4UljJM32CJaXO4sUEiJia8OeNMv6riiZCrC//TrVNgj9aLOuUyVyc1JCF5sDBzshR63UPWR+q8fffUV7cCVktiliwKFrRd718XqXOdjGFYYl8xot2X+8vSwckbk7m9mUnD1jBdTejP3Qo2ay6YInXHtirLx+ygrHr5anc+3aZxVKmVUZsODcUmHJcGW2KmwcLlauHJ8luh0/dFdGr3pRG3tyAoVhXSONnm/rH1x0rXjUE8XsBc9q1OFM71vl0lMFu/rbtaEZrCvIGd/7pVLb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYDLoz86ZRs9LXv/OWVkWwi2pW0mP6bCYf4kOwhkOVQ=;
 b=qG3k0aIeaU/peslw9QGk8bcQlVR630XUZCMLG2nf1tWa06oe/M0aj2BfhmOp/hun0bnXM/0AJ0L4TxZGY10X+Jz8FYIhIRq66e0E1aSTvOcc8apz/Dz7J2y0ynm0+xajvVKWUGe0N3gRfticS/NlPDFvlBLTEOuw2e4RaKT6vdU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB7942.namprd04.prod.outlook.com (2603:10b6:8:1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Mon, 22 Nov 2021 05:22:37 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::28ae:301e:551e:a62e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::28ae:301e:551e:a62e%5]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 05:22:37 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: Zero clear zones at reset write pointer
Thread-Topic: [PATCH] scsi: scsi_debug: Zero clear zones at reset write
 pointer
Thread-Index: AQHX3S9SOzsKO6LefkKx8vIL1zkqRqwLcPUAgAOWlwA=
Date:   Mon, 22 Nov 2021 05:22:37 +0000
Message-ID: <20211122052236.rp7edebryjfrbgos@shindev>
References: <20211119102204.259762-1-shinichiro.kawasaki@wdc.com>
 <8105e564-bb56-e239-bac0-a2882f18a048@opensource.wdc.com>
In-Reply-To: <8105e564-bb56-e239-bac0-a2882f18a048@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b49db3d2-3b0b-490c-a524-08d9ad7818fe
x-ms-traffictypediagnostic: DM8PR04MB7942:
x-microsoft-antispam-prvs: <DM8PR04MB794296C8BBD0D29287E748DDED9F9@DM8PR04MB7942.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aZ07kyomHTZ+tnMYYLx3Nb0d4SSOGi60egCIJb69YnhTEbRjWdsxzU2GvjdWdoOc5Ubwm03lfNQz1+on+Dq/CJLgi6H1uGYyPTi2QXx0WugLRTKDnj4VocboAYn+XJxr36rrnY2mRLlFSp3L6/aCxqP2RE8Y28uuqAzekjuG4Ct/HbPzfMXe7HCGd5yrn+ZTuLbcm3syQJNwrRpdHN7hem5jTBExR405dgi5bnZF1Apsws6Qh743+E4rzhQaFpeI8BROFrce0OFMZYTTO4LIso/vC2BJbRCFpORwDbH4ZD/iradUKqsL7OimLT/7mf8/osFqGMkxCFrMTbth66MajfI4y4tlORaTApAs0YiBxZGYgRmt738aXp3sdrYxpz3jvw2xsr+42EJ8cGLiFTFJfS3SSthf+IrZ06/b2r0r2WGgd9MMzmTK9UP+DDJvnyVeJX8MI8ScptEU2vYBSmk7Ep8JntSTsxl1Wk5bCKmH4pVbImmHmXScOlvJLw4xTtpLTOU9vLc1ADFEyLCULxXKb2aGjjO7n9s7eb/PLdbeQyNEQzLbk+GftMMvHbSJrZUa/EIUBgB0EEmlYklADhZJ57RYIWfHn02j1A9OFGV0UXEFAd9W0c/PQUlDtTmzR0XMCzMDTPBmkbh/wz+/iEkKSzYbRGgJaIt2MRwYs21X8L58Zx/97+Un2rIQyOMsbAeE3J1NYS9ueTlaSJEZRJknBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(26005)(1076003)(76116006)(38100700002)(186003)(122000001)(8936002)(508600001)(86362001)(2906002)(6506007)(54906003)(53546011)(71200400001)(82960400001)(4326008)(9686003)(6512007)(33716001)(8676002)(6862004)(38070700005)(5660300002)(83380400001)(6486002)(66446008)(64756008)(66946007)(66556008)(91956017)(44832011)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9aQG7x9JIevJhXOWu07XeAE5jKs4c1HW0c1m/SDyztKlDm6p6RcHoeonnm0T?=
 =?us-ascii?Q?Ya7u+gp3M5kemMilvD9biyI1fQVKmF04INy4GS1Bw9Thw396iDgqdJGQ5WJ+?=
 =?us-ascii?Q?ymZzp7tfxBREu3PxBE0BByEN3e4e1/jJFnCuEABf8S+ypEPAMRi5eh2cFQGh?=
 =?us-ascii?Q?k4WcEb8tylyyhxmTUmEgOMkcz4gdP/8/p7CaRSYBht60nXAVMgh7bQ3gJ/2y?=
 =?us-ascii?Q?xaB9Xj+CcEFrV1Rfyl5mxlV10wDqlz5dd2GGSN8Zyncd31Th5aR69zPFuT9s?=
 =?us-ascii?Q?jnllkVwsotR4KKjSxJAkAbANs7JOspj6Z2IvZrx1nTHeqQVt04E01TOBALHv?=
 =?us-ascii?Q?GyU83YzTo0wVCZcv7N75R4WZ6dzJZMlqoNZSwLEBX3J2dIXCN5RMcyYHThsS?=
 =?us-ascii?Q?YOHfngoZZ37kiTlsg5ph8AXbihBG+nD9/Fxfane00hFcpwINC2kGbQkVN0cP?=
 =?us-ascii?Q?w+pW35i9Z87r0erFAVzSheMbxm6GDKmCKA+kqrUpBBB7pjhZTQhG+/p3fU11?=
 =?us-ascii?Q?CsukI2Y5YXRsetFf0kT8oj8b4dY5IB2Ocn5vM5VbzIKaC9LTB5XkvnJ+H96X?=
 =?us-ascii?Q?auSg78YNfkJjOAEKwQhXJeIeYQD9mwLNQZd2aYwLnlyXvf/XZYov0Pb6ZYiw?=
 =?us-ascii?Q?K7W/5Vrrp1BQgZJ1TPLDTWplWFB0Ctn2dFW78jCgSzDFs/3ga97gUq/rMgsN?=
 =?us-ascii?Q?CNKownBeMzH87w1SGk9vEInsYGzB6472JSSGG/tKJTzVknPlcPBmNaanx2tJ?=
 =?us-ascii?Q?mX2iFY0knBW0WadaEkFn/GBGRxLZZWywVY5GQWxC+QOOrwzk0yOB/e7Gafdz?=
 =?us-ascii?Q?uc9Juib1hSahAaFEGOh44U0J/lsNtbykLHnwKkgIx59CtLobEIr0m8CB688v?=
 =?us-ascii?Q?G0f9qB1TjMd11m+4r07lgjKQYjfUyTEQws40DUEXftckeZHbp70Qv1KD1hDr?=
 =?us-ascii?Q?bVo9q4Ri3fFRqrT15jMLVmsRfqzNhkR741M2+bAwTQ5LxZtqf/AtuzKdil6n?=
 =?us-ascii?Q?e2+vAf91G8kN6Z7hIXV2qTg3YoGB6jsjXir5Enw8wLA9mvtIqtYgPouHaZRd?=
 =?us-ascii?Q?ooOOw1ojOwGVVc5uNGwrXN9pFMDhr1gEIdV0pETbad41OYX5Pdo+HjDLlBRh?=
 =?us-ascii?Q?yLFiX+d7AYI8ggwjzC+PKtg4yFWbO9YETAGWKzoNnp4lsUmJkFpvr6gnpJoB?=
 =?us-ascii?Q?vO2qlT66VfWed0DRij6QJUnaF9lovkokhG83kyiHRhATA61KBmwUuVV1FICq?=
 =?us-ascii?Q?MstVUFJ45MYgqxZePm+4DBdi3zwsbI4LfACEwWJ4kZGT0z3tu01Yya4vXdgy?=
 =?us-ascii?Q?RkkTHNsriB0BokYFP7HGoa7Rf8c7CdZMU08TidCld3VHumOMphCtB53va/B8?=
 =?us-ascii?Q?j/4/aqsvKFIC6X/xkdHyf5b0XVmlZJgf5IUNZL3wqqRp+salG0Z4o6thBEV/?=
 =?us-ascii?Q?wbzPE0JJJcYwu5u3Gp9Dwxj94jD/cq4gi6hkTzobXerO9dXcXCuqZE05g4r2?=
 =?us-ascii?Q?f2T3n6bAOB+GNSf5WICyezrZdTpWM/6kUILXJegh7B5DteyvXjYrFJcLMJAk?=
 =?us-ascii?Q?kGY/79JVoPcm2RsuC0mlSKfMtBWKToHnU0/u0w6aBVVGlQpYBPsVbgzGl/Ly?=
 =?us-ascii?Q?7Yz11FjvnjzPOe12iUqz/YCvD8XJT7CpGtLzwI91QMW4Vvbr08npSvsh36ZC?=
 =?us-ascii?Q?QDeVsorHCzkBv5sgqu+QvbDJ/4E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6569948CD63FBA4C8F795A720F070A6B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49db3d2-3b0b-490c-a524-08d9ad7818fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 05:22:37.5592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wNkBWWzgdTEhVTzjhyn3xBmy0kHf9Gd6mJFZE/A7unNgUM5tnk+hcpdask9wH5cen0aY9RKPyTgBf8TcmV3Rbei2wHx4d3HbBKKiKLDMlGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7942
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Nov 20, 2021 / 07:34, Damien Le Moal wrote:
> On 11/19/21 19:22, Shin'ichiro Kawasaki wrote:
> > When reset write pointer is requested to scsi_debug devices with zoned
> > model, positions of write pointers are reset, but the data in the targe=
t
> > zones are not cleared. Read to the zones returns data written before th=
e
> > reset write pointer. This unexpected left data is confusing and does no=
t
> > allow using scsi_debug for stale page cache test of the BLKRESETZONE
> > ioctl. Hence, zero clear the target zones at reset write pointer.
> >=20
> > Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  drivers/scsi/scsi_debug.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 1d0278da9041..6d1f1a4a6724 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -4653,6 +4653,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *=
devip,
> >  			 struct sdeb_zone_state *zsp)
> >  {
> >  	enum sdebug_z_cond zc;
> > +	struct sdeb_store_info *sip =3D devip2sip(devip, false);
> > =20
> >  	if (zbc_zone_is_conv(zsp))
> >  		return;
> > @@ -4667,6 +4668,9 @@ static void zbc_rwp_zone(struct sdebug_dev_info *=
devip,
> >  	zsp->z_non_seq_resource =3D false;
> >  	zsp->z_wp =3D zsp->z_start;
> >  	zsp->z_cond =3D ZC1_EMPTY;
> > +
> > +	memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
> > +	       devip->zsize * sdebug_sector_size);
>=20
> May be do this only if the zone is *not* already empty ? Resetting an
> empty zone is not an error, and in that case there will be no need for
> the memset(). This will avoid a lot of memset() when this function is
> called from zbc_rwp_all() to handle an all zone reset operation.

That sounds a good idea. Also, we can reduce the number of bytes to zero cl=
ear
by limiting the clear target between z->start and z->wp. Will post v2 with =
that
change.

>=20
> >  }
> > =20
> >  static void zbc_rwp_all(struct sdebug_dev_info *devip)
> >=20
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research

--=20
Best Regards,
Shin'ichiro Kawasaki=
