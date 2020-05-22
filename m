Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780EDC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 14:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48410206C3
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 14:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="5x6/QOtg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgEVOzt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 10:55:49 -0400
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:62977
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731365AbgEVOzr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 May 2020 10:55:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jm0Fnz3/Gwg27rKxxXTtLWvId4FXocRzzrPdQ4cNIE67sGOF3HjWYWbb2i/IPgrvo5dmTB+wMJayrIvlb8kNmb1uXjduhhcfVSbQLuR08LnRTJ34h+6GcTjJcDb0+WhPEAjJd0INaIB2KLdgR2bkZ6MMVLFYwm92cuvoQwqUeHnsbPzKQ7GK3CQEY0rypFeB6RASx0AdNxXi6RsAQIMpmIFCVTMUmPrhYNn1QMRw7YW4szwQdEfwkyjZrVvPXLqUnmSTw6r3DvTBnMuagp9uSkR4mY8NIp+WGRC6vytQBLmVOOO233SJEBGb70luU8mL84k+P+80iCRsuGI9g5l9xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa8OfpbX5JGsjxlkBvH58TN+EspF9dos4LaIks6SASA=;
 b=hTzarp75GWIOb4ZJKeMXRPBo2Sixqz1cBdS9+83eqUHTf6Ve+8XoIX1QzQ0yP14QyZjFU1vbl0fk9jujz0i7V8bv3ZMtOen4lD1AAZ0H0FI5bGjXmGzU3d7xnxiWw6Bih8sYgT5yG1+MQoZ0mFcM1WXQQN9m9W9+4QvQsnGyVWptlaBlNwsUlWGTw6rMQ9ZJIOvSWoun2oJCVoc286KluSnBJAeGd9eUh7qwtomzsNhfBxIGYOdfpRU/npx9EiCOIkpGTIIVEdcTz5HKx3vKuMWXXZUHrXhB+vH6Z577Iqq00dKaRLZ9ShdXZYNV+IzNC2h22oRXO3VvnuAzJsKLyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa8OfpbX5JGsjxlkBvH58TN+EspF9dos4LaIks6SASA=;
 b=5x6/QOtgimNmqSljn0wYpYedjZOKne0PP2GS2dqJOKeOxV7BYKg9zVzn80nRhU9gKeCa+UWuLD0s0qxqxh5qswE525fhEws7ZQlNU7eJ00p3XmhxWEcBaic4TDy79kh0Cp7/UcchwmqTgpYW61r4xMcT28POM21oN9gmhpN+DOA=
Received: from SN6PR08MB5693.namprd08.prod.outlook.com (2603:10b6:805:f8::33)
 by SN6PR08MB3920.namprd08.prod.outlook.com (2603:10b6:805:1f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 14:55:44 +0000
Received: from SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::d5fe:2ead:9b9a:c340]) by SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::d5fe:2ead:9b9a:c340%4]) with mapi id 15.20.3021.020; Fri, 22 May 2020
 14:55:44 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     "dinghao.liu@zju.edu.cn" <dinghao.liu@zju.edu.cn>
CC:     "kjlu@umn.edu" <kjlu@umn.edu>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RE: [EXT] [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on
 error
Thread-Topic: RE: [EXT] [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on
 error
Thread-Index: AQHWL/XSkL9YvKr2Y0+njmc4MiuIK6izvNjggAAQhwCAAGAPUA==
Date:   Fri, 22 May 2020 14:55:43 +0000
Message-ID: <SN6PR08MB5693D06B4B30D0A76824D2BBDBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
 <SN6PR08MB56932A6D579AFB4E28AFD001DBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
 <4a6ba414.bf5c4.1723b9792df.Coremail.dinghao.liu@zju.edu.cn>
In-Reply-To: <4a6ba414.bf5c4.1723b9792df.Coremail.dinghao.liu@zju.edu.cn>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a855cc2-1da5-4be0-b52e-08d7fe60341b
x-ms-traffictypediagnostic: SN6PR08MB3920:
x-microsoft-antispam-prvs: <SN6PR08MB3920224845BC93B8D53FEC07DBB40@SN6PR08MB3920.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WVXau2LPn6e7fptyYuIb/Iv+8SUC4VDUjO+uqItpa8QCrUq63rZ3+dvD9WLdLlydpestMXbVUkxD627VIXHHHSC9tUIfWEV0ANXLtABQxchx+ldk95bPeD53cGLxF55IoYo1155TtQ4e5lL+SfGmp2auBHhAW7qdqRrtDV7Wno8NxllAOBhlOC0yAeNxoVYZPgpQdl/27UoxbQmgj+0guumUXLiMiyc82xiqlG7RoPTApOgwC2ZFcYCLpS8vsHVjCMdhhMidvJllSoy8E5ajTNBK6GEzWfJq1r+2icd+BZG3hCCcPRl859jeOUfCGWgOhv5Js0SYnEeDPovX8XQKSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR08MB5693.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(4326008)(8676002)(54906003)(9686003)(8936002)(5660300002)(71200400001)(316002)(76116006)(4744005)(7416002)(33656002)(186003)(55016002)(86362001)(66946007)(26005)(6916009)(2906002)(66476007)(66556008)(66446008)(64756008)(6506007)(52536014)(55236004)(7696005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GZqJzNma6V0edxZwvAdU4szGd2AfuGnJTFhc1/OjVKpovPuG/OBMtFX02Dt4880c2P+LDUdUcroaOSUyZqpVBpfSGs4ALG3F17pNgu4TjO62hbyOcdFbgTcpaNu0vWenX0bnI7LiHDTse48KQlO7q9DaKf6oBphP+grHkp0ThKSeoawlA8ZuGC+xSB0j1Uq9YejKE1Nk8KkEOumTPskB6lDlWlPyzVVuKdD+9o5bddbGM9IBoY5GVYtDvpKgEyPfRG2ewGW8J/lA6uqHS7ZSty96RALLt9uoaoCa09oPgcb1iebRhw1TREt+KngQo1nsDNQzJ31DJ/OdtMtXdkA1d7mFpMIDvqcwHj275xxypPcrHDpwp65bU0TpN2+MrS1uhhuLvHZu4Bh9z1yii66uE6j6Pqgu4S76ZgZQE9gsxJi9BdsqS8syO/Kj3TKFmG0w5eM5accQuSbY6OLhCgL7wKGFsxUbP2n6V3g/tWVdVTojTSyxR3mgsMPyaIpOSBiy
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a855cc2-1da5-4be0-b52e-08d7fe60341b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 14:55:43.8395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JqJx4iTHQEUQV08Pla/Gk7euoGrL+IVX7pLsQUUpcZXGb8VW/NYHaND7JEKoZpLeYhtCDBbWf67CVXP+sMlAYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR08MB3920
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIERpbmdoYW8NCg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgYWR2aWNlISBNb3Zpbmcgb3JpZ2lu
YWwgcG1fcnVudGltZV9wdXRfc3luYygpIHRvIGFmdGVyDQo+ICJvdXQiIGxhYmVsIHdpbGwgaW5m
bHVlbmNlIGFuIGVycm9yIHBhdGggYnJhbmNoZWQgZnJvbQ0KPiB1cHNfYnNnX3ZlcmlmeV9xdWVy
eV9zaXplKCkuIFNvIEkgdGhpbmsgY2hhbmdpbmcgImdvdG8gb3V0IiB0byAiYnJlYWsiIGlzIGEg
Z29vZA0KPiBpZGVhLiBCdXQgaW4gdGhpcyBjYXNlIHdlIG1heSBleGVjdXRlIGFuIGV4dHJhDQo+
IHNnX2NvcHlfZnJvbV9idWZmZXIoKSBhbmQgYW4gZXh0cmEga2ZyZWUoKSBjb21wYXJlZCB3aXRo
IHVucGF0Y2hlZCB2ZXJzaW9uLg0KPiBEb2VzIHRoaXMgbWF0dGVyPw0KPiANCldoYXQgZG8geW91
IG1lYW4gIiB1bnBhdGNoZWQgdmVyc2lvbiAiPyANCg0KSSBzZWUsIGJlbG93IGdvdG8gd2lsbCBi
eXBhc3Mgc2dfY29weV9mcm9tX2J1ZmZlcigpIGFuZCBhbiBleHRyYSBrZnJlZSgpDQpJbiBjYXNl
IHVmc19ic2dfYWxsb2NfZGVzY19idWZmZXIoKSBmYWlscy4gDQoNCkJlYW4NCg0K
