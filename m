Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD43AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9931261157
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbhINGkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:40:23 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:7930 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhINGkX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631601546; x=1663137546;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=b0S2vcdWVKe/gqKjs0HEbFfcs33UpbyJPetua/rHSao=;
  b=oDgVMymclJPhB7vJkJAcqU8d3q+uht4x6yUG+B3qpyBhw4VixZzY+7fu
   vP231OnIex80y87YLD6ON/n01HVVAqzImbb6VmhGQibno+1s82Q+6OKQS
   lXHlFy35G3DQ7t09Bv6iRFU/T+lscld925dMkMWTW2aQV4TzuAfAq79Ax
   uZSKxF1x+dYo/3or/QpPsP/VZ4XYQ8EObkvjIGpAIYGp5UHvxP+qtUDzL
   EJ4ej/lsmcGUUSTEXEy0ao99E/NNyMpo2LjeKXhftiKtItSfLEiN6POtb
   PdaCElgCzaiocRpuMJxG9ZyXXOVDzgeaaz9ObCWdk8uyzgKxTDrSBKMCv
   A==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="179022750"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2021 14:39:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofJ0TJQ5PAD/ehvKxAZuFf9pA8vOuuAkIw+BFNN1cki+E2a1LGKA0WxBTFFUlYumnb9y8r/AiXHzh4/9YHQLP0oWzdPJN1VNAh77/YL5d1Cb1IAKiMznxYDuZvPNN32Ggm0aexLKefmZfTjkWM/WZhAgeMDKfmYmdlLO0361sVSzhexnQIejVOZ8b59XPuq/0J84s0M88QB/1bHcHfuwDOW2tmhXyCyCZownuLbBsMvlr2UpsWJw2g/wKoz1oi+Wks+7B+EUARppBWFhcpCf8+9XwN1jZ0FJTh2cs/KaoeJx5txdoT4pb3+8VoNTWnP13OLeTllTBufAFa+DAH9ghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=b0S2vcdWVKe/gqKjs0HEbFfcs33UpbyJPetua/rHSao=;
 b=lCDlosG8rcEokcIy8fxTOCDxqg2/NVsjMXiR8nrkJ8+oQDw6ygx5yl70xUqKLIX5lut6r/o3h4+lZqrwV8rHQHGXT9OGFoxPX9YWJMkN0h1+1d4qPE8ZX5ihhsia2YDUtAkCW2zQWEl2NxDPELptSxMyum5XTjmxwIN8ndHgn870qcBH20BuoHIcsxv0YeWOnx0rYDUpIW7tPotpOWGs0U9LYHNTezEWLoo7+73i7gnw0vlsgO2+pUQkRmBxnKKx0qk7r0+22mJ8IglqAl6XcUyFQtAlvD+lDWgiwxLDVIy/7Profix+f+OaWwqYUB1sNpuTR5UxLPNT7+dsxjSXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0S2vcdWVKe/gqKjs0HEbFfcs33UpbyJPetua/rHSao=;
 b=RH4y7iEvpOeKJTBiW2h7JL6VNqh1T9x9lnZvGXn+WLDMkDJ6M2tGi4EqG40egd4G+qOMdEHgC82ZWOVhQyLQzIVnJi3llKfodV9lOjqSorF/FiZ9p+GpSnQ1y+ocMblduZTFCP4guIgphpIbnElonbfvTPaKW+tW1mIO3lx/x7U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0413.namprd04.prod.outlook.com (2603:10b6:3:a7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.15; Tue, 14 Sep 2021 06:39:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 06:39:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: Question about ufs_bsg
Thread-Topic: Question about ufs_bsg
Thread-Index: AdepKfDft4+mL617SwWrELRDClUMdwACBMwg
Date:   Tue, 14 Sep 2021 06:39:00 +0000
Message-ID: <DM6PR04MB657564DA7CCE9220453DD6F8FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279@epcas2p1.samsung.com>
 <000001d7a92d$a0edcb00$e2c96100$@samsung.com>
In-Reply-To: <000001d7a92d$a0edcb00$e2c96100$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0466b71a-c71c-4bdc-9649-08d9774a5652
x-ms-traffictypediagnostic: DM5PR04MB0413:
x-microsoft-antispam-prvs: <DM5PR04MB0413287FACBB43E3FB7655AFFCDA9@DM5PR04MB0413.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aIp5FxyTIeUYIoGzX1/eIbvhmNAtci8peNo8CnD/HAsw2SKcBkH/0jh3dWn91U/jhw+Z5n8CQnLc4Ut7PmHKqhn7DuFN2izgnzLMRM9D+XKCjP0Ud/TM09esHYjCAbJlgwzM+3Nvn6IhlBe+b18rYrsTs/JTuvy9DQhoUl5haMQ1WTw2U4CKH5SePjl6wf/SBfpwvSd5DvVKiSwAeiyvVlCaRFGeYORbUvfA25kCW7TPo5komRQAZOc7EXjG5Rh9yBd9JC2/lqpBNuI2+tZ4wbzRte/gBFWVdxNu77DN6aaJ3GWy+Ox5XDg3J0mvF/hqeIDLxRnyBlBPJBWwdWikNVsaIiMp0TAQdrxXtN5cqqztLXPY7j+Nwa47qWaKKQHCzpAshNFmWXk5LlZ1OwzSv1oMkTa9JBnV0+9uRe95BrfTo6bjN3Hn32LRjdybBHI1JYaWRp5evTW/J9hcgSoyqvuQMFgiraE9vyAnWxBYhWiPxLWc4KxKpUj9lAoG6CN75QCjutRF2+vPCsxXI3B/XKPdvdTVHvMwBPSztdol1sLhS7YPssO1lcX6xXW/DKX9185Er9s1Dgje1PXmi5w44cmivgV13mc+66cidapeSUBqeY1yz5rBlc9y80BQiHgSPvxpUA/uBJxb4vOvypsQlCG8q36Y//w1LcOugmi8f1f0vpVS9WBRnpkQkZXcSx/ppe3RkkKic4DD31YW3lLzNLcMPEDiWgVhdGZVRU2IkfY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(9686003)(66446008)(186003)(478600001)(6506007)(7116003)(83380400001)(52536014)(2906002)(66556008)(66946007)(33656002)(55016002)(38070700005)(66476007)(921005)(76116006)(38100700002)(71200400001)(316002)(110136005)(122000001)(7696005)(8936002)(7416002)(64756008)(8676002)(26005)(86362001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3VJZGtTUVljNmxnMHQ4OXpRUE1XakN4YUUrZyszeEp1dmNlc1J5aWgvQm83?=
 =?utf-8?B?dzhMcStXaFlDbGJwWUhVWHFEdWw4Rm45V2VxbXV4S00zOFBHby9qY2o1UVVa?=
 =?utf-8?B?QkhFb2pCYUJxK1VTVzQ5MTlTZkJTbDhDdkJ6OHduTzJKN1U3d093L2p1Mk1i?=
 =?utf-8?B?aWhtSjJUV3orNVZVWlBHa3dMd0F1MkRCWFV1SVlsYXAyTXJxNzB0THZ3YkFE?=
 =?utf-8?B?YUdJeHIyRFFaVW9yeUhUQ3NZWEh0Z0I3Y0NtWnd0THRvNlhXeFdHeFQ5MFdo?=
 =?utf-8?B?dDh0c2VXdHlXN1gwZ2tLeXZNU1Y5RmNYdjkvVmJ0aWdsN3YzUDlGTDlIVkxS?=
 =?utf-8?B?aGJmeTdrU0g4VXJESmRJRnUvVTY5MUVoUzJydVhDQmtTQlkrak5sTDE1Mjl1?=
 =?utf-8?B?WStqSTJTYWYrZGRlb2VHT1l4SlNNbGt6QzNObG9RWDNGRUhmbi9rR3hGNVNp?=
 =?utf-8?B?TU1RTGVORDcyS3kvLzlCNzVLR1RaOURkbit0eG10UUhDdmJnck5oSGdlY09S?=
 =?utf-8?B?eGN2V1YvaEtIR011WTk0YzdLamR1Q1Qybk4ydC9vVkxKRzhJSUdkaHdRMjFw?=
 =?utf-8?B?eXNpMVQrSHpSSWRJOGh0MTRIWkpCbmtuV3hEQ1ZQL0Y5QnNjamZqWkJmMlRt?=
 =?utf-8?B?K1IxekJzU0tSRHlNUmcveFBjSDhBUUF3N2o4d2VIREF6TlF4QnpndEFmTW9L?=
 =?utf-8?B?cXNRUW9adEhwY3NkUWc5NlJNMXZYVmVsS3NvRk5SelZxN1VRenFvblVTRkhp?=
 =?utf-8?B?ZlRTaEp6SmhySHVxM0ZObUlKL1ZuaXBDVVEvTGNhbGpqNXB2cFpkQzg3enhx?=
 =?utf-8?B?MjFaODByNEhqV3FWZmVjOERVUzhObmx6Q0lNb0FVSGI3aE82cHlBbUZ0SG92?=
 =?utf-8?B?b0tXbGtnMit3TFc2RmZrbkVvTnpGWWdxVHdCQ21PRENUb3ZVaTZEWXVxNG5p?=
 =?utf-8?B?c3VmeERUVlBsZ0I3Yk1xbkFHSnh1Tzg0UzhhZ0hMMFBQczRxRjVIRjBDNWlD?=
 =?utf-8?B?bVc2R3YzNnkrNjNnaVdFdHZvQkpYZWJTYVBMVEIxb3p4OExaMGE2dVdDQ0JU?=
 =?utf-8?B?ZW1XeHhRU1lOb05SdUZlWmFoYVJaTkliTzBwY1ptVjlwTGJYd2EwUmJLcVFP?=
 =?utf-8?B?dndlOTFJdHdEZkZVVWlweUN2VUZnaEVZV25lb2tLSyt3SUpFRDFPeCsxRmZZ?=
 =?utf-8?B?bXBGM21uVEtueEJKWU0xR1NYOFBVVE9tR2ZWUCs3dUV1UnI1bFpmRnY0ZXJ1?=
 =?utf-8?B?eWt6NWFjM1FhaDdweTVmOFByY0orUTBKekkydVpST0owbk53NXA2bmw4Qldt?=
 =?utf-8?B?Y2hJTjBDOXhqc2c4WGovdGV4WkQ4YWRkU25hMTkyT1pna1YyRVZzZ0t1VzB5?=
 =?utf-8?B?S1diQStDT3YvZ1A5RDlIZ0hqS3Jzd25Vd0pyckxGalhxMXhwUVFVVHMwRHM0?=
 =?utf-8?B?T290NU1JeUIzdnRpZ1FCazdjTVI4ZU1ISnQ1M3lwQVV1WThEb1JXYVlrZVZj?=
 =?utf-8?B?d0plRW03am5hWnBEb1pnMnFxZm5PODFsNTNoazlDcWw1RjZuazdHaHZXZTZh?=
 =?utf-8?B?MXRrSkNjSnJwS3RVV2tqY0l2enFkd3REbkEvdmYwSjZvWWhwTzVRRUY1MEJ4?=
 =?utf-8?B?UERzTXhlQ0VaYW1md1FKM01IaVhjUUhFc1lkc0ZiTUFFbFNnR0g0Qlp0U29l?=
 =?utf-8?B?WWU5eitXN3JmeWh2dkw1blVFR2krWFFqeHBvbWJGR2dxSzMwQkQ4SUx5MFNC?=
 =?utf-8?Q?wZ2ZBfrWjJkccy7iS5luAMkVznaBt95gw9NuhRh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0466b71a-c71c-4bdc-9649-08d9774a5652
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 06:39:00.7899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQcb3DnGjnagLb0UvNFtTv97TmpgKj8NUvja+i6mZDZGvwu1J9VhYikkoM2d8iguEEx8Rt0wBqbQHvxFo9is8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0413
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCj4gSGksDQo+IA0KPiB1ZnNfYnNnIHdhcyBpbnRyb2R1Y2VkIG5lYXJseSB0aHJlZSB5
ZWFycyBhZ28gYW5kIGl0IGFsbG9jYXRlcyBpdHMgb3duIHJlcXVlc3QNCj4gcXVldWUuDQo+IEkg
ZmFjZWQgYSBzeXRtcG9tIHdpdGggdGhpcyBhbmQgd2FudCB0byBhc2sgc29tZXRoaW5nIGFib3V0
IGl0Lg0KPiANCj4gVGhhdCBpcywgc29tZXRpbWVzIHF1ZXVlIGRlcHRoIGZvciB1ZnMgaXMgbGlt
aXRlZCB0byBoYWxmIG9mIHRoZSBpdHMgbWF4aW11bQ0KPiB2YWx1ZQ0KPiBldmVuIGluIGEgc2l0
dWF0aW9uIHdpdGggbWFueSBJTyByZXF1ZXN0cyBmcm9tIGZpbGVzeXN0ZW0uDQpUaGlzIGlzIGlu
dGVyZXN0aW5nIGluZGVlZC4gQmVmb3JlIGdvaW5nIGZ1cnRoZXIgd2l0aCBpbnZlc3RpZ2F0aW5n
IHRoaXMsDQpDb3VsZCB5b3Ugc2hhcmUgc29tZSBtb3JlIGRldGFpbHMgb24geW91ciBzZXR1cDoN
ClRoZSBic2cgbm9kZSBpdCBjcmVhdGVzIHdhcyBvcmlnaW5hbGx5IG1lYW50IHRvIGNvbnZleSBh
IHNpbmdsZSBxdWVyeSByZXF1ZXN0IHZpYSBTR19JTyBpb2N0bCwNCldoaWNoIGlzIGJsb2NraW5n
Lg0KIC0gSG93IGRvIHlvdSBjcmVhdGUgbWFueSBJTyByZXF1ZXN0cyBxdWV1ZWluZyBvbiB0aGF0
IHJlcXVlc3QgcXVldWU/DQogLSBjb21tYW5kIHVwaXUgaXMgbm90IGltcGxlbWVudGVkLCBhcmUg
YWxsIHRob3NlIElPcyBhcmUgcXVlcnkgcmVxdWVzdHM/DQoNClRoYW5rcywNCkF2cmkNCg0KPiBJ
dCB0dXJuZWQgb3V0IHRoYXQgaXQgb25seSBvY2N1cnMgd2hlbiBhIHF1ZXJ5IGlzIGJlaW5nIHBy
b2Nlc3NlZCBhdCB0aGUgc2FtZQ0KPiB0aW1lLg0KPiBSZWdhcmRpbmcgbXkgdHJhY2luZywgd2hl
biB0aGUgcXVlcnkgcHJvY2VzcyBzdGFydHMsIHVzZXJzIGZvciB0aGUgaGN0eCB0aGF0DQo+IHJl
cHJlc2VudHMNCj4gYSB1ZnMgaG9zdCBpbmNyZWFzZSB0byB0d28gYW5kIHdpdGggdGhpcywgc29t
ZSBwYXRoZXMgY2FsbGluZyAnaGN0eF9tYXlfcXVldWUnDQo+IGZ1bmN0aW9uIGluIGJsay1tcSBz
ZWVtcyB0byB0aHJvdHRsZSBkaXNwYXRjaGVzLCB0ZWNobmljYWxseSB3aXRoIDE2IGJlY2F1c2Ug
dGhlDQo+IG51bWJlciBvZg0KPiB1ZnMgc2xvdHMgKDMyIGluIG15IGNhc2UpIGlzIGRpdmlkZW5k
IGJ5IHR3byAodXNlcnMpLg0KPiANCj4gSSBmb3VuZCB0aGF0IGl0IGhhcHBlbmVkIHdoZW4gYSBx
dWVyeSBmb3Igd3JpdGUgYm9vc3RlciBpcyBwcm9jZXNzZWQNCj4gYmVjYXVzZSB3cml0ZSBib29z
dGVyIG9ubHkgdHVybnMgb24gaW4gc29tZSBjb25kaXRpb25zIGluIG15IGJhc2UgdGhhdCBpcw0K
PiBkaWZmZXJlbnQNCj4gZnJvbSBrZXJuZWwgbWFpbmxpbmUuIEJ1dCB3aGVuIGFuIGV4Y2VwdGlv
bmFsIGV2ZW50IG9yIG90aGVycyB0aGF0IGNvdWxkIGxlYWQNCj4gdG8gYSBxdWVyeSBvY2N1cnMs
DQo+IGl0IGNhbiBoYXBwZW4gZXZlbiBpbiBtYWlubGluZS4NCj4gDQo+IEkgdGhpbmsgdGhlIHRo
cm90dGxpbmcgaXMgYSBsaXR0bGUgYml0IGV4Y2Vzc2l2ZSwNCj4gc28gdGhlIHF1ZXN0aW9uOiBp
cyB0aGVyZSBhbnkgd2F5IHRvIGFzc2lnbiBxdWV1ZSBkZXB0aCBwZXIgdXNlciBvbiBhbg0KPiBh
c3ltbWV0cmljIGJhc2lzPw0KPiANCj4gVGhhbmtzLg0KPiBLaXdvb25nIEtpbQ0KPiANCg0K
