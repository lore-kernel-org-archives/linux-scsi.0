Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75FFC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B3664E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhBWIru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:47:50 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31082 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbhBWIrt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:47:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614070634; x=1645606634;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hQJK+73o3Bj0MVB9H6qSb09xPm62SrK0DY8h6btzmd4=;
  b=D08/W+mjtB+fS2l1ZKFb+b4H07eRhyigduZUWQ0wbbYdRDIjcAS+sS/y
   Qf9VCVXrkGiepuEjeSbwT71+SG/XgnaOHm/erpoFiZAeGbQ9nKFndFrGO
   c4iKHbtOT36OkMVQbdT8TEHLUSrHVSOyQzIRenZSkAt6O98AWPCoan3kE
   NKg6ZAWtodjzluk2+nez3LaTPMZQhYKLXrv5n3k7T4ekExw4Nj+VSf8zY
   WAWxTR0qh61vz3d3QDIrEbnG9/lFqyvowls/3FM/Ed0yDNEha1QwoLBsP
   SyN2ydykZQYzGWacE7f7527tFw+azEuPvYl5hs93Hoh6UhIE4qAYZ3Qgy
   A==;
IronPort-SDR: 7kkXLNfWLOmAYd986nUW/1NGYptA3Tqr9n/7YYuLy1WOEup9hdTHMf3IEGTMy6igJ2HlFxf+Iy
 hq/0UFFmPTXt5P2gwbqLw/t/Q7a54dUJiWE9jX51QxdJM13NlNafCrZHSLqow/zrcGmPKqQQ9i
 9AE7m9DJpDblcg1V2YYWBgLRdHzCtD6DMwpHOh8MYLigmjXIu/T7AUTTGdyS05S5oeST3mhi5k
 nD9v2IHjCkGi1Urc2NHHAJ9VMq6vD/LM9g/YrUvR3C+UfwqBDBc0rwuxRoc1QWEixDbdK67Vvf
 a5Q=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="264773236"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 16:55:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnZEK5SY0tP9N20OgTPVfVe69FrfmZCC8WKu3J/7DJRTLgYTl4eGG3jpgz77f+sPPwQe3iw5eXJHjsKQnphE3LxtEGURqZBjf8SDKD90mdGcrMulGSc/23PxanGa55oJFXg7tmmz3dyPX3/YMyzkMv/CG8VSo7eYGyy7dnNvqyJKBGXP9nlQQ5N98ybOO4k/ahh+8CRLBb/DE4FmRwFMP4Ejfx5SYvHcE/9HYc1S5EEUrpxAiAuIbrhNImjcPkmt3/HCb/zl+ywFVbXAdCryWTfwI+j4pLxSpdJBrjyK9EPVYjv7UQM5ljSJ8nYOBX3d4pBX6elhK+R80YT4J/tthg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQJK+73o3Bj0MVB9H6qSb09xPm62SrK0DY8h6btzmd4=;
 b=JjM5tO9wnJzcNGcEUib8w+0jBbfnWpiHf8AXaIIwF28LE7hDF9uPIWb5w0bcWfAPk4KLAzzfOG8Rb5XXxfO3Q4axVeIpmV8sbAojbATacGAniXWeF4LDisRFvcBuJ/bv9sghisclQsrfom+Kuia6V2tuOl9MmhSxPT9eHlM6p0I0TLc8nzcmivksNoJf68Wxb26ZPX/35OP7BrOnRiXw6Po/IWmxSXSZFEAJku9Wfy16XmkG22yp107m7i3LJYVslo/91UsfwRQXYz9eJthQmSM+6bkUehIQo8nINmkWCr4Qx0k8+iyYto6jWl/j6L+Hr3CuCKDM9IuamRdXzlF1WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQJK+73o3Bj0MVB9H6qSb09xPm62SrK0DY8h6btzmd4=;
 b=ygepQQJ/8Un07XrB5MzVyBt0hoHCzj9pVttLjWBSGbSYcqLd9NYzUXEYPFy6288+14N7ezu9n0rlVmIFLrZObU/woo7f7XQH4NzlJuWDpCiyg6z6WiyEEChoIdnvD7n9mEHDnksWD6j255E/17NKabxBUDD8pi4lp60drRM5Cak=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7129.namprd04.prod.outlook.com (2603:10b6:5:24b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.29; Tue, 23 Feb 2021 08:46:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 08:46:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: RE: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB
 read
Thread-Topic: RE: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB
 read
Thread-Index: AQHXCP10vlbegHFtDUeQMxctLbOIr6plWD3QgAAJv4CAAAihAIAAA1RA
Date:   Tue, 23 Feb 2021 08:46:40 +0000
Message-ID: <DM6PR04MB657522A864655988A1430E56FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210223080043epcms2p83f813841174ade50ef97481b3f4cdef7@epcms2p8>
        <DM6PR04MB657508BC3F0D0240FDCBB043FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p8>
 <20210223083136epcms2p89ada047f0da1fb700ace8b4e3e396697@epcms2p8>
In-Reply-To: <20210223083136epcms2p89ada047f0da1fb700ace8b4e3e396697@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dbf1f2eb-f4a6-4677-f5ba-08d8d7d789e9
x-ms-traffictypediagnostic: DM6PR04MB7129:
x-microsoft-antispam-prvs: <DM6PR04MB7129E99721266BBBDC7FFBB7FC809@DM6PR04MB7129.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 21eAQSi59yh4KFjrWn/qbLbfEqIg12N3zEBRZShEhBN8W2Sj0RmhPo1zE8sNej3A3zBqEr5D4O5k01Lhq5mGk5POrOr5dGOfXLxsACH1LDNl6QENPOdIUOsi7lFluVIg5flLmH10YKmMeAQZSKX6TYGQeASTECgxdDEDTjCuTBtNenqDzB6AKDAUzb4mWGwM+UO91CMz3+FG0g9MZDEaateJsp4x3rWQZNjs2nFFhCh+FAOwOUAx7ltn73vUNlW1MoOHdAqKvHriGoRc2Eo/Bz22U+csVnPJ+dZnZq7NR2ES9fXe+2DCBL4Ib1YJQezqQmYbijmWr5wd4z+Qms9Cb/0+rcwox0VhXg/mA7zZxUfsvWu1bynka1OWih9y9ttfufBNqFcd035dyCi424uOE3v6GaQeQvp8cKKSVxfsCWkAc90gJCHeeHYxFTVQTNZMtWSlZ7/5oTZ3IByHS6C/9k7uQsNMe+N40gP9bca3N0XHStgmKN5Yg3k2Cag1NrLkBAu5eijZyvc/Vt57ISjd6z8eoDMc/9+QjbvH8yTM7GQBNXnmT2sblYiRucy5Juba
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(55016002)(8676002)(186003)(26005)(64756008)(110136005)(7696005)(86362001)(921005)(478600001)(54906003)(316002)(5660300002)(66476007)(2906002)(71200400001)(66946007)(8936002)(52536014)(4326008)(66446008)(9686003)(76116006)(6506007)(66556008)(33656002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S21pUTNwSm5ubFBQN0phQ0djclQxWEtGbW5PRVpRcmlEa1BMb01paHhzWnF6?=
 =?utf-8?B?WEg5QXZNcnQxaWViczViM1NyTlFuTUlXcnRtdnlUclY3OXlKYmhmR0VFUklQ?=
 =?utf-8?B?Zy9raTFWdXQra2RpbzZlT3ducmxLdWFWcTlkQmpFV0dDTFM0YXFXU01iNk4x?=
 =?utf-8?B?WUNKaWxDRUQ3ZFd6TEhZZGgvMTZwWEhwNEtFOGpZc24vWlIxM3B4alVhcm9y?=
 =?utf-8?B?b3hEbzNvUXJvVEVyeEF3WUF6cU1KeUpxQ05BTW5ack82UzJ2Q1FIRWtCVWsy?=
 =?utf-8?B?bi9xWWc0OW9ZZHNqRytiSU9JRVN0Lys0MmN6dUxTUXJ6WU9YUUl0WUFqNGFa?=
 =?utf-8?B?bTd2QkJzTk5naTZZTVhJUndoWFZGM0pnSXd3Vk40c0R2cGFJR0x1MTc1S0Nq?=
 =?utf-8?B?TzZ5SnlVVWhhVTgyN0FFU25MUzA3T2JSRlFPRE9Jb0VQbFRKRlg3VE5POUtw?=
 =?utf-8?B?ekNVM3lkelJPeVRVZ2NEY3dCYXRZNldoc3VSQWtBTFNJQkVpUDJpMXlvZ1U1?=
 =?utf-8?B?NkM3UjFnWlRCUkpWZkM4NDV3c3F5VUZUZDJ2WGxHcWZ4SWJrZjlzUWZoMWM5?=
 =?utf-8?B?eElzUU80THBEUE5GRjlYNmFUQlliNVdSZ0UvSWpsSXFyZXFPWGppaVFQb0tO?=
 =?utf-8?B?NWZCcWxFSGNUVElidS9nbDl6WVRQNnc1aFlGdU1ySi95VmNZRE16cE01VDdL?=
 =?utf-8?B?VWlQbUV0b1pJL2pDMEl2QXdTWEQ1U0pRbVBGMFFiWWo2YlhYajJ2UEtvNG5w?=
 =?utf-8?B?K0p0YzlieHdPY0xwTGlVTy9tSG4zdnp2VU9OeGlvS0pXeG16NXdaZ3NYMWg3?=
 =?utf-8?B?cWx6bTRQTSsyMFZ3MDFZSUtpdE5oQXFUN3dXd1V0OENTRHU1Y2RjTm02dG85?=
 =?utf-8?B?azFyQW9oaHU3ZmNCb2NmUXJvckNncVMyRVdqR3d0SlB5NFVmWnlESlEvdkI2?=
 =?utf-8?B?VVRFbzBHVUZtc3l2TmE5T2U1b1ppYnBKWTg3SmYzNDF5U3RtcFdJa3JWWnZv?=
 =?utf-8?B?ZnFCd2REV2JQQmF2RmxVSitaaFJQeHVJZENKakVjT0YzODJHdmRaRi9Qc21V?=
 =?utf-8?B?Unl4VmRCVElGUStNU2tCL1JuT1JXUHk5NzM1VCs2SllPVzNlRmtqZEI4Y0Ft?=
 =?utf-8?B?eFlVdVhGZU5DUjZZZzBuQ1czY2piMmxHbEIweDJsaC9rRE4wVXk4cEQzeGpF?=
 =?utf-8?B?TzA4WGZVb1hBWFhhUC96b0dicGlBdk1STmUrbGt2MDdmUzk5clZncU5ZNDBl?=
 =?utf-8?B?MTNOMnVxQXUweXFubG1LZmZuL2RDWjB4bHRDRlhVSmlsQ3RaSmJKTmk2bHVX?=
 =?utf-8?B?M2d0WmZnWFFiamhWV2E4MHJxNmtaR0dONTlpY0kzaXE4ZkxvUWFNNnl3TnpC?=
 =?utf-8?B?RFJHSkFNV2IvWmpya2hKajJyczhuTXpDN2o3OFp1OG5ITXRRVkcwL1Q0UjEx?=
 =?utf-8?B?WnhyTXM4V2NRYks1eEtMakVlTjREdjVIajBVTnlRVm4yOCtJZXZ0cVVOUE82?=
 =?utf-8?B?N2JYM0FmTFFCUTRoeEZlV095cWZnOGczUFZnTDBBT3czUDU3VG15a0wxNHBP?=
 =?utf-8?B?a2twZC9waFNmVnJCQlZGQUxGNGFGaG5zY3FvTnBkQjg0OG9pa3hSMkVubUtS?=
 =?utf-8?B?R3B0bGFnOU10Zmt4KzFvSGtlVXZUSW5WQWdkNTJZRCtwRFNGQXJvTllSSmI1?=
 =?utf-8?B?SnE2d0l2dW04VnJYcWpzUTFOcjFTb2ZNcTU1U210Q3FaUE5TcU16NWRKcDBV?=
 =?utf-8?Q?UX/PZJPyk/40Sc+G7bF4NCULx1YpoDigY1qAvfJ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf1f2eb-f4a6-4677-f5ba-08d8d7d789e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 08:46:40.4059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: txwfczbNGxSGjpi1DHeicmiJWWg4WbfmFTTP0bV4LUIRkNdy38KpHBVRj90j+ilw8H48WbtXwUEuWF5bw1ynyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7129
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gPsKgKy8qDQo+ID7CoD7CoCsgKiBUaGlzIGZ1bmN0aW9uIHdpbGwgcGFyc2UgcmVjb21t
ZW5kZWQgYWN0aXZlIHN1YnJlZ2lvbiBpbmZvcm1hdGlvbiBpbg0KPiA+wqA+wqBzZW5zZQ0KPiA+
wqA+wqArICogZGF0YSBmaWVsZCBvZiByZXNwb25zZSBVUElVIHdpdGggU0FNX1NUQVRfR09PRCBz
dGF0ZS4NCj4gPsKgPsKgKyAqLw0KPiA+wqA+wqArdm9pZCB1ZnNocGJfcnNwX3VwaXUoc3RydWN0
IHVmc19oYmEgKmhiYSwgc3RydWN0IHVmc2hjZF9scmIgKmxyYnApDQo+ID7CoD7CoCt7DQo+ID7C
oD7CoCsgICAgICAgc3RydWN0IHVmc2hwYl9sdSAqaHBiOw0KPiA+wqA+wqArICAgICAgIHN0cnVj
dCBzY3NpX2RldmljZSAqc2RldjsNCj4gPsKgPsKgKyAgICAgICBzdHJ1Y3QgdXRwX2hwYl9yc3Ag
KnJzcF9maWVsZCA9ICZscmJwLT51Y2RfcnNwX3B0ci0+aHI7DQo+ID7CoD7CoCsgICAgICAgaW50
IGRhdGFfc2VnX2xlbjsNCj4gPsKgPsKgKyAgICAgICBib29sIGZvdW5kID0gZmFsc2U7DQo+ID7C
oD7CoCsNCj4gPsKgPsKgKyAgICAgICBfX3Nob3N0X2Zvcl9lYWNoX2RldmljZShzZGV2LCBoYmEt
Pmhvc3QpIHsNCj4gPsKgPsKgKyAgICAgICAgICAgICAgIGhwYiA9IHVmc2hwYl9nZXRfaHBiX2Rh
dGEoc2Rldik7DQo+ID7CoD7CoCsNCj4gPsKgPsKgKyAgICAgICAgICAgICAgIGlmICghaHBiKQ0K
PiA+wqA+wqArICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gPsKgPsKgKw0KPiA+
wqA+wqArICAgICAgICAgICAgICAgaWYgKHJzcF9maWVsZC0+bHVuID09IGhwYi0+bHVuKSB7DQo+
ID7CoD7CoCsgICAgICAgICAgICAgICAgICAgICAgIGZvdW5kID0gdHJ1ZTsNCj4gPsKgPsKgKyAg
ICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID7CoFRoaXMgcGllY2Ugb2YgY29kZSBsb29r
cyBhd2t3YXJkLCBhbHRob3VnaCBpdCBpcyBwcm9iYWJseSB3b3JraW5nLg0KPiA+wqBXaHkgbm90
IGp1c3QgaGF2aW5nIGEgcmVmZXJlbmNlIHRvIHRoZSBocGIgbHVucywgZS5nLiBzb21ldGhpbmcg
bGlrZToNCj4gPsKgc3RydWN0IHVmc2hwYl9sdSAqaHBiX2x1bnNbOF3CoGluIHN0cnVjdCB1ZnNf
aGJhLg0KPiA+wqBMZXNzIGVsZWdhbnQgLSBidXQgbXVjaCBtb3JlIGVmZmVjdGl2ZSB0aGFuIGl0
ZXJhdGluZyB0aGUgc2NzaSBob3N0IG9uIGV2ZXJ5DQo+IGNvbXBsZXRpb24gaW50ZXJydXB0Lg0K
PiANCj4gSG93IGFib3V0IGNoZWNraW5nIChjbWQtPmx1biA9PSByc3AtPmx1bikgYmVmb3JlIHRo
ZSBpdGVyYXRpb24/DQo+IE1ham9yIGNhc2Ugd2lsbCBiZSBoYXZlIHNhbWUgbHVuLiBBbmQsIGl0
IGlzIGhhcmQgdG8gYWRkIHN0cnVjdCB1ZnNocGJfbHUNCj4gKmhwYl9sdW5zWzEyOF0NCj4gaW4g
c3RydWN0IHVmc19oYmEsIGJlY2F1c2UgTFVOIGNhbiBiZSB1cHRvIDEyNy4NCk9oIC0geWVzLCA4
IGlzIGZvciB3cml0ZSBib29zdGVyLg0KT0suICBXaGF0ZXZlciB5b3UgdGhpbmsuDQoNCkhvd2V2
ZXIsIEkgdGhpbmsgdGhlcmUgY2FuIGJlIHVwIHRvIDMyIHJlZ3VsYXIgbHVucywNCm1lYW5pbmcg
VUZTX1VQSVVfTUFYX1VOSVRfTlVNX0lEIG5lZWQgdG8gYmUgZml4ZWQgYXMgd2VsbC4NCg0KVGhh
bmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IERhZWp1bg0K
