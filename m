Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987F9C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63ED820738
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CK3Luo9o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QXBy3dai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgGSGBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 02:01:18 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:3719 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgGSGBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 02:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595138477; x=1626674477;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=iK9+qTJKRKlkzSunbCBdEp6kWL0Qg9yi1u0AxRI6znc=;
  b=CK3Luo9oI6C+GLe29bgLjDzSMnvfrqc5sjJmOVmAnGvLlm+83JtBJc8M
   CRJudya7bpUFWO06adIVTvpJ7wWYUSYI+3cMlI6kX2CvltGgkZ/tZ2+/J
   54WZN2suISmlE59I6k/OLFptAs0AxJu0pit2D9J95j91bVy4muorBxG02
   SA2jvY2XScMOXDmqUGchq0vKiNu+2JfhQP4rNQ8afgBou3VYLIGrouBIS
   hf9dMS8yc6jHIeyS+FVpzDQTJXFcvCn4BerqIl5ySg0tmIw52wl9HOcS3
   IhnStZGjUIrOW/fXeaTaZ8gSbQVtJ6FJN6KVcA7JA2cnUYf8MfSDvVksM
   A==;
IronPort-SDR: C86MDUV1+DCn/eQ1XYTCcbwsJyQgNzYNcYcP9Cb4ezUF5PnY9xH0usmtna0fAQyyc8jrz7WWXj
 zjfZjtVRBmnU1oPZW5Ri/OYIiZxg4NlLA8PQYE8G/cFg7uw10CYvQbJ4BeBgk/qC8Ex6tBsNl9
 bogCohEonsmBrovy7r39DeS7rqB16btsJEtMWsDMBYf07vTNIz1+lFQ1Qhkm1ZPcplOVA1v2KF
 TpctegOJU+7qWTWB+k45DxGWxIFZLZaB3wthjP3PFvLekwjX1u4alw/eomKoNBU8pcCX459ORR
 RD4=
X-IronPort-AV: E=Sophos;i="5.75,370,1589212800"; 
   d="scan'208";a="142825704"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2020 14:01:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbCGq+hDfbIljfvYZAd2KrvAB8sWgKJPmVMCAQWsKnQUUIOHQLxs+wU2CB2we71XDMWoiqkzSFf8Io9begQDJSmq8qiVsMNG3mE+Wq1odSZrsUQiWe/OFEcqURr4dIvbffr7SL2UvAr3iZUJPJIcz6Z9kzh02jToRxBhQ9ySDFWNfI9scur6JtD2iA9v46HiVy+a/iiYQRr52ytN4GmCzDioC5u4tZC6oJvyawnK3PPS6yxyw+dvxeoYsN1+jFfL5unOXP2NNShUZKUSs0l81HR4U4dS1kiP3i9Eehamh4nzK/7DX9RuPVMVbOjY1JH1iUn++078JnrQuXnc/xA5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iK9+qTJKRKlkzSunbCBdEp6kWL0Qg9yi1u0AxRI6znc=;
 b=oUPcqRZnKeKx3q/+0qU8Y9WffCzZf9HeEqO3VHqhFiDmh/7NTNnHelOrTSCY8DwA3NqA69s7iEVUPCW3ayUansi+zqmLAnv4Sn6lfvmczHnKpmr/trJkTprYoUbreRv5pNHFGFyQFRcNQhBAAb7rB/A/LiUVheD0DgzJZx+uNDJ87NEh7pimz90Apgq5Ce3eckgFJDbr/8dY1xIGfdLLkZh0mHl3sdfSHG70fEirF/K0Ahk8KZN61IT9PEPwqw9fmXBwG791Vp0az8eoRGGS5Wd5iuB5sEdXgRI5h/er2XLa9IChpA8GEB9GgORVv34YhmxKcILpXcYPROOx7czf6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iK9+qTJKRKlkzSunbCBdEp6kWL0Qg9yi1u0AxRI6znc=;
 b=QXBy3daiJ0DXU/ubHfgjJ56Fnm/pOaATtufJsSwgFnRjSsQLYrTnhc8gMB7XUZy1v+ogp95p6rrzO0ML9cLSZk+tcJfmFmIIwbIEPNc25YeCTfVHlmuO38HFrdbkCGaLHFkuuESmGDcCHI8TRHLEkOStsuTwODOI+++z3vQgR2w=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4078.namprd04.prod.outlook.com (2603:10b6:805:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Sun, 19 Jul
 2020 06:01:12 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.023; Sun, 19 Jul 2020
 06:01:12 +0000
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
Subject: RE: [PATCH v6 2/3] ufs: exynos: introduce command history
Thread-Topic: [PATCH v6 2/3] ufs: exynos: introduce command history
Thread-Index: AQHWWnxJa5WvuOsKUEi/TpEHq8GraKkObtTQ
Date:   Sun, 19 Jul 2020 06:01:12 +0000
Message-ID: <SN6PR04MB4640FBABF1C657C1DB932F18FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1594798514.git.kwmad.kim@samsung.com>
        <CGME20200715074758epcas2p117bed09c65271199ac0008a5a1564570@epcas2p1.samsung.com>
 <f7052ccb43695b21fca28eb846bf2ee9d5bc7809.1594798514.git.kwmad.kim@samsung.com>
In-Reply-To: <f7052ccb43695b21fca28eb846bf2ee9d5bc7809.1594798514.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 831b4a65-4f2f-4bfb-c0b7-08d82ba9241e
x-ms-traffictypediagnostic: SN6PR04MB4078:
x-microsoft-antispam-prvs: <SN6PR04MB4078D28824C7B802E8E8BEFFFC7A0@SN6PR04MB4078.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: acm74X5sxI1HhgNpsCmIKZwN+YLlZHbHDmCkZnCRWmQPYzqWA2fEaISE8WVPJtreik+gVIdFzM6o0hwrWDqG+0p51z3MzB88Ct2j5d1z1dNKMdv+7rgcsS5tHiqQKWUPE0/8wlJdOsbXuzCglv0a2xpfk77IjJ46WOaJ1xiAr+XhCwjT5BzFh9z0/7T9YTJj7RPEwhEOc70nZtXZxpmMlt2tAE1o8v8R61lUSEJVmjB3OdwAz4qISduim1TQctCoZy2hpaVRpVHaiZDMmUwUpGZNqAFgNSgDGZ+1HE6tUuxquUt1MPAp5lXwWmHQ9K6hWJ9ANWpSnXfPZC2eE105NjEM6i9yzNEHO8vQb+KDmqfeQBf6JNAy5JWvFS6Yqcgw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(55016002)(52536014)(8936002)(186003)(9686003)(7416002)(5660300002)(316002)(33656002)(110136005)(8676002)(4744005)(76116006)(7696005)(86362001)(64756008)(66476007)(66946007)(66446008)(66556008)(478600001)(71200400001)(6506007)(26005)(2906002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Qg+n+ANtw/3Mx7PyDLSa4j01XwtRRGuzJe/1grHb87R+/gusdcUpShpmIV683BBnGOEAK3Evakm25tNVdOeUi62LoDB1zWq3nkK6yCtic9EyAd5h0Q1qy1oOcpXD6MS3ofWCZBIA/40Aye7JA+XpnCwGDy5Z+Y13TZKyr8LxNykwE/v5Kyw5qb+TsTyvF/U6RfWaCbkKvQaR46lRuUkWolhhD6IttrTksYqdG07bLQbFUdlEhPoQuLKZS5z1VQYvCJvVUCs9xKwYxzMXn4prxESXv4zaXJnw8b5JB1mh9z2/Ko/feky5eftJszLaEs73gk73w6ExIoRyB+ahmm5r8uXLQxld1JNg9YE0gxSrMS/BCss/lzJdHIDXyBPqzfMvMc4JPFpA3Ao9muMDKXqSd8n4UyFGSHMXQIJid8q8WcfGy8Z6FDXG9lqsOyvPUKIxlKlZ6NgfNCX2b8vSYkBd7cSDlbRAOwruumATBncUvN4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831b4a65-4f2f-4bfb-c0b7-08d82ba9241e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2020 06:01:12.6528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PsW3+VlxfogWy1SPWDb0R9jnW+cwoDT1DqNWslMB0Vi6ehUtyn2BpgFfJ3bb8q/BH9yonVtGzwylMK3GIEebyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gVGhpcyBpbmNsdWRlcyBmdW5jdGlvbnMgdG8gcmVjb3JkIGNvbnRleHRzIG9mIGlu
Y29taW5nIGNvbW1hbmRzDQo+IGluIGEgY2lyY3VsYXIgcXVldWUuIHVmc2hjZC5jIGhhcyBhbHJl
YWR5IHNvbWUgZnVuY3Rpb24NCj4gdHJhY2VyIGNhbGxzIHRvIGdldCBjb21tYW5kIGhpc3Rvcnkg
YnV0IGZ0cmFjZSB3b3VsZCBiZQ0KPiBnb25lIHdoZW4gc3lzdGVtIGRpZXMgYmVmb3JlIHlvdSBn
ZXQgdGhlIGluZm9ybWF0aW9uLA0KPiBzdWNoIGFzIHBhbmljIGNhc2VzLg0KPiANCj4gVGhpcyBw
YXRjaCBhbHNvIGltcGxlbWVudHMgY2FsbGJhY2tzIGNvbXBsX3hmZXJfcmVxDQo+IHRvIHN0b3Jl
IElPIGNvbnRleHRzIGF0IGNvbXBsZXRpb24gdGltZXMuDQo+IA0KPiBXaGVuIHlvdSB0dXJuIG9u
IENPTkZJR19TQ1NJX1VGU19FWFlOT1NfQ01EX0xPRywNCj4gdGhlIGRyaXZlciBjb2xsZWN0cyB0
aGUgaW5mb3JtYXRpb24gZnJvbSBpbmNvbWluZyBjb21tYW5kcw0KPiBpbiB0aGUgY2lyY3VsYXIg
cXVldWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1
bmcuY29tPg0KPiBUZXN0ZWQtYnk6IEtpd29vbmcgS2ltIDxrd21hZC5raW1Ac2Ftc3VuZy5jb20+
DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo=
