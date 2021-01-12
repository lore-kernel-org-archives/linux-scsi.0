Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FC0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 08:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1B322D58
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 08:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392219AbhALIVW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 03:21:22 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11395 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbhALIVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 03:21:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610440291; x=1641976291;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hc3Q+vv0KEIY/P12fc8dx5Ajb3GaTCxZ+slqX3poVZY=;
  b=TUJHehyB3SyZtCRJxNQ5NKtH3jZSBoKnCiv9hMqbKx13Io6s+PZHefp8
   evh34iwLU+v2wgVU4khuH2K9iYUopj7DC7pLN/VE522VyA6GZCCDYwhkN
   hDODcBDRWusNsRa34zohnC1m0W4LH1/yroTypj2lL+PDwaCQPTIzSQTjL
   ptHlhJZp+e2sSvCSzqrVWm8iDuyasvwm0dZGsP/a86772oSZ4b6CpWkJp
   ebYbCvbF3Tb3WOHsjK0CFFx2g+LzD92xfP16HnWhe5NgHghWyv0r6vEs1
   0NKojNsa8mZ6+NFJib293r1WAqwLfEWefigLU3j8+xeSBwQTSnp08n+T5
   A==;
IronPort-SDR: mykJkfc1t485WulBvpr6vxpjQF7qJpOfAQy9vyWG8akfalw3jr+DZpcqGT/rZjGGwUurIDwepB
 lP00dwJOTxbeE6zX08PHwVYYip6B19amWVpEh/lrCH7xS+sOolNtX34w4f+QkQZULQdXLoPg0c
 7blpIkCK3ExrUCmscAW5/QSUc4f8DbP2rJltH2odDFuHvdzpfvro+gkIDUZWtE/FKzHuDnwc3x
 LQUeXRlqs5eh7RKPDEkRlkRNN+bfI8ISNl57jjNiGdePyCnbieykbbjwYV2NPlJyMKWk9DMw8b
 PRk=
X-IronPort-AV: E=Sophos;i="5.79,340,1602518400"; 
   d="scan'208";a="261118445"
Received: from mail-bn3nam04lp2059.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.59])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 16:29:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2nL+bx3nEL/B6ghMJEupHAQH6xiNxV/8yT+SSdQ2+Q78clwhDrppM3KebdCOoZkPQNMV2hG9J/iflHhf9zl5lIXNgcZ8D1UMMb4bHLYX8mWe8rL6/UenEAFs8/MUnKUo4D+PuZ8QUZjQ9nANriPsk9Ov7aosTprfbJB8UEBEKIDS8U/2SZHPpFrbBDeA+iaLuta/zcIyhYVHHiJ+1HVrEm63Y7ixhXMyxH0+FWPWeUgr86klI9xrPUYfZQs62ejxDu7F9soX5D3dQOesJOA1yzpWzt3DR2pArxBi+SpyJgtTR1tyktw3Pa8mHwipXGeFuYEh/SdEdWzXvGlYw7HAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hc3Q+vv0KEIY/P12fc8dx5Ajb3GaTCxZ+slqX3poVZY=;
 b=n2advHZwpRmrF9yNeCVutZPR0nK3STmIB6PLAobg0gl8RKH+3OQR1/ZzEWDfbC8GmVxCnsOtxAS31O2Kqown3tzxXAfuKYzl5jNPLXgBHN1XIx/QvfcNCtKJ+CTUdEt3YtCYb6OWLLiGbQwND5PYdYZ9zdm47yYK78NoMqdfwF29SlOAPRpyknGhyLbbRNj7/9CAglRd5KHUvP+3a1231w5dLF0zinIsXLBVSPWNMK/RjBhhKhM8bsGn7Wltmn2H+w2iHIalBGmVvpkGxEcgtX9PA2J6L1iHvkyGSqPvIUkOyPFzy4uHbRJCmqFkO3Z+zV8u5YhsJHco7Nh3SJlaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hc3Q+vv0KEIY/P12fc8dx5Ajb3GaTCxZ+slqX3poVZY=;
 b=S1mhrqKUTVZ3v6d8c9JM5VMQVNa0KXb1TOkc9IsT8/pL2FySH7+PwyGTg9OR/9i2Ht5TiFmI/ubNiFrr4GZFUX42A+cpR9k2u3bLbS8ejpzlpSX/Es9nTHCNrzGs0z0KTmw61wvmw7WS6S7kNRcek1pOj/UE4y0BLhynV++1bEQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4028.namprd04.prod.outlook.com (2603:10b6:5:b6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Tue, 12 Jan 2021 08:20:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 08:20:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "ziqichen@codeaurora.org" <ziqichen@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
Thread-Topic: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
Thread-Index: AQHW52wsFuiTahdeFUulzlUmp1OO9Kojphaw
Date:   Tue, 12 Jan 2021 08:20:11 +0000
Message-ID: <DM6PR04MB6575AC5B5FE4C306F6674194FCAA0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
 <0ad818b10110c4c383afbc2c39235a4f7f17f4c7.camel@gmail.com>
In-Reply-To: <0ad818b10110c4c383afbc2c39235a4f7f17f4c7.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 91317215-e8d9-485d-f2cf-08d8b6d2e154
x-ms-traffictypediagnostic: DM6PR04MB4028:
x-microsoft-antispam-prvs: <DM6PR04MB40289EA4258E14CC12A82820FCAA0@DM6PR04MB4028.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5U5fRzyz7GFrbXgk4tdJH56qoq9VD5JF75BOdkaEtakKamj+34gbeoh0EfcMNNApd4rxLBMLGPkZDfJAf/Be+f6yz/RTv0acIKokBbUWLrP64OSDZwcSAP62SFjjFzGbx/Q+Ca2nbbbJ3oM1sZblsnN+uVIBoU8uTV27kjKSZGc5Dnh0Y2OxsXNmrzkG0ONZmhS7v5UnrCdOFxtlIfVZFZFPoh7HnW9O4z85cYdL9EIxNxWO+pXgQ4Cm+0aO7O+HsTPwE+Pt22hjB8CSAexdRZ01PbRjCKxDn+84WqMAq1P7uY3I/LFDtKx61OFDFp1hqzcQwkyn00aPAHT8Ss/XOse7I6wg2zgmmAAQFNB/g5QyxLD3l5GyuMuZ3BWc838+Z49rr1LMr5BDSqwjGXToJtup4rsn7gb2Y6AcY6Z2LVr/wK8CDloEGCEDlECvYVNH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(55016002)(9686003)(71200400001)(33656002)(7416002)(64756008)(26005)(76116006)(6506007)(66556008)(2906002)(110136005)(7696005)(478600001)(921005)(4326008)(186003)(5660300002)(8676002)(66946007)(52536014)(86362001)(66446008)(316002)(8936002)(54906003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TDQ2aWVxdVF5d3RSa1hySnVKSkQ1SFVkT2pKRS9UZnFFRUJXOVMvRHVOazY0?=
 =?utf-8?B?c0RPZEcxMks1R2c2TkZZaXA3MkpMa3ZWOHAyL3F6blFKLzhLVnVNbDRhOTlC?=
 =?utf-8?B?TDJlbElXd1gyRUwwelpaVWFIY21HSDBNR0RQRVk1WTlhQ1JyaTZPQjZmU3Fl?=
 =?utf-8?B?dUlJTDAyUklMTWdtSGdpcE84MEVoRFNzWVpBWmFpc3F3RHJyajRKTFRSOW5p?=
 =?utf-8?B?VHhGSElUUjJuWkJ2bUt6U2JhTDZQUUw3UU1ERk5OTlIrbDIrWGdKRnduazVx?=
 =?utf-8?B?N0VlTUNFNFNxNWtyeC9WbGhDVWJrYk1XcFFxK2tBTnhtdWpRcEgrb0JlN1FW?=
 =?utf-8?B?YjEyQ2tOVjhUelpaKytzc2hjNzFndnpzRkRKQXRFQnMyT3YzNDAvT2VIWjdJ?=
 =?utf-8?B?Z2crcVY3dm9oc3gwV09PdFM3TnQ4Q0NNcGN4TDZuZGVjaEdoUXA4YjVkQzNo?=
 =?utf-8?B?ZFJ0M3EwWXgwRm8zbC9BZEZVbCtoTlBsM2FWOWl6R0JmVnNXQ2JCU1h1RHd2?=
 =?utf-8?B?S3hYYXBXVnJNSXhIWTkwSkFtMWNpNk9PR2RHSWR4WFR6Y2JjWGpCTURNdllu?=
 =?utf-8?B?ZWQyR093YXY0UlRqdWM5eVNaam9JM1JtMHRwZU1QNUUzODNENkkzZ0srbEs0?=
 =?utf-8?B?bmYwWnFqUXBoWW0yM0tmbXZtVG9zL09mcndCSFoxOFNnT3cveiszbnZ2Y1hm?=
 =?utf-8?B?M0hGSEpDYjVEcXpjVWpXdkNXWVpIeVE4S2lWQ2ZWNkhROTE2NVQwZlBVYWVz?=
 =?utf-8?B?WXpnT2k2YVhhbXJkVkNVcXd5dHdDdnpPbG9XQVFEcW9zWXZHczU3SHRJejRD?=
 =?utf-8?B?UlZTQ3J4dVlnMEZrK0xkamtuTXNlUkZYblowUkZRdTZIVU1zZWd5ZHRBNG1P?=
 =?utf-8?B?SmRsclBYT2FUdjZWdWlxL3RTVHBpbzVYbEdYODMyMGJJS0Y3ZDNxYjNPZlVi?=
 =?utf-8?B?N2h5MkFGN2NFVExsR1RzblBPYkozMXNiaXVaTWNpN0p5MEhKYzJWbHZRMHpG?=
 =?utf-8?B?VFJJTEFCUDFoalAyK3BjWXRlbVhMNmRrbDUvdmJxaTRLQVhJRm9mS1lnblEx?=
 =?utf-8?B?SzN6TWIycnNjeEpPamltb3dmVzgyaVdLTDZxckxoZEJEL1djNStiZzRaaENU?=
 =?utf-8?B?ejk2NkRNdFhZeTlqUnJPOHY3cEhoTEZZSVc1aHVjU29nNXdmV2t2WFV2aHRu?=
 =?utf-8?B?UTd6NUNJTDVaREQ5bkxHOWkzdEtnNzZoYW9LTDBYK0RPYVFmWUtPNnBSb2hL?=
 =?utf-8?B?UzZTSUdVaWxQOENuazFEQ3NPYVFSa3RKdEJncnVDcXZPdlNKejFWUm1CSjZF?=
 =?utf-8?Q?uYcZF9G3GHWFE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91317215-e8d9-485d-f2cf-08d8b6d2e154
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 08:20:11.1767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: buaKC104xlhXgEgXMwta6gFFDf8bfGQaVPFsf2UaF7ul3uG0JtY1gZvetGiZBW7ObZCD0m+0PcVy7gNABWpcmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IA0KPiBPbiBTYXQsIDIwMjEtMDEtMDIgYXQgMDU6NTkgLTA4MDAsIENhbiBHdW8gd3JvdGU6
DQo+ID4gKyAqIEBzaHV0dGluZ19kb3duOiBmbGFnIHRvIGNoZWNrIGlmIHNodXRkb3duIGhhcyBi
ZWVuIGludm9rZWQNCj4gPiArICogQGhvc3Rfc2VtOiBzZW1hcGhvcmUgdXNlZCB0byBzZXJpYWxp
emUgY29uY3VycmVudCBjb250ZXh0cw0KPiA+ICAgKiBAZWhfd3E6IFdvcmtxdWV1ZSB0aGF0IGVo
X3dvcmsgd29ya3Mgb24NCj4gPiAgICogQGVoX3dvcms6IFdvcmtlciB0byBoYW5kbGUgVUZTIGVy
cm9ycyB0aGF0IHJlcXVpcmUgcy93IGF0dGVudGlvbg0KPiA+ICAgKiBAZWVoX3dvcms6IFdvcmtl
ciB0byBoYW5kbGUgZXhjZXB0aW9uIGV2ZW50cw0KPiA+IEBAIC03NTEsNyArNzUzLDggQEAgc3Ry
dWN0IHVmc19oYmEgew0KPiA+ICAgICAgICAgdTMyIGludHJfbWFzazsNCj4gPiAgICAgICAgIHUx
NiBlZV9jdHJsX21hc2s7DQo+ID4gICAgICAgICBib29sIGlzX3Bvd2VyZWQ7DQo+ID4gLSAgICAg
ICBzdHJ1Y3Qgc2VtYXBob3JlIGVoX3NlbTsNCj4gPiArICAgICAgIGJvb2wgc2h1dHRpbmdfZG93
bjsNCj4gPiArICAgICAgIHN0cnVjdCBzZW1hcGhvcmUgaG9zdF9zZW07DQo+ID4NCj4gPiAgICAg
ICAgIC8qIFdvcmsgUXVldWVzICovDQo+ID4gICAgICAgICBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVj
dCAqZWhfd3E7DQo+ID4gQEAgLTg3NSw2ICs4NzgsMTEgQEAgc3RhdGljIGlubGluZSBib29sIHVm
c2hjZF9pc193Yl9hbGxvd2VkKHN0cnVjdA0KPiA+IHVmc19oYmEgKmhiYSkNCj4gPiAgICAgICAg
IHJldHVybiBoYmEtPmNhcHMgJiBVRlNIQ0RfQ0FQX1dCX0VOOw0KPiA+ICB9DQo+ID4NCj4gPiAr
c3RhdGljIGlubGluZSBib29sIHVmc2hjZF9pc19zeXNmc19hbGxvd2VkKHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQo+ID4gK3sNCj4gPiArICAgICAgIHJldHVybiAhaGJhLT5zaHV0dGluZ19kb3duOw0K
PiA+ICt9DQo+ID4gKw0KPiANCj4gDQo+IENhbiwNCj4gDQo+IEluc3RlYWQgYWRkaW5nIG5ldyBz
aHV0dGluZ19kb3duIGZsYWcsIGNhbiB3ZSB1c2UgYXZhaWxpYmxlIHZhcmlhYmxlDQo+IHN5c3Rl
bV9zdGF0ZT8NCj4gDQpMaWtlIENhbiwgSSBhbSB0b28sIGRvbid0IHRoaW5rIHRoYXQgdXNpbmcg
c3lzdGVtIHN0YXRlIGhlcmUsIGUuZy4gVUZTX1NIVVRET1dOX1BNIHN1ZmZpY2VzLg0KVGhlIHVz
ZSBvZiB0aGUgbmV3IGZsYWcsIGpvaW50bHkgd2l0aCB0aGUgc2VtYXBob3JlLCBwcm92aWRlcyBh
IHRpZ2h0ZXIgY29udHJvbC4NCg0KQWNrZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3
ZGMuY29tPg0K
