Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9C0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJRUoX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJRUoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:44:22 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4034C520A7;
        Tue, 18 Oct 2022 13:44:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1UIOZEs1ztWFkHjW8FnkShFGcKYY/IQbOGx2lSq1nxb+VygPm6i/nZ46/jKvVFOmjdcAB0wRCNFdb5TzRa1MnyzENTpZY2sxmp7HyESjUjnAFHk9RK4kpyGLHFqsplpXXcoYZVRKKRXuDJLuBi5mJVQrFOZLLmQ/v978LvwpCV+HQY4yv2J1L5zBpPhuL4U5a9eFW9zF5gJ7XQNQYwEKjG2NPSSFqfDcFVevXWJNQXuNjwRRZM5GTNOQpPN1WI7p7a/DZfJOwR7VH2SNkemVpvKlWtGRs2cGxQpIsK/ncaEw2irKAd3JzYfBFOLaQGmuic+0v6k1tGH0ekwWLIOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aisapD0kt9BpzYhTk4d3JjfXFCz9amixha6Dxy6Kvw=;
 b=dARdIwyV9RGbyXQprgSniqmvVeKGF4BrBCCLXHMT/V1zmHopiaj4LD9vWeJUJ2KI5aMLYDLnyVRqUCXBKpo24PskER4NbnuuOwNhcdxg37nQsHKcS3FXlm1b27qWVEOf5VqbmQZkR66Uj5ltIrNeYddBPHDR3vdTilJtgLa6ueBsolm6phaFYaGuxYYQy84+vd3NJqkce4qjvnbuyQHjBaVHVlpITj4CxGCN/if7gYhCSWbS1LO7AViPz8Jui2NcnqHcY2B5QN35NSq/v+ppP6OLBEhnreSOOafCRJmAplXKk/8+LhB6ph917p3W0KuMqHKJ8mk+rUgrdJrPvDlvnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aisapD0kt9BpzYhTk4d3JjfXFCz9amixha6Dxy6Kvw=;
 b=poQ0JEjGan0MmZ0UUsiqCiAu3tgkNglOYb2g7En4DmpDI4hMtDj3n+lsc6Sd7gahx/aln/z4s5vGpr3c0vNHf43p2O3hkpaN1MaYuEJTVhddnbTIdFWk7m9fbClpm1dUliXS8z0FPL7HfyiCkw4E/Jz61hwKGjCHA1foYhBMYmZ/hMdtPURWiU0Ydj8VTNvow3s34PY/SHt9bU3QRM4Wz6/ks2RJ5ly1zVS9aOB3508IY5mOv3/6KolK8/Njpo/QkwqYFBmP/8inotswLa3GK3q+AfS2iq5V1TfAWEOKIkIKihPUurHpvx6IHgX/Hsf+wZoB2cuyImkeOL2deWd7rQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 20:44:17 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 20:44:17 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/4] blk-mq: move the call to blk_put_queue out of
 blk_mq_destroy_queue
Thread-Topic: [PATCH 1/4] blk-mq: move the call to blk_put_queue out of
 blk_mq_destroy_queue
Thread-Index: AQHY4vmaQrM+QzhojkOfKukB1YoeJ64UntMA
Date:   Tue, 18 Oct 2022 20:44:17 +0000
Message-ID: <f9d27cf8-a453-9518-5261-3901a8e1b8f5@nvidia.com>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-2-hch@lst.de>
In-Reply-To: <20221018135720.670094-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BL1PR12MB5272:EE_
x-ms-office365-filtering-correlation-id: 404745e3-2a03-4f2a-5df0-08dab1498669
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhNktqJwIbD3NP8L0C1KZb5x3S3fN0mXVl2Hl1PliaB4dYPxDoEd7MMiH0BrCnYQl1tInLifP18Cuxg6cTIfxPRF3QdSW5xL+wm/1FZtCBlfAOrFyQkrCMtSLjMT/z+QVWbO1hF66BhkhiLZPUN/BK8jQHXsd9DQw1KChkvUrPkMA97OtWPKmiW5qGW3EmMaruQdf1JcOPsKfbbSGbjmbvBnfevp0X1wpSphZGhFYFEqaXq3TpLCwuAYJNSM02PLVJsWebPQJDMauZCryML2++LaH7oeqPgVBOW06Uy2xhGWb2tJQtltwSG1HG0JWQpHvQuIDlYJ0zWEkmN3C76Ljc/wuVZrtW9ZQk49TnK+OG4/HvKVrB+6TNC2Rgk76Y9ADP0K7eeRxTx5nYhQVoJ4kBsLwnHeKSX01FoxXO5HN9YTl4TBUow5ldKOyd3pJanrirkacrh5+gGVV3FezjcKLaVmSEecTUh3mxUfwpC0lo5C18aoo1QtBu7kGnKig2FVNrgX1Toeux/EI4ExmO8FIBgzozvjbNoCPoEtGF+7V3YYh2E1dPGjoJQA+UkVMGrGHuTEaRvpyZS3BTzFyrXls6DnTOIblIOqDA3JAQbG2eqjDiwC4WiabBxipXGKf8ZOsepzXVpetUANSnFjemcfMD8TaYTZZdNI+JSs0Gjemtah8Qeft3CW5DZ3/LUnS7BskIRas47zSva0VWQGtRtGAS2TZ5K7OY1scEGWDuS+4+w8DaN54yrmJ+n72okQu3sr/zmd+mcJN6O0Fg/+E2b2E6vNhGtNtFMSSvKFl2et8UptPXYULMIXDyXGkM5r/I2sgbERafkfMhmMleZTfl+21A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(38070700005)(71200400001)(122000001)(31686004)(478600001)(6486002)(38100700002)(186003)(110136005)(4326008)(54906003)(36756003)(6506007)(2616005)(64756008)(316002)(91956017)(76116006)(66946007)(66556008)(66476007)(66446008)(53546011)(5660300002)(8676002)(4744005)(2906002)(8936002)(6512007)(31696002)(7416002)(86362001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUMvcWlWMzM2Q2NiakV3TXJ0Y0FzYm9oY1dqSW0yeWJwcHdzZTdmVGhBMENE?=
 =?utf-8?B?VExaUTYxcXQ2WlBtTFA1dDY4eVJ6UUJEbEo0WDcwMTVlamcvYmZTUkNMbXVu?=
 =?utf-8?B?YlQ0K0dUSlpJbnVYVG1Kbm93bjdwdTdCUjlvTDA0Zkh5UTNqMWFFeS8yQURI?=
 =?utf-8?B?OEJHVzQ0V28yOW9pSWVNZzBRVVo1clQ5VCtqVGRGVGZDaWNZMHhsVmxOZFpv?=
 =?utf-8?B?bENXNm9PMkJTTEdSV29ORjgzZmo5UTNnaGI4L1BxTmlOTktkaTErb0hSTFFB?=
 =?utf-8?B?a0RpTTlackZ4N1cxYUpVZlFldXFGNDhSRDdaNHJORkd4T2ZwZ2c0ZmhZUWRL?=
 =?utf-8?B?RkYyVnlUQnFjTjNPbEh6ZmJhQWQzRC9OSk1PUUFKQVlycUFBNThCSVpVMU05?=
 =?utf-8?B?cTBhWTNaSXdKWThva2RIZjdubkhsQ2FDcHJsS0d3M1UrVXpyQUNwU3ZHVURX?=
 =?utf-8?B?WW9HTTBzVnJ4Tk5pUHJoQWl4UXlacWM4TkY4Qy9HdExkWjc0QnBjWDgzUXVn?=
 =?utf-8?B?UVJ1dmNPMHRsSGU5MlhxdU1HNWhhSk9yaDJNSEd6eC9CNVRHM0dXNGliU3Fl?=
 =?utf-8?B?Z3lKNTFTaUhXTFIwRVFZR08vMXNINHRHY21JR1pyeGk3a2FPMWtiaTQ5TVBl?=
 =?utf-8?B?aHkxSVpLeDZ5b2diVnJGZERCRTZhbVM2RSs3czlxcXVJOTMwRVJqVzA4Mmsv?=
 =?utf-8?B?aWs4YXdKTm1QeWR4M3ZXa2c5cmV5YVNTTXdZajU2WE4rL0dRcThaWXlhZzJw?=
 =?utf-8?B?VVVnQkplamFhMG1lcGc1dU5ReWNRelVkY0tXb2ZvZGVVYTRteGhXSWh5R0I2?=
 =?utf-8?B?WDJuM21aTzRCL0NEWGVzaGRlR0NtWXVGRER4Z3ltOEdnbUJQWUtCZThlajln?=
 =?utf-8?B?bVBHbktQMHRxbG5sMG5nWXM5MHJqU1VYYUtuamVyM0cwcnRDSTZoc281dkdV?=
 =?utf-8?B?R1RBcHNLZjdXMGZZWHliNU9HSFYzcnhzN25yRUVENS9KcUhWcnF1MWpnUENw?=
 =?utf-8?B?VFJjdHpHSlZSYXVxK2IzZmtDREllVlJsZlRNQ3JBOW1UNVZ1UU4rNHhOQlJx?=
 =?utf-8?B?NFFrYlRxdGk5bTZDVFB6SldOSm1mWWx5K2lSTDZXZmYvWHpMUGozQURLVU1K?=
 =?utf-8?B?ZTZCZjNIQVRLME5tVEFLcVRQblRZWmprWW5GTVFnOFphUTRhUThQMU1aWm1j?=
 =?utf-8?B?OUY5d1hnZTBFRzFOSG1yQUVzSlA1dDk2UkhTV21VNzhCNXZDUlJ1U0ovWlZR?=
 =?utf-8?B?Zjd3Q25ybE1XTnZMc2UzajBHeWRQalRJUFFaVjBRSWh2TklzMDhQNTJmSWxC?=
 =?utf-8?B?RnFmTVRqQ0tpWFF1OWV4TkFLZEVxK3p2ZmNRVklhVkxjNUROZHdUN25wdHg4?=
 =?utf-8?B?SEdJdVNpYzRlcHRPTXhPc3N5TlkvQ2JuUlIzMWtrYnIyNWZpWGU3cC9aQXhN?=
 =?utf-8?B?UnNERnBaVVkxc3lLbVBSOUxKMGR4RXdPVEdOZUJveHF3YUdrZk1JWjI5SmNT?=
 =?utf-8?B?UmQ4S2c5MGthRmV6dkdoS2Y3ampPd3ZyUW56R3FsMzg4NndHdVgxWXBnQUxv?=
 =?utf-8?B?a3UvU1ZHNDhRdHcrRUVtS01OTTdHUG9zSm5KbGQyRWhZSUZHbU1ZR0dta2JE?=
 =?utf-8?B?dzFBREN1TVRvOFo5U3NjRkptN20wcUhPRFBiZ0kvTGNzRHRXN0RPYzBPeDN3?=
 =?utf-8?B?a3VzbXEyYzE2dXd0cm9pdFpJYTlaZWk3MVc2dEUvbWpwRnlUQW9XS1Y4dW9r?=
 =?utf-8?B?YnhhRGIwWjI4RUdtMnNya0lzWDA5czNwSzBmS2xzc1l2VVBZc3ozOEk0WUNa?=
 =?utf-8?B?THNiVkU2V2NMazI0WVJ2dTZYRUtCWW9PcmVFalNpWXUwZlltcjUwRW0rMjBO?=
 =?utf-8?B?QlFxeDMxd0xZUUlWRHJDZUtqYWNFYkxUdis3U1JOSXdST3JFc090RzNVWE9V?=
 =?utf-8?B?dFAzbzJOWUc2UEtwaWgydjQ0SEUvNENvVXg5dHY5MWk4S0VFSDYrK24vL2I1?=
 =?utf-8?B?L2VJeERxQkM2dTZGeEVpb3R1UW82QkFBWUlSUEsyWStyT2cweUFwcGd2dWdk?=
 =?utf-8?B?ZWVmcTN0YUVObnRVSFQ2YVlvb2pkODNUcWZWOXY1YmRzbXYySFVqZlFOdWxS?=
 =?utf-8?B?dTVQQUpIT2txTEpGUHpkZXl3bnNmRTQ4ZnZrUFFVbWxZcWlpTk9aZlF4eTh5?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6260C45A0F3F514AAE91F535E9D61DE3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404745e3-2a03-4f2a-5df0-08dab1498669
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 20:44:17.1815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FEsC8oikhjG94Uqcj8dZsbyH7DVFa/A/gVxVsgeeKwSoovAQlGyEbPt6rPoPs7vFRoLleXT0ntighEM7slv03A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMTgvMjIgMDY6NTcsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBUaGUgZmFjdCB0
aGF0IGJsa19tcV9kZXN0cm95X3F1ZXVlIGFsc28gZHJvcHMgYSBxdWV1ZSByZWZlcmVuY2UgbGVh
ZHMNCj4gdG8gdmFyaW91cyBwbGFjZXMgaGF2aW5nIHRvIGdyYWIgYW4gZXh0cmEgcmVmZXJlbmNl
LiAgTW92ZSB0aGUgY2FsbCB0bw0KPiBibGtfcHV0X3F1ZXVlIGludG8gdGhlIGNhbGxlcnMgdG8g
YWxsb3cgcmVtb3ZpbmcgdGhlIGV4dHJhIHJlZmVyZW5jZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCg0KTWFrZXMgc2Vuc2UuDQoNClJldmll
d2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
