Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77F1C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiGEG2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiGEG2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:28:44 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAB91182F;
        Mon,  4 Jul 2022 23:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3N+d1VKAGwzRi4qt+P32cV+V2OlvJkBpQSsDIwSYeDzAxPQWnp+VPwEiguXQ4MhNAnrzV6qc/DyscHZ5xQ6TU+CU+tHlx/gq2JDHrpWI/QC7rgpyER+vlwwUL8AdK7xsx3f12ZBYr2SGHN0D0Hkyhfj8mJC9eMydi9xmkYVShgW96WktPvzEWxP6Hfc9LPV8XEjDXyTiBADCIPY99MmJP0oqLlBTD1VsSilc5+jDd/fkqmurZCTaBNxf9SjvKh91Pdvd9QWHOl0l2XZw7oxt4HrTt/oowKlPf2hqaLB92wo74wZO7Z4Te6QCvcJRHFN7VtJIFO0Da0tns7UJNSuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzUpy5L8rBeG/i8G8E/KX9ik6SOM5DoqH4ncPyKdT64=;
 b=KtAa//G9wcbjaLaglxhBTqOSsoRS8+3N1C/SwGuXxCpNwAqTgYle58izxff4QMyoO9ZPveMM15Q7jc0Y2yCGzmxRApFgWf9Z5zfQWc5aUqURTgeDKSliNSf9Vu0SxApHNPGtIbyMJz3Ocnm75dKu0bosU2UD17O6+tPv3XAZKl/WIXqZ57QavpDcM7lVSC4/GB8c89GJNwI1MrVXgeRNV3v0HZgnGlKs4CtuMmldWXPht2hT9uNtzY2UksLqkYVuEVhKdDxRtVkH42hjzGQJKJAUdGH7Z00bpzQ+k1rHAReSpdYvHn8/eMh2UKycyBGpouCfgBSlfel2xaZxr9/ULQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzUpy5L8rBeG/i8G8E/KX9ik6SOM5DoqH4ncPyKdT64=;
 b=QjsnMdNs/D5dnigWrU0vtmGWQjajjePsZKNWDR3WCLN+uprCpCfTpL/EDRFMtYnRr7dVuZhUxp6o1ce/5qcN4/Aa3kceM1nrPIjMTpy2GbG9uhFbNFAtGeDtKX1X/4u19/cuETabGn7DBTjxdj9xsdTrobAYtiVpOXX8/wdJx/JkVIlDuWK1Ji1H4sjkXkn92jyRS6LjVesjR9nO4rpEtpQ2ick/VZj/8lR4jS2WyloiV69wXSaFIH0T8e+KADum5Ah5z/ySfAeGLpb0cxbbZSj+U1fAueg5/G+7FidYSlpyR2unHQZWUsh90aJTW0Pfl211F2zEPeb8mr8AIVKYFg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1134.namprd12.prod.outlook.com (2603:10b6:300:c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 06:28:40 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:28:40 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Thread-Topic: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Thread-Index: AQHYj6P6hHKlh/ItWkKUsxlAzU2th61vUaeA
Date:   Tue, 5 Jul 2022 06:28:40 +0000
Message-ID: <f8a7665b-6faa-e07c-7f21-c4aa5c6fa1ec@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-9-hch@lst.de>
In-Reply-To: <20220704124500.155247-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6979d963-d9f3-432a-fff7-08da5e4f99b7
x-ms-traffictypediagnostic: MWHPR12MB1134:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hZ2M6nhNiVmKgCcn/AJqu5MabN2jqXSk5bc475CoMgX3CZySbikau8uq4/6cmMU4ABZ4UP05d6TJAX/F9KwKPGBNcURtmuSIQ8/5SDE8Hij9sVnO2EKsbYLGIyyz5zD1DRzOQarYzA3hsrMf/Vi6X0Ftjcfv6jSyAhUM9TKk8UjHONLbWjknGCGfSQCud0U6SdAa5/BNX3m+46GnY7IS3HxbN3pVLojWCyavHmceObuNs1Oha7ocmTHxbACH118VvxsdP6oTAzY2oYw7txQKXJKDH1q29fc++LppXLvD80G1NRcvtWWV+q0or1CyhUxNUGjM5YWZg6OVCID2oVn+Dp01/nPuNFXMN8VDTEHnurQmKWqeOKBLmVZkpRt7oHS6uPVTg4zBRGjXHepZaYHaKvejS+EitfiUz7z2yk3e8clJONVKUA9kpH5n8iVWv/e+Zl53EPZp+l5dTEeNEXYJvOvFO6toag/QXgxHJepy9INQ0oa5kCHXFbjuY/X8plrAPOt09wuwshg5UhdiEHrtuJzkvzHF3Dnq6UqNPipdntOe8QYdiV58GQzB+vHI5CkNWMkzz8bh4fv+cNrdHanb2yCOhhO8hVvzo3zkTbmA/fSIyuFDH5u7fOEOVwL5659HZLC+HiQ+1XDl8TZA6+SbWCB+ReRPxGqzO6275C9NMYJTMKFgqsPPcOMoWaidkDmQ+Xe7iF8Fex1wnxeQs4Mzoq6gzF4OvTxtPzkAQDxb8gzO3U+6I12lM5QXaA/bItOllsnHhvq4AnEi/nJuTTnV35JXA1L04eo+Sqyd/Miy9c/cDDyGlMLntnq2C378zoQS8lkwaHSDsEyV14XavFOAxkE8LQpMEma1EU5rKmlCn6ztjscBUVvviL721g+lz4+Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(8936002)(31696002)(38100700002)(6486002)(86362001)(478600001)(76116006)(122000001)(66946007)(6512007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(4744005)(5660300002)(2616005)(71200400001)(91956017)(186003)(53546011)(316002)(36756003)(31686004)(54906003)(2906002)(41300700001)(6506007)(83380400001)(38070700005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTAwUi9mZWxBU3FQMUtSSWh2dnM1ZWZsZG9FV3VQQTdqQ1dja0FXOUxFRXoy?=
 =?utf-8?B?YzNtWlcvbTY0SWh5S0pSV2tKVGluVEtyNnduczBhWEJyRTRTc1VycEFMam9P?=
 =?utf-8?B?bjBRdy9GalRUNDd5S080TmZyVE9pWmRFWEFOSnJDdW1sVXFhVHNFdHROUEN4?=
 =?utf-8?B?emNHbUVVVUFxU2UxVWd6ckFOYkRkZTNwcHZuL3VSOHUxcHUwYTFwUFNaQjV0?=
 =?utf-8?B?N2hoTVhNVEVtamVEUnRhNm5hN2c5TVBSb25VNVVTYTJkRU1UZHFOL0xiNkp1?=
 =?utf-8?B?MFR3NlhsckZadmpSeVQvQjRkcUl4NXRSWUZML1NSZmZodGU4KzlMUmpNdUZX?=
 =?utf-8?B?YUdxT1owdkU0dVBVVWYyUlZlL0x4MHpYbFJjOXRyRVVTYUtWTFFoVmNsTGU0?=
 =?utf-8?B?RTMxOTh5bWk4akpIcm5GM0RqV2doblE3MzQ2TWFKWmYvRHNpUUY2ZnZJajkx?=
 =?utf-8?B?UHhJK1k0cnZkbWZkY1IydVp3TUdURzdObEMvMkYwWE8xSGs5alNqN0JFNlZM?=
 =?utf-8?B?UVlHblc2UTF4Umh0aFp5cXpDb2YvNDc1QzlZenkzbEJoMXYyWVN5REtCazlG?=
 =?utf-8?B?SGhpT1YxekJqdk1NejhmT05UbUJ6T0dIQVhibmZUWS9hcXpmY0FMSUtIcjFL?=
 =?utf-8?B?S1JiRzROSkgrd2hRRGpJUUNkeUFwcE1MOGtDU3dudW5zQ3NZa01NRjJEYS9W?=
 =?utf-8?B?K1E0eXZuMDJTZW5YMFNLeThBVE5BWmNWRzZiQ0hzRi9WVFFSSkRjcGt5S240?=
 =?utf-8?B?bklRRlRpWG4wZ2tWMlQyK1RLNVlobjU1eTFVcm5pVTV3Zk8xVTJVc3Q1Ty9X?=
 =?utf-8?B?aElzSUpBTzk1eEZqMkJFRzN1RkxseDFxYklyN2t1RGlEbUpPdnhCaU51Q3kz?=
 =?utf-8?B?TG42Y0Z2alE4eDk2NUFOUmVxY1duTTlpMklyalE5N21FNzJxU2hhcnJWTFdT?=
 =?utf-8?B?bXh5L3RkWHI2YW1wVlpxWW9lYWpicTNsUnd0aFJzL0lrK0V5dWtVNjhlSExa?=
 =?utf-8?B?VGpwMXdRekRCMm5tcmpkc2dpeTZiSStzWnBGMVl2c0NiK1Q4TXhMOW4zbDNx?=
 =?utf-8?B?WTNnNllKSjRiWjFPb0ZlbVJzSE5YcE5NVUoyUzlCcS9IV2JoRktJYjlkSzRK?=
 =?utf-8?B?Y2tmSnVYVldXUjJNck91YXpiS0w3VmM0RC9neE45V1k5Ky9nK1NoSDlMME1r?=
 =?utf-8?B?dSs0VG5qOVZOc3J6TWdCYmJvUzBRa1NpdHFUNy9hdndRS3ovTnFncFFTMWxo?=
 =?utf-8?B?V095SnFRc2V3YTZlZ0dsbStOeDJrcGEyQnpIL0tHcTkrazlEVTlxMzNqanJ0?=
 =?utf-8?B?T29XYVpsQ0tMaW55VVJybHRuaFhLS3c0TC9EbzNyTXFONTRDUEd5THg3RW9B?=
 =?utf-8?B?ME1TdXhuSml3TE5RZzlXaU1mU29YT0ZHUEVQalNzUzBMMEJHWHdWSy9FZHNN?=
 =?utf-8?B?czN0NzJuMWJnWUg4QTdVakJIWVVpZXV1UDUzSzlmYlJyaWNuNGFBbkdXRFp2?=
 =?utf-8?B?QlZsblpLVkUyeTZieHBtVmlobXFtY0IySVJlcWw3MEtoNnJNWVFIQWZIVUpP?=
 =?utf-8?B?a1c0d2gxRytvNFFIeW5HOUZhM1p2Y3ZRSHNNOW9jZUxoWnNpZnRYM0VlWm1l?=
 =?utf-8?B?WkNMQXZoeHRwVXhNMWpLWkZ3bFlMWXN0cUZFN3MycmdHZ0pCcXd2dnYwdDJG?=
 =?utf-8?B?Z0xOaXI1TjVCV3RRSzE0VDhQQ1pncERXMWZnYmJwU0lUM0lEelBreXRaUE1Y?=
 =?utf-8?B?TTVycmRnaVd0TWxSQlF6WWt2ZGNYeFJQK3JHVVdrY2d5b2lSYndFMkNVMVpx?=
 =?utf-8?B?dzF2dWVicmNCVnNuUXJLYlhhclJ1VmQwcFZaVUtXYTJoMFlMcXNpakkyUEVK?=
 =?utf-8?B?SC9kNzhoRjJPTFNUWUQzVmlVVFdwNUtWSnZDMzdGb0t6V1Z3TExFOExGR1FM?=
 =?utf-8?B?UWc1R054clZRT0IvT3d1R042cnpIemtMWFlqU0IybGYwdzNTSEdKZ2srMWEr?=
 =?utf-8?B?OENpM0taSGM5M1hrd1ZnQlpTQ1dZcEZsSFhzNmhlbUpJaXF5Q1BwS1NCUGRU?=
 =?utf-8?B?bnFyZHZmMjN5ZUl1NHhvS0QrQThBTVNTQmF5UjdGQitOaEdSYXhrT1pXUlRX?=
 =?utf-8?B?dWpSQjdRMUJjU0pkeURFa0liVDhXdEFNaWxCaWpKZFJrQUdOeDY3T3dkOWFq?=
 =?utf-8?Q?9FMPh77EQCuHaIIO0e/qYaYnb/9jWRLpzBpG1TZxvFT+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8688BAB62A6A4D48B38ACCD565C9444B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6979d963-d9f3-432a-fff7-08da5e4f99b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:28:40.0434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tC0bM13cqH66RnMtYsdm+v4vHttQd/gfRyJ8s08sZXMMPh3vg4M1ZL6NEiAkQaRew6qwAMh9ZDM639h7c61w2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFByZXBhcmUg
Zm9yIHN0b3JpbmcgdGhlIHpvbmUgcmVsYXRlZCBmaWVsZCBpbiBzdHJ1Y3QgZ2VuZGlzayBpbnN0
ZWFkDQo+IG9mIHN0cnVjdCByZXF1ZXN0X3F1ZXVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgIGJsb2NrL2Jsay1zZXR0aW5n
cy5jICAgICAgICAgICB8IDkgKysrKystLS0tDQo+ICAgYmxvY2svcGFydGl0aW9ucy9jb3JlLmMg
ICAgICAgIHwgMiArLQ0KPiAgIGRyaXZlcnMvYmxvY2svbnVsbF9ibGsvem9uZWQuYyB8IDIgKy0N
Cj4gICBkcml2ZXJzL252bWUvaG9zdC96bnMuYyAgICAgICAgfCAyICstDQo+ICAgZHJpdmVycy9z
Y3NpL3NkLmMgICAgICAgICAgICAgIHwgNiArKystLS0NCj4gICBkcml2ZXJzL3Njc2kvc2RfemJj
LmMgICAgICAgICAgfCAyICstDQo+ICAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAgICAgICAgIHwg
MiArLQ0KPiAgIDcgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25z
KC0pDQo+IA0KDQpSZXZpZXdlZC1ieSA6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5j
b20+DQoNCi1jaw0KDQoNCg==
