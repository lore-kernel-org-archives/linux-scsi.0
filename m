Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43ABCC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 08:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB40320848
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 08:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DM4mv103";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xKxeM6R9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgALIle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 03:41:34 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:55170 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbgALIle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 03:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578818494; x=1610354494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NyxpCLCN9MEABEmeCDubKrmvjwAgNc087gfdNuY0Bvk=;
  b=DM4mv103PV/oES0ng5P2YBSynnPATiXf1sH9xyrxM7sG9DMZKhWRthYB
   ld1F03maqePdwBcqiT69EEkDeKITwxnaFI1c0TNVvd+fSQ27+BLROG993
   sM/dj3tNggvQN0qpz8adMwY9AVwbJCT4zt2nFKgHRqQIQZ78nRVtZj+Pw
   1puT+RZ/zYpjedK6g7oGLXyK3W8I6UNGSvs3xg+faBcjv7lkMCJ5s4YRb
   i7gJPWL8KbIgVCaW05faBJKnBHyT0azjJ2f0KQWk+ssC4nTABMx7Afw86
   kAdB7brJJHv/YGHfIll0qUU+p2XRolMx5ZjYjXZZidLTYGmxaYPr9yIQQ
   A==;
IronPort-SDR: ruUisxSoSlwE2hjMh1ir3tLVnLU88XHhAs9qXcMIwN2Aq0mRtYEmGv+o8DcE0+n58+s+Io/eSk
 WVf7w+aP43X3n4ZzSNI/ErT7mkpTM8r/oDWEueF2ehlx3z7G2bAuFA+pqqC+9N7YbUVeETOK75
 x9r3jHZIZ1+rM0CfSeYSbSVpZdOrSxZ9a1DtzfdHcnPUAPT+sijwnfYCY+cozSPm4aY/fNsaot
 mhOL3juPmH9zEZ3vOedIcBBGabBojbuHGvKm4I6o28c9mqm+2B5oc7Zt+92JXJYUxsTiJJyfPi
 8kw=
X-IronPort-AV: E=Sophos;i="5.69,424,1571673600"; 
   d="scan'208";a="131696241"
Received: from mail-sn1nam04lp2058.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.58])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2020 16:41:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHX7NPAZCFgGUb1Xrgx1a71fbpW1lV+81NDj/bS/OuoDtq4LdKHWS/mASjL1Z2ZSthikbeqT2UOYjUGUWLWXCAnkYqAl6a8JCT8AfgyDwQtl0oUhOaz36kIkNUFTYMElZDQ0nobyHUzKyZYMe2p9U16l61cxMAmr+7SD+TRxiPLdl6Y8uIyOnijG5uf1Q9SFgm9CDfyP+9Io+d1xHdRxq9miFMzYYAxa497eStYVuv39vhnHhHq3cHYyMwENLZTtZeRDdeUiNKcLunAFPbIClase1gpkUm/IWddishanhRckrJTY6ycTNCGby5J9KsKwrWTBMF4+tHoIwmuc7v5nUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyxpCLCN9MEABEmeCDubKrmvjwAgNc087gfdNuY0Bvk=;
 b=d+fPwIc+FUYU/ls2G2GI4BX60V/tlaFbfiff6YXjQDF9OQJn6YHEQf0Mw41233HrrXHejrHmfrpeJ4dVjUBPR5WXSLX/bEQR785UvE55qBvjskHf4Oa8vzXlJFfvY23RVB1nLMq6V6/D58VY+dddoTSyv6CdXFhZT4pAyufjX5c2KxpZRUh5spQ/K+A8miDR2r6sRPlOTm5Tm+VX68rghT6/GhQFM0+ceyx4GL+5BjRbQgT+lPkjZwmgJiM4XgPjz/tr6mdM5hE/sRqkim5SgDgJTB5Nbwgdg3c9ulJY8kTI+MK8eOnb9jUZik2MEuOnpU0vcQvmLWPy0j2eXOAP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyxpCLCN9MEABEmeCDubKrmvjwAgNc087gfdNuY0Bvk=;
 b=xKxeM6R9uYoVB4FpKi+M5Xk7VPUedTxVo7ttzKSdTnSKCLH4x34eYkdIU9LdvBdb26Xu+eYILfBmuVX9NmsqagfPSTqLck1+G4w5b6C8kyduOHUa/o4xy/o+2ZXGrueVchRtRtyYO8yAaYl2fhe9HEFfOWV452kcpQ6l7KDRphU=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5645.namprd04.prod.outlook.com (20.179.21.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Sun, 12 Jan 2020 08:41:30 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2623.014; Sun, 12 Jan 2020
 08:41:30 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] scsi: ufs: initialize max_lu_supported while booting
Thread-Topic: [PATCH 2/3] scsi: ufs: initialize max_lu_supported while booting
Thread-Index: AQHVx+Tr0ijOBGgPSUipJWppCzuGnqfmESaAgACl8yA=
Date:   Sun, 12 Jan 2020 08:41:30 +0000
Message-ID: <MN2PR04MB699126C95F23E15BC778FD72FC3A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-3-huobean@gmail.com>
 <95d093b6-591c-1f16-befe-3d192d7c0e2d@acm.org>
In-Reply-To: <95d093b6-591c-1f16-befe-3d192d7c0e2d@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 324e350b-186e-489b-ecd8-08d7973b38af
x-ms-traffictypediagnostic: MN2PR04MB5645:
x-microsoft-antispam-prvs: <MN2PR04MB56451978FDE9FB6AA9EF578EFC3A0@MN2PR04MB5645.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02801ACE41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(199004)(189003)(64756008)(66446008)(66556008)(9686003)(33656002)(4744005)(7416002)(8936002)(110136005)(81166006)(54906003)(81156014)(55016002)(66476007)(5660300002)(66946007)(76116006)(71200400001)(316002)(4326008)(52536014)(6506007)(8676002)(2906002)(7696005)(86362001)(478600001)(26005)(186003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5645;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D//6+mBE8Te2y+0HqQApnGoMYs593zKJgxjUXmymy2yr/abJ3+9S3G1FYl5B3ePkv6CNhkrNp+gwsDrQWAd0ZS3qj1WJSB6Ai1rtAgoyO8icASBWHYKHjebkg2/SMl1nPYMJCr+KUrXpRFelmTh/6k1VS8eyOtfZECFu6JmwQa6KmMQs0sVxCQeH+9ddiX3nvceAfEXURa0rkYz2rWNoYrlyyUmnOwO/aJcZnbV3juv3u87YWFaePrzEuOI+gH0H0Ul/jzzKZK6Ed+viipYRxIaELPD3BTcbNZEca1JrUmAuzG1hKTJrklJpUSumcB+fPqGxDaVyaP1ZQr8HYCkfkVM2pjQ5SkUUkMSjx9E9hhyyJiws/rHCkhTEJI0PiBHhfITpKQGf2H+PchiBVcG7IZxQedvlha5dn8ZBgHfmQcUGPCjvo70jS2PO/oOTkUs2QfvJENdl/QEGQ5GoRCQgTATd93LZwYn3+V79ayB0HC49MCAEfYVK4ynylqRA/NLO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324e350b-186e-489b-ecd8-08d7973b38af
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2020 08:41:30.1821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQ1Mae6HhX2725KP4/Elujq22LE21yxhi2aaqJAeWpPAsHXN8jRDYXgVl8NlsT+H6vjW0TjwKaPYKUBxhG5oFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5645
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiA+ICAgICAgICAgICAgICAgbWVtc2V0KCZoYmEtPmRldl9pbmZvLCAwLCBzaXplb2YoaGJh
LT5kZXZfaW5mbykpOw0KPiA+ICsgICAgICAgICAgICAgLyogSW5pdCBwYXJhbWV0ZXJzIGFjY29y
ZGluZyB0byBVRlMgcmVsZXZhbnQgZGVzY3JpcHRvcnMgKi8NCj4gPiArICAgICAgICAgICAgIHJl
dCA9IHVmc2hjZF9pbml0X2RldmljZV9wYXJhbShoYmEpOw0KPiA+ICsgICAgICAgICAgICAgaWYg
KHJldCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKGhiYS0+ZGV2LA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIlczogSW5pdCBvZiBkZXZpY2UgcGFyYW0g
ZmFpbGVkLiBlcnIgPSAlZFxuIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBf
X2Z1bmNfXywgcmV0KTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4g
KyAgICAgICAgICAgICB9DQo+ID4gKw0KPiA+ICAgICAgICAgICAgICAgaWYgKCF1ZnNoY2RfcXVl
cnlfZmxhZ19yZXRyeShoYmEsDQo+IFVQSVVfUVVFUllfT1BDT0RFX1JFQURfRkxBRywNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9GTEFHX0lETl9QV1JfT05fV1BFLCAm
ZmxhZykpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGhiYS0+ZGV2X2luZm8uZl9wb3dlcl9v
bl93cF9lbiA9IGZsYWc7DQo+IA0KPiBUaGUgY29udGV4dCBjaGVjayBpbiB1ZnNoY2RfcHJvYmVf
aGJhKCkgbG9va3MgdWdseSB0byBtZS4gSGFzIGl0IGJlZW4NCj4gY29uc2lkZXJlZCB0byBtb3Zl
IGFsbCBjb2RlIHRoYXQgaXMgY29udHJvbGxlZCBieSB0aGUgaWYtc3RhdGVtZW50IHdpdGggdGhl
DQo+IGNvbnRleHQgY2hlY2sgaW50byB1ZnNoY2RfYXN5bmNfc2NhbigpPw0KQXMgcGFydCBvZiB1
ZnNoY2RfcHJvYmVfaGJhIHdlIGFsc28gcmVhZCB0aGUgZGV2aWNlIGRlc2NyaXB0b3IsDQpXaGlj
aCBpcywgYnkgc3BlYywgYW4gb3B0aW9uYWwgc3RhZ2Ugb2YgdGhlIGJvb3QgcHJvY2Vzcywgcmln
aHQgYWZ0ZXIgdGhlIHVuaXBybyBib290IHNlcXVlbmNlLg0KTWlnaHQgd2FudCB0byBjb25zaWRl
ciBtb3ZpbmcgdGhlIGNhbGwgdGhlcmUsIGFzIGFuIGludGVncmFsIHBoYXNlIG9mIG9idGFpbmlu
ZyBkZXZpY2UgaW5mby4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBC
YXJ0Lg0KPiANCg0K
