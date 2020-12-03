Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E52FC63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F6A206A5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgLCMQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 07:16:51 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8698 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgLCMQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 07:16:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606997809; x=1638533809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Axu23fWNj0ETI/Bivy9ygdnWdRJhLx5iRR8Vj9MTlYw=;
  b=X8Du+N0JKIgt4r3L3CSZ/Qy5W151wcubB13R5UHpUlL+LfvHVGdg+Et2
   Qxg5QEl/2AdEJ0SsYQuddlRC6D6V9SRj8iRoxSUKwp381/5lU2qSbgK3X
   MM15VeM0FKvYD3FSLbfIU7WALJ8EkDM4/DmYYtMVcAs2/j1HvCaHK60bF
   nvqvsTHXMmYsceFz062o8RGsz3vk5ZmeiWb2CNBy5xOb5Y2TSeUIrS2ys
   yZRtnavLNSZDC/VWAmidqeXyu4D2NkPGidTOxTBOZR73xvScFbzBo0EDE
   KSDLnjG+EhrrcDwiX32tpn0cERzYyHO1GtIpz0uyr0ZJQ/sXk3irtHBMS
   Q==;
IronPort-SDR: H6FwS33oOXKMmFfI0IycFn/kcO02yoHtPiQX0rCbAPBuFl1vASm87VQE+m/io7HtH507dAFW/m
 /s6CJ+qKjZno2kWp0aedIMrVxWIYreiUty9rHIIUAmQhm0+ippLl3ZW4HQW8JYRiQSHpQqyPj+
 6rGbQFs0qti0N3iw2Q1Vzvs9tlyFcyBgTPLkVD2jwVTupw7zOsJ9k/saLUjBZ8xA/PxyvYf6Tg
 B3Ip4oqHNqktiCxMnpmN/MMpcFGSUNBoOJYqQKgPVE5odWCJbvUnl92zBcAzDSv3O5Asvd+3K7
 c4Q=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="155457089"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 20:15:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFgUL17v2IhG6++PTy8Gay+7blDSviVtO6xLN+pikqt3rd1VWRdBku2fmf6sMxEWaeMqphzoBxhIIdFQdqRrnK+jAyTo9nsvAsZqfA4wm/35x61hz+WTP6QR4LG7fErM0Nq9jRywnHuo2aWg59n7nj2n0DnAEvRoHSb8JItqJ1nVBpA7NpJE0ucsZdy3FrYjwA7wSt22TEGi9xOd781RIDPmiMf9XtH7CxCrRNQqf3wzgsLmdUYwp7bgqT2HeP1ySjtTp97QuOt6zqvtxNEVV4+JXjLa4XqIvuD+uGKmEJx6Px/V8JyWaUflg1QNHJpWEj095OK7B+azXHKX3E91yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Axu23fWNj0ETI/Bivy9ygdnWdRJhLx5iRR8Vj9MTlYw=;
 b=TjlDJ62FJ5ROMKPkoXxHUaGcoy5bMV3olVxpgyZuEAPVKJvUf4DlsYT/9a+e+YZ2jq8s6kBCmjq/qvJx0tb2mNqT0cET90KIMhR28MOja8aG4GaFDAgWtHhLd+s3+FUt6M3rcQG6pVulQ3tD6f41MYOZh0aD1xWvRlL8X7k5xExShICvmDB/NwxjLGEhBaxVN0VbXA5tzGjliff7WfAK/n/tSCizHIj0BUAUoaebvPMdbllIn8TOPjdtbYto4MXwROE3g9zXKYYkSIOsDrKQC4sMf/6+3MOpeTFx1DkhF8uNVPnEHXGq/B4lYpacx4BABZKO0kvnhpp1bLW6KI7U2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Axu23fWNj0ETI/Bivy9ygdnWdRJhLx5iRR8Vj9MTlYw=;
 b=eY1YrpuYURBJVxAV4D27g9xIUgBZG1cdd+mm+9PUDGtO0WmgWOlr3h+bNtPjAApt6g/2UCnHVf6d+04WcTAN1ZUzj7PDaKWYhaJ8XqWj6rioKdc5c8K+oOd3nEcxFPEcLlF/ihrcgUaPmNeyV32H0xqhqyPLB2ofktjDPOI1bq8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1133.namprd04.prod.outlook.com (2603:10b6:3:9f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Thu, 3 Dec 2020 12:15:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.019; Thu, 3 Dec 2020
 12:15:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWx0S43WodiAJh60uyT+kBS7g50qnkYW5wgACaOBCAACZ9AIAADIOggAAWRgCAAAUZQA==
Date:   Thu, 3 Dec 2020 12:15:40 +0000
Message-ID: <DM6PR04MB65750B6EF8B374476E255FA7FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
         <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
         <2dafb87ff450776c0406311bb7e235e9816f6ecf.camel@gmail.com>
         <DM6PR04MB657551290696C7EBD8339328FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
 <2578a5fa2323f46b29dc8808b948ed5eaea6fbca.camel@gmail.com>
In-Reply-To: <2578a5fa2323f46b29dc8808b948ed5eaea6fbca.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16b25726-3c36-432f-dd52-08d89785269f
x-ms-traffictypediagnostic: DM5PR04MB1133:
x-microsoft-antispam-prvs: <DM5PR04MB1133CC0719F30CF69289FDACFCF20@DM5PR04MB1133.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PavJIHTIDzULIQ+V0NBwA02TgeXpI4+nM1C/jkMp6V70fULXWs92rXX0R2tZLbnzTLcWPYsTRzFe5i01K3oait5seSf0uosfjKtr2mMH2xwaV/r9jly+v5F3mLG49IaouuuUje8Cidsy0a8WHMAV3QwqtvwocgZD3SOTcdqoGq5kFD1NWvqNhLsHn5HYRX4U7O4xHG9nkq+mzISok9eADyFSAWrJ1jEEnoEmP7Gxcsb9lO+RFOF3lheI62RXrPe62BCZzvBHcRx3cTdmL+wFJNyh9x+vyetl5XsSjCb6MUShxYuKh2ej1EDCN0jEMiC3gHHVADTOGk6uZYIUG0IXgUxax2u76nJoRgxBNfDckvi5ixB3ljtUFVqU8x06v0YW+50KGPYtKW6L1GSIXSyAasIgOBZ6KiDhDOqhLgmjDUg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(7696005)(7416002)(33656002)(921005)(86362001)(2906002)(71200400001)(8936002)(110136005)(54906003)(316002)(4326008)(8676002)(478600001)(76116006)(66946007)(52536014)(64756008)(66446008)(66476007)(66556008)(5660300002)(9686003)(83380400001)(55016002)(26005)(6506007)(186003)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cWxvVW51ajJBOFFNV1RzTjV1MGFUc1VRNEZLd09HZlBBdmpSOTc1NGpYd09m?=
 =?utf-8?B?ZWtqSGRqMTlOdXhSeWhjTG9iNmJoZzZDT2RZRlVaek5MdmY0L0ZGQWdTZFNM?=
 =?utf-8?B?aFN0UitYbjl2bkcydnNia3RwRUVpWlB3UmVKdkNHdS8zOU43S3JLeXBjUk5T?=
 =?utf-8?B?RzZUTDhGcEs0UHBaTm9Kem1wbUlhanRPUHhHMGYvUnJwRkVPRXRsVWk3MHlF?=
 =?utf-8?B?THhUMnBPcFZhOG9lS3NxRGU3VkVsYThSeWtySlo4YlhPdjdPUjdBOFFDWStK?=
 =?utf-8?B?NUdCbW9qQncyNGpwVitZdys4RWxnL1I3eXZERUs1Nys3dTJlWlRnZFBqRGZ1?=
 =?utf-8?B?aThTWE9SWTNjK1RVVVpWc1JndUxJOERTM1hDSWV5OXhqMzdkd0NrODNLcEdl?=
 =?utf-8?B?cG9ORzJIMW9XRWhsWmZjUWN2aXBvYm5NWjhCM2FZRDFzYjloSzlsTlg1dDFT?=
 =?utf-8?B?WERTVU5uaTEzOFk2WlVzQ0JoVXc5TkR3VG1PNnE4TTZuQnlLd25ia3lEM2ky?=
 =?utf-8?B?R0MvNGxmbVZYZEdFTDEvTVlubVRyL0VhcU83OUYwWHM0RWpra0h1OXoxcnpz?=
 =?utf-8?B?azhXdTNiZlNDT3FzcVNrNC9vK2FzSWtMY3lNT25RckNpQlZxbnhrcGNaMUVp?=
 =?utf-8?B?eS92NW5CMUlNZjkyc2RXQ1pKb2UwR0UzdDVrbVBoeHhkVHZhYlU4WUVhRVFR?=
 =?utf-8?B?T3YyYS9vYzM4TjRQOVg2L0RSVVpaWnVEcVRBVFdxckpSUmhxK2kwQkFuSnJu?=
 =?utf-8?B?dXdDR0p1b2tNbTVRUFhrMjF0UnBCdzVLd1NEV1VlSklNS2o0cGZtVjVUZTFz?=
 =?utf-8?B?dFFBKytrcTdlbElFUmNEeFA1MXhyMHBidlBXWUNNaVU2aUZFVDVQcGxwRkhm?=
 =?utf-8?B?ZlhYTzZINW4wMG4rZzdsOG5takhSWUJJWkt1aDJ5aXFpQWEyUWlsUUFMam83?=
 =?utf-8?B?ZC82aG0vVU5rRFpReGx4SGZ5K2JEUzVFdUNSMDBIWU8yZS9KTVRRUHNJSWhV?=
 =?utf-8?B?aldNYVk2VHpENW9RL2czaHEvM01BV1JWL09Fa3ZuWDloWnM5ZXl3WFdEaXN1?=
 =?utf-8?B?NVhOVHNWWFpsdWhmZXV6L0JjbzUrZE5DZmVaZ3p6TUw3ZWtSOENlc1M5V2JG?=
 =?utf-8?B?KzdENmUyWCszRW1YU1NVSWxZYnBmUWJIR0NiZkxLNnlhK3J6Y0xuM1FFS3Ny?=
 =?utf-8?B?VkVWSWtpNGkyUkhGckdnSFpOZUtVd0JxcW5NT2NtQUU1WXJONmlSd0w0dzVl?=
 =?utf-8?B?NStFZHBnVktPQUZMaFI4czZ4RElKTVYyMXFlbytpVFZGZ1RrYW44RVE4a0gz?=
 =?utf-8?Q?c6/vF8jeXmP2s=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b25726-3c36-432f-dd52-08d89785269f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 12:15:40.6554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KZ/+cnb/9bAqUXlo2BxesCiOSOoq8KMJZjL5xGoIhV+n27ffK0+ReCcO0U9EjMxidh3PNURsMUo4rlTEnrkJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiBUaHUsIDIwMjAtMTItMDMgYXQgMTA6NDYgKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+ID4gPiA+IEZyb206IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiBLZWVwIGRldmljZSBwb3dlciBtb2RlIGFzIGFjdGl2ZSBwb3dlciBtb2RlIGFu
ZCBWQ0Mgc3VwcGx5IG9ubHkNCj4gPiA+ID4gPiBpZg0KPiA+ID4gPiA+IGZXcml0ZUJvb3N0ZXJC
dWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSBzZXR0aW5nIDEgaXMNCj4gPiA+ID4gPiBzdWNjZXNz
ZnVsLg0KPiA+ID4NCj4gPiA+IEhpIEF2cmkNCj4gPiA+IFRoYW5rcyBzbyBtdWNoIHRha2luZyB0
aW1lIHJlaWV3Lg0KPiA+ID4NCj4gPiA+ID4gV2h5IHdvdWxkIGl0IGZhaWw/DQo+ID4gPg0KPiA+
ID4gRHVyaW5nIHRoZSByZWxpYWJpbGl0eSB0ZXN0aW5nIGluIGhhcnNoIGVudmlyb25tZW50cywg
c3VjaCBhczoNCj4gPiA+IEVNUyB0ZXN0aW5nLCBpbiB0aGUgaGlnaC9sb3ctdGVtcGVyYXR1cmUg
ZW52aXJvbm1lbnQuIFRoZSBzeXN0ZW0NCj4gPiA+IHdvdWxkDQo+ID4gPiByZWJvb3QgaXRzZWxm
LCB0aGVyZSB3aWxsIGJlIHByb2dyYW1taW5nIGZhaWx1cmUgdmVyeSBsaWtlbHkuDQo+ID4gPiBJ
ZiB3ZSBhc3N1bWUgZmFpbHVyZSB3aWxsIG5ldmVyIGhpdCwgd2h5IHdlIGNhcHR1cmUgaXRzIHJl
c3VsdA0KPiA+ID4gZm9sbG93aW5nIHdpdGggZGV2X2VycigpLiBJZiB5b3Uga2VlcCB1c2luZyB5
b3VyIHBob25lIGluIGEgaGFyc2gNCj4gPiA+IGVudmlyb25tZW50LCB5b3Ugd2lsbCBzZWUgdGhp
cyBwcmludCBtZXNzYWdlLg0KPiA+ID4NCj4gPiA+IE9mIGNvdXJzZSwgaW4gYSBub3JtYWwgZW52
aXJvbm1lbnQsIHRoZSBjaGFuY2Ugb2YgZmFpbHVyZSBsaWtlcyB5b3UNCj4gPiA+IHRvDQo+ID4g
PiB3aW4gYSBsb3R0ZXJ5LCBidXQgdGhlIHBvc3NpYmlsaXR5IHN0aWxsIGV4aXN0cy4NCj4gPg0K
PiA+IEV4YWN0bHkuDQo+IA0KPiBzbywgeW91IGFncmVlIHRoZSBwb3NzaWJsaXR5IG9mIGZhaWx1
cmUgIGV4aXN0cy4NCkkgd2FzIG1vcmUgcmVsYXRpbmcgdG8gdGhlIGxvdHRlcnkgcGFydC4NCg0K
PiANCj4gPiBIZW5jZSB3ZSBuZWVkLW5vdCBhbnkgZXh0cmEgbG9naWMgcHJvdGVjdGluZyBkZXZp
Y2UgbWFuYWdlbWVudA0KPiA+IGNvbW1hbmQgZmFpbHVyZXMuDQo+IA0KPiB3aGF0IGV4dHJhIGxv
Z2ljPw0KPiANCj4gPg0KPiA+IGlmIHJlYWRpbmcgdGhlIGNvbmZpZ3VyYXRpb24gcGFzcyBjb3Jy
ZWN0bHksIGFuZCBVRlNIQ0RfQ0FQX1dCX0VOIGlzDQo+ID4gc2V0LA0KPiANCj4gDQo+IFVGU0hD
RF9DQVBfV0JfRU4gc2V0IGlzIERSQU0gbGV2ZWwuIHN0aWxsIGluIHRoZSBjYWNoZS4NCj4gDQo+
ID4gb25lIHNob3VsZCBleHBlY3QgdGhhdCBhbnkgb3RoZXIgZnVuY3Rpb25hbGl0eSB3b3VsZCB3
b3JrLg0KPiA+DQo+IE5vLCAgVGhlIHByb2dyYW1taW5nIHdpbGwgY29uc3VtZSBtb3JlIHBvd2Vy
IHRoYW4gcmVhZGluZywgdGhlDQo+IGxhdGVyIHNldHRpbmcgd2lsbCBtb3JlIHBvc3NiaWxlIGZh
aWwgdGhhbiByZWFkaW5nLg0KPiANCj4gPiBPdGhlcndpc2UsIGFueSBub24tc3RhbmRhcmQgYmVo
YXZpb3Igc2hvdWxkIGJlIGFkZGVkIHdpdGggYSBxdWlyay4NCj4gPg0KPiANCj4gTk8sIHRoaXMg
aXMgbm90IHdoYXQgaXMgc3RhbmRhcmQgb3Igbm9uLXN0YW5kYXJkLiBUaGlzIGlzIGluZGVwZW5k
ZW50DQo+IG9mIFVGUyBkZXZpY2UvY29udHJvbGxlci4gSXQgaXMgYSBzb2Z0d2FyZSBkZXNpZ24u
IElNTywgd2UgZGlkbid0IGRlYWwNCj4gd2l0aCBwcm9ncmFtbWluZyBzdGF0dXMgdGhhdCBpcyBh
IHBvdGVudGlhbCBidWcuIElmIGhhdmluZyB0byBpbXBvc2UgdG8NCj4gYSBjb21wb25lbnQsIGRv
IHlvdSB0aGluayBzaG91bGQgYmUgY29udHJvbGxlciBvciBkZXZpY2U/IEluc3RlYWQgb2YNCj4g
YWRkaW4gYSBxdWlyaywgSSBwcmVmZXIgZHJvcHBpbmcgdGhpcyBwYXRjaC4NCkl0IHNlZW1zIHlv
dSBhcmUgYWRkaW5nIHNvbWUgc3BlY2lhbCB0cmVhdG1lbnQgaW4gY2FzZSBzb21lIGRldmljZSBt
YW5hZ2VtZW50IGNvbW1hbmQgZmFpbGVkLA0KQSB2YW5pc2hpbmdseSB1bmxpa2VseSBldmVudCBi
dXQgYSBvbmUgdGhhdCBoYXMgc2lnbmlmaWNhbnQgaW1wYWN0IG92ZXIgcG93ZXIgY29uc3VtcHRp
b24uDQpJZiBhIGRldmljZSBpcyBub3QgcmVzcG9uZGluZyBwcm9wZXJseSB0byBzb21lIHNwZWNp
ZmljIGRldmljZSBtYW5hZ2VtZW50IGNvbW1hbmQsDQpJdCBzaG91bGQgYmUgdHJlYXRlZCBhY2Nv
cmRpbmdseS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiANCj4gDQo+IA0KPiA+IFRoYW5rcywN
Cj4gPiBBdnJpDQo+ID4gPg0KPiA+ID4NCj4gPiA+ID4gU2luY2UgVUZTSENEX0NBUF9XQl9FTiBp
cyB0b2dnbGVkIG9mZiBvbiB1ZnNoY2Rfd2JfcHJvYmUgSWYgdGhlDQo+ID4gPiA+IGRldmljZSBk
b2Vzbid0IHN1cHBvcnQgd2IsDQo+ID4gPiA+IFRoZSBjaGVjayB1ZnNoY2RfaXNfd2JfYWxsb3dl
ZCBzaG91bGQgc3VmZmljZSwgaXNuJ3QgaXQ/DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gTm8sIFVG
U0hDRF9DQVBfV0JfRU4gb25seSB0ZWxscyB1cyBpZiB0aGUgcGxhdGZvcm0gc3VwcG9ydHMgV0Is
DQo+ID4gPiBkb2Vzbid0IHRlbGwgdXMgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRHVyaW5nSGli
ZXJuYXRlIHN0YXR1cy4NCj4gPiA+DQo+ID4gPiBUaGFua3MsDQo+ID4gPiBCZWFuDQoNCg==
