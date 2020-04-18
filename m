Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F050C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 12:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB62021D6C
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 12:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Lb9duceP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="c9cXQNGe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDRMiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 08:38:54 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:57846 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgDRMix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2020 08:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587213532; x=1618749532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TiH9snXz0XEvk8v8qxtXR58X+4arid4AASGVYlL5WMM=;
  b=Lb9duceP1WMKxDj/X5scufi5QX2m6ay99u/NTb0/ghlqzQlZlLPutbHx
   eYGLtiTLYYvBM0qgWbZCXOMwgtTBU4Esmvjq6rkKjFiGzn1zmmaKAnNUX
   Rja4qOd8gcsMrEpq2skLsfmLC1pHM4ms8+kIbgsf6WtIEJZ2o6eB96ube
   xp9Y8cm50soqo49/NrndHSxDIE210NsaAauOMLlxmjNQUXtE+bNlkX0gM
   gM4V0328/NBmDMXwzA6N8VBooPjgFdGlrAcTmO8/kG61g7R+lBC6h6IM3
   o3dZBTmLLdeY9Y+k2oyOdgcSepzfWXsGIzLjafeDoqG8StPxivwcSk+K/
   A==;
IronPort-SDR: vc57xsbyunVEAX4o9G1nbyOiquX4PmFp+Bu2vNXZaHzJCJ6txQM+jLInHEMdNA71tPR1azBD+C
 JocopYXglF972aqk6CrmSgS2EMVP/j6rmztti1tivO5sah3C/vcRy/Jf4/9hkUK9YhkeH2CMh/
 n/kp+Oluss7alPJyFR3YdnsgM9hNlkwa9684BD31ZFya/BoqNBUH0dxFwUTe7ho3LAUO7zhzRk
 KPdwo/nroV68Kd42J/4I47iQqdiZtysU5LiSlWFiEkSUlBqlMmdSANvUByAYngmSLta7QQOLkH
 Jig=
X-IronPort-AV: E=Sophos;i="5.72,399,1580745600"; 
   d="scan'208";a="135618589"
Received: from mail-sn1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.50])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2020 20:38:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLB0UgVW0EVdfOEWOZYaAgb0J7WlVUGLAtzsxp6zsY8M9R2+2DEeSffZc87+mOTnzFyYC7lPP/diCHliFOFqB1sElv4yo7qt8bbV1ciTULZ3bKhjOxHtnrHH90pMgnK4kGT935nfLtM7ikVy9rhoaSznjT0/NNe05SIua/hrDT68eltK1k+Nt/Ujm+ThWQXRFWA7JcneAN0s4P290G03/+GmPTFfzxvogWTqZV74BjUiRBbMSt2NicQ55AY917raUnb3NgfbRH9PCcf9asj3a5G0MSUE0KVCIb8glLwi2HP+PnZS4AAwLWhbMUb0wN4iF3Un9D4lTJRo+ptPMXLUWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiH9snXz0XEvk8v8qxtXR58X+4arid4AASGVYlL5WMM=;
 b=E+OVoZE1S6svvbNfShXNhPT3ZY+gxn/HtVsq6gXCUMb2vDNf8XWB8k3vTFy5NRi/apaSoieA6nXaB6P1h79InYhXCRjaGjw7CPew4rYcOFOWXyGVmE0yrMuJXWb1MOO2YwJ/AB2DGy9wx/kkZKdkRU0hZuuFywFd/GvS8Dl1SwIr4dSdKJ3sTcsmUfpDLQwAXzuyDOR2ctNPv0o9+KxTB7/kWYiq2wmZfm1dPjdpfjbMrQ94KAFspfoG7662LK46pN7krvHbxTONwHIQ9ZBpPHFn7pRWFO3iyiZaHi4oEQNCVfJXJDKiWnFtMvld+9uvSmqkH1NorwhAXuTeCK5NEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiH9snXz0XEvk8v8qxtXR58X+4arid4AASGVYlL5WMM=;
 b=c9cXQNGe9S96aEI2CruBRId9O59yETS2v4lH9w1DK5J05yPOWpS6bXBkLBVCRw/NAxgrxypXkNb0XAh0HJrplQ0/FVClWlbmhnm/KUrlmkB/0yWXEt95SUyRBfD/AgQDV04SEuwcVurBS7QyCUvztbT3b0s7Id9vESpd85U2V6A=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4448.namprd04.prod.outlook.com (2603:10b6:805:33::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Sat, 18 Apr
 2020 12:38:49 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 12:38:49 +0000
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
Subject: RE: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Thread-Topic: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Thread-Index: AQHWFONyboJhjuJWAki6eibLTJAA36h+0jPw
Date:   Sat, 18 Apr 2020 12:38:48 +0000
Message-ID: <SN6PR04MB46402211952BC3D427AADA00FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364@epcas5p2.samsung.com>
 <20200417175944.47189-1-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fc5519b1-dc78-413a-af3d-08d7e3957185
x-ms-traffictypediagnostic: SN6PR04MB4448:
x-microsoft-antispam-prvs: <SN6PR04MB4448980B10780734E2CCEA44FCD60@SN6PR04MB4448.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(26005)(4326008)(186003)(55016002)(110136005)(54906003)(2906002)(52536014)(6506007)(316002)(9686003)(478600001)(7416002)(7696005)(66476007)(66446008)(4744005)(86362001)(64756008)(66946007)(76116006)(66556008)(5660300002)(71200400001)(8936002)(33656002)(81156014)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ygyG5LPPlSWbNn59FymYFrBite4r1fREZrZFTWQ2bY77RNV7Vn6sKOT/1SKbBdDVqWl/4i3ZmLxWyyufENzhVNKCJUZlQNKLKMgTiPil7VC+ASRBEtSFnYyAnQEkEHHL3in+Tok+RBNEFfsPlrWnbVCvOOeATh1kYaqMthJPqvlObfLJHeuGPTrNwfFSoCAwE/GNSr/od17eGxw3hSkgiF2RoiafzG/+UG7uCc7p1OAUm2fe6mwRP1WioltAcOUp89CE6GjNuQqKMcTIpCS115Hudcs4DMzfonAe8TLDZjwDZzAnuSk0pFIXC3clku45Pu9K+ptDWjhY6SQ90ccShmilNerLN13wuwvM4rrgG622ZrHONS0g6jiwJX121CzA8vFz5a3JT6m8DZT3VBtZmDTZArpoGhBsEyMPl0Dcj9OcOvjhCLm5K/vVWe/I1V/D
x-ms-exchange-antispam-messagedata: ZqpNu6Uo1hp3vE61PbCawyilmx8aUXyrXnYb5jmFdbMiTyDOWdp2+ggWr0w1yEpv0zFx+ABXzCT6/LWWvfWCzqyso3K6fg8EQgYX1wcqTMmv0Ax/NphWeE3Z4w+ehkCTwoLKDmn45d9OqT80e/ZO4Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5519b1-dc78-413a-af3d-08d7e3957185
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2020 12:38:48.9144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZJOEsjaEK1e+s+1kscXQ4/1KUUVOSH4G/PGSTQsezxhJaWcUQXocAwEQFAJ/AWZpWeVC2Vdv1EMp+0a+ivb7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4448
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gVGhpcyBwYXRjaC1zZXQgaW50cm9kdWNlcyBVRlMgKFVuaXZlcnNhbCBGbGFzaCBT
dG9yYWdlKSBob3N0IGNvbnRyb2xsZXINCj4gc3VwcG9ydA0KPiBmb3IgU2Ftc3VuZyBmYW1pbHkg
U29DLiBNb3N0bHksIGl0IGNvbnNpc3RzIG9mIFVGUyBQSFkgYW5kIGhvc3Qgc3BlY2lmaWMNCj4g
ZHJpdmVyLg0KPiANCj4gLSBDaGFuZ2VzIHNpbmNlIHY1Og0KPiAqIHJlLWludHJvZHVjZSB2YXJp
b3VzIHF1aWNrcyB3aGljaCB3YXMgcmVtb3ZlZCBiZWNhdXNlIG9mIG5vIGRyaXZlcg0KPiAqIGNv
bnN1bWVyIG9mIHRob3NlIHF1aXJrcywgaW5pdGlhbCA0IHBhdGNoZXMgZG9lcyB0aGUgc2FtZS4N
CllvdSBmb3Jnb3QgdG8gYWRkIHRob3NlIHF1aXJrcyB0byB1ZnNfZml4dXBzLg0KRWFjaCBwYXRj
aCB0aGF0IGludHJvZHVjZXMgYSBxdWlyayBuZWVkcyB0byBpbnRyb2R1Y2UgaXRzIHVzZXJzIGFz
IHdlbGwgLSANClRoaXMgaXMgdGhlIHJlYXNvbiBpdCB3YXMgcmVtb3ZlZCBpbiB0aGUgZmlyc3Qg
cGxhY2UuDQoNClRoYW5rcywNCkF2cmkNCg==
