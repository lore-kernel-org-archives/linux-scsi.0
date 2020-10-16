Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E18C43457
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 22:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C68722203
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 22:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Lh4lePHS";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vaEvDElp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404934AbgJPWbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 18:31:25 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2064 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404839AbgJPWbZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2020 18:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602887483; x=1634423483;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xsHZaQrfMwHC+BDp9Mk4XCIboxh4e0tnFHpKG1juW9c=;
  b=Lh4lePHSL95N60JWo1DTkTIZjb+yFFacx5fO3GIeogn5zcI2ZpVmgg/V
   NwF2md1S2cG+Z1sEhZ6EFsJe0yov2mkqCvwG6zU39EXlrJ4KoijkBjF/r
   ApLGINAN1n2A0xySYE/fxrXM7DXgXS3gxFsm39Wm0uAttgHA2fFUR76bF
   brOTrXjAqpedCJnd4dMOaECZoNuKaXiBc1tXehOsuanzovT7Rfzet+3zc
   eq22+tAF0tG5h4Z+9ttUxNb00mFvevcTqKLbzPFkHmMuK21ZUKhYu4o6R
   gQNcJS70yMY7QPi7FW8OJOPcIcPSU4LAUKABJLrcrwyS8mdu43V8gJORs
   A==;
IronPort-SDR: qUeKyljFDQs8hHUG2isYBIBG1NQ1fUaFdDmMROe2382WKEu53sKtPi0kONwx5sG7JuzOHh9zrs
 LkSlS8fY4K+D/XQXnsCTPE4pCai6sqcXqTXd5Uee/0LiUUfyYGjLmZB0Ii4UNSDH5AaAQX6x6x
 sHHxlO/8UeEG4QlJg0fo+SpnG053rpVnVBnTu6hMUMGtiHnJNFtI4j7dBNJYitskk1YI4LNZCK
 bQKZFkw0vNYEkwO0fcM9yvR56ggZHmEhCx8WnCgB5fMICbDrZ/2g4a7020JlBZfs+yFHUjg7OZ
 zdw=
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="90475829"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Oct 2020 15:31:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 16 Oct 2020 15:31:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 16 Oct 2020 15:31:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJ98PrOTNT65XFABgXJp8TAnYJPkeVfRmwc+no+IO/lHuNwPFmDzKcotU7c6U8V0re8DEfQmlDYjbSj2y7E+9hPVx+ckt75weKWtdy4zC5/izc8VFRTOjHcvhjwfBWBcfV6dAGfZ6Ja/14DUmWQwV82dgO3XYv4Zsa6fflMgZycUc61hKkizOWfXqZ8C31jWAXkygH+uCyf0Bgvqk7gPeWBu7v3Th3pj12bOmGBVQSzldQy5jPp9SH+ATnPcsEn5AQil2mhm6XLjtcGWvkGsRSr8IpdFxt9Zi7xTdM41239QlaKLHVp6eMfYJl/mze6EZ5tY8v92378y09swX044iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsHZaQrfMwHC+BDp9Mk4XCIboxh4e0tnFHpKG1juW9c=;
 b=MDdtrEs1KkBFOziu58VvC6O9a9077iuyf37RIqnHEOYsHhLpvhrIFpoTQLytx57rV2wx8KJcLTgHKvTNc8UCHzJZNhCE420N9OaflSqbxTvi/a2Z8n8NYoaCvaf07ThnEpazRP7Kg+dokR0RV/n6CNp/Clf4HQLiPsZ3F60yHPM95kDRyncJwvjZCz26oek+k2pJ336kFyOhxKInseGyHYjZgBfG8DdCEf/o4uDCGqbuiv/aTBcVrzYdfk7lZlKWlCqqSDskcFZ3V9Rex56p6ASDtp8rJY41z74/BkzaUoZ5paboPXpuLa+grWmHyf0yGpUmamTEbgLSy8d5+2xScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsHZaQrfMwHC+BDp9Mk4XCIboxh4e0tnFHpKG1juW9c=;
 b=vaEvDElp8+M5sEIoAM+5uosNHJsQScst6K3xzrUJ04HR/p8L+41eiScO4HLo+E/Ymg+OFlcPb2VO5WBWSl+W9Mf2LWngbzFiTifNSxg+9j5671DI5mBf+WWPntuvEsp422CvF1e+ys3IqSFz5zfDmXqyU2vHNeGYJOz7XuYC07Q=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2702.namprd11.prod.outlook.com (2603:10b6:805:60::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Fri, 16 Oct
 2020 22:31:20 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::cc4c:c230:c557:d721]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::cc4c:c230:c557:d721%7]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 22:31:20 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <don.brace@microsemi.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <esc.storagedev@microsemi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>
Subject: RE: Linux 5.9: smartpqi: controller is offline: status code 0x6100c
Thread-Topic: Linux 5.9: smartpqi: controller is offline: status code 0x6100c
Thread-Index: AQHWonO8UiICPhpY0kecsPCfXgT31ama0hsA
Date:   Fri, 16 Oct 2020 22:31:20 +0000
Message-ID: <SN6PR11MB28482195705A64E8F8ECD52AE1030@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <bc10fad1-2353-7326-c782-7a45882fd791@molgen.mpg.de>
In-Reply-To: <bc10fad1-2353-7326-c782-7a45882fd791@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4e3e9d1-6495-4591-258d-08d8722334da
x-ms-traffictypediagnostic: SN6PR11MB2702:
x-microsoft-antispam-prvs: <SN6PR11MB2702DE257108DA68129D6C54E1030@SN6PR11MB2702.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IKgjt3kTRP56nbQ3WzLFZGM00GOIT23+4Mz/6mULrNDaK67Ie6jkdcRjpzOHmiC18H0a1mXJFdymraKIJMGWUJk/rpIq6VQMCa9cUsV5C38g6Aew75qyLkun7mtLuLf7NI8f9sOdOsFJdt0vyXMYUXjw2COqoBs5asWsESPVbxhTxQM3fp9opytGHJrfAlQr5sD0XUOg866yWAYnOSvckP245kMP+PMZp2IlfW5nVcLlQPksXCOGfYWu/z53J8ZZI8wWhGwiqXiujPi+SFsNsgQUDAiBKkhg0s8Cr2ULjwGH9AMsSiIgPeRA04uDSPIW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(316002)(478600001)(66446008)(86362001)(4326008)(9686003)(64756008)(76116006)(66476007)(66946007)(2906002)(26005)(83380400001)(53546011)(7696005)(6506007)(186003)(66556008)(33656002)(8936002)(71200400001)(110136005)(52536014)(8676002)(54906003)(5660300002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dH7osOO85ume5qflpykePYM5epT/h98M7b0X0A/wSb/d3kMkwaj/BrDOJ4nb76mAJ37YMOzHiHSIAggGYPeDbh4oSB4wmYzKlVvVZek8cElwMHaJ+zHvTnXTguMcrD0vGpjEZs8T56UYwO3/PAhS/fe0MCVETx7Onh2hQwNWvXyROX8CKGAz6RlakFW6af7vw+C2LETyhnOGgoJWB/vwbXsr3HWE0954wCswwDdQyBNg04TUKt/fFsUJ7UjDP5z2H0QbHiokk5Ok+gV2yb/3N/f91QPsSK58ZKgywHAzjyOS8UCwX6+EfY1pb3fRmxOc4n+oHNIQaXTWnRYtrsxT/6gEV48WJyOILCD6sLnihpDAigo3ObBaEl9yDohYPQWHR29CEop5lj1shtMK8srD7Rt5E8/7bxHj1l6fLwS4E4GBpwwqLKIab80Ma0AIyNBkq/Qdr1d/g6MBNDXIvnaFLGkCpE1odCmLAmfBu3k6F5PaAsf8xHmySEtDMzfuA0CbxKfiCbkPgbSlrMxeAib5MSHouOYwh5LDPj0V+abdL5ES6OPHwq/7aewZvIB7jvcmmBOsI0fNSsLW3nUsCvuykqG0w5ByV6acN+xbEUFdaIYm+bHEWOTdD6Y41MqR8DgbBr0oERNz8aA9tACZ4U5xfA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e3e9d1-6495-4591-258d-08d8722334da
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 22:31:20.8139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SasQAE+2AaiRZXo+e65d1Q5dD2nbWDJ0vOd3Az1LwhayrK+tE0Kf/t1QVMDy3TLFRjOWALafAxDGQhvE5CGkWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2702
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhlIDYxMDBDIGxvY2t1cCBpcyB0aGUgcmVzdWx0IG9mIHRoZSBjb250cm9sbGVyIHJ1bm5pbmcg
b3V0IG9mIGNvbW1hbmRzIHRvIHByb2Nlc3MgbmV3IGluY29taW5nIHJlcXVlc3RzIGZyb20gdGhl
IGRyaXZlci4NCg0KV2UgYXJlIGFjdGl2ZWx5IGxvb2tpbmcgaW50byB0aGlzIGlzc3VlLg0KDQpX
ZSB3aWxsIGtlZXAgeW91IHBvc3RlZCwNClRoYW5rcywNCkRvbg0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogUGF1bCBNZW56ZWwgW21haWx0bzpwbWVuemVsQG1vbGdlbi5tcGcu
ZGVdIA0KU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDE0LCAyMDIwIDQ6NDcgUE0NClRvOiBEb24g
QnJhY2UgPGRvbi5icmFjZUBtaWNyb3NlbWkuY29tPg0KQ2M6IEphbWVzIEUuIEouIEJvdHRvbWxl
eSA8amVqYkBsaW51eC5pYm0uY29tPjsgTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJz
ZW5Ab3JhY2xlLmNvbT47IGVzYy5zdG9yYWdlZGV2QG1pY3Jvc2VtaS5jb207IGxpbnV4LXNjc2lA
dmdlci5rZXJuZWwub3JnOyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgaXQr
bGludXgtc2NzaUBtb2xnZW4ubXBnLmRlDQpTdWJqZWN0OiBMaW51eCA1Ljk6IHNtYXJ0cHFpOiBj
b250cm9sbGVyIGlzIG9mZmxpbmU6IHN0YXR1cyBjb2RlIDB4NjEwMGMNCg0KRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25v
dyB0aGUgY29udGVudCBpcyBzYWZlDQoNCkRlYXIgTGludXggZm9sa3MsDQoNCg0KV2l0aCBMaW51
eCA1LjkgYW5kDQoNCg0KICAgICAkIGxzcGNpIC1ubiAtcyA4OToNCiAgICAgODk6MDAuMCBTZXJp
YWwgQXR0YWNoZWQgU0NTSSBjb250cm9sbGVyIFswMTA3XTogQWRhcHRlYyBTbWFydCBTdG9yYWdl
IFBRSSAxMkcgU0FTL1BDSWUgMyBbOTAwNTowMjhmXSAocmV2IDAxKQ0KICAgICAkIG1vcmUNCi9z
eXMvZGV2aWNlcy9wY2kwMDAwOjg4LzAwMDA6ODg6MDAuMC8wMDAwOjg5OjAwLjAvaG9zdDE1L3Nj
c2lfaG9zdC9ob3N0MTUvZHJpdmVyX3ZlcnNpb24NCiAgICAgMS4yLjgtMDI2DQogICAgICQgbW9y
ZQ0KL3N5cy9kZXZpY2VzL3BjaTAwMDA6ODgvMDAwMDo4ODowMC4wLzAwMDA6ODk6MDAuMC9ob3N0
MTUvc2NzaV9ob3N0L2hvc3QxNS9maXJtd2FyZV92ZXJzaW9uDQogICAgIDIuNjItMA0KDQp0aGUg
Y29udHJvbGxlciB3ZW50IG9mZmxpbmUgd2l0aCBzdGF0dXMgY29kZSAweDYxMDBjLg0KDQo+IE9j
dCAxNCAxNDo1NDowMSBkb25lLm1vbGdlbi5tcGcuZGUga2VybmVsOiBzbWFydHBxaSAwMDAwOjg5
OjAwLjA6IA0KPiBjb250cm9sbGVyIGlzIG9mZmxpbmU6IHN0YXR1cyBjb2RlIDB4NjEwMGMgT2N0
IDE0IDE0OjU0OjAxIA0KPiBkb25lLm1vbGdlbi5tcGcuZGUga2VybmVsOiBzbWFydHBxaSAwMDAw
Ojg5OjAwLjA6IGNvbnRyb2xsZXIgb2ZmbGluZSANCj4gT2N0IDE0IDE0OjU0OjAxIGRvbmUubW9s
Z2VuLm1wZy5kZSBrZXJuZWw6IHNkIDE1OjA6MjowOiBbc2R1XSB0YWcjNzA5IA0KPiBGQUlMRUQg
UmVzdWx0OiBob3N0Ynl0ZT1ESURfTk9fQ09OTkVDVCBkcml2ZXJieXRlPURSSVZFUl9PSyBjbWRf
YWdlPTZzIA0KPiBPY3QgMTQgMTQ6NTQ6MDEgZG9uZS5tb2xnZW4ubXBnLmRlIGtlcm5lbDogc2Qg
MTU6MDoxNTowOiBbc2RhaF0gDQo+IHRhZyMyNzQgRkFJTEVEIFJlc3VsdDogaG9zdGJ5dGU9RElE
X05PX0NPTk5FQ1QgZHJpdmVyYnl0ZT1EUklWRVJfT0sgDQo+IGNtZF9hZ2U9NnMgT2N0IDE0IDE0
OjU0OjAxIGRvbmUubW9sZ2VuLm1wZy5kZSBrZXJuZWw6IHNkIDE1OjA6NDowOiANCj4gW3Nkd10g
dGFnIzUxNiBGQUlMRUQgUmVzdWx0OiBob3N0Ynl0ZT1ESURfTk9fQ09OTkVDVCANCj4gZHJpdmVy
Ynl0ZT1EUklWRVJfT0sgY21kX2FnZT02cyBPY3QgMTQgMTQ6NTQ6MDEgZG9uZS5tb2xnZW4ubXBn
LmRlIA0KPiBrZXJuZWw6IHNkIDE1OjA6NDowOiBbc2R3XSB0YWcjNTE2IENEQjogV3JpdGUoMTAp
IDJhIDAwIDBkIGU2IDllIDg4IDAwIA0KPiAwMCAwMSAwMCBPY3QgMTQgMTQ6NTQ6MDEgZG9uZS5t
b2xnZW4ubXBnLmRlIGtlcm5lbDogDQo+IGJsa191cGRhdGVfcmVxdWVzdDogSS9PIGVycm9yLCBk
ZXYgc2R3LCBzZWN0b3IgMTg2NTc0MTM3NiBvcCANCj4gMHgxOihXUklURSkgZmxhZ3MgMHgwIHBo
eXNfc2VnIDEgcHJpbyBjbGFzcyAwIE9jdCAxNCAxNDo1NDowMSANCj4gZG9uZS5tb2xnZW4ubXBn
LmRlIGtlcm5lbDogc2QgMTU6MDowOjA6IFtzZHNdIHRhZyM1MjkgRkFJTEVEIFJlc3VsdDogDQo+
IGhvc3RieXRlPURJRF9OT19DT05ORUNUIGRyaXZlcmJ5dGU9RFJJVkVSX09LIGNtZF9hZ2U9NnMg
T2N0IDE0IA0KPiAxNDo1NDowMSBkb25lLm1vbGdlbi5tcGcuZGUga2VybmVsOiBzZCAxNTowOjA6
MDogW3Nkc10gdGFnIzUyOSBDREI6IA0KPiBXcml0ZSgxMCkgMmEgMDAgMjkgNGUgZTggZmYgMDAg
MDAgMDEgMDAgT2N0IDE0IDE0OjU0OjAxIA0KPiBkb25lLm1vbGdlbi5tcGcuZGUga2VybmVsOiBi
bGtfdXBkYXRlX3JlcXVlc3Q6IEkvTyBlcnJvciwgZGV2IHNkcywgDQo+IHNlY3RvciA1NTQ0Mjk4
NDg4IG9wIDB4MTooV1JJVEUpIGZsYWdzIDB4MCBwaHlzX3NlZyAxIHByaW8gY2xhc3MgMCBPY3Qg
DQo+IDE0IDE0OjU0OjAxIGRvbmUubW9sZ2VuLm1wZy5kZSBrZXJuZWw6IHNkIDE1OjA6MDowOiBb
c2RzXSB0YWcjNjI3IA0KPiBGQUlMRUQgUmVzdWx0OiBob3N0Ynl0ZT1ESURfTk9fQ09OTkVDVCBk
cml2ZXJieXRlPURSSVZFUl9PSyBjbWRfYWdlPTZzIA0KPiBPY3QgMTQgMTQ6NTQ6MDEgZG9uZS5t
b2xnZW4ubXBnLmRlIGtlcm5lbDogc2QgMTU6MDowOjA6IFtzZHNdIHRhZyM2MjcgDQo+IENEQjog
UmVhZCgxMCkgMjggMDAgNWQgZGYgMmMgMDQgMDAgMDAgMDQgMDAgT2N0IDE0IDE0OjU0OjAxIA0K
PiBkb25lLm1vbGdlbi5tcGcuZGUga2VybmVsOiBibGtfdXBkYXRlX3JlcXVlc3Q6IEkvTyBlcnJv
ciwgZGV2IHNkcywgDQo+IHNlY3RvciAxMjU5OTI1NTA3MiBvcCAweDA6KFJFQUQpIGZsYWdzIDB4
MTAwMCBwaHlzX3NlZyAxIHByaW8gY2xhc3MgDQo+IE9jdCAxNCAxNDo1NDowMSBkb25lLm1vbGdl
bi5tcGcuZGUga2VybmVsOiBzZCAxNTowOjU6MDogW3NkeF0gdGFnIzU2NyANCj4gRkFJTEVEIFJl
c3VsdDogaG9zdGJ5dGU9RElEX05PX0NPTk5FQ1QgZHJpdmVyYnl0ZT1EUklWRVJfT0sgY21kX2Fn
ZT02cyANCj4gT2N0IDE0IDE0OjU0OjAxIGRvbmUubW9sZ2VuLm1wZy5kZSBrZXJuZWw6IHNkIDE1
OjA6NTowOiBbc2R4XSB0YWcjNTY3IA0KPiBDREI6IFdyaXRlKDEwKSAyYSAwMCAyMSA0ZSBjZSAw
NCAwMCAwMCAwNCAwMA0KDQpIb3cgY2FuIHRoZSBzdGF0dXMgY29kZSAweDYxMDBjIGJlIGRlY2lw
aGVyZWQ/DQoNCg0KS2luZCByZWdhcmRzLA0KDQpQYXVsDQo=
