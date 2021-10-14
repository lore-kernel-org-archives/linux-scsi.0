Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50422C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 10:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36E8D610E6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 10:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhJNKHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 06:07:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23859 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhJNKHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 06:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634205898; x=1665741898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=un+Fm/NqzL//z8uE3qsZjrIv4zczTxdxsSauC0BLHNc=;
  b=RnZNYEBFdwF8kMPCqkvLemfadx74NHDPPSYRx4CoVGxFI9UtTWf2RY3i
   a0TM35eqXf+X5wmx/ZTvECKzVLzjcJpXSA2srwuaq+9I9tukWB5lHF+0F
   H3UK1Uj0yanGveGYdgJd5D4kvgv68KlQJR2Yg9ECMQX/xuNWiFq/OhANJ
   twIdENNo9DOnMRTlIQqqHvdy2BW+3HKXReRwR/h6Ub4KY7A25rOy7/21P
   EyZJLRKfWbjebN6/bhlBH1g2EXuGaSMrMMANjv7DZ1T6U/BSjw/IT2gnL
   bfciFv1y2oZk1L1NgcakeQ9QT2jkXfPtg5lI5SnvZDTccePa51d10e2ZN
   g==;
X-IronPort-AV: E=Sophos;i="5.85,372,1624291200"; 
   d="scan'208";a="183774702"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2021 18:04:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHxIG0yEONHzE3jspwv416pcYS5v4QCqko9PTuu2CjlGmr072K06uXekOniG8FZPOdGJwCsY7XPjrxjqOTv6PR31fo96mBG0sF9mNMemthmrRlh4O5+YQ+dpwlS/DCfugv8LFy9ZboqOjnXsYkL1rH52QFAb3qFgYMJz76qYHdH/UwcLJgin/ozFIzsURJWCWYRs7fD5G4PYB3P5tbM9JPzGSkip+18762mwf/WnwRuNz1BTR6NWV+3AcYVaItFXrNgDtDWIquaptE7CUTazaBI/XSV0UrjVMyXG/uzhjiZjFJ176IFO/s3I6ju65W2kKZ+IBYh+eHWr2igD0mU7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=un+Fm/NqzL//z8uE3qsZjrIv4zczTxdxsSauC0BLHNc=;
 b=hVBdonpqGsaxnd+kFx/9bIJrOHnM0Etc5HGNHyngzMfZD/HJUpE/1ujUedWSkB0f1mAPboazry8rh4XMwCzkAfw5Cdyi7prxZ5zkBMBwQ2ozPo3hcIOtMnk4uG1c7k1/2kIcXHYzPnYxS+/0RYqkBlEBkONwEl7hyIJMP8ZWTzUngmdPk7Po2UUK8nceSfkiCS0ZdMms9ECdifxUyEE3J20kTLoMtVo2ZIVXDXvT4GtlNppazJesXNQVqJWM/gNs1ARk1bqTkA+WwNAb7TqRIbYvNs4uwHI7Clj5bOB1lVydcd0jzAkfwKG8v98SW2+A/Pf2dRA1u+CF5wh4FQf0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=un+Fm/NqzL//z8uE3qsZjrIv4zczTxdxsSauC0BLHNc=;
 b=x4npoJSH+QHE5zb9SAv888AU2U+XuXsk0hr38uUiF+VEP/94kKfvAbX3BOj5uA7Sh1tTu63FSYUCDLnMGbJYnekp7YwFythG6n8BhmKAIi9yg4TP/C9lzhDUdinJgEJ0qCRt/CGR4tI8iKih8k9N8W+/wjme29nnGx4CB/l1e3k=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7116.namprd04.prod.outlook.com (2603:10b6:5:242::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.16; Thu, 14 Oct 2021 10:04:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 10:04:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v4 00/16] introduce exynosauto v9 ufs driver
Thread-Topic: [PATCH v4 00/16] introduce exynosauto v9 ufs driver
Thread-Index: AQHXu1MRuvzD0kwSWEij5cCK+M95DqvSTMTw
Date:   Thu, 14 Oct 2021 10:04:54 +0000
Message-ID: <DM6PR04MB657579A3B5545C759F325830FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2@epcas2p3.samsung.com>
 <20211007080934.108804-1-chanho61.park@samsung.com>
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d88e2a2-e970-4097-255f-08d98efa11da
x-ms-traffictypediagnostic: DM6PR04MB7116:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB7116D30650A825E7FF6DD13AFCB89@DM6PR04MB7116.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A7aQKz+mVx7946pj0KVPcyJ0LJLim4B4n9isZwHIi15EYbyatH0BbjaZaeaxQ2hCvWv5kOaT7VaxPwdi9Zl6e/EaP2QK0KK19+p2k7H3DcC6orEw8qINIqub/+RzgkVvQj98qfxa5/Cl9muihHq/QZ28iOwsXz17jBF9u591YzH5IBPoIO1R1gYnAkCzI+E+9ebP7nm4aB0ewgdRuFHZPAQqzC5zcMV5GvxDu0/tNc/kv61pkWAyvp/+isHv4SjEOw+jlwfxzHH8FWEQFDxA2ZWWXo1tAyfTVRH2OKzlh5jm+KhjO+I43Ig+712ZmX9XVeyKkODMLRSAYdubsDUB6ctVY4muQQC/vn8pyK6gJM+qugC1rzyk+cmCQ0pn3k/fbeWtpzoL0fiXpCPAvDU1MGXILWdAYzuRH+Tewo5vpZErPwBj+K3RRr+SsGO4+U1Cs7Q/KU7CeGBl9CxqBs3Gp1y/dGHRh1euGBse14062PpltyhC76T9xtLhwMgefyKj+jv4394QB4T2C53QbCV8ITHo/N4+WLsgRCKCsdZRdol63X1apPxVq3iSPwSZXVvkIC5nPFoSQsFeYKTtsWF3rc6AvN6tQ2kCYQrYhjVGR3PRpfKXCozyld5nH8tuKmAQmd/Mz8/8LNH1givuvXPeYrtoS1n1+k46Ry5F2VX9mWIJu+0me79vJaJnhCRpIvJztKA3raLMDmWu3GZt45lQqDbssGz4KLtyj3UtnozKZzlwMkSdrPpBsrapoRNm3H9Cgh7ViY4ZYu0S2fDwDKGL/+mhqwzzGwtJ710jOKRL0uWWinvkEzZ4wHenLnjdyOI0C8GQh4PeInHsvCoi7l27fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(83380400001)(122000001)(38100700002)(8936002)(66556008)(508600001)(2906002)(54906003)(76116006)(110136005)(966005)(316002)(9686003)(7416002)(4326008)(55016002)(186003)(26005)(66476007)(38070700005)(82960400001)(5660300002)(52536014)(33656002)(7696005)(86362001)(71200400001)(64756008)(66446008)(8676002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDZZVTRhQWpGT2tXbW5UdEYxNVlXaVhZMHRmUHVSWjJBWmYzZXRlVEczTTFv?=
 =?utf-8?B?Vkovemw2MFpEbTR1Y3VON0xnNld0c21yL3VaZzZyWkhYSzhzcHQvWnZ6WWhs?=
 =?utf-8?B?YU9WS0dwVUNoUFNpb2poSVNHMzdzamd1eE5UOVR4eDdkRlFqNkxrQUgzdzlr?=
 =?utf-8?B?ZE5CcjVaVzlWUmNuMEo0citwc08yQUFGMURhaGoxQnJJaVplVUlxQXFVRFRu?=
 =?utf-8?B?YStFN0tmUWh0eHdDQUhzTWgxZ1dtNnJObjBiZmEwMjRTa2RsYWpBMkRmMzh4?=
 =?utf-8?B?Ulh1WWxJMzRFOEhoRGtZVzhtbDRsVm5PcUV6RnlBYVBhWHNuNmVFdkZCcVI0?=
 =?utf-8?B?M1czcm0xbHNtaFh0ZUhtZmorcGQybjhqeTJOZTVrUEgrZU5aWmIzRHFyWk95?=
 =?utf-8?B?cHpBNmZKZ1dnOWI0QlJyZlZZUXVkaUNlT3VXclZtMktvM3djNXVocWZUcnVO?=
 =?utf-8?B?TXdYd0U0aWM2YWNXNkw1RVZBdkFrTlk5RzBuc2dQd0loY1ExQndmeUNVajZm?=
 =?utf-8?B?SG8yS0J4QlZmUFlsbGtqajRaV2Y5ZUh2dkRGVGhXcmg4cWZYMkpPQ1ZSbjYv?=
 =?utf-8?B?OS8zeDQ4akg5cnZDTit0QzZ4aGtWaGFXNlJIcjdxMmdSMGRkT3E0RHlpRVF4?=
 =?utf-8?B?dFNoZHNUT1dZUHU1bmhhYzhiQy8ydEpFcXNubUJVREJWWUFQMjB1dklKcEN5?=
 =?utf-8?B?d1FTb3JTRlB6bzAvalFsKzdpdkxtL1BEL0V4eWZtd0QrcWV1anh4bExwNTBD?=
 =?utf-8?B?WW40cjY2TUVKZldGSFBBbUYzbTA1T1FrM3pnTC9yaUFxQjNHUHVSQlRPN0l3?=
 =?utf-8?B?Y2Q3MTVHSTR1YkNMVEJVR3RTN2FndFFhd2MwWDB0L1NJV2RTU0tWN2hod1RJ?=
 =?utf-8?B?UmVQZGYzZ0RxTURUR0F4RUJuKzdKYXhVWUpKbWtaLzlsakdicVJINnBQTXVq?=
 =?utf-8?B?Q2ZaekxmNUpzK0l5UTYvZWxnTUlFOU5OaStMTmN0cFU0Y2xpb3krc0dqeWxU?=
 =?utf-8?B?MFREZEJJalQ1TjJrVDdwRkJkQkVwcjVCaEh5U0JDZGJqdHlEcUdaZWRVcDBv?=
 =?utf-8?B?WUN2amdEYSsvL0JYUVJzSnE2NFVvU0lZcXMvRzcvOU9VK0J4QjdzaEp3c3k4?=
 =?utf-8?B?SitQWWN6ai9kbzM3Z1hOU1VXb2s4TGh2UjIwbTMyZnZQbVYwamRhMnhCemJo?=
 =?utf-8?B?YWVRblNiSlBBQ0lIY1JXUlc4ME9NMXpmUUZpMjRjMjFxa3RvV0N6M0c3c2dp?=
 =?utf-8?B?UlVYcElLUGxMVTBndVllYXI4d29uTjBycVhoc3pVUVN0MVNCdnNIOG15SlFH?=
 =?utf-8?B?THRJTk1YaW9zWmJCWWZKTFJzVTgvQ2JZZUZWWGpBbytZZCsyVkljZ2dZV3Vi?=
 =?utf-8?B?T0FVQ0FST2JiS3hIVm9QcmswYzVKNWY0ZW85bURRem1nWDNuN2FhemRreUtY?=
 =?utf-8?B?aU1lMDlLbDY3N0RSRFpjZEsySGJIUm5EbTB6RkpYalF4eGNJSjhnM08zVE1q?=
 =?utf-8?B?N0dTM3hCT3NlRXZEaEVMc0tXNEZ5aHNLZVJPNk1QSno1ZXp1c0FnUi9WSlUx?=
 =?utf-8?B?NTJPNVZuWmprVDliaG1NVmxkRWcyRWk3T2ZucEYzWFh4bVh4VTNueGtrSmNi?=
 =?utf-8?B?M0lTdXR6VWw1eXV2RDU3Njc3cFBSUm9QbnRvMEk2ZVBieHd5YkJpUW5zUjZH?=
 =?utf-8?B?ZE5ySFJFU0pFNHRPT3VxdGZOdDViZzZtNUNLWGR6Z2J5aytETmJHQnFvLy9X?=
 =?utf-8?Q?HzlRJzGWQE79Q4jIht0Te0fl2vhjOCrzOQdpg8Z?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d88e2a2-e970-4097-255f-08d98efa11da
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 10:04:54.0549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UIfkdLUUcFnWOOwIUhzPiGMyuKkvtZtnvByVi2DUsBForSntxyYb1NFWWcdlckgx6obblFC3kcfBRGvkAWLlxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIA0KPiANCj4gSW4gRXh5bm9zQXV0byh2YXJpYW50IG9mIHRoZSBFeHlub3MgZm9yIGF1dG9t
b3RpdmUpLCB0aGUgVUZTIFN0b3JhZ2UgbmVlZHMgdG8NCj4gYmUgYWNjZXNzZWQgZnJvbSBtdWx0
aS1PUy4gVG8gaW5jcmVhc2UgSU8gcGVyZm9ybWFuY2UgYW5kIHJlZHVjZSBTVw0KPiBjb21wbGV4
aXR5LCB3ZSBpbXBsZW1lbnRlZCBVRlMtSU9WIHRvIHN1cHBvcnQgc3RvcmFnZSBJTyB2aXJ0dWFs
aXphdGlvbg0KPiBmZWF0dXJlIG9uIFVGUy4NCj4gDQo+IElPIHZpcnR1YWxpemF0aW9uIGluY3Jl
YXNlcyBJTyBwZXJmb3JtYW5jZSBhbmQgcmVkdWNlIFNXIGNvbXBsZXhpdHkgd2l0aA0KPiBzbWFs
bCBhcmVhIGNvc3QuIEFuZCBJTyB2aXJ0dWFsaXphdGlvbiBzdXBwb3J0cyB2aXJ0dWFsIG1hY2hp
bmUgaXNvbGF0aW9uIGZvcg0KPiBTZWN1cml0eSBhbmQgU2FmZXR5IHdoaWNoIGFyZSByZXF1ZXN0
ZWQgYnkgTXVsdGktT1Mgc3lzdGVtIHN1Y2ggYXMNCj4gYXV0b21vdGl2ZSBhcHBsaWNhdGlvbi4N
Cj4gDQo+IEJlbG93IGZpZ3VyZSBpcyB0aGUgY29uY2VwdGlvbiBvZiBVRlMtSU9WIGFyY2hpdGV0
dXJlLg0KQ29uY2VwdGlvbiAtLT4gYSBjb25jZXB0dWFsIGRlc2lnbg0KDQo+IA0KPiAgICAgKy0t
LS0tLSsgICAgICAgICAgKy0tLS0tLSsNCj4gICAgIHwgT1MjMSB8ICAgICAgICAgIHwgT1MjMiB8
DQo+ICAgICArLS0tLS0tKyAgICAgICAgICArLS0tLS0tKw0KPiAgICAgICAgfCAgICAgICAgICAg
ICAgICAgfA0KPiAgKy0tLS0tLS0tLS0tLSsgICAgICstLS0tLS0tLS0tLS0rDQo+ICB8ICBQaHlz
aWNhbCAgfCAgICAgfCAgIFZpcnR1YWwgIHwNCj4gIHwgICAgSG9zdCAgICB8ICAgICB8ICAgIEhv
c3QgICAgfA0KPiAgKy0tLS0tLS0tLS0tLSsgICAgICstLS0tLS0tLS0tLS0rDQo+ICAgIHwgICAg
ICB8ICAgICAgICAgICAgICB8IDwtLSBVVFBfQ01EX1NBUCwgVVRQX1RNX1NBUA0KPiAgICB8ICAg
Ky0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ICAgIHwgICB8ICAgIEZ1bmN0aW9uIEFyYml0
b3IgICAgIHwNCj4gICAgfCAgICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiAgKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ICB8ICAgICAgICAgICBVVFAgTGF5ZXIgICAg
ICAgICAgIHwNCj4gICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiAgKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ICB8ICAgICAgICAgICBVSUMgTGF5ZXIgICAg
ICAgICAgIHwNCj4gICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiANCj4gVGhl
cmUgYXJlIHR3byB0eXBlcyBvZiBob3N0IGNvbnRyb2xsZXJzIG9uIHRoZSBVRlMgaG9zdCBjb250
cm9sbGVyIHRoYXQgd2UNCj4gZGVzaWduZWQuDQo+IFRoZSBVRlMgZGV2aWNlIGhhcyBhIEZ1bmN0
aW9uIEFyYml0b3IgdGhhdCBhcnJhbmdlcyBjb21tYW5kcyBvZiBlYWNoIGhvc3QuDQo+IFdoZW4g
ZWFjaCBob3N0IHRyYW5zbWl0cyBhIGNvbW1hbmQgdG8gdGhlIEFyYml0b3IsIHRoZSBBcmJpdG9y
IHRyYW5zbWl0cyBpdCB0bw0KPiB0aGUgVVRQIGxheWVyLg0KLSBBcmJpdG9yIC0tPiBhcmJpdGVy
DQogLSB1ZnMgZGV2aXNlIC0tPiBob3N0IGNvbnRyb2xsZXINCkFuZCBtYXliZSByZXBocmFzZSB0
aGUgYWJvdmUgZGVzY3JpcHRpb24gKGFuZCBza2V0Y2gpIHNvIGl0IGlzIGNsZWFyIHRoYXQgdGhl
IFBILCBWSCwgYW5kIGZ1bmN0aW9uIGFyYml0ZXIgYXJlIGFsbCBodyBtb2R1bGVzIGluIHRoZSBo
b3N0IGNvbnRyb2xsZXIuDQoNClRoYW5rcywNCkF2cmkgDQoNCj4gUGh5c2ljYWwgSG9zdChQSCkg
c3VwcG9ydCBhbGwgVUZTSENJIGZ1bmN0aW9ucyhhbGwgU0FQcykgc2FtZSBhcyBjb252ZW50aW9u
YWwNCj4gVUZTSENJLg0KPiBWaXJ0dWFsIEhvc3QoVkgpIHN1cHBvcnQgb25seSBkYXRhIHRyYW5z
ZmVyIGZ1bmN0aW9uKFVUUF9DTURfU0FQIGFuZA0KPiBVVFBfVE1fU0FQKS4NCj4gDQo+IEluIGFu
IGVudmlyb25tZW50IHdoZXJlIG11bHRpcGxlIE9TcyBhcmUgdXNlZCwgdGhlIE9TIHRoYXQgaGFz
IHRoZSBsZWFkZXJzaGlwDQo+IG9mIHRoZSBzeXN0ZW0gaXMgY2FsbGVkIFN5c3RlbSBPUyhEb20w
KS4gVGhpcyBzeXN0ZW0gT1MgdXNlcyBQSCBhbmQgY29udHJvbHMNCj4gZXJyb3IgaGFuZGxpbmcu
DQo+IA0KPiBTaW5jZSBWSCBjYW4gb25seSB1c2UgbGVzcyBmdW5jdGlvbnMgdGhhbiBQSCwgaXQg
aXMgbmVjZXNzYXJ5IHRvIHNlbmQgYSByZXF1ZXN0IHRvDQo+IFBIIGZvciBEZXRlY3RlZCBFcnJv
ciBIYW5kbGluZyBpbiBWSC4gVG8gaW50ZXJmYWNlIGFtb25nIFBIIGFuZCBWSHMsIFVGU0hDSQ0K
PiBIVyBzdXBwb3J0cyBtYWlsYm94LiBQSCBjYW4gYnJvYWRjYXN0IG1haWwgdG8gb3RoZXIgVkgg
YXQgdGhlIHNhbWUgdGltZSB3aXRoDQo+IGFyZ3VtZW50cyBhbmQgVkggY2FuIG1haWwgdG8gUEgg
d2l0aCBhcmd1bWVudHMuDQo+IFBIIGFuZCBWSCBnZW5lcmF0ZSBpbnRlcnJ1cHRzIHdoZW4gbWFp
bHMgZnJvbSBQSCBvciBWSC4NCj4gDQo+IEluIHRoaXMgc3RydWN0dXJlLCB0aGUgdmlydHVhbCBo
b3N0IGNhbid0IHN1cHBvcnQgc29tZSBmZWF0dXJlIGFuZCBuZWVkIHRvIHNraXANCj4gdGhlIHNv
bWUgcGFydCBvZiB1ZnNoY2QgY29kZSBieSB1c2luZyBxdWlyay4NCj4gVGhpcyBwYXRjaHMgYWRk
IHF1aXJrcyBzbyB0aGF0IHRoZSBVSUMgY29tbWFuZCBpcyBpZ25vcmVkIGFuZCB0aGUgdWZzaGNk
IGluaXQNCj4gcHJvY2VzcyBjYW4gYmUgc2tpcHBlZCBmb3IgVkguIEFsc28sIGFjY29yZGluZyB0
byBvdXIgVUZTLUlPViBwb2xpY3ksDQo+IA0KPiBGaXJzdCB0d28gcGF0Y2hlcywgSSBwaWNrZWQg
dGhlbSB1cCBmcm9tIEpvbm1pbidzIHBhdGNoc2V0WzFdIGFuZCB0aGUgdGhpcmQNCj4gcGF0Y2gg
aGFzIGJlZW4gZHJvcHBlZCBiZWNhdXNlIHdlIG5lZWQgdG8gY2hlY2sgaXQgYWdhaW4uDQo+IA0K
PiBbMV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNjc2kvMjAyMTA1MjcwMzA5MDEu
ODg0MDMtMS0NCj4gamptaW4uamVvbmdAc2Ftc3VuZy5jb20vDQo+IA0KPiBQYXRjaCAwMDAzIH4g
MDAxMywgdGhleSBhcmUgY2hhbmdlcyBvZiBleHlub3M3IHVmcyBkcml2ZXIgdG8gYXBwbHkgZXh5
bm9zYXV0bw0KPiB2OSB2YXJpYW50IGFuZCBQSC9WSCBjYXBhYmlsaXRpZXMuDQo+IFBhdGNoIDAw
MTQgfiAwMDE3LCB0aGUgcGF0Y2hlcyBpbnRyb2R1Y2UgZXh5bm9zYXV0byB2OSB1ZnMgTUhDSSB3
aGljaA0KPiBpbmNsdWRlcyBQSCBhbmQgVkguDQo+IA0KPiBDaGFuZ2VzIGZyb20gdjM6DQo+IC0g
RHJvcCAiW1BBVENIIHYzIDA2LzE3XSBzY3NpOiB1ZnM6IHVmcy1leHlub3M6IGdldCBzeXNyZWcg
cmVnbWFwIGZvcg0KPiAgIGlvLWNvaGVyZW5jeSIgYW5kIHNxdWFzaCBpdCB0byBQYXRjaDEyDQo+
IC0gUGF0Y2gxMjogVXNlIG1hY3JvIHRvIGF2b2lkIHJhdyB2YWx1ZSB1c2FnZSBhbmQgZGVzY3Jp
YmUgdGhlIHZhbHVlIG9mIE0tUGh5DQo+IHNldHRpbmcNCj4gLSBQYXRjaDEzOiBBZGQgZG1hLWNv
aGVyZW50IHByb3BlcnR5DQo+IC0gUGF0Y2gxNDogVXNlIG1hY3JvIHRvIGF2b2lkIHJhdyB2YWx1
ZSBhbmQgZGVzY3JpYmUgdGhlIHZhbHVlIG9mDQo+IEhDSV9NSF9BTExPV0FCTEVfVFJBTl9PRl9W
SA0KPiANCj4gQ2hhbmdlcyBmcm9tIHYyOg0KPiAtIFNlcGFyYXRlIGR0LWJpbmRpbmcgcGF0Y2hl
cyBvbiB0b3Agb2YNCj4gICBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0NCj4gZGV2aWNl
dHJlZS9ZVU5kcW5aMmtZZWZ4RlVDQHJvYmguYXQua2VybmVsLm9yZy8NCj4gDQo+IENoYW5nZXMg
ZnJvbSB2MToNCj4gLSBDaGFuZ2UgcXVpcmsgbmFtZSBmcm9tIFVGU0hDRF9RVUlSS19TS0lQX0lO
VEVSRkFDRV9DT05GSUdVUkFUSU9ODQo+IHRvDQo+ICAgVUZTSENEX1FVSVJLX1NLSVBfUEhfQ09O
RklHVVJBVElPTg0KPiAtIEFkZCBjb21wYXRpYmxlcyB0byBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvdWZzL3NhbXN1bmcsZXh5bm9zLQ0KPiB1ZnMueWFtbA0KPiAgIG9uIHRvcCBv
ZiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zY3NpLzIwMjAwNjEzMDI0NzA2LjI3OTc1
LTktDQo+IGFsaW0uYWtodGFyQHNhbXN1bmcuY29tLw0KPiANCj4gQ2hhbmhvIFBhcmsgKDE0KToN
Cj4gICBzY3NpOiB1ZnM6IHVmcy1leHlub3M6IGNoYW5nZSBwY2xrIGF2YWlsYWJsZSBtYXggdmFs
dWUNCj4gICBzY3NpOiB1ZnM6IHVmcy1leHlub3M6IHNpbXBsaWZ5IGRydl9kYXRhIHJldHJpZXZh
bA0KPiAgIHNjc2k6IHVmczogdWZzLWV4eW5vczogYWRkIHJlZmNsa291dF9zdG9wIGNvbnRyb2wN
Cj4gICBzY3NpOiB1ZnM6IHVmcy1leHlub3M6IGFkZCBzZXR1cF9jbG9ja3MgY2FsbGJhY2sNCj4g
ICBzY3NpOiB1ZnM6IHVmcy1leHlub3M6IGNvcnJlY3QgdGltZW91dCB2YWx1ZSBzZXR0aW5nIHJl
Z2lzdGVycw0KPiAgIHNjc2k6IHVmczogdWZzLWV4eW5vczogc3VwcG9ydCBjdXN0b20gdmVyc2lv
biBvZiB1ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+ICAgc2NzaTogdWZzOiB1ZnMtZXh5bm9zOiBhZGQg
RVhZTk9TX1VGU19PUFRfU0tJUF9DT05GSUdfUEhZX0FUVFIgb3B0aW9uDQo+ICAgc2NzaTogdWZz
OiB1ZnMtZXh5bm9zOiBmYWN0b3Igb3V0IHByaXYgZGF0YSBpbml0DQo+ICAgc2NzaTogdWZzOiB1
ZnMtZXh5bm9zOiBhZGQgcHJlL3Bvc3RfaGNlX2VuYWJsZSBkcnYgY2FsbGJhY2tzDQo+ICAgc2Nz
aTogdWZzOiB1ZnMtZXh5bm9zOiBzdXBwb3J0IGV4eW5vc2F1dG8gdjkgdWZzIGRyaXZlcg0KPiAg
IGR0LWJpbmRpbmdzOiB1ZnM6IGV4eW5vcy11ZnM6IGFkZCBpby1jb2hlcmVuY3kgcHJvcGVydHkN
Cj4gICBzY3NpOiB1ZnM6IHVmcy1leHlub3M6IG11bHRpLWhvc3QgY29uZmlndXJhdGlvbiBmb3Ig
ZXh5bm9zYXV0bw0KPiAgIHNjc2k6IHVmczogdWZzLWV4eW5vczogaW50cm9kdWNlIGV4eW5vc2F1
dG8gdjkgdmlydHVhbCBob3N0DQo+ICAgZHQtYmluZGluZ3M6IHVmczogZXh5bm9zLXVmczogYWRk
IGV4eW5vc2F1dG92OSBjb21wYXRpYmxlDQo+IA0KPiBqb25nbWluIGplb25nICgyKToNCj4gICBz
Y3NpOiB1ZnM6IGFkZCBxdWlyayB0byBoYW5kbGUgYnJva2VuIFVJQyBjb21tYW5kDQo+ICAgc2Nz
aTogdWZzOiBhZGQgcXVpcmsgdG8gZW5hYmxlIGhvc3QgY29udHJvbGxlciB3aXRob3V0IHBoDQo+
ICAgICBjb25maWd1cmF0aW9uDQo+IA0KPiAgLi4uL2JpbmRpbmdzL3Vmcy9zYW1zdW5nLGV4eW5v
cy11ZnMueWFtbCAgICAgIHwgIDEzICsNCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5j
ICAgICAgICAgICAgICAgICB8IDM1OSArKysrKysrKysrKysrKysrLS0NCj4gIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLWV4eW5vcy5oICAgICAgICAgICAgICAgICB8ICAyNyArLQ0KPiAgZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYyAgICAgICAgICAgICAgICAgICAgIHwgICA2ICsNCj4gIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmggICAgICAgICAgICAgICAgICAgICB8ICAxMiArDQo+ICA1IGZpbGVz
IGNoYW5nZWQsIDM5MSBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+
IDIuMzMuMA0KDQo=
