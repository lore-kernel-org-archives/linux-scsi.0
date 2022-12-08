Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2331C10F1B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 18:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLHSSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 13:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHSSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 13:18:16 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3426818393;
        Thu,  8 Dec 2022 10:18:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgUtZsf3/7mZ2sbg7NhdFKuIcdsVtNV8egKR+ipDwY2Ek/tzLSsfemlB8tU+7+glGxDajQf7hQqD7DcCf6j5DAl5o7LULDiQ4D0llzkUkBYuDkCJteDJDeeZcSOzNpUeXGn61H+4EICe32m0W845xj7DbdazFZEBDpIZWb8ejLzvYW9fOqE22a4DYuiWfWy47xh8unN5lp/yC/jChr7twpJUEpFdWwnownZXcrmTm5FfSnSBI1UsZTmS5ZQZYu96DCnWfy96PHaZjLQQycz+kf9uyHGrc1ayK1owe7oqix6PaRx/4mjospKQ2ItYu/8mMQBxy0WukQiQZQRa1le1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTfkdd/WrH1nvh5LPUMNqYK1VD9vlQnLwULdqtujeFk=;
 b=ocnDOfp5yd0nNHIR7dnFqj4lMPiBoUy9z1ZWcv6uPHurhAr9pP6BP5MwAchwHhoQcehgFcjNkST4KAUkfu7hAoV3D9f4A3ZcS40AaFiMUxdf1P9F26nQXV0K89t60WIMHXDosV33ILjx8bXpw8VIfevGTAbwxFvz3qkcKB2sj4SGQA9kED2GqkNkXrbDkuH1zYiRgJioX5HMBrP2TNAQjN9V+8cxxzZtMFZdRZKMzKtDsXr6QYMlDmDh3Ob3Uqe+YS7QREP8V5A0lwcXN5dnBa4mqA7cVbKTvEzWpxFPUmt7T55BlGYZSCGq0mInW7qJzNqbapMvt6juI31hAw3b6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTfkdd/WrH1nvh5LPUMNqYK1VD9vlQnLwULdqtujeFk=;
 b=eh33BX386LILHhn9P7e+V2z6njj+QDYz+DOa2fhAxFnTSVnPNxIz358/3EAh6LHB4Q3oD9wjqus3W+3wp03GIUFMSjSGX6xmx87ZR3r/7BEEuT4YZFPecJDFsLJSiN1aptvCdFdPpZMwgkYjAbTvcJyvrBdI6W1yDZS5vkkUmzgnrwXSsbaNVZaT7Mb1Lzwp9V/8eZvYw1qIZavy14fe5ABR02k1kiUzV6Gqn30LYiFMKsu0PoHHRufhJ1LzG6lXRm5KmtmckCESSj3jnROl4acDYNTGkacJ5Jc1Aq6ZZvgv7MW89tLwEM6BXsxKdv38PJHEDr4rRtCJdOvbFdVrIg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB5627.namprd12.prod.outlook.com (2603:10b6:303:16a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 18:18:13 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 18:18:13 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 00/25] Add Command Duration Limits support
Thread-Topic: [PATCH 00/25] Add Command Duration Limits support
Thread-Index: AQHZCvSv+0LHvDOnfEyYf+AoCXSCy65kTPSA
Date:   Thu, 8 Dec 2022 18:18:13 +0000
Message-ID: <daff011b-6aeb-e6ba-c71b-8b0ff9a21ef7@nvidia.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB5627:EE_
x-ms-office365-filtering-correlation-id: 861fe052-5b0a-4f70-1ff5-08dad948920a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mrq45Eudbbu8DLXHpziC48pk3ighhkQJq+Mo+pw7BCQQ2VOdHFrQZ5AL+mt5ikh4cKv1z+MJ2cHIlr932JM5xhXxoLSCkY5a9ZDsgId5KxaZq6bkQxToWeicUvBT3d0M8RIFHucEbRWbWFUuiY102YLz0iZRVgA1EHYiYAOg6THX6Y0ICYx+iiZlk6twzTFCD1wzxRODDL7GjpIJGkRrnt+DJS7fsAkQCWkUVcAsWuPrdJPMVRmqZGO/GAuZMl/0tKj2gWkGFwzxCIEEyo72z0xWKSjKk2e8W0UAsg7rHfI3Bbj1woEqRM6EWiJ/DRIvBjuSjRx2PWV7e1dbjlqpnEiAGTt6HAVvpa0ZcbjCxABc4w94QWtdE3g/v87lqSIeMHnNQRZ+2RdYk4z3IQ3xmmmNiFBx+3aoxWHQexd2ucjVHAHJvDLXn3nc60rcO74VdGa1A1YM+yeUZs1QQx5XsnfROkhhjkQvLWWG5zt9vQTEqjlJpXWiwZfhoHrk9pRwk5TJ7pxL1wK1aTwJWdURz8h5r+Bk9K5uw5YoRC5GaG0in2qN1juTXAZg/atU0MecvNGPN4Fl4mvmJCvz1/s+zXv8gdz4kio1I1gycZqGYefyhzbupZYo7P39moEPxg499d4RAISzZQUSZNARLyITX3Y1QSD3QIQBJe9yRhKYsGzPAGnOuWVafBpW7kFY811GM6ZZKcFcgN7WcsxJiF8MCsnOKiYBCfTlgnq2o9h/qe2GEo2+vMPwVr3FGSlUS6Gf9waEV353LwbXvvNQhbKJbVH5KVzhJbjwxVwXZ0h1K6eCcgdQmwgR08tzWp5fiskHUSHjLRTxSt5Qzu6wDEnKO6PvHNrdnI1BoJINUxs9/IcgFdPfFcx5krT5BWWGDFhR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(71200400001)(122000001)(83380400001)(478600001)(8936002)(86362001)(2906002)(31696002)(38070700005)(38100700002)(5660300002)(4326008)(41300700001)(91956017)(64756008)(8676002)(6506007)(66476007)(6512007)(186003)(66556008)(110136005)(2616005)(66946007)(966005)(6486002)(66446008)(31686004)(316002)(76116006)(54906003)(36756003)(43740500002)(45980500001)(200334004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M09FcGV2RnBvN3RzV3MyT3BrV1VLam1pdE9ubytDMlNqZi94RnVpMk9ObE9x?=
 =?utf-8?B?OTJVUWQ5b080RkFBeGFJK05EM0dHcTZHWUtGdnRJeURrTVMyV3RMUk1zdHE1?=
 =?utf-8?B?aytCdGZCaW82MGdhYWdhL3I5ampDT2VSK3E5cjJzc1VlL3FOTnRGM0F1ak84?=
 =?utf-8?B?VEFYZFNlL0tIZS8rVTg4NjR3dGxrSXBWTTUyYU5nMmZHMWdhZVlRck5SVWJk?=
 =?utf-8?B?dlNic0NKOWhaaHdlTTFnTVFhbWJDcDM0eFRPV0FVSHhZVFI5REErUml4S29a?=
 =?utf-8?B?WCtoZ3MvVU9SU1F4KzFocU4wenZJdWc5ZHhSdk9TSlRMSk8rRkdjYVoxbUdY?=
 =?utf-8?B?d0JJOGprYTQ2Tm96K0pZYjR1WWVUTmNYNEsyUDh1VG00L0tpVHVxbjdCYXhJ?=
 =?utf-8?B?REdGV3c1SDJieWY5UlFjOC9yb2lCaXZDMUF1c1FHNWZmOWxTMzVta3ZwVjNs?=
 =?utf-8?B?WlRUMWlJUjU1cFQyUTBlL05TdElkMHlEL0NpVkhQYXY1ellMQzBVZVFHeGIy?=
 =?utf-8?B?dC9EbXVTTnd5TnBQeENOcVNrSGVhSGNDTENjd24zdm1OMGgvMTluRHBma0lH?=
 =?utf-8?B?R2t0TjgzOStMUkc1UXRaSkhTTTcwQmx4YnNMaWxYY3JFWDh1emRyYUZmRWxG?=
 =?utf-8?B?aTJxcjFNL1hMdmpWUXdvbEpPOXBKRXluL0g3WmdxNjIwL3oyQ3ZkRS9ZTWw0?=
 =?utf-8?B?ZkU1NlNsbnhrL0gzWS9iZ01RTjZnY1FCU2M2UVNGTDl5SHhNTWpIWDZjcE03?=
 =?utf-8?B?d1FpQ1RaSXlLSE1vNnZ0eWNEeGdhSUZRU24wRloxNmI4OWtKSVkyQnhUUXNn?=
 =?utf-8?B?NVpZWmsxU052OHpIeUJZcis2d2l2TXlKd2gzZUZjU2FOellkWWdHMlg5aEFU?=
 =?utf-8?B?bGFZbDErdklMQmdhRkk2TEtmdFlpVXppRHVwQkxVb0FWMGZ3bXBqRnV6V0tw?=
 =?utf-8?B?R3FVV2NFVFY4MHdQSExZMmlpMWIxczMyMDdGZ0pRL3pVYnVYcllyTkRaSmVm?=
 =?utf-8?B?elhQZHJmZlBjblNRVllUMHNmT1F4cUJacjlNTDI4cHAwVkVYdW15V0tNQ1JL?=
 =?utf-8?B?OUVGSmZ5OTVTTjJYLzJiK1IxY0VXbkdSL0t0dUEzR01sUTJrUTExYk5MRkdE?=
 =?utf-8?B?ODFNT01OZy9TamVjQWx5bWdHNWwwakF0YW1Dcit3Nit1N1Z5dm1Xb0ZNWXJt?=
 =?utf-8?B?bmgzR3BQZ0JpZVVrV2x4cGp0VG1uQkRzNGdibFMzT1Y4aWhQZ244ajRTL0pD?=
 =?utf-8?B?Z2tiODNBZkQrMkJMUWx0NFR5SjF5NXlzTWhJYzNyRFhUZXdqYWNzQXpTc2t1?=
 =?utf-8?B?TzNRWUY2NzVuRS9BbC9FOFNhUXJkR1RicHJhRy9MbVJPa2djOGs0ZVlnZklp?=
 =?utf-8?B?UUJlaVhWdnJiZEQ4dFdOOFc0a3lGcEdwbmJkUXdNTkUvS0p0c3dOUk9PcTFM?=
 =?utf-8?B?VEtsS0JSY0FDTTZWU09GTVp6UFNLM29IMWt6ODNTVzhEYjFNaTN1T0R0TmM2?=
 =?utf-8?B?aExyRlRrcVpja1ExTDJINTYvNkNpN3ZVQi9WYXBsQlNPL1dqNlg3L1RkZHg1?=
 =?utf-8?B?blprU2pSUUlEVk1ZQ2tsUjVCcHpiWmlSUFZDTEhSclhjN2tTdytlYTBZS2Rs?=
 =?utf-8?B?ZXZ3RkxVT1BadGRYVEVxYWpuNTVtM0d3T1dnbHRZQ25jVVRsVzZ6VXovYTM1?=
 =?utf-8?B?RmpLZDJST2lhblhTeVhvbHE2TU84TkpJRzltcTRUdUJuSUZ5c1gzd1dNQnp3?=
 =?utf-8?B?Q0dkM0xuOUlLK3lOdE1nZ0dJVVBlQTJQMU5EYWk0R212OVY1eTRzOHl5OUJw?=
 =?utf-8?B?OEVGOUszZk00YVRXYU8yYmU2akw4RElXVWJKNThKc0dYYVp6VEpCT2JxczhU?=
 =?utf-8?B?a1FLQ0Zoa2NuT0d5c2F2TlV6c0FYYWtwejZXL0IrSFNzalZXd3FmVlR5YzRx?=
 =?utf-8?B?TG9KcFZ1Y1dOTTg1ZDF5VlNJaHdOdE4vUm1DR2tyRWpiNEI3cXBkNktreW9Y?=
 =?utf-8?B?b0hvUkVDdDBka1ZGdW5IM2xjZ2Q0Q0kxSXV1eG14K2J5NlZnMmhKblFYRGhH?=
 =?utf-8?B?eXF4ekV5Q2VnTjZNR253cmd3Uk9lMTMxVWtTQnpjT0lqRG9vYzdsRGZ2Wmxz?=
 =?utf-8?B?ZmRkNkxibHJPeHI1V2ZVbjNrTTRKeTZXWnEvRDEyUm1aUGZOYS9JbXZkUHl4?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <300E1D6F7CF6C54EAB0AD20D8357678A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861fe052-5b0a-4f70-1ff5-08dad948920a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 18:18:13.6887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTkMhGjKyNA8hOssGmpQJI66lYgVCKkGkzLHKm6Ls9wAwbsVc1tb224N1sPF+zVb58GNF0JsbJ9XvDXnHiREqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5627
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IEtpbmQgcmVnYXJkcywNCj4gTmlrbGFzICYgRGFtaWVuDQo+IA0KPiBEYW1pZW4gTGUgTW9h
bCAoMTQpOg0KPiAgICBhdGE6IGxpYmF0YTogc2ltcGxpZnkgcWNfZmlsbF9ydGYgcG9ydCBvcGVy
YXRpb24gaW50ZXJmYWNlDQo+ICAgIGF0YTogbGliYXRhLXNjc2k6IGltcHJvdmUgYXRhX3Njc2lv
cF9tYWludF9pbigpDQo+ICAgIHNjc2k6IHN1cHBvcnQgcmV0cmlldmluZyBzdWItcGFnZXMgb2Yg
bW9kZSBwYWdlcw0KPiAgICBzY3NpOiBzdXBwb3J0IHNlcnZpY2UgYWN0aW9uIGluIHNjc2lfcmVw
b3J0X29wY29kZSgpDQo+ICAgIGJsb2NrOiBpbnRyb2R1Y2UgZHVyYXRpb24tbGltaXRzIHByaW9y
aXR5IGNsYXNzDQo+ICAgIGJsb2NrOiBpbnRyb2R1Y2UgQkxLX1NUU19EVVJBVElPTl9MSU1JVA0K
PiAgICBhdGE6IGxpYmF0YTogZGV0ZWN0IHN1cHBvcnQgZm9yIGNvbW1hbmQgZHVyYXRpb24gbGlt
aXRzDQo+ICAgIGF0YTogbGliYXRhLXNjc2k6IGhhbmRsZSBDREwgYml0cyBpbiBhdGFfc2NzaW9w
X21haW50X2luKCkNCj4gICAgYXRhOiBsaWJhdGEtc2NzaTogYWRkIHN1cHBvcnQgZm9yIENETCBw
YWdlcyBtb2RlIHNlbnNlDQo+ICAgIGF0YTogbGliYXRhOiBhZGQgQVRBIGZlYXR1cmUgY29udHJv
bCBzdWItcGFnZSB0cmFuc2xhdGlvbg0KPiAgICBhdGE6IGxpYmF0YTogc2V0IHJlYWQvd3JpdGUg
Y29tbWFuZHMgQ0RMIGluZGV4DQo+ICAgIHNjc2k6IHNkOiBkZXRlY3Qgc3VwcG9ydCBmb3IgY29t
bWFuZCBkdXJhdGlvbiBsaW1pdHMNCj4gICAgc2NzaTogc2Q6IHNldCByZWFkL3dyaXRlIGNvbW1h
bmRzIENETCBpbmRleA0KPiAgICBEb2N1bWVudGF0aW9uOiBzeXNmcy1ibG9jay1kZXZpY2U6IGRv
Y3VtZW50IGNvbW1hbmQgZHVyYXRpb24gbGltaXRzDQo+IA0KPiBOaWtsYXMgQ2Fzc2VsICgxMSk6
DQo+ICAgIGF0YTogc2NzaTogcmVuYW1lIGZsYWcgQVRBX1FDRkxBR19GQUlMRUQgdG8gQVRBX1FD
RkxBR19FSA0KPiAgICBhdGE6IGxpYmF0YTogbW92ZSBOQ1EgcmVsYXRlZCBBVEFfREZMQUdzDQo+
ICAgIGF0YTogbGliYXRhOiBmaXggYnJva2VuIE5DUSBjb21tYW5kIHN0YXR1cyBoYW5kbGluZw0K
PiAgICBhdGE6IGxpYmF0YTogcmVzcGVjdCBzdWNjZXNzZnVsbHkgY29tcGxldGVkIGNvbW1hbmRz
IGR1cmluZyBlcnJvcnMNCj4gICAgYXRhOiBsaWJhdGE6IGFsbG93IGF0YV9zY3NpX3NldF9zZW5z
ZSgpIHRvIG5vdCBzZXQgQ0hFQ0tfQ09ORElUSU9ODQo+ICAgIGF0YTogbGliYXRhOiBhbGxvdyBh
dGFfZWhfcmVxdWVzdF9zZW5zZSgpIHRvIG5vdCBzZXQgQ0hFQ0tfQ09ORElUSU9ODQo+ICAgIGF0
YTogbGliYXRhLXNjc2k6IGRvIG5vdCBvdmVyd3JpdGUgU0NTSSBNTCBhbmQgc3RhdHVzIGJ5dGVz
DQo+ICAgIHNjc2k6IGNvcmU6IGFsbG93IGxpYmF0YSB0byBjb21wbGV0ZSBzdWNjZXNzZnVsIGNv
bW1hbmRzIHZpYSBFSA0KPiAgICBzY3NpOiBtb3ZlIGdldF9zY3NpX21sX2J5dGUoKSB0byBzY3Np
X3ByaXYuaA0KPiAgICBzY3NpOiBzZDogaGFuZGxlIHJlYWQvd3JpdGUgQ0RMIHRpbWVvdXQgZmFp
bHVyZXMNCj4gICAgYXRhOiBsaWJhdGE6IGhhbmRsZSBjb21wbGV0aW9uIG9mIENETCBjb21tYW5k
cyB1c2luZyBwb2xpY3kgMHhEDQo+IA0KDQpPdXQgb2YgMjUgcGF0Y2hlcyBsaW51eC1ibG9jayBt
YWlsaW5nIGxpc3Qgb25seSBnb3QgMywNCndhcyB0aGlzIG9uIHB1cnBvc2UgPyBzZWUgdGhpcyBh
bmQgWzFdIDotDQoNCmh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LWJsb2NrJnc9MiZyPTEmcz1D
b21tYW5kK0R1cmF0aW9uK2xpbWl0JnE9Yg0KDQotY2sNCg0KWzFdDQoNCiAgIDcuIDIwMjItMTIt
MDggIFsxXSBbUEFUQ0ggMS80XSBzYml0bWFwOiByZW1vdmUgdW5uZWNlc3NhcnkgDQpjYWxjdWxh
dGlvbiBvIGxpbnV4LWJsbyBLZW1lbmcgU2hpDQogICA4LiAyMDIyLTEyLTA4ICBbMV0gW1BBVENI
IDAvNF0gQSBmZXcgY2xlYW51cCBwYXRjaGVzIGZvciBzYml0bWFwIA0KICAgICBsaW51eC1ibG8g
S2VtZW5nIFNoaQ0KICAgOS4gMjAyMi0xMi0wOCAgWzFdIFtQQVRDSCAyLzRdIHNiaXRtYXA6IHJl
bW92ZSByZWR1bmRhbnQgY2hlY2sgaW4gDQpfX3NiaXQgbGludXgtYmxvIEtlbWVuZyBTaGkNCiAg
MTAuIDIwMjItMTItMDggIFsxXSBbUEFUQ0ggMy80XSBzYml0bWFwOiByZXdyaXRlIA0Kc2JpdG1h
cF9maW5kX2JpdF9pbl9pbmRlIGxpbnV4LWJsbyBLZW1lbmcgU2hpDQogIDExLiAyMDIyLTEyLTA4
ICBbMV0gW1BBVENIIDQvNF0gc2JpdG1hcDogYWRkIHNiaXRtYXBfZmluZF9iaXQgdG8gDQpyZW1v
dmUgciBsaW51eC1ibG8gS2VtZW5nIFNoaQ0KICAxMi4gMjAyMi0xMi0wOCAgWzNdIFJlOiBbUEFU
Q0ggMy85XSBiZnE6IFNwbGl0IHNoYXJlZCBxdWV1ZXMgb24gbW92ZSANCmJldHcgbGludXgtYmxv
IFl1IEt1YWkNCiogMTMuIDIwMjItMTItMDggIFsxXSBbUEFUQ0ggMTUvMjVdIGJsb2NrOiBpbnRy
b2R1Y2UgDQpCTEtfU1RTX0RVUkFUSU9OX0xJTUlUIGxpbnV4LWJsbyBOaWtsYXMgQ2Fzc2VsKg0K
KiAxNC4gMjAyMi0xMi0wOCAgWzFdIFtQQVRDSCAxNC8yNV0gYmxvY2s6IGludHJvZHVjZSBkdXJh
dGlvbi1saW1pdHMgDQpwcmlvcmkgbGludXgtYmxvIE5pa2xhcyBDYXNzZWwqDQoqIDE1LiAyMDIy
LTEyLTA4ICBbMV0gW1BBVENIIDAwLzI1XSBBZGQgQ29tbWFuZCBEdXJhdGlvbiBMaW1pdHMgc3Vw
cG9ydCANCiAgICAgbGludXgtYmxvIE5pa2xhcyBDYXNzZWwqDQogIDE2LiAyMDIyLTEyLTA4ICBb
MV0gW1BBVENIIFY5IDgvOF0gYmxvY2ssIGJmcTogYmFsYW5jZSBJL08gaW5qZWN0aW9uIA0KYW1v
biBsaW51eC1ibG8gUGFvbG8gVmFsZW50ZQ0KICAxNy4gMjAyMi0xMi0wOCAgWzFdIFtQQVRDSCBW
OSA3LzhdIGJsb2NrLCBiZnE6IGluamVjdCBJL08gdG8gDQp1bmRlcnV0aWxpemUgbGludXgtYmxv
IFBhb2xvIFZhbGVudGUNCiAgMTguIDIwMjItMTItMDggIFsxXSBbUEFUQ0ggVjkgNi84XSBibG9j
aywgYmZxOiByZXRyaWV2ZSBpbmRlcGVuZGVudCANCmFjY2VzIGxpbnV4LWJsbyBQYW9sbyBWYWxl
bnRlDQo=
