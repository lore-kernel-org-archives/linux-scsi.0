Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426ABC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJRUor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJRUoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:44:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3DD32DB3;
        Tue, 18 Oct 2022 13:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/XbylSlxd3ACwIA1TcAeKswI8bCxwv2e5EiKfymLzY4bP+0IUu+TzoobkFpvKgbFMsqd3LdvaV8MaOVrt3rdV0T+16ZcnraNLMO6Rt8excl+rk0MHHQrr152IjQkZpvjsqTtpNP8vkKKvOBhf9r2MChFMRtb2DLe7azvLop6RuXKRp9q8Gcf53LNBzwAj/IxOf4aOMXub0Av8DVcTvT+XRfUGxfROg9c2Z3AOHPsM1X1Om4bpNFIChoNV1IuFbddbzv6gMXdiyaq320C+2KO4K5QwebplZ4RMtkkuIuV9tLNxbycJna+T6vX0T9bXGZKmIrkrnVWj8Fe7uCX72bTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZ/WXd30gTrVu42scd11LuO+EvOtk3o7RjeUAgc54Fc=;
 b=jlChOKHU/b74S6O5HMIP9ZXWtQPTD1wUIsk9x93BiFhfmObGKdoTNxnMfQPrNpYzltkRzFI9y4/QtoP1G/jf8PwhJPuMD+3EQqpiRecGz/9S3ArpObqiIYIdUPH9kFVcdrLDyGVlKVMk8/cXt+CLM41xv1dmisvoC1n3+HJRgTzHm9sgGoZySuyB8xP6SlbqWUM83h845+efI1oHQX5YFep2aojhuYBtwDSnrfIHOL2ROXGluWFA+X87yjR+rfeX6psHz7Npsucnk+Y9DqrCUArn+m/xBZQKmCrci3VsKCCTEP60bN+VYijWZSDaV53RAwPSDVdMgXxy5prnRuz/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZ/WXd30gTrVu42scd11LuO+EvOtk3o7RjeUAgc54Fc=;
 b=FpqJHE/zzs7MEwDlKYb0H/3Q2Ouio5ae8a8F1PCCH6I8hUqLQd8hg6IFdnuwJh1TWM8bwtTTLifpO7d4QxJoAeguCwkdY0BQLTvnWWwWAZiYWSW3SyNpAMb0f8BuwZcP/mkXkV2Dkl4l7cNOmPOvB7QOLFIRvDcdrV2VdrPEpPi0QAnFQhn812Gb9odWR1ZELUEUEDyHCmbeQ1+vmqbr1u1Z7HICtWAI6iu3gx9BpMkGdAAu53cz6LAb9ggNwXisawQ8mk5Z6T8WcRT5iFg/z8eG0vaDmogZ1vjuZuvPfUXZqaCiHqMRYoRWDoj816sd69dpqz5c3wEohpbLKxczZg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 20:44:40 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 20:44:40 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/4] scsi: remove an extra queue reference
Thread-Topic: [PATCH 2/4] scsi: remove an extra queue reference
Thread-Index: AQHY4vmaEQTZm6NAzUCxVJ0wjiHMfK4Unu8A
Date:   Tue, 18 Oct 2022 20:44:40 +0000
Message-ID: <914d8678-89b8-f1b8-eb69-d6baf2a5c9f6@nvidia.com>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-3-hch@lst.de>
In-Reply-To: <20221018135720.670094-3-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 09c9cca8-45a0-427e-5c33-08dab149944e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L/vix6yk9OiRzWnYBO4A+PbK5mot4uCLqTjzrSihFKM1YZOVUEqwE8cpq2MQWMB9R1vCsmBWF/fx1ViQVE+ujo6tDZFkZ5gilbkdRdvoIVAZ5zoHv87pQ/7DLkmFeof38a99I5rwgz1hHpQFnNLJVVgG5OVL423TlIlk/4U++VRit2dCdcn1ToZbCGXlD7RhuXwxxVO4fqMFICgp4rrTb/1cLOj3n549Km9j7px2nfAuJyH6MhZ7HFXUOpFB1jL9CIpayxRsIEUAqugtpUNO+VJMTu3Y2LqeG5aVBCTVsuzi+p40rP1uk2Dd2PvXRALJ5zLAqEiXpr8ksAyODuftZqWxK44E33iOLOA4GXKfxVLu+9S9zGeykVOLEewfDVc9wf9SZpibYUnd6voaAq8nUTj2AFjcTE6nUc6Nk9jEIr4rte4PmddW/KRTPDF7QX+l/61aZR3DQh88bwgk2+HZviQFHbKDHyFM+sGvHzHFQ+TsPQbIM6iJSeRIJNp0+i1iWjdV7cbp4sxgr3FDbHC18ial7RROWX+K/bC1INcSIsOkcpXC1SepeaQcEZBUVEZQdIDsloQbi57yhCFRoauvpmU49gW15D5Y0a1CzmBNQ2sYXjFGM/5BElzXrgDhMWXLkyrZoaqsfmWkZfMzxn4McPUZQSva3ngrYRrnRV71XZLRkad00+eVbXLLxJEaDlQAtIYF7NFB6FUNxJzhjPVuiniJO33sq5Ndvg2CQVHugVhyEavgj58S6AMv4YIAuR6kDjgXlo3pVaZqx/bQQPEeZI4yCnH72yssVhDc3LcrgyUiu7gTvgwR7Rc7V8O55+s3sZ30I5OSKrfULTKLmSJpdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(38070700005)(71200400001)(122000001)(31686004)(478600001)(6486002)(38100700002)(186003)(110136005)(4326008)(54906003)(558084003)(36756003)(6506007)(2616005)(64756008)(316002)(91956017)(76116006)(66946007)(66556008)(66476007)(66446008)(53546011)(5660300002)(8676002)(2906002)(8936002)(6512007)(31696002)(7416002)(86362001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk5RRVN5eERzSkNEU2cxK0ZqN0MrRzZmRE1tRU03S1NPZHNveUtzYTRYUWpE?=
 =?utf-8?B?M1czR3hDYlVyL2VuaGhrcUZHSmh0TDZVelVxdFJBL2Z4eXFvdzJNU2IxUUk4?=
 =?utf-8?B?Q3dyV01rNlZpNzRQTzk5eFQ2RHd2Mnp4Q2s2bVVhVkkrUDNZT3BQZ3BpVUdD?=
 =?utf-8?B?aGt5VkVVWHdmNXFjZUkrU0E4ZDE4cUdjVEtudVFlSDdsMllQOVd0b0tqb0Vm?=
 =?utf-8?B?T080K1luRVQ4WE9HYnJlVFVGejMyUWJGa2lqWWpLbjVXclJ0M3dscHhweDg1?=
 =?utf-8?B?dFVJdHlBa0dVVEhvQWFnOFFDRFdnT2tMUUlib3pkcngvTXB1WVhLL0hQZFVT?=
 =?utf-8?B?VmxZRHQxemdxM0RSM3djTWVPWGdPUFhyZTZTWmJlNG1NYmRSbFZRazJoZkFY?=
 =?utf-8?B?TFc3cUhpck1EVklmNzhqaEdmSEFaekpaR3Q0ZURSenVHbjJGcjR5UDBuNUJF?=
 =?utf-8?B?SExwT3RjYjNvTzkycTZFSlVOSDdUTmZrUEllVWxJKzhSQzA0dE5nL3pycUpn?=
 =?utf-8?B?Q3NOODE3eXJlMHVOL0VudjdydFZVTFM4L3k2MU1DRExRck14YTdCS3lFWmdV?=
 =?utf-8?B?YjFxM1hqVWl0MTNYZUJXR01paGpwTkdTVDQ1UnBqcGt1MFVRTC9USnhrZUFU?=
 =?utf-8?B?SE4zM0x1QjNaSTlXMlh1VVl4bTJPeHozeFUxVVZKTlQreUE2KzRlM2lMclJu?=
 =?utf-8?B?MEpIQzdNQnRJTHVocEMwdmhaVW4xUTZxZ1pwaFliOVpKTng1M004QUZGY0VJ?=
 =?utf-8?B?NXRNRVgxeE4rU29RQUJKdUpKamhKSTkxbVJmRy8xMkZKU2NUajZxckhseEE2?=
 =?utf-8?B?Q3BNYXJiN0hlZzM3QkIvS3VZc0REVjk2RG92N1RUS21YaUl0bHRDQ0ZJS0VL?=
 =?utf-8?B?cG0xN0MyREdTNUo2ZlBOWjRPamVyc1FjM2RNcy9oUWZWLzl1Z1VCeURscHg2?=
 =?utf-8?B?K3hYQVdjRW9TR29FSEh5eWRncGx5WTIxL0Y2eXVUMW9BQTJmWnZiUFhzdDRt?=
 =?utf-8?B?WkVjTWM4KzdtVFNwKzhvdXIwY1hxRitabGVhb1NSZGlXc2JqdTZsdWRrMUdy?=
 =?utf-8?B?aG15TXBOdVdiVWdERG9PTGJ3UjR2bVB0L0ZsRHBGY2NkeTFkdHVIMXR4aFd5?=
 =?utf-8?B?L1M2TURuT0NOVGRsMEdEdjRIT09oeHNwUDZWd2Q1NkYweG9ocDNQRkJ0VnNq?=
 =?utf-8?B?cWdJcVlxVzJNSmVVZENpaHRCUGZtWlZFMGFBV3V5dUFOL0FNVjJjSU9CcXdR?=
 =?utf-8?B?MEtrNitQUlhzTzA5YWE4cnl4R1VHR2xVRjdKd1dma3VZQVVFbThxeFMyQklN?=
 =?utf-8?B?MktSaHRjeU5BaCt6cVdGcEU0MWFTR3I4d2UzeUVGaWQ4NFBucUJqblNvVFQy?=
 =?utf-8?B?blo5UjBJcWlSaWx0V1d3L0RMQUxFekMvL0xnVmhZcDZmU2lJcWxDZFJaUzVQ?=
 =?utf-8?B?TkJxcGNESDFCSVU0S0pzTUxOLzNpMHhycmtoMWF2aXBMbVczSGNINnBUWmJN?=
 =?utf-8?B?RUVmY0Y0YTZqWUVMU2ZkUEY4WnNnL3hMVDVlR0dMb1BtcXIzNG1xcEk0aCs5?=
 =?utf-8?B?UlpUM0FBZHRxUU93dUFlL3pGa2dYYkJkU0JMV1pqWTBqOU1Zc2hWUDFRVTRy?=
 =?utf-8?B?KzlkZlljaSt1VS8vTjlhaW9PY1NFNk12M1kxaXVYYWNRbmJVUElSV0ZoVGtl?=
 =?utf-8?B?Z1cvWXp3M2htdW1EVFdDbVpyTnl2a3lyS3dOcnd1cGdINDBjTjBxRzdzWGVZ?=
 =?utf-8?B?aFQ5VnVpNDJ3eGRxb25rNXh0cG15NGh1OVUxT3ZoSCtMeU92SnNKUDVQcG5Q?=
 =?utf-8?B?S2hiWGxUQjlBRTZYK2RpQjFFeEFCWC8zR0V3RysyWkZWdGY3TU9oWGxiTHdl?=
 =?utf-8?B?dDhBU3dnbW5TUGVaNDI2SzlOZUs4ZFJldnpYaUUvWUljS2ZLcmxGREZ4ZFJa?=
 =?utf-8?B?cWpWU3RCZ0JEUmVvVjdBMTFacVA1ZjZUSXp0QkZldjlGRFM3UFErNDIweDlI?=
 =?utf-8?B?RVhQZVF6NkMvR3FoMU1RTUxLcjJpbDM4dmdnYlpRcXFrMk96UDhCdHk4MlFm?=
 =?utf-8?B?Vm1aTDR3TStEb3FJV0c0RG00OGZKdEFzYW0wWkN6MFgvMzRyeGlZQmxtUHRy?=
 =?utf-8?B?ZFVNcitGWDgzVmFVME1rUjZPSE9JcXk4TGFGaWxablU1RVVBN1FOMkhpaUEx?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BD96345BAA27745A3C44BF4D186C7FF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c9cca8-45a0-427e-5c33-08dab149944e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 20:44:40.4613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCSw/AP4lLm7pdafD5Xyrs4hsvj5sZ3LTkX+/Yd8F+3VxYrrxcfIOtIukdDGgm2wEZLiYaRS4n+/H9Se4TCCpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMTgvMjIgMDY6NTcsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBOb3cgdGhhdCBi
bGtfbXFfZGVzdHJveV9xdWV1ZSBkb2VzIG5vdCByZWxlYXNlIHRoZSBxdWV1ZSByZWZlcmVuY2Us
IHRoZXJlDQo+IGlzIG5vIG5lZWQgZm9yIGEgc2Vjb25kIHF1ZXVlIHJlZmVyZW5jZSB0byBiZSBo
ZWxkIGJ5IHRoZSBzY3NpX2RldmljZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxr
Y2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
