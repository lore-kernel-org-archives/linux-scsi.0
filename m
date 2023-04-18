Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9402C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjDRUP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDRUP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:15:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA98D7A88;
        Tue, 18 Apr 2023 13:15:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayXLmhf0NVXC5boka6q9SN47ZopKX1hsDpQkbZX0VAFIB4uXbTQ4ATC/TIOiqA4Yri7/9ZV4XF+arQQASQvgoabV3XXVw/mJuEuJ2sC51GrvMEMPOp19x7dvJUgf7n+FLL1bEkS/UTLye7zPBBcC60ybgTyw0KEK0m7RpHE8z9/HLp48Ze1UGbl/82V76hgzmzX5kDmilAyR3z9894LgrYLQGMR04G1BOS+tDc9MntGRA7h/k87iw3ko2fh+0ZvTaxbqX3ZS0C8m7t4NbfQSY0xJNWK+V5sVGszpwE/I9H4+wfwhUIwgs2b7KaemoWbise9ITCZYnbbWZPaJpZN/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4d7JdIVEyaYQHLQjx6l6URLKPhxwKcTEDGT2lKCLLEo=;
 b=TH7GmhF9Q2mW9P5ObT9C/Xy/0dBnLREpSoJoTqHqZn974BOQB8UlQJ8sLH7KHa1c5ViaqOBvrQ1Pc3ZEY338lfeDt5smiqPdmRLBgkWYwvYI5BkaGe11+RBcFH5RFYaK2oWeonk7loSF4nW3YCxP/lIh+4dIElSdekAKyyCnqAQ9bkHsYp7aAGqiGIyvjaA6V/aOH2iq+uLcZBWZjXtOtaVbtRfWj8VI1mxXcV+PBNhGkPrxM8ILmDnKiIhUR94x0QNP51MCSC8tWMRjNempMQFQ75C4blsvPyztLbSbnEGGv6OsiacoidWsOowfU6/n0rBJaJnThn89VBq6EHTsvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4d7JdIVEyaYQHLQjx6l6URLKPhxwKcTEDGT2lKCLLEo=;
 b=DmDaM1l3J7zWQnoS1RwhsKgzS6phlycruD+um+cZd0lYSHul2WhOT1PljcSaothaTpx+L61PPf+LFE07YflYKq0rdW6KxfaR9dn+c5jIW5i9tI7JC1O7A7UZrf5IH5n93EvPIGeWf8MyTxod0cpno2LEcHa+bmwZ61oPobh1QSncs83VUnaKdnba8eylp+qDYy+HHYWJGFTIF643UJXhTwf6of57gm60MZBUxlB4bioyZEn0qyaASxdaf2OszhRqY2CswORzVO98hQoZIjkFbFZnRKBsyQuoNKr/gy3jfwoSUT+RNmZe0W1mSPbxzVl9X7il1yqHy+jxFUoQHr2MlQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 20:15:20 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:15:20 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 4/9] common/scsi_debug: introduce
 _configure_scsi_debug
Thread-Topic: [PATCH blktests 4/9] common/scsi_debug: introduce
 _configure_scsi_debug
Thread-Index: AQHZcSrp6svwvn2Hkk+qNEPirYSHXK8xgqkA
Date:   Tue, 18 Apr 2023 20:15:20 +0000
Message-ID: <10817e6f-3b62-288f-5931-a167743e32b4@nvidia.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
 <20230417124728.458630-5-shinichiro@fastmail.com>
In-Reply-To: <20230417124728.458630-5-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DS0PR12MB8561:EE_
x-ms-office365-filtering-correlation-id: 12167897-39bc-40c7-3878-08db4049a268
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: elbA3fuD8p3SSus73b0DKsDkp6LsGy7YUiqjsutUFojosS9sJT9ZeMaL0nzroBAah4pKDkccNMYRH/v+bo9RoUQNbIwwklUaFHHDiNRxIy+aGhG3vFu8oJtCx0sV/8674EACdidg/f8kyMXK5p1jkOCLsOk+3WmXkpWRqP/0FZ9PjO9r6DJiJNCc8QM2kuH0VWl+Tp6zlG9CMr4VHXap8rpiB0GXou5LXFGHrW3hgzHQj3z5JPn+o87G3OizgpnRZLoEe0DQcDTHznxMNEMhWgaOGimzvcUe3PzWPPniZncXAd1xNEb3jAP2lfmlUQOa/PB++HcNc9UPNk0w0CkHRTOGe/9T7Tt1EZP9DU5C4GdaTjOQX/9A2IT//muErXi2I+blIswTLyAQ1qC2WrbPvIN7rE0bt445IXRga4d4omZfpgWKIl0byVtg7DDgVT9Y6K2B0G8Y+2ZJaznugqDo6NHb+zgPFJXYxYrRHVj2FITMSLBcMGk3PaYhHx3Dm9ut7wTb8ZTgzVFd6/nyY8KhoZAQJVMJJ3KvAI/nh/WiXFkXcql++eCfJspvb89wjjs4X6N0ywWPd1EPcdibB4MUNpglZvB9HjvINB3MSNHSyHSu3ZxtXip1H4LdnTPjqjgw0jeQTWSInMmGTEQ0/MKCxO+HlNenCX3WPiZBK2Cuc8qjUNv69rOo4kTDiwk4Sjne
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(31686004)(316002)(110136005)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(91956017)(4326008)(36756003)(186003)(53546011)(6506007)(6512007)(122000001)(38100700002)(2616005)(83380400001)(31696002)(41300700001)(8676002)(5660300002)(8936002)(478600001)(6486002)(71200400001)(2906002)(86362001)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVoyOHZxYXhaVXN2TG51ZHlEYjczQTNTRHhYN0hNYmFxZEdjTFIvcG9weWRt?=
 =?utf-8?B?M0lWT3Nod1doU0Mvbm5haXNZb2hSMlZMd3E4OENVUk5ZVGJKVktMQUZzZVNQ?=
 =?utf-8?B?M0JFbXprRFd1VVVJSnRRR2VtclduKytwRll4aTVrbHFkVXE4Y3hKdUFNZFJn?=
 =?utf-8?B?TVBpZTYxMU11dDVaTkFGUWtoeTc4Tm53WFdnTlhNb055SEQyaWpJOVVnQVJW?=
 =?utf-8?B?MHp2NUgrRUJITGFYMnFsSHdkL0I0UHpuVnlrb3BVMnZrNUhLdUVzdnBTelRI?=
 =?utf-8?B?OGZJdFgyVmJjaGorKzdkNUJQWjVpUzFTdjlyelR4WEZ5R2JXYmlkUjcrcFdP?=
 =?utf-8?B?Y1d5ZTJzQXpWUFhsaWVnNW5SQkV1N0ZpUVo1Z011b3FDU2crRFFreHdJaGc0?=
 =?utf-8?B?TjZNRXVJZGlwUWNxTDZSb0ZyTU5GcDZab2IrbGZTdkNNSzdMbFlDNDhXMDIw?=
 =?utf-8?B?eVo0d0lGcUtxQ21nL2ZMM0R4OElaazJUdU9Pci9GdmlVMkkyMVV1UmtwbUdU?=
 =?utf-8?B?Y1psQUZqVnRLT3BnRGlxTU5PNjlqVTBLdGpxRnpHd3Q4cGRNU2FjRlh5Y3lO?=
 =?utf-8?B?ZWNRUGhaMmdTWDVKR21pbDBnYWgxY2M2YmRwY3Q5YmpmbDI4R1ltTWlkZnR6?=
 =?utf-8?B?bGpZQ1Z1UFdyOU9NdmYxTDd6OUdhSGw4UVJTdWtPeFhrei9BNVNqV0FlKzhj?=
 =?utf-8?B?WXM3TU5VZTBNaFVGakFBeFc2bUk2YWd0NzFLZDkwVTlBdi83Q3NrQlFuT2FQ?=
 =?utf-8?B?cHI5T29FcUxIVkxSK1RKSUI3QmdpcXNUNTR4WitqT0F0VStFb3prRU9sdTA2?=
 =?utf-8?B?Y1J1amFVVGVmZ0EwQW9tRG5SVWp5a2c1VytDU0xRWnB6K0xLTzE1M0hDdUlU?=
 =?utf-8?B?L1JwbzQvZ3NrOWxsdC9DdzJBTHAxeGI4UFB3eXhNOUdidldnYXhlbktMMENq?=
 =?utf-8?B?cFVtYnp1bENkNzVGeGViRFZsN0JNZldSeHVJc3g4bjNGZE44bmRoeDNNTEhk?=
 =?utf-8?B?U09oL3dwMjJQWGVoSFVLZ1FtRUJHaEJOVnVDSDN5eFRadTZjSEUzZ3dFNmxJ?=
 =?utf-8?B?N2ZwV0plQjZFU0FXRmJYdmJzVzlSVy9QM1lGOFRmUnB1R3NnWUdYWnJSZXQz?=
 =?utf-8?B?eGFZTy91dXZES2Z6dER5YjVybmE5dk5yR1EwaU16Zk9wWnZIUnp2RmdwNnN3?=
 =?utf-8?B?d1k2MGxDTEtmSVNnbTV6MHR4VTU2bGdJNFk0TlBTOGtEUE9NNklob3lYVnUv?=
 =?utf-8?B?MjlSeCtVSzNzTzZTQ3pxN0NKTjdEc0sxdkNMQ1R4d2o2b2w4dVBFeXh2eE9y?=
 =?utf-8?B?VFdTZFpHcTZPUmhIbzFhK2FJdEtFZy9IbGNCQ0JUOGFwZXRpSG13OUR4cWRB?=
 =?utf-8?B?Z291L2k5Vm5VOVdvWld6YnVjOVlCNHY5WStKM1p3L1FVY0xOR2RMYmxscW0z?=
 =?utf-8?B?d0tQb21GM1o1OGdBL09Tam1mN29CUUd2eEVWRkRjL2VBMkRJNkVhNUJmYzZI?=
 =?utf-8?B?L3pwdkJRU2l3TFJMK0N4T0hWSFdmWVc1TSt3U2tnbktHMndWUUJFMmp0T05o?=
 =?utf-8?B?NWdFbUtML0FZWGp1YURkOXg0NTF5d0ViclBHdG9vMWhoZC9oUVJDR1l0YUVs?=
 =?utf-8?B?ejRMMmZzSmVLYnBwWUpocEljQy9RanhNL3pLOStzbzFKL2hsNGxOTmRwVnky?=
 =?utf-8?B?alU5cmxwYTlDL0tTRHRTM2c5YytkcXEvNHBja1M3citUeitIWjVUOTVZTlJk?=
 =?utf-8?B?T3pia2N1MDFzN054WldvNzFCZ3VOdGJkcXpZNXR3Nk5TS0NzWHVUQnFhdDE1?=
 =?utf-8?B?TlVJQnJKQ0ZqK0ZJZTlPem0xSU43RjUyajhkMTFxM042YWJ4Ty9RZWU4Qmp1?=
 =?utf-8?B?YkVCdDZEWjdEcHpEejFOc1Fjb0N0OXFaYUw3WjVCaUdyZ3pOdk0zQThDRVk2?=
 =?utf-8?B?cSsyRmVFajE1SWxWYVNoc1N0ZXdiQ1FBRXlFaURDbGZKNHdMYUd0cVhSU2xw?=
 =?utf-8?B?OWlkMmpBT3lCYjhNc3pEMFpGWHREZmVpUlFBRWNNUUtMdUlQQVBYSVp5Qi90?=
 =?utf-8?B?TElpVlBSRXpFamJLUDZGbGd0WTVqUWI0Q3JUMytGRTFxandEL0toNkxwdTFR?=
 =?utf-8?B?UW5LbEY4UHFtWHR3Wk9BeU9FeHlCZ3pqWG1YekJkREp3SGdkZUs3Y3E5MFYx?=
 =?utf-8?Q?TJcGeq+QwdXBH26mxg4o6ehnuc4Fr6Ptl+uIjveM+beE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BFC9AB2202B534BB13D548A276EC240@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12167897-39bc-40c7-3878-08db4049a268
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:15:20.4531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4PKtliXWZze1kJ9ZwyhGNPtHfg+E/7WEmsctLMcwPVufbRTCXzMKkSzfVH6bGnt5xu0PNF5wLdWIFZQdBjgDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo0NywgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFRv
IHNldCB1cCBzY3NpX2RlYnVnIGRldmljZXMgd2l0aCBidWlsdC1pbiBzY3NpX2RlYnVnIG1vZHVs
ZSwgaW50cm9kdWNlDQo+IGEgbmV3IGhlbHBlciBmdW5jdGlvbiBfY29uZmlndXJlX3Njc2lfZGVi
dWcuIEl0IHdvcmtzIGluIHNpbWlsYXIgbWFubmVyDQo+IGFzIF9pbml0X3Njc2lfZGVidWcgd2hp
Y2ggc2V0cyB1cCBzY3NpX2RlYnVnIGRldmljZXMgd2l0aCBsb2FkYWJsZQ0KPiBzY3NpX2RlYnVn
IG1vZHVsZS4NCj4NCj4gX2NvbmZpZ3VyZV9zY3NpX2RlYnVnIHRha2VzIHBhcmFtZXRlcnMgb2Yg
c2NzaV9kZWJ1ZyBkZXZpY2VzIGluIGZvcm1hdA0KPiBvZiAna2V5PXZhbHVlJyBhcyBpdHMgYXJn
dW1lbnRzLiBJdCBjYWxscyBhbm90aGVyIG5ldyBoZWxwZXIgZnVuY3Rpb24NCj4gX3Njc2lfZGVi
dWdfa2V5X3BhdGggdG8gc2VhcmNoIHN5c2ZzIGZpbGVzIGNvcnJlc3BvbmRpbmcgdG8gdGhlIGtl
eXMgaW4NCj4gL3N5cy9idXMvcHNldWRvL2RyaXZlcnMvc2NzaV9kZWJ1ZyBvciAvc3lzL21vZHVs
ZS9zY3NpX2RlYnVnL3BhcmFtZXRlcnMuDQo+IFdoZW4gaXQgZmluZHMgdGhlIGZpbGUsIGl0IHdy
aXRlcyB0aGUgdmFsdWUgdG8gdGhlIGZpbGUuIFRoZSBvcmlnaW5hbA0KPiB2YWx1ZXMgb2YgdGhl
IGZpbGVzIGFyZSBrZXB0IGluIHRoZSBnbG9iYWwgYXJyYXkgU0NTSV9ERUJVR19WQUxVRVMgYW5k
DQo+IHJlc3RvcmVkIGJ5IF9leGl0X3Njc2lfZGVidWcuDQo+DQo+IEFtb25nIHRoZSBwYXJhbWV0
ZXJzLCAnYWRkX2hvc3QnIGhhcyBzcGVjaWFsIG1lYW5pbmcgdG8gYWRkIG5ldyBob3N0cy4NCj4g
VGhlbiBpdCBpcyBoYW5kbGVkIHNlcGFyYXRlbHkgc28gdGhhdCBpdCBpcyBzZXQgYXQgbGFzdCBp
bg0KPiBfY29uZmlndXJlX3Njc2lfZGVidWcsIGFuZCByZXN0b3JlZCBhdCBmaXJzdCBpbiBfZXhp
dF9zY3NpX2RlYnVnLiBBbHNvLA0KPiByZWNvcmQgdGhlIGhvc3RzIHdoaWNoIGV4aXN0IGJlZm9y
ZSBfY29uZmlndXJlX3Njc2lfZGVidWcgaW4gdGhlIGFycmF5DQo+IE9SSUdfU0NTSV9ERUJVR19I
T1NUUy4gVGhvc2UgaG9zdHMgc2hvdWxkIG5vdCBiZSB1c2VkIGZvciB0ZXN0aW5nLCB0aGVuDQo+
IGRvIG5vdCBhZGQgdGhlbSB0byBTQ1NJX0RFQlVHX0hPU1RTLg0KPg0KPiBTaWduZWQtb2ZmLWJ5
OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29tPg0KPiAt
LS0NCj4gICANCg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGth
cm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
