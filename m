Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F945C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389342070A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="zHNGW1dt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgEOTfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 15:35:03 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:6243
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgEOTfC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 15:35:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqwabuQRiSlV8aR9FeQOPNqnWSkyl3ZmLdvAFDZWjX/mY6HMKl64+lQRSlG7fjL3cY/TYsQtESCLmWKdItaOj6e1KwB03l0phkBhs7hQwKVN3gOj2kiqqPtDPMbzfjUkoNxIssUXQviKy5exRHWmlidpCeFw5VvisSH3WoV0PvcJYWg8/zV9fxyysqm66Sml7NKESoxxTceazV2gUqOdaK9rEvVwLTWqAPAeKpFrl2+Dbyo043D6wa3iHKiqlEnnkndGSd7CWrOcViwduJDDpV2heoMX25aeoMCtSQubUHPh8wXCwCJniJYi6tC9nnhfbnHvBM4TQbwY79rLUNXw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apzQ3aEXSJP1g4D96CUIiR0yJcsQNoIZ1rthZQ7ZRxo=;
 b=iKsRddyb82W8Iz5Zy+dxet8S7lPURF8SmSQJxQUh+AKLDXi22JBIzDGm4lGJkxDH9V6PiyuaZESu/sQNmnOGzuMNaFcmM1AdYdX6wluxh+F/84LPaW0pJvpW7rfF5JulwUFMVdPd+Ng0H+PYuBz0xa6K6GRph6YdjPky1mZqF24rxvpG1HV62wyy6ArM2rFUxBYL7xcci9J1bgp+3oBNRTwfo0y5UGnn8RGEQgkmRWJabuAJqZaOMuMwisMj3Y9MSaY+nMuqx2UeM+vQhLxmhkEwxlo30zcGEILecxcTpL45rrViyr6kR8ooDNaNhghRf3f0jpRmH5VSVu/KYOCIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apzQ3aEXSJP1g4D96CUIiR0yJcsQNoIZ1rthZQ7ZRxo=;
 b=zHNGW1dtgmnANodohqbUut6DTiu9Ns4Jtaf5XUqyGntKo5zZPqGpGV8L2DBNYAvbffa83/1mIJCFnv3UNVC2LIx4hFNCFi25QGxMRlUhlKR5E3Ikp+Cg6RWyeV5niCXeVSVNKnqmrAaflctPga8M1VrO9Et8OhBM0Pxr1um3aZ4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5667.namprd08.prod.outlook.com (2603:10b6:408:c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 15 May
 2020 19:34:56 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c%4]) with mapi id 15.20.2979.033; Fri, 15 May 2020
 19:34:56 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [EXT] Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep
 instead of busy-waiting
Thread-Topic: [EXT] Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep
 instead of busy-waiting
Thread-Index: AQHWJVWjClMqL4p0T0io9BqnliNXaqipk2aAgAAAuAA=
Date:   Fri, 15 May 2020 19:34:56 +0000
Message-ID: <BN7PR08MB5684EC1034B4D45896C528CADBBD0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200507222750.19113-1-bvanassche@acm.org>
 <198a1467-09db-f846-e153-a9681ff15b71@codeaurora.org>
 <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
In-Reply-To: <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTI1ZDJmODI0LTk2ZTMtMTFlYS04Yjk2LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwyNWQyZjgyNi05NmUzLTExZWEtOGI5Ni1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjcwMSIgdD0iMTMyMzQwNDQ4OTM0NzE3MDkyIiBoPSJzM3VITk5sRldGbDlSZXYyeHAxSEdiMTZ3Z2s9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUNrWml2bzd5cldBVFNtZTZPUGZ6YW5OS1o3bzQ5L05xY0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTlvN0IxZ0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5904f09c-6fba-4c99-1b13-08d7f9070c8c
x-ms-traffictypediagnostic: BN7PR08MB5667:
x-microsoft-antispam-prvs: <BN7PR08MB5667D72B0CE25C6CA36E9C8ADBBD0@BN7PR08MB5667.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j9Y24spjL8NdGzWK/cUVBlbjqo+CL+bjm6N82aYbfCg0lL0ZVUPAe0Sq+ucMKzp0UGWdw6+vfkCOwoI6IQ/HO6B4BZEZrOlxAJjk2kaNd+FhkcUjRfmN0oFGaKoWkXxY76zvmai0WXaSMVwXrNnSt7lIzJvGMnsv4B6wW7XO195mQnYDWh/d/ZmumkzD1vGZLB0UmaTrdqQ1XUzqvcNDvKoVkSdyvMl47Wb7IS411aWjeDGFUtZcqZlVl4yrNFE+sbbLan5RRnbIGfqP6mbScMRyWB6dTcJaKFUF7RwR5iJR2E5tarv9PDQd86csOPHnflYL3b8UgZyEDXhB2qosDIDJ8ibNM3GHlLjYDPW/Ls9fuU0NOrpyeLdx73vDGm/vulC9Ojw6A4nYtiy06pwACV94gAtJUnRwhYsfIaEu1xa8p4Wxlz4QsSCKsKm4qUon
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(55236004)(8936002)(2906002)(6506007)(316002)(4744005)(52536014)(8676002)(7696005)(86362001)(110136005)(186003)(26005)(54906003)(5660300002)(4326008)(66946007)(66556008)(66476007)(76116006)(9686003)(55016002)(478600001)(33656002)(66446008)(64756008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0oX+ucEMW0tMz196quHnoed13t5oDOaYjK/EOgB1vHtA5uFemGBF4LBjEvTZT+xWRqrRiv/KcPqFm/MOmQBr1NkmTtV5Pf1sIC8Lm3ql7TbqqkvYh+b4elQiCR0xKUaXt/UQp3fYy/sP3mtwWOesnNB5QGt+2ShcJxxhDAFNED1lapdZTpIJKkH7tE4KsUOOC3fc8xogzI7RI5DeiP9xDtklyiMmwV8oHtdSo0Obg8G879zSanwkCYM3Zau7CnW2uh8gSZhtT1sTatHVlclhp5NFeh7oZdQcJHWbU1ER5FVADp2+tYbxBlB29o66Bx9L1oaQ61M/Eof1gfE2Tv1mcEUz5EiZH1owHoNRJFHf9st+Q/B4zurUA6djLIJVRXBopBe/yC5xoa3gl8cwcA3APjevh9WQ3eJSMbn1eNdgzthsff/FiWuO97/BKufWXsqbb6Vkn84lgXUo7aFJyUbx8J4nZ1WyyLTcOBxWHyEqvQ8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5904f09c-6fba-4c99-1b13-08d7f9070c8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 19:34:56.5800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PYXnEKiNmTCqg0GSyaR50UIZeLJj0ptoxAtsBjjhwytJp9LdK+laRqHAzfiFYzaBHbxKyHDA24Hnjvvnq6KNRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5667
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+Pg0KPiA+PiBDYzogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCj4gPj4gQ2M6IEF2
cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiA+PiBDYzogQmVhbiBIdW8gPGJlYW5o
dW9AbWljcm9uLmNvbT4NCj4gPj4gQ2M6IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5n
LmNvbT4NCj4gPj4gQ2M6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4NCj4g
Pj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+
ID4NCj4gPiBSZXZpZXdlZC1ieTogQXN1dG9zaCBEYXMgPGFzdXRvc2hkQGNvZGVhdXJvcmEub3Jn
Pg0KPiANCj4gVGhhbmtzIGZvciB0aGUgcmV2aWV3IEFzdXRvc2guIERvZXMgYW55b25lIGVsc2Ug
d2FudCB0byByZXZpZXcgYW5kL29yIHRlc3QgdGhpcw0KPiBwYXRjaD8NCj4gDQo+IFRoYW5rcywN
Cj4gDQo+IEJhcnQuDQoNCkJhcnQsDQpJIHdpbGwgaGVscCB5b3UgdG8gdGVzdCB5b3VyIHBhdGNo
IG9uIG91ciBwbGF0Zm9ybSB0aGlzIHdlZWtlbmQsIG1ha2Ugc3VyZSBwcm9ibGVtIGZyZWUuDQoN
CkJlYW4NCg0K
