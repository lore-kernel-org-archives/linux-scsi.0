Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EADC43331
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 11:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D3620723
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 11:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Iap3iiUZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mcn4Kab0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgC1L2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 07:28:30 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38880 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgC1L2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 07:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585394910; x=1616930910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=daDgnQ/Jir+PSWgC6qnWAUkygxH6pfgK259ujqAGMl8=;
  b=Iap3iiUZ5IrhLwISriXbJI6QX9DQZmy/Of0/jwk4ud61R8OT4XvqEXhI
   bpWiH34x//2otCEFQcJ7RyS1q2z4k5WDh7TtBP4UxVkzTgNTm1JVG6coQ
   tXkkF5ymHI/h8+pD2pZIy1QiVdw+cXLILOgQWODMYiHpgzYU9W0nZb2me
   aQ4dOklDAlQqaQd7z++XnREXxr9Qbydt2RlpXzl/JoTvv1JfQhNMp5r1V
   V3AGj6MPTOXjahNvA0kJ9SvW5vlJGq+aPT8HtlRV1UFBCWXk1cCxxtLHP
   g+aYG46RVx3ynCDQbh4zIBb0q0L7iwPoZUb0GJo+O/fOKlc/5/7QKuYgM
   A==;
IronPort-SDR: DtfdMPfIUsnaUtCfaRo87d0PJdhi2obIG+5C5SBWG60R2fNIZ81LTVnXgfpNcBFFKpx0gnLqn+
 U7BXKSVLq5As6fZ+46MUSYb6hoir17Vvfs8Awc+hysdf7rSaKim39KWbTAMqubRLdDtPkW7ZBw
 3/QZt3Zl4ZWTbtU4qNfSi8A+qXBw3KGsEwGGx9PNTpKDHqYlxiEMCqkI6ZFPNZlrvl2mGCt9Uy
 XjybEHQyxIt9/AOGnVeylXBdun9NDk9OIBoTxPqYB+IzqlSW+fkqwqHyGPM6iFI8MRvIJCB612
 PuA=
X-IronPort-AV: E=Sophos;i="5.72,316,1580745600"; 
   d="scan'208";a="135193001"
Received: from mail-cys01nam02lp2055.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.55])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2020 19:28:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsGge+/YsJ+Xp6WkKiPGiLFZvSJ+qhFbGBxyV8m+dcveBCZe8n3XflUyONFmYbnxLpgap7L1CPziJjDP8YWB5xeLYZ2/PRQkwpKi86/6ClwcW2PQnohK5/NDgnwDqrwimN3NOVfScm2zrCT8DiWum8Q3XeLTuHgYY+pr4N9B2Xvb+uvynaQDM5b9cD0BM1Pjv3H3Bn6k6Kvs5gv2CYFZ7uA6y6SgrTjTD6hhgsTHb8No1ENUectZoxIkmxk5n6kp4tJQ04aG43/1WakkpHH3TJGJTPAwW7sXivYcacjM77bb48D8t6cm7sbWY/Sz73oiwi2lBJ3DpFmhZ9ToquadVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daDgnQ/Jir+PSWgC6qnWAUkygxH6pfgK259ujqAGMl8=;
 b=NPYTzme1kDb6RqCd6TCM/JxQ3yi48SASK7Sg3czT4Yh/4MGIwiZXKuTtlzgOTuK51NyeOd20dfAQiZV3toMSZEWwmtQEZiqczWRxFnq1+M+S7xLZJNPUL3wXdAhi1jBgwxScuAj0tTMzy7n0FhIk9A132dI+72DSe0mOCaIOvcZVtS5kEaqLkkf6oR9Kg0l76yg69btzZvkiUq065osxpS3pexPYlgOETG7iA/N2dAX5tdxjaoHZGbZlZvRkZ3hPCViqaMzUw4RNkfobr9IqpfMKWeX6wP88ZSQDCSqsxd44Xj4yF0cN0R8CwEMO5o5hmNbsTl9uSM2bOw7/QlUOiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daDgnQ/Jir+PSWgC6qnWAUkygxH6pfgK259ujqAGMl8=;
 b=mcn4Kab0X3Z3AIqfPfajmA51F9VIbssFBmPKnBYsdXMmnEdNStHAiMG0oNh6r9kOyDuSFneoa56U4Ydzepx9sGEKvsfw1QdTQdgf59qxz3lV2mjh3Jzr6VXkxJ9ZZ5VjUrze0UneCkVulcuH9gyVMPol/A7LihOEsMSPjCcmzNU=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5293.namprd04.prod.outlook.com (2603:10b6:805:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Sat, 28 Mar
 2020 11:28:27 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2856.019; Sat, 28 Mar 2020
 11:28:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Thread-Topic: [PATCH v4 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Thread-Index: AQHWBFstXCevzUCX9UuieWMryrlIrKhd3W9g
Date:   Sat, 28 Mar 2020 11:28:26 +0000
Message-ID: <SN6PR04MB4640B92BC9EA5CFEB74BE5EAFCCD0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
        <CGME20200327171420epcas5p490e1e6d090a540eaf050e0728a39ba25@epcas5p4.samsung.com>
 <20200327170638.17670-5-alim.akhtar@samsung.com>
In-Reply-To: <20200327170638.17670-5-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8609f09c-199b-4596-ffc0-08d7d30b2258
x-ms-traffictypediagnostic: SN6PR04MB5293:
x-microsoft-antispam-prvs: <SN6PR04MB5293C79F985799E5F0DDFDCAFCCD0@SN6PR04MB5293.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 03569407CC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(6029001)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(8676002)(81156014)(81166006)(9686003)(7416002)(4744005)(33656002)(6506007)(316002)(54906003)(55016002)(110136005)(7696005)(8936002)(86362001)(71200400001)(5660300002)(26005)(186003)(64756008)(66556008)(76116006)(4326008)(2906002)(66946007)(478600001)(52536014)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0yBrWRq6frY6Q+Kcjn4/LtZX7t4ZYx6KE+z53Jtw/7+014kcFPgJB7EoOn2PfbqKXmMlJdvzZFXpf87IwZIfRPZWHkWwLy2oOqzLN9J/tKhdxirsi1LXctwDEW/9KsNDK2v4NTf3ABFbW2dgpaCoqQgXLlyeCLrtF7Pb5A3fqzLk7T4IsOEpWY0/5NK4URpqi/lmU7tKQ6BQOe7n6uKXAm3PUfQLXJTrUkaTtBPWU2i8mPbC812VtLVEGBiNbTF+S2WL86iEM7tr/gVyNEJgrUKUY2bsctAbpKx2lBAIUq+PM4NU2Mqc4EgC1D8ArPqUnhY5ykPpqm2+/qfcjKXaftoJJ00/Pbl3q59EQQI0teTg/+PGHFl5T/u44TjE97M0WTLnTdLA+tYEvbZUUvTiHMZ1U9Y8ZenpO+VAAK7fbN0RmG2ssIIlr40Tteud5Ncm
x-ms-exchange-antispam-messagedata: ZPdY8PnW7+3iIIkuttKirQZ6sdZg2aq9g1cZO0aSDlqophy88nacBLZ6sSw1r6hnZ5c42u7E9wfi/qvxpc8Mg+MlgnQKpcGRFYj+Uz9HfCrqJvIOWP9vGVFYi3ZRueMWAwGth137OwUBcrA7+QyKFw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8609f09c-199b-4596-ffc0-08d7d30b2258
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2020 11:28:26.7565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0beeGRxkwUGS9mzr3mu/Rg4OtSdliwt9x8P1ZrS8z126yilMDJmdVo3I0p4UX+RutxL0DCmUzL1bPcy0M6ttw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5293
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCj4gKw0KPiArbG9uZyBleHlub3NfdWZzX2NhbGNfdGltZV9jbnRyKHN0cnVjdCBleHlu
b3NfdWZzICp1ZnMsIGxvbmcgcGVyaW9kKQ0KPiArew0KPiArICAgICAgIGNvbnN0IGludCBwcmVj
aXNlID0gMTA7DQo+ICsgICAgICAgbG9uZyBwY2xrX3JhdGUgPSB1ZnMtPnBjbGtfcmF0ZTsNCj4g
KyAgICAgICBsb25nIGNsa19wZXJpb2QsIGZyYWN0aW9uOw0KPiArDQo+ICsgICAgICAgY2xrX3Bl
cmlvZCA9IFVOSVBST19QQ0xLX1BFUklPRCh1ZnMpOw0KPiArICAgICAgIGZyYWN0aW9uID0gKChO
U0VDX1BFUl9TRUMgJSBwY2xrX3JhdGUpICogcHJlY2lzZSkgLyBwY2xrX3JhdGU7DQo+ICsNCj4g
KyAgICAgICByZXR1cm4gKHBlcmlvZCAqIHByZWNpc2UpIC8gKChjbGtfcGVyaW9kICogcHJlY2lz
ZSkgKyBmcmFjdGlvbik7DQo+ICt9DQpUaGlzIGhlbHBlciBlc3NlbnRpYWxseSBjYWxjdWxhdGVz
IGEgZmFjdG9yIGYsIGFuZCByZXR1cm5zIHBlcmlvZCB4IGYuDQpXaHkgbm90IGRvIHRoYXQgcmVn
YXJkbGVzcyBvZiBwZXJpb2Q/DQoNCj4gK2V4dGVybiBsb25nIGV4eW5vc191ZnNfY2FsY190aW1l
X2NudHIoc3RydWN0IGV4eW5vc191ZnMgKiwgbG9uZyk7DQpXaHkgdGhpcyBmYWN0b3IgbmVlZGVk
IHRvIGJlIGV4cG9ydGVkPw0K
