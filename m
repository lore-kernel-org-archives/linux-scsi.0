Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3036CC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 083F0206B7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="QIG/EJ+M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAQNcp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:32:45 -0500
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:6139
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbgAQNco (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 08:32:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfNahnekJYr17HjP5VORP6qpNoN2xgLu6Z3TQaPAJEjuIt762HXuvHk11kZ/JiqXUQtP3468ZNgLRG0t5LcCQ+ZY7keBuNklmQpu7cPGeT1F3Lxtdrq2GEg94bERDD0Blze8Xeqmfv+oTjGUTGpxdvTkgVWjLhGk/cIy1G29GsZdkZ7/WYSi5YsQfTz4mi3A2u9nUZGVxlHBbgNgbPNZYh8lSVs7u9gFJOpca7mlWaY5DmcNDxK1XKw4gJ90lfAFZBaIEGkdRktxVoUultxGfy7qCotJCtAZ0+iLgm9fZ0JvXGtfxCSu9Vtq6Xvl235vVkvtNLQLJVyyPRNyiItM8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hy3Uud9n2KfRRQBPtasw4zmxXoff9OJ/awRbDuqPD4=;
 b=ONQuHk8shekku6UDEQ2Bq5kpiPzQob0ISAlxgHDKDiFXiH2RcbbPXLe/vOWEvXLK1/XAV1c6sl7RkPImJ7A3hMllgNlUiRu3GKPHEUunUlrC8ERan6IV1PU2G/vBPXYW8zzFn/fCsv2OXH4hyNVP54NSJJoR0IY7M5akUozGTip6RNfmEYPL9W8jLau+ZFy/HXAChX3z0nLqbEmtGfBhmiopXLVttm3s7zc90QwO2V8XFeBqlKIt+62mrYTdQyFa6Ekl0kOflUEU2+w3tLx3X2VDSblGR1U6bhU1ZreEiCI2p91m8ZoI8Bo9tfYSbpLXCzs1N3PJeX9cBOFdAmlNQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hy3Uud9n2KfRRQBPtasw4zmxXoff9OJ/awRbDuqPD4=;
 b=QIG/EJ+MlRn7rEeU7OLEXuiG5u0CO0mO0RrREZGdl6bo7UGJqiyVyXTt2W/i6UBIVcZlJyBs6GhSSn8T31nMTM+FmM6BQ0C4xqoFCKJuXGuIQQOoSpUn4DCdQrsfh0d5RPYc4llky1a6XLdNlgSszqWz7C+mQ02Q+zYwOHFuqt8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5459.namprd08.prod.outlook.com (20.176.31.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Fri, 17 Jan 2020 13:32:42 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.021; Fri, 17 Jan 2020
 13:32:41 +0000
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
Subject: RE: [EXT] Re: [PATCH v2 5/9] scsi: ufs: Delete two unnecessary
 functions
Thread-Topic: [EXT] Re: [PATCH v2 5/9] scsi: ufs: Delete two unnecessary
 functions
Thread-Index: AQHVzOpYbAB83sjWkEy6eA8UAyZP4Kfu2v/Q
Date:   Fri, 17 Jan 2020 13:32:41 +0000
Message-ID: <BN7PR08MB5684EBF75EF47DD5FF7F4638DB310@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-6-huobean@gmail.com>
 <b315bf53-6b64-0e1f-ffd4-823dce99954e@acm.org>
In-Reply-To: <b315bf53-6b64-0e1f-ffd4-823dce99954e@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWQ0MGEyMzdkLTM5MmQtMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxkNDBhMjM3Zi0zOTJkLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjUxMyIgdD0iMTMyMjM3NDE1NTkyMTk3NjEwIiBoPSJsaW9tdjhKcWs5emFZZFYzZmhma1RiZnR2M1U9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a241584d-d54d-46dd-31ba-08d79b51ba76
x-ms-traffictypediagnostic: BN7PR08MB5459:|BN7PR08MB5459:|BN7PR08MB5459:
x-microsoft-antispam-prvs: <BN7PR08MB545986E279D74297C4164443DB310@BN7PR08MB5459.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(199004)(189003)(81156014)(9686003)(5660300002)(66476007)(64756008)(66556008)(66446008)(55016002)(81166006)(54906003)(8936002)(110136005)(7696005)(2906002)(66946007)(76116006)(71200400001)(7416002)(4744005)(316002)(26005)(8676002)(478600001)(4326008)(33656002)(86362001)(52536014)(6506007)(186003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5459;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7SseaJR7aNfKMcArK9Jbt/wbNAn0bya6b0UB62BWxSpZBOlecCNAli59/4H81gkM5zwDuXlZ5ghdO/IztW6l9Le+pK2C+3UAsPhyh+nvGMTYG3AdibR41d60CsR9l1rg9lH49QjG4N/H/cOe38pUgN/gAeBCmWNmiXs/3L/SV2dqtAM8lLxW5CI09Qb2FRRwZ+lVB343wfgFwyAKdHOzyS2Fr0Ir5o+H//WGJHsYlO447ayD91/S8jXzKD8/VUfzBHIg5Gr4Dnw3tCFfbAii6hHUOOKAwsGRUHcmsPdmT94ZRqqkS8yYNENULAWSQxVFFQwIWfilo/7rEH5f1F2pzK0MfNP+pXPF9pgiVGE5nhuSlx+QCeyxb1VlZYgFkQpIJCPBcDOi7R0DkNW0Jj/fFm+g5UC1IXVLetKW7oe2R87NqE9ZWf6lnAruKl2izrhakaAf4zSC0k0QewYg/bhyHPvCY2VeB3UJdDPWLLKgS5PS/lnoVkwV3WY2g1MFf3HZ
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a241584d-d54d-46dd-31ba-08d79b51ba76
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 13:32:41.7819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OYNgaI14m69pwzwsvJ9MTCF1c2Si8FA7t5V/m4U1K1KkS+mrpMS5qyqPZiawXUQY4U6FL+3pHpZgpzltRh/XGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5459
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiA+IEZyb206IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4N
Cj4gPiBEZWxldGUgdWZzaGNkX3JlYWRfcG93ZXJfZGVzYygpIGFuZCB1ZnNoY2RfcmVhZF9kZXZp
Y2VfZGVzYygpLA0KPiA+IGRpcmVjdGx5IGlubGluZSB1ZnNoY2RfcmVhZF9kZXNjKCkgaW50byBp
dHMgY2FsbGVycy4NCj4gDQo+IEhvdyBhYm91dCBjaGFuZ2luZyB0aGUgc3ViamVjdCBpbnRvICJJ
bmxpbmUgdHdvIGZ1bmN0aW9ucyBpbnRvIHRoZWlyIGNhbGxlcnMiPw0KPiBPdGhlcndpc2UgdGhp
cyBwYXRjaCBsb29rcyBmaW5lIHRvIG1lLg0KPiANCkkgc2FpZCB5b3UgYXJlIGV4cGVydCBvbiBF
bmdsaXNoLCAgaXQgd2lsbCBiZSBjaGFuZ2VkIGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClRoYW5r
cywNCi8vQmVhbg0K
