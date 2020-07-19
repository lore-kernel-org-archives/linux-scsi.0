Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345EEC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E97F320738
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RErJjXV3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IaarqL47"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgGSGqO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 02:46:14 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31594 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgGSGqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 02:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595141198; x=1626677198;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=YJZG2787s88FSoCCWvr8s6fhFvuKcWuQmDTzb6/6avA=;
  b=RErJjXV3731teqfKAxHdmleILaTRyXKHw2aoedsQbOOmlm+5NfewNyI+
   oNhaoV32lTGHxiFDSXybcSe8BSKlcHfNXp9xQXhuYtswRyRrZonH410sN
   VyUdZ0YMFbXnzp8VV0Y6SajKE0XH5lT7b9Qjsa4ClyN/PNI5QT4ElqQ1/
   nq97u3qVgkVv1D7q43QY06gGPHrAfOWyG8YlE3cOsPvYYvS0j5tw/v4Yk
   ehefXFsiJOAcVYKbz3ii+l4hsouBkASlA4pKQtvPxTUlL6QCt4OhzO+v1
   Z/04Bqjt/aW3y83JEeXZycM7+FuRAjjcr7UocAWJCcfahjlcg3yjrhNA0
   A==;
IronPort-SDR: RVQYYn6tz8mgEYmZDaMDpW37mPtWumbNP9fqE+EzdjC/i3OOy4CBqva2XkqZFvPP/tbOkagPUP
 NoCZO8KSBrTvHpS9WNQ1F9NIMZ+dvm1InQf3AylgJdz1T2vSS7ONLQaGVNIEcFdTZHkhyKnE8c
 lsGcXDj0EhuOrKksBR/NR/xFCV7278QIb662KIRAxbjZGS1ztouBS9jsZzr1hpvaHdtS7h26df
 ojzzPg3KXGDENeOoIc3hVPBvaKUeghkM6Zaga6KZBk77FlQLnqprlOhxNIo7m38TRP1r85aiP9
 MLU=
X-IronPort-AV: E=Sophos;i="5.75,370,1589212800"; 
   d="scan'208";a="245862664"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2020 14:46:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuKBHv/t6dt9i2JbZ6BA90dfLkPc7iQNlJCZu8TMvkJReC3Ay74z3tgEWEWcgHeXCvblmNgs4MM+7Lq7estBP3YjnL5kqHv+iQC0Xgfd06HA1H4uW+AK9/g5zUmIxXEsuVPPYErymmYFigjHp7rXIm77k1Kawrssuge6m8ff7PZOel2I/tD3x2sotNJ2fRlBoZajz85mF2JAL/wMkx+zDMFoamXvwYTAgo7xMUT+KnfsGYA/GoEYyxbTZfbxOe2R3lQrhlPXJSMZLKujw20syy6SADbMPEd1HfluBRIxihAAJFXMRlS/m8l486PZwNJiF4e9GzplLjTFiLyIWXSCpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJZG2787s88FSoCCWvr8s6fhFvuKcWuQmDTzb6/6avA=;
 b=luL3YAy4LNXcipuXRpgAHXA7Q7y3ncA0AZ6zygKf6DkwXLmEXwY3S9dxRBzu5E14ZMIywNEaYDrkk6hhqwAT9+k5SfpU2PiFVz3ibqj06kA80/NVKsvB4/Z5gF5JoUzS4qywcD+OL+MAXdemoC2YS3wQczmEAkSI0yPtoV+eerxAECfvireBAtXI46fBmVuQCwdpMeAHVP6t0Bpgw7Wo5+vd4P4DwHTe/2Fu/PG1c8O4n9eldpIfuSVY1vTCwATiAFOuK7zfEv29UOjdm9ljrm/0+K8EGe1mVWIgr/aewMLhqYsQ8a3wEvezR0TRLnK/vaLZZRgwCZI04b/A91CT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJZG2787s88FSoCCWvr8s6fhFvuKcWuQmDTzb6/6avA=;
 b=IaarqL47ORXe0Lm6qKAkBAxaYFT88ha5rtZuVITLPRZUCckNLIHW9Te2ZtCnRpyQwfUpzkySvPijiPsU+xv8x6Khq3WU5SNj3/ri1RekSfc+vvzJl2xvInp81M9voLtCwzjeXBeR4BefEMU7II3RLbx1GvBbqg6Gikqug8GYYRM=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4639.namprd04.prod.outlook.com (2603:10b6:805:ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Sun, 19 Jul
 2020 06:46:09 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.023; Sun, 19 Jul 2020
 06:46:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [RFC PATCH v3 2/2] ufs: change the way to complete fDeviceInit
Thread-Topic: [RFC PATCH v3 2/2] ufs: change the way to complete fDeviceInit
Thread-Index: AQHu1pDNEI1WArg19xfehYJkuPyuggIodicAAU/VsrgCNqJMqaip2GAAgAYzH4A=
Date:   Sun, 19 Jul 2020 06:46:08 +0000
Message-ID: <SN6PR04MB46401488080D379B5B96AB60FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f@epcas2p3.samsung.com>
        <08bc1641fdce941175596fe106fd5c02161683bf.1593753896.git.kwmad.kim@samsung.com>
        <SN6PR04MB46407E21E411B7E785C3B3C1FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
 <01f501d65a7f$53aab090$fb0011b0$@samsung.com>
In-Reply-To: <01f501d65a7f$53aab090$fb0011b0$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 14450be3-bb5d-4ec3-d04e-08d82baf6b43
x-ms-traffictypediagnostic: SN6PR04MB4639:
x-microsoft-antispam-prvs: <SN6PR04MB4639671EEC25EB26D0135F14FC7A0@SN6PR04MB4639.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5H4v23kYgz1frW+iMuZLQaKGE3zxP1rLM6IVGOD0x7pePWa+SP2GJEOZRqxwvbH9s1i7UgUytM2QXo0pmkZCbQDG9z81Hvmw3vLithK5WTlP/HyxZOyI9F7xtE3z3JC2AArdf83F11YTJdnUmJ481q0iP7fv5KV9vjw5HISAUEGKDb2tM/36nbslfSf8+J6c5v9n9/lIUzSxWIsf7FmRIwhhKTqx67bw/IqfDzhCAyAq40yptb5/NM5yPZ86N+ILuOCffPu+VMDmV9gTaZelFCBHShZZdDQCYkyhu1swJz5ycT0WGKsvR+7NPhCSCN7CNb1CMltTCB2drgtssRGLK0cUF62VIRQ77fva6YifpimqpcWp3pH8KLbhAH/CZMnS5EkXtTjfExmtBcl/euQdSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(110136005)(7416002)(9686003)(8936002)(52536014)(8676002)(5660300002)(33656002)(71200400001)(2906002)(6506007)(76116006)(478600001)(7696005)(26005)(55016002)(66556008)(64756008)(66946007)(186003)(86362001)(66476007)(316002)(66446008)(921003)(43043002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HQDeF8dN2CyTWb56uwQZ5tZW1wGZpG7ssw4rqrlGPEbtn8+jIMMkiJWQrt88WHEm2kufCs2qW05Zu1IFqZgDuQ8zQtgMN23eehHYhjVKOcG1XdPTq0TIF/BHc5jn7bfnqEn6wX1Z+nRGWE4Wwh93SKhkCpcaX7sDrOCDcRdd3diA6GcABo0F942Dd3wO0rmvx03fiBb33t9QEdjnjSPaSBsyhJzd1tBfLX/l3mgbA8BVZLUC1AE/9ZymKg+sivwKnqB/YqbwVkw44NgK+zUal6ki3F3tDAOL0ANJapsG7F7q102g/vU61jei6HE70YbygvEtrkg0sv31UhEgdJ7oX9rgh8XZsS2vek3ASrvy5+2B8yOK11gXYTIbTcjXAEw6muNj1KCmcK1RthNgEpLL+dwwfs5d90q2gIHraEK04/709JSabieIcCSqQIb0lpavry9JcAVLenr9D7AoJ+kkIU5RmD2n7BrDjulpT8oCwHk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14450be3-bb5d-4ec3-d04e-08d82baf6b43
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2020 06:46:09.0093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RHf67uxxscPfgMFKAYh2HTYuCveGxHUCY+GLPlN/vfwu1cYuCWiectqFhvOc2aoBIN2/zxDAad/9jNWI7cB+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4639
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gPiA+IEN1cnJlbnRseSwgVUZTIGRyaXZlciBjaGVja3MgaWYgZkRldmljZUluaXQg
aXMgY2xlYXJlZCBhdCBzZXZlcmFsDQo+ID4gPiB0aW1lcywgbm90IHBlcmlvZC4gVGhpcyBwYXRj
aCBpcyB0byB3YWl0IGl0cyBjb21wbGV0aW9uIHdpdGggdGhlDQo+ID4gPiBwZXJpb2QsIG5vdCBy
ZXRyeWluZy4NCj4gPiA+IE1hbnkgZGV2aWNlIHZlbmRvcnMgdXN1YWxseSBwcm92aWRlcyB0aGUg
c3BlY2lmaWNhdGlvbiBvbiBpdCB3aXRoIGp1c3QNCj4gPiA+IHBlcmlvZCwgbm90IGEgY29tYmlu
YXRpb24gb2YgYSBudW1iZXIgb2YgcmV0cnlpbmcgYW5kIHBlcmlvZC4gU28gaXQNCj4gPiA+IGNv
dWxkIGJlIHByb3BlciB0byByZWdhcmQgdG8gdGhlIGluZm9ybWF0aW9uIGNvbWluZyBmcm9tIGRl
dmljZQ0KPiA+ID4gdmVuZG9ycy4NCj4gPiA+DQo+ID4gPiBJIGZpcnN0IGFkZGVkIG9uZSBkZXZp
Y2Ugc3BlY2lmaWMgdmFsdWUgcmVnYXJkaW5nIHRoZSBpbmZvcm1hdGlvbi4NCj4gPiA+DQo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KPiA+
IEkgc3RpbGwgdGhpbmsgdGhhdCB0aGlzIHBhdGNoIGFsb25lIGlzIGZpbmUsIGFuZCB5b3UgZG9u
J3QgbmVlZCBpdHMNCj4gPiBwcmVkZWNlc3Nvci4NCj4gPiBUaGUgc3BlYyByZXF1aXJlcyBwb2xs
aW5nLCBzbyB0aGlzIGlzIGEgZm9ybSBvZiBhIG1vcmUtZWZmZWN0aXZlLXBvbGxpbmc6DQo+ID4g
c28gYmUgaXQuDQo+IA0KPiBJZiB3aGF0IHlvdSdyZSBtZW50aW9uaW5nICdlZmZlY3RpdmUnIG1l
YW5zIGJlaW5nIGFibGUgdG8ganVzdCB3YWl0IGZvcg0KPiBzb21lIGxvbmcgdGltZSB1cG9uIGNv
bXBsZXRpb24gb2YgYmVpbmcgY2xlYXJlZCwgaXQncyBub3QgcHJvcGVyIGluIHJlYWwNCj4gcHJv
ZHVjdHMgYmVjYXVzZSBmRGV2aWNlSW5pdCBsYXRlbmN5IHVzdWFsbHkgaGFzIHRoZSBiaWdnZXN0
IG92ZXJoZWFkIG9mDQo+IHN0ZXBzIHJ1biBkdXJpbmcgYm9vdCBhbmQgc29tZSBjb21wYW5pZXMg
b2Z0ZW4gdHJ5IHRvIG1hbmFnZSBpdHMgbGF0ZW5jeQ0KPiBhcyBLUEkuIFRoZSBtZXRob2QgbGlr
ZSBhIGNvbWJpbmF0aW9uIG9mIHJldHJ5aW5nIGFuZCBzbWFsbCBkZWxheSBtYWtlIHRoZW0NCj4g
aGFyZGVyIHRvIG1ha2UgaXQuDQo+IE9yIGlmIEkgdW5kZXJzdGFuZCB3aGF0IHlvdSBtZWFudCwg
cGxlYXNlIGxldCBtZSBrbm93Lg0KSU1PLCB0aGlzIHBhdGNoIGlzIGZpbmUgYXMgaXQgaXMgLSBu
byBuZWVkIGZvciB0aGUgcHJldmlvdXMgcGF0Y2guDQpKdXN0IHNlbmQgaXQgd2l0aG91dCB0aGUg
Zmlyc3QgcGF0Y2guDQoNClRoYW5rcywNCkF2cmkNCg==
