Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C447C77B6E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Apr 2023 08:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDNIJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjDNIJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2023 04:09:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC8310EA;
        Fri, 14 Apr 2023 01:09:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbFIFt9dnFIL7ECbWxQbOCiAtxFwi/bwC1VTeN48CSxOyLjjyEfi0Kn/91XChLRYkmnqvfUpRh23T6WIY0xIt+0ObYJxkdwjeLyXVHrVaGFnNlR7uBUYnUXf4yfmOAw/NOc2aeqFfnKpYeRIvPdokQlhpGzDdkiE7pE4VQ/IGIYY760RR7CM6YSGmuV7rcoaCtSAK2arP4qsvnBplkjUJaSe7zuVNaaZd5NDZzQem8Gkpbyqc/EtDLzmExYNe6tM+JQ5tTmuLNjoxnMUKbLlkMujHklIDTyGLZNuDVMG6jxH4R/g4nIM1YFj362luumRBRjeoXmjDTxV0jR+U450GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtd/2YxVeIN9ulSNZmjm7dFXvJ59rAKx6E8EOanKEWM=;
 b=lEb/Sg2dzO4jjIpRXbd3Ele+s051YnNgiZwRALzNQGJV4+bCBs6kKtbq8K/0MEzfrMThW8ECLHSvdm3WNS867NVBTpsAchUqKIz6E7VVvgn0zuIdY9m/Ili8lrkGUrULLpii+2aXvBhT/Lvl95mhm15cUTNKKzX/m8brJ3LlgAVBCVq7ZT3pTucuRqVB1J7dmr8/lhwZdcV1GCmQRVxtjrQIhpzcY6EOXz/Mw4YcB0IpMWzYlpfbcDHXYxq51NGKRcRzWE6XxHqF0kcWQXEc5YMjlhTk4SUzzNhp7fssMscIvTnES4rxu3srmEyJxSL78wlPsBr827+3YXvJvVYg0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtd/2YxVeIN9ulSNZmjm7dFXvJ59rAKx6E8EOanKEWM=;
 b=hfE8pdyoZ7j/R004vp+WNZB8t4NjNsaggw/xXVYXb5evC7JN+VwmHcPIJd42barXfWn7/Wmc28MjfPj16TYRuB66nJ+FprALagEI8XIxZrqvrYKFJdg3vKl18SJXvHlaVsZi9We+2oDbEfy6QbEAdKpcHbBiOES+JvKS7M0U/oyZ8wkuoltJ7exDuR3JFtMiO7y8elcNS2gK2q8oK5bhnzcu1V86A7gUNhq5Araf89k627aHB1UD7qE9qSyNMT4gLwfTfCT9PVTTniHdBZNWpklcAY8IwnAF6pqZSw8vLrmzIOyutbdba5Txxcc9PHQefQkiqWjzbiisDke1cPoYHw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7723.namprd12.prod.outlook.com (2603:10b6:208:431::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 08:09:32 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 08:09:32 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: blktests scsi/007 failure
Thread-Topic: blktests scsi/007 failure
Thread-Index: AQHZbqQKKE1vybuJjUOL+PzCC5t1tq8qc5gA
Date:   Fri, 14 Apr 2023 08:09:31 +0000
Message-ID: <06f976f7-84fe-2994-4632-c23aaff568bb@nvidia.com>
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
In-Reply-To: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB7723:EE_
x-ms-office365-filtering-correlation-id: eb5e5714-2bf3-438b-45eb-08db3cbf93a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xHr5C+7+YCbP148rTx6rXvbu53YIAcNIdmJifYCSCoo8pTNt78NorCcGG0ZGfLySxb7Ihwo/hlg8UuHi4/ikttnWkhVSporpVPKmHcv8IArVjXt3IOICvjPfnYD2IFp4bmRDhtxBdgSZsfZOy6FaQcSRPk4DPetIXiI601GKli8z4ZKWLmM6fgmOkwKreYIZ9rOhtc0RJv14jNuE9A2G8QCEphu1Z7m0TAHYeNhCN6L/jmrNy9OlQuqwaEvxelZlBD6y7XdaA7u66fRkNlS7tfewm4m/fhD9/A+2wdsZe8jLeU34ljFMBkf9PJlAoBsTz/QlRlTR9jExui+80oinRrI8WWqc3KujYuk++lZ0UDpu9J6fs+nmxzwPXUu6+w9K4Fludu9mpoht/dIgjom8Wt6SuI5ZIzp4YyW1e9JHzuVuEJ3zG3CjOnq+Mg0IJ8du0FIgy5vjVtwaUadAEi25Q/BgpC4vRCbWr5lKSpa+5Bvy76al35LNYqbz+3s8zu+bYIGSm3a1cvZUcYOGLo0y1akl4TuBBPZmVUe4Q0DUbp1GbOLyhi4S/3vfjyEKrWFZywSPWhDZmUiRXai4r5iJE0nQx/Fnz1XMELR9bUEw23j7uhn3vBxkDvBua9GnUhTsY3bKzJBpXhA444hjGB8U5tCOjaEUdTI5ZE+SzMNXBkv8FXQ04teuYgRJ9d1kBU27
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(53546011)(26005)(31686004)(6512007)(6506007)(186003)(83380400001)(2616005)(71200400001)(6486002)(5660300002)(41300700001)(316002)(8676002)(8936002)(86362001)(38100700002)(38070700005)(122000001)(478600001)(31696002)(66446008)(64756008)(66946007)(76116006)(36756003)(91956017)(66476007)(66556008)(2906002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnFuYW81SXJuL0pkaDJUa2J2VVMyKzNvU2FYQkVISGZJdzN0T3hWbWVBeTNq?=
 =?utf-8?B?bFFoM2dSaW1nL09uV0o0OXpxL2NuZXJ5ZXcxOCs0djBXQktTMS9xcFBJWVdD?=
 =?utf-8?B?NS9oemNSQkhZaEx0K1RWbTZUSCt6cGE4WEwweDRPMzI5RldtL2U2ZkhHaHl3?=
 =?utf-8?B?NVQ2VjRZOVZnQXE0d2VnRkRxRGUvYk80dEJsZ0dyN2dpdnN5MTlyWkt6VXVC?=
 =?utf-8?B?U2dScXBKUFBsQllwdmhWWWtmWHdzWWlzZllLZWVzU3M5cHlOdUwxY1hrdnNE?=
 =?utf-8?B?ODBaQVdzaWlHRDhtM1lEVmhNTFVhT2JLdmlCejRwS2ZTSmxHeWlVMXNUOWZW?=
 =?utf-8?B?aTU5OVBCNWdXemNMb3R2dDVpSjhKYldBUUJqbGtaUFNjYzJNYW13MVhaOThy?=
 =?utf-8?B?UWpjNTFVN1FEdEM4RlZFUkh6eklIai85N05VTzhFMGJtY3dmQ3FLOXc3amhz?=
 =?utf-8?B?ZGJmRkJ2cnZQdW1waXlMM2VGRldyaE4yeER2VmRoWW1pSW5aK3YzVStLaVFU?=
 =?utf-8?B?ZWJFbWwxZE5HeE4wTk9HejBzNHlTL0kxRzJCQzJzanQzQ1ppS0lKOTdpUGhX?=
 =?utf-8?B?WTh5U0Y5c3FNRzBjdzZXQko2akZjNmFHY2hXa0JaaDg1SlRYUm1Gd1RMaHdr?=
 =?utf-8?B?a04wT1N1dU81VEpIUmxZQVVwY2IvWmgxREc4WXpmaUlrdVlBeWlKbFY2QVBV?=
 =?utf-8?B?eVZ3UU9FdkI5WjNad3h0blVTZVNHbzhubm9WYm9qZFgwK3BsZW9URjgyZnVp?=
 =?utf-8?B?ZVllU1RtQTVKT244T2VFTkQveFFIUHZGZjdpbjk4aHJRMzlOb0JpZjA1NkpO?=
 =?utf-8?B?NXBPOG9FcVNuUjVKZVBYcVRMdkhSTFRsN09lZ3hqZ3lMYjBxOG9Td25VOWVL?=
 =?utf-8?B?WHNNVGh4UEx2NWJ1blR5TFJMSUllbXdBU1RuS2xHRWxUcTRsNEkzaCtXY3FX?=
 =?utf-8?B?djQ2WnRGcUhGd050and4NkVGWHJDL0lYc0pGeXlKdk1oNVJFaDg0QkRWWkFj?=
 =?utf-8?B?eGZkekxIa0t2WmFNSDZCZUx6aFB0U2lKaWlGNnpmYTdQanVVMUlzQUhBckFT?=
 =?utf-8?B?RVVZWkZGWkpNVnl0SG1zOFBDRXRPZGNTQjdRbENSM0c5dHkvZnRodEFtM09N?=
 =?utf-8?B?d1lFclp3Ykpya2tlNXF4N0dTZk9qdDdRT1FwT3ZJK1VzQVZ0Vjk5Q3c3R28x?=
 =?utf-8?B?RU0vdWFueERPVUhueHdobU5aaFN1MmNJc1hCRHA5K3kxOS9QbDNiOWszUUJw?=
 =?utf-8?B?Q2xtNW1rZGd0THlJbjUvZ2cvOStDV1FvYzBybVVhNzZJNmR3cC9QbnJMQitq?=
 =?utf-8?B?UWtuSFl6MmxQQ3dwYTRxc0FCaUVzZlZWTjlQWnI3SXV3UWpVeEluaXZJNlB6?=
 =?utf-8?B?d0FDRFI2MW9HRUhUa0RwSjVOWXI5cUx6OU9KOHZGRjlLZHNyVzdnajdvUUpF?=
 =?utf-8?B?eE9ib3BTRGQxR21uS0VEd1dNejlZZ0czWnkxK0RGU0hqVEFhUGw4NlRjOHdu?=
 =?utf-8?B?NDRGQ3hDaHhXbkkwWEFLNTByekppSzFwem9HZnFTUUZtMElPRCtQb1NPK0ZM?=
 =?utf-8?B?L20zTG92Zm5sL1hCR1NPRkdnMUdZcjVvSkJnMFpUemtKeWNPaEZLb0xlSmNM?=
 =?utf-8?B?MGowcTRuYmVnWE9MeDdnVW9kWnVGUFM4ZUk4U0hlREtRc00rNTdCOHlFSTI5?=
 =?utf-8?B?L2cvNXdBZGRDU0hGWjlhYmttYmppSjhMRWpsN3J3OFBTS2lUZEFPcnpTVEsy?=
 =?utf-8?B?UVNmenFtY1F1Tm5xSU9xQWJFQVFnb2UzTXR2S0hQSEhoVjRZdE5FWUNoWVBS?=
 =?utf-8?B?elZFYTRjWnhjR0ZjWnBPaVBZRGc4ZlMyN05qemI3SWs4T2R3OHR4N0d3WWVR?=
 =?utf-8?B?KzVCS1ZtbzU4NG9LYkUyU3QvVFduTFFWY2liSi9CeTVBYWtzbkY4dlNLMFBy?=
 =?utf-8?B?WGZjbWs5cmlGMHl2eVhmS2hTemlQUVFpUlFYdm85K1RqaitWL1FhL1FkWE80?=
 =?utf-8?B?enNtQmVsQ2hrbEpyR1pSdVNkOURkemJPK1dUQ0YvQlZrTjNQbW5vRUNnT013?=
 =?utf-8?B?ekh1ZEhVdUFhaUxzZmRxcWJFRWEwdTJQU0hBQnA5VUpRR0FidUZ5RTc5M3BW?=
 =?utf-8?Q?aS414wuwf14mmXZbVKK69vmZr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B80A1D5D4763441994F18717351067E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb5e5714-2bf3-438b-45eb-08db3cbf93a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 08:09:31.6012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJ9AhOfcYFGct58YIXy/x946XdDzPpItt/JpIOaznfpcbf5CtCN6wwey+R8dmPrJyZNcmFLMHDEmEYP9GLrroQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7723
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNC8yMDIzIDEyOjM2IEFNLCBTaGluJ2ljaGlybyBLYXdhc2FraSB3cm90ZToNCj4gSGVs
bG8gQmFydCwNCj4gDQo+IFJlY2VudGx5LCBJIGJ1aWx0IGEgbmV3IGJsa3Rlc3RzIHRyaWFsIGVu
dmlyb25tZW50IG9uIFFFTVUuIFdpdGggdGhpcw0KPiBlbnZpcm9ubWVudCwgSSBvYnNlcnZlIHNj
c2kvMDA3IGZhaWx1cmUuIEZZSSwgbGV0IG1lIHNoYXJlIGJsa3Rlc3RzIG91dHB1dCBbMV0NCj4g
YW5kIGtlcm5lbCBtZXNzYWdlIFsyXS4NCj4gDQo+IEkgZm91bmQgdGhlIGZhaWx1cmUgZGVwZW5k
cyBvbiBrZXJuZWwgY29uZmlncyBmb3IgZGVidWcgc3VjaCBhcyBLQVNBTi4gV2hlbiBJDQo+IGVu
YWJsZSBLQVNBTiwgdGhlIHRlc3QgY2FzZSBmYWlscy4gV2hlbiBJIGRpc2FibGUgS0FTQU4sIHRo
ZSB0ZXN0IGNhc2UgcGFzc2VzLg0KPiBJdCBsb29rcyB0aGF0IHRoZSBmYWlsdXJlIGRlcGVuZHMg
b24gdGhlIHNsb3cga2VybmVsIChhbmQvb3Igc2xvdyBtYWNoaW5lKS4NCj4gDQo+IFRoZSB0ZXN0
IGNhc2Ugc2V0cyAxIHNlY29uZCB0byB0aGUgYmxvY2sgbGF5ZXIgdGltZW91dCB0byB0cmlnZ2Vy
IHRoZSBTQ1NJIGVycm9yDQo+IGhhbmRsZXIuIEl0IGFsc28gc2V0cyAzIHNlY29uZHMgdG8gc2Nz
aV9kZWJ1ZyBkZWxheSBhc3N1bWluZyB0aGUgZXJyb3IgaGFuZGxlcg0KPiBjb21wbGV0ZXMgYmVm
b3JlIHRoZSAzIHNlY29uZHMuIEZyb20gdGhlIGtlcm5lbCBtZXNzYWdlLCBpdCBsb29rcyB0aGF0
IHRoZSBlcnJvcg0KPiBoYW5kbGVyIHRha2VzIGxvbmdlciB0aGFuIHRoZSAzIHNlY29uZHMgZGVs
YXksIHNvIEkvTyBjb21wbGV0ZXMgYXMgc3VjY2Vzcw0KPiBiZWZvcmUgdGhlIGVycm9yIGhhbmRs
ZXIgY29tcGxldGlvbi4gVGhpcyBJL08gc3VjY2VzcyBpcyBub3QgZXhwZWN0ZWQgdGhlbiB0aGUN
Cj4gdGVzdCBjYXNlIGZhaWxzLiBBcyBhIHRyaWFsLCBJIGV4dGVuZGVkIHRoZSBzY3NpX2RlYnVn
IGRlbGF5IHRpbWUgdG8gMTAgc2Vjb25kcywNCj4gdGhlbiBJIG9ic2VydmVkIHRoZSB0ZXN0IGNh
c2UgcGFzc2VzLg0KPiANCj4gRG8geW91IGV4cGVjdCB0aGUgSS9PIHN1Y2Nlc3MgYnkgc2xvdyBT
Q1NJIGVycm9yIGhhbmRsZXI/IElmIHNvLCB0aGUgdGVzdCBjYXNlDQo+IG5lZWRzIGltcHJvdmVt
ZW50IGJ5IGV4dGVuZGluZyB0aGUgc2NzaV9kZWJ1ZyBkZWxheSB0aW1lLg0KPiANCj4gDQoNCkkg
ZmFjZWQgdGhlIHNhbWUgcHJvYmxlbSwgYnV0IGluY3JlYXNlZCB0aW1lb3V0IGl0IGlzIHBhc3Np
bmcgOi0NCg0KYmxrdGVzdHMgKG1hc3RlcikgIyAuL2NoZWNrIHNjc2kvMDA3IA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzY3NpLzAwNyAoVHJp
Z2dlciANCnRoZSBTQ1NJIGVycm9yIGhhbmRsZXIpICAgICAgICAgICAgICAgICAgICBbZmFpbGVk
XSANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJ1bnRpbWUgICAgLi4u
ICAzOC41MjlzIA0KIA0KICAgICAgICAgICAgICAgICAgICAtLS0gdGVzdHMvc2NzaS8wMDcub3V0
ICAgICAgMjAyMi0wNy0xOCANCjE2OjE0OjM3LjIwNDIzMDIzNCAtMDcwMCANCiAgICAgICAgICAg
ICAgKysrIC9yb290L2Jsa3Rlc3RzL3Jlc3VsdHMvbm9kZXYvc2NzaS8wMDcub3V0LmJhZCANCjIw
MjMtMDQtMTQgMDE6MDM6MjYuNTE4OTkxMzM3IC0wNzAwIA0KQEAgLTEsMyArMSwzIEBAIA0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUnVubmlu
ZyBzY3NpLzAwNyANCiANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtUmVhZGlu
ZyBmcm9tIHNjc2lfZGVidWcgZmFpbGVkIA0KIA0KICAgICAgICAgICAgICAgK1JlYWRpbmcgZnJv
bSBzY3NpX2RlYnVnIHN1Y2NlZWRlZCANCiANClRlc3QgY29tcGxldGUgDQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBibGt0ZXN0cyAobWFzdGVyKSAjIHZp
bSANCnRlc3RzL3Njc2kvMDA3DQogDQogDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgYmxrdGVzdHMgKG1hc3RlcikgIyBnaXQgZGlmZiANCiANCiAgICAgICAgICAgICAgIGRpZmYg
LS1naXQgYS90ZXN0cy9zY3NpLzAwNyBiL3Rlc3RzL3Njc2kvMDA3IA0KIA0KaW5kZXggZTcwODhh
MS4uMWFhM2UwMyAxMDA3NTUgDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIC0tLSANCmEvdGVzdHMvc2NzaS8wMDcgDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKysrIGIvdGVzdHMvc2NzaS8wMDcgDQog
DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBAQCAtNDEsNyArNDEsNyBAQCB0ZXN0KCkg
eyANCiANCiAgICAgICAgICAgICAgICAgICBlY2hvIDEgPiAiL3N5cy9jbGFzcy9ibG9jay8kZGV2
L3F1ZXVlL2lvX3RpbWVvdXQiIA0KIA0KZWNobyAiSS9PIHRpbWVvdXQgPSAkKDwiL3N5cy9jbGFz
cy9ibG9jay8kZGV2L3F1ZXVlL2lvX3RpbWVvdXQiKSIgDQogPj4iJEZVTEwiICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIyBDaGFuZ2UgDQp0aGUgc2Nz
aV9kZWJ1ZyBkZWxheSB0byAzIHNlY29uZHMuIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAtICAgICAgIGRlbGF5X3M9MyANCiANCiAgICAgICAgICAgICAgICArICAgICAgIGRl
bGF5X3M9MTAgDQogDQogICAgICBmcmVxPSQoY29uZmlnX2h6KSANCiANCmpkZWxheT0kKChkZWxh
eV9zICogIiR7ZnJlcX0iKSkgDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGVjaG8gDQoiQ09ORklHX0haPSR7ZnJlcX0gamRlbGF5PSR7amRlbGF5
fSIgPj4iJEZVTEwiIA0KDQoNCmJsa3Rlc3RzIChtYXN0ZXIpICMgLi9jaGVjayBzY3NpLzAwNyAN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2Nz
aS8wMDcgKFRyaWdnZXIgDQp0aGUgU0NTSSBlcnJvciBoYW5kbGVyKSAgICAgICAgICAgICAgICAg
ICAgW3Bhc3NlZF0gDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBydW50
aW1lICAyMS4yNjRzICAuLi4gIDIxLjI2N3MgDQogDQogICAgICAgICAgICAgICAgYmxrdGVzdHMg
KG1hc3RlcikgIyANCiANCmJsa3Rlc3RzIChtYXN0ZXIpICMNCg0KeW91IGNhbiBnaXZlIGl0IGEg
dHJ5IHRvIHNlZSBpZiBpdCBmaXhlcyB0aGUgcHJvYmxlbSAuLg0KDQotY2sNCg0KDQo=
