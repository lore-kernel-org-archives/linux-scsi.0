Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C26EC49ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 12:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8012089F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 12:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gRFfgemO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YjuW5xnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfIKMzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 08:55:14 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:28295 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfIKMzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 08:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568206512; x=1599742512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mxx5CNki3IHFe8OFMIZ/K37jVE5tbD0cPTdXfTmj0HA=;
  b=gRFfgemOPPpwJAQkjXgofrWtONJCfeh8sxed8DYgNbv2X5xAWkG+WS+U
   Qd1/bWaQai0noCmJHl1fJjZ1nIriH9T6qoHLBbxqsPKAhCgDJgV6MGGbb
   Et5pv9JThNOMIeigru6odoeB1/q8ClV8Of225Enx1uTZqrVeCuBDCKefd
   7w9RhoSJRoUZzFdudf0gC3GoVQ8uUoe4nT/0h9pbyU0egFDIZUYrTReWg
   12/th00YYqX3QfRXJVd5ZqBDRZX0W16svSYXJXS1qsT4RinkNSSPlP07a
   c50RmnTlv2RGGQ8MyxjyZmnhfjhV9eIfbcejloPATfe7Ib2wV/OpU0WcB
   Q==;
IronPort-SDR: 59qypxNeGBTp+wrdZ23akAAf4qzIFcUAmzfhAyBbQJzRLwJoOA9n+hzq3/fgE5RJSeuplp8E1G
 YRjPxhPQyms2my+yPmzNuBBnk6crvT5rxVRwxbCAwYCWsDyHkWafJaCn+aZyebIrgn7geoJLnj
 jejJZh/HvO/o+y0dymM8LntTuxvpsKkVqNKdSm2YjxmQINKT6icoRs3NmfAxHVAhu2imPasBkx
 lfGF3JzRDpT0lrDLLcFkm3YtpjCk1ZSCA4sjAnlrxocl58Oqd6xOFE5vAY/BV/NLQsIeZpxVn7
 Aeo=
X-IronPort-AV: E=Sophos;i="5.64,493,1559491200"; 
   d="scan'208";a="224773197"
Received: from mail-by2nam01lp2050.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.50])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2019 20:55:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOHRJ7S7VCkIEhhxpb/SCy6cDaZgc0UgWY+5KG7SutYZcf+oqmV7ILyNloqeYstplhMvS9a63c9WCxU58t+aezUZpxX2yWwfBmW8UmCEeBK+AEjZrVseQVAI5tSPz20l1dUmzQJAUf2Hb86oVkkbC7Z4Bj7GM9nnsgUBVqDtLdd1YEn1sI72CWDLHjbsAQ1AUYYEf/c/XYNZxh+qCZV+YV+FmoOQxeikhIBDovG94aFDLXduAMBRDSbNgas6jEbBKw5T5QwCSlz4Q6X9NCrRho3SkRrtiyll48aBa6JEA87wvD9zAqKD2FJUnmGMYStlFInIdRvcVNdNuuZZCMKAGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxx5CNki3IHFe8OFMIZ/K37jVE5tbD0cPTdXfTmj0HA=;
 b=KhKnwx0wXQ7VJbCBARpEdnZjn+pUqxEQYBubujer92+tGotMRqz04HPGj8TOgJNWPs+mk8odfq9EdeqMp6wIz/Y/xM09lbb/F6SwiFcg01EYQTP7gi3GwdGbWWBcoi/pnXEWz5LwTEnTRGWXnrYFCPTNoVmxUVrmwQE24TMSAl8Y6xVs9prJ6Ld9slPbUFDCBToHKuRBoMCWouxC66/mwi8wzge3kE9lT+Hlqj+GR3z3d4h24ynIaUUSHRsMSwDDS8FS8EtJOW9ko7W1pAHpXe9CLtG+fytOF+yaGsIkb/Sfuq4FsIav+TiM7wXgf2rL05s+tT0ohmeXLOqBEIekyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxx5CNki3IHFe8OFMIZ/K37jVE5tbD0cPTdXfTmj0HA=;
 b=YjuW5xnHDJ50xgqWt1BGYohL7RpOjlm52rObnMC3xAc4TjdaiL6CSOdKY/byd+Q+OpdAhaW3siyzAk7u89E+PH1ATh/HoUlviguGK9QKKW0pf7vaDHRtg5uIFw3rQfaJE2JF7npXmwZVI83tNXio5Mz+pRgjlOKIAr6lRlECPas=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5536.namprd04.prod.outlook.com (20.178.245.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 11 Sep 2019 12:55:09 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371%2]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 12:55:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Markus Elfring <Markus.Elfring@web.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Allison Randal <allison@lohutok.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Kangjie Lu <kjlu@umn.edu>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Li <liwei213@huawei.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs-hisi: Use PTR_ERR_OR_ZERO() in
 ufs_hisi_get_resource()
Thread-Topic: [PATCH] scsi: ufs-hisi: Use PTR_ERR_OR_ZERO() in
 ufs_hisi_get_resource()
Thread-Index: AQHVZXjxzhPiQX5u6EWxRGwM6AldQKcmdR3Q
Date:   Wed, 11 Sep 2019 12:55:09 +0000
Message-ID: <MN2PR04MB6991E9732236A682DB8E9A2DFCB10@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <9e667f19-434e-ed30-78cb-9ddc6323c51e@web.de>
In-Reply-To: <9e667f19-434e-ed30-78cb-9ddc6323c51e@web.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfd1524b-07d9-4627-41ce-08d736b7471d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5536;
x-ms-traffictypediagnostic: MN2PR04MB5536:
x-microsoft-antispam-prvs: <MN2PR04MB5536DADD3066B4DEF04BCD71FCB10@MN2PR04MB5536.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:153;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(189003)(199004)(5660300002)(110136005)(6436002)(81156014)(66476007)(229853002)(9686003)(66066001)(66556008)(76176011)(55016002)(305945005)(53936002)(11346002)(446003)(52536014)(26005)(2171002)(186003)(478600001)(33656002)(102836004)(81166006)(6506007)(14454004)(99286004)(6246003)(4326008)(2906002)(86362001)(3846002)(6116002)(66446008)(7696005)(66946007)(76116006)(2501003)(4744005)(316002)(8676002)(74316002)(7736002)(54906003)(8936002)(256004)(476003)(7416002)(486006)(25786009)(71190400001)(64756008)(71200400001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5536;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s72nUB/8H7lwifCv5USx8CCG8WA1RJAvp9SXcTwsDSgA8fRvbexsW5dh0froGc+OB4Ko6SItMnzyyIE0ATlBHJJUptOjw4UZnGFYh5VxHO+aLbbp9bUHEDu0z+CtYse60Srxon73T0NOR5d6cPl8GrCJ2g6v+0BFZ8mAkBpmO8m4Z/B3NnRl/8PBmf1gfiVSuWG8bU+utkoFjefifMNn855Ar4UN9sFf6JF/RhNVl+KQ8dZy2lzOZoLvjVQTeBr32Ma7N9DnOwlLZeKr1y3cyqXIENidrOay+F91awv+F80Qwm9gGbFhe5U/sGSVwcSKDx+4gjYIHlw0JXY1IHswDLatkqYCJK1FPSBGGYgKliP82gbEBIV5Gm/LPZk9LCs77OqTq69ZEb6cKYmBxVN0yX9TZOU9gpd/SBIo3xebz+k=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd1524b-07d9-4627-41ce-08d736b7471d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 12:55:09.4838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfivUfFHN/AUlMRVBA/58Ow+7157qJtjVLuE47caKe21ldQzXS3RvF5UD9AY3hfj0g4/4z6bgDc6z+AFnZg4Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5536
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gRnJvbTogTWFya3VzIEVsZnJpbmcgPGVsZnJpbmdAdXNlcnMuc291cmNlZm9yZ2UubmV0
Pg0KPiBEYXRlOiBTYXQsIDcgU2VwIDIwMTkgMTQ6MjU6MzEgKzAyMDANCj4gDQo+IFNpbXBsaWZ5
IHRoaXMgZnVuY3Rpb24gaW1wbGVtZW50YXRpb24gYnkgdXNpbmcgYSBrbm93biBmdW5jdGlvbi4N
Cj4gDQo+IEdlbmVyYXRlZCBieTogc2NyaXB0cy9jb2NjaW5lbGxlL2FwaS9wdHJfcmV0LmNvY2Np
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJrdXMgRWxmcmluZyA8ZWxmcmluZ0B1c2Vycy5zb3Vy
Y2Vmb3JnZS5uZXQ+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5j
b20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1oaXNpLmMgfCA1ICstLS0tDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtaGlzaS5jIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtaGlzaS5jIGluZGV4DQo+IGY0ZDFkY2E5NjJjNC4uYTBlYTU3YzE5ZGJjIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1oaXNpLmMNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnMtaGlzaS5jDQo+IEBAIC00NTQsMTAgKzQ1NCw3IEBAIHN0YXRpYyBpbnQgdWZzX2hp
c2lfZ2V0X3Jlc291cmNlKHN0cnVjdCB1ZnNfaGlzaV9ob3N0DQo+ICpob3N0KQ0KPiAgICAgICAg
IC8qIGdldCByZXNvdXJjZSBvZiB1ZnMgc3lzIGN0cmwgKi8NCj4gICAgICAgICBtZW1fcmVzID0g
cGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVNLCAxKTsNCj4gICAgICAg
ICBob3N0LT51ZnNfc3lzX2N0cmwgPSBkZXZtX2lvcmVtYXBfcmVzb3VyY2UoZGV2LCBtZW1fcmVz
KTsNCj4gLSAgICAgICBpZiAoSVNfRVJSKGhvc3QtPnVmc19zeXNfY3RybCkpDQo+IC0gICAgICAg
ICAgICAgICByZXR1cm4gUFRSX0VSUihob3N0LT51ZnNfc3lzX2N0cmwpOw0KPiAtDQo+IC0gICAg
ICAgcmV0dXJuIDA7DQo+ICsgICAgICAgcmV0dXJuIFBUUl9FUlJfT1JfWkVSTyhob3N0LT51ZnNf
c3lzX2N0cmwpOw0KPiAgfQ0KPiANCj4gIHN0YXRpYyB2b2lkIHVmc19oaXNpX3NldF9wbV9sdmwo
c3RydWN0IHVmc19oYmEgKmhiYSkNCj4gLS0NCj4gMi4yMy4wDQoNCg==
