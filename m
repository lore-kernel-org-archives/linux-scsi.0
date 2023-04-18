Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CE9C6FD18
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDRUMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDRUMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:12:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EC44C1A;
        Tue, 18 Apr 2023 13:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXioWKlE6wqPoHQRvSTmFknIa3f+wVj3vc89Ayjh/GIC8vR0/gXwtERABBc2NYc6wfeblxlgFmE2hl5UazmQHWvUDzBAlKk6apV48s5d04xIULAu0hHWShW+WZade5gq5Ku9r69PKMsukls6Iqtds1DhLI7O6Rgasie2vgPuQPUWWs4x9SXpFqJly8ypK8Jxepn3iC3kbfJWXY7xJM9YhfRNP+HrJ9OfAzq+AcEOa3muG7yTIZ3ZptxWxKdbc7zzSTCWZNmxNy78eGk75rvTQlRuxozXz50KR0nESRCwhkfJAWrf4OqX+gy0AMG6Guogg0pnhhGETmmPLb9yQmWrqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leNU0FzApUV7yX7Gsgu/9s3rQt25FPT51K/QzV+rMSI=;
 b=J2splgK9uAHJTnOI3LD41nM06ENG/cbJR1Xv+ls1xwcbKuBJag8a+/JKpgOGKLMQQZRPfR1ZLBGo2H3Y0ozNHSO4OLU937A19JldGLVzLNKEJyuruw7wjj4uSqnwMWSXv39S0hPYMPveLgsBhh7r3wkv7AGWXDd9kUard9V0m2vKM4uEpq67INQ+P4q1zjnnFhsoXx7wItmj+QFP2OqNIaDT4wdTD0CdH7bL9XT+/OxaxMVQZFHqsLjf/GtUGhlThe00eIXRBSRM13N5tbT+bJJSmQPRRpLJX++McRT7cLBPHTXG08qN7eidDGh+rWCxLzSj57XmBk8jtLCG1drcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leNU0FzApUV7yX7Gsgu/9s3rQt25FPT51K/QzV+rMSI=;
 b=Dyfd64Mc8hZ0AEaFNTiUjj1Mq4PTiJiFwCNtSt2f4CIg2hzLCByT0mEDYJ/kEPhekvfgFvTd5iwMQ5YgU02ZEyi4nviuHVgTuRgFdPqUp1NEgMsyVgR+/AiLXisVnTEejP5AaGMDJmkfxM0zjiRkoSX4xq/S8ixP4Muw2lU47V356auS06c7ERG2UJ3VyIS0k00YheYF1w2wh79Dv75fuZLkERttBokLO9LuGIhCcGHmjzhOOfKLbfzvB1NxXHcVhSMCw22/IQjJ5JXmfX04bCNIoL0Pc13wzir+ThswyvMjtcP/WmYy8O4IsDJFbWUJEDbtKUPgYF2qYxRt9lye8Q==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4538.namprd12.prod.outlook.com (2603:10b6:303:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 20:11:57 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:11:57 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 3/9] common/scsi_debug: factor out
 _setup_scsi_debug_vars
Thread-Topic: [PATCH blktests 3/9] common/scsi_debug: factor out
 _setup_scsi_debug_vars
Thread-Index: AQHZcSrpPACDdqlWgUWkiVmR0u0+HK8xgbeA
Date:   Tue, 18 Apr 2023 20:11:57 +0000
Message-ID: <286e5174-194e-0229-9a00-9c34900d8996@nvidia.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
 <20230417124728.458630-4-shinichiro@fastmail.com>
In-Reply-To: <20230417124728.458630-4-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW3PR12MB4538:EE_
x-ms-office365-filtering-correlation-id: ab907914-6d6d-4312-539e-08db404929a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2h2LZDyYNBrZEMutnvm8yViMOwd77I0kplNNC8tVdASE8hUErmcBzHeorcGqeODaU9TsyEWBr64yQs8SEosrh9I4Zzo284/jv1xoFgwUcDtwjvAEJol2sfZfjeWYwtRC7cNZfS6XmDzdzvbjLoR3ALQ3TDr4Tg8zxKS+AD2Rsyb1d0TJgixmmn4D4/g0mMs07c78NVydOD0v0UZi08XkDHHtR89q09Mb0V24gR/37DxdwxCC9QbPl/PriDt0Rb4Xs83VCWK3aRIQJL4pXWKj2M1m3ZM1GbcobWgcd1T/Y4kprZMh1rysEFFhRYdP/0dhSjcpPEIXDeuXSPUQRRzq+cuxAHtSMTB8WI3d+X/yyjgvTeA+gmVMZObaBY0v5bwO9GMKzMTexadSq0Dv5TJQVHt56/XZoxU14BCdtZwtbOLS/229LSZyE8VaNTHCBtiBht1InqScbY+S9kskdE772CrNZzQz1jNaPtQifq5k7DchdBf0P47Wo1y6kIZcMIhh/h7FWCkQfGlBOefdEsgGziE22/cgYh/RChXMkYd+ablbXDGMbbCldSlVyAI9X8ygkHjOaemN1W2eysku55rOYg35m2kJ6pTGusnGz65tLhO8MIfQGrLHm2Mo09yQir+QzEbQQONkJYgEwvtZ0KqcMXIr4FBkX2bHWIvrUpVoeHRI9c9ay750TfPmP+uNt/o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199021)(8676002)(8936002)(5660300002)(91956017)(31686004)(41300700001)(316002)(76116006)(66446008)(66946007)(66476007)(66556008)(64756008)(4744005)(2906002)(4326008)(110136005)(31696002)(86362001)(478600001)(6486002)(38070700005)(38100700002)(53546011)(6512007)(6506007)(186003)(122000001)(71200400001)(2616005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K09aQ1FuT0FJNm5RRElCcnhsN2lMd3VLWnpLc3lWaFcyN3lCT21LUnNkdm8y?=
 =?utf-8?B?ZnNZNlBEK01sd3d4OXcrdEZFVm1nOGxCU3NRRzU2bnhWdmhXTVNldVdoVVJ0?=
 =?utf-8?B?T2MyZ0xwTG9TMEQvdWdUdDBWakR3ZjFQbWlHclhWOXVSTUZYSlVpb0dyZUx0?=
 =?utf-8?B?L0dxcTdzUnNOOFVqY3V2ck41czhpUDhLS3B4NjNXL0RXQ21pYmI2eXNCbEFi?=
 =?utf-8?B?c1ppK2tKbFI4ZDI4d3E4TmhuTzhHM1djQWNJSk82VkpzelZ5VGQwbkZBaVRP?=
 =?utf-8?B?VGxIRFJ3SVkwZVA1V0ZwT0F4akVtYmJCeXhySEJ6U08rSWIvZ0J3alc3cXJm?=
 =?utf-8?B?d2RIc0UzVnNYc1pHbEpMMzhHeGx1T0d1cDc1MC90N0RyRko5QWxDWU9oQTBj?=
 =?utf-8?B?MkJ2cUNpV05kV01TOE02aVdXdW1GdmNIaG5GSy8wWGFpdVFYaDcrbUFjZURx?=
 =?utf-8?B?UmFzZlNQWjVaZGwxMUNWelNzUGlKaCtwUldGWHN4Z1dEM1BobjE5Z0dJMkpz?=
 =?utf-8?B?N3IvSkYyenRXSHZRN2hsWkN2WVQwK0xibE51TUJHSWNvdXdjWER4MW9mOXFn?=
 =?utf-8?B?WmVoN3c2YVEwMnBiaTRzakhHZGE2SEJsR2pvaUtSR05XT3Z2WUpNcFI0bjVU?=
 =?utf-8?B?UE1rMlBJWHNWRzY5ZEV4L004cGpSRFExWmwxdmJvUEhkNW4rdWc5bjFvV3l4?=
 =?utf-8?B?NnZwc044NlNFWDRHSTd5SVMyMm9VaTAveVN5S0g3ODc5YkZLUldGS3VLakdP?=
 =?utf-8?B?enFyaG0zd2hIbVBTN1ZWTU5wbkI0WjYyS2ZTeGNaZ3IyTkRhK210Wk5XNmRk?=
 =?utf-8?B?czhuczIwUW04ZEU1N0h4Rm5Nb2tQbHlXVnorU0tQMlhwcW1wVkRNdDJsekI4?=
 =?utf-8?B?WXQrZElLQU9WQm1sa05ReDVCQi9RdldmTjEyQVc2Qll4NkxHLzlnbzZsK1Bv?=
 =?utf-8?B?RGN6d1VtUUdMOEt3Q282WjF0NTJrT3VpZm5TQTBpc3p1REZ5RTFLVUtCYnJu?=
 =?utf-8?B?ZVJRTUwyK2l1YkVNRVI2SzVyaW1yZVMwR3UrK3hkWFZnTmJFcXB2Y0pVU1NT?=
 =?utf-8?B?bS8xdUpRZURIM0NMVXl6K1AwT2xsNkVFR01oT0NzNWU3MkdhQ3JaVWI0VUFm?=
 =?utf-8?B?ZldrdElsR1JaM3ZpbjYraWRScEt2VEkwZWV2S1ZpMnRkVmFDTE5aUG52YzFK?=
 =?utf-8?B?WUg0dUhvUzZOOHhSS1d0dVFXQ2JIcDRCOW40ZkZuQ2xueFJrSk9Qd1hKMjBL?=
 =?utf-8?B?OHd6N0N1Z1A0RmpYMkVYTTRIcnZRdHEyTVBzUWNTNGdCSmZVb0pSMGI5anlT?=
 =?utf-8?B?SnRiWDhZVUMxcXJDQWJvczBTN3ZNZFk4dTRzZUsxOUYrNDR5S1E2VUJhb09m?=
 =?utf-8?B?Rm5va3J5c1V3VFVOSmRBbEFYM1JMMkNoMHB1VDlZWWZTdUJtU29oZVRMT3Nt?=
 =?utf-8?B?VmxsQjA4cVhPWWRCbDJkUlo5S0V2dERFRUJUL3dkSjRzRm8vMmdLcVY2eEZZ?=
 =?utf-8?B?UjhkMk9wTXU5Zk9scENHUnV2TFNyTGZISmp1OEZRc0twWm1MUjQzVGx4aWg3?=
 =?utf-8?B?NVRJcFhHa1RWeUd1NzNQeEgrS0krcmlvNWpDK0xDdElJdytIbUlLZmNkSGl0?=
 =?utf-8?B?SWEyQ1F3ZFd5Z1ZLVEVyckw0ZVJPRGVsU1lqSGppaHNnUEN3YkNGMzg3azVN?=
 =?utf-8?B?cVRCT1ZkSit6TFF3VEIzVUp0Y2Q5Ui9BalJkWVN4ZXZkdWk2dThiSTRDQStM?=
 =?utf-8?B?RDVvS0x6NVdYUkFQN3cwSklPTUlmQ0NNTTloQXhWdzdraGNOUG5zbTJZTFBR?=
 =?utf-8?B?R1pkQVpKaG9lMjQrTklndlFGdlU0S2JGcWJvTkJlUFZ0VUlyK0NOQmgrbk9C?=
 =?utf-8?B?eUc3M3ppRDhIVWZ1L2NISlZZcHlmTjBjVjQrQUkxUklFZnZ4MHhMRzRIdTU5?=
 =?utf-8?B?NVo0UENvVnM2K1NMeGhrcXZaWWlnOG5PRVZMQ2pER0krRXR1d0xwMzRsUE5z?=
 =?utf-8?B?SnZYZnYydytvZU82VkZZVzBEZmtieXd2SG5pVzMxQlcvN3Z6T29zSlF3cUsr?=
 =?utf-8?B?aVhMekdTUU82SlJKT2JpOG9QRFFVN2RGck8rU3ZZTGMzNlpXdWU5WU92MjRk?=
 =?utf-8?B?NmlrZEgrdFhCUzVyUWdjVVJtOFRyT3p6WFkzN0VQcDZ5SUFNdnRvZGowZjRn?=
 =?utf-8?Q?ZIa1eiTtw0Ug7Fy88ExGoO/g6LC9VVhkfuo4gZrKIjRO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <94FBB6E340551B4AA15ACD36D9D3A661@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab907914-6d6d-4312-539e-08db404929a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:11:57.8530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lleEh7tuHaD7cKdnQc94plPFarVHhyY237gTSzRJ7fetTX4bQ91H6Kf3fId3fpnOjcJQhWAb9rQdd3pI5lLKGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4538
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo0NywgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IEFz
IGEgcHJlcGFyYXRpb24gdG8gaW50cm9kdWNlIGEgbmV3IGhlbHBlciBmdW5jdGlvbiB0byBjb25m
aWd1cmUNCj4gc2NzaV9kZWJ1ZyBkZXZpY2Ugd2l0aCBidWlsdC1pbiBzY3NpX2RlYnVnIG1vZHVs
ZSwgZmFjdG9yIG91dCBhIHBhcnQNCj4gb2YgX2luaXRfc2NzaV9kZWJ1ZyB0byBhIG5ldyBmdW5j
dGlvbiBfc2V0dXBfc2NzaV9kZWJ1Z192YXJzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBTaGluJ2lj
aGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2FraUB3ZGMuY29tPg0KPiAtLS0NCj4NCg0K
TG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRp
YS5jb20+DQoNCi1jaw0KDQoNCg==
