Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0627DC77B78
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjDRUK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDRUK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:10:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8170C6A44;
        Tue, 18 Apr 2023 13:10:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6Tb7I4wyCaK4eK5Vr3poBrF5YD4AHGHDHuWoVN7ZBIEI/zpocC6euYdrgy5YdNQJ0wbLutQv2bzn4d9tO8SA20RziqDtR0tXHulZnXoqqBKUeO804MXVnDgS55A7kTrCrnWzgTq+y6ei5E+4I7h7Da7BflJ+oBxPe57G1vGtQ1trskoB3JDsRPfXsF6V1EXnRYv9wVyyIpCmDl0nWRL1ABrffNcgq/6yA0Mo6mRgMkWnc4FVOsfieI6T85MXKMTZRHS2oRnfqtr5FQyjEc0sOSP/ieF0AdJV1tciEZasAoE59sc7Gy2EpoIA7om3XoBIA6vjYOxfEuRY7aM74f76g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/da7Ar0SqGhhuHdfzS2oh6Dtu+Syn+Ycg5hSiNRmI9c=;
 b=TrIlgOlJn3oE6OSaBNSy6wGjlPsyfE6ymiQbp0FR9tgbqasVtk+WQ5K3gIchGQSmD03MOcDkRmozpewsCKBBQ4PD+YBDtKRBQbgfcozBnMrVGU+xmr+vlM3e0Wc6oPVt6dFlhQPkVfxvYXbCgeXLdiq5lUuQWZyBhvSHoVGARoQRy+2YZ+oLHr1AUB/1LFhe68z+zbwdQP5tBybmptg7pPgKQpJbZeczyfUYvcveAcE5Lp+uv+CXoNwn+WVL2Hz03/Miy+xgVALN/KsKE0ZIdQj0Toa8c8wxv9+liUwGWUcdzUy0NKnKr1KX9xJGYuxAxtGkloQqoGGqiQRV12dVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/da7Ar0SqGhhuHdfzS2oh6Dtu+Syn+Ycg5hSiNRmI9c=;
 b=nutCAMWDQNJXvaNoH3SCv3mz+QQqqF44uooslfV9f0Kwf8F4SiPVJEaAVmNnSVc3+r3iMpiM4dqeSFsLochdHM6ZbiKv6y1tchrsBcAIaxAagzp5cNJN2p53J+qElyZUH1n1hCjtI8N14IfYUcfF/GPF8tNEl64DLyFEAJCNkw3uRfnKqciYHHViBDYMQiGH53ajYTqMA5r7PeO0ydiT2wAHzaYwLhQVzqqkblWPH8tyTJtQ4mH6KyXyoPOcZdRl9ZM7XK4yiWNL6gQUqPxdVjAI3jpLKx2LB8UkymLVqKh8iAeBLYgvHcmWuoiQJzWVSd0unavYU3uOzCb4tJTbSw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY8PR12MB8337.namprd12.prod.outlook.com (2603:10b6:930:7d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 20:10:53 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:10:53 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 2/9] common/scsi_debug, tests/*: re-define
 _have_scsi_debug
Thread-Topic: [PATCH blktests 2/9] common/scsi_debug, tests/*: re-define
 _have_scsi_debug
Thread-Index: AQHZcSroUEVFsu1OLEaqu7Cjn5L5/q8xgWuA
Date:   Tue, 18 Apr 2023 20:10:53 +0000
Message-ID: <d4201ec4-a2d5-2ae3-db86-be3437cfc7ff@nvidia.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
 <20230417124728.458630-3-shinichiro@fastmail.com>
In-Reply-To: <20230417124728.458630-3-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CY8PR12MB8337:EE_
x-ms-office365-filtering-correlation-id: fd84aecd-75e7-4a47-af75-08db40490345
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ba/9umn30aoAXGApOoNMUq1/gbVMryhpVtPZptTq8cSDskfoOdNkT7cucvdgRBzM7Qidd9ojgpp9av0G1wR4xSE+L3+C81prTj/dU7OLIAZoIB9cRa+7K7Cg/e9TtM7hBi/YfOyiNMuMSRUlhGtYdvmtbsGh5xQyuUz4ihfh+p7T0V0lNWgstXGFT13KnDw96YY7PjAH5YM1jaVVvecHN1hwkoOyR2HblaleiHWuGM1oDShMb8F0tl0uzhq27M/zTt2AVqug0kPPRe6a5sJHxzPCsIgKlq91QAcZEDUUXu+ReaDgXMfZj/KEUc9jR+va0qcgYgrgpssuE1y+I7161pa95+ml7AT54ssx8Qal4MejHNjW4EEJdCDPTH23C3qByAQ8JAgA6NHQ3BZ8G5Zv0OUfLjCpN4+mNb1HtlAhGmWbRYNt4gohfE/UWhRGHC40P/FPrNL6gZsi2dmO2US5hi4DRElZACrd9Lf8Y51pJ6Z05xPQOGjmR0zzZevFv5f7FKlFGBfXxgnzuFs3eB09C/pnXuTP0Z4irOQ5wGiJISo1IOawd+rPy2EVVoQsYWzGFEVHyhMK5IVP4xwMjvOBVRFbdRXikU3WhVOPLjoy5nJGd0HD0vAyuGb6vwi8H/P6mUtGz6q0bVKE/CQ3UIqxT5NRMqDRxEzToVPnnKdBHQNgABTtKJd26o29M+nKEYm/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(86362001)(186003)(31696002)(2616005)(31686004)(6512007)(6506007)(53546011)(38070700005)(36756003)(2906002)(4744005)(6486002)(71200400001)(5660300002)(478600001)(8936002)(4326008)(316002)(110136005)(66946007)(8676002)(76116006)(66476007)(122000001)(66446008)(64756008)(66556008)(38100700002)(41300700001)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUVvVE1xRmg1d1p5aVZyOFJZbnRRTDdSYWtkeU96RkdsM2FqRW5LMXRqQVhG?=
 =?utf-8?B?bE9rcldhME1OOVRPaG5FNUdhVy81WmdYREQxdDFGeGdOcEpwbVgzZjllSWxm?=
 =?utf-8?B?b0RNS3RGVUF2YkpGa3dSTjZrUUpDdUMvQm16VDFNU2dhc0FpdVR4bWVhQ09L?=
 =?utf-8?B?UUQyWFNvQjFkc3Z2MlErQzdKRktpYUtTamdVc2RnL2l6NHo5QkRVSlY4Nnd4?=
 =?utf-8?B?OEwwWHdZTTNyWlB6RmdWWGpCNU9PZGNITEY0QmlKcGpmMXR1TjYwTUN6ZE9j?=
 =?utf-8?B?dTV0QlVoaHpTdlZIWllmR09VR3F3V1g3STFvVU1WUndVOGZta2JMN1dIeHBu?=
 =?utf-8?B?NFpMcHB6bHN6Qm45am9SMzFZdUJGYSs5T3NITm1IdlJoRXl1cHVidW9nTjU4?=
 =?utf-8?B?SitZS1dqNGFxdUJtSERGbFFiLzNEa3grUmVLcGt6a1BlUnpXS05YZXZMV0J0?=
 =?utf-8?B?WTFHczZWRkVEdU12ZGFsYmZtOGNUZzRpWTVaenNHcCt3bzF3WXo5NjIxVHli?=
 =?utf-8?B?bTBLMklDcnVzUjlvL1BFUDZOc1FoNFF4UjZEbFFwbmV4R2Nyc3dBWldHcU82?=
 =?utf-8?B?ZUxyQVZ6bHZrV3pJNlpBSnFrWWkrSE04SE04SjJBd3lEV1B2ZnR3UHFscXp5?=
 =?utf-8?B?aXB4NlB3UnJSTlkyOHpkRXIwNUZCcFdHcEt1alJ6cU5QbTI5Mm1uV1hocTRu?=
 =?utf-8?B?dm9GMHhmTWJOUUZ6RitGNitJNkdXZjNJcjNCc1BCa1ZDUm5kd25uV2IvL2s2?=
 =?utf-8?B?aXBEQUVnR09MZldWOGpWUURrUVcvK0Z1MWdIdHQzNDAyUDA1VTRqOWcrQXBG?=
 =?utf-8?B?ZEpQTmZDbGU4WVJpdWwwUUhNNTg2NUVhWG1qb3J0M0daUXFlcFdldTRyakJy?=
 =?utf-8?B?dk1xZm5JNThrd1F0U1pFSXVlZElMT2xBU0J6RzFHdHFjS3g4OUV5SFQxS3FF?=
 =?utf-8?B?Snp6eFFndVdSZWI4UGFzTTFiZ3RzZ2hqdkhSNUV1WWovc0VPU08rZXpnRjBz?=
 =?utf-8?B?eTRZS1BSSFJLS1JCUTlDY1lXYkxHSEwxd01iVTk4c08wemNDdU5QWkM5UTZD?=
 =?utf-8?B?dkhMdS9hTGJwbDdQV3NWTk85RUxVcm5xcUFOeGNKdmdpcGtCKzMyRWN2ZGxH?=
 =?utf-8?B?Q01DRm9vVnJTV2h4MXhvamZzeHhNejBGR0Q3MW9ITytXdjVxNkc3bHN4Wnpj?=
 =?utf-8?B?VWRKMll4dWNPcFpxc2JRZXhtVk5PNTZNMTJvdnZKdG5yWXRzT2FZL2FCMEI0?=
 =?utf-8?B?ck9VbmZuRUpGNTVnUjB4L1pkaTFxVUJ4akpLUUFoSzJkeUJLZ0xVNTdSanZs?=
 =?utf-8?B?TnA4alJiZ2o4Nkx6azlyYnJIY29VcDQ2aE4zdWIxNnZ5bnA2RHFPLyt5aWF0?=
 =?utf-8?B?QjNkOENpSk04d0g2OXVsazNhb1JPZVQ0TjdkNEtsWkxMT1pUQ1puWWlkNjJN?=
 =?utf-8?B?VXlvaytMSkpXdG85YjVNb1NPdGlJMWZTQTdiQUpYNDhaV3pJejFCK0hNbUl2?=
 =?utf-8?B?QXNOUlBBNHdlUE1SUFdzWGo1RlJjUlJUQVdsTFRKNFpuSWRWREY4S2NDZkor?=
 =?utf-8?B?Y2F4YVFtaUtheUhnQXU0RFA3STV3NjVCeXlTaTdoZGplaFlvcGdwbTFRVTQ2?=
 =?utf-8?B?ZTM2aHBVVFR1eVlFMm5WcU96bHRGdGxCYXkvZVRTcTI1K3JyL0l3UjN1YjVz?=
 =?utf-8?B?bDZUU3lJaHRTcTEvbHpmeVhRUnA4TVByR29udEh5OXU3d3NiSFhXSzRRNmFL?=
 =?utf-8?B?Tm5WUk9XVG9TTWpRV1VsdWMra2N6Q2gwYXBzVHBvZ0UrWXk3NXFBM20zSWU0?=
 =?utf-8?B?WVVCZ0FudlF2UWNaV1M3Qyt0ajA1Q0J6bERrcVJMSDZSdURlZUswdWxmVlpj?=
 =?utf-8?B?cnZzVDFUL3lZKzBRYlRoOTBQUnNHbStqS2ZjUXR4eHJZdE84K0UxaFpWUUpE?=
 =?utf-8?B?alBrajVLaXAvZkplcHlUdG53MlRjcTdSU08vbVE0WVJoMWdVU1lVSjFWSWp2?=
 =?utf-8?B?NFk5Z2pDcmI5RVFETXFQMFRnWE8wcEt4a3RZbk9VQ2xHTlhmN0xwblJ2K3JS?=
 =?utf-8?B?MVM4TnpZdWs2TmZadEEwN2pRWUpQNXRMZXhxSDRJaVRTOTVxbjVhQ3hKSEJO?=
 =?utf-8?B?UzFjMytSTDdpTGZsYUpzSmVnVndicGRtdWorTi92bmsrRVlYU1IxYmV6WURC?=
 =?utf-8?Q?Emc0vghjUKKQ/d/3yIdbrnh1iKYiN49KbyIMpyiI/3d1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B33EE9860264D40A3586BB43AB2B332@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd84aecd-75e7-4a47-af75-08db40490345
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:10:53.4694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTV9ZdH7kAJmZyaPvBg4kbAmCUoZaVmmfzH502r5vEaYfx4znAi7psj+2Ha0DNG2utZATqVu8zzvAAg3xE6CpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8337
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo0NywgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IEFz
IGEgcHJlcGFyYXRpb24gdG8gYWRhcHQgdGVzdCBjYXNlcyB0byBidWlsdC1pbiBzY3NpX2RlYnVn
IG1vZHVsZSwgcmUtDQo+IGRlZmluZSB0aGUgX2hhdmVfc2NzaV9kZWJ1ZyBmdW5jdGlvbi4gSXQg
Y2hlY2tzIHRoYXQgdGhlIHNjc2lfZGVidWcNCj4gbW9kdWxlIGlzIGJ1aWx0IGFzIGEgbG9hZGFi
bGUgbW9kdWxlLiBNb2RpZnkgaXQgdG8gY2hlY2sgdGhhdCB0aGUNCj4gc2NzaV9kZWJ1ZyBtb2R1
bGUgaXMgYXZhaWxhYmxlIGFzIGJ1aWx0LWluIG1vZHVsZSBvciBsb2FkYWJsZSBtb2R1bGUuDQo+
DQo+IEFsc28gcmVwbGFjZSBhbGwgX2hhdmVfc2NzaV9kZWJ1ZyBjYWxscyBpbiB0ZXN0IGNhc2Vz
IHdpdGgNCj4gIl9oYXZlX21vZHVsZSBzY3NpX2RlYnVnIiBzbyB0aGF0IHRoZSBjaGFuZ2Ugb2Yg
X2hhdmVfc2NzaV9kZWJ1ZyBkbyBub3QNCj4gYWZmZWN0IHRoZSB0ZXN0IGNhc2VzLiBGb2xsb3dp
bmcgY29tbWl0cyB3aWxsIG1vZGlmeSB0aGVtIHRvIGNhbGwNCj4gX2hhdmVfc2NzaV9kZWJ1Zywg
b25seSBmb3IgdGVzdCBjYXNlcyByZWFkeSB0byBydW4gd2l0aCBidWlsdC1pbg0KPiBzY3NpX2Rl
YnVnLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGly
by5rYXdhc2FraUB3ZGMuY29tPg0KPiAtLS0NCj4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQt
Ynk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
