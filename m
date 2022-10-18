Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A490C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJRUp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJRUp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:45:26 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6268474B9C;
        Tue, 18 Oct 2022 13:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0h5z6f3Usn6HR4OrUEO4NC7UqhsvXgo+fg0ox5INwhEJHSZUDbcZpegTGIl0wxuAv8k7JgsDFmBhC48mnFai7cfa5B3AliC2xB4CIDn673EOga8D17/gWsJSdJ8hp5LlRc3MtTghsADJxWbvOMqfTyM0RvGOQRN5W9LlWPi1CBn+/gOD1NewU7L8mdbHe3SUYoVAkBiPS+ZkYBdx5TpJALoNbKm9PlykhgCDC9fEERPyzDDWnA20g1+Cgs2BNrglE43Q5btNDvZdXtsWMgXEzHexPQ0MCMTKvCLK7pXbV8BSILv2iLPHkf89QvItjW5AGwkwCIGg8zPf6O9bNKcng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrapT9oO1GWXncBIaLT6fCoICWlBYI1DI3TUNjtGo1A=;
 b=JwQCJ1hwDOp777zJZZw2qoEOcWcM3GGD9mRpoIpK4aV3jSFVCCAXSkoL8Xa4PUUsh1gw1j64Oo8e96mpeAL50y3SBtfkR6jaKbGqLiUonX1Xd5JWEh+1TxIwSd98Fh9gZETlUC5ggb0GI5Bl76sylbVnXWgwXEJz5tnbzaPr3/j+XW18mFadosZQDKYZLkQbqVV/BSVtI8P+jATpQ49HImu6TCWg2n+snQwPv4T4HeQGfRvsaIHTRpiMiJQJMqyVN/Cqc/vFTSs0kd6Mzs186nFfLK/8kzT2fluoYT180QAmtkpuWfwe4NG3C+p562OvdAh2sHSTf+KrdQ4Yjd2i5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrapT9oO1GWXncBIaLT6fCoICWlBYI1DI3TUNjtGo1A=;
 b=aDb8RcNjjEJKYDP4ivsGwNIY/AeMTbgvmdh9EGxrHnHT6AD9IIenKdpAjPB9YE4bUnMc8/8god5Bu2iWwNlGnAGJ3+ZUQXt+wvi0SvAOGNPotg0yzl4rC62a4W8Rti3gOK12tZ4lvN/HbmS3j1XwJ+CzcMw9DHFG15oXgKRzPzOXKPI/tTS1Cd4HbntW9k8z76cG17wqg577a0HW95oS2Ox9KrEaQzgFJdMRXYIkv2ZbUmDD5H/g+iMUyMzG2LOdgjLTy9Sc9YJd4KfkuH0bnCvXTSY3ioIHadZa7l1ewBuuxP05AzFsa/arfBFfI+wCAiApkCds8KGbZr563E8ESA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ0PR12MB5663.namprd12.prod.outlook.com (2603:10b6:a03:42a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 20:45:24 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 20:45:24 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 4/4] nvme-apple: remove an extra queue reference
Thread-Topic: [PATCH 4/4] nvme-apple: remove an extra queue reference
Thread-Index: AQHY4vmj1QRbDvKubE+CL925p7g/4q4UnyOA
Date:   Tue, 18 Oct 2022 20:45:24 +0000
Message-ID: <5ae6ee5f-f8f6-d547-1c76-a5da90cb2de8@nvidia.com>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-5-hch@lst.de>
In-Reply-To: <20221018135720.670094-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SJ0PR12MB5663:EE_
x-ms-office365-filtering-correlation-id: 7bd9c85f-2a61-44e1-12f3-08dab149ae45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oLf1izCh+W5M2gDWnvFVYB4wdp7X5iOqVlyQckOoie51IzuggnTm7gJsFWwK2IqkAp4D9LKS/G1gxDGH9ayD8Dtw8JmQmkGr7vUadr5U7yOoDTTcrMMXQOzYug2qADMcnpUT9nQ5oZ6BALLBiGNGGdAs8i95bsXlF+rD/IkejyA90k/pt0G8h/s6Vj6AyH/LYXoMZIZOGU9jSyTuEWk4/5cIqccz0//rzn40QWQLtv0hCR1PCx4+4+Yp75Ibl7KEmIUCwiaYOW7kuFZ6u0+srb1S7px7fMrhr3afqbr+/L8GolSWm5TqGPWwpJ6vq+LsVwX+B+g+DX+acfxqwimD90jEtgyEYV/QMRCVcRQ1lYR5u+yzD3E1xx7Nt0M4GzTnnAlGlKrbHR+shAoqqQ5eFk7sxlvOf3HakF0Wez8/HRwIof4VnFz1ho0+jxOjwF8Q1Rvb22NahLUZ3ZLQkbCuqtu+pQXPKuq9Mgl09dhBB6ry4QdKszNEvsVKEw2A80k+Z2fkUlwi81be7V9hzUWGdaVi0r/gVZU7XYy1L6Wjy5wq491ZDTIsv3F6wdbYm8cWDR02tGlO5fbVLj+fxFNBitm8b1EDBdZ8Zi8kuDx8MT7jSRg7MVbdYpnA/CZyze558H8pILDWlhbXs6eJasQIjR3hkjexe2T/m8tbLDIzETSx0RcEubqGWg3pyDFalExs9kTudxkmwvAeOALHaJgTxWV1YugSQU096hSluuGIt3jeZOYO3acOhfYi/gCUmONMVr9hdnkZT5X4B4LsxhrX6X1tjMJxfB/Z83uok/CyNS67mnbv8FhMwczfqi4rx2dWP3YIcGLhHYlSljhul7qwgvoyTzebmsjPU0SKe6DDDtc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(47660400002)(451199015)(36756003)(122000001)(38070700005)(2906002)(8676002)(66556008)(86362001)(31696002)(66446008)(558084003)(38100700002)(2616005)(64756008)(66476007)(66946007)(91956017)(76116006)(54906003)(110136005)(478600001)(4326008)(316002)(5660300002)(41300700001)(7416002)(8936002)(186003)(83380400001)(6486002)(71200400001)(53546011)(6506007)(6512007)(31686004)(46800400005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDJUSXNBMTBycUhIZVVkRE0rZ3JpMm9qTURCYTVpdTVFUmZtcWhMektpRVZs?=
 =?utf-8?B?UWlkZUpBeGtTaFFxL01uQXZwUFdoT29FK2N1NFNtNWtkaHRwY21OWmNwaHU0?=
 =?utf-8?B?TnFvT0FsZzRFZ2g1a3RJNXhiRHR0WDE0WDU5dVFLUG9Cb3Y4cW1lak13WHdp?=
 =?utf-8?B?M1pzM2dyell3UFFVaVJYOHRjS0cvYTUyMVIyTkNPSEkzdUpuRTNQdlNEN0I5?=
 =?utf-8?B?SSt1Zy9ERmhDUG9nV2ZlcGJTQTNYdzFYT3c4NThzc2hERUJkVlRpNjdYeTRG?=
 =?utf-8?B?OXhkV295M09FM25GZGJiaHZrcjVvdU5lT2lmbUVqbXdQQ21BYUliZHpHbXlQ?=
 =?utf-8?B?cWh6SCtyTCtJRml3OHE2ZmdVUUlMa0hCUElMV2NaV0UweTRGTnVLaE85M1l1?=
 =?utf-8?B?SFVLbG5vcUtvUFNDU01nOWh0WW5welRPQmxzcVpPdnNnTjF4a0hQNmp6TXJ3?=
 =?utf-8?B?bWVDMGNaeWx5OXhQZE05aFRiUmIvOGFlWEI2VisyWXR2RXRTTWpaOHdha3FC?=
 =?utf-8?B?aFVtVnNSbThYVGs1S3FsNWZ3dEJyTVpQdTJCYUJpdHllVHlTUytvdWkxNTU1?=
 =?utf-8?B?OHM4eFVIOEVVSkY2QXZaUlc0WDE5bWNiMWpQTnYwSG1NTVNaNVlqRmxvaVZt?=
 =?utf-8?B?MHNYa3c5YkNiZlhWRHRyQ3hRVGdOVngxRHIxR0dkMmE3c3NNTllIVzBWcU91?=
 =?utf-8?B?TDlpMjVLMElWWndwSERwcVpzRDFVVmREMXd0N0l0bGphQzZPbXM2VHRoaEdY?=
 =?utf-8?B?MFFjdENURG1jQXNLVTg0UTYwS3U2ZjV4L0N3SktXd29OWlNpeFlTUDNYcHJR?=
 =?utf-8?B?RVpkcFFUdGZoWFhBUytHRHM0a2NDVUcxdG41d1U3SjFTOVN4M0h1akx5VGRh?=
 =?utf-8?B?OEp2RmlGZ3ZFRGMxMTZVdXIrZ3NPWmwrTnAzRlQyKzRvM1hkVHBZU1hHYnZP?=
 =?utf-8?B?czl6b1ZaNWNpWk42OE5tczJPVTYydTZ1dVhMZCtNNlRsNUxhNCtQOW9oTGhN?=
 =?utf-8?B?dTZTbFZxbWM4TUtEaWo5UlBCbEg1cmkvbzVSZG9WWXFPY2JLSnRnYmlMekYy?=
 =?utf-8?B?U0VyWVB3dHErdzhlbnNxREpZbHZLT3F5VVIySkJ6RjJnOUNadk1vSmtwMURQ?=
 =?utf-8?B?d09uYktTUkYveWFhM1NmYk1QSXppM0ZURDFKMk9CYUtTb29maWhpbGx0aHFU?=
 =?utf-8?B?ZW5OM0swYi9VWWlwZ0s2UlRhUTRQc0U1RGdOUW9wWlVJSTNwSEkvTE5Td0xN?=
 =?utf-8?B?Mm9lTGdleDVFUVRMRXpVczVPdzhsS0psNGVQZ3RyRUxtbS9VMGViQU12SXIr?=
 =?utf-8?B?ZFJxdDkxVjd4dmNGNFpDSTJ3UFU1YlhPeVZHbHJYQkJib1pCSWhNZFRLR1hz?=
 =?utf-8?B?OHcyVStXWk00bG96bThZWFpBTFhvS2xya1VTNFFMYW5nT0R5UmkyYzZFejJL?=
 =?utf-8?B?UlRuOU9yM3dZc0NWMlNHMGFPN1pkdmpkTmdTeHppTTltUkl5d2NBcmNkTUJw?=
 =?utf-8?B?TmlHMHczdkJZbENXb3h5WHdBcTZLdkRxaGpNTjlHeG1XR1ZwejVNUi9yU1R6?=
 =?utf-8?B?QnFUbHZRZDZFYzZHdHN6UmJ3NzBFcnFTYlV4TjV1ellDbFhBTTJPbUJtWFR1?=
 =?utf-8?B?RVh5QW80VlNyVy9uUkhXTFl1TXp5U1MwUXk4VkhzTkxITkRGMzhLcG1CNTcr?=
 =?utf-8?B?VkJjbkZxdU42M3h3UTlnSXJqYUZFZ1gvZEpIVTdQZlNuczNaaVUwTWw3SHdi?=
 =?utf-8?B?TVpkZ2tDeE5xaW9tdzhwSW15NzVXdDZkLzZPWE9rK0J2VXJNenJMM1FVaUla?=
 =?utf-8?B?cVZXL0tURTZjdEZyMlI1WHprdlA5eTMzVkQ1SURacjdOT04rYTRLc3Z3UTN4?=
 =?utf-8?B?TDJhMGpPZ0dKRU5EeHJlL2xuMlhBNDZrcmg3R3ZyYitHSndzUjhlWllDTmNT?=
 =?utf-8?B?aUl3dzhaT054ek93R1V6aFNwWEVTL084VTJvOGJPVlpzcnIyeVpWdWwwYXYz?=
 =?utf-8?B?RmRCcXhWc08rS1lJNk82TnRsU0dtVzJQeW45QTU5dU15RWJVejlzZlBnNHRD?=
 =?utf-8?B?ZVFyaTZkUTV2aUw2cjJ3b3g4M05ld0FYYjM4Tjk0WGl2WEpFdWM0TmdQa080?=
 =?utf-8?B?Um5mOTFRSlZUdmlaNmwvK0w4bDFFVjY0ekVtQU1qSTJMSER2c2lHNnl3MnFo?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12EFA2767C52F645B7FBDBA9D4DEA0B0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd9c85f-2a61-44e1-12f3-08dab149ae45
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 20:45:24.0369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w9a3fooNNZABCuspzLyl8zDJKjpCcA9F6eGLUDO+Wm41MTeh/7kFnkYW4ARL4QCBidy97cF/iuF0ejriOY05Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5663
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMTgvMjIgMDY6NTcsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBOb3cgdGhhdCBi
bGtfbXFfZGVzdHJveV9xdWV1ZSBkb2VzIG5vdCByZWxlYXNlIHRoZSBxdWV1ZSByZWZlcmVuY2Us
IHRoZXJlDQo+IGlzIG5vIG5lZWQgZm9yIGEgc2Vjb25kIGFkbWluIHF1ZXVlIHJlZmVyZW5jZSB0
byBiZSBoZWxkIGJ5IHRoZQ0KPiBhcHBsZV9udm1lIHN0cnVjdHVyZS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQpSZXZpZXdlZC1ieTogQ2hh
aXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg==
