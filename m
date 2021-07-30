Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89AEC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 18:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA09960F4A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 18:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhG3SRK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 14:17:10 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7816 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhG3SRK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2021 14:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627669024; x=1659205024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LDzckBCfi1VbI2ZIM1Wrb3WoSKNYIJOnyyut3NaC0dQ=;
  b=jfNfuzLEfY4X00uAygU/R1aPkimb8Zi7SOAtDnasWhliPu91rpgLfPmx
   EyN4ZLle09ChUsJQ1XmLO6NRUceI0D5XAmMFR8O64UAJI2AzC3TiMQVvF
   XnimkgowfS3J081hgktM+o9VCjBHvZx72kRUk+QTTrcXMpNYMhym+yC4u
   O3tqLYlJGmTHaCCaOgYpUJMIPSre6HYAVRBLWTNzI4c2ezl+92BwlslJk
   +SsNuRsfy/Bx7jsyyPhk4zVww/m2ECdvOG8q/V1xsYGosufXTg7/Y4iC9
   DzPjV/g0sQ7QVtGoreLr5iZ2ZRfTBglKfzeecMRj2w7fa6M5Sf37yjPRD
   A==;
X-IronPort-AV: E=Sophos;i="5.84,282,1620662400"; 
   d="scan'208";a="175921913"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2021 02:17:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nw2KxpBY2JHqqYPERwdm1yMrnv0a3Lnp1ErVimru3BcAhDeO1JgneTLYl1yfe4TcAWhqWJrfq13WF1HOJ66FMMPQjLeNu3/Mtwb+OoqO5LxDcAZBPIQSs7JxSVQxJf34KozBi5vCCWZvoRfbGBqWmavqYCAzaU2cHd/NrekHvW5V3Rw1P8P6OZBgXlA0qPabiqYX+TjHxQFHRbKa8czusM+pu1WPaIOyxyl2nhdtAscXUaxvYwJktmqnQdCM0gzfERrhN9r7AWmgkfgjVosjrnpDyuY/e3l9GbMOhozUmh2dyhs6PGRJMTve7gwUYzvO8ksRpXo8ehRwG6+NXvQlpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDzckBCfi1VbI2ZIM1Wrb3WoSKNYIJOnyyut3NaC0dQ=;
 b=WZr2S91f41p/gGl/UrcYN/a4iQsEjFFn8G6fYOIOqFalTmnPLc3BuXSmCWY2UIiTEiatXPz92ywnxBxzhVrak3YXu80iV1s7yQi/EtoDWcDXz3oGYdxLWCZFi7V1G4M/+bwPczhFvyt/YKWy9ydPR0LtHj7XnOoupwokq157KsPM9isRJ1sFWYwrQUW2Gkwatd5LTjPYqcpVDwOSrlU5mDVL3e/lQZt1/BiHzC0vHR0v9M0JwU5f/iXivLRUPbTagIcbJ48u9DPTQjssPtX76gaqJL29LA6VW0fITG/8XMgNKQfjAH2qORx2vcVpJWYl/RHbtSDOQJjY1pwkqbYp4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDzckBCfi1VbI2ZIM1Wrb3WoSKNYIJOnyyut3NaC0dQ=;
 b=kUbmd8LUz2Av+3XE+jalgHaTlDH6fNStHYrtgwy+ToYQRRfpTV/nMJo1NzbEQvv5fD4KDemP7/aj4URj1OHEiKTN1tDxSMNJNy3Sv5MlNLdxF+aSaUDn7IAtz++Oi8lrzAgiYOWfLBdgeOoYco+5ix/RJ04a8bhY2JAJQro7z+8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5946.namprd04.prod.outlook.com (2603:10b6:5:161::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.20; Fri, 30 Jul 2021 18:17:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 18:17:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Vincent Palomares <paillon@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Bjorn Helgaas <bhelgaas@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: RE: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
Thread-Topic: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
Thread-Index: AQHXg0/zB35JV1w98kepLuUOEdMo5KtZg7bwgAIu/ICAACRfoA==
Date:   Fri, 30 Jul 2021 18:17:00 +0000
Message-ID: <DM6PR04MB65756833EE4ABEEA1144B670FCEC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210728012743.1063928-1-paillon@google.com>
 <DM6PR04MB6575579560F7CB1B71103F28FCEB9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1630ebc3-b40e-31e3-1efa-67717e186b0a@acm.org>
In-Reply-To: <1630ebc3-b40e-31e3-1efa-67717e186b0a@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bffbbabd-d52e-4a7e-2b33-08d95386397f
x-ms-traffictypediagnostic: DM6PR04MB5946:
x-microsoft-antispam-prvs: <DM6PR04MB5946E5D80027B4E3E1E3A9ECFCEC9@DM6PR04MB5946.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YTbQ0/d6i2L3IjSY5KTFerqoTXdCBP9ElqxYvpe1xXeiUCBxzoQPtMzob2TAeRFSsJ/4AS/tpWjcrZduj6LtDFYaDHssktf57yQtQyYiwryjjfh8qmo4Ka31xQcwySrLszJ2+5Pq06MqEWsJuctKGBif8l9EYAAdtjg+oPmSf5mwwiz6vknMlP0ZNMOkV8a3yRh9WujqXM55Isi9gaDZsOfSCgO3rclHpiGHq/cNviOw726tq5LR8RNTyRyVgdaZM+f3+e015QgZcWrDseV+q2etwHDjGKFQ+U6e78HsjFRhp9i1g0zXq6TH0BwuWosliXh1NR9x78jYz8UM0ecpOg1bV7MRWdyqMlFxS/dW0dXVsbGL+TuFL7TEcSfhP+wHgdFf/aTSCx6q6GSoZ+JDRSoR8T2aKaK3khXeVqxBz8DPkyiN04+1k5s3QYWESUAU2N8CYghnkejPTSqq9Gf5++oEOwqlOViD58Pq5Z9B+wK+W0Dsu4/Z27NNMwIPDO+Z5k4173TD1FEcKQ0wL8GMvGLioPhYjfQNDJYE6GXDb4HV5pmGgTuXZeRB7/PW/SkOwntv2lc29jfRxYpOuhBW6U3q7hssWwGbadR+Pt8Mt31pROEaVqomfJxO81D4ae5v94rPXhYY4xtnyWOYJ8FgpR2feLyohj/te7o9UH1/9Xm2AUc5+ZBPuwTD4G6mIveopMftUjGOgn+yjyP+qhC+PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(64756008)(66556008)(66476007)(66946007)(26005)(186003)(76116006)(4326008)(15650500001)(71200400001)(66446008)(6506007)(33656002)(83380400001)(478600001)(53546011)(54906003)(7416002)(55016002)(9686003)(8676002)(110136005)(316002)(8936002)(38100700002)(5660300002)(86362001)(52536014)(2906002)(38070700005)(7696005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTNKaGt2WjVUWFlmS1JEakV0dGtkS2g2RFVKaWNxNUt6Y0ZXeWxrc0Nqc2Fa?=
 =?utf-8?B?TUl4V3RJNkhpSUZ3QksvSHVjRnlhMVVpeWVXNzBaWXhsZjZqRUxYYkZlS1JP?=
 =?utf-8?B?WURoL2FmM2FKT1NDd0YyM2xxU29PcVZIMjFydmx5ZTdMYlBnME5vL3gzVTBq?=
 =?utf-8?B?bTAwNExMaXJOOUozUGxJSURGQzUwL0lkNG5BclZpaU9CTGlKUHpDNUhHazB1?=
 =?utf-8?B?RjVIV1RBenJFMW1uczg5eXVhZGQ1cmZzNWtJeitkVzQ3aHA2RzNKRm51SGRB?=
 =?utf-8?B?bFd0RTd1TGlCZjdKVCt2OVUrSnJLRFUzY1BVVXVGZG41bXk1NVpwamlnM3Bn?=
 =?utf-8?B?bDR5Q3dmZVdTeEZaL2EzU0xwUWNjR1kxZUYvbW9IMDEyMU5qR245S2llZlAv?=
 =?utf-8?B?eHQrL0xtQXFBU0d6R0oySXNKN3hSVVpXY2VyRmZ3RFArdUVvOXAwL2E3UHBp?=
 =?utf-8?B?cDNtZzAxYTBOd29nNGh4Z0RjWi8xQmNZTjdWVTEyLytxeVYzazVhRTZrWVpL?=
 =?utf-8?B?OEdGWXpYUGo4ampDRVd0SXQyMmhNYmozMEpYeDc3MUlQaW50b0ZuMHZ5YSt3?=
 =?utf-8?B?UXlkV1ZGQTJNMXNqNUxkSFkrdVBubk12K1N2bFg0Q3V1MEtYTTNNVWI4UytP?=
 =?utf-8?B?ZTliRmlzb001QW5JeHl0WHFXWUNndTRQc2RQYzZNOE1NU054ZlppOFdJSUd2?=
 =?utf-8?B?MDBtSVoremxFV0plVlFUZUtDNGpYUU5wREY4ZjZucHJYY3hkK2ZtVE9uWXJy?=
 =?utf-8?B?TWcxY0RMRkVnQTNOMWt0MVZYaTlMWEJMUXpNTTZER2MzcmY4RVBxWnFYNVp3?=
 =?utf-8?B?V0Q0ZDU5ZzNiKy9GY2doNzdGTkk3eDVESC85Q01sT0p1amVTcjVwcUlxd1pE?=
 =?utf-8?B?b1NzaE00L3h1RkxLTXdQazR0NkRWSXJ0dXBEemZKY2oyOTNPbUQ3aHV3K1pE?=
 =?utf-8?B?YUpaMWpJUXpjRnh5d0pYb1YzTnJYWGNzdSsvRXZ4UWE0OXJtYnpUcERJWU1u?=
 =?utf-8?B?MmZTU090ajVqK0NQS2MyTjhVVzM0TXM2UHBkTG9BYUoyUW1OWjdGc0IyNFRI?=
 =?utf-8?B?NW56TlVtMDRqYlJIc2p5Sis0TVdVcVNLRTh6OHh3UU8zdGk0TWxoeDBPOWlK?=
 =?utf-8?B?ZGsrYVJHSWFWb1VOay85SEVMS2RTWGE5TmNPSlZvdkxudHAzN1hlRWFQQmpI?=
 =?utf-8?B?YisvT3dXN0QwTVZCUHk1c1Ewc2thaEdoa25ITEZDQzNkV1lZc2NIZ0xDUnVM?=
 =?utf-8?B?MGVsNWdaeVFBQXdHb3hxRG9mS29CNEJtQzI5ekw2dE9iUG1GUDNTbUhCM3R0?=
 =?utf-8?B?OEdOeEVuczhHUjJrWGwrR0pnZmpKa2F3NElJRXgwcGs1Q1ZaZW80STF6VEpi?=
 =?utf-8?B?V3RSOWtPaWsrR3hEZ1pPNktpZHhaYnIwL0YyZXhVeEhKTGp2cHVMUGZ0RmRL?=
 =?utf-8?B?cXZsL29wWmVkQTVlWXVZSlVHTTUyU2o1TThrSWN3NjhWNXJYa0I2amR3TStV?=
 =?utf-8?B?ZW44b1hlLzhUNVR0dW42d3NzTnhLK2FkWDh3S1BjWGhhUnNlOHFXRjBxck00?=
 =?utf-8?B?Nm5mZ1FyWmxpbm1DekNRcHhsU05KbmtleTJodFRnSFFuZWRlR2w3cHFwY2tX?=
 =?utf-8?B?TDdiU0RRV2dFQ1hxLy9mWGRCczJLUUZ0b3h5dGIycDZzOTRXN0F5OEdyMUFZ?=
 =?utf-8?B?b0YvNVlwaEhqZHVCdnVhQXVhQ3hyUExPVVR2elY2WGVaZ3pYQVNNand4NXZH?=
 =?utf-8?Q?zIriKn6WEjN4ZfEkL0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffbbabd-d52e-4a7e-2b33-08d95386397f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2021 18:17:00.3719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TspN63wTXhPmVVR/wARAzebM52MsuWcsQaC6PO/L6MAok+A0mCnRAerKdINHEVZhq93n/jvH/ocAP5NplPrCeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5946
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA3LzI4LzIxIDExOjQ4IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBWaW5jZW50IHdy
b3RlOg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPj4gaW5kZXggYjg3ZmY2OGFhOWFhLi45ZWM1YzMwOGEw
ZWEgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPj4gKysr
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+PiBAQCAtOTYyNSw2ICs5NjI1LDcgQEAg
aW50IHVmc2hjZF9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHZvaWQgX19pb21lbQ0KPiA+PiAq
bW1pb19iYXNlLCB1bnNpZ25lZCBpbnQgaXJxKQ0KPiA+PiAgICAgICAgICBhc3luY19zY2hlZHVs
ZSh1ZnNoY2RfYXN5bmNfc2NhbiwgaGJhKTsNCj4gPj4gICAgICAgICAgdWZzX3N5c2ZzX2FkZF9u
b2RlcyhoYmEtPmRldik7DQo+ID4+DQo+ID4+ICsgICAgICAgZGV2aWNlX2VuYWJsZV9hc3luY19z
dXNwZW5kKGRldik7DQo+ID4+ICAgICAgICAgIHJldHVybiAwOw0KPiA+IElzbid0IGRldmljZV9l
bmFibGVfYXN5bmNfc3VzcGVuZCBpcyBiZWluZyBjYWxsZWQgZm9yIGVhY2ggbHVuIGluDQo+IHNj
c2lfc3lzZnNfYWRkX3NkZXYgQW55d2F5Pw0KPiANCj4gSGkgQXZyaSwNCj4gDQo+IE91ciBtZWFz
dXJlbWVudHMgaGF2ZSBzaG93biB0aGF0IHJlc3VtZSB0YWtlcyBsb25nZXIgdGhhbiBpdCBzaG91
bGQgd2l0aA0KPiBlbmNyeXB0aW9uIGVuYWJsZWQuIFdoaWxlIHN1c3BlbmRpbmcgd2UgY2hhbmdl
IHRoZSBwb3dlciBtb2RlIG9mIHRoZSBVRlMNCj4gZGV2aWNlIHRvIGEgbW9kZSBpbiB3aGljaCBp
dCBsb3NlcyBjcnlwdG8ga2V5cy4gUmVzdG9yaW5nIGNyeXB0byBrZXlzDQo+IGR1cmluZyByZXN1
bWUgKGJsa19rc21fcmVwcm9ncmFtX2FsbF9rZXlzKCkpIHRha2VzIGFib3V0IDMxIG1zLiBUaGlz
IGlzDQo+IHRoZSBsb25nIHBvbGUgYW5kIHRha2VzIG11Y2ggbW9yZSB0aW1lIHRoYW4gcmVzdW1p
bmcgTFVOcy4gVGhpcyBwYXRjaA0KPiBtYWtlcyBVRlMgcmVzdW1lIGhhcHBlbiBjb25jdXJyZW50
bHkgd2l0aCByZXN1bWluZyBvdGhlciBkZXZpY2VzIGluIHRoZQ0KPiBzeXN0ZW0gaW5zdGVhZCBv
ZiBzZXJpYWxpemluZyBpdC4gTWVhc3VyZW1lbnRzIGhhdmUgc2hvd24gdGhhdCB0aGlzDQo+IHBh
dGNoIHNpZ25pZmljYW50bHkgaW1wcm92ZXMgdGhlIHRpbWUgbmVlZGVkIHRvIHJlc3VtZSBhbiBB
bmRyb2lkIGRldmljZS4NCk9LLg0KVGhhbmtzIGZvciB0aGUgZXh0cmEgaW5mby4NCg0KVGhhbmtz
LA0KQXZyaQ0KDQo+IA0KPiBCYXJ0Lg0K
