Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CD7C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 08:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE1B2145D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 08:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GeNar70d";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Gs8BDLk8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgDTIOF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 04:14:05 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27566 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgDTIOF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 04:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587370444; x=1618906444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OgOvId5r7wzFPz4kD5E2QEgvcp+IDu1mpc/Y6eMKG3w=;
  b=GeNar70dRGFUSI/xiAKtipgV/7hsakoM5wwU6vFdlYjr57oyzUUHKjvU
   RUh7VZOwKkAaTIFz+8ZZxzmtQVT8OJ3fl/hMZ7UCs/r+PRRDpK5weJF2H
   1ZlGINCw4STTq1l96KMcVK7DnrdRLRkxz/0JXCzcTGM8Zv2k11B4nQuKa
   CdLVTAGp1/wlVNQ0jxM8OKc8GzN10s5gLK29T0tIN1vAzhq7OvIEN2r+B
   3vJHcQjPkJFffZn07SIeHLUIHw1FvifR44qv6OogOb5FgPsfeq/eWFluz
   gSVrtJ4oU+5fvGd+ii0n9PD4HCH5swPQrbHDkXicFJoWLEV2F8Pgc7bX5
   w==;
IronPort-SDR: pAJg5BR0hDDLuqXvr42wIoGjAfibe6ZOSBjuehaOr1gPWs/lGZNPCV+UPMRbZYdjDJ3a9qZXMX
 UBjv+/Pu61lSymehFEmJTNLwDsUz5CPkIJlJH2PT1S7CWaYGYqSTlIeKy6Ng49KHI6rOMPa61I
 Xy347gV1RG8Uqwv3tfPcYesfmcyfGBMHA3HQWjFjoHDuXjtYTGd5X6cg8HZA9Hs7SLvDre6dNu
 //QJRxCdb16mJ6qR4hOGBUWreKBiP/KPekNOr9iY8E6nAlvQ2yeRi/CcL+7Q4Ysr9qa2p3P6AR
 ilA=
X-IronPort-AV: E=Sophos;i="5.72,406,1580745600"; 
   d="scan'208";a="137123042"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2020 16:14:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjRCvEKOoNOXB5Xcmps535mW3tvWgrs2z9K4ymVfhFl/ks3RcY5RrZ6T49WjYqgQ1j7AU4aCqRlCBJtQVyQJLlDzFMqyAaPB3l2e1m8eeXezTI/75b9Ryb4supnNjOKLR4jJ+H6pSZTBqFokaDqoWqTToC5pp9yWdUGejMZwh32WMvTlsAMo1cvsou1MBbfZQdR2c2RmIrn3pydhb2TaMOLPybtnVBUVjfFfUmC8iGvNFI346RjKyjMMyjbeVL2HEJETbWap584qGBkA/mQhyNZjwm/LyMJ7UjkgU0e6RXM7nZ2G5DdwVykeAKjqO0QU7GsYNHrxIV9+dfTLx1/VGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgOvId5r7wzFPz4kD5E2QEgvcp+IDu1mpc/Y6eMKG3w=;
 b=jHZOMJ2B1fOk2lFQxIc0ObiJXUHb41Sp2I4Z7Tk4X8FK0imVxvmTknf6uYLqxidwIXtjQJieKs4P+Wzj8xD6I0JsU+kUbTZa+djslPckjy3iqg9tvaumgGbXvXi84i4Fn8PSBHzZqXpWom6VuwCxCmiGPDgO9zarus7uXNawxQSeGN/vXQFwyrH+v2aiTkOEgYdMovoWoOXr4jIi0u5vPv6k9RvJ5i8vgWKB4vtUBSdKfQbZPSRwwkP4JwqA1bVt4La+sX4CqpqZ3hN7nt1+OwHY+WbNnnf1q6Tjj5zZP6R5ixhVoNERuNSBLt2wmL82tRTJNUaxpscygYZeKH3khA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgOvId5r7wzFPz4kD5E2QEgvcp+IDu1mpc/Y6eMKG3w=;
 b=Gs8BDLk8t1P8eGy+QqROA6NA2ThpXLvzZC7UkMREHJaW26wl9o4VD0I9TrwwUJ/pWEIjoD94k/cb7sAL79SbVQbAdnjzEU4CB99hJi0eqLBoEoKklwzeYyhuYfC6FXXNTUrSkcPGXdVfEkmGFDM5ok5/VOhPO332YRH+a5ccLFE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3919.namprd04.prod.outlook.com (2603:10b6:805:4a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 08:14:00 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 08:14:00 +0000
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
Subject: RE: [PATCH v6 04/10] scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN
 quirk
Thread-Topic: [PATCH v6 04/10] scsi: ufs: introduce
 UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Thread-Index: AQHWFON3oXMw2fFRh0ylLEswVoKPnKiBrVGw
Date:   Mon, 20 Apr 2020 08:13:59 +0000
Message-ID: <SN6PR04MB4640E9D18F9FB283B6458A90FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181014epcas5p1343bc81fb246133cc332d3fc7a394c15@epcas5p1.samsung.com>
 <20200417175944.47189-5-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-5-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0b4cded-a6e2-4582-1fa4-08d7e502c7e0
x-ms-traffictypediagnostic: SN6PR04MB3919:
x-microsoft-antispam-prvs: <SN6PR04MB3919B483AEDE69C59C0C978CFCD40@SN6PR04MB3919.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(316002)(478600001)(81156014)(54906003)(110136005)(2906002)(33656002)(7696005)(5660300002)(55016002)(8936002)(86362001)(4326008)(66556008)(64756008)(66446008)(7416002)(76116006)(66476007)(186003)(66946007)(558084003)(6506007)(26005)(9686003)(71200400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNh93VgnoXCymn4S2/CbMjW0cjgo2RLRJtUa0fzYduko7RRvLf2hRjwwxZQm90BNBQ5CThQxyWrywQXd1il/5q3pz3b+AXwx3mFXjUZDOgLFZXV3xzkaCsupufMdFVg1Nt/0wy5bHYAWEk3GOYIMtU5e4a9L+cR56G10DLxoztyIzAs7WSjG8MadQJ1Nw4wVgXfeguKUyLtzXuB4ukt4lQQBWnCT7e9gSObWNi7AjGyFcHAPi/+O3t+/xdX+NviHswqh4y4IZMGynEGdgEvDRwjh8SVdZtU/hX9gooQNmQICZjq6xSA5xkGlCk3LLQTe8MpFBfNvFxF81ILPtsqUhq75f2l6S3qFxYPfgXp7Tej1YXp5yYy4B/e1NPmgIu79uVUu4wRBrbCtNvc3OelwVOdNwV1vhg6EEW4O78dTkgIGasUotkEZkKCKEWr6xUsZ
x-ms-exchange-antispam-messagedata: 2sR4ZJxfmnvtQMIU8cXXyOzFD5hK7YhN7F2089ab5W+3FOD9RqngiH8x/G9EHvGjrwgqcKY1ajbKoDRkwEtU9xhlpfQQM3TzbRMBBiZ7rPWc9VS48BUUwcjxASYte0Z8zWO2wfMk8EAEL3plXR4K2A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b4cded-a6e2-4582-1fa4-08d7e502c7e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 08:14:00.0505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s6fWgUQW+XJBYsZ10ixRJvJvZzdcpNcHaHdjVyx+e94NZzEawrLp01Z6ZozMMfHJBL1/0UmUJn8Hu080E8RB3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3919
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gU29tZSBVRlMgaG9zdCBjb250cm9sbGVycyBtYXkgdGhpbmsgZ3JhbnVsYXJpdGll
cyBvZiBQUkRUIGxlbmd0aCBhbmQNCj4gb2Zmc2V0IGFzIGJ5dGVzLCBub3QgZG91YmxlIHdvcmRz
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29t
Pg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0K
