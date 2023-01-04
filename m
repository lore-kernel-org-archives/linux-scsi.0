Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B280C4708E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Jan 2023 10:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjADKQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 05:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjADKQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 05:16:40 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF83B167CF;
        Wed,  4 Jan 2023 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672827399; x=1704363399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bQTW5z2jd835J1EFmrF40Q/O8dtJoolwxRhBKKR8GFM=;
  b=OjqA9WtFRvDdvyydpYxjIVf9mByFCAhsv2Y84csGCZE6JdXOjBJMmO3C
   Y66A3upZMeslp6VeD0BxZCBthb+Bx7StANAbPOBrSNY58Glp6+nMRJHSB
   xJjuBRFwiCzHSbEHDIe4jMhifPslKOYTKAMsjBEOsHxsdPhnY1LuDQ1mA
   2wikKqNxfhR3kcwHlwrmWTEoaCNALGDPw32viYIU6hZHR/FyEMagjbt0y
   PaOrqlyEhUlfD8M2oejmm3BkbwNTewSWns33y/U90H/JlcZ27IKr6jkhk
   i6Pu8Zd8BG4mCTvDiky2XKMVW7dzg62rhepSy9BZPttkiAY2PDqSRheH2
   w==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665417600"; 
   d="scan'208";a="331999376"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2023 18:16:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrLtqkU1A9B93s5clOFAs1duWW02hjn2GIjSu3zhv6l/FWZkqqNzpsqjGORgTCiMzKO2pefnPQmIU5sNyq+dw/z3aFGeYT/cdLtPEG6eEjIuJD3/v8Y4EZWurq8tP93Bb0sBFfDO2fAF6vdO8dqdUOXIK3vb5QIJ0x4iyyIIvWDT7KQbEiqXrknAbYWw1EWZQ3guXDPmL/DZ17Ige3ZiQGrSV3wxLC7u7cPnAhKIoXwBNQqGulAhdu2fZOcQGhcjBP1R1nZDBgzZpUT5/Wwin6y6AVmr5533Y79mfariDFzlTttV4J8nGYIglYQ6tVAO8vE8NSHcw1zgOBLs7QxBmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQTW5z2jd835J1EFmrF40Q/O8dtJoolwxRhBKKR8GFM=;
 b=n/Q7TW4Zo2/G6BMHdG55P7zWKon6mLgm/AN1d31ENyyeszfydhFhbkvmHfsLTM0M98ceNjq4GOKMHU6htz62v6oTqo4qRGtvWGuPWB4tGJJa5X0eQ5xjqu4QQDwZbavboNM9p43T4Fks95kpeDikvFpveKXbQleu3Ayg3/cmsjRxVXKZ0SikgQjLfRkwpfi9O19jAKT1QI0BN/rNRCp6Nsbd3pBByuwvO4DarUtLVnzGF82FOjjEN6LxYuX5zDs69Xp7q9rb4ZD+LULkfyfEDol4hdVr9DEUH5a/PSnq6vT6beWG4dBduWLkz+d8kXTo7WbPPt5TvVGmq7upzJQEmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQTW5z2jd835J1EFmrF40Q/O8dtJoolwxRhBKKR8GFM=;
 b=RNwLnP7brDIJC94TLMUJy5SmUqfyD4LBAApVXO6Df+mm5gf5QP8LFaHWUE4QWagHrwXW4vat12zCaEMi+wt0UwXW3shLop4bgM7Zi3HE6wBxk2kAZsP8ZHUcKve3Q04ubVLX99a66TZyR/iio0yWAtO658pmtjH96UT7RL9lnkM=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BN7PR04MB4241.namprd04.prod.outlook.com (2603:10b6:406:fe::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 10:16:34 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 10:16:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] misc libata improvements
Thread-Topic: [PATCH v2 0/7] misc libata improvements
Thread-Index: AQHZG6cNSsG1SwXcq0SwZBLsVG1D6K6Ntv4AgABbzoCAAAEigA==
Date:   Wed, 4 Jan 2023 10:16:34 +0000
Message-ID: <Y7VSAR6FmaO+f9RL@x1-carbon>
References: <20221229170005.49118-1-niklas.cassel@wdc.com>
 <49c92e50-5452-8c3e-1517-a0bb1e4e72a0@opensource.wdc.com>
 <Y7VRDQX4fvB2CyZ/@x1-carbon>
In-Reply-To: <Y7VRDQX4fvB2CyZ/@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BN7PR04MB4241:EE_
x-ms-office365-filtering-correlation-id: bb62b92e-5e60-4f5e-0933-08daee3cc1ff
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQRmFiMaKhXbwRDjP8++T+Z9jO/F7thTS9OJiK3Zu/qXHmLeOtmezhNrlSx/jz1wp6otyriZDxJF+LYmP07iXg47aI8e8xtP544mUgh7xk/YLMm+NRvTQYX56fuhr7/e2fke6sdztb/w/sODsNJrCzX3wd1jyZLEsvmN2/yAQCa1uzA0HwNCrPHE52yfpe0C2WBI0T+eJjpR9jxZCjingTq52zxw27iwrr04ljIBfej603M/al/DVNDBamEsPiFc4x4h+p22segoXHh94uQ1oK40oEACQx5m43rPVaxYqgozlWVfztcvLquWbAn8QSFjkXmR2OyrF1ls7KKms5R4Vf+vSxEVKl5nIfGu6Ua9Ak4Awtia/kmEECRNKlcXsTvUPj9dy2SPOGLIWSO+5IPRHSa0cAESkmuXD0ol0oETnDEDy8ZzvEH6NA/af5LoaadkogvBsU7NceJ+6Gsb14/cWXLs6Qlm1yR9kZlwVPTB/tdwQnlPZAj0CqFcQWgMjyvbJHI5brw1Kf/LQaGmjtDFM9pEbfDBH0ZaPIPFYfIWgcdES1vnY5uhsIiqvqx0gTR3CGaZHzd1JV2SFNsqMXA4rMQOl+8XQsIh0OYdhwEnnPRWporYKu740ALxK+f0n9WKW2sDAd+LJKZxs5lkiAGzCQtx+oS1rEmW961YVhSxE6PqdaUf1cRQgcdwxwCoq8LwNTErA6dQXXJbGziQq4rQg6oY0VZuqeqn8zMt1pl4k8Ss6rcFhbM8ioso2IJ3vSN4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(53546011)(6506007)(966005)(33716001)(86362001)(82960400001)(122000001)(38070700005)(38100700002)(6512007)(9686003)(26005)(186003)(478600001)(83380400001)(8936002)(71200400001)(4326008)(64756008)(8676002)(6486002)(66476007)(91956017)(5660300002)(66946007)(76116006)(66446008)(6862004)(66556008)(41300700001)(316002)(54906003)(2906002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?psvfIoW6Nl2/H+kcL9da4tt/zmQf9vbPj8cku8zzzCaRsptM73vIK1M0svZA?=
 =?us-ascii?Q?IyWLHTDfGpNBvYUqQOQ56gk7to8Jg432to/CXlY6n2wwyQ7+kdFQF9jhQHgi?=
 =?us-ascii?Q?nNP6gfX5wA0Z2YpySb2Aox6wQXx5tXfGcLwe8w8np0ktUcm6alAffOTq8u+j?=
 =?us-ascii?Q?IcLouRoe9q2bwzMeNejwi3gpDUu1cSeeHT5PQQJctyB9iRLpRZurtwYadMvy?=
 =?us-ascii?Q?Jlde3SFmzYPOZ51NaPBHzGzlT3Aa1weo3JQLapm3cv/KYbv3gu0XbEYlJW8o?=
 =?us-ascii?Q?pplrD4KSHHxAoGmkpy2H2o2pQSLtWE2Qf7i4FqRJ7qOvdRlRnEmFYGY/sYg7?=
 =?us-ascii?Q?NoN4CnoDYx22BlXgTgAyYBTOFej+6jzS8R33kQsvWGAzBVJybi01WeVh1o4B?=
 =?us-ascii?Q?n+ZvSq7DEG9W+B3dUgCh+u4dwy/8d596sg1L/Rguux+tBE2/GTUPco6/U1dM?=
 =?us-ascii?Q?JCT1LZdTZa30ul7jvb7qoqe9MCNt5ldRMhHJW91yyvehoFY/+B/rgyZKXB5d?=
 =?us-ascii?Q?sBUixUNkJaRYq9m2HD0AiJ/DxdnQHsbWnm0c1DdYYQr6xtF/U4pqp+0ZApN/?=
 =?us-ascii?Q?LSlEIUm5jPmEAlJ/6wwt0S586BRZQ9F2bjxb7D1W05xQ48jXGgjRaCDHUbZv?=
 =?us-ascii?Q?j038dGABy9y/esvodDP/bM69EXeSWT+khggVq7KSNVn4XlDDOJfOwuoQPjIR?=
 =?us-ascii?Q?dJv3vkwXB2YMBX3ij1F1oVIRKFsFzI7GRJipL20MsYqIkwYrZJm3mRiIg7jY?=
 =?us-ascii?Q?wTdFdVPJmwwvBtmty3KKT2LGMnxzVwPLEHHLIKzVl6X+YOsFA3BfY3Esabw3?=
 =?us-ascii?Q?hPEgpekjNvfsI/r+6Lozr/ZJNcA+xWXxyYlBR95C6r2PwjH9tFP4d/b02kWg?=
 =?us-ascii?Q?tNHlO+YdVH0pkDZMLHRMyTeTY+5ZxVCZORtuSa3DhpyZrjICYyYC9xu1IGk/?=
 =?us-ascii?Q?8SKNxY4FrRvQXXxQWM0UJ+Zot3dsAJyyWErQk9JNuHvZiF38+us4sLRsDkVH?=
 =?us-ascii?Q?BnBErPYgakJrY2gU3fTVTjNpdolmb1iBIbpniwPN8YwJ7Pl7QnEaQSTMpWsR?=
 =?us-ascii?Q?ARsHdlbVHGEA0LDDHy2hmoMKH4Rtii+kFIeMpepvenfZae+vvf+PsIf7WoBb?=
 =?us-ascii?Q?IuOT+txhNdOA6eHP3f6gb19rywfLD64ZJbziHEJRB33nGPBCkY4gNc/QfdX4?=
 =?us-ascii?Q?LpgKF21ysGD9HFlq9hkHAVmLDeYMTQzN/jr1ABJlrrJWxbFoB62yVd1z0tvT?=
 =?us-ascii?Q?ThNRO82p5iU4f6VVkOqY7JGp+/DOdb/de5RvDfe435P3J2dhjSEcKYvEpXTc?=
 =?us-ascii?Q?qLQ+G026VS82WNjWWSW+5SzMljnceGpibsw4YsBv+YsLaRplHvtrkajYFd6W?=
 =?us-ascii?Q?yiaQA8rKTyhrgE0Ew2w/JBaWwKDJ3n6zHhKklSRn/MAZ9EppT142DAK23xT2?=
 =?us-ascii?Q?3aZwPoQT9LfFke9qmPtV3jh9um/eGe/J5s74j/XZNopeqlfvoQIrpJJ9zcYW?=
 =?us-ascii?Q?mzt19swNIFLbTo3czXLPpyWIxPDFI3c2jKd/Xcobr3GELqAaLKf+xV21RP6W?=
 =?us-ascii?Q?oy03NcR1BMyHQ7vwxNVuBl3TXunuf3DdosEaHhyWtewLUPgsC5vPGprzikWk?=
 =?us-ascii?Q?1Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <51C310AF31F0BC43AB858E0AD73F1A35@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?DnrpNoAtwDsGrHqxH5isXHQINT/ToSrpNJnyiq49Ull0LlqaV2vstjWpSuTY?=
 =?us-ascii?Q?4oyZNkVOeDKLNXPMHh3LG9AnMte4VQ6ZKuRq6f9iFt+I72s/deWYCwD80h8g?=
 =?us-ascii?Q?6bK3tjMIOdKfg47IFL269Jj4xGMxwncI21LDLsB7isObwuFVTorytiZ+QyWL?=
 =?us-ascii?Q?iKLjck2d9J2ybL7ZH5bcNerNABZ3BZohzIHXY11A2Rv+LRWbnmsnQSSqKOKS?=
 =?us-ascii?Q?/jna7DczBMjfyinqvpYycnrEfzPj2a/LQJAm8WOi0Oj4nEyhkhSih2kR4+2Y?=
 =?us-ascii?Q?Di1rwcPERtLgKzgTjB39ehsk/GsH4e/EZT0MSAnPEpIN+nyf7vZo535rjuF7?=
 =?us-ascii?Q?8IZmouhZHNTB69NSaDGrO8+rs5j9e55sF3Ixl4okKeZLwjqMVi8ojaW17GpN?=
 =?us-ascii?Q?AWY6msfZkps9I9QCqo0w2CVIv3GEl/O51YXJfAookE60OgXotIlDOm5pBv3M?=
 =?us-ascii?Q?/u8NImEf5i0OUX00kKbTjiKCKliPRBISdrCUiz5INNWSe2sOLPxuBH8GdVeq?=
 =?us-ascii?Q?1I39D+WI3Vi81Q8VN4eFdbejQAITW6mzjo4VKP3NuozU8eqYdaN8AOO0y6Za?=
 =?us-ascii?Q?LjqOF6mIR8zmEY+5xRR+RUnoHu92dFWBhYEU5kg8Hd+QYPoVWnj8W6b2IBT3?=
 =?us-ascii?Q?mnGED9dp6G5SiJtIqNh0Dqx1aJJ/kZhIg5+eN5WryiT77dOhB4Dn/TQ65Uqa?=
 =?us-ascii?Q?w2doaIMRCs+ZXnfsIEH+9XdJcBz1ZfHMK93/xpStDaxwymx8FITb3AcSckXW?=
 =?us-ascii?Q?akW3XVTy6yyRee+xg+Ctov9NXygpnAaAqW5np0fiBHTN0iAspqj2/S538dG2?=
 =?us-ascii?Q?dsR24aUQEd9l0sHuR0YTyTxCwNNnYgz+/DOuMNJ1Q6+fCz9Nim+8fy4uS675?=
 =?us-ascii?Q?UYv1fke7wMXr0oEjjN1opd3HKAiKDShVMV5En12FuoUrchB2sfO1F7zC5loX?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb62b92e-5e60-4f5e-0933-08daee3cc1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 10:16:34.5886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ob7GBpIwuRl4eEeIMWeU1EU45QCwebho+mcp6xboQzrWT4jVLQiYpZF0UKG0en1cHU8drCmR7yA9o7Hc4YjBDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4241
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 04, 2023 at 11:12:29AM +0100, Niklas Cassel wrote:
> On Wed, Jan 04, 2023 at 01:43:54PM +0900, Damien Le Moal wrote:
> > On 12/30/22 01:59, Niklas Cassel wrote:
> > > Hello there,
> > >=20
> > > This series contains misc libata improvements.
> > >=20
> > > These improvements were identified while developing support for Comma=
nd
> > > Duration Limits (CDL). All patches in this series (i.e. V1 of these
> > > patches) were orignally sent out as part of the CDL series, found her=
e:
> > > https://lore.kernel.org/linux-scsi/510732e0-7962-cf54-c22c-f1d7066895=
f5@opensource.wdc.com/T/
> > >=20
> > > However, as these improvements are completely unrelated to CDL, they =
can
> > > be merged independently, and should not need to wait for other patche=
s.
> >=20
> > Applied the series to for-6.3. Patch 1 had a small conflict that I fixe=
d
> > up. Thanks !
>=20
> I had a look at the SHA1 for this patch in your tree, and it looks good.
>=20
> However, patches 2/7, 3/7, 4/7, 7/7 seem to miss your chain sign-off.

Is this perhaps because checkpatch complains if the same sign-off exists
twice on the same patch?

Not sure if this should be ignored or not...
To me, it seems more important to keep a record of the chain,
than to keep checkpatch happy, but I could be wrong here..


Kind regards,
Niklas=
