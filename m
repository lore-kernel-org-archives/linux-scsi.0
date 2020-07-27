Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE7AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 503242070B
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KPTZqZ0Q";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Jb7Hwsdu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG0KKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:10:46 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4216 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0KKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 06:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595844645; x=1627380645;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=w34RqWVcNdJNWHLJW4m0U5vhjLmKubjlslWTosfOb2k=;
  b=KPTZqZ0QOft1tZZdsWLXjO80M0oojGJb4imf7W3w4MPPBX4by8n9js2R
   I44rkSFvf2ngPYq7TiVJUDdG+eYo8gyRfhQPXWJLhNag/mL2Rl1/eiWv2
   olRz4HiqOfMxYj6mhwnbGqQuwa2l2ebEZGqROFDPGmmycpfKEIJ1ZoFcT
   qSBnt729pEnwVDySng5n99MCQdR59XskiaRY/c2+AsIAYAkA3sAilK98I
   MjDV+bJNhnMetXvdRcJJND3t0iMICiAdFFtWj7+Qed1f6aBr4UiOYkki6
   +Ozmf3ROw0fnYrBcfIjNu8I7nufWqKztHUQB96E4wdakWprlJUzIORe+N
   Q==;
IronPort-SDR: jSMbwqA0R5zY3UZTcdj/Odiv+kLkhVfa5fWa+izsTns/ntoqPWuFf3OBCcwNcx/d0bj0rQuLeX
 fn5qx8mfjDNxqqa00npUw+4EMm2ZVDtNUbt3nG6zNG1UsjDUOjz9H7raMivNFlhn/LCCgLgdrU
 X4zpqg693Jy49iJwSBu0PNN5ntz0RDY9v/zKp13lYqzXcaV/HpPFiyxyyqlsMF4xKxSVVpZLH9
 Nwn1SLN4cBopHTyvM7XFopXZNcSRW/ekzMeJZL3906o/hUswMoC53o9Bl2VPR5RE7INkriDE0o
 eFQ=
X-IronPort-AV: E=Sophos;i="5.75,402,1589212800"; 
   d="scan'208";a="147761471"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2020 18:10:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Szlp55eTWAzTbheM1GxXLn0PEaK8VPzZOcwgM/fIRcmkvb2TcSCUmjwT7bQhgiPtRbh638oFBG7I209espNtYAC2cT2iiGMZXT3r1cpv0kzxxp5FC3PKS5wQyCbJwuiyHmCp1ej26WaLQAknZmS32zSh/EKzGUinZ2L/oEDrn4K12HfVZ/VuS4pfh8UxnSOr3NGZjnJlQodpYnIbFgNsQlMlxxQbs7zqBGGPdxRau1yzN3JfMUUPn00ZOUsu4Ad0McTyPp89nYBEJyeJH/cosznykLU4Cl42ATlv8XAjwRvLcR4BMr/aZyrhM9yTqix7PNZjTFcHXVs7BGVLcwtQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w34RqWVcNdJNWHLJW4m0U5vhjLmKubjlslWTosfOb2k=;
 b=PQUJMJKEQXpDq9rXZLPjjUONLGaPOmbncb0a4WshEqGQEN0NA+4X4vjhsGMXNsaTaIaZsXP0z9o5Rj91RlIu04xYftY8Dy1trNiYYyrU+/2P0XnU/48ybh9Wpbw20hVmopZGGzERbj3okBluSaRr9L2wLD0Z4+ahqEDN2RheaGGl3UyA1jN5RcA5I88lSYAflu8J2g5pb3/32Pj8Nnu31wDrzRmP6bMEEvI3ZPtsauTo2CeUXV7WZoPHkAT3GzVVrNGBJuopSk+rwVOzhgcUS7PrTLzIo5VLqSw0lCjVlxnkEY6FdIep2tJXvwYFtBssoz7uBdjOAehiO80D8ayOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w34RqWVcNdJNWHLJW4m0U5vhjLmKubjlslWTosfOb2k=;
 b=Jb7HwsduEoa9eEj9yhmNGS4n2T762XPcG3a/UHL+xFaxpn/fyt+8a1W/4SgX5dvPSZsfg3A+Lnz7zHfnVb8RjOzW7L6yVaUryAPMT8AQ5yYGx2NRKPDVCzyc7ltTfHIPjz2tk7Qsren5uYI2BpAJNpW28Syz5VIvQBFQcOLr3kA=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4192.namprd04.prod.outlook.com (2603:10b6:805:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Mon, 27 Jul
 2020 10:10:43 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 10:10:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     =?utf-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Thread-Topic: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Thread-Index: AQHWX0VHDp/H9W3ONkKVkhESMJIZA6kZbLvggAHNSICAAAMrIA==
Date:   Mon, 27 Jul 2020 10:10:43 +0000
Message-ID: <SN6PR04MB4640AC885D7E57D6FB4A9994FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e@epcas2p1.samsung.com>
        <90ad671ed4a2b4f6035e9858153a13f7c00a1904.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB46406E701D8571E3A1EB5FDFFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
 <071d01d663fc$4782ef40$d688cdc0$@samsung.com>
In-Reply-To: <071d01d663fc$4782ef40$d688cdc0$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1b615a3-c15c-460c-6716-08d8321552b5
x-ms-traffictypediagnostic: SN6PR04MB4192:
x-microsoft-antispam-prvs: <SN6PR04MB41925A393996278B615CDED8FC720@SN6PR04MB4192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WIEuvd/egosN2+NjLigWEaWHIlWLzsFmQJbHKoMdlQyPSQsKK0lskYz761UL6BMbcRqoFljJY63QzcPIK3rXrnhUbrFuKyUOKNqprV0kXeVQcxkStSavZVvVred1kDvf0nXnejL3HbugOQrJ5gB0G8wTsa8UqDBBNxU8pvRVtp8CHvByqqt52lo2+aeYUym2NZi+vfW4aTDPlnCspYWg9siw2VEa2+bb0gXFPkku2C3kZJI2X5sS7s5ZK/F9MjUnIgBCDBwfz8vWHlZGHEWW7AsJQKmbXx/DmH0VO9oAsewQWOi0b7PHVsrDJcGweTDosVaAhoJRghoK9PEb4UFZLg/wVv1MOS6JXeELZgnd1r+8AcBF93PwhkHWqOXuz5iW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(33656002)(71200400001)(7696005)(26005)(9686003)(5660300002)(7416002)(6506007)(186003)(4744005)(76116006)(66446008)(64756008)(66556008)(66476007)(86362001)(478600001)(66946007)(110136005)(52536014)(8936002)(8676002)(316002)(55016002)(83380400001)(2906002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: nYzTf6vojnUKqV5bZHq6VoDwgIdImy18Vtv9VNdhtqoI5RMhxOu45KDzpW69gIFU8mw71hMJxapQYrfWwNA7J2BxkEseY3Hlrdo/hR8OdW3xq0Rx1pmCh2tzTJKUI/2dLvdmERScQVxss6IM46lu0TTv7KiqmRZ16wk12tgLdkl8qKvf8jL118Xdto3mFsUSZbGovXJm5ufg23ZlRgIIpR/fTvgX7VPHHXZn2Okp51rXuMBFRBBPAB72k2PUROZlpvVSuomSc2OhjtwnO39G+7zjUynImgNpQMSgSHpt/fDwqQJJ5eHjcoan7uBVx62mH2mYCedMkVVfZj/p38DI0I/zmxyfTSv6siuTPgUwCKb+i9KeFt+2QAiDa3X1ATz3KwG+WbasZI7wVaDCkk/uWjqfqLbrTe8+5qEclIASoMg1lEWaIEI/EKHUaWkPUefQL6HpqwU1nj5vYq6OS3NVPDVR82f45b7TCz7J2BoppWzU1m1Tz2VIsNs2709VJ4jM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b615a3-c15c-460c-6716-08d8321552b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 10:10:43.4808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ksHxTiFiTsA25Hi+SENEBk+6kSoBjyFqnlfd5bPQX79Blx7fkX10r8HFX+lokOxb7LE1UCeHwzCGXaySxjehJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4192
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IExpa2UgSSBhbHJlYWR5IHRvbGQgeW91IGluIHlvdXIgdjE6DQo+ID4gSWYgeW91IGFyZSBy
ZWxheWluZyBvbiB1ZnNmZWF0dXJlcyAtIHlvdSBuZWVkIHRvIHdhaXQgZm9yIGl0IHRvIGJlIG1l
cmdlZC4NCj4gPiBNZWFud2hpbGUsIGl0IGdvdCBuYWNrZWQgKG5hY2teMiBhY3R1YWxseSksIHNv
IHlvdSBuZWVkIHRvIHRha2UgdGhpcyBpbnRvDQo+ID4gYWNjb3VudC4NCj4gDQo+IFNvcnJ5LCBm
b3Igbm90IGNhdGNoaW5nIHRoaXMuDQo+IFRoZW4gY2FuIEkga25vdyB3aGVuIHRoZSBjb2RlIHdh
cyBtZXJnZWQ/DQo+IEkgd2lsbCByZW1vdmUgdGhpcyBmdW5jdGlvbi4NCllvdSBjYW4gZm9sbG93
ICJzY3NpOiB1ZnM6IEFkZCBIb3N0IFBlcmZvcm1hbmNlIEJvb3N0ZXIgU3VwcG9ydCIgLSANCk9u
bHkgaWYgeW91IGFyZSBub3QgcmVtb3ZpbmcgdGhlIGRlcGVuZGVuY3kgaW4gdWZzZmVhdHVyZXMu
DQo=
