Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DEAC33CA8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24A402084D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="xRNgMX61"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgAMJ6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 04:58:55 -0500
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:65153
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbgAMJ6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 04:58:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOz/eEFrG1inWPOM1JJcLgsv4JBMX1suVKQn5dE4h65JIwvEWQOmtxS+piOe9RV+rTxdG42rbnc7R/ox0PUHn4vzHN/ORrAgGyi+AyGJ5nCSY2s+aQ1zPyT70HuxGR4ItL/WuNstqu/xIu6A+d86ZX2iXPKxCeqHUp/ZU7SkTT2/YOETchRBoWvqhlWsWQu15OtE1DQHqT3K6TWi5gvpC6IE2XgTPDYMLX64z3YjHO+7FdwDbSsVnQdJtbSSVMP5VYjfxSqDuNjpHrBB8qgR2/CVtm4JufQHn6IgRHhKMy5vk8CUnfQp1Ct1cFuGJLygkDGZlO0s7Ws94669nt421A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkzh2HqmbmY1jtwx3yTyry6Lixdo5GjU70EYVHBqcZI=;
 b=Kx8weRhF4MLXzGE3A5r2jRxXxjMcvBATMgwNZ3s/dfQ1wCn3z/YnWD6cDWeKDs5ROdG0dopFGZNxP5vZPRTeR313HMAHvKIC779BYOaXP/0K4T22cJ4Qq4+ujxpO82iZ0D9YJ75qLbz3ZcpO9Ao98q9edJJ1pX8tvw4DgrKIqMtqFrXul0QPL+Gfiv521T0Uy5ya8YQBYsIdA3ptVZF+I3iBR3cFB+5/4DBNiCfkUOh1jNIOA2WcF1CGYprQTY+tsC/XL/yIJ3XrV20ClqSH2uLpBTks29N65rwQJFWIrZKFDck2q6j+FJr67lzu1F/jwXU0in9pvRN9rwKdhQLHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkzh2HqmbmY1jtwx3yTyry6Lixdo5GjU70EYVHBqcZI=;
 b=xRNgMX619b8LJzLAVJHBEl9NVPl0K/FdIT5TIVK7aAYi7ACN50UsZDdntrXZL6g/OZ/LpHtIAZ0jVIRiZPqHE4IQJKYaNMWqebNus4AydKQ271avkxHpqK+iGyPf07zoviqISfWmnp8KjcVp1M9CjcfxNEJY4PXY1EWAPh4Nmew=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5089.namprd08.prod.outlook.com (20.176.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 09:58:52 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 09:58:52 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v1 1/3] scsi: ufs: fix empty check of error history
Thread-Topic: [EXT] [PATCH v1 1/3] scsi: ufs: fix empty check of error history
Thread-Index: AQHVwwrtYdyISOHmvEWfKtFqbPPmzqfoX2LQgAAGaICAAABC0A==
Date:   Mon, 13 Jan 2020 09:58:51 +0000
Message-ID: <BN7PR08MB568462931864FC928D262098DB350@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
         <1578147968-30938-2-git-send-email-stanley.chu@mediatek.com>
         <BN7PR08MB56841F049CEF89CD8F40B4E3DB350@BN7PR08MB5684.namprd08.prod.outlook.com>
 <1578908621.17435.18.camel@mtkswgap22>
In-Reply-To: <1578908621.17435.18.camel@mtkswgap22>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTQ5ZWNkZDY2LTM1ZWItMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw0OWVjZGQ2Ny0zNWViLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE3MjkiIHQ9IjEzMjIzMzgzMTI3MjU3NzA3MCIgaD0iR29mQVgwaU90MEJUTmtzY0FBenVqZFdncnhNPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3551af9-03c7-4af9-e0cb-08d7980f31df
x-ms-traffictypediagnostic: BN7PR08MB5089:|BN7PR08MB5089:|BN7PR08MB5089:
x-microsoft-antispam-prvs: <BN7PR08MB508900ADDE6689A1C0C35D9DDB350@BN7PR08MB5089.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(189003)(199004)(4326008)(54906003)(71200400001)(86362001)(8936002)(9686003)(55016002)(8676002)(7696005)(81156014)(2906002)(6916009)(66946007)(33656002)(66556008)(76116006)(66446008)(64756008)(66476007)(478600001)(81166006)(7416002)(5660300002)(6506007)(52536014)(26005)(186003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5089;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zrUJ3uxkhrShR1eBkUvsN2fwy2LNolvKQwC/GgTAkgQx2mUepfSOkeoDlFo3aVnKjUkL+2JEe6Eo84Gn+JfRvE0Dxrav2q4nlJpGR6tBGyO9mP81/I2KvyTRWCIov03SH09KbLDtyupnk+JiOOy9GTHvkkSwdSBqCc6ZnRZP4Vzvk36cbGglo/nqdHhQsxCd2drhN89Vl4cGBp6XvJDGc3JucXmZ1LUfXtlJ8Zr/4WWjJrmyQMr2ZwPMoLRduDUVk6/oq6XRbywOOvQAxqfJNmtecJicWu5m5NdDn+muwDBe4dQIeIg1TBgXaWSXH7weMHCfNITGARk2MEAWGbppja9r5rTU08PLOMUPFpPn6FGTnPYLPI171adMBTVRWH81pQiX97qV2mMlS+izGIPYADcbRS5L5GQ9ajeDBaME5qfXA8e5cz1iw7LXGS7lTet
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3551af9-03c7-4af9-e0cb-08d7980f31df
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 09:58:52.2715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kpVHKFgO4HKMqNpgRCfInpjUdg5mAM31h63RDvRDe400+3SHFjbOqc26FfMPdry3pRqRZCaPotwaWFeh6DrDug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5089
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBTdWJqZWN0OiBSRTogW0VYVF0gW1BBVENIIHYxIDEvM10gc2NzaTogdWZzOiBmaXggZW1wdHkg
Y2hlY2sgb2YgZXJyb3IgaGlzdG9yeQ0KPiANCj4gSGkgQmVhbiwNCj4gDQo+IE9uIE1vbiwgMjAy
MC0wMS0xMyBhdCAwOToyOCArMDAwMCwgQmVhbiBIdW8gKGJlYW5odW8pIHdyb3RlOg0KPiA+IEhp
LCBTdGFubGV5DQo+ID4NCj4gPiA+DQo+ID4gPiBDdXJyZW50bHkgY2hlY2tpbmcgaWYgYW4gZXJy
b3IgaGlzdG9yeSBlbGVtZW50IGlzIGVtcHR5IG9yIG5vdCBpcyBieQ0KPiA+ID4gaXRzICJ2YWx1
ZSIuIEluIG1vc3QgY2FzZXMsIHZhbHVlIGlzIGVycm9yIGNvZGUuDQo+ID4gPg0KPiA+ID4gSG93
ZXZlciB0aGlzIGNoZWNraW5nIGlzIG5vdCBjb3JyZWN0IGJlY2F1c2Ugc29tZSBlcnJvcnMgb3Ig
ZXZlbnRzDQo+ID4gPiBkbyBub3Qgc3BlY2lmeSBhbnkgdmFsdWVzIGluIGVycm9yIGhpc3Rvcnkg
c28gdmFsdWVzIHJlbWFpbiBhcyAwLA0KPiA+ID4gYW5kIHRoaXMgd2lsbCBsZWFkIHRvIGluY29y
cmVjdCBlbXB0eSBjaGVja2luZy4NCj4gPiA+DQo+ID4gRG8geW91IHRoaW5rIHRoaXMgaXMgYSBi
dWcgb2YgVUZTIGhvc3QgY29udHJvbGxlcj8gQWNjb3JkaW5nIHRvIHRoZQ0KPiA+IFVGUyBob3N0
IFNwZWMsIElmIHRoZXJlIGhhZCBlcnJvciBkZXRlY3RlZCBpbiBlYWNoIGxheWVyLCBhdCBsZWFz
dA0KPiA+IGJpdDMxIGluIGl0cyBlcnJvciBjb2RlIHJlZ2lzdGVyIFNob3VsZCBiZSBzZXQgdG8g
MS4NCj4gPg0KPiA+IFdoeSB0aGVyZSB3YXMgYW4gZXJyb3IgaGFwcGVuaW5nLCBidXQgaG9zdCBk
aWRuJ3Qgc2V0IHRoaXMgYml0MzE/DQo+ID4NCj4gDQo+IFRoYW5rcyBzbyBtdWNoIGZvciByZXZp
ZXcuDQo+IA0KPiBZZXMsIHRoZSBjYXNlIGJpdFszMV0gc2V0IGlzIHRydWUgZm9yIFVJQyBlcnJv
cnMuDQo+IA0KPiBIb3dldmVyIHRoZSB1c2VycyBvZiBVRlMgZXJyb3IgaGlzdG9yeSwgaS5lLiwg
dXNlcnMgb2YgdWZzaGNkX3VwZGF0ZV9yZWdfaGxpc3QoKSwNCj4gYXJlIG5vdCBvbmx5IFVJQyBl
cnJvcnMuIFNvbWUgb3RoZXIgZXNzZW50aWFsIGV2ZW50cyB3aWxsIHVwZGF0ZSBoaXN0b3J5IHRv
bywgZm9yDQo+IGV4YW1wbGUsIGRldmljZSByZXNldCBldmVudHMgYW5kIGFib3J0IGV2ZW50cy4N
Cj4gDQo+IFRha2UgImRldmljZSByZXNldCBldmVudHMiIGFzIGV4YW1wbGU6IHBhcmFtZXRlciAi
dmFsIiBtYXkgYmUgMCB3aGlsZSBpbnZva2luZw0KPiB1ZnNoY2RfdXBkYXRlX3JlZ19obGlzdCgp
LiBJZiB0aGlzIGhhcHBlbnMsIHRoZSBkZXZpY2UgcmVzZXQgZXZlbnQgd2lsbCBub3QgYmUNCj4g
cHJpbnRlZCBvdXQgYmVjYXVzZSBpdHMgZXJyX2hpc3QtPnJlZ1twXSBpcyAwIGFjY29yZGluZyB0
byB0aGUgb3JpZ2luYWwgbG9naWMgaW4NCj4gdWZzaGNkX3ByaW50X2Vycl9oaXN0KCkuDQo+IA0K
PiBGZWVsIGZyZWUgdG8gY29ycmVjdCBhYm92ZSBkZXNjcmlwdGlvbiBpZiBpdCBpcyB3cm9uZy4N
Cj4gDQo+IFRoYW5rcywNCj4gU3RhbmxleQ0KDQpIaSwgU3RhbmxleQ0KVGhhbmtzLCBub3cgY2xl
YXIsIGl0IGlzIG5vdCBjb250cm9sbGVyIG5lZ2F0aXZlIGFjdCBpc3N1ZS4NCg0KUmV2aWV3ZWQt
Ynk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo=
