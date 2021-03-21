Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AB4C433C1
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 10:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E922861581
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 10:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCUKHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 06:07:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37942 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCUKHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 06:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616321230; x=1647857230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nskdP9Ll4AtF/NUF2dJSRqC0X1ZeNr096WvD4G4xhk0=;
  b=eIJUV/lVVz8lwxrbz8zciEIf5mFV4OhR6A/Pv88HgVdU/zWnd/eHdYcl
   tSdOdOoW+8UKUxRc9crpeHQY3Ba3PQnD3qNlMzjhu55eTUW3EuxqyZxn2
   e8K7RiNvRyvilAOivdsKge9ItRrCGA9GnM3ycnP3RwOymlKLfV4rc2ycl
   6Ci5BrZgXvJYt56R2AxjhCxN5/elEl5OTuJoVJACMfOvpgBMgD7r6yKQ7
   HF3PNgRjy/rQxrLUJpdaczpMBURpZQrsLJGP636ePFFDithGGa4OcpSN9
   1z2FL4nBArsa/lxE56Y6/gIB+e7+TgWcmIFeayTMpzvDzXOHPfQ7ojlVW
   w==;
IronPort-SDR: qosvtAyAUao7W9XpfOULMK9xETLamlrPeGrLL02X1l8xorSoPuclU6efpKpdUowqCJQghtVvia
 C/+ZM00BNXv+/XUk2Q/LcXoPs7w6sLGotOIIpMA473BmWNbyWiORtiK/Wy4kec7L7wLp7MOtjs
 oKnw5UrstYBs+7Q9fDaLbY+UaP5E0IwjfHmzoAe0HlktfPJBYLkIp0SzyNmkRk5gVhuh7e02bL
 v9gG4K6b8W2KmP2EFlyodbQIVFVUNHu3p29SLSGtVGINWBNh4+ON90jEmusUtS2UtpO6ebDG6y
 YKU=
X-IronPort-AV: E=Sophos;i="5.81,266,1610380800"; 
   d="scan'208";a="267049063"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 21 Mar 2021 18:07:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX4N4VPaBdehOxytvoXTHqBE5lbfMdiE34rl5NeIKs2R47bMjD1oge3z97PJUhWxvtSZK8YQd1w8t6rFi+aRdlXE6HCgH+lw1GxJxNfS0U2AkJi1rEboYUnJtqgEC4Nly1r//o+Lt86jJ/rSnhC5LtAT5xAU7XNiQU+k4mSFkLeijdkn36tp29w8ksYB6VsJIz4RdPPhdW+8KlAGV03lmPHDcdzTQrfCjv7dsglWjEGcw8XbBV49mwIe6jvc78e/1SQFS33eUCDFEBR9/X49tb5o3CY3JBTCJaOC43ezvniDlLIuZYXx99sG5vfCfCa9xrjnctJVq9knMrWbmch7Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nskdP9Ll4AtF/NUF2dJSRqC0X1ZeNr096WvD4G4xhk0=;
 b=VoL+dTRUKK2XJjmxXW5jLqgeDPGh2WJkSd7sigwz4mtVzffgdxgBWF4i89EmXVNstTlw4udAMA0zXk+f9dY1xKUD8TGKuuIUlAZF7sLP8vzscbQM2BnPdcyIxEMTTcXAkwgcIYv44Nwirqmec/kWXks2jhN4MR7Z7pjWKbdN8E9835vIZty9eGYCuaQJHtZJ2+N02D8KQcQfkcxXlUaTBbOpcqq+dRf9ADHJgQ8KZ15MAcVeogMl6XrNoV+B4smx16H8uwTLftsQuk8ll3JLt7LHkS14PC1pEhNTfiZw237P+SoTSCUszeB+chjj5OrdvdHVu22ejYDzbj58qv3ogg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nskdP9Ll4AtF/NUF2dJSRqC0X1ZeNr096WvD4G4xhk0=;
 b=zI/D/ySSFIvbTDCeXPjvcdYyTEv3LwYWCE1pnUoL8pg9r3gimKQecnZjGcHk8HjuehldxSvKW1h5o0v8mQA9aI8FiMZn8jWwn1lbe2389CuCCn13+d9h47S7LJmGJWb+N0fummBaKLa46fSc1dDVBq16qJAq4wfspYANUTlnDtA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4027.namprd04.prod.outlook.com (2603:10b6:5:ac::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Sun, 21 Mar 2021 10:05:59 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.025; Sun, 21 Mar 2021
 10:05:59 +0000
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
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXGTsD7TN1PlWoo0avHHbLGOwa2qqOQBGg
Date:   Sun, 21 Mar 2021 10:05:59 +0000
Message-ID: <DM6PR04MB6575DEC175CD1D3895F1AF2BFC669@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
        <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p8>
 <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
In-Reply-To: <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16b69f92-ac90-484e-47bb-08d8ec50ed3b
x-ms-traffictypediagnostic: DM6PR04MB4027:
x-microsoft-antispam-prvs: <DM6PR04MB40273470E00D94F38C72B06FFC669@DM6PR04MB4027.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5M/4S9PSE1H332cggvlvj/J+MTfg96jNUwyQE65ppB9knBhkwjiLSjM0nO5Zn6gQ+Dd+SAPbcRatT2poXVeyYXxeQmGPF1/8WVJOJ9N24uNc1PdgqjMdnyxqFdzKgCeLyaoRuoPlaxSZoVjogznUY78vMfi0U5uTfYKktB5ZPJ+q9aeEsoqYDrri5fuMwxO8Dz7hqEnvanc/WhI65d+awukYYWO3s7dlyyOWt+ggPC/8PPHZf2wfXsvbuJuv7Fggcunsr6DLX/iZUI26TCJsZ/J9SmnPZjejnifSPJPd1zix68Zbo35OMqFdt6QPl0hWvrg63Y5dUaKfshKz9ZbIupf4e2Q6d1/z2Cofnu4gjMvoZ8QaSNDRE0eZ3JvDDP2Or3kqf3C4ByD37vKrbOuv9FfZbwYed4Q1Np7aemtq2cqFIn5LciyyOcpJJqsfqDaq9i9TMF7lJKSBg+JIFVQ1jTi1uitnMZNZZMrTAkv/dgzdcz3wrKrjVhNoVoqLpv0WVrk+hvABg8m4nPMztSfBFHgd03AjFYGJwT8SV/Qwg+NCg/cL2I43DDdkFuWxRQQgh9+gliL4yZ13rQDDaLBSn41V8CcKoHCVuFx5yYDS/n/TWH6V/C4ZbTOfr8IY+N6MUglD4HXxmg1MaeW6MKwOtUrXR3F3iG0RFBo7d6F7D8w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(316002)(54906003)(83380400001)(110136005)(55016002)(66946007)(33656002)(71200400001)(4326008)(7416002)(7696005)(9686003)(8676002)(921005)(66556008)(8936002)(64756008)(5660300002)(86362001)(6506007)(186003)(66446008)(26005)(66476007)(478600001)(76116006)(52536014)(2906002)(38100700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QWVKbXRqeCs3Z1JyK3R6V2pnS2hZVzlHdjhxNHdkR0JZWGd5b0dOYVJFckpM?=
 =?utf-8?B?UnEzTzlTSStxVnJhcThKZ2p1bjNpTWNobStyWElmUnl5Nk5CbXlHUVQ1dmFj?=
 =?utf-8?B?YU0rOW9PWVlzNHpoTHFnb0xUYXlpQkQzbUJhZTBHc1dXOUErZ2h3eXgrNVF5?=
 =?utf-8?B?eEIyNStPQzdjMUJBcjhqRGl4WXUwSnpWMU92cC9OUHlDMGprY1lJT1k0NU51?=
 =?utf-8?B?UzI2ZW1zczhrQkpJaVBNdnpoU3N6NGc3Q3ZWcUlRb3dENU15SzFhbVJBSjlY?=
 =?utf-8?B?cVpzd1dsTm90U0dteCtyS1d1L0ZKSzRNaWhNa21TZDJaT0d4V3hmaVBaRmxQ?=
 =?utf-8?B?byt4cmh6NGs1ZkpFN2tOQ05BNFZ5RzhqOTUzUVM2N1dPSllZVldoSnNXTVIr?=
 =?utf-8?B?bDVialQ4TmRpbTY5bGozKzhxTnhxc2x4SDRqWnlYSzJ5WjlnVkZuK1lnd1NP?=
 =?utf-8?B?alRtdzZBMGNMN1NueE1oekpWNnh2QWMvSlNMMzhTWEFsQXp3bDFkNVNnaDM1?=
 =?utf-8?B?eDBpM1M4bU9sZ05qS2xtOERQMzhLOCtLYmlibTB3eGpTaEt6QVFsd0kxODZK?=
 =?utf-8?B?K3VOZmpsZVdUV2w1SVRwR2JZVDcwMmhnakNvN29QdzMrY0pHU1Z6RGwzK1dI?=
 =?utf-8?B?cHl5VG5NYktVQWZ1YjZKdkxOWFE0bTZQOHZISlBCNXJJSFRERTQvbnZyS2R0?=
 =?utf-8?B?UXdFNEpRVGh0Ykk0Tk00ZGNkWTExUUpDU3c0dUZnQkRzVjNXUEVqSlFVdUVi?=
 =?utf-8?B?MFQ3NW1CVi9TOVg2WmNpVmpvQjFEWmtSSjhOb2dsYW4wdzJ2YkVONmJaaXl4?=
 =?utf-8?B?MTNndXh4WDlPM3IwMVltTUNYQ1VWS3o2TTNHemNUcFFFa3h3VkZYWERBOVBO?=
 =?utf-8?B?bkV0WWl6VGJNQUljbXV1S2dqUjNLbStXNFNoWUtETDFienkySnpVb2R2ZTZC?=
 =?utf-8?B?ampUMDZWbXJ6TUR2Q2Q3RXU4YVNYcld1aE4rTHFxRXlCbURMcHdNSzhYY0pZ?=
 =?utf-8?B?WWY3WUtQMmhoN255a2lrRWsxc0JkamFrM1ovQlFkQVVkTTJRRW1rMUc3RkN6?=
 =?utf-8?B?NC94T1hkUXlUSmVzczdtRi9OcjZkWjEwSGc0TjRXOUpYcHZRR284OXlCaHp0?=
 =?utf-8?B?WHZ6NUF1eHBCdm94NUFXTlNBZlRRZm9QTjU2bDJqQ1hJallRRWYxS2l5M2F5?=
 =?utf-8?B?MkZGdjAxMi8yc2poaWJwU1hJK0d1M0xOd0d1QW5wRHowUFBQNTRxcHdCV1hZ?=
 =?utf-8?B?R1NhMjJnQ0NUZE5Md2VwTXM4M1ZsM3J2eTZxNEU3Nkg4UWQ2VUU5MVZlaHh1?=
 =?utf-8?B?ZDZDUmR6alo1UmNkcXJtL0JpVlV6QkVENkRQeWZ5dVE3MVhiL1hRVWx4QWkw?=
 =?utf-8?B?T1B0M3B6dEJIcStLT1VVS21GU3R4emZaWHRsOExxd3FCby9GRGdKYXpTclYz?=
 =?utf-8?B?TkVqVDhadDJLNVUyZng3N2FXclFBaDUwVU5qY2gzU09sU0UzNUFMMnF5VlBL?=
 =?utf-8?B?cFZOVTBwSnpsWDh1bGhPeXd4Z25vWmlnakdXUk41NDBUa2xxaVROQmQyWEJ4?=
 =?utf-8?B?bWo5ZGVXSlNvSTRCT0NHMVkwaFkvL3FteFFUYTZTVTg0bXU5N0x5ZUxTZ0dt?=
 =?utf-8?B?TFlyMEIvT3RyaTc2NWwvMFZjTjlPU3pFVVFNMFhTb2F3NmFPQnNHeDdnbHoy?=
 =?utf-8?B?MVBpZVA5VUtDUEM1ajNGc3hKWUpOcXpZS3RzT0x4L1NEdzJhM1d3Mk1IZHE2?=
 =?utf-8?Q?lRafbhT+GheH23ypeJs2/MOmtAkASmZjppsF/hF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b69f92-ac90-484e-47bb-08d8ec50ed3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2021 10:05:59.3145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kLI8Whp6zg3dyorSSxlUXyI5ElKtSdU6r32pyKiIymtmp1ar3ofy5BIS7F1UfzxR/relwLl5BgWIKbvswO6hJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgaW50IHVmc2hwYl9leGVjdXRlX3VtYXBfcmVxKHN0cnVjdCB1ZnNocGJfbHUg
KmhwYiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdWZzaHBi
X3JlcSAqdW1hcF9yZXEsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Ry
dWN0IHVmc2hwYl9yZWdpb24gKnJnbikNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3QgcmVxdWVzdCAq
cmVxOw0KPiArICAgICAgIHN0cnVjdCBzY3NpX3JlcXVlc3QgKnJxOw0KPiArDQo+ICsgICAgICAg
cmVxID0gdW1hcF9yZXEtPnJlcTsNCj4gKyAgICAgICByZXEtPnRpbWVvdXQgPSAwOw0KPiArICAg
ICAgIHJlcS0+ZW5kX2lvX2RhdGEgPSAodm9pZCAqKXVtYXBfcmVxOw0KPiArICAgICAgIHJxID0g
c2NzaV9yZXEocmVxKTsNCj4gKyAgICAgICB1ZnNocGJfc2V0X3VubWFwX2NtZChycS0+Y21kLCBy
Z24pOw0KPiArICAgICAgIHJxLT5jbWRfbGVuID0gSFBCX1dSSVRFX0JVRkZFUl9DTURfTEVOR1RI
Ow0KPiArDQo+ICsgICAgICAgYmxrX2V4ZWN1dGVfcnFfbm93YWl0KE5VTEwsIHJlcSwgMSwgdWZz
aHBiX3VtYXBfcmVxX2NvbXBsX2ZuKTsNClR5cG8/IEZvcmdvdCB0aGUgc3RydWN0IHJlcXVlc3Rf
cXVldWUgKnE/DQoNCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+ICBzdGF0
aWMgaW50IHVmc2hwYl9leGVjdXRlX21hcF9yZXEoc3RydWN0IHVmc2hwYl9sdSAqaHBiLA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHVmc2hwYl9yZXEgKm1hcF9y
ZXEsIGJvb2wgbGFzdCkNCj4gIHsNCj4gQEAgLTUzMywxMiArODc4LDEyIEBAIHN0YXRpYyBpbnQg
dWZzaHBiX2V4ZWN1dGVfbWFwX3JlcShzdHJ1Y3QgdWZzaHBiX2x1DQo+ICpocGIsDQo+IA0KPiAg
ICAgICAgIHEgPSBocGItPnNkZXZfdWZzX2x1LT5yZXF1ZXN0X3F1ZXVlOw0KPiAgICAgICAgIGZv
ciAoaSA9IDA7IGkgPCBocGItPnBhZ2VzX3Blcl9zcmduOyBpKyspIHsNCj4gLSAgICAgICAgICAg
ICAgIHJldCA9IGJpb19hZGRfcGNfcGFnZShxLCBtYXBfcmVxLT5iaW8sIG1hcF9yZXEtPm1jdHgt
Pm1fcGFnZVtpXSwNCj4gKyAgICAgICAgICAgICAgIHJldCA9IGJpb19hZGRfcGNfcGFnZShxLCBt
YXBfcmVxLT5iaW8sIG1hcF9yZXEtPnJiLm1jdHgtDQo+ID5tX3BhZ2VbaV0sDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUEFHRV9TSVpFLCAwKTsNCj4gICAgICAgICAg
ICAgICAgIGlmIChyZXQgIT0gUEFHRV9TSVpFKSB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAg
IGRldl9lcnIoJmhwYi0+c2Rldl91ZnNfbHUtPnNkZXZfZGV2LA0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICJiaW9fYWRkX3BjX3BhZ2UgZmFpbCAlZCAtICVkXG4iLA0KPiAt
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1hcF9yZXEtPnJnbl9pZHgsIG1hcF9y
ZXEtPnNyZ25faWR4KTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtYXBf
cmVxLT5yYi5yZ25faWR4LCBtYXBfcmVxLT5yYi5zcmduX2lkeCk7DQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgIHJldHVybiByZXQ7DQo+ICAgICAgICAgICAgICAgICB9DQo+ICAgICAgICAgfQ0K
PiBAQCAtNTU0LDggKzg5OSw4IEBAIHN0YXRpYyBpbnQgdWZzaHBiX2V4ZWN1dGVfbWFwX3JlcShz
dHJ1Y3QgdWZzaHBiX2x1DQo+ICpocGIsDQo+ICAgICAgICAgaWYgKHVubGlrZWx5KGxhc3QpKQ0K
PiAgICAgICAgICAgICAgICAgbWVtX3NpemUgPSBocGItPmxhc3Rfc3Jnbl9lbnRyaWVzICogSFBC
X0VOVFJZX1NJWkU7DQo+IA0KPiAtICAgICAgIHVmc2hwYl9zZXRfcmVhZF9idWZfY21kKHJxLT5j
bWQsIG1hcF9yZXEtPnJnbl9pZHgsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
bWFwX3JlcS0+c3Jnbl9pZHgsIG1lbV9zaXplKTsNCj4gKyAgICAgICB1ZnNocGJfc2V0X3JlYWRf
YnVmX2NtZChycS0+Y21kLCBtYXBfcmVxLT5yYi5yZ25faWR4LA0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIG1hcF9yZXEtPnJiLnNyZ25faWR4LCBtZW1fc2l6ZSk7DQo+ICAgICAg
ICAgcnEtPmNtZF9sZW4gPSBIUEJfUkVBRF9CVUZGRVJfQ01EX0xFTkdUSDsNCj4gDQo+ICAgICAg
ICAgYmxrX2V4ZWN1dGVfcnFfbm93YWl0KE5VTEwsIHJlcSwgMSwgdWZzaHBiX21hcF9yZXFfY29t
cGxfZm4pOw0KRGl0dG8NCg0KDQpUaGFua3MsDQpBdnJpDQo=
