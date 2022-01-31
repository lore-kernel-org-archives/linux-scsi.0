Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061A0C4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350244AbiAaLVX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:21:23 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44190 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377993AbiAaLTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643627966; x=1675163966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=OsHOcPk5KKwCfEsEUfaPmzZkvTcctcugqKlvHjnXh+va22kNhpiPNSGU
   L8tq/SryB5Ky9dDYK+Y4/2UFeku1DX4QUtRZZffuErQvHmhkuzuA+Lo2m
   ISkxBvN1VxayA9fjbbjO9/UA17zAOKvtJFHAoVpu0aamBq84gf6KHdaHx
   6ck1aHouWTICRib66Ft+1Zu/fHubQJvuUkN3/Kjs8R5Ac4+IaqfmQLwUn
   +oGBsZNYcZLwvdTS4WhARZUTJlVfc4uiiXLsILre3VjRyxys+ooXEHZrM
   9Ul2bj/mDxcJTE7GiKls5ognxgFJgiCmeAFl1nKs0qGXT2PpjXTyvPkpk
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192788325"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:19:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFkmUJWe3yfjcvjAAfcCWmcB4VL/j0NMtJP9tZRhQVc3O2FmQAVBUxdyVBl02QdX1q94laBeeaYyKQcjXG8Vd9YDSY2gsOcbfSujuaOdp8BfAcnDI8JOcgBIOE8frenYhhRjs8CLN6WIeiV2S9wb4A5tEILWpVu1618qRha5l0plNY+OwFit60JUSaDqY0+7A5qEbbDVCHRbvkPuemav/HAKx5cdEdwOihgMIVrzCGJKMaSnp4DD24eSEu+p88LEMpnrmYQNF92CoCwN7lYkp7zKnnAZFsdKh+LvQkasoqdBsQnnEpxL89yL07mJF0OxtLopmcYwRqp94bhyKnrukA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=R7NbJWPiTta3mLU2j8VZ1DYwVPQ9/VK45FoPvoBJcoSgmYWNBwTuJphw4C3+0s0e35tvtwwsHoJSbv510et8OgwXpKPyJTvuzpqgq9meRu/MnxequjX2LAPpdKFOTAwpxyUQWBkEKj05jR1TfvPDxQrtI4xugJwHKNumHQUCSCimofM2mZH1n0IeR9/892oShhOJRUvnoLSO8NUZHEEkySnaVGMsYTzaqfGOooRXmkdFZJ+4uzjCHSa9c04v6mrOdQlq0FuzPhSH4m2Nj6Yn/jdnkOQH1LT9IcXS/UrvDgzMEvXQYylmD5PBcpc2AAmca0ZSEzDE3mjsqhsZi7/XcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=A5jMdw+n8hF5j+/WpYzVzQtl+edrl9EaKt87xCfSL1rHVRER+KflFXjIFeOfAGXlA+Auv4xnG03DS3YLXlGLRKoYZ14CveBXxeLh+iSb2cp0DqYnr9A8Ln8farjWRZr6qKtkrlWPny5mcRntVWoGrxHQYZ9AyllBZH9eyb8ApiQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN2PR04MB2205.namprd04.prod.outlook.com (2603:10b6:804:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 11:19:22 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:19:22 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 23/44] initio: Stop using the SCSI pointer
Thread-Topic: [PATCH 23/44] initio: Stop using the SCSI pointer
Thread-Index: AQHYFJVvIXH5efrqaEunuwk/Oa1I66x8/50A
Date:   Mon, 31 Jan 2022 11:19:22 +0000
Message-ID: <6a79c7068e9934b192bb844f310e98e53e7da6ad.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-24-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-24-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 832b94e9-47d7-40c0-dc49-08d9e4ab881f
x-ms-traffictypediagnostic: SN2PR04MB2205:EE_
x-microsoft-antispam-prvs: <SN2PR04MB2205A5D350D4F95C87946BE59B259@SN2PR04MB2205.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dYd8sjFlYqJ4ZkLpFb+gSxLzXYxDw1QbNCEuapEsRP59hfwTNAOKaXSmyFnjlFUTLkvlmfrw5rAibokjJ1phWQMT3/kGaHmx4dJwglqsAqaSkRPwrqL0o09y+keR1Bq+esqn5PQZ0bA/JOqtQcIXePotNjJAYfn+QJAp1tAB+mKbXpU5vt6MgGjN8DTF9tGCGhKfoYtY6q/Ebyy1jGFTCtUkcOHfUuqXprVg7WE7D/mR8vKYqyUswKjCNSmvT8tTXD4pE36lZyVYoaAKe2qwbd55xmjAAL4TVg29NhxaunEHssWbzgY1GXEYpNT7Dgjm48CgZG/NWg6TFdjfURfXFO3iHTEK5c9oYIgtZPx6j3VCm22jYZsZ1a0yNjbagRBMaLOj/ENe2gGlNCw7aQKhowU4bT2xL0WIbMuFCkCkaQ9X9pKqm/HRq11XbbGg6O1MJwzz/dT05RSmMY7shUN3kejZbj1Ene9fh9ZLL18gs9dS5uBz2FhIWY6G9pxdkZcAGpWsruvrWuyf+4EgMhclMTMS821oioWr6L65U6c2FvxnA5EXqOv39DVyo5jqpmMTD42CY/6we3nxkD1abNFeY+vlQvcE93l/pOh0mp/ob+CBi+hbtXSjf3egunIfvwHvISe/RfWhQabHDbpm/5kpyk1CbGNf3bx54WR8aV0uIt+boU0XU9UoitndVNtvIJU/g+eRkWd3ld7GaHJvz6w7rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(110136005)(8676002)(6506007)(82960400001)(54906003)(6512007)(66446008)(4270600006)(66476007)(558084003)(64756008)(26005)(2616005)(186003)(38070700005)(71200400001)(508600001)(36756003)(6486002)(86362001)(91956017)(76116006)(66946007)(122000001)(4326008)(66556008)(5660300002)(19618925003)(2906002)(316002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THJ6MjE2M1VnTk5ieXBkb2V4bjA5VnR4Y25FbllRcU1WQ09nbW1HendkSnd6?=
 =?utf-8?B?emY5MldZbVhYLzVPKzVnZzZueGxDSG1FSmxSZGJmVGdVbmxOcy9HVVRTSXRv?=
 =?utf-8?B?WThpYVZmMXZ6WDNBeFlTRlZtd0k0NHFuNFNNaXhxcTVHYUN0WVZOd0lTd25I?=
 =?utf-8?B?K2dtWDZsUTBVK1MyTXVNR2NVbFhVUDJzbER2OEZETVBTWUN6M2J1K1k5dmdo?=
 =?utf-8?B?ZTFmcmNIV0RBT3g5bVZpeVFIYUJ6bFc0akdUNHFvbW5pSW5YSUJqejNJQ04z?=
 =?utf-8?B?aEp0dXFuQnNvS1JqRi94V3NabVY1aVBuNU9GUCtvNjdOS29WenlUSTQrTzhE?=
 =?utf-8?B?WTZCenZqVUlWYW5XcCtPa29OZ3NyQnFiTEc4a3E2QVFXNzREQkZVOGpTaEdY?=
 =?utf-8?B?WnlOZHIzaHZkZVlDMnJuNnYrQVFHdUZQMUNZaExxRmEyRXNRMmxBYU5aUHh5?=
 =?utf-8?B?TlRjT243cFhjQ3d5VGhPWHNKaU04UzlOZjlpdlRtVDBhVWI3cWRpKzVwYndx?=
 =?utf-8?B?dHRXb2JyNWZOam9MUEk4eWhsdkQ3Z0JpeTYxZXYyRUVkYk1ja2RNV1VWRjFX?=
 =?utf-8?B?UDhTTEo3dTNNdWgya2oxWGgya0RtRTg5NFY5dHFaTEZWV2FiQmYybEt1L3oy?=
 =?utf-8?B?TGo3a1FkZTFQOGlkclhKWnZxdFlKOTVoQUx3VklHZjY0cmk1RnZTWmtURWhs?=
 =?utf-8?B?cW0vNVNmUEg2QjZkV1owcVlXMjNrQXQ3ZTd3QkJjYVF5RWpXcnc4RkFMTGU1?=
 =?utf-8?B?OXJWSjhDb29MTVZuNUhYUWZJNG00WVVDTDZpNk1LVTdDWnBpUTlMVWpmVEp4?=
 =?utf-8?B?YnpjaDUzdlBOVi9nYWczRktpTVhoN29YN1d5WUlUN21LZ21IYXU0YUY0bEs3?=
 =?utf-8?B?dnMzZGxGcXNSU0p6RGNaRzF2TjhvamZ0VkFBcmcvTmdYcjdid3lIM0tPS0R0?=
 =?utf-8?B?cUp6TlBPUHBsTU9maHhmZFJOYzVHL0tseFRhcnFyUnd6T3VZRDgvMEdlUGV5?=
 =?utf-8?B?dWxXOXFhWk9JVlhUVHN6QXZZM041cElMV09qdUhUbmo2c3dPMjlGSlhnbm0v?=
 =?utf-8?B?em1lWWlDaVVtYlgzN0piczI2YS9pVStTM3E1clFVSDQyMENoVkdlYkc5Y1pR?=
 =?utf-8?B?Ump5NFEveFZSYmNuWFBTU2hXNXF4aGRVdTV1UGVoY0xSTE44WXNmS3YwTlps?=
 =?utf-8?B?dk1pa2xMRUNwVnhRRUllVzFwZFdrMldqK3RyY2Q0c2xZS1E0R3VQSVlTMGly?=
 =?utf-8?B?THlDRkNiWmlUWU12cjJ6ZVcwSjFmYlJnUTlUNk5wY1c0UG5oeUkzZ3AvY05Z?=
 =?utf-8?B?akFXK014UURmWFhkN0hyRHRhNVhkL1BiZkFNMyt0Rjhzc0pCMSs2RWtvbHpB?=
 =?utf-8?B?clByS2t0MjBycG9tTmZJM3B3RWYzRHNoUWcwdnEvUHgySDJNbjFibzIwWHhB?=
 =?utf-8?B?WWZpMGxDK0lESGhWbmc1RHJ0S1lPUVVTd0lJZFN2bEhONHkxTVRQOGtuOTdE?=
 =?utf-8?B?SWFyS1llNVlHRnVKOXRsMVlvYTNhbkhlSVZLb3lFRVNScUloMVhPQU1hVTRW?=
 =?utf-8?B?Q2VuMGRaaXQwZStWVkhkeVNEa0dTdWhESG5YQXJlb3ptN1J2QmgzZjFVRTNN?=
 =?utf-8?B?a3N6U0x3eXBWZVFoaE5IdDBtMHF3S09LaUVCMFVSVzNsdlVWY3pHUDdpRnpD?=
 =?utf-8?B?d2hvNVB6Q2pSS05jRTdJbGM0UEtGU0VpSWdxK3ZKdmtJQnVoOGxZY0NkSnhW?=
 =?utf-8?B?SHVybFIxdGJYdFRLV25OU2s0M1VsdW1XZWdPZUtvVVdjWXNVU2RLT25wcG9w?=
 =?utf-8?B?U3l3Zk5BYzFTT3V4ejE4Ym9HN2Q2RDJOSFB0eWFNRnpkWXhib0M4aDZxNEVl?=
 =?utf-8?B?ZUI3eVVYRmM3eDBPUitCSklDMnowVVhGVk9VYkFGclFUVU82Zk9xTTh3Y3BX?=
 =?utf-8?B?dWxzQ3M3dklBeGJjcHhWYis4OUx3M0RwcTlTZ0x2cWRNenRzc0JjZzFxWFo5?=
 =?utf-8?B?SUM4RFdMcTRoQjNMTlhoY3RORjNsUURUUTdFeVlTV0R1WkVEQ3RTZ243c2dP?=
 =?utf-8?B?TVJha1pETDFSMGlBVVhoNjFEcC9ROUtjakdMdlFYUng2ZXpxTmdwN3IrT0pQ?=
 =?utf-8?B?cG1hd0lITzROTVRWWjVIeTRxQmpSbCtZakNNeGNOU0V2R2ZCV2l0NnEwYnZ0?=
 =?utf-8?B?OXA2cHBob1g1bmZ6Ym1IaWZIbzJGMVdxU1lncEtRRVVQR1hxTFJaK1hoUHRP?=
 =?utf-8?Q?yXBLYC9Z2u7WSPOCeBATKm7zMObDfMsxnGE34/BaCU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <486B978206E14E4180FE838C8BF95E88@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 832b94e9-47d7-40c0-dc49-08d9e4ab881f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:19:22.2403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YP6TXY5nVyB1YMh76UOkNCj1ElfOWn7W/6xiWSAJ0l/0cGVWfXcTc3HrNmsTSy1Nsfi35rwtMVH3NxTmQwwBOdm1StEqaz0PH92rnOO+fZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2205
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
