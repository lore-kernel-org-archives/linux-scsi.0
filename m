Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A22C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF0864E68
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhCANAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:00:05 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9554 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhCANAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:00:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614604124; x=1646140124;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=gX5F+sotlMxzfELq05qA768WE1wt7OuhWCzcDiohu6ccIBKXB0zFbqgV
   dyVZu4usWZ23FHjN3FWlVeZeDZuX1dcj8Dbk3fwrvNOtJKqrMKckNHnna
   jXlTz03e7qnChjoo9aXxghDTZ2sVlwfwT3jOoBk8wDh7rSG0oZRtyrGlz
   dDcp1WNShVKI3IiBVFb95wskfoeCMlTmlm37A1Ac6gsH8Z/uVo2T3kcOY
   yBNUlNSiNhkNsqGHoohYiSdG5+Qk2ES9BSete6Z7JzH8YnXDPFkNhdqbG
   jFmbO0g35RH3mPtzXaEnf+l8E9cv+uFBXpt26BWawNck8ySswaw3MS+cd
   w==;
IronPort-SDR: 2XIl+H52wWcW3WuNYWTCqSAEUJNhJPUDJp3iwmKlAjB94nSEIeTsvyS9jWztBacgUfam8/SsI+
 shO2ihrvZq45jZ5t5iH4W4YwgiS/x0V06lI57KCd54gOdWsyVBFoOQmhuUxvHVlKonpC9pXo8d
 neP0u6fHLqq4bKH32H1PaQQqJx1b/3vKnpkbgLxT98tcxOWsChFfRdDPb5v4cltBnjiWRfctEJ
 0UwetmvndZ5SJbSf4UrTndLdu6k2LjtvlMWySArETq+M+pwVHdjJnh6kJyxW3aF4VG+T0Wvatx
 nwM=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="265332557"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:07:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa/CTMETI2MjuiQLr6AR0cYY/W1qbjn1zkFNxpBG9/OgmSbddggTD7Mox24por7bARiEOYVJ1rU4IBXngkbfLbwXpBB84yBIhmgaq6aMWzsXMZ5sDEAFCJciQO8IVZbYlyMzZXpMj/CrZsTMl/6ORJjKxA9E4j0LGZIx4fOUfURQ0z5Amqo2DJOTYZkt70KG/ai1Cg5TLQJGcvVYdLcDOfoX2QxfRPlL2/+yKusXqaLmdFq56nbET7dqR5VPmtogixiXqNdKFS/dx1h4LqmnjIb7q/b8OzQjuFcJTSyyjafm2UFGRhl+b00VnNCv+3s2qenzJbNHGYtLKLInYAph/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=GXAtJVvul8qxC96hTF1CfzEGLzlV7lkFIXM9aXF3QzCAx9ptAzP91OQeFI31QplMjVU9TiXgqriOfOmmPF0NU5UsU9KcVVXMXvIMDgkKjwi5zaPWfJw+NCqatENBqe4AvUpUQzT/z/Gg8g2DQFvtxMObnXhzdNTsRPeTjgs7OZDJDyqWoH0Z8YghAs7Xr5yOrOmtFF1KFIXHZfB+XK1rQuoeRt5ah+Ojll7I9bvlZEAgbwkiRZwOGVpwMm4KHXoRxHtKT4D+em0TV6WS/Dy/Is6TVjDj5udIAVCOI6nqDC2jjh6WH5lExaLVa0y0eYvPTHy1lTbhf4Ka26tnpL/97w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=KONV+yDn18EccHvezUAqtq2XJbFErumnuSkqNcwIGD9dqcaBtrA8T83b8Bt9ob0YNpm6ybnmB/JdRmMRhyheVNctbRADxcqA6JbmX0J3BwXtKZBvdm8cX+66v0qPRC71k0EVoKqphp9GL+0EgzKGDu1SZbylYoLH8AWFRpcKrIo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7237.namprd04.prod.outlook.com (2603:10b6:510:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:58:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:58:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 11/23] target/iscsi: remove unsed macro PRINT_BUF
Thread-Topic: [PATCH 11/23] target/iscsi: remove unsed macro PRINT_BUF
Thread-Index: AQHXDZcBe/ZZqEI9sEupYdb4VZsP5Q==
Date:   Mon, 1 Mar 2021 12:58:53 +0000
Message-ID: <PH0PR04MB7416D8E18F84DE97C93A5F219B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-12-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d23efd63-c49f-4aec-0c06-08d8dcb1c46b
x-ms-traffictypediagnostic: PH0PR04MB7237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB72375312A02C7FBBF6E0F7839B9A9@PH0PR04MB7237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6vjjuSABCVKKdeJN/8kbFEK7PgjSWVeeJpes3y6m/lyjFisRxy4BkzcZ47tLysS83/2st01H/925Zw3qFCJZMYKU8aFqi7ajIuk1VJZcpZL0VzDvzk+qpcOESqlOvVlvuVzVzdbq9yZh5PnG1oAhQTJAnx8Aey2VmAw39ak9GWC80cd7OnmpZU62sxjGMfriTJFRN60Gel+hZN4NcPRrApQQIa04aAZ0e/HddmS3Jwv/hg1QD6/YflKSrTcLfFjgVfMNLokuJl8uoX6b/wroqEWkqRyfXFxpSa5hi0bBLK6D9IUEax5i6IUSClC8E327bP2Taf+sYV1dL/lFZi82Sy3FIuZFIhB7EC0HnCdNVViCOnXvaxN1M9wV0v0aA8vtI7lKWv3mItS7ZfywzsJLGC5/akzidN2F0UD+r4wfoNsu1Cpgnt++EXGcMpTdSTFuPY6JOfBp3gKG6OH36EzLF7jJ11Ls1p0ceOhcXp2YTbjga5bm6DpTwgHjpZarjejqFJTsN5Lx4/JnanxPwIc+DQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(4270600006)(71200400001)(7696005)(54906003)(478600001)(26005)(558084003)(186003)(316002)(110136005)(19618925003)(4326008)(52536014)(33656002)(5660300002)(66476007)(66556008)(76116006)(66446008)(8676002)(8936002)(66946007)(55016002)(86362001)(91956017)(9686003)(6506007)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Aaf8vtqjD/0IPtJp6qklrYlFkretpYxJPxUxbzUEocqS0+OAnMeM1cnQzEHo?=
 =?us-ascii?Q?dOk1NJn6iRSsfxxutMBF0oHQ79tGaTgjcHBGmPgQWqa6lle6RDXPKcZhdkeY?=
 =?us-ascii?Q?Sd1skEDn9llITJ072PL7jPsjoPHPxeLSii3th6zg60IW4yIhFwfba4obyWcQ?=
 =?us-ascii?Q?PPIi8XeAoIyMoa3fagc/qRpeVIsB66LwPgBUqDwIzo30tu8dBr05MtZOqlzG?=
 =?us-ascii?Q?QEIkeT3w+FkmhHz9WEXeYlAbO56HUJchoTJH/sGP4f5oWxqyAhff7udJhDY2?=
 =?us-ascii?Q?P87a2pTt9tBTLLsw0Y54G4at2y5SPoid6/616fOlkuwIL79JqLpGE90YkF5q?=
 =?us-ascii?Q?i1YPAr7wej1uXr1vRYUo6sDAoFFh89p4gKWYYd1O671LJA9ZDi967g/KTTXf?=
 =?us-ascii?Q?sAaWK/5ugklMKEuqT5DBVGKGlJNQXnMvo/BKwzPlnYFQpfJN0EvGYcy8k6eb?=
 =?us-ascii?Q?c/4wiYsYajb7zAxyd85Mc2z8PEynHG7HKE38c8PYK2zvDn3nnC4EihC4nFXU?=
 =?us-ascii?Q?wI9qIpc5Ji0ZFAGkTf6yAkle/SG3PHMSgd+D8oKopjEJxdKsJwI+HRPoXWoP?=
 =?us-ascii?Q?KI4/8JDTHXlIMX7yhXktUXuFVIRIIr2f9cFyoxLwvUGPOvZv2jNK0WBuJ1Y6?=
 =?us-ascii?Q?aBgdZP+WOj0XipEFLgpnTsBVeYp6n/FnTt3UGLNnmwA/soGC+WoCrwj6NYg9?=
 =?us-ascii?Q?PGC9kJhccJZq4b19KUcQr4ZoLe+Odibh0DxVXCdiJifSUXWFGTjHwdgiRfxS?=
 =?us-ascii?Q?PxKEkcsOi1aM8/W59itJa4Dqg/20Jju2cnDF0ZGXQwODgXdsstnKHbfiatbl?=
 =?us-ascii?Q?1QdRejzPjyXMADU9NFfHnJSRvRuovcnpO9eKhJe77Y9xm3WuK5yniVuMzXjz?=
 =?us-ascii?Q?ZZZS8svFUHGTj0gN159oJRD4sybNi3X1tmK71At412o3MJamb4JJyxnYSzbn?=
 =?us-ascii?Q?MRsXdVAdfXXweT+NVXoKfiXhxeGqxRJ9lEF1e0OUkvuW891xUzHTxeqGBqrM?=
 =?us-ascii?Q?E+i8tPFQrLg9G+OTic4ID4k52gNsKKqiVQ2kLcnBKCgGH/jljfPCNsUbMZmW?=
 =?us-ascii?Q?HX3P8cfS0iVEA7bkx4P0CRox9mz3D/AE0CCxHdI+SzVEjLydioH9Y7Jv9rmF?=
 =?us-ascii?Q?Ayq0lJc9wmKsifCutZtwurWM+TUHwGDV626+mf4MMKTsWq4mgtbX1VCxVPTJ?=
 =?us-ascii?Q?Ka8fyoxX2KubojEnfGApAE59rNy620SNrPff4ptw5f2jryAGvI4fd6zGtIUo?=
 =?us-ascii?Q?q1bejAoPNXETk0ovIqB09V/hUE80a8/ip0nHkf2KSaB5ZwznsiNjdHO8WvnC?=
 =?us-ascii?Q?/PDbHLvHGPMhnNr+fjbjRLyFL6Dz87TEal2+Ev4wumhCOw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d23efd63-c49f-4aec-0c06-08d8dcb1c46b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:58:53.4262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lfCX7MecFICd/pTpuXzqWOUMSliaTLUtmTo9Ah5eG/Nj5+Db5obPIdSqQ5Me3l8QjinE54b4whaxlv6ThemDyZ4ymZ+f6Gqc2giG2IF/utQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7237
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
