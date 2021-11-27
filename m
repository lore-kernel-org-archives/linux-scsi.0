Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E63C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 10:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351106AbhK0KDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 05:03:34 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11789 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbhK0KBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 05:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638007097; x=1669543097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yGHiXdqR+/+ypdHOYRQpZCMelfy7J9YoWeFxL+dPenQ=;
  b=AISjuZvam0A04u395z4DwoZ2i+IVpWwJztIGeFBjkkPKtMAQnlFxsjXT
   sVHlDuKqqL9aXGYTY6C5hI6f8J/4NNbrQAqsJrNaOjjIPxtR+kMTKFmsk
   ZR8lITQ2VdC2IemFJ/lNg4MPLhzJxCu3afmpwEGv1kercc9ioDqQnNLdG
   SJ3RUsg52e1k2PTheLTmyAi3tR7/5JmGFo9dUMFrdU35amyCOCLFtS571
   b0so1J98zanpefemF2cpuzHJzB/z1VsRKi0GMq/6S66XMnGpbC5ONcgns
   XcFHJn5mO+lPIPNlLxIKL4kAjdso6HY9cdsdSy1v63AWprHWUvFnjZ03m
   g==;
X-IronPort-AV: E=Sophos;i="5.87,268,1631548800"; 
   d="scan'208";a="191607223"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2021 17:58:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFHOKGB8ma3KLRDxjyt/ligmPSlrkkHqVMP/ckE0Pl7kagv3sLAKCjfQqi0AnZrq1p8ssorOJKwzzJPGdTgOzDo+58MF+h76XJt52i0tya0SC/9rnqS+Zj7Jp4tjoeaz9463ttl5WNZSDVXlWpzOE58YQZl1aVyfjnLGm71gAvBxE6DQNkqWabVJcNSEvf/3HwlbnveJvKg+jqeWFyb1o7kiBbR7+57xWxYf1P/fGZmaKn80upyb9aE0Z6yCPbxBOzjdojDOhME9MnoYICmJAwNuJxLP0jzek4JdirpjeM9LYhqVmXzcDVKFHq0tXf5w6Y4eFeEc9zC4qNW9i7hbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnpS8FyW7sgrnXDKRslox1j5sGAAgm58SnudiboVdCU=;
 b=WbhzkvQlneHkuvQ+3+ZflMVvC1oGzhBUftL5pDAPI2rJxDj66OnELt7LXpVXXFsx1i95dVpFDSIgWjKiKgfPypCHICWXcAjRdUcEkDEl9lCTA0A7oHY7uErAr+kGhNmBsODaaFZUElIkn3TnupNlDOmZeQVAkFffcMbcOGKc9GdQUZUlCLhohdFfg8C3cf68mTDxl/4A9xWRxsBqcjoXj3NV8hJ0aFCCC6wSrf5lfRxrXx65ztS9Au6QOKoUGqEWtKWwqZrdbvgbpAL901J7tIHyG0qyYguJlf4sGdPbf2eRFD37HSu9SHmisekrTJVVS8gTjd8k+tuCUxltOcPpyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnpS8FyW7sgrnXDKRslox1j5sGAAgm58SnudiboVdCU=;
 b=gDaf+ycP5fCQw2d1yJijnUO2/FXcbrnui+Zwc54EClzzlyy5CVMx/eI/vWTluJoMfmoEpXSUKq6hWjobH6SDBzZwVGH3EgPEpLxFvaY41pUNZkLLtxchlz06xblr46E3eEwzOh5F7FLPRKxRmAd6qVUbDJYDgbxj1K7MBHf9IYQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7606.namprd04.prod.outlook.com (2603:10b6:510:5b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Sat, 27 Nov
 2021 09:58:17 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 09:58:17 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum values
Thread-Topic: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum
 values
Thread-Index: AQHX4sT1wmIgicv9UkS/qqm8MDen0awWju6AgACWIAA=
Date:   Sat, 27 Nov 2021 09:58:17 +0000
Message-ID: <YaIBOPmCC6QH2rei@x1-carbon>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
 <9172d395-29d0-6b1a-4be7-8968bfac6762@opensource.wdc.com>
In-Reply-To: <9172d395-29d0-6b1a-4be7-8968bfac6762@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5384c62-5649-4dd7-a3b7-08d9b18c6f87
x-ms-traffictypediagnostic: PH0PR04MB7606:
x-microsoft-antispam-prvs: <PH0PR04MB7606D237B3B05C706F1779C0F2649@PH0PR04MB7606.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pm7tqGt5YB/oRdApQ3DUNnJSydyHphBewxwn4QWeRzMSfcmY6ua8GUiIP96XEplFTrYjSwVvc30U7uO7BSO1CCtoEHnEW91I4ypjkvHyN3S6Nmnxqwqrh/3VS+TezJv7BhFbIryvsNktQlD+gVfzF2ROi2EuqsBHQhhO12mDkFChwjmH99z0nuvrlhGsAabzYglud88vABcWJVKtGBGzgmdNkuYmLX8Oond3y5P2o+M+nXprNJIb0SnHh5ZzZH0DX9G+p7cXlflcn44/6Ly7pfUrVkahZROnY+82opyPyzjQfm0nfP2GRDk4+s9H0uAgzcT2n62b8FMT2pGwK29OquCT+4pjSXYNoPhcBntTmTe4tzijW9rTxtkaLgU7IlxgY8lBbhJkh0SzOVReU3vrwtb1aevGlo2snsG059g2XlImmILFtq4RPBuigGdspa494Uo0uxIr9wOVja511M+MgErBkbLe0I1M6deF3chtZrPKvuCvAj2c2ibAeexF3igSo8os4XxFpE6AMJ/wvROd2hoYDSiTjX2e613+hlgrX1fYjEa5k6aH89Gu3Ui3V5EcFdUB7+ty93c+i2/RBKnGzAUyxzNkMfQ9+1aeoRLtaAy5Nugpo7uVcNnLiobKZZBltUoK+nI0f8PP2VL3DNtaHEkGkWhdEAFb4LUP8v2+J90dDmcXdqOei8NhlYRos2Sd2VCD7OwdKIRtZQgcov5TLzcqIwmblHJmeWt5Y3LzZWJQEL34dWzNzeqUfpXhQJNgXCY9JJTpwaupoePrG2Amse1Y99OLONvMinTT9FK+MsXLwoSxtObcJz1iJdUNG80R+/1TWTGyaZG1sWzqF3Wh+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(9686003)(6512007)(38070700005)(122000001)(2906002)(316002)(508600001)(38100700002)(6506007)(6486002)(53546011)(54906003)(966005)(5660300002)(4326008)(6862004)(76116006)(186003)(86362001)(82960400001)(33716001)(26005)(66446008)(83380400001)(66556008)(8936002)(8676002)(66946007)(71200400001)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AkvvXDY0OVAE9gvom+mpG7HoV5sGqOucPa4IXKbbK1DrgLwb+IWY3nNCM97S?=
 =?us-ascii?Q?SBpWBlQ+1bTW3zXVUhiJYg1EZbrFeUe2xM2Blya6LZ8MP5iV7w5QLT6Ec3PJ?=
 =?us-ascii?Q?+1hD0AMjoVUF4WjFQLNcddzH4svDOLuIdtB5BLmF/NzdoTa7hPeozcATkz+H?=
 =?us-ascii?Q?K+H+5u+QzZ1bmuQQPaXipY0EZxMg3K9MBSImubNudW2u5yP2wMfhp8EEW3BA?=
 =?us-ascii?Q?OeCYoe5DdyoXUjHi1OSIFTLcfY1xnj0nGWyMGJkS3jCSHjb64XJP57GHYVCW?=
 =?us-ascii?Q?5Wk4kMJ/t0Rz+U9P725EPL2IjJU55yrL7FML+RxeVxrytqAfKRAdHedlRUik?=
 =?us-ascii?Q?6fRwURSspkzNYGFedBLKEUzy4pv1e5jPKIxte2SIDQqsVI1yHvAhYqVlXarC?=
 =?us-ascii?Q?4A6HF0mzJGj8RATXXB4IJiabfRNpIMREiu4aeHjnqWvALqWtj6mfvr58WoY3?=
 =?us-ascii?Q?eQLY7lJwsHuwlI0Dx1OPpNmM1G1Cl33/HW/Sr4i5hLRxUPxtbFO396xeN0Yp?=
 =?us-ascii?Q?Mz+jEaLuLYVKN2rTR6u6Vu4B5Dz06Hfy6O/qo18Co2fMevxfQx48b6lNaly2?=
 =?us-ascii?Q?1rJ39dhg95zJEddHY+rKpiSXHsfVuPyhlzIIZ37KF6gq8Q3i0vjMbig0vzk0?=
 =?us-ascii?Q?8MW+Yb3yBajBagSTxO1PM7JG6hM1NyV99rxiI02tNv3SM801cw/DBwgvHsJ2?=
 =?us-ascii?Q?qwrn4S5uROwDF8J4+X7C8klTbNlKz4x/juDPmcpen3BQgWyKuO9wR5AraYQW?=
 =?us-ascii?Q?3Na+Ivgsn9gm7gXxuy7aq9Heip8ofq3R0YkMfjTru5fSFIMsh5n7vsmuMjqS?=
 =?us-ascii?Q?awvL00fZ2myHrKtnjo5tZi672FOWscf9hwHpLJJPMHrMa+2IxdXaTWC0fQZe?=
 =?us-ascii?Q?d/MQI03QWeXwdib7qI9u0K7+JS+hlEHpG3+jbshx1iBBGSO8RsVhy5taq5nY?=
 =?us-ascii?Q?7LFeinATJpK0Id8b2HF5hKqry1A25/p7/a4+vZ8WPE3yhlLdTM6OThmX+eTf?=
 =?us-ascii?Q?K0dzTX0hegQLEy6o9abOVcYgglTq/U+2VB0htrwPw5ocyPKGr1w3LTogxwpK?=
 =?us-ascii?Q?42+y3qmmur+C58bP9o8ENq6kE5dn7usOmN6E4LkPo7aePXkl6kOGqLm+alCP?=
 =?us-ascii?Q?7NMkT9wExPq9QXL0wxM0voXymErikyPrWtA8Xyl3k0UreJxC91At2Lfc4Rh/?=
 =?us-ascii?Q?tqMJCivwBOd95EUWjKdrUfwzwQ3jDWCT1x5buNShCPLjIr++Y1e8ACwDyGfM?=
 =?us-ascii?Q?70u67KjHNMYWcSyb1iaqM/L1JRV9/JIEQFeX+TkzWPIeGcTdGxau5vPaI/Kp?=
 =?us-ascii?Q?x3dXzf6GMwLcBS9i5ZQpW2HD63lMe3Lj2IWJBnp7NPbU5qGrx1adortDzmmp?=
 =?us-ascii?Q?NzihCmBZP8BT4gcNmZ58Ng4ZpePbR5tXyCf1PwQbtuYqnW4XeilZ3dlkXm3J?=
 =?us-ascii?Q?8GCvAPqU3ztjwZKDKO4xN+uy9FFjhG4L5X4s6zF8cmGawTXXrqjlBF2NtPTs?=
 =?us-ascii?Q?LNHYAK72Kww7Cjw+rsDNRoxtPJzWta9+giiV935kCDdec3svkBlgRnShIo/c?=
 =?us-ascii?Q?pBlO1s7iOIyoTQn1fsHR1TOj0hmEweOuQOpIvi6h6ZeqH4DPatFibAJc+Hz3?=
 =?us-ascii?Q?SxCAmKM/c88EZ9XSfX4G574=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A47FDBE52B77134483CDF5EFF573D854@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5384c62-5649-4dd7-a3b7-08d9b18c6f87
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 09:58:17.2292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTkyxEpWoAYy44UV+E8MV686Xz4TRBur3zUuw7mRbYQAEOmJ8X5TotnmGv73RuBUuiC7NonmMFrshzjthgUNRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7606
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 27, 2021 at 10:00:57AM +0900, Damien Le Moal wrote:
> On 2021/11/26 21:55, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > sd_zbc_parse_report() fills in a struct blk_zone, which is the block la=
yer
> > representation of a zone. This struct is also what will be copied to us=
er
> > for a BLKREPORTZONE ioctl.
> >=20
> > Since sd_zbc_parse_report() compares against zone.type and zone.cond, w=
hich
> > are members of a struct blk_zone, the correct enum values to compare
> > against are the enum values defined by the block layer.
> >=20
> > These specific enum values for ZBC and the block layer happen to have t=
he
> > same enum constants, but they could theoretically have been different.
> >=20
> > Compare against the block layer enum values, to make it more obvious th=
at
> > struct blk_zone is the block layer representation of a zone, and not th=
e
> > SCSI/ZBC representation of a zone.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  drivers/scsi/sd_zbc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> > index ed06798983f8..024f1bec6e5a 100644
> > --- a/drivers/scsi/sd_zbc.c
> > +++ b/drivers/scsi/sd_zbc.c
> > @@ -62,8 +62,8 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp=
, u8 *buf,
> >  	zone.capacity =3D zone.len;
> >  	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
> >  	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
> > -	if (zone.type !=3D ZBC_ZONE_TYPE_CONV &&
> > -	    zone.cond =3D=3D ZBC_ZONE_COND_FULL)
> > +	if (zone.type !=3D BLK_ZONE_TYPE_CONVENTIONAL &&
> > +	    zone.cond =3D=3D BLK_ZONE_COND_FULL)
> >  		zone.wp =3D zone.start + zone.len;
>=20
> For the sake of avoiding layering violation, I would keep the code as is,=
 unles
> Martin and James are OK with this ?

Sorry, but I don't understand this comment.

The whole point of sd_zbc_parse_report() is to take a ZBC zone representati=
on,
stored in u8 *buf, and to convert it to a struct blk_zone used by the block
layer.

Similarly, nvme_zone_parse_entry() takes a ZNS zone representation, stored =
in a
struct nvme_zone_descriptor *entry, and to convert it to a struct blk_zone.


When comparing against struct members inside entry, the NVMe enums have to =
be
used, i.e. NVME_ZONE_TYPE_SEQWRITE_REQ.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/nvme/host/zns.c#n158

However, assigning, or comparing against struct members of struct blk_zone,
the blk layer enums have to be used, i.e. BLK_ZONE_TYPE_SEQWRITE_REQ:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/nvme/host/zns.c#n164

And why did you give me your Reviewed-by on the NVMe patch that uses the
blk later enums here:
https://lore.kernel.org/linux-nvme/ef1c39ab-7b56-6a37-0f4f-1ca111d5b48b@ope=
nsource.wdc.com/T/#t

Be consistent, either ack both or nack both :)


>=20
> A more sensible patch may be to add a static checking that all BLK_ZONE_C=
OND_*
> and BLK_ZONE_TYPE_* enum values are equal to the ZBC defined values in
> include/scsi/scsi_proto.h (ZBC_ZONE_COND_* and ZBC_ZONE_TYPE_* macros).

The blk-zoned block layer is obviously modeled after ZBC, that is why all t=
he
enum constants happen to be the same. But this obviously doesn't have to be
true for all existing/future lower level interfaces which supports zones.


Kind regards,
Niklas=
