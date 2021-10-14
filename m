Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860ADC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 12:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62FFE60EB4
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 12:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhJNMO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 08:14:26 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:3347 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhJNMOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 08:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634213540; x=1665749540;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=blX+LIp7zYO7RzdGAVPGpaksCq8vfYJNVjnKJOu+e9c=;
  b=hkXMvOj76JaaXqIkFIcSkRa3UnmXx+1sUyu0S6a9TgY2aYTXIvwr0wBp
   WVROWb2dHCIfFd4+4PWGQ1Tqa35fKnkz9QRj0sjrVbzy7bP4uUC5NMs8r
   1aTWOcE01BAs+ZiynCcy8/Um60b+gGa2Ji10pQ1FAuRz+aH7b2Pj+3xQh
   gz1osSSzMLOmR4cV34N3q1qyrzEiKJyFHsLsLaS/BVSEhzY0EBz9Q1u1t
   IQNz6Z0RnqJgvPX0L76YfuGFB+g8cfWC9G72kOZObCfpedALP51jAPW5G
   gHnjSjfrUFTEyIHQwgl8PTqGrr4Lc+chCwWbv8BCA5rZWb9CPH12dgatJ
   A==;
X-IronPort-AV: E=Sophos;i="5.85,372,1624291200"; 
   d="scan'208";a="286697985"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2021 20:12:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEpTdkUZD6rXT2K/ugTpGDk2mmNidnSOexIeAC0ZPJkx0kFQOCJuA2Ffxwlez59F/G+tY97fqf5Fe5ISNPYAwiJTQqQsm3IQfCJPnrQsKsyDQHzefNsKRuNeyQLH/s3n/crc7b1hzcBExbsn5uZmVYiSQldr5J3HKtdPVyBd1cKviBtJ2TUWd3Z1lnBIejnNxubytIuaJ6MQckkKoATYqQ50Lk6ozOJHGWVyR8uu+PWyJYO0Sj4qJpKwGHs1poehW+R6SUTguBdDEQ2/MfjsSAj9hQVtR8bqM6tEkezsJcCZAVWu2YFRFe6fVcjaVAXTg8Qpzr6f5ljIi8K+o+YLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blX+LIp7zYO7RzdGAVPGpaksCq8vfYJNVjnKJOu+e9c=;
 b=MgEpFgzPfkHolssMVxTeNcQBpmBXZUTQSCuXzUg04aKZZ2GHGLxo19tQS6nH+RiBxsrkH3CJVXZJkgi0zXe4nW8xGyjglCQLvhDpWqh6QCsCAA7NC8Wh4cNXYdy6v1KXeMNbF+klYwcReI9hSt91ekIJrdYiCy/MDE8yZSHUScFTBfpFCFVDBn34Oobo5OhiJ6IR53xQ5o2Ww6kgTgWNxhdKv/TT1sJapuHazlkgBtsK8tBazUmGyofQfFqI6x285z4MqQSSYtEc9IrTCVfe1QOZxZSk/r+ne3UE00mbrJPtv+h5VgSz1jbhDyCTL5Z8te4x4m8wkyrsT7idGDsU7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blX+LIp7zYO7RzdGAVPGpaksCq8vfYJNVjnKJOu+e9c=;
 b=gPGIzwtpR/m59M+7WSwgCwRvjB5vp1bEfz7jmumNr9ODKO/SEu0+2Fsyie1ajom8ktTCT6ZfM1jC1FgLdmGnK9MX23CIr0KNXJDvRaj7HraRMIxHbLAWESkFQDL2f42eUIO5UYGjXSMdzMTpT8xpuGV57Xd3btY3cbxId/NgFZs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6511.namprd04.prod.outlook.com (2603:10b6:5:1bf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.16; Thu, 14 Oct 2021 12:12:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 12:12:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v4 07/16] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Thread-Topic: [PATCH v4 07/16] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Thread-Index: AQHXu1MXAFe5r6zb8EK4DOdSta2z7avScjZQ
Date:   Thu, 14 Oct 2021 12:12:16 +0000
Message-ID: <DM6PR04MB65752FCA8B8CDF2E0BA0988FFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3@epcas2p4.samsung.com>
 <20211007080934.108804-8-chanho61.park@samsung.com>
In-Reply-To: <20211007080934.108804-8-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ca29cb6-d53c-44ca-016c-08d98f0bdd1f
x-ms-traffictypediagnostic: DM6PR04MB6511:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB65111DE686FB853B31B0B4C6FCB89@DM6PR04MB6511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nze2Lby1CDHA6zpqMtC4cNQmAc/nUf4bKAO0Zh9PCLEWF0PVFLRwA49iDBXulRSIgHA0o436PGSBIxQwicaSlmRZ1CXJKa0kllX9L9QZq1+sh4sSr1x7M643s1eVmG6OmqFJMzuvF3kkXZPCrcONfT10mYpvmTw2L9cshLiM+YCWX8W4tjE/gGEf9/9I9MhaT/3+cRSBMeCDPItQOmEgucnutU0aJYv8e/uOtXRDmqt2BWrKw7my0r2Ensi3NU7JT9t8NTqDq6s3oTgeF/38MKNXZnqiTEAlVvxoZauRLDp8wL6L+Ig569KC3/BhVKtQCf75G9OCaeSiCeTKvrJJwNJLSJ0YHnT4ZOWTu0WIj3/W9bfVSN1wCFcucLbTWPcscCfUINrwF73/N1Nph2WpovJyQgHUYrKN1TTqm57ej1Xt/WK3EqJJTvQF8o1kTsgs28KERVLl7o8ASrZpWlAwwKhqDorz+rzC72SAGSofGzIQ4BX+xIg7xLLWV/C8UfM/8p0hSKa5LGGayf21xzqM1BFV20bknd7taQSjOgIZBXRrfWL7Q4mEZvTYrpYcQLRy/d+DaGR5mw43WK6ydM0usYxjno7G5hoA7R4MDVPy9KGpZbx3AGybgugOG2Xa0W76lVoWK7p5LnepJJ/GRUfH8TDx+TQDGp2nk7UEB9ilZixwodd0FO7cTxVPWQaTVpIs1wY58osRkRD8ubF0MIs+EA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(8676002)(508600001)(38100700002)(4326008)(66946007)(66476007)(55016002)(558084003)(186003)(2906002)(38070700005)(82960400001)(7416002)(316002)(122000001)(71200400001)(52536014)(5660300002)(6506007)(33656002)(54906003)(66556008)(7696005)(8936002)(110136005)(66446008)(26005)(86362001)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFl5T2VzSFFXc0ZxREVObUVkb0JFYVBYRSt1YVdFNU5DbU4rSjdYVDFmSEZu?=
 =?utf-8?B?ZHBXazZtK2ZUdmErbUJobzJXRE9iNEdrWjBFdGtrQmlNbkZTdlFGRmZXcDl0?=
 =?utf-8?B?SjJDZVVqeG5mQWtWNDVYVFRFUk14V2gvcGdtUjI1TjZKYkREUS9UTk14R1Uy?=
 =?utf-8?B?dDFYck5hUm5ubElHUjNPZnFHckpacDlFS3JQcVAzL0VVNVRCQ1JwNlZwM01r?=
 =?utf-8?B?STZGdXljRnRYejZxRUFTSkhQYWlZZnV0SGJtRHNBZGVMVnRhRU8xSU1pK0Vq?=
 =?utf-8?B?NDF0RDZrS1NyMFdnU3N2d1M0dUZuOFBxa1hqMkJ4Z1FYRHZoQnFkeXYrL3NF?=
 =?utf-8?B?S1AyRWRGRS9rRWFjeDZweGRvTVNZL2NPRVBIYWJrZmgrT2VFOGZmaE5vVENy?=
 =?utf-8?B?WHNZTXYyVEloMkw2V1IzYVFpbVozYTNqK0pIL2tMTm10a0E2R0U3RUdNR0dZ?=
 =?utf-8?B?cGh5UkpDcGY4ZnlkYXpQczA4K1ZuNkVtOWxuY0FhT1FGbFo5VTVGczVyWGlo?=
 =?utf-8?B?Yk4xZDJGNXdPNFBwR1RnRjdZNWdkN0RxMlhnU0VoZlFiRVBHU1hkTEo1a1FS?=
 =?utf-8?B?UlM4TlhXNHZzc1UwMkhXTlNXL2JsTDRycmV3Y2FjeDg5eFdqVFE4TVQ4YlBK?=
 =?utf-8?B?Sm9SYVJ3NXFlVWtHT1F0bldlQ2dQN2I5Y3g0bVduRnpRem8wbnhMT2JVQ2lr?=
 =?utf-8?B?aHRoYlhQekgxdTVOR3hMVDR0bi9GaURRVWJMcy9QNVFDdGJadk9qbkMyNlU4?=
 =?utf-8?B?Zk85bC9Cc2pMakNXMW1jNUNlSzNvWWpyalY2ZG43UEJyWWQyS0EzWGN1bTdp?=
 =?utf-8?B?djBFM0todVFlbGkyYis3WDZad1RUdStkY3VHdW5JYXBucnBvT2lXY2dROUt3?=
 =?utf-8?B?QW9SbUsvYlc1cElKUENDbkRxd3pReW9hWXBKZUhWSnR6a3hEc0lyWjBYTlVT?=
 =?utf-8?B?ODJ3ZkU4ejNxb1lBVlRwa0pqN3JUTGxkbGgrbXdRaVFXWktQbDhvK0Nnc0w0?=
 =?utf-8?B?ZW11ZHgrMFd2enZ5VjBsZWdoYThQYW9TR09jMVcyVmxMd1p5Y2ZHUUZDTXgr?=
 =?utf-8?B?dXN3cm5pb2lxb1k2Mm9mN0NtemR3YU8xTFk4QTNLcWJuZ3NJWFc4NWZUbGRH?=
 =?utf-8?B?U1ZRUTZDdkhuUElyVVdCYTZWRjRFNTlsNmNHTWt3eEcvU2Vwd1NDY0dMK1NX?=
 =?utf-8?B?allqNEpEcjBZZzZVU3V3S0NCbVFoTHpKSVlhb2kzTS9pMTVFdDlnMU5KTVFO?=
 =?utf-8?B?ek1pTEw3ZFBSRmtwTXlNNWFUUFJXNU8zTk9yUEhwaE4zQ2svSXg1OEpUVnMr?=
 =?utf-8?B?Y2E4Q0owbDRBbTBvaGMzRkVnbHhXTWtZVmw2bjU5WWtKeFpNYmFIQU5IdEtR?=
 =?utf-8?B?Y2VxL0Z4UlAxcGVKalZheFRQS3FtblRZODZmaFNFVXh1aENpZDkrVTllbmdF?=
 =?utf-8?B?WmhzL3NjcTg3YVk0MnUvWGxtT0FlV3RkTHBLNzVDZ2NOUFdFNXlTRmNNb0Rv?=
 =?utf-8?B?c1dHZXJKT1RRRThscFg4QStPYSs4WDFBa2lRRHN6NUpiTXluY0xTVVRXb3JT?=
 =?utf-8?B?M011MUhybGx0cmFMdmgvWWg1VHhYRnliVm9xeFhETzRPU05MTWlnVDZtb3Bw?=
 =?utf-8?B?SWs5dWRhd0hqb0loTWlKMzJrU3FudTRUdTBSR0VNbE5DbTJnVVN0d3hwbXB3?=
 =?utf-8?B?TzRWUlRHR2o0WndnOVNEdlVFcHZibHgzUTdRcGF5OUtrbDhWc3ZUVE9FdWlD?=
 =?utf-8?Q?IHbhQ1bFoGtdg0gZHrISjx6r2Fgyuh4tcTW88mm?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca29cb6-d53c-44ca-016c-08d98f0bdd1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 12:12:16.5117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InbQGu3OomoFiHjvJIDQxkmpJagLknlVji4pib5/2yuIMlY1dg919ae4OK6Ye/669GSyJ1DDG8e5NOwfw0F1PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6511
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gUEFfUFdSTU9ERVVTRVJEQVRBMCAtPiBETF9GQzBQUk9UVElNRU9VVFZBTA0KPiBQQV9Q
V1JNT0RFVVNFUkRBVEExIC0+IERMX1RDMFJFUExBWVRJTUVPVVRWQUwNCj4gUEFfUFdSTU9ERVVT
RVJEQVRBMiAtPiBETF9BRkMwUkVRVElNRU9VVFZBTA0KSXMgdGhlcmUgYSBzcGVjaWZpYyByZWFz
b24gd2h5IHRoaXMgZml4IGlzIHBhcnQgb2YgdGhlIGV4eW5vc2F1dG8gc2VyaWVzPw0KDQpUaGFu
a3MsDQpBdnJpDQo=
