Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FC7C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 03:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0C7610CD
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 03:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhHZDvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:51:04 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:34636 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhHZDvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2021 23:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629949817; x=1661485817;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zBJGn4hGhPwJ9Tgx45UyaLNVQIJ/H70uu9YT53Uj2y8=;
  b=Mx3bDsCRl5N/XzTmUqI/QfsObZXQX1S0SVOJRiKu1ueacF6a4EcQ/qoW
   O0v6GrNwg5uhAyf0Prt2NZOCZYTkuAVpgW8v2xaXMtVJ+C6PXIVOVwtGS
   er/OShMuS94gZwVJk8mu8K/MsQuF9VPlCkqsA5x77vWh+Ude9+5m4+pVY
   MhwYCEhiW2XC3gqAd+JWqMmDWq08hRoZgB99NH/1GnAFb+oS2HHxADY2j
   zz2TEiPWZaTjV23UgqJWeZ74VHGjxB55B9ZjXG5nxvPFGLzYSx3HxLKXu
   LXwPeFtMv/rHhoZVubnTH3T3z3h/6wCVBbjVZm5VNMv8LMFuRmkN6stnF
   A==;
X-IronPort-AV: E=Sophos;i="5.84,352,1620662400"; 
   d="scan'208";a="290028371"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2021 11:50:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akZB1ztDvCcIeyCH7ZROnZcx5I9aZtOnnm5nL06U5TrRVObQVTA3CvLe14J+MfVkFTgk/FEGCkwWSvFZqPCdHPH/+J5Q921STXNA0HPJmOvuyEhQZmgcQh4mPjGnFjZlPwHfDlZXJDNcOIlg9atw8PFyFYqBrkpMfcd2SsY5uCgZabnGRZ5taB0hvTG9ZAhRcaN69OZPmHzUNXXFoXqlInErZC2DceRrmhaIDH/2VFVQtrk55PfxNpaVG3JMAQGVBjFsCEOuzWlokdwWWzrDB63YK9HPDHjtTEvb4O1iH2xoTnzsU6V6M3PKmhPCMpDPVOl5jM097yCcXy8ge93Bfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5T20neaxCD7c37+xabow6NjH6D3WXDsY9+crG8bZ6Q=;
 b=FGLL5n1y4iB5WLLNcMeTEsyghO4SKljz1BmYVSL3vDOamVrUOZPfeq8PnIPmOpTJXADHQ/6u6AoYC1A+u2Qf51JY8k9RUME1t00RwVFdwlsCOkV4hB6EPlk7hzmiPFcqXcPK7VKLoUx5Bf1CdML6OxTSjHKN2gaBLggyUF62VSkFuI9Y48z8yPQP7Vwn2k85/feZ224aMNLpECeHlKDZ2PZcCu4xKLSYCHZNRzN0oHc56+ree5msSAzKx0x75eoEXUqn7OoHdTGekj1gCVc71KW9x9RgidFZ9S4Q2jfcP44VdVlOJQckN/PB5MAArCEu+ZSNX1pxmlIv9mH6sEYbKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5T20neaxCD7c37+xabow6NjH6D3WXDsY9+crG8bZ6Q=;
 b=x5BQflg/GwoeTZjuesrWfHPRtGedWo/MyH/uj5s9ZBQXtTLplQrtWihZd+MMh0VjxOJcFucxXi18uTEoipFgeKlFkNa1qSWMO6fLRF/L+ko91sn+Ivfm+Q+5HTrVBWq/28uqmU/uNzhi29gS+vsS+CEX6sCSJ5wirBEmKQ4Geu8=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0443.namprd04.prod.outlook.com (2603:10b6:3:a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 03:50:15 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.027; Thu, 26 Aug 2021
 03:50:15 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Thu, 26 Aug 2021 03:50:15 +0000
Message-ID: <DM6PR04MB7081B82BD60E0C96F31C84E7E7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1ilzsannu.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e410375-895a-444f-6fab-08d968449d1d
x-ms-traffictypediagnostic: DM5PR04MB0443:
x-microsoft-antispam-prvs: <DM5PR04MB044313D5A62A2A4C78B2F3D8E7C79@DM5PR04MB0443.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZdPfJnfds7BW3zLY6LdQrB/FGi+oVWvqnlI6JDdRzDDQpTkj8okDfs+mMT2uIBJfqvv3G05aVmcwaSywhxVZOcWPalKKRfmz0eukCNnXxS2dTp8KsmPr3Biakx/odyG5paQ9mP8RECmRIC21qhBClQWXbFfhty9N0fhV0oudQyMHuBBlk74vo/JbzPl1NM5lgkOE8KMl3OgWRt/3XFizyln6l59etJoVAYKKMn6dDxrxqO8Op+F9Mm0kQPexxNJw0j3ndwX7tNJ+n1drr51RL09q1LyP1gwmWhR25nAkr8OQH1jqE/JSk3R5DoOqI0VlHpC6RTCDMm1Zd1/JftbtpMoUpT2JCqFt83S6iTfTtgIMdCuRoMlZgB9H5qOtzSvgm/ISGJVBF03/Kys/cbFqeK9hKm5PlEybPXWk8laqNcoBju9mzzl9gb4IJ61GEzbefLt+oAIdmnl26VCinJbmMugf0XyofkC++cWmC8hWEwNrKXwSGvzuQgfSXtiqiaJE7tKaDyQ6LHkbmwQzCEjBegW0MCj5z35T3PrT/VQc6+cPS19w9ltaHz6UR7XNCI8b+do0NUmtZQ1OnIYXY1GH5t8bCaTFrQoz4IJK/FnhCiTVUetvW+Ao+2pL4J6/HDOophjaH+D/FSoJ+QqO5MduiimMh27V6A35wDOV/eGE4TYX8n6nDFuHUuEyTs5s4IgmqecXZl9S3VwtEjtpNm0bvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(66476007)(66556008)(64756008)(76116006)(38070700005)(186003)(55016002)(91956017)(66946007)(7696005)(66446008)(6916009)(122000001)(316002)(4326008)(8676002)(5660300002)(9686003)(54906003)(52536014)(53546011)(6506007)(38100700002)(33656002)(86362001)(71200400001)(8936002)(2906002)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CZvsUmFc2hgLY8RbW5TiQvBeaEso0PSB5P5mRWULZ+fEwxEmOnqKbW3Gbp0s?=
 =?us-ascii?Q?jV+zBlf83+9kdBB3mF5hTpQyvakHLxxU/PoPn1ljL4DesJsuukVW5dZwE+FC?=
 =?us-ascii?Q?zp9WhhWCl4qMKaqtmKlhvXRGkejrphn2M4tbBm6eN+lONq3d14J+jdFRKGh/?=
 =?us-ascii?Q?w5u3y2GykTTTOYUlWvJowZZY0/bmAvta76LS5ZB7Q2TTzPZUtzy0M5M3MeRV?=
 =?us-ascii?Q?VtYmPso6+UmiqFGdhZZhZIh9zyxmFTkCVuliT6/jmwaIBs3JBwPYUa0eIBp0?=
 =?us-ascii?Q?cdJ3bFkHFn1TNL75fP8C7uBMWmVtcsHaZWWrJbiE4BK1fn/lBVS7qtxGUMYv?=
 =?us-ascii?Q?+FiAGM6yOTPxwj+yjBnY5FQURLkFf+Nu0uw6CEjCt/UL3gqZN5tT2yX0ml8W?=
 =?us-ascii?Q?L1+Wfpu9OWvU9ULiT7VUKiaNytHhN0nxcReU21Eb272W6Px1/7yj/jDasOpw?=
 =?us-ascii?Q?7FUK0Ru0Fwm8KEyK7DZQ0adlgtEpZ/2UJXSwhlXj3+RXSW12aT289zs8/BrF?=
 =?us-ascii?Q?XsQkE5/mI+bGAltF9wi1hd/9U5kMt88RwZ+CUFDdDMl4MYxW2+ytlhaB46nU?=
 =?us-ascii?Q?VJm+//3rc3lDn4XUhq7538Q1fiLt1G3lMcpvxevfRG8LexCJkIXddLOhpWL8?=
 =?us-ascii?Q?ebwxnUPIia+38fYCIujARAi+97wUHlD4QepJVEJYEiWF3mkJFsQp9unrP011?=
 =?us-ascii?Q?6AJkfgI58DFy6LTvU4dtJkNjSfKgyf4l7R0+VTvaKGFrElzU2m3ZzRGyjI3O?=
 =?us-ascii?Q?U+Lewy4XyA33GCPOf8diU05pWoVQb47w0FjxAGDKGMP0wpcTO68q3OAYLlEM?=
 =?us-ascii?Q?h0FG060rQwZ/ryhMFpptVmTpOTm1aBKt5DYrmNKtaBA8Fk44reDm+XW+09Eg?=
 =?us-ascii?Q?UgI09vTKxDRL1HunyKEyaFNS3VO5oeIf7HPLg4hmA//Id68fKAQmw/aby0Dy?=
 =?us-ascii?Q?pioqLuLhAHmyQFnQu6i6Od2l5WRMkq061PmAA+oXgT0fbcBV8dYLVY7rXXqR?=
 =?us-ascii?Q?hLh1qATWURNdVsno/6KPWkWucNLKpeZUqSJ5mbDWpfJTZkDsT8QTDPbrVXev?=
 =?us-ascii?Q?OUsKQ3P6iPI2YyMoFv3CPhAiDomrtNN0fXR117yfBMwU4m4tcIkj5F7CxBrI?=
 =?us-ascii?Q?vyICP1YJ4M2uCYOLxmN0EWU1LtrQ2dG2a3S8cvQfd5hIoqogp454+9+FUcmM?=
 =?us-ascii?Q?vLd1AM0mRjlI2rQiRru/aj9vahGDP08DaJpit2yaP1LDfpETxXo+pyOCZhLQ?=
 =?us-ascii?Q?c2eUKNztmeBONbe2yk+xy/t+lNvCaNAyM8bp6OBk3IJ9uN08M6yZhQiK3vUY?=
 =?us-ascii?Q?cQRqkTxwIK//ASkA1t6czfzvXx+NBTgfMpoCs3v1y+qlneHy8VoxfluMwjBA?=
 =?us-ascii?Q?Pe/izE4RePaJ53wecCcTVyRaeJIgHVgnZbLkukZsy3CQWDFPiw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e410375-895a-444f-6fab-08d968449d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:50:15.1696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZmzSacmNf4E1M26HUpUza1qyEPYE5AKpNl2E9jWS2CzybGqYdI7OHPX2AACtXy7NBXyD3e82+6glrPd1R9LVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0443
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/26 12:43, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> I am not super happy with the name either. I used this one as the=0A=
>> least worst of possibilities I thought of.  seek_range/srange ? ->=0A=
>> that is very HDD centric and as we can reuse this for things like=0A=
>> dm-linear on top of SSDs, that does not really work.  I would prefer=0A=
>> something that convey the idea of "parallel command execution", since=0A=
>> this is the main point of the interface. prange ? cdm_range ?=0A=
>> req_range ?=0A=
> =0A=
> How about independent_access_range? That doesn't imply head positioning=
=0A=
> and can also be used to describe a fault domain. And it is less=0A=
> disk-centric than concurrent_positioning_range.=0A=
=0A=
I like it, but a bit long-ish. Do you think shortening to access_range woul=
d be=0A=
acceptable ?=0A=
=0A=
we would have:=0A=
=0A=
/sys/block/XYZ/queue/access_ranges/...=0A=
=0A=
and=0A=
=0A=
struct blk_access_range {=0A=
	...=0A=
	sector_t sector;=0A=
	sector_t nr_sectors;=0A=
}=0A=
=0A=
struct blk_access_range *arange;=0A=
=0A=
Adding independent does make everything even more obvious, but names become=
=0A=
rather long. Not an issue for the sysfs directory I think, but=0A=
=0A=
struct blk_independent_access_range {=0A=
	...=0A=
	sector_t sector;=0A=
	sector_t nr_sectors;=0A=
}=0A=
=0A=
is rather a long struct name. Shortening independent to "ind" could very ea=
sily=0A=
be confused with "indirection", so that is not an option. And "iaccess" is=
=0A=
obscure...=0A=
=0A=
> =0A=
> I concur that those names are a bit unwieldy but at least they are=0A=
> somewhat descriptive.=0A=
> =0A=
> I consulted the thesaurus and didn't really like the other options=0A=
> (discrete, disjoint, separate, etc.). I think 'independent' is more=0A=
> accurate for this and better than 'concurrent' and 'parallel'.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
