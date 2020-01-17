Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39FEC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 12:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A092C2073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 12:55:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="xk5Kjgli"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgAQMzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 07:55:06 -0500
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:11872
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbgAQMzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 07:55:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpwubKXODeiRTqqnCeW0CzCvyyPRWmDCu/+4knik23BwButvgy9Wc8n/tFMa4frXhW/tiS2WXzC7f88DKIJZ7iJhHMvm8qnRzbdO/eEsKpnb5XhAL3qaBDfhU0E0t4VVG5GYLNisfhjIWUTVlJ3G/RqLLuY4bFk5nSmEGtnyMoRPUW6yH4Gj2f18zAD8Gkl1nUmni/bZxJCL4bWRt3MLM7DhxZH5Hct5XvI9opaphVId3noEBgYFtffb90r6dKJffzrOzZPRwGH8d9yOiWGjrsgZ4jraLjcFAvV+DD1aokdaQ4bfoSyvFrzoLZlLL13BTCCUaer+YqTyIqptvb/Sdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGOEURLA2yXUUmLu6gvS+tykkiJJU85efd+fvh9plVg=;
 b=Zs+VOgrsgCdyN//FH4ihrUjAq2CxGe6djGUvN4q4GG1yRkrw1Vljj+x8A5ZeC5jqbFQT9z/pQJSe/wVmCjt41RfMb2mxiubtSeNVBain1M2xG2V3X/VSR91k+gur7YuLGJGpCb6MoJWUK8ly5R60fI80blXELG4tj5sT4GLNuO4hvsePvSz34ooVgKAMLuqdcs5RB9rpu0RzEv2gN6h6zIXDZnpRedsLtojREMZ3+/3ei1RiBy5B9xZl4FcdCkKL6tQINn5+C23kSpP6WYB+7oHQt/wrD4sXpgRaJC+QBVCYHRDYAer8eFO29l2kicH1vHgeR0vP784qtMOZPYe28Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGOEURLA2yXUUmLu6gvS+tykkiJJU85efd+fvh9plVg=;
 b=xk5KjgliUJR0cRF0ZDIEeuJk4olivvrKEp7NJHs7ng0iiXL0GZKLWbEtUny1uRPl60yuRZehtFWRrvEtYf4jJLig1eeD4W8SmY4u8BcT/TVeeVj08QYE3Qh4VzWatTRjbax8pCZfh95hgnsVDogppUv5Q3sdDCc4jPKfwA42ly8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4290.namprd08.prod.outlook.com (52.135.250.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 17 Jan 2020 12:55:03 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.021; Fri, 17 Jan 2020
 12:55:03 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 2/9] scsi: ufs: Delete struct ufs_dev_desc
Thread-Topic: [EXT] Re: [PATCH v2 2/9] scsi: ufs: Delete struct ufs_dev_desc
Thread-Index: AQHVzOmr8txOZeeVp06Oxze9xgNap6fuwmjg
Date:   Fri, 17 Jan 2020 12:55:03 +0000
Message-ID: <BN7PR08MB5684A86FC0922C3AC2DF93A3DB310@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-3-huobean@gmail.com>
 <afc473b1-6857-4cca-101d-2382f5314f0d@acm.org>
In-Reply-To: <afc473b1-6857-4cca-101d-2382f5314f0d@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTkxODExMTc4LTM5MjgtMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw5MTgxMTE3OS0zOTI4LTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEwMjAiIHQ9IjEzMjIzNzM5MzAwMTY5NDE5MSIgaD0idDR6NWpEcnEwR210SWlHbmUwRGFCcFNxVHFZPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4185f36b-5cc7-40bf-40e1-08d79b4c7840
x-ms-traffictypediagnostic: BN7PR08MB4290:|BN7PR08MB4290:|BN7PR08MB4290:
x-microsoft-antispam-prvs: <BN7PR08MB42903C03AF09EECE03E3CB89DB310@BN7PR08MB4290.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(110136005)(54906003)(81156014)(33656002)(316002)(5660300002)(8676002)(81166006)(7416002)(8936002)(26005)(71200400001)(52536014)(4744005)(86362001)(66476007)(7696005)(66446008)(66556008)(4326008)(9686003)(64756008)(66946007)(76116006)(55016002)(53546011)(2906002)(6506007)(478600001)(186003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4290;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3+6UzdBaCpoWHl4qRlpuJtk6bpfOjZolY9fMZbKDLR0zYhKjiwh6lovdgyG7nigv9W9Flwpi0aisIcrrXXJnI2CtsM8GIHIWm56TgWo1iPp2FMOlw8uxElHoBx5II/nkqy0sgIz3olAKxTflCccQc/wBo5ww6wuu5MWZk+wyky5eTrZ1gx2+YeK+IASncwG7Bm7DMikA2SOOPCquqbymnPlbihEnnqTAWnVzjlp4aSlh0lgVnU77Sal7s5V+pYjFpRSvfNpfnApLZeYxcl8fCXRMbVTTY3bEjykgfmgHE7aNqziHfcrCGfo82QXkWWiLt5nkqhXqRnp2YZmftEzQ7cC/mIzM3sZsBVLkSpBCM0otcHobKwzoHMQgOYlZDpLkrQgqzSg+3a13ckhu8sQEI1dLXLkirnPLqqui55SimfkDV+WrHQAtYl0tKFNZg9shtX1+FDhq2uj0TTmzjZv1z7IcUJnh1tlNJ/Ds9XWUSl5EA9awRYt45nztQXz45u0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4185f36b-5cc7-40bf-40e1-08d79b4c7840
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 12:55:03.1522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ra45DpEfltb0Wdzy5dJ+70BIZnCF+42ayTyf7IDuyTa5FzkADGnjmE+gCzuzhn6aEAJooGDSdBI9grQfvh5rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4290
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiBPbiAyMDIwLTAxLTE2IDEzOjU5LCBCZWFuIEh1byB3cm90ZToNCj4gPiAg
c3RydWN0IHVmc19kZXZfZml4IHsNCj4gPiAtCXN0cnVjdCB1ZnNfZGV2X2Rlc2MgY2FyZDsNCj4g
PiArCXUxNiB3bWFudWZhY3R1cmVyaWQ7DQo+ID4gKwl1OCAqbW9kZWw7DQo+ID4gIAl1bnNpZ25l
ZCBpbnQgcXVpcms7DQo+ID4gIH07DQo+ID4NCj4gPiAtI2RlZmluZSBFTkRfRklYIHsgeyAwIH0s
IDAgfQ0KPiA+ICsjZGVmaW5lIEVORF9GSVggeyAwIH0NCj4gDQo+IEEgbWlub3IgY29tbWVudDog
cGxlYXNlIHVzZSB7IH0gaW5zdGVhZCBvZiB7IDAgfS4NCj4gDQpXaWxsIGJlIGNoYW5nZWQgaW4g
dGhlIG5leHQgdmVyc2lvbi4NCg0KPiA+ICAvKiBhZGQgc3BlY2lmaWMgZGV2aWNlIHF1aXJrICov
DQo+ID4gICNkZWZpbmUgVUZTX0ZJWChfdmVuZG9yLCBfbW9kZWwsIF9xdWlyaykgeyBcDQo+ID4g
LQkuY2FyZC53bWFudWZhY3R1cmVyaWQgPSAoX3ZlbmRvciksXA0KPiA+IC0JLmNhcmQubW9kZWwg
PSAoX21vZGVsKSwJCSAgIFwNCj4gPiArCS53bWFudWZhY3R1cmVyaWQgPSAoX3ZlbmRvciksXA0K
PiA+ICsJLm1vZGVsID0gKF9tb2RlbCksCQkgICBcDQo+ID4gIAkucXVpcmsgPSAoX3F1aXJrKSwJ
CSAgIFwNCj4gPiAgfQ0KPiANCj4gSXMgdGhpcyBtYWNybyB1c2VmdWw/IERvZXMgaXQgaW1wcm92
ZSByZWFkYWJpbGl0eSBvZiB0aGUgY29kZT8gSWYgbm90LCBob3cgYWJvdXQNCj4gcmVtb3Zpbmcg
aXQgKG1heWJlIGxhdGVyKT8NCj4gDQpCZWZvcmUgbm8gYmV0dGVyIHNvbHV0aW9uLCAgSSB0aGlu
ayBub3cgd2UganVzdCBrZWVwIGl0LiANCj4gQW55d2F5Og0KPiANCj4gUmV2aWV3ZWQtYnk6IEJh
cnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KVGhhbmtzIGZvciByZXZpZXdpbmcu
DQoNCi8vQmVhbg0K
