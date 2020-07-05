Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304D0C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 11:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD89C20739
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 11:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bRaujcxX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="G9VySEeo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgGELiU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 07:38:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26829 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgGELiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 07:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593949098; x=1625485098;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=bhHt1PvKlgwaVZ22EWVXQ+IUMr8oWhZDPY12agFAjp8=;
  b=bRaujcxXoxJ5ATI5dw+CITf4gr7hghUYO8WD0oSzD6ru+fRL2MVP9ZBm
   fxownYMnTodz4e9cjtsQf4gN4vQkNflpzCEbsldbyHo/feTZ8W8BouHGu
   HytiiCuW2gi97HyQSGL6mLSsfEAmDFnIs8p+JK3oRvvc0C2WuyMR19L1e
   QXTEzp9g149OwKwlkLjz0O3TeyBES3qo93nH2/sJZSFgxZwwUsCZDGZpK
   D6HCFUfUQnkV+d0/zqNmJpeE//VerJlb9hlE+yfmr6kVibg36CU2Lu6oS
   ZOrd+wN0gfWAKrZvA7ajf+a4KxViPWkIaZWQHfl7SxJ+3afSR3m6eMhi/
   w==;
IronPort-SDR: PMHfF309wG3mlzVFqoWXGA8psAUGwWRMGS451gkXc3hKbVHrO1W8M4PqRyiNK7bwSQ3k6fyh+d
 iywYiinvxstqZyuWiITzXa9Y0tSCpSXEw4EvcZTRvEQJ5pZpKn5000z+YB0Hv6Y8TwguTwfjWG
 nqlRO/e5IQhv4dWh8DTXcIKDZOX9/T6v7t6tVUmuMpXnhFO7GfrBs1Af9Yvp4xjphnnRKyt3Gj
 iCHQUYKO3yR8KiQAotHRHMo6w3HxLRd2UID7JPktymn/h0rm40VvCvypGifbPApP6gIw5htKWC
 Ic8=
X-IronPort-AV: E=Sophos;i="5.75,314,1589212800"; 
   d="scan'208";a="250910823"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2020 19:38:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nf4b3rACPbRrjWtPONWp6tjW0nqx2ixYqmUlhQFf52byYJ5ZcUE/ClSEisVyNFdzjtqofLUc6B1WSCmRLcby+QKMb8M25QGGOC2ldECj0avga/LjSyI3eIf5+4HRT2CRgdtnwcrw/pImMq2+wz1c0H07YQBBiln5f4zt8AE4iUcTX2Wa167pbDMs+j3VywfQo9vjovK2J8LSmEJ502BinAnLZ6GR+R5e5XISKBPY43BS9O07yLYUm1Eay1pacNBdayxaXF4M7i7KaBFq3bCrk/E7a4vOjj1JTHRSb3kG8z29TvpbdF/YMYX/gEnUw9USYE4CRRoqAyEVDBFVmRFOew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhHt1PvKlgwaVZ22EWVXQ+IUMr8oWhZDPY12agFAjp8=;
 b=KZR7tp7AYSpvh/EPvmUKNOMqKCHe5cpKYgfaYX+4YzywvurPRvjI9Izq2if/US6IoSykm73HyQs/eV14KmLAg2nMaWolyOntW5CA7W2YIwEj6yVpVJwkqE52iDKE9nfaf8Qwi4C20HRC1ciKUBaLUDZt9Dnu1vET00PjOFiLCUw2m/YQkcxpFeDvbYw0BuLzkdsp2Yo+bwd4+nAurdg5xcxjfDAOTLcfkqEoXnG4YJODWtvZfgV7NC8T0b1Ysb/TFF+NTaNmyNQasckzvUvXQuwkVx10A0VBpJ4Wf7Oz39DMzVt6Ij4Ii75ZTjaVT+yMm7hobv5IaV/1Aymy/D8Byg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhHt1PvKlgwaVZ22EWVXQ+IUMr8oWhZDPY12agFAjp8=;
 b=G9VySEeoN9LWr4ZWn59D+3gjhxO5g8e/cjTLg1TH51vclMOoYzDe5jV0cNvsY6ivWrXwVy30VTLOYp4M7iIHBh5JYt6qzi1+E+eoAudBBL2Js+RIAEuDT48JR+aXk1cpSXVRXm36kxqSY+5S5poIWtEkXaSd8hnLU3J92I6mdzo=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4896.namprd04.prod.outlook.com (2603:10b6:805:99::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Sun, 5 Jul
 2020 11:38:17 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 11:38:16 +0000
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
Subject: RE: [RFC PATCH v3 2/2] exynos-ufs: implement dbg_register_dump and
 compl_xfer_req
Thread-Topic: [RFC PATCH v3 2/2] exynos-ufs: implement dbg_register_dump and
 compl_xfer_req
Thread-Index: AQHWUPxRfQomfUJpdEyqPUvI3g203qj431Vw
Date:   Sun, 5 Jul 2020 11:38:16 +0000
Message-ID: <SN6PR04MB4640F8152119C231A6EB46FEFC680@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328@epcas2p1.samsung.com>
 <9a3f8f8fed39aa7e07e20cf1ff25c708919ff2ea.1593752220.git.kwmad.kim@samsung.com>
In-Reply-To: <9a3f8f8fed39aa7e07e20cf1ff25c708919ff2ea.1593752220.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56540243-663f-4b6c-6ea4-08d820d7e8df
x-ms-traffictypediagnostic: SN6PR04MB4896:
x-microsoft-antispam-prvs: <SN6PR04MB48965CC0C0886ABBAAFA2AB0FC680@SN6PR04MB4896.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 045584D28C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kSIRLx02x2LK5shR5MS2E8ByDibX3NQ9EeE+MPS2cKYNqxG6tsHX1Xlt6TwvNRfb1uAU0Ph4BlHnvYHzlWFnHvMPAR4o74tBgeXjtSJiOQ9QKHVN/QzpUX5CEHeBsaxc95Egvtj4BO959g737FN53umygnzhqkOEaeF5wm0WKcH07AEUsoPoMndfhPzhB0srAbHj2/+6SP66FCusHxQeea+WmxEjYzHmnByNTQaaYhXk8wPw4h4iOya00soLlMr7Ihz97IBrvxQApSgVBSMk18zNumJbN1FMdWhl1qvEbtTY895a9XqBPTbhB2m3pjbhRa7nQOHp/SFpdIxwQohHNiwza0b+KHduS5juFPwQ7KEU2EB23YNowme+MX3On3JP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(66946007)(55016002)(33656002)(2906002)(76116006)(8936002)(9686003)(478600001)(7416002)(186003)(7696005)(558084003)(8676002)(5660300002)(71200400001)(6506007)(26005)(52536014)(110136005)(66446008)(316002)(86362001)(66556008)(66476007)(64756008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: z99Gshu4pzFCh59BSiMReVRid3qs43/gxjn+iHBTCGL2wFa/9OL5aJpY36WekS4XdSngO1iVvXtBsg0dFRXr8pUo5GhKOptmuF4D+2a/shu3draFUWL/DOA4CO44AAZdqAIF86q8kHF0f7rSQrRU7KxwhVl0wOcQOQ9tLEsDy+OUrVwIcOFRJcki8g0oUnvJPIq3E8i5dn4+lPnlKy/dVJx7v52T5JG7CzagRbusx0ubOcbh1jtmt+DkouqowHgHgQ8ZtfJtQlzGNE2o1GX59lKzON0a58/xl0n26EL06ZXH5ArDj+7uQnZF8lfBWgOsPmaA8uvYepLcOYStj8CaY56fJAsNXDQJiRtxPWJhLUmUsZE5J6XI4S8uusf5w8fe64F6bJgmCyCVG1Y1DiiBa2SIWcSUoQVzafRx/6+IxadR1VAoHu3ZztMN5Ei3br7r0LzbfLWKKad5Q97e/BA4BAPsAXhvuc2ZCRCfH7pb6Wg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56540243-663f-4b6c-6ea4-08d820d7e8df
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2020 11:38:16.8550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ppEqtgy0NVMlndzGJXApxZjrZ1A4C/X770VJlGSnEntPnRwC8YlLeBv/QmHk5XsQIye1cDeqli/oz5BvC3H46w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4896
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IFRoaXMgcGF0Y2ggaW1wbGVtZW50cyBjYWxsYmFja3MgZGJnX3JlZ2lzdGVyX2R1
bXAgYW5kDQo+IGNvbXBsX3hmZXJfcmVxIHRvIHN0b3JlIElPIGNvbnRleHRzIG9yIHByaW50IHRo
ZW0uDQpFYWNoIGNhbGxiYWNrIGRlc2VydmVzIGl0cyBvd24gcGF0Y2guDQoNClRoYW5rcywNCkF2
cmkNCg==
