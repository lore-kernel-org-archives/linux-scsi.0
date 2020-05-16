Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AFFC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 09:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2120F207D3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 09:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ey/aHjEi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kSnMO4Fa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgEPJOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 05:14:32 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54212 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgEPJOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2020 05:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589620473; x=1621156473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1wKGlavVurPIkK0xQC34qgfDHDNrOJhLutkYLnndDug=;
  b=Ey/aHjEivzpXl1mKjW1HzOp5mVF4fqhNT3Gt+Fxf09dpDKfi5TrSquHn
   CsO7l5Y9VyTaW+0wyUua0OsglDPwvWwDiYYRHANHypoAgoVPZOjsNXYMx
   rtv5j31jUy6TMCu/KDiFhPBSo/Jq+Qm0GRslM/HLfeoZ6ws71TSuG10+I
   Ljm1k3Jjx7afmdtx8fFI1321g9aUYHZGbfAP4KrJcIIXgo8pXO84fFMRk
   S6GwXCtG08RrumOYmfcwerlKd9Suc9cQOu1UuRVRr5ph4JsAScd8mo4eR
   1QgxIaeO3gAfr86IrqHy/5d6+VL/hFOt8SAmKA15jDlno/70OFBYIMusK
   g==;
IronPort-SDR: lyptJqlP279O/xgxqHb0/0igCGIRGhK1GdaRq4s8upPzRqxG3xuRrph6PKDwDZ3eQ3ZQaebBDi
 rGVZTLE93rJ5rLU4TdxLR9TgyvxY3u5XMllZrg4NeAJYjXcfrIPGfnTnc0PT7xYsEYj7mJf7dU
 dmcUfAa2gk7xBD+m50YZMi6SAKT9H7rdMCG7C3+qpb+F2OMLps2l9o6PcbbHODtQh0+z2VNM1C
 4IhMT61XL7+BUFxqfcV0Bxa4xZDD6ZcA8UMTC/IvH5Nr0j1mQOjXUphhOstu47MOL1YIDj53iT
 doE=
X-IronPort-AV: E=Sophos;i="5.73,398,1583164800"; 
   d="scan'208";a="240560100"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2020 17:14:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/JX8OSTm8BvA8TGRfVaH7Te9r64n2nhE1hpgUlms0vjj0Dy3QmXkTfXQRDX7zCzb/iUQiGesNDJO64Fm5dluV6j96dhS/GvagpA26Psgp3ALOGkwWgXlaXswVGTVao+pvcoOP5QHYXfRjh/59/ww0/jR0DYiedr6eCFljJn0unyTk7utLPe1wP/rfcki4FvaCNj7pYoU5J2XnBpF8AlvYxw1aSMSQ+8bLKxEDrlw1ns9qnbGUQJPNmBWIEhvkxvd5NoqH5YmHoE5nMY6XlTz/sVA2UefTuP74DW1A4095EHLWL6CjnwYf3IDIB6VSVEuKiPQc/8dK0pG6PvZ0AcQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wKGlavVurPIkK0xQC34qgfDHDNrOJhLutkYLnndDug=;
 b=Up7hx3UWKZr9cJVTdmH0wqnAsUKHA2E9a0akbsBPRoBIwn1LutUqzBYM3I8Q8yMZ63P2HxYDMrenvwSF6uVUm4RqvUT3+ZQpoA7p6aDkaLkSv31qOuL8cDAGyzo1o8qIjwH/CKDWmPxEuDqnkXvnc15jbhG1LAy0BPgBSdqtfzTnK8CQpxnFUSdpO5hwdCnpRiPc9WIM5jboxOpD2uMFN53iQlyK+jpPjjjOEqLHMIrZT7ACqfTHSQSjcxgcXzUnNf/O5IDyB+D5kM7tsMp5laz0pM9OaszNiKH5a38XkhnpvFjy1ydhsW2s6MI7MYXJ5ONzswmey0Tv4RUDgH79Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wKGlavVurPIkK0xQC34qgfDHDNrOJhLutkYLnndDug=;
 b=kSnMO4FaiO3jFWIbMMK7u6wnSJpQ9+kynq9WyWB7qY4dbtUGA3yOD9aNZoO1JOalw6dtnqeGzKHRAFBfsW0CIe1z7w+j8FPhEoDupLzX/ta92vFJbteN9KoyeqvIRhFyVv3QoUOu41xR6AH/hpm+Jo+w657gkqDaposzVhDwPfs=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4846.namprd04.prod.outlook.com (2603:10b6:805:b0::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Sat, 16 May
 2020 09:14:18 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3000.022; Sat, 16 May 2020
 09:14:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
Subject: RE: [RFC PATCH 00/13] scsi: ufs: Add HPB Support
Thread-Topic: [RFC PATCH 00/13] scsi: ufs: Add HPB Support
Thread-Index: AQHWKqPlUccMAbA8XUSxGuQk2UPIMqiqFSGAgABZjYA=
Date:   Sat, 16 May 2020 09:14:18 +0000
Message-ID: <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
In-Reply-To: <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:4851:af85:8fc0:7c95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0675cf13-cc5b-4377-65b2-08d7f9798343
x-ms-traffictypediagnostic: SN6PR04MB4846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4846C0E9E06169C13A0725BFFCBA0@SN6PR04MB4846.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 040513D301
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nqHmiNbiXuvfS1txKs8skUdvEVIjYDn9+DJdL2kWu5H2sU4OUhjHqX5ZWECZ9m9kzylq5JhwOFDKQ2sxtX7AOzsQWYrQeOMM1EJv0/UcwXVAklk4DjVrfuWo7UseHzdCqz2c2K7v5rhLizGvltXrkz5gRs82puKGj54n5MhNYRjKpf9FuIpYXwAsLAEgkEZOGiGCF1L92TKF+2L1HWPW+/+S24eqOyTk6qVIH3V0eyzF2I/JVReRlZbvT2hRA+qGPVx6GoZPcZLiZAyZo6Xanv8NUf8wIeVe5BaSOGEZ7XHtGOZZMXIWm8NwV2a/+6oH4Sn1XNrBOH/KWNAj2VoKlewRJXPsSRhGxrdW6veP0xpfrHoBn40kkRseFDZbw1SUPZp53tYOzWZiUD7Xxyldc6pBfD9dSTN/BtLBhLqC7Ji+po12QdnfK1boyaqdCXnO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(7696005)(52536014)(6506007)(2906002)(7416002)(86362001)(478600001)(4326008)(66946007)(76116006)(316002)(66446008)(33656002)(9686003)(8936002)(54906003)(110136005)(186003)(64756008)(71200400001)(66556008)(55016002)(66476007)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mRKsPlNnG5gz5x/VNV1EP1T3hvV8iFfGr0Ck2VVGDxMMxJ+UbeDaQZ6cDA9B5VUbk1Stpv+CLPGZI51XrXobsZGlOUfdqWfu77svfBQDTFn5g99gD52TaNEFbco6IZ1qnyIb9m+aNdVLvpongjY2mNHkFUHARsgB+OwDFcrqvQuqlFppSz7VLp4w+xWWP/Kbkm98DE9KAH9FWkdXnIaGOzpC8SENZI71Vz7G82cYCZjHjvO9M6Sat4KyqOwGtjFcCANRmIFP/VZJ7EKx3FNJJFA+dusquTBYPY5Qhg1hXksOqB7vqhj4jFDme/DAKqhw0eCNvPrKSt2BNNs8XTTb6WZrnO2miQo8yEUEudXHe8aW/hErrO18QhEkwUGo+yLfSeFeodGTXhlwf34zh+RtB2PBijCwW1t4+fLNh/32rFWBSHjAxLz+/7DLZETfr+J6NHqhz4RY8uw3hhJZopgbocYwezNOoqGaElCTXQH+lEZFoLtgOZSBMcyvC9oVHfo2HfYjbyn0durMaK9wD8Vjwd7byA32iubnnF6/9RZnOZ+RCupmOajXBSd6ymY7iLwJ
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0675cf13-cc5b-4377-65b2-08d7f9798343
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2020 09:14:18.3576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/Df6en2f8He7SOiOoGcXQPF7Tles3SrZbITtO+I/O+U597Nct4fye96x26il9tkWz5aY26I0jA9XEyl3UbfTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4846
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KPiANCj4gSGkgQXZyaSwNCj4gDQo+IFRoYW5rIHlvdSBmb3IgaGF2aW5nIHRh
a2VuIHRoZSB0aW1lIHRvIHB1Ymxpc2ggeW91ciB3b3JrLiBUaGUgd2F5IHRoaXMNCj4gc2VyaWVz
IGhhcyBiZWVuIHNwbGl0IGludG8gaW5kaXZpZHVhbCBwYXRjaGVzIG1ha2VzIHJldmlld2luZyBl
YXN5Lg0KPiBBZGRpdGlvbmFsbHksIHRoZSBjb3ZlciBsZXR0ZXIgYW5kIHBhdGNoIGRlc2NyaXB0
aW9ucyBhcmUgdmVyeQ0KPiBpbmZvcm1hdGl2ZSwgaW5zaWdodGZ1bCBhbmQgd2VsbCB3cml0dGVu
LiBIb3dldmVyLCBJJ20gY29uY2VybmVkIGFib3V0IGENCj4ga2V5IGFzcGVjdCBvZiB0aGUgaW1w
bGVtZW50YXRpb24sIG5hbWVseSByZWx5aW5nIG9uIGEgZGV2aWNlIGhhbmRsZXIgdG8NCj4gYWx0
ZXIgdGhlIG1lYW5pbmcgb2YgYSBibG9jayBsYXllciByZXF1ZXN0LiBNeSBjb25jZXJuIGFib3V0
IHRoaXMNCj4gYXBwcm9hY2ggaXMgdGhhdCBhdCBtb3N0IG9uZSBkZXZpY2UgaGFuZGxlciBjYW4g
YmUgYXNzb2NpYXRlZCB3aXRoIGENCj4gU0NTSSBMTEQuIElmIGluIHRoZSBmdXR1cmUgbW9yZSBm
dW5jdGlvbmFsaXR5IHdvdWxkIGJlIGFkZGVkIHRvIHRoZSBVRlMNCj4gc3BlYyBhbmQgaWYgaXQg
d291bGQgYmUgZGVzaXJhYmxlIHRvIGltcGxlbWVudCB0aGF0IGZ1bmN0aW9uYWxpdHkgYXMgYQ0K
PiBuZXcga2VybmVsIG1vZHVsZSwgaXQgd29uJ3QgYmUgcG9zc2libGUgdG8gaW1wbGVtZW50IHRo
YXQgZnVuY3Rpb25hbGl0eQ0KPiBhcyBhIG5ldyBkZXZpY2UgaGFuZGxlci4gU28gSSB0aGluayB0
aGF0IG5vdCByZWx5aW5nIG9uIHRoZSBkZXZpY2UNCj4gaGFuZGxlciBpbmZyYXN0cnVjdHVyZSBp
cyBtb3JlIGZ1dHVyZSBwcm9vZiBiZWNhdXNlIHRoYXQgcmVtb3ZlcyB0aGUNCj4gcmVzdHJpY3Rp
b25zIHdlIGhhdmUgdG8gZGVhbCB3aXRoIHdoZW4gdXNpbmcgdGhlIGRldmljZSBoYW5kbGVyIGZy
YW1ld29yay4NCj4gIFRoYW5rcywNClNvIHNob3VsZCB3ZSBrZWVwIHBlcnVzaW5nIHRoaXMgZGly
ZWN0aW9uLCBvciBsZWF2ZSBpdCwgYW5kIGNvbmNlbnRyYXRlIGluIEJlYW4ncyBSRkM/DQpPciBt
YXliZSBjb21lIHVwIHdpdGggYSAzcmQgd2F5Pw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IEJh
cnQuDQo=
