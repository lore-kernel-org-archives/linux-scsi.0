Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3905DC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 20:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02652166E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 20:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="hVlCdHr2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgDXUCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 16:02:38 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:6123
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729592AbgDXUCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 16:02:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKswofdnguuFdnXZNfpP2zCGw4k56gKBwc1AINrLXZlgQlY/vkjqwVWl1IQ7QFesp5HbnEWblqH9ArWv1EKX2SNJ8OR/5KTJGLNWQDKwM9uvhFk4Te7mPSoPt769mLtTfTJe5WrCfeszgHy1cSN0l5PbVuYzb5zjC82SC4do3opoqm7MI1jrmZqZ6oYkdITJrM9/rgrYMjCvWt5RuetCXDkKxrSpwWOtp+yOqGbuuXZ+eN32+bH2DHZqouBMLjPpEb3AQF2hm3Te5Kr7Lls65ZFH/sLHj+NryT8bM7QVSpn8qKXuVig+wgV5B0a45orzDroBG07uOARVBgFLaDtFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWx1+TSivvHZQU6WeVAd6EiHasnb9+oL/qlL5VPNub8=;
 b=e06tdQ8Uj2Fo2bDrYom9bm3HqDN8fmjtWbAd/ZpXZCHwT8UV+SRLaHZQ5+vvGke1PHUuGn+5HUgGyRGbj+2kZLsot4sEc+ubVw9VJrG6sHFBqsS/mpAPbT5EHuh8kf8wkpso9e5bBANdy7bxBOoYqnYr6PO9psnq5PT2Cu4ztKBoHwyBAXNGjhnvhm2hoiPAVVuLNEBjultLN4DPTLEbsyhRAU7M9DhXVOR3ISQlhhn9XZWKDE/4aEsgNXi+w+OE6WnSdh+eQmBAUA5cWzRCPSNqjcgDG6dubL9989cIu/i5AnHTcP5mz5/s5Fcjk5AqLXtE/LHao8M3jSoD2EPJkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWx1+TSivvHZQU6WeVAd6EiHasnb9+oL/qlL5VPNub8=;
 b=hVlCdHr24ci0RrvuAtcz/zHakuaLx3pCSCoxXHh9XLXmWOvx6uiumzonY5SeF9rzco9UTAD2/VWROZ6rEv4npItTB+VGIziWM2AI/l6s5bKAoBCjb5AX9RsDSY7O2vMVH9MUt9GNzCbw7PVXgv6oPsA9tASxL774WRPNvUAh5Ks=
Received: from SN6PR08MB5693.namprd08.prod.outlook.com (2603:10b6:805:f8::33)
 by SN6PR08MB4575.namprd08.prod.outlook.com (2603:10b6:805:96::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 20:02:25 +0000
Received: from SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::cca2:ac08:1fe6:732e]) by SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::cca2:ac08:1fe6:732e%6]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 20:02:25 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Thread-Topic: [EXT] RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Thread-Index: AQHWGQIuljcTg3qMfkuM3OvLDJ2opKiIlyeAgAAXyOA=
Date:   Fri, 24 Apr 2020 20:02:25 +0000
Message-ID: <SN6PR08MB5693CFD4085AF0674A86EF0BDBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
 <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTgyM2M2N2RkLTg2NjYtMTFlYS04YjkyLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw4MjNjNjdkZS04NjY2LTExZWEtOGI5Mi1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM3OSIgdD0iMTMyMzIyMzIxNDI5Njc0NzA2IiBoPSI5ZmNGUUJkTU55VmVFWGFFMk9TQW1YdnJmYTg9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQURTdXF0RWN4cldBY3RBbEozK041VWd5MENVbmY0M2xTQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQWYzT0VLUUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce250aa4-ca62-457f-c443-08d7e88a68a4
x-ms-traffictypediagnostic: SN6PR08MB4575:|SN6PR08MB4575:|SN6PR08MB4575:
x-microsoft-antispam-prvs: <SN6PR08MB4575C9746D10F10782792955DBD00@SN6PR08MB4575.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR08MB5693.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(7696005)(71200400001)(6506007)(478600001)(8936002)(8676002)(55236004)(81156014)(316002)(86362001)(33656002)(54906003)(66446008)(4326008)(9686003)(7416002)(64756008)(66946007)(55016002)(52536014)(186003)(76116006)(66476007)(5660300002)(66556008)(558084003)(110136005)(26005)(2906002)(921003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3b3g64ATOg6idDVXD3x1sA8hX1/gvHFYSGYmbK5hfTUMq93EBGgRThLPXWIB22CrujPuhGgquMlQjzmiba2e6o/07Mei+Fz9G6Bx+eGnkzicI9nrOT7PPAt7Np1iTai5S4cwQsu6fSZCwy/l7unPYfv57oa/Oc0RDY2OTIlO2PBrUiBgAROHJDUTysp5/4Do8a7eORr5OFY/dR2buRri0uLXro6+vTE66WQG/YUAzD4l7RLqzvD70yrAbZzy/Y8a49SBPoE0SEH0qrB0+lhaDF8D+mk7NK50uVybzjR+7MvSLgJMw/yv1DTEmnSrnu/qR+mPoZQpF/uh7DmO+Y7pv1iVo2dn+kW5xu/2NgAx05O/b+BuHKbVLix2ruLyKik2JaCg+ZElQsnVioYybguRGqpcKWAc17L48MoX69GGBB9PWwZU3fsWV/lKzUtu7Fc5ayoLa2Nw5+4lzALclhQ/tMnrfBjgFWesMwicgam2vao=
x-ms-exchange-antispam-messagedata: /NqP6ZcwsA3t06oqdnagfMxdF2YRRxu0jsO6l5sgaa/wucijrz59zOry6q1O71CLVuH3migjgRx3E488jTzVWKkfYhf2p7/UMNg1Bti2RvMmwIpSWOx490/cvHfHg6lopIGeDc+5DZnDCwwRK/xqUw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce250aa4-ca62-457f-c443-08d7e88a68a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 20:02:25.3265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7hqPAHmBdJ36nPfdPffzN6GN8BOx2XowzIFkhP0Q2xXz9NFXLIpGj/HcWQgSm/hvdmifEdTDuRHuzML9AV/qQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR08MB4575
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEF2cmkNCj4gDQo+IFNob3VsZCB0aGlzIGRlY2lzaW9uIGlzIHJldmVyc2VkLCBJIHRoaW5r
IHRoaXMgcGF0Y2ggc2hvdWxkIGJlIHJlLXBvc3RlZCBhcyBhIFJGQywNCj4gQW5kIGZyYWdtZW50
IGl0cyA1LDAwMCBsaW5lcyBvciBzbyBpbnRvIGEgc2V0IG9mIHJldmlld2FibGUgcGF0Y2hlcy4N
Cg0KT2ssIEkgd2lsbCByZXBvc3QgaXQgYXMgUkZDLCBhbmQgYWxzbyB3aWxsIGZpeCBzZXZlcmFs
IGlzc3VlcyBCYXJ0IHJhaXNlZC4NClRoYW5rcy4NCg0KQmVhbg0KDQo=
