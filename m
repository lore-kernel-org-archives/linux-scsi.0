Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13D2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973C064E6B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhBWJJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 04:09:12 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3314 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbhBWJIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 04:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614071311; x=1645607311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eQnQk6DorHyH+MHEFkkv0GRYPc0oh2/GtOpH627q+wc=;
  b=Z8GuY8IsTtXkgsajrv9uYUHtkaXQ7muTd0Zjqnr4Xqsz30PKNSQZAabw
   fgJjZLxI2F20WufYovrqDRtFFUcshLet+uz+GA+jBqYVbJoUlAaJYEsYc
   ziZv8Jw72tEeJsNfBzkf91nu5ggsYgg0uEXYR2Bkk9PDl4S8EOQfkppOC
   lrHWoxOCP966KZNgSztbLP9c47/v0kqxXgynqRddKPla3vxwzG0f+iI7x
   gyP8bSWwCWwl1VvBOy981I1rmFhOfEiWUWkQeM7+C23XCl6dc2jiLHGY0
   tSSsV++Thf6Xas+QktwAxdv/SgZw6LbJUcPXkbeea6NG2J94DihF7vEVq
   w==;
IronPort-SDR: vtsMYIo3uxZUxqXdAqxfX//3SoF2pGhcXoEkgSDiStbTsyEWhR8j50WDRXZKu5YJeROq5fnZtF
 DWigBoc37lqH0u8LphASK1H7lLJ5UEFWCD/7BJh4MwLbEFjUH0Ath3TZGG855iPnwWHE90mdBe
 o83FFITwnqksoBpyRsX6y77Vwxlerp5gH/7IBwRCP6peK+2v6d7Wu2NgU4F5VEGlrEXvnIlWEo
 zYeKsipONQ7WmVaB1KPsKniB2KetAYxOT/0YIhMS+TJSixmcT7vTWYAfugT/yd90Ghwyk9AOAE
 KJo=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="165059597"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 17:07:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zsmx60iSAXi/6wW7TQK/yE9fP7u2aAIVH2BtwKbZkuMD5ykJ1lRDKJf0VLUkRxC0PJaXQo0+iE+E0/288j0XJB/TXP8/E+8tM4Q4YqHXkUXpj6YyhORX5tvuQ/helVOb2yEsX99MgDTNR5dJFN572pdcYvYlAf9S6fLeYKXRjjGfGYAEparwliypnuEoLN7OqRp6rYoqBTe7KoWd1zmX0LZxYIrJ/B9y229acHn06Xlts/x0Uf89hwQ/gqwk9Ir3FygPqRyMHuF+bAACKbuWRBdBKay6HRAN+VhLDNkDOUVwCkc2/N/5Uzp2GZrTn4XvNoW+3k30gWMeRVhFBuzOew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQnQk6DorHyH+MHEFkkv0GRYPc0oh2/GtOpH627q+wc=;
 b=b0mvJlOafSjVtVAidlWV9iDH58uHomXEaj2vwI/puJHx07A/ONR3PTt8Mykc+CJ2YmM9mgVxWdGKZo1nLF4XkmSl9RzNlGmudKXwOEUixp/GpwZYkwRg7JykixSnglhXmCJMISL9DI5gWsl84m1p16HqOaxOxw3a0RjaCBV/6ZoHfCrSyB3Ff2ag3PPYNzTivGoRsIQA7oXrPAwiVSqhJu9KzYK37G2gApEohLKba2vTym+CXM0sUEdEk+8OjpOZ+vi/drFD1runCH69QpCJ13Bi8WRHEtaEU7PayMZVSJNqFraX7eXVEsCsxSOGdpiMIXw/BGAF/0TAQBE+xAvlew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQnQk6DorHyH+MHEFkkv0GRYPc0oh2/GtOpH627q+wc=;
 b=pfAB7lZFYfV3u7aJoAidt65yyP1o03oTUSOgN4xYFxV9vhzXlLT404pZtFF6oTdnC+OssyjG5QgektLop8nhgjShVyNOTM8MbSQqanbNAH8kEn7PdVFA3H/cTokQewwu8c0QlMYnonFXBloXzyOM8gMeOrrED7hseQKmG5P7ot8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4028.namprd04.prod.outlook.com (2603:10b6:5:b6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.33; Tue, 23 Feb 2021 09:07:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 09:07:22 +0000
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
Subject: RE: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Topic: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHXCP2AswDeSMp180uO0U3nTEujWqplaNAQgAAFHYCAAAZ8sA==
Date:   Tue, 23 Feb 2021 09:07:22 +0000
Message-ID: <DM6PR04MB6575F87694FB14ECF068F681FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <DM6PR04MB65754012DD7AC9EEF9D47D0FFC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p5>
 <20210223084327epcms2p5b158fa6769d3deee54796b364f0ae369@epcms2p5>
In-Reply-To: <20210223084327epcms2p5b158fa6769d3deee54796b364f0ae369@epcms2p5>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5889a4e4-b3a1-4699-17cc-08d8d7da6e37
x-ms-traffictypediagnostic: DM6PR04MB4028:
x-microsoft-antispam-prvs: <DM6PR04MB40288F6715F654DFB555F4EFFC809@DM6PR04MB4028.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 85Tdbz3BdbvyJphZbX+F1atpA5NK3rYniCTrpLtSFAQxiYvIG7dWLO6O6VlnqaWbdA9/t8BvGEHdo/JXo/jEjEJv/7uulsVeEHrhBmWxqxGPEs8fz9TsMJIndGoDtxGUf+eREdRnIlmoRbeIHIZJMxgLyTByvA3s/QqDHgsCEYN9VlxiDQa6NGTQm5OAb3ln8HduyBGA/jBg+PCe4O5+R904oYNAE5ZLxwMYtF9JG9LoPqyJLvDd1pSwqokP2+MsLyTbVwsm/TX6jvWTecYdj5tfO7koLsW9P8mhIgoE7SSLO609t0tis7TBQ+iAvohH7SKxAf4Uc/s96KwR4BbOuMs0eV8ettWuLGgoS0zqe6zAP+/gM7g7hqXQSf3c1OaJ0rHfepr8PbUspcn7SL6NHaWlrckO6VX1lq56EB0I1ULOvNwW64vmTn9dze6+lHi/uwLv9801vrzxAhWmf43dRqkufeLELuidYWjkEDIx76eCz3IdlyXhLSkvj6Jq2PA5dSuDDY7aeIYNp8fkvoBTq8Ry4k16hRN/0gr2wLEkWQf5eWZHiLx+/rirbd1TXcMy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(478600001)(2906002)(26005)(186003)(4326008)(66556008)(66476007)(64756008)(76116006)(5660300002)(66446008)(4744005)(71200400001)(83380400001)(52536014)(66946007)(921005)(316002)(86362001)(8936002)(8676002)(110136005)(7696005)(54906003)(55016002)(9686003)(33656002)(7416002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aitwSEE1OU9OSExSY1pHNG9aUERFejF4bTlYRXRLOHcvdk5sTTRuRDNxSThs?=
 =?utf-8?B?bi8vWEpwZVk4Y0NCQzFhODNyMjZ4cnU1dTcxaWdQUERqQ0plRDAzcklxYm41?=
 =?utf-8?B?SFB6WWhEV20vV0hDODRJcWtJVmpZV0poeHVuNGNCSEJzUHM4Z1VkUSt3akFX?=
 =?utf-8?B?bStJRHR0YksvTTBnWFhyaDJwTjNQZ2FESlNXQ1Jyc1FpeEE4VjRqelovL1VW?=
 =?utf-8?B?OWhMSjBLZVRCWEZjdWdzWStXZmp2bkRqcjNHaGxZRnFSd0ZrLzVqRlIyOHc3?=
 =?utf-8?B?WUxjS1c4RitadHk4dGlFdkZiMHN1bFloUCtFY3Q3ejdHckxRVmI5VUpYcU52?=
 =?utf-8?B?cFFLZHdkbmViRXhwR3k2WTF5bVNTT095N2l4SVl0bjlKTStnSEhtbUJTRlR1?=
 =?utf-8?B?NmU5MkEwY1NlbGdQdGx1YWI1SlFaaXdCdyswazEwY0swWlIwSmlmV25RQ05P?=
 =?utf-8?B?bHVrTEtaeHVTZTV1K2RCRXhJblRYYTFpWUZUYzJyeStNcnJ5T0ZaUWp1TXd3?=
 =?utf-8?B?dWthbWs2NFFzaU1oSzdwZC9iT3FIK2NCYVlDc3liQzJySS9peWQ1WW9aU0tR?=
 =?utf-8?B?S0xCK21KOEIyUHhXZzhYZThCS21LUVdPbU9nVDlGdDJCR3hFWFRzVWs1SmZO?=
 =?utf-8?B?SGRmZTI4eGlCci9oblBLZG1qTzBCRWpWanhFd1ArZmU2VnR3WXhUdTVxUmlK?=
 =?utf-8?B?WTZNeEQrdWJtWDdLbHk3Mk5oOWZ1RVlNOXRzRUlQODdMaGpGT3R1UlJCV01a?=
 =?utf-8?B?aStUK29PeFRjamhxY0FNQ2pRd2lwRUNYS1FnT3dVMXFkMEFBamQ0V2EyU01Z?=
 =?utf-8?B?cGFGSk15UnNoZHhMS2ZmUHZYQ1NPSkdpL29iUWhXUFlFOVVmZTNYanNzZHZE?=
 =?utf-8?B?TFQvS0xvZ040YzhHY201RkpBR1FJRTU3L0JxTjR3cDVKNFdBYlVpZlFMQmxy?=
 =?utf-8?B?N3M0V2ZrSFNzMTZqVnEwekNpNisva0JsNXZPelpFMDVGci9rcVJrc3NYV1Zl?=
 =?utf-8?B?TTZTbFJ3NDdEdlpqUGRwMXd3Y1Z2OC85MkxNRlJzZkhFMkxFZXBDZnZ3V0h0?=
 =?utf-8?B?V2VNUllqNUNCdlVrV0tCOTZxZUc0a0x1eTMwazNSMDZ2VC9XVlBSaHRpbHJi?=
 =?utf-8?B?bkE3MVQweGZGYWpXRHlCU3VhOHdYdTM4RUk2bEtsU295c2VSNWpDY21DSXpz?=
 =?utf-8?B?TkJXTVlyNHQwYVJ1N0NrdzBHNHhyRUtUa2dJRFZzYWxJS1V2MXdWeFZhZVc4?=
 =?utf-8?B?NmpEbWpUYzhEaVE1TkFuaC9FQ09BUzcvb2dVajFjbWdIUkgxR3FuaXhQeTBN?=
 =?utf-8?B?Z2d5OE9KUG5GcmlRb2x4MFBqdEZOWXdCTTFlbmxhRXFrVGZaUUJhOUt0ZUhp?=
 =?utf-8?B?NVYyNmgxZkE4UXlNYWFXY0wrK3ZjaCtoWTVsUUE3VENLUGFGVUhiTHpaSjRN?=
 =?utf-8?B?dEhCSWQrRkZBL0NoNiswWUJqeHBCR2ZhVXVSOEFBUXNwTDBwQ2lxamVxYjVt?=
 =?utf-8?B?Z3plTGRURW40SVVlSmx4S1NvcHNCa1BDZnFobnoyVTI1VFl3RnB2UUJTUGFV?=
 =?utf-8?B?ajBUTGYxRENNRURxR3ZNUUNjVW8raVU4V0VmZ1lyRFh0WFlLNUVGT01MZmpE?=
 =?utf-8?B?WkorNGw1TXNkL05OMnF4emsyUjBhQVc4V2NqS1pIVFk3b3VKR2xxeTM3VUhZ?=
 =?utf-8?B?ZkpVbno5elJNeUErVkRiZmhXL3BRQmZuWERWYUVQMzNnQkhETEwzNlpKNUJC?=
 =?utf-8?Q?FdW/pHMqJ8YANkE60u1KBfmjxBnH3Kjh5eqBc+G?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5889a4e4-b3a1-4699-17cc-08d8d7da6e37
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 09:07:22.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o7bYeLSSw3cR2Gzr3Ngmbqn9h9/n3cPGCNsyyYyUWeiMuzm6zNRSDjfr56Dv9VuRUVSpLhIz/+mKwCUIdZH1GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+ID4gPiArICAgICAgIGVyciA9IHVmc2hwYl9maWxsX3Bwbl9mcm9tX3BhZ2UoaHBi
LCBzcmduLT5tY3R4LCBzcmduX29mZnNldCwgMSwNCj4gJnBwbik7DQo+ID4gPiArICAgICAgIHNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmhwYi0+cmduX3N0YXRlX2xvY2ssIGZsYWdzKTsNCj4gPiA+
ICsgICAgICAgaWYgKHVubGlrZWx5KGVyciA8IDApKSB7DQo+ID4gPiArICAgICAgICAgICAgICAg
LyoNCj4gPiA+ICsgICAgICAgICAgICAgICAgKiBJbiB0aGlzIGNhc2UsIHRoZSByZWdpb24gc3Rh
dGUgaXMgYWN0aXZlLA0KPiA+ID4gKyAgICAgICAgICAgICAgICAqIGJ1dCB0aGUgcHBuIHRhYmxl
IGlzIG5vdCBhbGxvY2F0ZWQuDQo+ID4gPiArICAgICAgICAgICAgICAgICogTWFrZSBzdXJlIHRo
YXQgcHBuIHRhYmxlIG11c3QgYmUgYWxsb2NhdGVkIG9uDQo+ID4gPiArICAgICAgICAgICAgICAg
ICogYWN0aXZlIHN0YXRlLg0KPiA+ID4gKyAgICAgICAgICAgICAgICAqLw0KPiA+ID4gKyAgICAg
ICAgICAgICAgIFdBUk5fT04odHJ1ZSk7DQo+ID4gPiArICAgICAgICAgICAgICAgZGV2X2Vyciho
YmEtPmRldiwgImdldCBwcG4gZmFpbGVkLiBlcnIgJWRcbiIsIGVycik7DQo+ID4gTWF5YmUganVz
dCBwcl93YXJuIGluc3RlYWQgb2Ygcmlza2luZyBjcmFzaGluZyB0aGUgbWFjaGluZSBvdmVyIHRo
YXQ/DQo+IA0KPiBXaHkgaXQgY3Jhc2hpbmcgdGhlIG1hY2hpbmU/IFdBUk5fT04gd2lsbCBqdXN0
IHByaW50IGtlcm5lbCBtZXNzYWdlLg0KSSB0aGluayB0aGF0IGl0IGNhbiBiZSBjb25maWd1cmVk
LCBidXQgSSBhbSBub3Qgc3VyZS4NCg0KPiANCj4gVGhhbmtzLA0KPiBEYWVqdW4NCg==
