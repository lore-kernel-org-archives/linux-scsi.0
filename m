Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2468EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 10:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FC4610C9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 10:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhJMKsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:48:21 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63285 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhJMKsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 06:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634121977; x=1665657977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q8u+MzpCXdjbD5lT3Xn5zudgxFgkQiojk71JCYYQx50=;
  b=bAuEwwjTLuTW2uwUA3oy7gzsmw+5MmcKKeMMz7ZiK9k+9TFnP/XMNnst
   FXzkRQOZCyk+pSh2/lUJuEM4UmIMkmIc+Af4rjcJZiu9ftbOpOFM+dqw3
   67+WCWCUMXGQ5GiCKeH+RPFefRe/ZwIWQaCk9vDE58a0Od0xa/Uy9uie1
   IYUunmxFjkv2euyuo+Qro70StZ+Zlb7vAlQ9bwxdBl/Nv1ceal+zHn/zd
   kA2s7ymhBAVYOQzDIFbJcX/VFdNIzzc9QVzu72CQekHNgtQDLWxP9n36b
   CDiHvjuZo+x3Xe6nkQSL1PWuBLB8fTAfftYLwG544vqVuRZyU3QyNYnLL
   w==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="294442485"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 18:46:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgGPidsQb91hkRUBGfh9qSE/ieQwzoh3XPoHnRyf9a3PjSqc+6r1R24O1cfsaR39WR9xZXG0ExnIH9bU3VBJuaHkcUX33niwqp6MRiKojJpiuF9xtg5Bhs/smxnMfZ6kVzTU0qzhtw9LP7dVcD975ReIcFF3f0VXM2UbUWcjbfr3W+Lu2e7FptB5C3ppVbaZCpLZvD0b1boC9X8T1yo1pXp3/o63H9UQdltzeDUmYn0bBzerDfBChW2ApYaHqZtkLSUUpI9NuGXNg0LraB5VjCU9V+UtMLDXcTNEtZdXfGpDofM5QSZx+CC5YOUI0nTsbs4EYpjvsBmC2wtqGLIcQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtfOIacLqCihRmMcmhplb1jL9i/FPwqsTA5Suy3ZsVo=;
 b=Teu5JVU6uIH6UnIL2tiZ04+mkrQ1OriNFCHpk0uxd4l/Zjqimd/8LxJhQMGLM/Rd+1IJaEMXqOhgsE9nEuCYE6kLB2fx9KIF3cv1IZjnycsfFpO9654qGHHW5clYyADzs4ais+J3wx+teA+A6Bdx5w4tWXtb1GjwUGVxyzO/6kxhzFvBHOp5T3/yqKMBT7ELyQcubcATYpgAhQYMxAhpEnyIhqTodAgpzha+splJjuj0BeKbxx8kHVUFHd3WaqxgbxBLgycqId64dXrR2yHgFsxxJ8J/QCki60XPbOYPfiGC4FV2sLAzr+3XAvQNlY/v0V/APfHK9wYtg+nfSF56eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtfOIacLqCihRmMcmhplb1jL9i/FPwqsTA5Suy3ZsVo=;
 b=URsFtBNOcMkmJ8zZGkicjVQhACjjnphRfDFZIjEZ3PJ9jHqGyr+NZcb0aCNoAkBF/B1SIl8TMJpneCMZnzOhzQT319z7SOLUrLIhPy4Lq9TiuPjVahyVzNgQshGZLvnTKU8L5mX8X3RQAJeziug+rzZR5Drseqia0KhJlmEsL5A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5819.namprd04.prod.outlook.com (2603:10b6:5:164::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Wed, 13 Oct 2021 10:46:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 10:46:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Topic: [PATCH 0/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Index: AQHXv2ktILZ4+Vq6Pk6quV5n8PaEsavQv1tw
Date:   Wed, 13 Oct 2021 10:46:15 +0000
Message-ID: <DM6PR04MB65752EF1F70EA5CF44F8AEAFFCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
In-Reply-To: <20211012125914.21977-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27957d95-72ff-42cd-4a04-08d98e36ae82
x-ms-traffictypediagnostic: DM6PR04MB5819:
x-microsoft-antispam-prvs: <DM6PR04MB58194E353D7C7CF0264B9CD1FCB79@DM6PR04MB5819.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zKjfu9SEmjlOqyP0F97sHV2Hd9sJrgWIkrRAzmkXnh79bpUL1VDXhoODUI/swdlFjJjE36pDGodsCO6JQVOA9eQ77qP3puJ2NOosxg9BarCNBNWsmI3XXpXlpBlTs6mQL5mSNeX9wAZ9LgQAioI52YZpJ7eHfpktqwx+zQMdpon7GRuJMLg0aZgJZyXlc8pEyzdI9BN2AvUGd4dSQ9NAh5X8WXGwk9yx+l5rIwhG4zhRDDt2O7jSMOEH7z0fr+6v78IUSLLQwi+ZKtg1FlNL84iSPuG0qbxfzMAQGD7HzV5f/Q+BqFuuzkrOiDaIRrbMSqxL1mqfw/LyZdn6NcDxiPeX76yI6UE5Z5Oqnd50R/59eSTxZVOwA/g9C3O6Zoy1q0q6h9DG5/ATybbRZ1HbOuIwb89qN+B3F11QhCFeiueARaozgk/iuv6jmAnWFMiyogV6sl+mBUqcS0snwIjxZ3H9An//oCMtDLdJL05AMPTkt18zi7OOuwTw78ibeQ7THC9nTAxjGjx5RJHLQ43A23ymSLcNC8tM1b7v5kIbgGYimfKcAoasKH7eWVE6FDaTmroRfRVrbKTVRAZfcOoHDyz9+72AQriopzX+NkApdGfxFqlpJ5GSuzItmUP/s3Koi0gd5la2dFvtN6YM/JvFBRjOFxASHBjtlHtA8MRZItZNfoTt2JYk9WBr7JoMHvGYMN6pYNSN1SYCjJS7ntzAZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(122000001)(86362001)(4744005)(66556008)(316002)(76116006)(2906002)(82960400001)(71200400001)(4326008)(52536014)(7696005)(83380400001)(33656002)(38100700002)(508600001)(26005)(66946007)(9686003)(38070700005)(110136005)(186003)(64756008)(54906003)(5660300002)(66476007)(55016002)(8936002)(6506007)(15650500001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F1HyxZy0AA4nfNXNrtL3rvqN/RHmmcRfCIMsMdc1Uc7W9f7XiVm4ovVNmlC7?=
 =?us-ascii?Q?eTdPneoux0aBR596bH4D3T5H0DoVs0BxVKC7RkTkXkGKC0jgg4Cz5YwlC+MX?=
 =?us-ascii?Q?zhCi8eLw39BsNGxpUXdZ2b1QJPVX0oueUhcu1pq353CFlm8fV8RjMcvoTWZ/?=
 =?us-ascii?Q?4I9lYJ7ufxH1IvXlbhbIjGqFYfkilvMjVvoyRWqWIXHMMihE/GRalEzXU8/I?=
 =?us-ascii?Q?yB3HHyv2H1afsVao5r6aazVXN6BwU5OVT2/muyOGhFrHKgeDv44r0zERwvS9?=
 =?us-ascii?Q?0eEP1pHQ7WADA0Jjo6WrpKPTFJOFowtbExb54lccKrOtGg7agTBMTpSDWcFw?=
 =?us-ascii?Q?KOWbGGvub43M+94xbPgVTNLgcADMDRZA/YAQfkU7J1kqDnlsWGAXxfD9lvJ0?=
 =?us-ascii?Q?WxLEkbqSEbAkZtrrXAI6uhPldJEwI4BjPvmksV0l7GCjtAjw0NWQCAkvgb84?=
 =?us-ascii?Q?6+lTcz0jKkKwCLJytnrutSvaYBnKDZMTFlBAg3I3lkd4KRhNS2pCeusOw9YI?=
 =?us-ascii?Q?soHz3nUQhCmsG5mnmB1INlFK0Q0OxevK9UuWbv6hk62g1DtOLFMMZOxKCygV?=
 =?us-ascii?Q?FRxsmbu2pdu6uLr9t0Akl5sIKOr79xs8SUUGq9uV8LuJGKyXTLSpNrZdOOqV?=
 =?us-ascii?Q?ifIIAgdxVedOcr44eMPb61cSWf7bCjH6SA68EIkAVU/aF+DddwDYZpoI96nb?=
 =?us-ascii?Q?p6ab/19nteLfYke2sqFYBIEA4JJaNL6fEH1bAldvgn9SvhLvZWMhv/58rrDR?=
 =?us-ascii?Q?F+hWnJtmS7odODPkBX8XUaNttevMxSRqeA6B5w+4UDKF39w3RGEAM6UfGS4h?=
 =?us-ascii?Q?i1a7GDlARLZxjAGAAikWmO30FS22iQVgRbWkIR2pl1Tuq8jIdmlIcuBfjFFb?=
 =?us-ascii?Q?ZvgS/W1HZbgsMz+Gm/VQGzrnADyP+qTUIlVHvFfEDbCy9KC0T5ZEJmZDaoIl?=
 =?us-ascii?Q?d/4C5CKLXhHn6gLXtbFo+X01vKhN5dZYS6Tw9P5hquiDxozWsOuPMauYiXj0?=
 =?us-ascii?Q?5SnD1TTBtb7OyLmsZZ2xLdlwxTAaVoRa1jTr6u1OpTzei+QwZbef/o4N3zTX?=
 =?us-ascii?Q?EepIMpvJHvysul/uob70RaDa3a5VkL9II3OrTg4TB/2M7AMUMtO0dEUvrZHM?=
 =?us-ascii?Q?4ofCHTz08GaRn8VqA9LSOLyN7N71qke2enSTLtb8ibOBUmq/oK/XWVzbLcfZ?=
 =?us-ascii?Q?IUa5bvW7Z/NAciSahrZQYTQVYw6Ykvx9rqeXLqA1BZHvHXP1I2XTzLPaw3V8?=
 =?us-ascii?Q?igmnNCeXcRxX4RV2L+BkNVUvRbWk430t7UKa1OtwWkz05g0r5liJQCJP2MPp?=
 =?us-ascii?Q?uSDgeYmg72PNBrE1doFYkGp8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27957d95-72ff-42cd-4a04-08d98e36ae82
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 10:46:15.5628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /iVwCnuKG7LrGYoAOT22q+BXOkFGcYnkhS4UxMyBQh7Aap6PLDDYKgYk5CFQtbTBiaR0TGFSBWp0gsQMWb9qjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5819
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi
>=20
> This patch ensures suspend-to-disk works with Host Performance Booster.
What is "suspend-to-disk"?
What power mode is used for that?

Thanks,
Avri

> Since the Host Perfomance Booster feature was added in v5.15, please
> consider this for v5.15 fixes.
>=20
>=20
> Adrian Hunter (1):
>       scsi: ufs-pci: Force a full restore after suspend-to-disk
>=20
>  drivers/scsi/ufs/ufshcd-pci.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
>=20
>=20
> Regards
> Adrian
