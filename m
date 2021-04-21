Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53505C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 14:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173246144D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 14:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhDUOO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:14:28 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10904 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbhDUOOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 10:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1619014413; x=1650550413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YSxXLof4TocIDmRzbaVqMThOyH3T+i+L/2I8YBDYzmk=;
  b=jHHpVh3WCx57gVVlbv9UJ2XfvHhrOvlfppAgaQBCE4pUT8xNalwQco2t
   tUx0KI/60JsnBBaWlpKu0semDQCD4V1TLaqs/psFfbJnKqgxm6rK/NM7O
   WrASi0Z7aktyvxXJw+rtgrLu8Z+bFxW0GtmNE212sPuYwfYcwIkFSyEEr
   3LLKURxchImK/B4Yc6DmtMawGfB7jEg7SaPYTmuR3Cg5XCu15HAl0so0U
   Y1tsZoUXx2lkuffqtw9petkPJH2gvbczklMuOLhhA0o/RCELaWOUXU+d8
   Lp96GDlwXTx6FD01ko5+9+NXVZLNztIGzbgxqGRHcaCC/1X3JT4I5Kbrk
   w==;
IronPort-SDR: ooDpLpJz+3TWmuNjIPky6RpzVKpo8Q6hUZjBzx3ejPIiEnHeedsTrfuGq3XiXMulGP2EIMX/ko
 FtNdGpYxXg4/Co1V3n0pmYJoV+X4snbWpqPkMNPtzmoNPicF2GgMBc2uuOrDUQ33coLkZ1Wz9F
 JUiS+M4EybHkkwfDBvYroTmhqVv94XgC+4y1SpZccfS9o5PdNDf/3KwnPrag7QVEtPCFV4AQJm
 7wYZOpMrM//4jutiLWlmKe/pe/TqnimJBqowG3pmRvwiH63AQlr85z3me3sOcZnRY+HbolcxNI
 2GM=
X-IronPort-AV: E=Sophos;i="5.82,240,1613404800"; 
   d="scan'208";a="165701983"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2021 22:13:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egkKKNAlAKdyBeC++PsDNeESvVBbYfynGqJFyj56t6iFUx7lhvyHGavq1CIEJjf1pz3q9CB8QTmJNdyK5h3f3lfbRouM3g4EEWQwWdoFwxSzFggx0EF7S9FGxUklCH2sL/y7aixUkdHd13h25J2aSNsMQYFxKilzFnYQOlZyck6gZ1m9cwi6Wvk5v1k6oBMKiiCdRtcnM4hRiWEltGb/ASoXWztw/Fz66AWZeSqr8dQ/XB64z4FT8kOGmTKom+v/4Or52eAPDmCqcMyqjnzRLub/4FuNbTk4kSM4reyXctMgUNrHzPv/fhrS4mk4td31qEH0FUJZ4F26MuL6MbY4jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSxXLof4TocIDmRzbaVqMThOyH3T+i+L/2I8YBDYzmk=;
 b=KHWSp9f9fVwGRS778IGmBGfhHqPHPWWElSqiAGwtEEb03UQgbwciQXpWxsoMjJGz96ssaP5hQ8pWAt6qhnP0ikaLlI/7gXpu7nde+lm6GSIEvy2GfZx72C/T9XT/NeUbCaIBFBm64HEH6QO0PpZtmxhuxVDkR6JVc7LI28ZvlJGDUIQM9wy42HuIy5Z9W+HmvtwxeoyIFWDGGN7kxxdPvhBdSR5iULffcw9ifggcqrlGX4PIDKmzYNQzML1IjgtZcyO7JhocauwPXEdvlvkx/xfiSX9DrZG4Piom647dyMjbSXJ5a8Ljs8dgUEMd3sS/54zHKz/VvzARgbsVM4v2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSxXLof4TocIDmRzbaVqMThOyH3T+i+L/2I8YBDYzmk=;
 b=ulLPClOjQWB0WZ/tuV9185LEle1kMsuMW1UUHHcAhSrA5vjQt3z+BnwQiqsw/HKayQXsNxAZGU1V3d3w9eZOeWaZOF0PBBMHf1i3YaHDMnOewq6zOx3b/xhC+99WSite7jPl2FprRgKiQrccd6axlNsY7pYZCY6emBnGw3a63FQ=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by MN2PR04MB7134.namprd04.prod.outlook.com (2603:10b6:208:1e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 14:13:31 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a%5]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 14:13:31 +0000
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
Thread-Index: AQHXJcvTbopFT3JB9EekzkyulUARjqq/H3Pw
Date:   Wed, 21 Apr 2021 14:13:31 +0000
Message-ID: <BL0PR04MB6564B4E309188E320AB258E6FC479@BL0PR04MB6564.namprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 458d6a1e-1e38-41c0-61c0-08d904cfa494
x-ms-traffictypediagnostic: MN2PR04MB7134:
x-microsoft-antispam-prvs: <MN2PR04MB71343050C1A5BBDC0648A247FC479@MN2PR04MB7134.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VqHsJVwe79RWgHOl2ToTPsesyaaZ7WIAGryBXBMQCrStr1O+RaGH/XHpty8b5PKEJmFcnxWWv1cqNprz2gke/uQGbiLNT2EptAmDyFd9R5hr/cAsnVZNzAXll3zwoYCrJENPYV9kE4+O471aJVpP8U92/6WmURKGTcgQe/v3+iGiyxnOn+vE1ze40FPQoxkwrkvvHlj1b61WNwiRSQ3OdArotxnqg2cH+NRr30Ft8TJYq1Fcolth7ru50LWGylU0IcW4LQ+TSac+L6bVr5lIcQstG/g6cQHQUf6P5lBQq03lr6/1q+l+4+CwmPiAxxm9bQTPQtYa1W40oUoNgnGMbdPxZnsRBtyvS8StUseqh9X/aoce5mXUMcVncNCCvT4764RHAntqZmZMio5QTTXvluaovko59G3gVfnAuQlGnOXgFMAOmH4oTEDiEw7TB+b4M+SaJfrAeIwKE8kWfpR+XsiU8bBD579jJNHGtfS6W7BCMj5eWtI/97aZ7bsEnQVc5tuclqvXZUA1qBpzirIq4jFKrEEugBz4YI2b98wskOSjAAbZjJReX1THUMLFrdROQECRm+aAMvBpr92BDKwqqBnO8FgMGovQ2UuvztkJYPxb9yFwnDJ5z7TyTcF7yYypw0jYE0HL1UWn6oKgqQOLEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(7416002)(4744005)(4326008)(478600001)(52536014)(66446008)(66556008)(76116006)(64756008)(66946007)(5660300002)(66476007)(86362001)(122000001)(2906002)(55016002)(9686003)(38100700002)(71200400001)(26005)(186003)(8676002)(33656002)(921005)(8936002)(54906003)(7696005)(6506007)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UWllVk42MEVNNkJxblRWbzdyZ0ZSWkFaZXQxem03M0ZHdzFDTDNGNkJRT0Qw?=
 =?utf-8?B?dXBJV3V6WmVuTXdZb1F3WnYrcmtScjBTL2hIankyUXR2MWJyNzc1bGEzdFNG?=
 =?utf-8?B?RzNPekF4cUl6NHhxMHNiM3RsS25sSzRFY0JwZjcrSTFJTVk0YmpFL2x1Z3R4?=
 =?utf-8?B?d1hnRCtNQjRDQTFnN0ZBNmE5M0JmVk84NmRkdlhpUHFWRCt2NDJzSCs1YnE0?=
 =?utf-8?B?eGc5N2xDendEZXB2ZnBnaFlPaXpXQUlpOHJLRTZxNGtQcmNGVHdYMlpkcmg1?=
 =?utf-8?B?VzhsR0ZFY25rWFNoekJLeFI1cjR0ZTZIU2ovMVdzZ0pKSitVNlcwS2FEMFY2?=
 =?utf-8?B?eVVSNnZyeWZENzBVdW0yaEo3Rm1odlp4MHJHSms2dzlGMTJhUDhDZ1orSzZl?=
 =?utf-8?B?L2JMSjZoZDlDUER1RUNvMXRacnBkSzkyVnNOSkFnRUY3M3l2NnBmSnVmV1dL?=
 =?utf-8?B?WVVzc2o2Mnpkdm40S3lvSnlxa0pwZXdENjBiV3VrVWJkdlNCd2lBVmllOERW?=
 =?utf-8?B?bTVLWG1LbFRKQkRXNWgvOWZsU2dsVFhpdGZDY21HVUwvWDhPMTlSTU13TENv?=
 =?utf-8?B?a2kxcE9obTREeVVoM3JLOFRuTDRMeXdWbExmZXdlL2ZGbW1FaGM4OElRdjBj?=
 =?utf-8?B?YzBWR2RLTTE0dUhZZ0ZpazZJL2puL0pkRHFhODYwcUtLYUNqRi9pdXpqanRJ?=
 =?utf-8?B?Qmw2SXVjaGFIYjBqckpBaGQ3UDRKNm5NdzV0d2R0MzJNa2IydW5OWXNySURw?=
 =?utf-8?B?ZFlWNkVEMEx3Mlg1aFh1U0NvaE04ZGNsd2NCM1ZpTER5dUpiRWhDaTZ4Yiti?=
 =?utf-8?B?U2UzWGRwa0pQbmdGL2hHQkVVWTVTVXc1ZGNVdUpKTVFVajIxUCtmSWcxUXk3?=
 =?utf-8?B?SndsNlFGTmNTQW9mcUJJVVNxZDdZY0lTNTlBMnlJeEVzVUk3bkwrazF3OFMv?=
 =?utf-8?B?bWlaTVhPam5LN2x5eTRMZi9pczFLQVh0K0NrWFFTRGpIQXFHNUhoVmJma2NK?=
 =?utf-8?B?VWI2RnVjUUdkR1hZVWl5ZG1DY0dYbTJHN3RBVGV2MGpXMTQyV2JxbmNNM0xr?=
 =?utf-8?B?Y3ZYZ3E1NXRRb3VOK3ZQSjNib1FONEhZam45UEpkRnFWRWpWcUFNdzBraSsr?=
 =?utf-8?B?SU9mM3U4czF3aHcwZEJsWXllRm51OTBkbzJGRlB3NFM0cGpuWU4wVzREdTlx?=
 =?utf-8?B?S2lXdzd5c2UzdTkvcDVtZmpyRExWNEpTc29xQzFUS2cwemZUZ1JtQnFlcXNJ?=
 =?utf-8?B?eG5jcmloekFmTTNHRU1zVmxrNVdPU3BJbTlHYjU1S1dyZEE1cXllL1hXcmhW?=
 =?utf-8?B?YlBjMjlJN0R5VFY3OFkvR1U0VzZMekd4Y1l2d3cwWTdKZnNjNGRVS2RuVExW?=
 =?utf-8?B?REh1SFBqVXpQTHd3Q252QkpiWnczdmJLYTVZQzhBMkt1YVlSZ0RIY3p6endq?=
 =?utf-8?B?NWJ1WHpKYmFSVCtOL2NFTkhnSEdBYytkWHVwVjBMRUZ0RzEzUWhUMDNSQU9E?=
 =?utf-8?B?em1hUDdmWHAzcTBBVkV4SFYwMnBQYmpuUksyckdXV3BTckRLV21kVFVZOWhz?=
 =?utf-8?B?OVFSOEs5Uzc4VjlpbTZxWTBwMjVoOGFGdHpYTitlSkRjamkxS2h4dUtWcGNX?=
 =?utf-8?B?Z1gxeTBPRjk3MEcvMW9tYndFbW9VajZIbWtyVzZLMk1TWm9DbEdxZVhrMUR2?=
 =?utf-8?B?WTE0VWJ4djhwMFFMcTUxSDFsUURteGFiUFI4YmEvOWJrMFpFYUM5M2s3djgz?=
 =?utf-8?Q?RTw4xXOUBmkWxuh/ZhxO0rSweJfTbIZdfPYFtTc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458d6a1e-1e38-41c0-61c0-08d904cfa494
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 14:13:31.3733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XLldt+DpTO0yDM+lNkAkm7ADYfO9fEwLlXdzzsUg1W47pf6LpP99oF88XoUrSWKhCaAP5r3yqVJG/BHobxQ1Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBAQCAtMTY1Myw2ICsyMTQ4LDcgQEAgdm9pZCB1ZnNocGJfZGVzdHJveV9sdShzdHJ1Y3QgdWZz
X2hiYSAqaGJhLCBzdHJ1Y3QNCj4gc2NzaV9kZXZpY2UgKnNkZXYpDQo+IA0KPiAgICAgICAgIHVm
c2hwYl9jYW5jZWxfam9icyhocGIpOw0KPiANCj4gKyAgICAgICB1ZnNocGJfcHJlX3JlcV9tZW1w
b29sX2Rlc3Ryb3koaHBiKTsNCj4gICAgICAgICB1ZnNocGJfZGVzdHJveV9yZWdpb25fdGJsKGhw
Yik7DQo+IA0KPiAgICAgICAgIGttZW1fY2FjaGVfZGVzdHJveShocGItPm1hcF9yZXFfY2FjaGUp
Ow0KPiBAQCAtMTY5Miw2ICsyMTg4LDcgQEAgc3RhdGljIHZvaWQgdWZzaHBiX2hwYl9sdV9wcmVw
YXJlZChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICB1
ZnNocGJfc2V0X3N0YXRlKGhwYiwgSFBCX1BSRVNFTlQpOw0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICBpZiAoKGhwYi0+bHVfcGlubmVkX2VuZCAtIGhwYi0+bHVfcGlubmVkX3N0YXJ0KSA+IDAp
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcXVldWVfd29yayh1ZnNocGJfd3Es
ICZocGItPm1hcF93b3JrKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgdWZzaHBiX2lzc3Vl
X3VtYXBfYWxsX3JlcShocGIpOw0KPiAgICAgICAgICAgICAgICAgfSBlbHNlIHsNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgImRlc3Ryb3kgSFBCIGx1ICVkXG4i
LCBocGItPmx1bik7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHVmc2hwYl9kZXN0cm95X2x1
KGhiYSwgc2Rldik7DQpIZXJlIGluIGx1X3ByZXBhcmUsIHVmc2hwYl9yZW1vdmUgY2FuIGJlIGNh
bGxlZCB3aXRob3V0IGRlc3Ryb3lfbHUsDQphbmQgd2hpbGUgdGhlcmUgYXJlIGpvYnMgcnVubmlu
Zy4NCkhvdyBhYm91dCBjYWxsaW5nIGRlc3Ryb3lfbHUgYXMgcGFydCBvZiB1ZnNocGJfcmVtb3Zl
Pw0KQ2FsbGluZyBpdCBhZ2FpbiB3aGVuIF9fc2NzaV9yZW1vdmVfZGV2aWNlLCBob3N0ZGF0YSBp
cyBhbHJlYWR5IG51bGwgc28gaXQgd29uJ3QgbWF0dGVyLg0KDQpBZ2Fpbiwgb25seSBhZnRlciB3
ZSBrbm93IHdoZXJlIGFsbCB0aGlzIGlzIGdvaW5nIHRvLg0KDQpUaGFua3MsDQpBdnJpDQo=
