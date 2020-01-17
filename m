Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BE4C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 12:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF02C20728
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 12:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="l6dXzvdX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgAQM54 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 07:57:56 -0500
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:62593
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbgAQM5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 07:57:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAW+Dpi8511tMl0aQXDIRAFHHwz5MHtU+0FW4G6k4/5OQmaks2YDcElOmOpRBu+yGFsN1pwQG2nnAaJ+dH7lvRR9Ye/cfz5D7pV4mGf2wymLFn43XRTDp1STv5l3UXt8OtqNXSziGFsbGvCuf9O3v2VKbdzUGJjmWpNyai/hedbBi8I+YZVhowpazMRjzeB6iv6qicfulFuePj56fno0TPqckHkB/yg9aRIQKC7Vyh5bXc0ucAgBXVDlKK8iDIMIBjcHyEetVuSfCcLamJfjuwGLWQwaf6xM+50k620mYLCz6PsrTuvxZO64yIPPqBq9XDR+JJkgqIiIqjPodumJ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCE6mAhCPDdMHOABcXPpStpY+6k6CV7yjvFj/5sDGnc=;
 b=EUz/tkRWbO2M7KLXDuo8mASKxPPpIuYNZufjCGh9EEoa+Aij5W5uEMlV/E6SBMw3IAXvNLhfO1xLL2cCWaPrty4+NlCdgJOL1diUvgIbvWZ9X3Pv3C1mO/jzXdCrjaljU6P4es1o/wEgigOTe2j7ARR5E8xYX5xXnADH1GITri29c7kB0iMkcQVm4SoRxHmSwbsp8wAkg1s3eNxmOiJevlQI+OI3v97KzNH4mp30U88P2SwWiHIpDaLxKPNRCPOaRtGS6O+vhXCoMufck1q2ihGd+MuAo2Jflphs0wL8VTEM2uW6PUDy8tQAs+QbZ7nQLnf4ZJnHFlFFnYwoJuNxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCE6mAhCPDdMHOABcXPpStpY+6k6CV7yjvFj/5sDGnc=;
 b=l6dXzvdXQfxzwiXE1Fg1BniJrw9Kt64jBxR3c/Dj+3T4iiIax6ojmO9JiMU3PcITvwZHdNXivuV7vp1kUTl8nu1fGnKXIkXcQJkAiV1zCB619REBpPxR4xO+8880WltMnsUNUMzVGru4OL+RRdrrAbWT8CdJ4VSKTu+lfqkSy7s=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5457.namprd08.prod.outlook.com (20.176.28.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Fri, 17 Jan 2020 12:57:50 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.021; Fri, 17 Jan 2020
 12:57:50 +0000
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
Subject: RE: [EXT] Re: [PATCH v2 1/9] scsi: ufs: goto with returned value
 while failed to add WL
Thread-Topic: [EXT] Re: [PATCH v2 1/9] scsi: ufs: goto with returned value
 while failed to add WL
Thread-Index: AQHVzOoUK+Qzmm+B8UO2MUoLbfqWBqfu0OLA
Date:   Fri, 17 Jan 2020 12:57:50 +0000
Message-ID: <BN7PR08MB568424A209D22A54EEC14270DB310@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-2-huobean@gmail.com>
 <36285cf0-7d04-f773-b266-2e3a1c9f6527@acm.org>
In-Reply-To: <36285cf0-7d04-f773-b266-2e3a1c9f6527@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWY1ODdlMGE4LTM5MjgtMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxmNTg3ZTBhYS0zOTI4LTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjU1MSIgdD0iMTMyMjM3Mzk0Njc5MjcyNTIzIiBoPSJFTExHaTRsak5vaktNbHBMUnJvUjBvMWhIRTg9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7455b70-1c91-433d-64ee-08d79b4cdc01
x-ms-traffictypediagnostic: BN7PR08MB5457:|BN7PR08MB5457:|BN7PR08MB5457:
x-microsoft-antispam-prvs: <BN7PR08MB5457684E763901E5A75026CEDB310@BN7PR08MB5457.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(189003)(199004)(7696005)(33656002)(86362001)(478600001)(186003)(5660300002)(52536014)(110136005)(7416002)(26005)(54906003)(316002)(9686003)(66476007)(71200400001)(4326008)(8936002)(55016002)(4744005)(53546011)(2906002)(76116006)(6506007)(66556008)(66446008)(8676002)(81156014)(64756008)(66946007)(81166006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5457;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tu+iZHGuVln3mW3xj07QMg34tCHRW3iomQDAl1xa8AVgtlIWR3Fi0GZAf5dQBEUKr4BduHJCILTd+zHGrWF4KX87TjipBSaezw+yjaeIiD5DkumbU3/jYKzY3Xqgm9CgP+WAeZMX58S95pYael/T4ftFEMmZHMiLmjZVYf6ZWSFF3Q/zGsudDvXYn/R6Y0S2d+d9uWlws7bc9rEn2HVk7GYvdDCI4rok3qpNNbrUjbTTkZVGR7xFdIvh66rK4a5FLmC8UjKCtPPJWnmPerMkTn7QH0zulh+NM7OO3cS2vRSr7RAv6MtEq8Fs6h9LR6PfIh43XQl+B22/4HaYyoEBY/fhw+ATNk/1i5KJDQdkF7afwNNeTYyEDROz4biX69/nNG5aIN/Vu5Lkln0X6XOzKCGv9PS5nkcFDntg47WZXhlITKSw/Ph6JS3VCqVprSjavUXQatvNqfm6Zq66eBhLkBiY9NT3/T8HT0qKQrFbouDmxtyyGuYmBXoHL/3l9vGO
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7455b70-1c91-433d-64ee-08d79b4cdc01
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 12:57:50.5004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kXiu5zaGixw9hCBDxvbFTLiWTV+ZJwTilfwKVLaZjhGwWW89nPONHvKmduMKQ11Af04Bn2guEgz1T3MpEuMuRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5457
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiBPbiAyMDIwLTAxLTE2IDEzOjU5LCBCZWFuIEh1byB3cm90ZToNCj4gPiBG
cm9tOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBp
cyB0byBtYWtlIGdvdG8gc3RhdGVtZW50IHdpdGggZmFpbHVyZSByZXN1bHQgaW4gY2FzZSBvZg0K
PiA+IGZhaWx1cmUgb2YgYWRkaW5nIHdlbGwga25vd24gTFVzLg0KPiANCj4gUGxlYXNlIG1ha2Ug
dGhlIHN1YmplY3QgbW9yZSBjbGVhciwgZS5nLiAiRml4IHVmc2hjZF9wcm9iZV9oYmEoKSByZXR1
cm4gdmFsdWUgaW4NCj4gY2FzZSB1ZnNoY2Rfc2NzaV9hZGRfd2x1cygpIGZhaWxzIg0KPiANCk9r
LCB5b3UgYXJlIGFsd2F5cyBleHBlcnQgb24gRW5nbGlzaCwgSSB3aWxsIGNoYW5nZSBpdCBpbiBu
ZXh0IHZlcnNpb24uDQpUaGFua3MsDQoNCi8vQmVhbg0KDQo=
