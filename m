Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9879C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 07:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D6B610A1
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 07:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhDSHTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 03:19:43 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32475 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhDSHTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 03:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618816753; x=1650352753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o6DWU5eKgrnlAd8f81s9krHb/u+G28bfEtuf9xiKA3M=;
  b=SoDomZ3bGKIfcQIeG+jFiPJnNhTPXPFOokPT8L7CKjZcyVbB4rPbZ7D+
   PH/gRk7H2P/eptYohtFFsr5cv6icRfhiuVgTBQpV90ZAKwk6uaFqlKwcZ
   flfbXopX96XYzmll1xGw7jjVSScDbToJ6/0qzO0RzGXK4HKynXjGZx6Oh
   CrRbaFbB+1F3dp5CJAQiZxhj1kEmyNVfgD/iFqQVkaKtE8OVvhApXO5BM
   /F2t+5x0pb1PvG247obUmNsNJ4Tl/pL0hjjy0jscCC/UM49t5NsTPYo8H
   fVcEDLS8DZ7SDAGi+LNgq7+CjomN+g7R3slr4m0bzkTRPY2uuc7JKs/TE
   w==;
IronPort-SDR: TdLNTnTOnzDRMbK/irlZ9FqqoR9NqngbpBtw+AKxar0ejpny4q2nVRogQFSzBQ4hZiW2lDKSN0
 lkzo1JCM49bGWkzX54VVLzZPhuboRgfyIgdD2cIvDtkU7ZxGNsmoyJrfucn9KxrlP65hqBI2l9
 RGq3Lr7N2eTIbAUBXncU100kjJSTt911P48uDD6Ave5DCLXM+xuMEvQrogd7PlPHQ5/DzBZJYq
 JVgXHwDc/j1O6SjpaPHXjBQVhtfVDGMYpFjPoLSXuqlvU9Pn/9n+k3CuBGO7hIcO28y7kU4OJ0
 t2c=
X-IronPort-AV: E=Sophos;i="5.82,233,1613404800"; 
   d="scan'208";a="165420345"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2021 15:19:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOVxZ4sLlnOxwq4FJS9SlSyD+7v1u/k3kAgMC+wjUp2UGktFRboNtK+UknOdS/t1aw1As93sB+1bYnoSWunTaNna3fdex3dzHo8S3p6boPHOF5h8WwMyu2fDAPYG3bIpe/hwGRRhGDgOMNds+Aw4tlKLYqSreD0U8KWmNo5/M7EXvYqlCQslbiMnPlfttlssRYT3YH9Y3pvl95lv0Kikff12PDDCmtX+Lx+O4oRLZe/LCCZ+3UVeA7u825/SxdZz/56rduOM2vUWzH+CoBM43kY/nKCXRNtQXadrjE6dEtXfDz+FjoXXS0njcgb+UzY8OYs69xz9FIX2b9ATdL/DLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6DWU5eKgrnlAd8f81s9krHb/u+G28bfEtuf9xiKA3M=;
 b=DTIu3w3dbRbKoBrIFa1fdfFVdDQm0BqZxI6BXUPnVxxdBJM24k/BhAmOJzYPUwMbiaHDEOHCoAzDQmTS8ZkZIjWJKnSCG0ZjeSQ0AiXikywQufKubyzfH4+ysmF9vIaj6nXsL6bF6dDFGTDQAbTlVZ+AJCFSpGEbo1LB90FFEC7KqeCI1gRW4GX4V1fcnnf8UCgp632bnbrjpp0p37vY/av80vCSzl1XebkbPFsX0HDDXJvNHIdKux3SuqiXrX82hEh47AaqzxnYrACROyq+5OHzPb9tI7fVQv7lD60e7bk8k5PTPA3Bwr9+sh62o+sMDSlgCEe0kT5v0a06Gnm1jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6DWU5eKgrnlAd8f81s9krHb/u+G28bfEtuf9xiKA3M=;
 b=Rraa7jhgL/3NLvwai3ef07wyOGBxo11g2iUpqMqn/1wk0M9JkU8nHB6aIDKNZVG9aFEx0mMr9HTIpoZlaaiYa5OOdnn73OWQ+U6l5qiIOOyt/+igXL5aFICcM65NkEPX+KZsSbeLwSKpoAqSyvoX+oP+0wZFVkxVp5wBCKioqAg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB3899.namprd04.prod.outlook.com (2603:10b6:5:b9::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.20; Mon, 19 Apr 2021 07:19:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 07:19:10 +0000
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
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: RE: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXJcvTbopFT3JB9EekzkyulUARjqq7iaDw
Date:   Mon, 19 Apr 2021 07:19:10 +0000
Message-ID: <DM6PR04MB65759A0DFBA1BCFAE97FB134FC499@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p4>
 <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
In-Reply-To: <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84b638f8-0e0e-4a9d-f351-08d903036d41
x-ms-traffictypediagnostic: DM6PR04MB3899:
x-microsoft-antispam-prvs: <DM6PR04MB38995FD0787541383B46163CFC499@DM6PR04MB3899.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ckmLxjp1GSMbpJiZctS8WZbNJF0q+g16pAKvNis6WqJKou4K4SHrzcB6gOgp9PbjpaMr9i6AGARmAroWNWFCWyOUbYZioqaSFNJWVbBhROD/29AIrBfc3LdpzhyX1+zPnXWr7VNLQ4xtdM3Tmz7JuGJ0SaIwmgpE+1+SQ27iBBOcXpNPmIZWgjqkNg7cAkSMMqnTLLpn8h6LoUjsow1vP72WoX7Y8rhd9VS/khehwAxiLNnzdHKTHAEZZQtBLVPphlEg3jBmxAzV46COzhepzHeoTG4bAwABrrpOl+FUsckt0xP5+p/T5QS3aDsmHwrofHwbDna/pJdRr00sQye5nW8aIOaJb54QBcOQ5mPHMNOcCt6aupIwSGxfInjLy3/7TaiV6sC07RAElSiwzn3Tfe40igF0bWiuaD4dt7EsaT+zxyLCJtCX4z7/QljGvUWl9o97dfmJ4vvmd8NDmhV26RbDcZyjTDX8FeuR1U6ugsnxjx/Z832Gfkf2NqEj/5I6PsyN9ENKnWwrLWYT9ZG/Xis8GVhdyrdJEoNh50MRoCZtt4yDeho6W1jkjSpOqSRNrU9WeqnuFapmnbErGogXW3y4mmO4/JpYltMG0Giq0b96AV4UrCdCZZXq6ERVLbNvHfWuvj3GK3rs7Y1lc+loDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(6506007)(38100700002)(921005)(71200400001)(86362001)(122000001)(2906002)(9686003)(66946007)(8936002)(66556008)(7416002)(66476007)(4744005)(4326008)(54906003)(7696005)(5660300002)(76116006)(110136005)(66446008)(55016002)(52536014)(64756008)(33656002)(8676002)(316002)(26005)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dkFIdE04OUJHU21CTlRWYlJveTFWT041RCs2VWZ6QnRMaXZCdzIxVHpPamJu?=
 =?utf-8?B?aWdWNmtwY2YxSmwrNm81MVV6eElqNGF5Vnl3M3liYnNKdERORC9GWTVacjJQ?=
 =?utf-8?B?bTEvUTl3OTBsVG9BRWE1UHdWUVQ0Z0FHbHU1T2dLY3gxb0d3VkNQQnl6VVA4?=
 =?utf-8?B?N2syRnRYenQxVzhDYXNzS09iM0JpNTIxM3FVR1cvbEtlS3RBMjBBZjJ5Mktt?=
 =?utf-8?B?Y09RbEJKL0xEQnRPWDJ1dk52bVJiWmZFTHhOZkoyK0o5NW9mNy9zTkZMNnZB?=
 =?utf-8?B?THloNFVVbktWRFdSZTN2aUNncUtYajVrMGgwZG9mSEs2TFQ2Y3Y4aTEzdlNt?=
 =?utf-8?B?T3VtT3lKNGZ1amhmcnJCQi9ZZ25KYVdybUpBZzlFaGJFc0V3Ukp1ZTlpVW5j?=
 =?utf-8?B?ZGVoY1ZsbzZJWXJycmtrRHBneXpFbS9Rd1BKdGV3K09WWDZCdGhCeTc3MEdm?=
 =?utf-8?B?Z1dQNzZkWGQrOHhESGpQRCtTK1ZsSHRhek5QUVpDUkNwZThRVGFXMHl5SGFq?=
 =?utf-8?B?a2tCbkVZQ3JYY3ZNQzdCSXl6SE9pWkYyck1ncUZjTXZPbVV1THlzL29iUTZj?=
 =?utf-8?B?QkZQOGhMV0hQOVhYQytZUm95cVdmR1NTdy9sZ01TLzZNYWErTjJBZTdhUVh3?=
 =?utf-8?B?bHFyQWlUcTkrdzBISkhFM0ZEZXYvelFhMXZkUUNPcUVZZTl3R29UajNFUjFX?=
 =?utf-8?B?UGMwNzA3ZUlhQS9NMG1sSzMvNlRzc1pOemVDNDBqMnd6RjloajMwbk14YXZ1?=
 =?utf-8?B?dXJTM3J2NTdxNmFZU3dEUDVMRzgyT0t6Q2hqMFRSWEM4U1V5UU9Gb1Y0VDRE?=
 =?utf-8?B?ZTZIT2dyRjRwVU1rWklMQmk5VnF2TjBMY1dmV3MrdXkyNXdKdFM1WWpVRXJm?=
 =?utf-8?B?V1I5bUx3Vnd1SWRtR2c5Rlo4Qm5NcWYyNC9sSmdXblUxTGFuU01DNWFyL3hD?=
 =?utf-8?B?OFlUUTZMV0hVbEdUSnFTQUxHQWJzVnVWL1RIdG96OWtHK1hndVRoQ2g4MmNO?=
 =?utf-8?B?MFJUNXo4TkNBWkF3MWRydVVsMWZxeWZLVFBzUVAxdE5leG11VSs4RHUrTStT?=
 =?utf-8?B?K252Z1ZXbjFRbnNyS3BqaVh6SlNBdk1QSXhhTy9kZjlWS0dlZUROSytKYTd5?=
 =?utf-8?B?WU9LOVRpSVRWNXI4dVpNZ01maU1qUnVTYm9RRVNuQ0dBTHlldU83bUlMYmd2?=
 =?utf-8?B?Y211dnVNMkNYMnpqRmJVS2ZOMjRKV2xaM3lsTGQwUUFSWmg4SnJCS2ZDSGxH?=
 =?utf-8?B?U2hxQTJCUDJpcHVxbFJqRkFZV0JNamkya3FzL3N3NDJBdUU3cEtkdWpUekdo?=
 =?utf-8?B?V2N3NWwrcEp2akRNSFVHdks2bHBHWkdrV3JZaFZ3WkROR1liVm5Mcm9SNERx?=
 =?utf-8?B?RHB5NEtLNWRGNm13c2FhUUNhT3FCbmxYSE9scFlkMitDd3UwRmNBQ1RMbTh1?=
 =?utf-8?B?YU9rZG5EcXZrMFc3SmlkSkhWUS80OWRwL2dzYVcwbndhOHhML0RYZktzelI5?=
 =?utf-8?B?V3Jla3NCcngvcy9LL1lUSUZObjdTVkx4Tm0zaG9CNHR2VzZGQ2Q5L0RwK2Fw?=
 =?utf-8?B?MitWemppYVZkRytwaWZMOGVPclN5KzhiWDg1UFkzRDR0TkpVNlhRd2M2Z2hG?=
 =?utf-8?B?Z3RUaGRIaFZOVFZONmk0ZGN3eXd2QTBXdjdTUmtrUXZSK2FoWkZ0Z25LZHpK?=
 =?utf-8?B?Yyt0dld3Mmw2NGYwOE1KbkZUYVlNYnVDd3huMlV6WG5QSDdXYlZjSFBEV09m?=
 =?utf-8?Q?mZEC5nt7ZutlfKcEHelW1qmvC6d0JOr7ScgmU3P?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b638f8-0e0e-4a9d-f351-08d903036d41
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 07:19:10.1026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1dDmS//I5fHXj3MV3GBD7IJ42ESpkzrBCRbrhr1290u2bMFHs/BnbBDU8Pw/ty0U2q34M0VEvTJqJ5vbtEa3TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3899
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQo+ICAgICAgICAgaWYgKGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPj0gVUZTX0RFVl9IUEJf
U1VQUE9SVF9WRVJTSU9OICYmDQo+ICAgICAgICAgICAgIChiX3Vmc19mZWF0dXJlX3N1cCAmIFVG
U19ERVZfSFBCX1NVUFBPUlQpKSB7DQo+IC0gICAgICAgICAgICAgICBkZXZfaW5mby0+aHBiX2Vu
YWJsZWQgPSB0cnVlOw0KPiArICAgICAgICAgICAgICAgYm9vbCBocGJfZW4gPSBmYWxzZTsNCj4g
Kw0KPiAgICAgICAgICAgICAgICAgdWZzaHBiX2dldF9kZXZfaW5mbyhoYmEsIGRlc2NfYnVmKTsN
Cj4gKw0KPiArICAgICAgICAgICAgICAgaWYgKCF1ZnNocGJfaXNfbGVnYWN5KGhiYSkpDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGVyciA9IHVmc2hjZF9xdWVyeV9mbGFnX3JldHJ5KGhiYSwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
VVBJVV9RVUVSWV9PUENPREVfUkVBRF9GTEFHLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9GTEFHX0lETl9IUEJfRU4sIDAsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZo
cGJfZW4pOw0KPiArDQo+ICsgICAgICAgICAgICAgICBpZiAodWZzaHBiX2lzX2xlZ2FjeShoYmEp
IHx8ICghZXJyICYmIGhwYl9lbikpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9pbmZv
LT5ocGJfZW5hYmxlZCA9IHRydWU7DQo+ICAgICAgICAgfQ0KSSB0aGluayB0aGVyZSBpcyBhIGNv
bmZ1c2lvbiBjb25jZXJuaW5nIGZIUEJFbiBmbGFnLg0KVGhlIHNwZWMgc2F5OiAiSWYgaG9zdCB3
YW50cyB0byBlbmFibGUgSFBCLCBob3N0IHNldCB0aGUgZkhQQkVuIGZsYWcgYXMg4oCYMeKAmS4i
DQpBbmQgaXRzIGRlZmF1bHQgdmFsdWUgaXMgJzAnLg0KU28gdXBvbiBzdWNjZXNzZnVsIGluaXQs
IHdlIHNob3VsZCBzZXQgdGhpcyBmbGFnIGFuZCBub3QgcmVhZCBpdC4NCg0KSSB3b3VsZG4ndCBy
dXNoIHRvIGZpeCBpdCBob3dldmVyLCBiZWZvcmUgd2Ugc2VlIHdoYXQgTWFydGluL0dyZWcgYXJl
IHBsYW5uaW5nIGZvciB0aGlzIGZlYXR1cmUuDQpUaGFua3MsDQpBdnJpDQo=
