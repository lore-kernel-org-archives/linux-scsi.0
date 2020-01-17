Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D969C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF632083E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="lSbpmr7x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgAQNSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:18:08 -0500
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:26945
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbgAQNSI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 08:18:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8BKibgZ6DG6z+9lyy9ICx0OxZ8Cq6737Q4wcaeTtSCNFq7Cj78byFsUtkS6bJk+vTPGmsD+hboXYV6aq0wZsN3585fNrDXDuJE8f8KA/Z3QpIrwbRRGdkFhObTH+4azMbf/70VtpZWZeo77jxrU6dBDfkdgf+YLvKEOptnLT50VDWPSMNVFFU0PDqFRpLjuOIZPXHcQFPXp67siEtaAWJH0Qxl/Wa3B7KnVvMl3Ujh41NGWYSoCZV6zsI+q4nU4PTycURPqr9LlICy1B/xBObz7Rmfc9tLMTJ4oe7yFbNPnaF7Iu+YEXnqAWliHEz5XgMH+ACp+VuRWwusXyws0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUTwsEhz2iHUJq4RHe5MxcStXRttumm3tumMl0wCzu8=;
 b=MRP6+zvvBAnScVvUkkzsZevId7YHqqu8fQaJ822loT7dpQ7ndoKiCAKx1/FVVVQzpXVYOs+69Pm0bN3WE6Yzi+inHYeSHcpjHB6kaKNo6w2d12vCFSzsLcjSWFZHoHdZ5+T+xDuTmyfAGG/gXiHimwoiCXcPuRp+Vgn+reaAAPRG1zGyV6+zoeRpLmfL1uV0d1s5BIaaPkH30P1AINFeJ3CevbM4lWjru89QTFbmkvF+TikSmhrZ3Kkw1cC1AMCRs86SXJFjXuPUZYLRadMe0hjFDZY5J9ZqLUeUFSDOOf9mRtw2MBz1JhICIwaaoGZDthEJujmvq4cHQeruOvyRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUTwsEhz2iHUJq4RHe5MxcStXRttumm3tumMl0wCzu8=;
 b=lSbpmr7xVYHgD/zPeSoSkhbdrS/tY4wnTRDJEXAteQTFTp73W58Mn7dQdHBLnpX8eqqIG+M5PJvG0Gnm6f1R31v9zuBbxKhfzbMXqwKQH2M/gQS6aREJBjLdndGUffEZepVCDrxenk0dU24gd+mlN+mt4eUVrhIYuPIkVM1sCDY=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB6068.namprd08.prod.outlook.com (20.176.179.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Fri, 17 Jan 2020 13:17:53 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.021; Fri, 17 Jan 2020
 13:17:53 +0000
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
Subject: RE: [EXT] Re: [PATCH v2 7/9] scsi: ufs: Add max_lu_supported in
 struct ufs_dev_info
Thread-Topic: [EXT] Re: [PATCH v2 7/9] scsi: ufs: Add max_lu_supported in
 struct ufs_dev_info
Thread-Index: AQHVzOrtNlVvpxxrsUOf76PHI/iylKfu1caQ
Date:   Fri, 17 Jan 2020 13:17:52 +0000
Message-ID: <BN7PR08MB5684F7534F526793297BE673DB310@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-8-huobean@gmail.com>
 <3332e2a9-f720-4127-af57-afb6cccef9a2@acm.org>
In-Reply-To: <3332e2a9-f720-4127-af57-afb6cccef9a2@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWMyNjYzNTljLTM5MmItMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxjMjY2MzU5ZC0zOTJiLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE1NDAiIHQ9IjEzMjIzNzQwNjcwNjczNjMwNyIgaD0ib2ZnUUhVTGMxM2oyeFZkNXJZV01nTUJ4MlI4PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62749efc-3dfb-4e37-ff0b-08d79b4fa8d1
x-ms-traffictypediagnostic: BN7PR08MB6068:|BN7PR08MB6068:|BN7PR08MB6068:
x-microsoft-antispam-prvs: <BN7PR08MB606817D12605B418347A0041DB310@BN7PR08MB6068.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(81156014)(86362001)(71200400001)(26005)(76116006)(7696005)(6506007)(8676002)(81166006)(9686003)(8936002)(110136005)(5660300002)(66556008)(316002)(66446008)(66476007)(33656002)(478600001)(7416002)(54906003)(52536014)(186003)(4326008)(64756008)(2906002)(55016002)(66946007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB6068;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hxw1rpKhX9mOZrHNnJuuPYBPupd1oQeTy0yxJkcNExABh9CIm5RyPGZIXaM0KWMeNYXqrjekOTIf0aHNwXfvq+2nvdkH2hoG3z8hMso5gU3GqVGK3ByofkqlGlRrGXrEnT7vk3oYa00Xz95usnxcaW/HtcyIoLYb921XBI+P09q0KHlgrMT81W/MX+GSTgpIN0H+kesbkEA0IUWhuboEhYXpBsR0L89qPV23vO2uxrox8yDhsyrxFk6D9OmoK6tVaonVpG+Gv5J6HtJRq8Fcscz2JWT1K+VLhobQIggtBUH/wnyVOvvPGavdjjTRO1aBwd5VOiMn1npsG2ewaheawD7CneVRdnwwx/BuWhEtyCcbDbBJ4Nx2FJWnzkW61ZRnCxYamLJmPn2hdmjRbuW1o21oDU+hsFHVF/ZiL4g0lvlDIRZixKOdYTAeb+CVzq7dG4QOl+fYtpKXPPhD1ze5Zi4nvLI2TFTx/oIQ7/mPMTHnxJgDQZobXrTKXABGC6DX
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62749efc-3dfb-4e37-ff0b-08d79b4fa8d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 13:17:53.0242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jkMqrZRi4wJWrQ58N5KT9jq+2gn49h/hUSpZYAJTrPO8PY18yoUy7T+RHkWDxIcJQp6Jdsk0z653PEpCF78Hnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB6068
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiA+IEFkZCBvbmUgbmV3IHBhcmFtZXRlciBtYXhfbHVfc3VwcG9ydGVkIGlu
IHN0cnVjdCB1ZnNfZGV2X2luZm8sIHdoaWNoDQo+ID4gd2lsbCBiZSB1c2VkIHRvIGV4cHJlc3Mg
ZXhhY3RseSBob3cgbWFueSBnZW5lcmFsIExVcyBiZWluZyBzdXBwb3J0ZWQNCj4gPiBieSBVRlMg
ZGV2aWNlLg0KPiA+DQo+ID4gUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2No
ZUBhY20ub3JnPg0KPiA+IFJldmlld2VkLWJ5OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1
cm9yYS5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCB8IDIgKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oIGluZGV4DQo+ID4gZmNj
OWI0ZDRlNTZmLi5jOTgyYmNjOTQ2NjIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vm
cy91ZnMuaA0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLmgNCj4gPiBAQCAtNTMwLDYg
KzUzMCw4IEBAIHN0cnVjdCB1ZnNfZGV2X2luZm8gew0KPiA+ICAJYm9vbCBmX3Bvd2VyX29uX3dw
X2VuOw0KPiA+ICAJLyogS2VlcHMgaW5mb3JtYXRpb24gaWYgYW55IG9mIHRoZSBMVSBpcyBwb3dl
ciBvbiB3cml0ZSBwcm90ZWN0ZWQgKi8NCj4gPiAgCWJvb2wgaXNfbHVfcG93ZXJfb25fd3A7DQo+
ID4gKwkvKiBNYXhpbXVtIG51bWJlciBvZiBnZW5lcmFsIExVIHN1cHBvcnRlZCBieSB0aGUgVUZT
IGRldmljZSAqLw0KPiA+ICsJdTggbWF4X2x1X3N1cHBvcnRlZDsNCj4gPiAgCXUxNiB3bWFudWZh
Y3R1cmVyaWQ7DQo+ID4gIAkvKlVGUyBkZXZpY2UgUHJvZHVjdCBOYW1lICovDQo+ID4gIAl1OCAq
bW9kZWw7DQo+IA0KPiBUaGVyZSBpcyBhIHN0cm9uZyB0cmFkaXRpb24gaW4gdGhlIExpbnV4IGtl
cm5lbCBjb21tdW5pdHkgb2YgaW50cm9kdWNpbmcgc3RydWN0dXJlDQo+IG1lbWJlcnMgaW4gdGhl
IHNhbWUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2VzIHRoZSBmaXJzdCB1c2VyIG9mIHN1Y2ggYSBzdHJ1
Y3R1cmUNCj4gbWVtYmVyLiBJIHRoaW5rIHBhdGNoIDgvOSBpcyB0aGUgZmlyc3QgcGF0Y2ggdGhh
dCB1c2VzIHRoaXMgc3RydWN0dXJlIG1lbWJlci4NCj4gUGxlYXNlIGNvbnNpZGVyIGNvbWJpbmlu
ZyBwYXRjaGVzIDcvOSBhbmQgOC85IGludG8gYSBzaW5nbGUgcGF0Y2guDQo+IA0KVGhhbmtzLCBJ
IHNwbGl0IGl0IGluIG9yZGVyIHRvIHJldmlldyBlYXNpbGllci4gSSB3aWxsIGNvbWJpbmUgdGhl
c2UgdHdvIGludG8gYSBzaW5nbGUgb25lIGluIHRoZSBuZXh0IHZlcnNpb24uDQoNCi8vQmVhbg0K
DQo=
