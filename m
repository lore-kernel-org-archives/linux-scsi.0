Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A429C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 08:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED44F64EC8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 08:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhBXIVj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:21:39 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57138 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhBXIVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 03:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614154891; x=1645690891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/GhzrxBatP+325jFpXtnl+Rq/VAlmalCKUfs4BeLgs4=;
  b=iChJSbcD1Wv15lzfB92PR6ZQsaSzUp/4WVGWm6bES0cmtCJhFb/kp5gh
   Fx4BEP6JpE7a5wlbslnbOUqfXrAGH37RlVMY7U0xHH4NfmIIrEj1t6bjy
   sCYrFzoEf3/JPRQSwHvot1w2YxPUcmYU3bjV0ee/YsHC9EzMJb8ThG4Nc
   MZJkZ+TEXsxIkbC1QD4AGlzgDbAh9QE+y2drmVfdQSlAFbBLksGQMH1RT
   mdd6a7uDV2ojwdG7cAuZXvYD+Guby6RWed7N4Yx7/FuW4m3oY9Z7nkpua
   KpyvBUUkVAarIu0F8mnoAtO3IBQddDkCMT0KqXKsDC2UARyWsKcDRrR9l
   Q==;
IronPort-SDR: idhjdbl5lkdhyZrWAnbHaHC7ucEgmyt+NRpweuiAPFaR1AqHhHwGCJrrDlWHgBUh3Tjici0JF6
 BPAExemVamGAlAgVmN4Tf6NNOVwpuGWYszE+RfhuXdJxp0prRfGGNyIbry9dsFNjA2rox4v59I
 c8squKfBNpoph0uubo8R+9+oNlVbHlOcdakTr0qUZA7/UeJ7xaMwlx0CVvPHeMHb+DKiC7pRGA
 bfjTfbwacV3fPpMt7MgLuS3E2Iw0sAXSfgJ5OhJsc15T8PKNLO+UPaqIVA3wb1cIBqS2Nbc6ff
 ycQ=
X-IronPort-AV: E=Sophos;i="5.81,202,1610380800"; 
   d="scan'208";a="271223375"
Received: from mail-dm6nam08lp2042.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.42])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2021 16:20:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+VOGKQDQbskg0wamridOXP+PMELzRgAmlqQOZP3BHZsNQXWAzia+13N4QWiUYnEea0PYCyKTUo8f95tfYXs0TPNCU6ZGej1UQ2RxNX6CDVRBNW0iP0Gh+5ofbeTjUijAqmZZi2GT9VGAlFrnm8cd8VFNVOpBwk+3Tv4FS8zbt31wFQHxACvTySq8U5Y+fqwMT2mxwBiP8FBd8lcgeAIGJPX7aJqvi3eBZjZL/TTRPtVAZ0f0255aaix/osgFPIb2kX4Y8vnFNCRpqHcyc7Zhmi9jzgxmIZEt0XZHNCPCRAjeMuwU/22GfK9K+P83z1GNXZVMW/h3UjN8thPwefBcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GhzrxBatP+325jFpXtnl+Rq/VAlmalCKUfs4BeLgs4=;
 b=Tol1wdw92Ecff1xYmE+YUYUGZapOZssVgFDx3i0ZlzsNjN1NWxwnZNlNkwsDPyMrXzi1BMj+9iVz2ofAnv6tcQCrw9GzLUwDEdHiSx+nyfiVxFm7VxGQIb90t0jtnxRwntjfQkicmtGl4LfKJFJz46zwXhjwUFWTkyrYbMc6/15wP6MeSYKsfMVEkiEImtpyYoCntgDDpuG3F4xe6LVudPtM6V6WNLcpC/vZTKZdn8DsNopSByaP8t/jmbW/a9pVG4rZDcIh5ZsMjFhm5r6fKFa1se5xW6sDk62VNYjw0jkdBiAlCyx2hhZhlUU8Ts61tm02xzP9JLYJFGyx62hYSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GhzrxBatP+325jFpXtnl+Rq/VAlmalCKUfs4BeLgs4=;
 b=pUXp6SmCP4FrAAh+eHhaZ00lh8piUsIY015/YBGmUR7n1xdJlzPKUzxC0zg8D7L8FppE4H4E3GdZlez3XhurjL7BFjA/si0QrMpD+PNwUDszjKEqdsiemH/wC+usGcFhRbNv8brgFTWidzj9/CLdoskQcRu+fXmz831Y9KlVKBA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0268.namprd04.prod.outlook.com (2603:10b6:3:6d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.33; Wed, 24 Feb 2021 08:20:21 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 08:20:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCP2Y/e9Fs0BGVk+8HmhkjtrqFaplnxOQgADNhgCAAIxTEA==
Date:   Wed, 24 Feb 2021 08:20:20 +0000
Message-ID: <DM6PR04MB657573102C577230A3079DBBFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p6>
 <20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb@epcms2p6>
In-Reply-To: <20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb@epcms2p6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9939df9f-fe67-4e8f-25a2-08d8d89d06cc
x-ms-traffictypediagnostic: DM5PR04MB0268:
x-microsoft-antispam-prvs: <DM5PR04MB026813A3867FEE4EC898CFEBFC9F9@DM5PR04MB0268.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jAgpIvOfRyNOZNQ2uFV5NyVmOrplOoVefVzlvg4nxV8MXlSieB6RHa8LwjXaWTdLNfceUn2CS/pqEyLIjBsxmCQYPsAuTzPVpGbPh3/m0nl7kapZ4bQTEub5Pz8LyIGYWFPoMs/uXQ2AsFnbUcUPZdU8kvBoBq105j+AXxtfXJmzCNofSr4m1z3aZMn+Z2EMCOTTgTrxEcJWBM5vCaoDoiyL3dOhi5/ihowtHWkX/1DhLkB8cn1ciN/I96t6sDZiBAf3L9xmu/nuq1A09NdBbdfRYyxy6yZ1SiZGhPxmBsADnLm0IpwoNvIlQ7CGhDzH7Zbr2TSNyYRI1miVVBqYqojmDc/Yn+5uE/5P8Vw9/mEEuPGWCjbBHousQBF+q9PXCaUlP3djaS/r7GmY07oDcrwzbPX1K8DcUCc1iTN4FuISWrq4UN22/lE3t4vKCB+xMAn8L+eYnYSxqHZjlKwitxR9vkMfe0seHCxjMaBaE6iOvwvzBBoKlsMG0EluMaCby4HVV6LRdfoP9Xrg1KyzfcZBiOK6zscEG6Y6TUSreYt7rhOSUzAwp9+UBa58CZ3X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(2906002)(7416002)(4326008)(6506007)(33656002)(71200400001)(86362001)(4744005)(186003)(921005)(55016002)(8936002)(9686003)(5660300002)(26005)(316002)(478600001)(83380400001)(110136005)(66476007)(8676002)(76116006)(52536014)(7696005)(66446008)(54906003)(66946007)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YnhkM0kyL3BUb3NRVVlpMTVhR2U4Z2w2b0RLeEkxNElkY2NOOWhnY2FNVWdr?=
 =?utf-8?B?WTFHM2xnam9oVmdTV0tPRmlyOTBVQTJpdXAvR2daT1B3OTBZRzhQeUVyS20r?=
 =?utf-8?B?eUNROVZVaEd3aVdYYmhpRUVGeEFxREZyYjlScHdCd2U1ZU5mT0NkUXhiR0FV?=
 =?utf-8?B?VXFMR3VKcExzb1J1aVgyRmVmRURxbDVoM2hrektYTk1HK01rR2hDb2Z2U2lu?=
 =?utf-8?B?OVNrbk1zamJxMkcxeSsyZkRHejdlZUVockN1OTYwN2RKb0xOSFZPWXQ3bDlD?=
 =?utf-8?B?eHBickUwMms1OE9kWVE3RmxrcC96U3RUcDJ1dUIwc1ozOEpmaFllUFJyWHhK?=
 =?utf-8?B?S0xoTFJzLzhrV1g1V3RUajlXSjV4SkozT0hhT3d2Sk84dnB5enF1MC9BZ1Qz?=
 =?utf-8?B?azNDdFpzYnJFcmZDZ3A1N2RKTGVuU3ViQ1RlU0JoSC9DZzdJSUZIRCtwZm1o?=
 =?utf-8?B?VVV3TEhSQm9TSWFUNThVL05LWWVUMS9RRUcwMG9SU0FSOXVoc0U4MHZzdC9u?=
 =?utf-8?B?NERvNXlFSHZQNDhLU0NKcXlKODVLS2RncTBxTzRJaC9kSVZ4NlJuV29aZk9v?=
 =?utf-8?B?SVVIbXp1TlRKeW9JVkdrT284VXVxaHVHSEFvSEJTYkZFay80QzdTRE1EOEZo?=
 =?utf-8?B?TkpyVDkwSVhmRG5Bd1NyV2NYMUl2ZnQ3MndqaUlLdjZscDZiRkZENFRuM3Z2?=
 =?utf-8?B?MVk1NnZaSzVEVzJ1ZjBHdEFUV1NtZWhIRE9yZnhBd0wrTDBwdmNhZG5BSVV0?=
 =?utf-8?B?cUZzT2JRMEF6bXdhU2F5NWJoajF2YW1rTnJUSzBJUEZLeWUzUGFsMEQ3NUJm?=
 =?utf-8?B?N3hRMktaNzJqeFF6SkdldmlTY0lqQWFZODZTTmoyemFqSFdmZnZCTjUvNytu?=
 =?utf-8?B?d2JzMlNVcmxpSGliWVFsU2U4eHIwS0IvWkN3N1RlMHZzSDJmeHcxMW1qTWNB?=
 =?utf-8?B?a3l1b0lhY1YrcGFJNWNaenVqT2ZxdUI0Uk1YM2J4amNDZUlUa3owNktpZm5D?=
 =?utf-8?B?eDRVUjVFZnBjcmRnR1FDWWVmN1d4cG5oRkRZaVpheEJXWVV6YmIvV1Q5UVVr?=
 =?utf-8?B?Sm1Kd0NKOG85Y281dGk3RUZwV2twQXlwWGF0dWpJeXBhQXE2Z0p4a1hyRUZm?=
 =?utf-8?B?c21qY2pJQ01jTkRSaXNOYzJVK2FFOExkbWV2QTBpbHJ1aUNheXhkYjY1Rkhr?=
 =?utf-8?B?VGMxc3lDTytqTk5ZcnBpWUczOVRSQm5MNUNEbGt1YjZrSUNaUlloYWNuSkNV?=
 =?utf-8?B?cUE2Y3lydVhKVzZyUjcvZFdDYWlrcS8yVXp0SlhjN3hiQ2NzQUxrMXhXUnZK?=
 =?utf-8?B?Y0N3a25rVHZlU1RFblR5U1JxR3hZelYzbHJydXl5eC85RnRocEo2OE1Xclhu?=
 =?utf-8?B?ZnBjNVdqYzJKOHptN2VOUldzYkhiU3hPTlUyREo2TXpXL0llRjZiR1R6STJL?=
 =?utf-8?B?QUtpdWkyVEZ4UUtpRGFzcmFxSGhzR0dVTWFGR0QveWJNVlFLQ2VSL3pYdXJF?=
 =?utf-8?B?RXdRZUxKUlRSbVRGNFVQYWNZbnRzbG5IeXZCMXFram8wZDluUmQ1SS9PMnJB?=
 =?utf-8?B?K3VYaUg2eXBDeGVKWk5ZQmJUQ3JtRmVNeFY3SjhFZ3BSbnlpN3A2SVlYQm1x?=
 =?utf-8?B?anE2R1lvODZudDh6blMycW5FaXg5a1I2NjgrblJuZHJYOE5LRFdqVXJpd0cz?=
 =?utf-8?B?emFKaUppY2dYb1dJWmxVdUgxK2pIcmVXY29JRW8wZ0RGeHRNT0orbTFxSk43?=
 =?utf-8?Q?Z/DF+SCCWdzoNK7fSEgY3GY8jrtBzgxHRDHkF0A?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9939df9f-fe67-4e8f-25a2-08d8d89d06cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 08:20:20.7735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Pt6rGXnr43BJ2MLfevzTgiYOxbQS2Rt0SuxHr8j31Rw8loG09KCFtsjZ7pErqyJXQotg1igkqCXoXJu1x/FWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0268
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gPiA+IEBAIC0yNjU2LDcgKzI2NTYsMTIgQEAgc3RhdGljIGludCB1ZnNoY2RfcXVldWVj
b21tYW5kKHN0cnVjdA0KPiBTY3NpX0hvc3QNCj4gPiA+ICpob3N0LCBzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQpDQo+ID4gPg0KPiA+ID4gICAgICAgICBscmJwLT5yZXFfYWJvcnRfc2tpcCA9IGZhbHNl
Ow0KPiA+ID4NCj4gPiA+IC0gICAgICAgdWZzaHBiX3ByZXAoaGJhLCBscmJwKTsNCj4gPiA+ICsg
ICAgICAgZXJyID0gdWZzaHBiX3ByZXAoaGJhLCBscmJwKTsNCj4gPiA+ICsgICAgICAgaWYgKGVy
ciA9PSAtRUFHQUlOKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgbHJicC0+Y21kID0gTlVMTDsN
Cj4gPiA+ICsgICAgICAgICAgICAgICB1ZnNoY2RfcmVsZWFzZShoYmEpOw0KPiA+ID4gKyAgICAg
ICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ID4gKyAgICAgICB9DQo+ID4gRGlkIEkgbWlzcy1yZWFk
IGl0LCBvciBhcmUgeW91IGJhaWxpbmcgb3V0IG9mIHdiIGZhaWxlZCBlLmcuIGJlY2F1c2Ugbm8g
dGFnIGlzDQo+IGF2YWlsYWJsZT8NCj4gPiBXaHkgbm90IGNvbnRpbnVlIHdpdGggcmVhZDEwPw0K
PiANCj4gV2UgdHJ5IHRvIHNlbmRpbmcgSFBCIHJlYWQgc2V2ZXJhbCB0aW1lcyB3aXRoaW4gdGhl
IHJlcXVldWVfdGltZW91dF9tcy4NCj4gQmVjYXVzZSBpdCBzdHJhdGVneSBoYXMgbW9yZSBiZW5l
Zml0IGZvciBvdmVyYWxsIHBlcmZvcm1hbmNlIGluIHRoaXMNCj4gc2l0dWF0aW9uIHRoYXQgbWFu
eSByZXF1ZXN0cyBhcmUgcXVldWVpbmcuDQpUaGlzIGV4dHJhIGxvZ2ljLCBJTU8sIHNob3VsZCBi
ZSBvcHRpb25hbC4gIERlZmF1bHQgbm9uZS4NCkFuZCB5ZXMsIGluIHRoaXMgY2FzZSByZXF1ZXVl
X3RpbWVvdXQgc2hvdWxkIGJlIGEgcGFyYW1ldGVyIGZvciBlYWNoIE9FTSB0byBzY2FsZS4NCg==
