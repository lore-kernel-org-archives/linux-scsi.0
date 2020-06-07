Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87D6C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 07:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9386820663
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 07:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j9FVjGkG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Eyw+9E4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgFGHGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 03:06:53 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57150 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgFGHGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 03:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591513611; x=1623049611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wyPtyP46xBl5usqImeocN6zaLCnslYSmZ7myqKtDSB8=;
  b=j9FVjGkGVKrUN980hg7MSRGkIt/XY1cj6KOiFd0ckW4eqIuQ0ilUlLiB
   VW1WWU7sNzGw3K0OehZveRCqEm1qwRFPu0YLOYp0K/0QGuKuiFekpRPyA
   LTyxZdvTo38jgXGfThNqCcxcntkJ6roO2ApaqhwkpmO9UmCqKujpuNfoy
   tkpkYMFUvg/z0fnRWMDyI4EUgalHNgG2Yagj9lyC4WLeslwes4kRWWPlp
   avHWp4aigjvD+QJieKGSDKeUzmiTtcffMdWGW+fCMJrWybiwPL88Pxw2c
   naWQ9bm79h+UA82M/lCOW4cf7PL7NZGtsOGcKyT22nnO0FppXufeIovJ0
   Q==;
IronPort-SDR: z4fy/xSPgBWFuwBEubY/J5k6l9X7Tsrpk+EHk3BvoV2oU0i/b1Z+8vNenY5vf/qfKh9T2BkqpE
 ps3w73MZ25xl7Xm59rQzAJABl4YSIJHPxxHibitOjLm6e4qBf79o0THKVYugwyq4ocCXsEtG2j
 4sF5oiNQy2QwMnPtiljpIDq68uK5gxOGCigHMQGIqlS7EnziqrbiamEiaSgUjXsQLu2FYgMj9f
 MIG8KsBUEoQMGO2Dkqazohq76AZLnL2XyuijhpLMkJ2B3EZ/Xvj9/oCzFFlr3OK5BikrWmaGBr
 8Q4=
X-IronPort-AV: E=Sophos;i="5.73,483,1583164800"; 
   d="scan'208";a="143699598"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2020 15:06:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT96RCD0RKGvgESIMF2932hF64TKlWfsggyGl4yQy2yEUXK87fICucWOhQjzbcAENWv27ZFoUEbGtir7NBkYLoPabx7nAww1ZEaklPBEUGD/xA5PU+G8XhlIfQsAm1C5ixX4+9sju7DNy98lctCfFsuPoAkUUimSK65kjIEiRTuTpoZo7jzS9xzYu7SA7i/VVAjzxeVg3i9VWU0zrOo1g+LFO6Ap6YIH923/yupiLZB7cK4a3tLNJfsiRnAlMoG2N4TmedH8SE5Jo9qQHgC6Ji5jrQzPaIWwunYGzjIvmNEqSbjBmXPtzcKzntrvkAG6rPRfFctiylMoVKcBghEbtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyPtyP46xBl5usqImeocN6zaLCnslYSmZ7myqKtDSB8=;
 b=EBIIZy9KaiS/oz8bqdiCoeDzF63+2yiGrtj3PTKugh57fUWWqfy2EhtWUSpTSaAxQkbdDOmXViVofNQM+MlDYoLp00ni+ZIwcvq6P/mSgSMIyy5tPch8Q6em4RAAqWittAxGHMVTfyl0cB8HrhsgX9Fh+mU+BpGyw108V1mL7DB3RnSUTVhoep/zugheBVX2FqrVE3tS25mfmoRG40/F3W0JgKQMwJWCa8f5MDpVvuKBm0bGiuxA3c7Hoh1Tql6wXljE4nmSKByWZbGFViYZqq6MEhQM5+pkW2AKmzdvmTjXKz+DcaMgZLt/YxMSSC1zUQv6DVkCBVvK6KgVNtGv0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyPtyP46xBl5usqImeocN6zaLCnslYSmZ7myqKtDSB8=;
 b=Eyw+9E4jYg76cOggoHhBKGnpKJKKQGFAd+OeeLghrdb1kwVgn/r0WbDug1ju+8b0P385iXquHxWjSud4bHMI5xcvEeIz9WHNKMe1Gd5tENB/Fcm7o8rleMU+1olDCFGgDcjxWA4x2bweltmNJBWZhJzth4A5U5/I/m7T56G7+DI=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB5815.namprd04.prod.outlook.com (2603:10b6:a03:105::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Sun, 7 Jun
 2020 07:06:45 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 07:06:45 +0000
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
Subject: RE: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
Thread-Topic: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
Thread-Index: AQHWOtxXhjJ5JD6j7UapdYSyFhANFKjMvdRA
Date:   Sun, 7 Jun 2020 07:06:45 +0000
Message-ID: <BYAPR04MB46297B7D1CDD6CA00E87F640FC840@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
 <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d5dd3c1-30f1-49b2-b039-08d80ab156fc
x-ms-traffictypediagnostic: BYAPR04MB5815:
x-microsoft-antispam-prvs: <BYAPR04MB58151E9ED963EABF6D5146BAFC840@BYAPR04MB5815.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 04270EF89C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T6UHxXVIKPM+qxRCzCE4vR4uhAxmz4h6dyRQdz97K2XnJUL3XWXzRn1ZbSqetB2c7TGCb3Ub/iF8EQbwByljbVOimKKNJCniK1WuXqtx5GjUrI8vz5oEjE3zXID55B7H9vgkffPSKYxSoRzciHAOdOLfE2q55rGDs5TJbmZa2OVRrWeV+erXCm/zZ24zKwzlbnvplKGHRGs388xDQWZPvQSKPvlTjUsw6Dw6QGV004fHor6ngUqhJ2mlARGpXpdl5Hicwswo4w0V/xhKXafwYnSCWtUAy8PO/A1ZCU4R1rtj4xqfsLjdG/SfxIKPRsMKGRIrm4q9bcLsfUfN4NFl3hD2kIKPCh5WVO1CI2g+/RldiL1sGE3N0e3KF7wXqvNB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(86362001)(186003)(6506007)(478600001)(66446008)(4326008)(54906003)(8936002)(8676002)(110136005)(66946007)(9686003)(55016002)(64756008)(33656002)(66556008)(26005)(66476007)(52536014)(71200400001)(7416002)(558084003)(7696005)(5660300002)(316002)(2906002)(76116006)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5oOeFp9PUYBop9adT7/jQJzxmOE9aXDx+2FwiDZSwVh5TO4Vk6tS0nHsMrr4Btxeuay+WBhcJ5j/LdMkTHG5ZOAN+W2+08dleKWrfk96ZTrobUqgNV6ugce9jKWmz+uIAyf1LpOn1f5/CC8Ct2BA3UDBdGRJB47WFGNDPWk7f8VZysJrYd295bcUZ82jNH01OcSyeJrouMLFlihYUJBAJynXMJMLaW0cKA3Hq+42vdXnU35To3xjdyOC09LY18H6lQvg4v/2eVb/mpSHNuFcw8dGkHz3dOqhqcM8EHdzevPLbT1QmLsfQYapZPpDUEm3dP7yQ5ktae/fHDY8hLadgSkyrm9R1Y8H+WYz/jhWEdHg7Qhabz/Cizyl9dIg0IyX1ZMTwafl8lsbUviQ/kKPJ3UYgmhTea+bJx8ozwX2scp/+NATPR2JwwrHj9cT/kHXJVR94pwx3Q5Tk7Fp1NeQ6sOGXt+Yo0TM72oiJfo2MTw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5dd3c1-30f1-49b2-b039-08d80ab156fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2020 07:06:45.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oOlueIN0blnZgdVDyy6wDqDUE8BYEnWebThFtiAqoNy6MHZMHZxhx7e6tI8YmX+OwbLuJ0e2DR+Z3oUC95Tp1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5815
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgaW50IHVmc2hwYl9nZXRfZGV2X2luZm8oc3RydWN0IHVmc19oYmEgKmhiYSwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB1ZnNocGJfZGV2X2luZm8g
KmhwYl9kZXZfaW5mbywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU4ICpkZXNj
X2J1ZikNCj4gK3sNCj4gKyAgICAgICBpbnQgcmV0Ow0KSG93IGFib3V0IGhlcmUsIGJlZm9yZSBk
b2luZyBhbnl0aGluZywgY2hlY2sgdGhhdCB0aGUgZGVzY3JpcHRvcnMgYXJlIGluIHByb3BlciBz
aXplPw0KDQpUaGFua3MsDQpBdnJpDQo=
