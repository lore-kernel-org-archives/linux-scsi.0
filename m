Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4BEC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 14:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3AD60F6B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 14:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243140AbhIFOKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:10:35 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61420 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242521AbhIFOKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 10:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630937369; x=1662473369;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=i73cQScyOXtQNhKCgBM0j0yco6YrKjuowVHgFUDbKic=;
  b=nmhHLodjf3kHs/G3jfsHnb8Pewixwv/NR9Kb6wQ67CxlE6rUpA2WqUZN
   iYM1coGVUNITQUVZDTi1bEb6uxS9w49BqrFY7O4OzYKrN0dpwoU3Qtr+K
   Dytz651Avm6mRCGkAARR92ivFD+CPfJn81KGBOxJxYUcIRUf15TIUrz3f
   UN0QS97AbE3dpYKzYTkejg6E5oFYbWwnj+/StnaKG5tpj4Ux6r21jUHP3
   N5j2nrP+o4Lhy4wNLK6OqKDEvb0f2IxiAyYRoA1QLaAr5UbLkxsVo99ti
   BYyLNYHlobNqd5ZteWWMEEzdaUFpAQcybQjK6XbD68AD3jpUcfXvz0v+1
   g==;
X-IronPort-AV: E=Sophos;i="5.85,272,1624291200"; 
   d="scan'208";a="179299333"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 22:09:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrCYiPb96DcZ8azJGxsZ2oHjaPE/Fux3qfC7G0FkZJK64sEAGfOt5XysjeHynaMriHfVEXKwb/Om/lyfGLyBOYB3zFvPJJsjGRcYB1El1X2oEmIqjhdrd4CnbcTkPOsg+BdAeJ+ZpJdrDcjd40k4zhgRv0hcc7y9PKqu5RLSwl5Y0RDP5mcSuN3xH4spVJeM0rm/xtMXJcFGl7m2NuWucIE+O9/pUbpZ+bLWQk7ef0lPKEDsh21OkXr1Ce4RL41xiu4rVzdmTzozcv9bLPy/Gc/W/HGbaY0e6bxWE5LIjEnuv7o4B1/qzWUvEBoOk2B02cX6iwnY4M4KAuxM5buUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i73cQScyOXtQNhKCgBM0j0yco6YrKjuowVHgFUDbKic=;
 b=NlqLgbVzdZjpBqJPXeu+hVjvG9zw/GhrnSow2kxxovA3mgrKgwRMsfz/cyVnkK10sxPOzAK1JtzH5ujBhDW3HDeI7DN+ViNKuIa0d6fpcWHIDmM6X9c2WhmqRMoyVmqEvBECZ8SD9kKOntfyZ4SFin0InXR1pB8ClPg+zQKiiTSuTUEE/zlFyRyPFDCaE60e6/endPoSKIfIBw1iWRo5HL3iR8yGl8oIBb1VihjQAxMBhb+4e1sV9/cCmjqU9GwYuQNUNQtR3GTNUsdQOex67ZxwD85eAcIYBr5laFtJB9hglN48RnmjSOVcGr33bzTmy//9FSfBAkXxMs9SoQFqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i73cQScyOXtQNhKCgBM0j0yco6YrKjuowVHgFUDbKic=;
 b=o4lFqWecAJm0JYjDRso7VBbJlDb5jLlJfIKaHzv2ZPkhlAenCwZ5vn8h8Vstg4hyynqBoBrdTfQ2WtWHMP/mpNjenB43gbSWs+hoSx0mtn87PoT7wueSLPf/aFnbMpTz465ho6GtsX93Uwpo95Yef+GdEnEKxGrCLYXOxK+wfZM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7478.namprd04.prod.outlook.com (2603:10b6:510:4e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Mon, 6 Sep
 2021 14:09:28 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5d0d:3d52:2041:885a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5d0d:3d52:2041:885a%4]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 14:09:28 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to
 SECTOR_SIZE
Thread-Topic: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to
 SECTOR_SIZE
Thread-Index: AQHXoyiKOygz2F5OoE29tAyE4De+aQ==
Date:   Mon, 6 Sep 2021 14:09:28 +0000
Message-ID: <PH0PR04MB7416208D588F7BFFD0810B839BD29@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210906140642.2267569-1-naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41f7d20d-1602-4b78-6b7c-08d9713ff0a8
x-ms-traffictypediagnostic: PH0PR04MB7478:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB74782541006004FA89E94C559BD29@PH0PR04MB7478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ewSXYvQfPkuUZ/YzaOyWyI3+0ZZmwbSlRAR8WA6spNV8LkD5Ro2ehE1GxLPq67maF2Rfh2T7+lYQNKmMmtxFEKQNbOYP7Vc6Bgz7kIFUW/9Igqo+s0t7Cd9kHq0RIMbtWanHIWb808WBSgi0hC0AXatWKRaAO8DG3Z9n2lNTvyvHNaCy4X/nNG6xOpz17zSo2W9c4/KOEvg0gPGokyP8JnSDsA8Apko1hlqXBUBhLKU3a+9kHjVyAOBFbT6lX+nplzUw7/cVAGj+/jj8y0h6cS3mnytY1nVhevga08ffPdjoZYXY2zZa08zoxIOa3NzrYrvJ0LEUiEvscazETi9wFIfaQ9hqXDm3boAJccN73Zett+xsSRsguRWYPWsh8gE5tDFVYATG9JK3BDkSps3ALygysLDDIbyXlXsP20tQn+8kNowSpm10DKrzTNbDUbGZ/QNtuiWJvBCay3d6VpIm4eDGLS6nkCvPTAS4Ua4PoB4cEGoJOivzvRkRP7+DTYbBlp6nxVAA9HdD4/akdKriE8Cm5oYW5em4P0E9a/LNh15ArrrTvUNV7IDPDAUDsYc9pG6YZqpWUMoWaa2jYyy2/JKHQG6rV2PKPk+aLKfTt6tZR/DIS5x9RLQq28epRrVjcgotLoDsxlCOCrRCZRfpw+FI9MTki5mO8rojMy02K+D0ot5tira2vjbpbCNOz2sDMgRKPVtlOElDGGQjy1+T4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(110136005)(7696005)(122000001)(86362001)(54906003)(71200400001)(4326008)(558084003)(33656002)(316002)(8676002)(9686003)(4270600006)(186003)(19618925003)(76116006)(5660300002)(38100700002)(66476007)(55016002)(52536014)(8936002)(6506007)(478600001)(64756008)(66446008)(38070700005)(66556008)(2906002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cS/BsjgLTY11+DJiiI2AXnpa2zoZzqKOOx0oJ5hs5l3wz6SNMEQJ/rYfhW2m?=
 =?us-ascii?Q?hbJccrhsHGur1Ln/YNGOE51SeXyo0sYq2b6DhPNRXXN5xLC4sr7WcYaYPzhA?=
 =?us-ascii?Q?6SivJ5EikhTe+HAyp7q/dhSBbfnrYzRBlfmcdoATlf+s4CWqptWlgttST08O?=
 =?us-ascii?Q?r6cy9UCmBoyXuyZR6oRQ+29XnguT5CkKbn7Uh+Cj3NyWwxfhYru+gk/HUjWx?=
 =?us-ascii?Q?gpwY8dUCwxdO7hpuTMEkt9EOK2JdgXB4ds865EAYckadWXFjKoU3GyS/i8dZ?=
 =?us-ascii?Q?Kqgmz2/xPoVWTLjJw60/WSAQusXmlZu2560TyeaakIeIXlE5NSQnWoP3LDCt?=
 =?us-ascii?Q?HkNv7VbKlpYxRzAmm98FgmORiOSgp80DQkttRwv9lmczyjlBxP8xQt9t+tnM?=
 =?us-ascii?Q?EqcugHnP5vww0dx4oGpyI7lH14lQ89liXBiZby34D++Msj68Lsce+W2fNWYs?=
 =?us-ascii?Q?m4S+z5txODGL9zzMoKZ8dm1shrVQ56K74A2SNBp7kjfj4IlUKT83nG3W6hKn?=
 =?us-ascii?Q?PAsscHkBFTeiDyMW58pCZe0KJ+allvt+oFmRcJh2eikidbG52OipS2m2FggI?=
 =?us-ascii?Q?G8zGKLDYJIJkRMi5ZWUjIiIKCepeZSHui6EriLrT+E9/kVuyS0T7u3nxrFQy?=
 =?us-ascii?Q?oucdug0OXR2eYTC6xYD3XL6ntC3FcN4pqeet9wX15mK7SXRmorGJjOC8Ocxr?=
 =?us-ascii?Q?GxpXNDhUStSrxaBLq7IxjAbm53lV7TCFvAsOcAxoJeEHCMvehiLwwoFSRoeb?=
 =?us-ascii?Q?ktMxuF4eA1Jg09bUbbjp4XXnwsx/J8VLyHZVSXbxnQ282ez6TnRu2JoARZZz?=
 =?us-ascii?Q?EEXrmg61zeOSof07EtYuiZu4pmfJdz6iffBBTCJfUUJ6+aRAfH8yEm1/A0r7?=
 =?us-ascii?Q?dnmsf6ilflYQj+3n7SXUV+KW4ziv1wJyLTLM7gmqvQ6YjgUgW1erX5barjUx?=
 =?us-ascii?Q?uJN92M1Ykb3X0DnHtWzTdSsM0qPEZ0s7gmwWd7UE8710RxfaE9iN8zMe5wDQ?=
 =?us-ascii?Q?JgEr2ax0Oc7AgCzvzh/npeyJvni3fXfT6kPU7hxMyRWqrh+/SbpP/Tf85Hdo?=
 =?us-ascii?Q?pjJEmo8uNw6TD2Vbqu7G9vDqB3FX1vr+K6jUOElYAsU1yIIRnG4G2Yf73Jpx?=
 =?us-ascii?Q?inguwLt+EdQEp2d+B0NuogSFx/bSMsgvjNdPXAhdfkjwrJC0jEnEpXEri1l5?=
 =?us-ascii?Q?M41y3Ntqu+9epD3n7qa20r9E7qbotyZBzeKRS+bvaoa5qndt8TQ2ksBHGN0Q?=
 =?us-ascii?Q?ycaqoVNyJPmYdjTttf5+3M4Og2R7Cha5ECCOaNLKa/uBEebK1t7Z7eoPs+gZ?=
 =?us-ascii?Q?OKn4vpYm7Gkv4S5ZqF/0BvXq4njVI0/xC03eeSefh1OqXvOT8zjZ94e+Mj2l?=
 =?us-ascii?Q?LCyN3DJdYvypbdOrr1WGyhhmK2pcT3wjJpUeaxdnJGz2lURoCw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f7d20d-1602-4b78-6b7c-08d9713ff0a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 14:09:28.2002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6LqKPF7B6ngLyrOeAlPiW7nykwIUcJlSNd5V03/ncq/PbX67/pH2WRdT9ElM2I3BFF9Sp9jm9zBM/HNAcaRClO59NVHxQ8wjkd4T42QeftY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
