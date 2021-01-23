Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177D5C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D68DC23B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbhAWDEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:04:40 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3371 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbhAWDEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:04:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611371074; x=1642907074;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=v2FvscVwZpSCRtJkHS5RZr64YPJVyphfBhKwmFS509Q=;
  b=bAn0WVzUJn//1k6738ykBFI2IbjkyUPnk4ca+8oIvNyjaJi4HnRnGeZc
   hHGii+8QlkA4h6wMTtyfAhE/y5795KpTc7IG5uvj8a/RErTMc9oKPUGSb
   7NR1VpImLm9HRZS+8Qu1pkm2nCA1kLuIIBu/mgBwjrf1OHFD2h8p7omCc
   HnaLhyN8e5IKx0+IpXX9FHLfBEZGtHRgDbV3I2PDkZkP5hmKLOkcUTSg4
   2m3EX0UpTqqq3lTz2uuJvxc5OSkYDXbiSVBs3uAxbKJTHGMBW5hDeTRQI
   jgIdIW2I5cLJEUb6ikb/5X+Lapb+K+ed3Wot8bOEN7pGAYqXk0p8ori9C
   Q==;
IronPort-SDR: +mxnETCbQIP84zBjO17c+smC8i8v2ZFV5JrSD+wY/59hhA7Y6Sm/9hto1L+NPRflgCQC6Um5Rb
 Oswif3q0W0RPA/4pBZTYQ79Lic5UP52514BikqueCiWBk+nonJBgxEvF+3g4bwXm+WEMt4ITKs
 2hI+2mSa5sYKCeKONuClzvYfJGBi43nhpvEr4rmhk/Gnqsu3pZjTZWYkeHdMh9l6oYRdfl9Fsr
 i/itE0A5tKofzKTi+mSzREXtXGmrMaQGPKQK8ofLusStyFwdre2za0j2gSZGsk7LLmJAtFtQss
 z+Y=
X-IronPort-AV: E=Sophos;i="5.79,368,1602518400"; 
   d="scan'208";a="162584532"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2021 11:03:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrPPClB80Yh6j22QYeI88hSg36HJJ8rbk9P4O/Jsc6fefOS3IP/ECQXkoFejZp2/eiG8ZCZ4trqogbpSRexdIg3Bc30ScguKXV6b4eai4KtQhpFqLsDQKCg+DJxsfl7emvxrDD4MDbdnbGFG8JLnKkk6s/FACrNndgTld1it/JvKN1gmbxQIUP59gqRxXD20VIVqvzU2dfNDLzrAsW8k+T5daWKIDOhV7q8x7qpgyVrKz50Cxq7wprD23dI4f99TlUOdnRQ9PH0vBpUTm530cMpMR2uv0k2e3DnOK8UvU3Z7qfgbsGithw1COsxizgDHHLkNd2WVwrZS6HEcjuaZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2FvscVwZpSCRtJkHS5RZr64YPJVyphfBhKwmFS509Q=;
 b=NdRZa9okfu3F5xAZlSQN+aPrI3e5JjmGqvpEGq8pM+x0gaJIhOetqQ9HDzxFj27ha1sSLCdkTfQaNqocHpQYgrS/m6JVu1iOK/DLfLO07SPS5KvU2kJwjHGTcBeFxSGJWEjhxT9PXnkAXm/YGDrf830znnorCcCYzZ2sOX/p81+W9QSqC5/alA7fZrH2gtLa6EVfs9GnKSMU601UwGL2Ljq7SnUTaTPm7vGoIieSFQzxvVH9N5BQ4v1M0UAX4iIeKBQVglUVOepTLJ1381GC3/ShiUimetqWqsic+ae9nNJ+HQq436oPo8Wqtl5IDrqv2icuCfIZT2Qren0au1xjig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2FvscVwZpSCRtJkHS5RZr64YPJVyphfBhKwmFS509Q=;
 b=t5hbFiGtoPAEWmUltaN4b3n9N4wPUo/GU7kI1+gbq3MoH3gCBxytt4VvSuf/DZG0m1bSHBpTArZ5M4eRc2QKhxIAGFTZmoJJUTfKrdgCWerBkYZR3m8zceEzkMoSEBYGWuzbZ4j5p2iwFIIAVluShi4paRPt95N44Pg+U73YQNg=
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
 DM6PR04MB7052.namprd04.prod.outlook.com (2603:10b6:5:24d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Sat, 23 Jan 2021 03:03:25 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::9a1:f2ba:2679:8188]) by DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::9a1:f2ba:2679:8188%7]) with mapi id 15.20.3763.017; Sat, 23 Jan 2021
 03:03:25 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v3 2/3] block: document zone_append_max_bytes attribute
Thread-Topic: [PATCH v3 2/3] block: document zone_append_max_bytes attribute
Thread-Index: AQHW8JSlhHxVQj6BSEWc48JBLHcLTw==
Date:   Sat, 23 Jan 2021 03:03:25 +0000
Message-ID: <DM6PR04MB49728F70DE83642A3B61D51E86BF0@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
 <20210122080014.174391-3-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2600:1700:31ee:290:89ac:da1d:fcc3:58a9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 61c0c461-c680-4e14-c015-08d8bf4b73ac
x-ms-traffictypediagnostic: DM6PR04MB7052:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB7052FD4A049DDBC2583D183A86BF9@DM6PR04MB7052.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:335;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /mmDb9FjlpwKNSJoJDYobyQK5hrEEAOD3o7Ha23Xt0QtIjzrJvVFvrfdx+bnZdfmvZe29nAyXIauUk6RiHdcs5yyfbZtXGcjl/EcX6SrzHxczVVlDfFqqKkuofCmB/H74XzB+3Q139ttlXZ0QdjTB6xl0e3Xv0VkDOI2hTykFw05coVR33k4XC/cL9z7b2d953Hm5lUtuXgs3V/+dgcz6YFrFhNlSISy6qFkmlrSlhzW4suTumqLxx7YxOXC/KcN9apkAInUDy93lFJsbubIK6bz7G6Afklgcprr1xPElnCOl9ZYH/nVnRGHSoRRSXhyHVgKP1j8I8VQBK0AELiD4TNJ7u8WRAnlMOiwmZMm0Dp275S/xbM2eDCYLakINYaIHea6ClTCdxWW9B+qAX3WnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4972.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(558084003)(8676002)(316002)(52536014)(54906003)(33656002)(66446008)(66946007)(110136005)(4326008)(66556008)(91956017)(86362001)(76116006)(5660300002)(71200400001)(2906002)(64756008)(6506007)(66476007)(7696005)(8936002)(55016002)(53546011)(478600001)(186003)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tqgUttjpCOzH6K9R9WCw7664i1WVkSsOEtDwcwniXkUs60cudpcsrpnIZ3hJ?=
 =?us-ascii?Q?tiRPdH6VHYHxokN39hYGxhOLgTIh/t7cmve9S5LP9iUMOy9Fjx3r1H/fgVjD?=
 =?us-ascii?Q?+jLWNnDj0IGTZZRiS2Ak3XtvPG+0FoboxdXIsXWz2Sx9y+lclyUVsy4MsUSB?=
 =?us-ascii?Q?z5Gs8Crye232VLzJQ2w+wqgARuhOO+toirOwAdT6gPm5s7MJcQ52n2QlV+Cz?=
 =?us-ascii?Q?Uz8g1k7mI277WWGjVkRosPWUt9gxKKQSl37i5b9zZVHkB3OJCx9cOQ/UNXF8?=
 =?us-ascii?Q?W/Sd8gU/s2fskfXt7HJQR78EJnBbQuFlZFYTVIV0JGsq9CR64n8/f2Lh7CvW?=
 =?us-ascii?Q?3mYWUGYC4UsEV81P+LYtwdUc8UVMzs4mjbxMyO7DJ/m//KbgIKTTrxmKvUBT?=
 =?us-ascii?Q?1iHEctnNQV7+3nO4zAA/ltKf1k6e6heCZSyqYPNKMnDVZYEBudIHrbEHhEZ9?=
 =?us-ascii?Q?F1Yda8Gb1sW8ivxkt1UFu+RhgUHSVKFqZYx4QZYP0AVArb7v+0MEdqDiaHuN?=
 =?us-ascii?Q?+/1ctf+Gk9g/s562zXSKZKmvTk0mI2oyaVTciNcrSIxzUaQsDo0hV+IckQAV?=
 =?us-ascii?Q?UNiP1r7vG3hEAB6YboHbsPuCApkazfYaoQ05Os9EbRO181DU77tbkgBIF43p?=
 =?us-ascii?Q?1DLxTRA+sjzH1vKAbACuBck4vKPPaYwOPlY0g8nUf035IdHUM/GBB1cTwD54?=
 =?us-ascii?Q?JIoPb3YBkf7DJSXZdmhGQhrsoamHwd/DKcPmBtMXlFb50+7ImxHog4eTBoks?=
 =?us-ascii?Q?d/gIgpoT6cFWADSjAcGefAS7U95DU5guiQTJvV/HN8tTFcuA7pQ/8TX6vyfd?=
 =?us-ascii?Q?yhiPkXIk23Awmp1+qEMvvG1w/5qrCcNogtAgxiqN5HHYby7GYIDvdkNUAPxH?=
 =?us-ascii?Q?ZdQTkzvb3rBx17rvFyzFfpPJKBszkvlO9Ut/aae+aZ/N2k0PItTAOZs8OGAi?=
 =?us-ascii?Q?wVzAA8dwS+85qO6lkipoB49oHIanQoSzTc+qUzQbrGExUhXLKoP1n8lJaH90?=
 =?us-ascii?Q?QgW3lywQewNNpv7QGeQbD+yexGuvyD/6u9/JDFt1chB/yLGytaq6qjNmW0fV?=
 =?us-ascii?Q?Xm/CyIihX3EIVoDz5VIFwcqka8rMzQ87J6PyCIux59U+Mbl84Z+Fc5CTI6oz?=
 =?us-ascii?Q?WkhNpUynpzf0azsIubMthr/nspOE+yMb8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c0c461-c680-4e14-c015-08d8bf4b73ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 03:03:25.5929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oyLU36aoVikUQpu0H/JWfg9YbVC4M7AqGREtLosHWbOr2l6tIvcEigr/essbAMFkkZpY8MNs8kZbht2hF+gTxkNA1+mzcUfJYyfEOjlu+lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7052
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/21 12:00 AM, Damien Le Moal wrote:=0A=
> The description of the zone_append_max_bytes sysfs queue attribute is=0A=
> missing from Documentation/block/queue-sysfs.rst. Add it.=0A=
>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
