Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB272C07545
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 05:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjJXFza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 01:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjJXFz3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 01:55:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B383E1A4;
        Mon, 23 Oct 2023 22:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UK5wceSd7UrEJrIXnpWKUKzaD/tppYpRVpoUUGaxfyi3/kSVxXNqQPzcQj5URMYFJRtwyZQoSaCTyOlcQFywIjgH6MJ1kPEy2UShld5IM8yV4BjcMfMWRnaqaM8UPTI3Zw20eJ3BFtMs44EZHK2loXlqXl0WiLpzSxX8bQDky/83P4i0fkzjv+X3bmSAScCMSv4v2Tm/1VjUpPqHnyXvpuJ3dPPPFXtDpl46tc0YsaOpmjMGCbGmHefh7T0FAuLIUC8WDPFFpfdH0ykCuKi22JmCEf6No5TgfpIp0FiPb/MwAdzrSq1wqoXxeZtRy3ZkyVsB7XoB9YB9DCY80xQpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dlnq2W2pOTp2Jk0ml4474544ZbDV0hjqi0hBYGvqBHM=;
 b=XYd+OJnTDbplQnuR95/EPvr4ovg8c8I8rctPgcpLbh7+RDY52DK2+6sy29EnRwA/Anba92aOx7NVqQuOFtC/4mQBTKVVTCT2SZHdcaw3/jSEpFVefrpXCpb5oV9bYerzsS4ibPWSQZhkUgUu979aI2qMn2KfG5C2s1Qed2UhtkASYfUE0mMbxceZ2+ZAmuk4evI9YG3qnHodLrZ20D3fSy2bwp2sAP9nKSGC1mEunvsbPQvCBx3nbQbrWNtPGAmJcNks8AMhxwXNikRAdlTxsxFoWTC/+s4aIS13w/MwFQ69ZJV3yxRKJ0dtDZsHt4hbR/KnTVB1YroZKKG5JD84zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dlnq2W2pOTp2Jk0ml4474544ZbDV0hjqi0hBYGvqBHM=;
 b=tsjr4r5wPwmxEHb1ybOGw88f+IliLJhcj2FIbJm5FB3tXxHyXdw6+m9w9wvCeB2hf4NyHoPz2sEsXmqdW+JYpXuHmwlOCQISVJGxc257r7IKrqxPryfIBhctewRqfcHKOHCXhdUi1zJltjr9kTkaAlA1vPVytrb9dGlTbSrLJZb0uPIQnVirNeBaPsAmFaDBvx7AFWmG1bdpVAilc/V4ktpImJjCl2ozb+SfUveVa1xaJFl+pswrVkwQFzt03xUHkobS+m++VbR+J2TI/lGPx0IDJFJkHGfpo/JVVV1cl7zbx7WhtSCcQZSuHJkC2ar7+g4ggWx/EfaXKfZtCfJcyQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by PH0PR12MB8049.namprd12.prod.outlook.com (2603:10b6:510:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Tue, 24 Oct
 2023 05:55:23 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::af95:93e7:d27a:15ee]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::af95:93e7:d27a:15ee%7]) with mapi id 15.20.6907.025; Tue, 24 Oct 2023
 05:55:22 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Daniel Wagner <dwagner@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: blktests: running nvme and srp tests with real RDMA hardware
Thread-Topic: blktests: running nvme and srp tests with real RDMA hardware
Thread-Index: AQHaBiYWTin4xWkZxkKsvv5vKBqfkbBYbaaAgAADZwA=
Date:   Tue, 24 Oct 2023 05:55:22 +0000
Message-ID: <4bdf4031-5f14-4cb1-92d3-7ae106a4a73f@nvidia.com>
References: <vaijnbobhxyz4nkk2csv3nfhnpeupbudakcn3qgmo7o6vii4x5@rfnfdll6iloo>
 <ce187671-ea90-4d97-b323-70f275c09649@suse.de>
In-Reply-To: <ce187671-ea90-4d97-b323-70f275c09649@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|PH0PR12MB8049:EE_
x-ms-office365-filtering-correlation-id: 445d5b51-0b93-4786-20c2-08dbd455cfa2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GqI2Rv3tQN0F4zr6kqeP5gK6ye8SpD7Ke4iQ5zW2383qwRhZSJuSLzY+dVq37kCN/x8UGFyqia733JComgMjbjBt2HQoxPPRd011xd7HzR74wxl17PfARRcGOTYcQGQFTsO3LOUNrwpxKmTi3WpsjhxgkjZzYqsNFWxLYPjj+uT3/jqrAnU3y0g5iOABYF7icIS32JXhbDWAp0tD5UJXTFMgEn1Hpm1xxZ2k1X/J+stus3+VVN1xLJl/wVDc1OMkKhsAbLWa72j1lp02zC6OXOxHEiYThhPuuNKvWZw/aSjNUWFoOYgDAKDeT9uaeO5RyavSZ/Rpi5npd2FJzZ1Xw2ILmsT6VEKIORdH9zuQJLETAdfVV29yzthTsN1T0XSWovGwJ6KcJvOV49u7N7RtglWtNwwsZn8ClbJ/k+zamYuvxLXPo+oKZeDIIzsrXAeQy7ayM6CkZ1BGXWBUBLiUNJRcBuXGWbjawQVLzAQbGpdFVJqTrborb4YlRwdq/5ODn3F2wj1dmfA6lVi1uLJRK2/snPUZj7KTJ52cLX1LRW3m0kNOsfNxj/EyTpqK3fmP9E43RwR8TvgW/jA/nOpxO596vSkhb7TqBMtb3n0V2hyMQh751lF3Ml8UsX2fOvu5glBeuQ6ojY0p8OgpkjsMg8S/rnpLGhK0rxVh0aHXwIN71mNZHd5KhjFUsT1I8tOtSxoU5KU9zHyCjTCLcQVXPta+2pNU6Zu+oLLH1lvG+5k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(366004)(396003)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(38070700009)(31686004)(38100700002)(2906002)(41300700001)(86362001)(5660300002)(31696002)(36756003)(4326008)(8676002)(8936002)(478600001)(2616005)(66556008)(6506007)(71200400001)(91956017)(316002)(64756008)(122000001)(54906003)(76116006)(110136005)(66446008)(66476007)(66946007)(83380400001)(966005)(6486002)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGx4azYwTUxIRjA5Q2hCUGFVKzM5eXViZEw5dmtFekR3Ykh5MXluM1dON2Uz?=
 =?utf-8?B?STRwa0t6cXgvcXpkaElsdzh2UzV1N2dCM05kOW1JVERNSmVqamJGaGYxUGcz?=
 =?utf-8?B?S09ZVlRaeE1IcGZlVUFPV0pvVlRJOWFRRkgzZG5CdUl4MStZamVoQ0ptb3lo?=
 =?utf-8?B?eE0wYldoTWY3eEh5cFRZK1VBYVFiSmpabjE1VDlNMlRabTN5VkNrU25QV25T?=
 =?utf-8?B?ZUQ0VG11T3ZtUVAxMnVObEpUNi9BTjZmbit2ZXRuUHFHQVMzNkRmd2pabEZM?=
 =?utf-8?B?RHlIMlQzMjk0SlRPMXJ1YTBkNktvb3pZT1phVExRbTV3VnlnRjd4RzBCOTZ6?=
 =?utf-8?B?WDlad1BieXB2a3RYTmlEeUZodzl0eUUzc3V5cGFQUGZCWmQwcWwrV3o4eFRL?=
 =?utf-8?B?WGlVL0xjQkJubXRVSkJmN1JjZlg5bE4xelpmWnJPTmNPL0hBbTdkZzFvTFJ3?=
 =?utf-8?B?UlgwUHREbm1uMldJL3JmcHZpbXVTdlZldHp0eFUwZjV6RWNocjZjN3JYRUUy?=
 =?utf-8?B?dnltN1lkbGdTNXlDNUJLQ29tUXpKdyttR3pDQVFXS1ZQeHRyUWN5OUlSTmxE?=
 =?utf-8?B?ZjIvMjFPSDF4OGM4YW84RzhpMC9nRWxocnpoQjNZSExzNkt2TFhnUEs2M2U1?=
 =?utf-8?B?U3NhbWUrVnNuUWtkK2o3OWlqei9DazgvOXhDNEdsVG1yR3l6a25MRC92V1Fx?=
 =?utf-8?B?VnNycEdIZGtJSEdLRFF4SDlDLzVhQ2dKcE90NVV0U2liOG9kVzlNQ0tSMXVh?=
 =?utf-8?B?ajFUWWZrMERGdUlrajFUcWdqT1lkRFd0eHZSWkFJRHR5MG5QV2NKeW85bUo4?=
 =?utf-8?B?Y1YyNFpmOTYrK1ZuWjBHS1NnYVJNK3A4bHBjRUxpdHFDbmtza2RwbThuK1Vm?=
 =?utf-8?B?QmZPUy9XdklDa1BJLzVuUU10ZTFLMTlyNmxCTllsbkNFeGd1OFpjSnlYbWdR?=
 =?utf-8?B?QStwWUluN25xREJUckpmRTM5Wng4ZHg3cjh2ZnVTek1penZYb3FVRkZNTmVl?=
 =?utf-8?B?YmtUaVBqcWVYR2NsT1pidFIxcElPYnFyempvMjEvaVVvenRicUx0MitOdTZ0?=
 =?utf-8?B?RkN2ZXlwRDg2WE56Y1dEZ1JLeGxSSUpvTDZjSVRKWDdVb0kxUUpLYUhRL05T?=
 =?utf-8?B?bExXKzg4UVEweW9lUWx0Qkp4d3hrQ1dvR2E0b2RLQXl2SGdjN0lYUW1mMmNS?=
 =?utf-8?B?YkVxekQ4OTlaRjMrQTM1WVpIUXRiQ0hHckVUTWFSZ05YeDhMKyt2dllvL2Qy?=
 =?utf-8?B?ZUZXK09nUDVCdmd1VTR3ckJ1b3RtdlhhVmtuMC9nRTVONlVSakpPZXhrN1FQ?=
 =?utf-8?B?R1FNNVN4LzNISWZQWnY2d2dBZjBTSG4wWEs4SlNJOXRvOUw2eDR3ZUVnK2NM?=
 =?utf-8?B?d0ZHVDFqaFdxMjdnaHVJZWFKL2lzajhSRzgwd3VRcFcza3FSQ21JQUJuL0tp?=
 =?utf-8?B?Tm5DZ1FxclhidmxOaGFqZ2pUdHdreFBnWUs5U3oreVdGRklVbzJjaDNZZkRq?=
 =?utf-8?B?TUUrSjZvOEdBdnU4L2ZRVTU4WW5US21zN3RuT0E1SE5FY0pEQ3JwNndwKzJB?=
 =?utf-8?B?RHBSakNZSlR5MkF1TVhWY01PV2JKUmppWFh6eFFubksrd0JSSUZ5SGNUL3Bu?=
 =?utf-8?B?OTQrUGYvUVZsKzd5TU5rL0pmWXFvZmJROHVUV0JjVWV5SzZYR092RGs1NTE3?=
 =?utf-8?B?djgrMG92OEJ4b3ZPbzVFd3lNN1p3eUUrVlM4aXI0ZVVtanJLNDlZeE02cmE1?=
 =?utf-8?B?b3dXZ1RIbVVtZDlaKzJ2SUoyQVFYVThEcWs1SzBqN0FGM1pGWkRVVFNSOTRP?=
 =?utf-8?B?K2lXOG5nRmU5S3JZbFRBYnBndEhSVW5vK1FYbm43SlNBRktkSVRRUnF2MzhK?=
 =?utf-8?B?bW44SGc5S1pKRTdnQXFCMHBZOHFrNFNDSXdNcWdQRnRieitpcHlXbGZBa2dr?=
 =?utf-8?B?NkJ5YVBOYzRHWW1LbjZ1Unh0aDN2ekNlcWhFdUpHYm1wRG82d2pXSHlCMGtG?=
 =?utf-8?B?cU5zR0ZwR2ZGTkt3T04zS2lqUHVabTZQWWNQck0vRmFzRzRBYzFNbkpBdkN6?=
 =?utf-8?B?ZHV5dnB1b1BhYyttTDhCbmxUNGEyRjJpRS9Pai9naXdSeFFRUjdBVzVDSW5Z?=
 =?utf-8?Q?AjABGTJzz6teGlAcYCSVZCRJx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EB96451D0422642BE5AF2734A72AF50@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445d5b51-0b93-4786-20c2-08dbd455cfa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 05:55:22.3773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T4Cqir24eHSfnM29pvir8/NDhTFK+fxPxma/BDuQ1rXKNGVYpU0n9lda5+gOaGkKS++HOFRZXNTEzbpNWkLgDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8049
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjMvMjMgMjI6NDMsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4gT24gMTAvMjQvMjMg
MDQ6NTksIFNoaW5pY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+PiBIZWxsbyBibGt0ZXN0cyB1c2Vy
cywNCj4+DQo+PiBBcyBvZiB0b2RheSwgc29mdHdhcmUgUkRNQSBkcml2ZXIgInNpdyIgb3IgInJk
bWFfcnhlIiBpcyB1c2VkIHRvIHJ1biANCj4+ICJudm1lIg0KPj4gZ3JvdXAgd2l0aCBudm1lX3Ry
dHlwZT1yZG1hIG9yICJzcnAiIChzY3NpIHJkbWEgcHJvdG9jb2wpIGdyb3VwLiBOb3cgDQo+PiBp
dCBpcw0KPj4gc3VnZ2VzdGVkIHRvIHJ1biB0aGUgdGVzdCBncm91cHMgd2l0aCByZWFsIFJETUEg
aGFyZHdhcmUgdG8gcnVuIHRlc3RzIGluDQo+PiBtb3JlIHJlYWxpc3RpYyBjb25kaXRpb25zLiBB
IEdpdEh1YiBwdWxsIHJlcXVlc3QgaXMgdW5kZXIgcmV2aWV3IHRvIA0KPj4gc3VwcG9ydA0KPj4g
aXQgWzFdLiBJZiB5b3UgYXJlIGludGVyZXN0ZWQgaW4sIHBsZWFzZSB0YWtlIGEgbG9vayBhbmQg
Y29tbWVudC4NCj4+DQo+PiBbMV0gaHR0cHM6Ly9naXRodWIuY29tL29zYW5kb3YvYmxrdGVzdHMv
cHVsbC84Ng0KPg0KPiBKdXN0IGNvbW1lbnRlZCBvbiBpdC4gV2hhdCB3ZSByZWFsbHkgbmVlZCBp
cyB0aGUgZnVuY3Rpb25hbGl0eSB0byBydW4gDQo+IGFnYWluc3QgcHJlLWNvbmZpZ3VyZWQgY29u
dHJvbGxlcnMgKGllIHNwZWNpZnkgdGhlIGNvbnRyb2xsZXIgTlFOIGFuZCANCj4gTlNJRCBhbmQg
ZG8gbm90IGNhbGwgaW50byBudm1ldGNsaSk7IHdoZW4gcnVubmluZyBvbiByZWFsIEhXIHdlIA0K
PiB0eXBpY2FsbHkgY2Fubm90IGNvbnRyb2wgdGhlIHRhcmdldCwgc28gd2UgbmVlZCB0byBiZSBh
YmxlIHRvIHNwZWNpZnkNCj4gYSBwcmVjb25maWd1cmVkIG5hbWVzcGFjZS4NCj4NCj4gQ2hlZXJz
LA0KPg0KPiBIYW5uZXMNCg0KV2hhdCBmb3JtYXQgeW91IHRoaW5rIHVzZSB0byBhY2NlcHQgdGhl
IHByZSBjb25maWd1cmVkIG5hbWVzcGFjZSA/DQp0aGlua2luZyBvdXQgbG91ZGx5IENhbiByZWxh
eSBhbmQgd2UgdXNlIG52bWV0Y2xpIGNvbmZpZyBmaWxlIHNvbWVob3cNCmZvciBsb2NhbCBsb29w
IGJhY2sgc2V0dXAgPw0KDQotY2sNCg0KDQo=
