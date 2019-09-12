Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0F8C4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38A132084D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="B36vhY+0";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="R0FTfpFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbfILNxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 09:53:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7748 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732299AbfILNxS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 09:53:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CDnM4m003718;
        Thu, 12 Sep 2019 06:53:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=J3YbIIthwfgRkJjdLVIuac4mim5TXrrNzirayeoHY0c=;
 b=B36vhY+0/WDxBbN0JxiD86rCdIAhRxgFC0X/K44esb6CWeajUbJ5JX9cyAFhPxHE4LvP
 /94dwsHOh6t9k4eni+eBDiJ3Afpx+JmOZSNNXOnawxD0k8gNXCGwtpEHvmZAmp4yGeBw
 Z1ndxU5oa3d3fVANY1VbAvuDYjPeqb0f7qTwoP5SmBjEySIeovUvOk1Si0z3upSBZ/B8
 2bFGKdhlyqaAEP79R5wsMEpIcnD/uVOJD21F/tCfOc890Vy8BZjB4EPEPT/GmgLfE6OQ
 GHRVHbRdwO2TFpWri3c+zwdvHIkEjUSGInFqRErg+66tG5IQ9c0dnoLBmdPhY3c1QrX9 IQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkfhj3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 06:53:06 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 06:53:05 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.52) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 06:53:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNNoFlLmE4ftySbjEaqsqdPlgHrZ4pS3pwArsG6looIcEw9iowVpU/D6gxsoMWi0IYn3iVSM8XfupHhYUuyHDTy7TrojoElHsPcdchLrWyLWH4JaGbBwfk+GpkPUr9Wn+XS5ihM98AIMeRs7MTRzPnZcTUGm+z9NuiJv/d5Osjz4nEO5BSBUE9M6/wpjTTZMlBQGezg/k3fOr0bLWQ8I3OSRJDMKAWXRFVYOHdh/+IWth0KQClIGCO3BTHndXs1MeJZHSGxNXykCRCqSxyXNw0acnSM2DikBSn2ImNhbU6JS6a4qeySqGWxOkw+aUfgpGVbCile1P5FxmtlpkEatdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3YbIIthwfgRkJjdLVIuac4mim5TXrrNzirayeoHY0c=;
 b=brJfVUEl4dMyNZg5KsZiRAjZg/UiLscNQSLjbO0HXjjAwPILzI4Cqk+KnozxW+Ub9lCfVKxHKzODOdIiDYx80iX51hiUc9e4euu0s/ftg1ahmFSgQGT/y7SiKvgWgaH9yW6unDHfqMcUAs5iubUrwPR41tn38jfIxNQQYb8iv/SqzPtTFyCVjfrgnevRMCUBdg1uU0JhsyzHd7PgO20WpSPAhaD+ir+K9uXVKiSRm5Bm/vTwBZpWxjndzND477mYi1WMaHlMf+ii7PKqsC5pl/fLawsaaRVzY8xYq+rKytf4hOyQSnB9WDPTaYlqXMAugTJFnl0XC3q0clWMon6DNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3YbIIthwfgRkJjdLVIuac4mim5TXrrNzirayeoHY0c=;
 b=R0FTfpFu+Y55zWDktlm7dW2K0G7fyyd22vUda/3jHm+qQ7waioXNJCxUoaRxsY9Ne3E21/RvjKQQIYNJyPcgRu5Yi+VQ7XfHHskjdcPaYWnwFok0lgv6DqbhfxHp0K+f4vdhEkWrDLOomUqHLDtOLwZa/j/3vqPhwd4rnEzq3FU=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2416.namprd18.prod.outlook.com (20.179.80.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Thu, 12 Sep 2019 13:53:03 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933%7]) with mapi id 15.20.2241.018; Thu, 12 Sep 2019
 13:53:03 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH 0/4] scsi: qla2xxx: Bug fixes
Thread-Topic: [PATCH 0/4] scsi: qla2xxx: Bug fixes
Thread-Index: AQHVaSwr0bslRuztKEW/Y88ikYpEhqcoD3QA//+tKwA=
Date:   Thu, 12 Sep 2019 13:53:03 +0000
Message-ID: <B39B0F4F-3439-4313-A808-578047F1B93A@marvell.com>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
 <8774334a-b1e7-1a5e-0da3-82db68f963b6@acm.org>
 <20190912133605.age2zo7jxdbe4jiq@SPB-NB-133.local>
In-Reply-To: <20190912133605.age2zo7jxdbe4jiq@SPB-NB-133.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
x-originating-ip: [67.79.99.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36179579-a164-4dbd-20b0-08d73788883e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2416;
x-ms-traffictypediagnostic: MN2PR18MB2416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2416EE9A0389C273A29ECA8ED6B00@MN2PR18MB2416.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(199004)(189003)(66446008)(53936002)(76176011)(86362001)(25786009)(33656002)(102836004)(256004)(316002)(99286004)(14444005)(229853002)(110136005)(54906003)(6506007)(6436002)(53546011)(6512007)(71190400001)(58126008)(71200400001)(66066001)(2906002)(6486002)(478600001)(486006)(7736002)(14454004)(4326008)(36756003)(476003)(446003)(305945005)(186003)(3846002)(8676002)(6116002)(81166006)(2616005)(6246003)(81156014)(8936002)(26005)(91956017)(66946007)(76116006)(66476007)(66556008)(64756008)(107886003)(11346002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2416;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H/oGcL8BHonZmGwYsltizykHet1pcXl+z/7dbhDYrjziwWiXpCnnc/bH3cq/Grswr3o574mqz5cAranRNyJyoS3PEkyYdfylXriwPYXjJoS9E8utW3uFkfYdarRGC6P5esWHENO9PfdUcpd+K+74p9zKaCNjXvB1+qECm7veErktfYa4ODfxozvng8wrGfx31CIsc7KhD5G6N5/1QD5+g90NI/2Ws0gJZbLmUI8WDCt4IMLWfDm6N+Ob5XrSYM0VF0A9+T5Ry+bOCYoHmQsuK+eRdfj4GByOlJqd211v6T7qUrl1DCgV551aEjz9hens1Vlp1sqaowJCRCcoEULfCAQI9pWhtw+CcSq1hEjJcEcl4zagLNTL7ll7h6iCH/AzOwRnoLMFKcm6C3Xv+XG8LCrs7b+cDuyTsuf95sml6l4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB7E145E87035243B704BE59F849CB32@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 36179579-a164-4dbd-20b0-08d73788883e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 13:53:03.4988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IfvowNGlQ44TQ898qSUaAQSOWBu2iEmZn9guWJ2GANSs8DKuOZfAoe6cToDvtf6FbigHupVw3SEf7Alh2/vmgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2416
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_06:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkaW5nIENvcnJlY3QgUXVpbm4uIFBsZWFzZSB1c2UgInF1dHJhbkBtYXZlbGwuY29tIg0KDQpX
ZSdsbCB0YWtlIGEgbG9vayBhdCB0aGUgc2VyaWVzDQoNCu+7v09uIDkvMTIvMTksIDg6NDkgQU0s
ICJsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgUm9tYW4gQm9s
c2hha292IiA8bGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIHIu
Ym9sc2hha292QHlhZHJvLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIFNlcCAxMiwgMjAxOSBh
dCAwNjozNzoyMkFNICswMTAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQogICAgPiBPbiA5LzEy
LzE5IDE6MzkgQU0sIFJvbWFuIEJvbHNoYWtvdiB3cm90ZToNCiAgICA+ID4gVGhpcyBzZXJpZXMg
aGFzIGEgZmV3IGJ1ZyBmaXhlcyBmb3IgdGhlIGRyaXZlci4NCiAgICA+ID4gDQogICAgPiA+IE5v
dGUsICMxIG9ubHkgZml4ZXMgdGhlIGNyYXNoIGluIHRoZSBrZXJuZWwuIFRoZSBjb21wbGV0ZSBm
aXggZm9yIGNsZWFuDQogICAgPiA+IEFDTCBkZWxldGlvbiBmcm9tIGluaXRpYXRvciBzaWRlIGlz
IGluIHdvcmtzIGFuZCByZXF1aXJlcyBhIGRpc2N1c3Npb24uDQogICAgPiA+IA0KICAgID4gPiBB
cyBvZiBub3cgaW5pdGlhdG9yIGlzIG5vdCBhd2FyZSB0aGF0IHRhcmdldCBubyBsb25nZXIgd2Fu
dHMgdGFsa2luZyB0bw0KICAgID4gPiBpdCwgdGhhdCBpbXBsaWVzIHVubmVlZGVkIHRpbWVvdXQu
IEl0IG1pZ2h0IGJlIGZpeGVkIGJ5IG1ha2luZyBMT0dPDQogICAgPiA+IGV4cGxpY2l0IG9uIHNl
c3Npb24gZGVsZXRpb24gYnV0IGl0J3MgYW4gaXNzdWUgSSB3YW50IHRvIHJhaXNlIGZpcnN0DQog
ICAgPiA+IGJlZm9yZSBtYWtpbmcgdGhlIGNoYW5nZS4gV2hldGhlciB3ZSBuZWVkIGltcGxpY2l0
IExPR08gaW4gcWxhMnh4eCwNCiAgICA+ID4gZXhwbGljaXQgb3IgdXNlIGJvdGguDQogICAgPiA+
IA0KICAgID4gPiBBbHNvLCBhbiB1bnNvbGljaXRlZCBBQlRTIGZyb20gYSBwb3J0IHdpdGhvdXQg
c2Vzc2lvbiB3b3VsZCBzdGlsbCByZXN1bHQNCiAgICA+ID4gaW4gQkFfUkpUIHJlc3BvbnNlIGlu
c3RlYWQgb2YgZnJhbWUgZGlzY2FyZCBhbmQgTE9HTyBFTFMsIGFzIHNwZWNpZmllZA0KICAgID4g
PiBpbiBGQ1AgKDEyLjMuMyBUYXJnZXQgRkNQX1BvcnQgcmVzcG9uc2UgdG8gRXhjaGFuZ2UgdGVy
bWluYXRpb24pOg0KICAgID4gPiANCiAgICA+ID4gICAgV2hlbiBhbiBBQlRTLUxTIGlzIHJlY2Vp
dmVkIGF0IHRoZSB0YXJnZXQgRkNQX1BvcnQsIGl0IHNoYWxsIGFib3J0DQogICAgPiA+ICAgIHRo
ZSBkZXNpZ25hdGVkIEV4Y2hhbmdlIGFuZCByZXR1cm4gb25lIG9mIHRoZSBmb2xsb3dpbmcgcmVz
cG9uc2VzOg0KICAgID4gPiANCiAgICA+ID4gICAgYSkgdGhlIHRhcmdldCBGQ1BfUG9ydCBzaGFs
bCBkaXNjYXJkIHRoZSBBQlRTLUxTIGFuZCB0cmFuc21pdCBhIExPR08NCiAgICA+ID4gICAgICAg
RUxTIGlmIHRoZSBOeF9Qb3J0IGlzc3VpbmcgdGhlIEFCVFMtTFMgaXMgbm90IGN1cnJlbnRseSBs
b2dnZWQgaW4NCiAgICA+ID4gICAgICAgKGkuZS4sIG5vIE5fUG9ydCBMb2dpbiBleGlzdHMpOw0K
ICAgID4gPiANCiAgICA+ID4gRldJVywgdGhlIHRhcmdldCBkcml2ZXIgY2FuIHJlY2VpdmUgQUJU
UyBhcyBwYXJ0IG9mIEFCT1JUIFRBU0svTFVODQogICAgPiA+IFJFU0VUL0NMRUFSIFRBU0sgU0VU
IFRNRnMgYW5kIGluIGNhc2Ugb2YgZmFpbGVkIHNlcXVlbmNlIHJldHJhbnNtaXNzaW9uDQogICAg
PiA+IHJlcXVlc3RzLCBleGNoYW5nZSBvciBzZXF1ZW5jZSBlcnJvcnMuIElJUkMsIHNvbWUgaW5p
dGlhdG9ycyByZXF1ZXVlDQogICAgPiA+IFNDU0kgY29tbWFuZHMgaWYgQkFfUkpUIGlzIHJlY2Vp
dmVkLiBUaGVyZWZvcmUsIGEgdGltZWx5IExPR08gd2lsbA0KICAgID4gPiBwcmV2ZW50IGEgcGVy
Y2VpdmVkIHNlc3Npb24gZnJlZXplIG9uIHRoZSBpbml0aWF0b3JzLg0KICAgID4gDQogICAgPiBI
aSBSb21hbiwNCiAgICA+IA0KICAgID4gSGFzIHRoaXMgcGF0Y2ggc2VyaWVzIGJlZW4gcHJlcGFy
ZWQgYWdhaW5zdCBMaW51cycgbWFzdGVyIGJyYW5jaCwNCiAgICA+IGFnYWluc3QgTWFydGluJ3Mg
NS4zL3Njc2ktZml4ZXMgb3IgYWdhaW5zdCBNYXJ0aW4ncyA1LjQvc2NzaS1xdWV1ZQ0KICAgID4g
YnJhbmNoPyBJJ20gYXNraW5nIHRoaXMgYmVjYXVzZSBzb21lIHBhdGNoZXMgaW4gdGhpcyBzZXJp
ZXMgbG9vayBzaW1pbGFyDQogICAgPiB0byBwYXRjaGVzIHRoYXQgYXJlIGFscmVhZHkgcHJlc2Vu
dCBpbiB0aGUgNS40L3Njc2ktcXVldWUgYnJhbmNoLg0KICAgID4gDQogICAgPiBUaGFua3MsDQog
ICAgPiANCiAgICA+IEJhcnQuDQogICAgPiANCiAgICANCiAgICBIaSBCYXJ0LA0KICAgIA0KICAg
IFRvIGJlIGhvbmVzdCBpdCB3YXMgcHJlcGFyZWQgYWdhaW5zdCBuZXh0LTIwMTkwOTA0IGJ1dCBp
dCBhcHBsaWVzIHRvDQogICAgNS40L3Njc2ktcXVldWUgY2xlYW5seS4gVGhlIGZpeGVzIG1hZGUg
dHdvIHdlZWtzIGFnbyBsb29rIHByb21pc2luZyBidXQNCiAgICBhcmUgcmVsYXRlZCB0byBzdHVj
ayBQUkxJIGFuZCB1bmhhbmRsZWQgUlNDTiB3aGlsZSAjNCBpcyByZWxhdGVkIHRvDQogICAgc3R1
Y2sgUExPR0kgYWZ0ZXIgcWxhX3Bvc3RfZWxzX3Bsb2dpX3dvcmsuDQogICAgDQogICAgVGhhbmsg
eW91LA0KICAgIFJvbWFuDQogICAgDQoNCg==
