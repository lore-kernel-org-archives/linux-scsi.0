Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C31AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 13:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377250AbhK2NUt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 08:20:49 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26904 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377578AbhK2NSs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 08:18:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638191730; x=1669727730;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bKDEWHJ4RKXOmE3BlUN9jvvWlP1nirsfCFERW7X+zcw=;
  b=SLFMEhmAmYJ5hd04Bm2/mkYZqLqPW4Ltu40WJHSqJUQIwbhRTsUg4azJ
   5SuqdLovx5sEfbFYtpUv5LAqc3nArWEz48wqdExMrkT/wvrYBE8lIJtsR
   pRug4Qv9tswm4QZ2/DmWfV7vQLNu4IExmEQ0t+8sPalo2OSoA9Dblj+Ok
   GpogWLvsWgVqb+9+J9EoAaO8ymH812R4eDHs60sMMjxnR7PXXA/Wr4ro1
   tcwYAEW25w0WK330OZZfFhumZ5az5pZLx2/JtOFsH5srhRqmHzP+h0F2u
   akXyAuFfpvckqAplPZf5OUCAwKCWOimwGSW/xx5HYS2G9xpAtxt3Amm0N
   w==;
X-IronPort-AV: E=Sophos;i="5.87,273,1631548800"; 
   d="scan'208";a="290909463"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 29 Nov 2021 21:15:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lva8/1rpg22IMFgLanthOHa5HUpDPREa5fhXDijwxkHndwg+oqW7FjtVTdw7SnhGSxhHFaS/DWtRJssyr27TMo7xDDMiFk0dvPxsdU+ow6fOoXLWYi9z72/Gh1qLiaJ4iVxeNFTQcq+fCZVj+roaWQB+yB/rod02Wjrdvbzm3D8u8h1MUcukJQqKsVSrnr0kWG8g+uoGTGseB4MI2B6JyLNTik+Dt3aZCok7ZzJQaAOgCHW3dOQP0B4AZatFp67dhoB2C2UC+x0l3cq8uJZXAkKLDoOc0o8dr5maCCs4NtUT/pc9W/035dB7+1kQKHNi1gY+gAd0YcPTKnlWG9zcbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+ag78/ZNYWvPgCs+fyL+X3z9Jj1gmgMLFRmIuxUQxk=;
 b=KeO85hnz5NxN5S5bRARJw76xXlwsLMA5LZCYz3klIGnMTOw2sQ1qOSCKj1g7YiE2owMkuzt+3lF2MC6NfUOMIGydOgeDoufRjvTG63O6ENza6jTBhaSsTjExQmJgQjDhtRy+VpXa1AML0McTED7oVfXhcWFPkYgppOmJbb44gNj2JpyZ3JWaXAMbivQyuo3yVXT6zTBGH46IfFriLWqYCfceUXa0Ju5n/Qe22gWGcPgdy/1SjoPOqITwQ6Bl3OjV0yOZCvyJ2Hhd3NoLjEZTxY7/6tqzL/kgmUExQ0F3s1nJvpV//xD/FZaWYLVEF1YA5eM+C47JL/woTRNHxZaytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+ag78/ZNYWvPgCs+fyL+X3z9Jj1gmgMLFRmIuxUQxk=;
 b=ZDPyAi+08T9TlxSBUGoJgvBMXdF5fLivkpLrbyuVh07DMtclskvPva8hZsASJVvuCPXRNRvT1f4nnsexmjMbgy7b6B5VZyAKxxSgbi+wUGTApakyemAr0+JlEDHiP7gXzmIJRUwvHZ2mHftPE06lilaXPMqG8TdhB3ZzPbUjtjQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7703.namprd04.prod.outlook.com (2603:10b6:510:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 13:15:26 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 13:15:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum values
Thread-Topic: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum
 values
Thread-Index: AQHX4sT1wmIgicv9UkS/qqm8MDen0awWju6AgACWIACAAvzTgIAAXuyA
Date:   Mon, 29 Nov 2021 13:15:26 +0000
Message-ID: <YaTSbcs/cNfl/hKO@x1-carbon>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
 <9172d395-29d0-6b1a-4be7-8968bfac6762@opensource.wdc.com>
 <YaIBOPmCC6QH2rei@x1-carbon>
 <aae7748c-7915-28b4-75a4-033dc76f75d2@opensource.wdc.com>
In-Reply-To: <aae7748c-7915-28b4-75a4-033dc76f75d2@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0513532d-164b-446c-2e52-08d9b33a4f1f
x-ms-traffictypediagnostic: PH0PR04MB7703:
x-microsoft-antispam-prvs: <PH0PR04MB7703A5AD553E0546DC29B693F2669@PH0PR04MB7703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: juskKaLg/jyk+MWxs3vmUYuTHU9VF/6fOeWkxBbkFGsbSwAo1qam+4C8ry/tdiwRTh0pp1DOoDP8JlxoARRzFDVpKBzwbRQWJdUsZOKDK9PIOU+YppYYE7srLx09VHMTWT7dOt/vTv+9O0ehdPOaL76Grr4j4sHTF84CWdrrNPJqsjlBM8kw+/W+Ftrjt4SbaWtd90cGgSLOlj++bLkemGxmKjceS4/eQi5OQHZzalKJF9rQhHec/9hyAAvsiLEaFxodmfGwtlpJaGkPOui2NF6k+lvKvg1BcUhSwGjaYpOG+ZKDJsYsDkPcPWAaICQGvAnab+lowMwjpwq3q2bSOFg+oXRk2fgKX7vd+fwmxtKBJpZ6znoLqeRPPKM6DSXrxvoYhWpm5V1BF07Geo9rIk2vCHbFSri6AVabY5FBEZWKTW1FWy0R/JcHp1saFgtwJ6hWpE+niKJeDnTYsjzSNMXY4uI50Xi1wD0/Yn3UKEzArm/PRt1vKPnM+viBuD/PpURgwD6K00t/PBXjW170BSczc5oE1y83R744TrVOrG4MnGV4UtbJyR09zlim6BGPyEHQm7nCf9/viXpmfGUf2pXTBSq+EDa2W1jRENhMJaoQxQj2olh/SOv9wYZT7YLHHIgtSvCW3/93VooAai7hHHt8kbeHy5Ai8y2o1+yPTd8duKFy2iB+nNz4l0YaNeoi9rC0mk4w7hoviVrdrStJhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(186003)(4326008)(66446008)(9686003)(66476007)(66556008)(6512007)(64756008)(71200400001)(33716001)(38100700002)(6486002)(53546011)(66946007)(86362001)(38070700005)(76116006)(91956017)(6506007)(5660300002)(8936002)(26005)(83380400001)(316002)(2906002)(122000001)(8676002)(54906003)(6862004)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6/dwQCSuzOBv3PkMO2wSCPGn8SRR/hiPShT9YUuMZYPti3G6R/vo5krxfbxP?=
 =?us-ascii?Q?j8DN8kM4ZxKUND3CGWkzQRbJc4uvv2surww0zUCRbbPdeuGwdi1jbWwYsI5f?=
 =?us-ascii?Q?zM7jC4GxvivmLE4RqQDxtUVJIQ2x7Yu5l6j+X37ruXtCqMv+vIjNraJHxIdD?=
 =?us-ascii?Q?6RdyHO+vJ0WoEEv6rq7ggOVZvQTct52QffTZa9UF9EoDV184wZdT3hlcUrGH?=
 =?us-ascii?Q?d81xXnmk1ys2VZWORvXGozvTxrNFDbz/Mx09ZMWXyWsBOrAR6kgb6XYTY5yT?=
 =?us-ascii?Q?CrYcjQVD76d9oDBeTx0QayhnSHoPT5uGRixbJ/6bpc0Pm7n8n6g8K2ue11uv?=
 =?us-ascii?Q?R09kJhHTBwRIR6qN66nDQNdqnqyR81fRgua2MY6l2GQXx4yLmD3DZSbUa1rY?=
 =?us-ascii?Q?CeabRVJBQgZQU6XzVwXCtJWUvdZbxJ4H+akI5PJgiVXE64e1nHFy/H2TZXLI?=
 =?us-ascii?Q?MxfeXhk13VcINKSHfARbMpHncYNLEw8jd/i5XnGyrfpjcACU6wFc2xge/SV0?=
 =?us-ascii?Q?qvaRcbnY8+7SgHUt2j0ZMbdTyo4pnYACWgLLdMId4k0ovBj2Mjlg9h+an3ih?=
 =?us-ascii?Q?ei0FXETvn9MXlRfsPdNTkE3UzxPKKEoFiiHTCYK5+JXUrbvMsghLQWtZJyNr?=
 =?us-ascii?Q?7ATxWV17RkTVT9IWbBCvkXA4FRGdCe/rlpTghuSxipc5ZjAoFv6pBRj9BWX+?=
 =?us-ascii?Q?+mXf7e6MtXxGYhvusMnsorGpR2rmj3kwDzEGaQn60RJb+tP+D8wB8ioI8OQO?=
 =?us-ascii?Q?AUOBjEKfWO4AkCOtHc4bVmCq/qexfSbcoBzSPkjdelAj6pb+f39m2pu+wNbm?=
 =?us-ascii?Q?GQsd4T+52oBHtSX1E7Ie0PNszTGDTMv+rwTtUA6M8iygvXivOins4XGt1G5S?=
 =?us-ascii?Q?wQwOha6FCRmxXlKzJ0NgGJ3YdxhZ0KIyj0J2GutCBqcpdkDsYfGaaZ/5H5Pw?=
 =?us-ascii?Q?CjtTLBoI+kQcFZu52PqbCuySar0HR6uLmlDWTgaDOOvBc3mG2LXtFWtgWh9f?=
 =?us-ascii?Q?t6A0I8lqadYrHO9V1znHd3peS9jKfAKMGkaGOB2i2EphzdUL+yxquvWTkOg9?=
 =?us-ascii?Q?0WWLilABOEUGdQakzjY18tJPzQKKO5+t7KxvYQX/SlhCdPGj3KIi+HLifZov?=
 =?us-ascii?Q?JLXVg8rk8uvIwgez26cRZumGHGmOxKyrYEOEyb/YZCxyJKOH71egguW+K1RK?=
 =?us-ascii?Q?NRtG1AZxgko7+GnwxVphbz5BCsF1sTB94PNVmf2e2HnmA+JidwVUYHOTSzB1?=
 =?us-ascii?Q?SNgwrlt6t/XdJvAHlNTNVFzrJ2vuLaP0oAVvk8msQjaxIfrssV31yrTZfZqN?=
 =?us-ascii?Q?XhYDgtQh6+ezEcLRVb1n3rpMYKSRamRgG78v96PyF1ozaVl0+5ejqakyVzsR?=
 =?us-ascii?Q?9z4VOwGLvyq3W7w7+X8yWlkisqsfFZyt6XAbDfWF5R8BtxCNooO8F3bk/ppH?=
 =?us-ascii?Q?TbyBHbGFSb6dZk4n8Xr/ua2I1F7PREH1UW+xE/UTLQ5sEC8dB8xf9mFn0ZRA?=
 =?us-ascii?Q?P/mmiyIiT2DZUvxL2Rk/tVZOeClIjrgyc1zPmGUtiECcG1rL7HLCHUDgULtI?=
 =?us-ascii?Q?RkQHRiWjfJVSr8tQBofvzimf7Hu0numT6mqJXt5EXSVpOULlIoeO+XZr6Wca?=
 =?us-ascii?Q?nO5UP/LvoR0VNIxzsqEfPao=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6370331D42991843BE6D0C48DAB13A07@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0513532d-164b-446c-2e52-08d9b33a4f1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 13:15:26.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJhEvpVLc2zpyMdKenhBSEi68eojrWXFWInFFgCgiSSvlMddEbHpKeVU0L6TrJtD52K6hL98VvgkDFXiomVqHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7703
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 29, 2021 at 04:35:41PM +0900, Damien Le Moal wrote:
> On 2021/11/27 18:58, Niklas Cassel wrote:
> > On Sat, Nov 27, 2021 at 10:00:57AM +0900, Damien Le Moal wrote:
> >> On 2021/11/26 21:55, Niklas Cassel wrote:
> >>> From: Niklas Cassel <niklas.cassel@wdc.com>
> >>>
> >>> sd_zbc_parse_report() fills in a struct blk_zone, which is the block =
layer
> >>> representation of a zone. This struct is also what will be copied to =
user
> >>> for a BLKREPORTZONE ioctl.
> >>>
> >>> Since sd_zbc_parse_report() compares against zone.type and zone.cond,=
 which
> >>> are members of a struct blk_zone, the correct enum values to compare
> >>> against are the enum values defined by the block layer.
> >>>
> >>> These specific enum values for ZBC and the block layer happen to have=
 the
> >>> same enum constants, but they could theoretically have been different=
.
> >>>
> >>> Compare against the block layer enum values, to make it more obvious =
that
> >>> struct blk_zone is the block layer representation of a zone, and not =
the
> >>> SCSI/ZBC representation of a zone.
> >>>
> >>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> >>> ---
> >>>  drivers/scsi/sd_zbc.c | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> >>> index ed06798983f8..024f1bec6e5a 100644
> >>> --- a/drivers/scsi/sd_zbc.c
> >>> +++ b/drivers/scsi/sd_zbc.c
> >>> @@ -62,8 +62,8 @@ static int sd_zbc_parse_report(struct scsi_disk *sd=
kp, u8 *buf,
> >>>  	zone.capacity =3D zone.len;
> >>>  	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16])=
);
> >>>  	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
> >>> -	if (zone.type !=3D ZBC_ZONE_TYPE_CONV &&
> >>> -	    zone.cond =3D=3D ZBC_ZONE_COND_FULL)
> >>> +	if (zone.type !=3D BLK_ZONE_TYPE_CONVENTIONAL &&
> >>> +	    zone.cond =3D=3D BLK_ZONE_COND_FULL)
> >>>  		zone.wp =3D zone.start + zone.len;
> >>
> >> For the sake of avoiding layering violation, I would keep the code as =
is, unles
> >> Martin and James are OK with this ?
> >=20
> > Sorry, but I don't understand this comment.
> >=20
> > The whole point of sd_zbc_parse_report() is to take a ZBC zone represen=
tation,
> > stored in u8 *buf, and to convert it to a struct blk_zone used by the b=
lock
> > layer.
>=20
> Yes. So what is the problem with using the scsi_proto.h defined ZBC_ZONE_=
*
> macros ? We are deep in scsi territory with this code, so using an UAPI d=
efined
> macro is weird.

There is no problem with the existing code.
I simply think that it is strictly more correct and slightly less confusing
to use the BLK_ZONE_ enums when accessing members of struct blk_zone.

I didn't see the weirdness of doing so, especially considering that NVMe
uses the BLK_ZONE_ enums when assigning members of struct blk_zone, and
since struct blk_zone, which is the type we are using here, is itself
defined in (and only in) the UAPI header include/uapi/linux/blkzoned.h.

Anyway, I will drop this patch from the series and send out a V2 of patch 2=
/2.


Kind regards,
Niklas=
