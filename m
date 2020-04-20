Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FFEC3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 08:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFF821473
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 08:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eZTkOKTq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="feZwAkDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgDTIzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 04:55:46 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60811 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgDTIzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 04:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587372946; x=1618908946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7ENCpieTz65E3lirF+44Xaw7VKX5VeIuFJZo3xfPyHM=;
  b=eZTkOKTqW3eEUY+h4tuWCpP0WgLmFtpD+xKy5Mi5A0PYNUk954epxEZs
   sh+VvqSVfPXTMrqbE5eUJ/niFGJVregnJCdzsekSSaHjP6ElV7X3U6RRC
   USQiMzexsqjX+/lOb48I3liwP+PslwgUIChPRtfxDHxjiOW5IgtLEfmVt
   juAOEu3Qa/9Ib8SMB+IVuE87XDOo6x9sFC4jLTMnKbMaG3oCzOk5fxFA8
   1Q/fcw2nnKghkhHQz2ygClplLi1a2nTyJydl0B58gCQtgUW/KbD4JyZ+f
   ZbUNRUhKPBZjQ5w8XGsNXHkiIJ0wwN01aGExHsRwxcMChBFXQsKcj0Mkp
   Q==;
IronPort-SDR: CZNVYqYLHZvCCa36i7y0L1IWrXI4znSYJMN73D6DxZTfTI8+2NTDumciNnM+gEcm4EGqnQij8F
 +b0qHzk1wf2H2SDIOpAi1aLqkATdj4TgPNdWg0K4yyi6HXKv+1IIaMUUht16SVZBA6YLANxByS
 Mt5sYaiZ1AOQPqbpNGBqCuLAHeUm4tKcyiEwq0Oweh70jwOH56BhPnyJ3sHJmnyiOpM56My2NM
 vDjtl++Y571jQ5OvCDaN3YZXGkuTNdu7tA+Kk34k+Gy7wDVFN1rQUZkULLMorCo7dKfJO54lW6
 AwE=
X-IronPort-AV: E=Sophos;i="5.72,406,1580745600"; 
   d="scan'208";a="136004593"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2020 16:55:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHC5dMkAY5zWKEmdUyJ5cXcwh8PfyFYz2FY00Qw6AyLvvJ0Rvf7iE0j0k1OS3EXeO8qe3AU/G+P0yxwbYz4Zl/1xN3U/KDpd8vLsAXvFxui5S05TxTqJ9cQgw1slsJPJo0oxugygdTOq0y0aOuGDmqXje2SjmO4RNerotkWkMhNcTXb5c3WpPhqp5/5PM/BCXBIOWT3zK+y+7JHNJEouY+bGYmtGeWIPSxNlAFaKw8yA27T0RVNmgfotSsmT8DGKuZs049zGvllRAGKUUCm1IQLxUBuz9iQpRwbqOjEtmLrQDakaAGkI/hUKOimSHXRXlaR/UtO/yKlrzIBpOADfUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ENCpieTz65E3lirF+44Xaw7VKX5VeIuFJZo3xfPyHM=;
 b=MFaTlTUen8USkQwfKi81AUb+TAx8GeeXkm4yECpo+mC0v1QuNcPdEB9MBMLw3xFFMKgGKsE1tAl22TkP1CyAgIX9UXDWSo3LJzNqIEXFGy6935f68B6xWYmlYXcsTR/+s3NDiWla9cJh3xF21AFUE3oyJOnN8B2+3GP3QEnNYWXieYkmpnWHO/HvR1dLNWWtoS1nG3oiYlnmhwsQw242uPn2jNRzugUs+53GDWvmFEsAS7/Temy7dERxa6KlTYxuEbKfhgpaQUFQBdkgi9W2Him4R9zI99HHTAOjl5a5swKKE3dNshxyHb805L/gp+OQfm27KVbEl0OO1sP+O1gC3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ENCpieTz65E3lirF+44Xaw7VKX5VeIuFJZo3xfPyHM=;
 b=feZwAkDUSIsUHGyVC/VEJNkfExy0FEyOqoZtvIzzsBXf+61C61rbUD/Wf/6SHc6yvbim321P27/bUVNAGBdxYBfzje1E5WLThUUE/ZxIC0hbdvK+1Si3JyLCselZtZC2VynSeae58ooutL9A8nxPR3+izVVOJlTlv02WX5/JZXQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4733.namprd04.prod.outlook.com (2603:10b6:805:a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 08:55:42 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 08:55:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Thread-Topic: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Thread-Index: AQHWFOOBFbSRs7BAOkOiLBrzlbkq96iBrgCA
Date:   Mon, 20 Apr 2020 08:55:42 +0000
Message-ID: <SN6PR04MB46408CF4DD05DB9B48DFE412FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
 <20200417175944.47189-6-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-6-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0bc995dd-9bda-42b4-ea2f-08d7e5089b7b
x-ms-traffictypediagnostic: SN6PR04MB4733:
x-microsoft-antispam-prvs: <SN6PR04MB473356A7580FD048F7C235F0FCD40@SN6PR04MB4733.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(86362001)(7416002)(316002)(54906003)(110136005)(33656002)(81156014)(5660300002)(4326008)(52536014)(478600001)(6506007)(2906002)(76116006)(71200400001)(55016002)(26005)(66446008)(8936002)(64756008)(66556008)(66476007)(66946007)(7696005)(9686003)(8676002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FTsXLKjHAJT9hPSO6Qa4TxXgWcCdtUaYG9j+Wp3gQPJdUlYxXnNXEV+PBSlX27hIXd++hr5TwuVy+yifUKrzYdRkS9xystEqxV+kAJnXgb/AutAeIQel+VSwGFRrWYT9G7B897xEOrsiYTb6g6zRd1PFhJTKQbAM7UIzBZbZRsBoN899zL4IXDU56bWvXzxOCuMHzftx3rp2BIIVf7rPaIY0JrSCbqIWPHxhAvokzy1U7yCEUZA6/zDPJx1ActDdTB6nU0s0IylNM5wtmRNmbNxqfWA4TyfAN8T5E+CHzis4TzJW0xFobNXgbpOZjr00MM9cCU+/kSf9wFzt/K0oxv/X64zxPLhYPKZoL7q8GzXJumQjnjvGV/j/bsp9ljCGhCBQi2pYzF3YmdBy6GrCd/MUC0D6XW5bIaN2/B50etfDUSX1tab5/PrWICtK3FbG
x-ms-exchange-antispam-messagedata: f2peM62ZgmZuvIQqC2rivO9WXougPxhAShMrfrUSPAnMUmD4SeIgVfZ5k8pBwID0rBLxUNCrWnRmsslO5kG/UOboRNUqqshCUlqDJgny2sYmAWzyHcX+aMBGBD8W2tb5ZpYcy2QkPzLX+bMdUM4JZw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc995dd-9bda-42b4-ea2f-08d7e5089b7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 08:55:42.6243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8hu7uNwztGfTHpul0IKvuqCVMxSMCazodP5I2H9Ijg1V8xAFoxzzZJ+DdkFScecYrkP0LS5PzUYj4kWnUOsTEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4733
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gRnJvbTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4NCj4gDQo+IFNv
bWUgYXJjaGl0ZWN0dXJlcyBkZXRlcm1pbmVzIGlmIGZhdGFsIGVycm9yIGZvciBPQ1MNCj4gb2Nj
dXJycyB0byBjaGVjayBzdGF0dXMgaW4gcmVzcG9uc2UgdXBpdS4gVGhpcyBwYXRjaA0KVHlwbyAt
IG9jY3Vycw0KDQo+IGlzIHRvIHByZXZlbnQgZnJvbSByZXBvcnRpbmcgY29tbWFuZCByZXN1bHRz
IHdpdGggdGhhdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtpd29vbmcgS2ltIDxrd21hZC5raW1A
c2Ftc3VuZy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBz
YW1zdW5nLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgNiArKysr
KysNCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCA2ICsrKysrKw0KPiAgMiBmaWxlcyBj
aGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gaW5kZXggYjMyZmNl
ZGNkY2I5Li44YzA3Y2FmZjBhNWMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBAQCAtNDc5NCw2ICs0
Nzk0LDEyIEBAIHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3RhdHVzKHN0cnVjdCB1ZnNfaGJhICpoYmEs
DQo+IHN0cnVjdCB1ZnNoY2RfbHJiICpscmJwKQ0KPiAgICAgICAgIC8qIG92ZXJhbGwgY29tbWFu
ZCBzdGF0dXMgb2YgdXRyZCAqLw0KPiAgICAgICAgIG9jcyA9IHVmc2hjZF9nZXRfdHJfb2NzKGxy
YnApOw0KPiANCj4gKyAgICAgICBpZiAoaGJhLT5xdWlya3MgJiBVRlNIQ0RfUVVJUktfQlJPS0VO
X09DU19GQVRBTF9FUlJPUikgew0KPiArICAgICAgICAgICAgICAgaWYgKGJlMzJfdG9fY3B1KGxy
YnAtPnVjZF9yc3BfcHRyLT5oZWFkZXIuZHdvcmRfMSkgJg0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgTUFTS19SU1BfVVBJVV9SRVNVTFQpDQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgIG9jcyA9IE9DU19TVUNDRVNTOw0KPiArICAgICAgIH0NCj4gKw0KTm90IHN1
cmUgdGhhdCBJIGZvbGxvdyB3aGF0IHRoaXMgcXVpcmsgaXMgYWxsIGFib3V0Lg0KWW91ciBjb2Rl
IG92ZXJyaWRlcyBvY3MgYnkgb3BlbiBjb2RpbmcgdWZzaGNkX2dldF9yc3BfdXBpdV9yZXN1bHQu
DQoNCk5vcm1hbGx5IE9DUyBpcyBpbiB1dHAgdHJhbnNmZXIgcmVxIGRlc2NyaXB0b3IsIGR3b3Jk
IDIsIGJpdHMgMC4uNy4NCk15IHVuZGVyc3RhbmRpbmcgZnJvbSB5b3VyIGRlc2NyaXB0aW9uLCBp
cyB0aGF0IHNvbWUgZmF0YWwgZXJyb3IgbWlnaHQgb2NjdXIsDQpCdXQgdGhlIGhvc3QgY29udHJv
bGxlciBkb2VzIG5vdCByZXBvcnQgaXQsIGFuZCBpdCBzdGlsbCBuZWVkcyB0byBiZSBjaGVja2Vk
IGluIHRoZSByZXNwb25zZSB1cGl1Lg0KRXZpZGVudGx5IHlvdSBhcmUgbm90IGRvaW5nIHNvLg0K
UGxlYXNlIGVsYWJvcmF0ZSB5b3VyIGRlc2NyaXB0aW9uLg0KDQpQLlMuDQpUaGUgb2NzIGlzIGJl
aW5nIGV2YWx1YXRlZCBpbiBkZXZpY2UgbWFuYWdlbWVudCBjb21tYW5kcyBhcyB3ZWxsLA0KSXNu
J3QgdGhpcyBzb21ldGhpbmcgeW91IG5lZWQgdG8gYXR0ZW5kPw0KDQpUaGFua3MsDQpBdnJpDQoN
Cj4gICAgICAgICBzd2l0Y2ggKG9jcykgew0KPiAgICAgICAgIGNhc2UgT0NTX1NVQ0NFU1M6DQo+
ICAgICAgICAgICAgICAgICByZXN1bHQgPSB1ZnNoY2RfZ2V0X3JlcV9yc3AobHJicC0+dWNkX3Jz
cF9wdHIpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gaW5kZXggYTliOWFjZTlmYzcyLi5lMWQwOWMyYzQzMDIg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiBAQCAtNTQxLDYgKzU0MSwxMiBAQCBlbnVtIHVmc2hjZF9x
dWlya3Mgew0KPiAgICAgICAgICAqIHJlc29sdXRpb24gb2YgdGhlIHZhbHVlcyBvZiBQUkRUTyBh
bmQgUFJEVEwgaW4gVVRSRCBhcyBieXRlLg0KPiAgICAgICAgICAqLw0KPiAgICAgICAgIFVGU0hD
RF9RVUlSS19QUkRUX0JZVEVfR1JBTiAgICAgICAgICAgICAgICAgICAgID0gMSA8PCA5LA0KPiAr
DQo+ICsgICAgICAgLyoNCj4gKyAgICAgICAgKiBUaGlzIHF1aXJrIG5lZWRzIHRvIGJlIGVuYWJs
ZWQgaWYgdGhlIGhvc3QgY29udHJvbGxlciByZXBvcnRzDQo+ICsgICAgICAgICogT0NTIEZBVEFM
IEVSUk9SIHdpdGggZGV2aWNlIGVycm9yIHRocm91Z2ggc2Vuc2UgZGF0YQ0KPiArICAgICAgICAq
Lw0KPiArICAgICAgIFVGU0hDRF9RVUlSS19CUk9LRU5fT0NTX0ZBVEFMX0VSUk9SICAgICAgICAg
ICAgID0gMSA8PCAxMCwNCj4gIH07DQo+IA0KPiAgZW51bSB1ZnNoY2RfY2FwcyB7DQo+IC0tDQo+
IDIuMTcuMQ0KDQo=
