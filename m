Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B2CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 11:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850C8206D8
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 11:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XKrMUHKs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IPfydNjq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgFQLoH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 07:44:07 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9491 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQLoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 07:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592394246; x=1623930246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WtZqXDaW4tp6U/kH/VwVA8Ye0VW64d9tmUGFwdFADzY=;
  b=XKrMUHKszEQ5l6Ter2l5cmsCiYGn7gLFcMAWVgttOcmaJVzgiaieLs6u
   jaojSHBmt7Lv61r4WIJ1dVW++kZMTbdeFGqheNi3B9ajdoMD/J4m+OpOM
   Mpr1CRTNmfSrCimW45cw9cOPdd1MBau1cGPU4NG3rpd3ygiyfNvZDJyYF
   +pLkaq4FfjOH73K4AVgpsogpbNH2LM2960ZbkOf46QaAm2Vd7IDFOwa9K
   2c8FnpsnQyB7C1ed8F9/CgzGSMWzigd91Z/V3TX5FBzzSMueWH/f5frEV
   Ll114BqMvQhSsCVd/A5vgV5wIAwNSiOaK9y1StBSqfE1J+Afv1lmvoi5t
   g==;
IronPort-SDR: FbIbA9ks3Ew00yNg54rIRvcGAdGEcIaFInGR7ABFsig5imivid902S/czORf4QHz620Tr5UmgG
 EDUUs3yQcw/SRAt4RjcvnwLkjRdl68rp5LQU1uUD2UAq0gl2JJq94Ys1txz20MnpbLdHjpS0xO
 b6UUF2dTbM3Ui/au5dhHEKTlOcXEOBH8Y8pY8PBp9vK85iooRPLPs8SruhPnvAl/e9h70B2XxB
 e8ZId2WvZpHhBgC+s9J67y0YkOVTXPryjFl8MsJZlp0swdG5NI2/zSf6hGj9tx3hCATdPVUPmm
 1go=
X-IronPort-AV: E=Sophos;i="5.73,522,1583164800"; 
   d="scan'208";a="140216783"
Received: from mail-cys01nam02lp2050.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.50])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2020 19:44:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwPfcpe4n40GgFbF+yHS+yTBHkbA0P7VtkpRkL1cyAisNSorsHkcm1aaMWKiSpVCkC0gsXiWQpbxM+zq0YB4k18xe9u8Uf9oHzwDwGcY9hqcaVLZqFztCxKyn2CTDff/c/I85mEyv8wV0oeyi1iOkzn4X+osUoOUuUVMjjxjUQQ5xImPZ17tYOMs3Z0uq4Uzc5Wv76ViGjeeV9IzwTsjkkK8i5OhzVJjIURPG9uwlsNvC4x9WuqSWcX6uG42YmV9kCchK3O17OEEn4/bvxK7oslA0ievz7m6LGmVGoKXrHOp+pz5/PJxRV1V7nTIlrDalABXHY27IovCOzoBoMILng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtZqXDaW4tp6U/kH/VwVA8Ye0VW64d9tmUGFwdFADzY=;
 b=f8b0uvBXUqqyyFa8LzUXyLDnzP//DzFqADU4WjwjYQmDS1Rh2T7AQYNpCN/Kdp96SJjNN5+IdZyYNod3Q+FDB4Pxxv6GDPK98FVKA0Ox52/oV6/9qKiMBFcDQtFWdie4ay30lJocp/tYGS7NrzvZYnHRZu7AotaGdmrstTRdhfyCOnAvmpDvMw7FSA75XGYDnUuiPj120JwRN8qVN5X3QZqPgl0mbpZWHGLDjT7YpQv4YJtlqvF2BGomY3O5gNW+0sOFeGrCoQaRuX1u24757svyEUZcY2KwxiBypLzJ4nLnlIz0S3xswbQxDaqdT4FjrZWY0YNQwjwkhWkZGPpJSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtZqXDaW4tp6U/kH/VwVA8Ye0VW64d9tmUGFwdFADzY=;
 b=IPfydNjqKjx41S9rFEVyJJWB64ZvaXSSXQkJAWOWN6qUaH33fehPGDhtd3E360MeUaBcPnC/9tfiddoNn2lDXTdDxGzvCymGdFMu6KyleWaORFwuTxbX/Nr3hRybHJcv68Rk78IK03zkS5ff1t4aBXVJ3xa7YKClSbfAD7vCvsE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3998.namprd04.prod.outlook.com (2603:10b6:805:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Wed, 17 Jun
 2020 11:44:03 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 11:44:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWQvj3YPr08JZ2QEy1VbmJ7tAyW6jcr+Tw
Date:   Wed, 17 Jun 2020 11:44:03 +0000
Message-ID: <SN6PR04MB4640114902AEFE69CCC54C01FC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p7>
 <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 164aa643-6ece-4153-eece-08d812b3bc04
x-ms-traffictypediagnostic: SN6PR04MB3998:
x-microsoft-antispam-prvs: <SN6PR04MB39986DA2A245A4EF4ACECC2AFC9A0@SN6PR04MB3998.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eInfC1Ve7xgj1KHaBU1VRCaSeXtTIU92CuenNpXIeEorpYiB7beH4WKsSggUQDpteiqn+vjoesSmpKVKXQbSrzCNkS2Ri8EPmzpFVmQHGtcRg0AtwsBRahkuL+yCGxuUAGoqwrnV0i0s1ZYpTl9ApmRvW6faWlsKskFAUI4KeL9WOjaw765UZEfIpfgSg5+s+R9nK2t26nAS6vjXTbB10aJJzOt3VElRHcTRkVXuw8CgQACN90AwRS09h18HvN+XHWqK4s4B6yR1gijJzuq0IRSa7/h2qb+Ehkl5jy+C6Ah9GKVBI2h3ppOi0+f1HDsiLbRjos6kmCxWuIYn4NWtH+Q2rTsIcI3aPfLAvLy7rGeh9yD43mFQ4BpUp66YZZFk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(55016002)(4326008)(7416002)(66556008)(9686003)(71200400001)(66946007)(33656002)(52536014)(76116006)(66446008)(66476007)(64756008)(86362001)(2906002)(83380400001)(4744005)(54906003)(5660300002)(7696005)(316002)(6506007)(26005)(8936002)(8676002)(478600001)(186003)(110136005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FFdcROulaYHiJ68d11S21FvbqkBOq5PwJUQhuRR8+2EdJDkl21Db0TTodzSdA0WehhvLA0qfpalNWaND+Va1UYsoxpFGj5J/JEWDnGW6GB2IEvPunsFTKCzaFF5OamAU1xRTQZQis37uqZSmvxMgh8s1j59tvGMX8Ak4cTPPltiWeAPvyHh454rlSIGbBPaVGRhE9OrJ4ZIHhB8RpXqytpfIYnRbXWB7G0S1OcgoTHOtPDYLhPaPDOy+pGPBTD0ggS8iuaVXXsnH4HAiPtCT6Nn2kqkHoDh+Bs9h6JfKiNjVVA2SDge9E4ShD+ZWgUkgFtHQ00XdmjCJEP4WH6kkLFW14XTuRo2gWdKx9zClpD5WTG+wk2hQN4JKBm5jTQdrAtFarIfSltHKRHCPmltFxS6q0+dQr5lxWwe/7lhBp2JkHfUm6JHMYml6fgtpO13TUGUb8o+hzPnS4HrpLurrZE3bsx6QfjyVKBMLvHcFL3U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164aa643-6ece-4153-eece-08d812b3bc04
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 11:44:03.4641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mH+Z7o2YCwnyCQvpxDiUMGFnFhFZFExOuLzZiCxERETHg6LvbwmonKaq/8ksYerb8RyGwqDe2t9m0b8FuVPk8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3998
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICsNCj4gK3N0YXRpYyBzdHJ1Y3QgdWZzaHBiX21hcF9jdHggKnVmc2hwYl9nZXRfbWFwX2N0
eChzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IHVmc2hwYl9t
YXBfY3R4ICptY3R4Ow0KPiArICAgICAgIGludCBpLCBqOw0KPiArDQo+ICsgICAgICAgbWN0eCA9
IG1lbXBvb2xfYWxsb2ModWZzaHBiX2Rydi51ZnNocGJfbWN0eF9wb29sLCBHRlBfS0VSTkVMKTsN
Cj4gKyAgICAgICBpZiAoIW1jdHgpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNClNv
IHlvdSB1c2UgdWZzaHBiX2hvc3RfbWFwX2tieXRlcyBhcyB0aGUgbWluX25yIGluIHlvdXIgbWVt
cG9vbF9jcmVhdGUsDQpCdXQgeW91IGtub3cgdGhhdCB5b3UgbmVlZCBtYXhfbHJ1X2FjdGl2ZV9j
bnQgeCBzcmduc19wZXJfcmduIHN1Y2ggbWFwcGluZyBjb250ZXh0IGVsZW1lbnRzLg0KU28geW91
IGFyZQ0KYSkgZmFpbGluZyB0byBwcm92aWRlIHRoZSBzbGFiIGFsbG9jYXRvciBhbiBpbmZvcm1h
dGlvbiB0aGF0IHlvdSBhbHJlYWR5IGhhdmUsIGFuZA0KYikgc2VsZWN0aW5nIGZyb20gYSBmaW5p
dGUgcG9vbCB3aWxsIGFzc3VyZSB0aGF0IHlvdSdsbCBuZXZlciBleGNlZWQgbWF4LWFjdGl2ZS1y
ZWdpb25zLA0KICAgZXZlbiBpZiBzb21lIGNvcm5lciBjYXNlIGZhaWxzIHlvdXIgbG9naWMuDQoN
Cg==
