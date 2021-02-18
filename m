Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D432EC4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 17:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F00614A7
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 17:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhBRQ7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:59:14 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:1841 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbhBROKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 09:10:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613657756; x=1645193756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=onD5V8ckxgACDi52/8GYh5m3pkWlNDHBsLMf5VMW7jo=;
  b=jZOrUbUrQgp7oefwxGIuC7EUAq9vzY2t+x5UcmaMHE+NzkY0Zj1tVQKm
   05jmfGqnmUtc3HQeXO/JVLlBJMdsLKkxL9MbP8vrWLG7XvEpC6hGMFoZl
   7yTPAI3CUHdqOlT0TyzGMUUYUSxPOBbz8kJBTVFbGyzC3zgSiWOiotirF
   kyq67O0KaXE36h0oy8bPNW6i2jiX/MzSTrTfZ/9KhLPx9MZmb27/UAA7W
   tH+AvVbzPU3clc59C0cmXl+yxZD6WwXk+qJgOADEJ6dhjyZCj2F8zT+SC
   tr+Tlc6pGJiK+rouxF83v3yXkk4T8WDRk7CW6V7m+Sa2OaXzNNwBrfqY9
   A==;
IronPort-SDR: KVzvDy1zaN/FBFgGwIw440b6naYn5kB+ObAI609vzXyih6rfBnX/e/v6mErJ2rAd2D0CcnHKt1
 5Cte29F9hKP7BQs4yvKVNWV69PuxwDJSos/GZJv+8fpzrV0LqZmzmC0qu3ZKCMTArI0hvmPxEm
 waxO3YmP/ghqleSA4eNyyp+sAg5NRvHYGRAd90Y8Pge9tCtZ8pQ8JVRxc6ftE6kHqv0HI+2Dgr
 c9CD6NvAAh70yAjuGDPTjyocqSupaxoasRcA/ptcmOZ0gzKIb0nB4c515cug3+X7J0Kr2cgr4M
 KZw=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="264444347"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 22:14:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEHcI/txftcaHdQC9IJwuCfXYRWDtRhYsrpWeyDpdhe2VJmtH+UIH1FNJ2uHnW5PtL1WVu535Ba8NOvp1xCPav/5g/LINCxV7y2T3kNPTJqwvFOKe12a0sRo3J9DD9PBublHXY9u5QkGO3pVyxgGgBhe8gDmkZ2/q6X+Zu7XR7RR1lyN9huOP/zQEtqwA4EDTLyBWN5RztLUW2fI0jErtwjlVvU8NgSFNwQ44H02PJNrQtQ3+hUF0xYYNa5no2P7NCZXGgEzphMr+VtuENLrzAv+CZVRfknYLYxXR+v6U/3+nBr2fPF6t1S1iYfZXu0PrgfodJOo7h0FQ1Ms8282nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onD5V8ckxgACDi52/8GYh5m3pkWlNDHBsLMf5VMW7jo=;
 b=Q4WLhNc7d9ErmN61MbHDMN0b1vuJjyZR18WNNK/hl+yoFzAFbnAMGXMd/5lazh1VZyGpsEzlPJtzsYFZpH9sV1xDfga6ciwXDyg2E2NR34d2HHSiS5ntdvJoMv4IhFAhuDD/ofuYViCqGvvXsvO3E6d6FKUfOKiiX4rCIyvYCfJnCgMniIX/rrvlbP+ihyZdOEffw4BYG4//4+a5DUUNnO1Hssis3pgW/cGOpVGQVJk4mzaMGsIWvFK1TA6B+ZQl8nSjvvBKPCHb6/7Xe/QBie1xrTYwQ8MZ4MDXfC3A/x3FilJ1B9s0z3R7sjcGVffUkwalE5loCqJF8BJNpFYCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onD5V8ckxgACDi52/8GYh5m3pkWlNDHBsLMf5VMW7jo=;
 b=fuao4XfjbSRM2TeN4LCkhy3UTdwjFqY0rYecpplmCKZREWzxC8w6a1s1V5lvMG3UPEErTM1T11hBBqo36WvWbxK1VSdAu5Kx0easPWhyH8Xn0y/dc06hBAQ0Ms/cX6ebeu7LeHrBJRjb+ndq+zcovf34dPNfbZS1oOvdmYH8xfU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5017.namprd04.prod.outlook.com (2603:10b6:5:fd::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.27; Thu, 18 Feb 2021 14:09:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 14:09:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v3 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Topic: [PATCH v3 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Index: AQHXBfkF1tJ5H5SAtEudF2R53/0h7qpd7Y0AgAAFzFA=
Date:   Thu, 18 Feb 2021 14:09:38 +0000
Message-ID: <DM6PR04MB65758A674D4C8C949DEFFD3FFC859@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
 <20210218131932.106997-10-avri.altman@wdc.com> <YC5wMu6Axu8G+Nsg@kroah.com>
In-Reply-To: <YC5wMu6Axu8G+Nsg@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c094de8-85f5-477f-c23c-08d8d416d43c
x-ms-traffictypediagnostic: DM6PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5017DE7DB9DEB5601C4826F6FC859@DM6PR04MB5017.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 03qIqw5HtjiRg1gmAySvC5L2uia1eY15O4JxRWXjePuVjNHtjxGYc8jsFIgvO81T3RBHEAKwrJHyOKCPikWkG1ahdbJ5XOuFEOEvshaSlN/q1iNfV/l1CQwZhT207dcgmV4Lsf76CEvTVx1l7rIowSr7Vegpypz0sLHpEY8YkLFr/lRvI24gaGBRW9uIA3nxg6hkyVEd+U90KnovmFlPUzGFVZJjN0/hPri2IyPmyPovf9lKjRBYEcfVUMRXrG/eucG+3IUSa7eG0PNY3BOGWzqZEHvo6amjKGEq/B8NZ1qK2dKMsRiqGSgIsVHtyCaiUFmCH9jRLGiDibnYhuehT7p9H4s+UWl9Rcf/su/Va8LTGVRhwH9gV6bICZ1q3x+QKGMTKhuDY+Ab/WRPtzSO1U9GiiDfmR4iXVINfT6xDyamukkriCxrNz7qMvQ8DnoVkMTS79zf3GFIugyABmZaftueo7OLHS0kJbGrkc/Zif8mVw5uZnPx2SkXDrGRhbxmclXdEIjwqua+eC96YJmusw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(76116006)(26005)(33656002)(64756008)(66446008)(5660300002)(6506007)(66476007)(66556008)(55016002)(52536014)(8676002)(66946007)(9686003)(4744005)(8936002)(478600001)(7696005)(7416002)(71200400001)(316002)(54906003)(86362001)(186003)(6916009)(2906002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Qk9KcVNnSzlRenIvMFJlcFRuU25MNnJualMwbGVTYXJiOXp0d3lHMkZ5MnFz?=
 =?utf-8?B?VUZlWW1ueEtlSlRObHNZdTdMWElVb3gyemIrMlM0ajRPWkZHU2FtUGxrY1BX?=
 =?utf-8?B?U2tUWHZVR3h6bk1CWjg1U2dJUmxBT3RmOU0yZ1JaT1cyTmx6K08xbDdIQnJ5?=
 =?utf-8?B?QU5BSG9wUHBsUm4vMGU1ak5TeVFTNmZOM0VIY1NTOURjanBSbGJBV1pWQnhi?=
 =?utf-8?B?S3FiVk9CRU5pYU5RNVJuMHIvaGpjQkEzTUt2RG0wemhyTkFwSXpOZ0lGeW5m?=
 =?utf-8?B?VzBUR25UK1krWWhNYkJjTnlIZzRMN1NxUEMxVWVhRjNjcUVIS3ExUHB6SURx?=
 =?utf-8?B?R3dKNFY1S2tBSk81b2FGTHp1bHRDQXhNbnRDWHZYWFZHMHM1UGFkTGZLdkRG?=
 =?utf-8?B?SFFucnlQOWhBNzU3UDZkc3FraXdNbWpvSTcxVFNlVHdyVThpcGl2MldzUTF3?=
 =?utf-8?B?c3RtWUFJVjY5V05Md3JnR0ovR0cwaDJnVVFVZG9Sd3NiT1lCaFh4QXZkY1Iy?=
 =?utf-8?B?bTZwdWNpVXZnZnFjNW5seVV0djdEUHBrU1ZoSnpXUis2T1RBOWtNejRtZm4z?=
 =?utf-8?B?T1M0U1pxR1pySDRCVmJCcDBJaEFkV3ZjR3dVM1RSTlZ5UWVmTFAyRXJYZlI2?=
 =?utf-8?B?d0h0b3RQVmlGMzFHL2dQSjlIa21JTnB1M0k3cmFkK1h2ZytXS1pVSGtadWtH?=
 =?utf-8?B?d2dsdWJZckpNTW44VDRxVWtUN2FiY3o2UHEyRE9BVDBPN09teDQvVlRzTlor?=
 =?utf-8?B?VWpadlNacnFhcVNYOTJNMkx6Z3hHTzVsYjlZUldMYzdvTGlONGRoS3gwdjlQ?=
 =?utf-8?B?NGtzOGRDeWx0MG9ldzVpYmdOUEJrZmRMV0xjd00vZnRFVExkakowQ0d5QmFU?=
 =?utf-8?B?RUMyQzNXNllVbDIwQlh0UWF2UkwwUG1VVklKQklmdWRzNkVaM0s3cFVIZE82?=
 =?utf-8?B?TlVqVEZjbVFTUUFSZy81TURXNkVFK0NpSXhTVjNZK0FkOExIb2owMXNtazgw?=
 =?utf-8?B?WXVaOFNLcU1TdlJlZ0l2ZkptczZrZFhFZ284SUxuTUpQWEJNYTB1c2Y0Q2RJ?=
 =?utf-8?B?V3NWSUZ1UVdzQytIdEt6R3lpYTdMS2JYTmxOMXJER1BaUmdyQWF5SnFxOUg2?=
 =?utf-8?B?M2F2d3pFS0g3RXlXelVXWUFaajJueEFwbjN0M2J1RTM2QUJzREFnaWdEY3lj?=
 =?utf-8?B?aUp3ZWhCZ2lEK2dCeTd5Wktlc3h0amUxVFpMUjBqWVovUGM5NDRNSkNaamd2?=
 =?utf-8?B?TGNvS2RHTDVodXdnalVNdmg1cDAxUDlFaFdlNy9CZ3FtaEo2QVNzZ2g5L3Zi?=
 =?utf-8?B?WGkyVmVZVXIwTWtRT2FySUxYRnl1MmFrbS9kRUtEWWlFdWplc1VVV3VaNUNh?=
 =?utf-8?B?NU1wTit5YmVvY0phL25LMlN1dklJRytKVGk2enM0TTBmQy96bUd6bTYwb0FN?=
 =?utf-8?B?WFZjaVF2c0I1eW0yUURtR29lbUd4azYrejBZZ1RUTWR5QW1mTjBDREV6UDh6?=
 =?utf-8?B?ZU1lTnFtR2FQdlNEaSswd0RNVlY3WmZraERpV3puVjlJUlBmSDFtUzA2eFFz?=
 =?utf-8?B?VHphek5mSG9lY1BNVjJlcGxKQVNBM1pjeENBSGVoODJEUkFlVGZ2NVlGOGZO?=
 =?utf-8?B?Vm5sMXc5dzQ5R0FuNTVwWjRZWEpVV3ZoQUZ1VktheWdlY2pXVzV4REM5a3cw?=
 =?utf-8?B?RFNBZnh2VkVVQmpoQTlzQkNmZ0xVVlNCa3UxVGg2aVlSVWNCclJUdXNtV3RH?=
 =?utf-8?Q?ldppaDwvalOKAZ1DgNKEcEroexJDt2j3f2JuYhH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c094de8-85f5-477f-c23c-08d8d416d43c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 14:09:38.7338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vLYWy3udUUQs5AhvceZqn9f8qvgJbf5g90kIK86PoQ/HgLeWAFMwr1hTx4jv12jLaTc51Z02+D+zSrPa7+DEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICtXaGF0Og0KPiAvc3lzL2NsYXNzL3Njc2lfZGV2aWNlLyovZGV2aWNlL2hwYl9wYXJhbV9z
eXNmcy90aW1lb3V0X3BvbGxpbmdfaW50ZXJ2YWxfbXMNCj4gPiArRGF0ZTogICAgICAgICAgICAg
ICAgRmVicnVhcnkgMjAyMQ0KPiA+ICtDb250YWN0OiAgICAgQXZyaSBBbHRtYW4gPGF2cmkuYWx0
bWFuQHdkYy5jb20+DQo+ID4gK0Rlc2NyaXB0aW9uOiB0aGUgZnJlcXVlbmN5IGluIHdoaWNoIHRo
ZSBkZWxheWVkIHdvcmtlciB0aGF0IGNoZWNrcyB0aGUNCj4gPiArICAgICAgICAgICAgIHJlYWRf
dGltZW91dHMgaXMgYXdha2VuLg0KPiA+ICs+Pj4+Pj4+IGVmNmJmMDhlNjY2ZC4uLiBzY3NpOiB1
ZnNocGI6IE1ha2UgaG9zdCBtb2RlIHBhcmFtZXRlcnMNCj4gY29uZmlndXJhYmxlDQo+IA0KPiBE
aWQgeW91IG1lYW4gZm9yIHRoaXMgbGFzdCBsaW5lIHRvIGJlIGhlcmU/DQpUaGFua3MuIERvbmUu
IA0KDQo=
