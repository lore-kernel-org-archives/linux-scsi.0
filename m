Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0F7C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiGEG3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiGEG3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:29:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE59BC32;
        Mon,  4 Jul 2022 23:29:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4iNrLSuLwlaQIB4+bjo310BH5jUQphPcdFPU+r60Nee5oZ234O/6pEudzbm6Q0S5eRz3jchL8alYb89u/6rPLXll5KQiRGmX92TKE17Z98LE/1byRYRt+SBlKMM3qDp+1UDcKnlllLKgE+1VXl+zyWqxGmG8dAqWSufmyJ06JZ6K/hXBBEBZdfYdJBg4YvrYI/uXrDc5sU5z9ckqdkRfnv2RFerlTK8aYAaAWCf5lPwJxvC5MTkoFRSa2SF1rR23FC5N8+5KVBqa3BAFuj16ElRg+OMVQT46kJ8WSdmFSvxf8i+f0fItIC8XXEvulg5Ey/Bry1zP3ZXGO6jXU21jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63rg2Jdja4KL2ysB4kTK3fdrjBxd4QhTUYLllCxK5v4=;
 b=WrxYBtyOD3UbU35ok5ANeX11+nHciwoFftJDFauHPg7xy7EfAO6DKjbAkOfV0nuXJIKnR5TwP6+hfUU7WmnbpwP9nRnOBEC/5Trh5gIUbqiwyi6VY0XhazVJDeaUEhh1Pk73DO3TdvmSdrQTAPWsK5Jkr/cG+7DKdIXlegdKN0oBEtzVNl6IHhMe1g1nHQ7nE6UJIyaT5e1HTGbzi4ssBjb/rLtp6OZ7rHux374dvdORsTjZbx30/Toaw5qyWNmk7Uy0qIg3AFrS35D/snNz1iV7bo9vb1VLDYc7QOliJq/ohQKS6spWfufblDWFQVpJxeNn+qIUJz5YUU5V0/wy4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63rg2Jdja4KL2ysB4kTK3fdrjBxd4QhTUYLllCxK5v4=;
 b=S/DhT4Sz76Ym3OGTpAM5LaG4f3mvhKdVT8QKR/7gKOjeye44mDzlcidbQe4J6hQY97jugBzr9il8SCWmEEudfnkKmz3+5lCE1TwCPEcACwTiNbUJpOAQ+TDVpTY0I8YYLWr3xJ32T+4F51Xkb4/ev1dGScJ4ShsJuCprKur4bI0CEU1LTOlKb+CzSa2ayMBmd/tbGRVNKX9KetPJXloh/a0exychGhS0DAZ9arvu6cFPsFOIUZWqQoA6UH39NnbMueC7MbVd8TObN/vufivbXfHydshLES+o3yhXyUz+5Wtr3DgE401OoH70ja1eL3lp9yV1uvp7WvOPjh8V13oyRQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1134.namprd12.prod.outlook.com (2603:10b6:300:c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 06:29:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:29:50 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Thread-Topic: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Thread-Index: AQHYj6P63JXdZnrMME6+VVMZ51uta61vUfuA
Date:   Tue, 5 Jul 2022 06:29:50 +0000
Message-ID: <ec663d63-14f3-550e-cc2e-4c6db8dc1784@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-10-hch@lst.de>
In-Reply-To: <20220704124500.155247-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0637bdb5-6d53-4e14-3576-08da5e4fc381
x-ms-traffictypediagnostic: MWHPR12MB1134:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +5PPtcY9ZqoBo5xt8xAKixD8WjqxWx2BHLFqZErqD4H7DUPf5T3OofZZfLDWFoRAD/3X3iS5ij0eCPJgoNAX8OMwxcfX+8rt4Y7sd0Mg1UC+F1GqYAtX0X2yCZUasSnctV5dHxqQD94knwoyE3TP/dYVzoxkjoxdjIzVaxJZkN+TzADfiSS5zoUtmKuox4Vd9ppJR+eQLOGoCXArd+5dI8l8cFuPAGHJOBJxVjLe1/S/kgo9U4SYKInuSlBs/MqunPYPbRR/N4nbyKJIayJqbHhU59aP+oC33vZaJ7w5EqKJur79dMkZC1n9ng5UbLl6m/3sT2Iw1XEBfqqkQgAgWlZf+CRMh+yY1/oPbb3z+9olec4XxlpyJd8EVHsZ6iBxqi3lPjGcbTHKE4uOApEC9ofDcOsbTVFJX6BAPevCS+rCHuIRV+OHbpijD5YH/dbzzogs/IncQqFCgPPxjMBZNwv3+K6WsmdjVrB53ErMnvux/sJvc8Sx/C6Ywp5BgFl/e88jb4dRqgRKUiTzZYyi3wxIqp/sPCGvQ5P+Ori7qBgZEx7iR3CQdl0Scg3OHgjVjRtGflfqC6sP9gk4NZeHK1K0u71QQwZQixJYYzYIGoSqyPK9NHlgt4UpOs+O2/4QMtgy6pubMCXdh2YWdvz2aidmk3aOxiknV3snmvhqqkBqUpaBBXva8lsYObshP1FnfBugJsbZaFjj2n+/KbVaWraBOu8E1gKlk6xHVxnI1SKGSzb/Odg/0XJydmp2dsUsMEQpaEi4RC3/7rwiwcSSbPzTV32aMX4ekYy2BlmQnEVexZyBF7Uc0QdbKWqMlSXvDrPZMj8mhgFdRC8OJrrcSwdclGZkQFYgG+3CTOzD2XUdl9gCZzqLbyi4+uqA2Db4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(8936002)(31696002)(38100700002)(6486002)(86362001)(478600001)(76116006)(122000001)(66946007)(6512007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(4744005)(5660300002)(2616005)(71200400001)(91956017)(186003)(53546011)(316002)(36756003)(31686004)(54906003)(2906002)(41300700001)(6506007)(83380400001)(38070700005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXFMRS9vWXhEZStWU2czR25tWlBUb3ZiRi9rYVNSTlp6Ujd2Vzl0Y2g2WWJM?=
 =?utf-8?B?RE5jY2JvSlJvVVpydm95LzV4a2ZWK1ZuRWN0azBhUHdXZ2VEVkZJcXRzNGdO?=
 =?utf-8?B?c0hjSU1VcmRVWDBlL0QveW1Eblp1NTdDYVNMbC9LNFZsekhQTnE2dTJlT1BN?=
 =?utf-8?B?YkwzVytTQlF2d2dpVnV6YWJwTmlCS2ExRlBwa2ZxU21vWUhVNE45S2VpMUlS?=
 =?utf-8?B?WE9HU0pJL05na3FFK1N3MG1rRDdFZjhTMW9DdkhQdUpOcmNyODlQRDJIYzBU?=
 =?utf-8?B?dmtrUHlhVm16ZFM5bGltY1NqaXVZOGt6dTEyN3poeWNRdVFCV1Z1MkdVTHJL?=
 =?utf-8?B?UytmUERpeHhUY3BhbGt2M0hSdDV6N1p2ZDF1Rncrb0VmeFBqcTdwN3NkYXFi?=
 =?utf-8?B?enZ4cnhQK2F6em53U0NVM2JKZ2huNTVqa0NZdUdTYU1WRVgxeU5pblBrV2M4?=
 =?utf-8?B?aHVsYXJuOHdzSTk3U00wZWcxK04rdHRUZnJpTWthYmVWNmw1QUFYZVNEdEc2?=
 =?utf-8?B?MWJOa1E4MTljV3FWMVIvWVRQcHZkN0R6MXF0T3BpRjlxU3M2N2RkTENhbW9k?=
 =?utf-8?B?a3hGazg1b1hnZC9QaW0yd3dpcXBVV1BuZm5NTnNsSnNVNDJ6U0k2Mm1uWSt5?=
 =?utf-8?B?S0NDRFh2MXhNdmYvK1U4WEVUVkpWRjNIZ3EwWU9JMGo2Z2xmcmFuMHQ3b3JP?=
 =?utf-8?B?dHBvdFJtSUVEa0xnNHNBYTR1RVZZbmQrK3Z3VG13YTgxS1ZHTXlhM0RBd1dw?=
 =?utf-8?B?aitsZEJ0NE5UZldIeEdpRE5YRTdxak54YlFNSlhNN0poRjBDK1NpZmJMSUp5?=
 =?utf-8?B?Wk1PcnhNNTdhM2VVRDBETXppcVlIYWtXMVY3UlQ5Vnd0eGdCVmFrajNOc1FM?=
 =?utf-8?B?YnBYc29GT0NSa0E0eE9kN1MrSlpOWC9SVnF6cVkwU205bk5teEdmekl5ak9Y?=
 =?utf-8?B?dHp3cmxZUmZDSDdMN0VmNkE5cHVFS3prOGRNWlB6cDAvN1NQYTBRQ2hidVRP?=
 =?utf-8?B?dlhIcUhwaGFsd3JheFVUZHM5VDdCMjVLSzlrNW5CSVQvaU0vQWtITys3a3FL?=
 =?utf-8?B?VmJUdkNLMVNyMWtxQ1VUeGtNY0xLekpJNS9HSm5EaEpyVy80UDJyVVZlcElx?=
 =?utf-8?B?VllMN3RpeEIyaWdHOEllZ0UvZFc3QkpjR3hWbVpoeXhaUkhvanpxaC9VSTJS?=
 =?utf-8?B?K0lVNVJLUW1yaGk2YVRqWjcxSUtnU0RBUE5OeUFsQWRwYWQ0cWZmY0xPZC9B?=
 =?utf-8?B?UytKOEtjdjEzVUN5TzBhd1dFbTh6R0dkRWZINlZXdkczMUhwbXVhNElSNisv?=
 =?utf-8?B?TEpNTTNvTXpUcG1EaCtoaSsyaFc4TytlWjVwTkhkS2pTakY3MG9XSzJQN1pP?=
 =?utf-8?B?SXBnT0w1d2k1UlNnMHh2Q2M0eG9tZVdxRjVJckhLcXp0T2dhaGNreTRiMFZn?=
 =?utf-8?B?Skg2WGpVbDg0eFQyYXRGWXNTK3FVNEdXUnJiM2t4ZnJ6cytPRHBhcXVwY2Zy?=
 =?utf-8?B?MzhPemxlTlg4WElJWDR0b0hSSHVtN3YxWWNHYTU4V3BtUk5BSEhaUFNEOHdh?=
 =?utf-8?B?eDM1YU5hRVF2TE9na09XODFVQWpnNXRwVXNwc2daSEJLUUlwTDA1Unlaclla?=
 =?utf-8?B?WXNqQmJ1ZGt6YTFyMnQzYTZOR2c1T3ROMzV0WkhwdHdVcHVjalZ5Tm9FejA5?=
 =?utf-8?B?c3N2andwemNmbjRrdWVGVXBVUnM4d1NtMlMrQTc5SHQyRkYvZEtxMWhaRmQ2?=
 =?utf-8?B?blpvOUVHNENoQmd1SXYzQklyOUM4aEdtSzRnUlFuUU5VVXF2MTlVQzl4Y2Q2?=
 =?utf-8?B?S2VzV3drRUt2U3JSVjlDNnZEMlB5c1REKzlnYjdqTHZjV1BQZW1neFBCekVP?=
 =?utf-8?B?cHRVV3RSSUpTRVZQa0IySEc3MDZadDRPSGJVZnBqSFRQc2hqZ0Z2VTVaZ2ph?=
 =?utf-8?B?SzZzR0Z6bGVtcDZkRjY2ZzZ2VVRVRjZJT2V0SEhEYUprVmp4bUlUT1NTcTFD?=
 =?utf-8?B?dGFZMzg5dG9BRFBlU1FQRVFsTHR4VU1JcUdqbldqU1pldEd6aW1uSzJCNWx6?=
 =?utf-8?B?UVpoNGE5WXN2T2l6Nm9DR2RiTFl5dHNPOEtZRFA2RzU1RnI4WWFCTW41RU9B?=
 =?utf-8?B?Q2M1T0U4SkltenhXMHJZYzIxZTZ4MnV1YUdVdDhGd1h2K1c0K1ZoU0w5RU1x?=
 =?utf-8?Q?qBxl2DlfTgQfHo5wSqL0+wHaC4UYBbevVxAZpkErRrij?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8E80994445F5942A6C37B8B680A4513@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0637bdb5-6d53-4e14-3576-08da5e4fc381
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:29:50.1486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFOZ0pZzYkIfY3TEwDTXktfcIAwr7UKzAaTKVJmwRAuJLycpBYOu1LfPUjYeBebA8eyiXC4HfRAnimC6E1XHwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFN3aXRjaCB0
byBhIGdlbmRpc2sgYmFzZWQgQVBJIGluIHByZXBhcmF0aW9uIGZvciBtb3ZpbmcgYWxsIHpvbmUg
cmVsYXRlZA0KPiBmaWVsZHMgZnJvbSB0aGUgcmVxdWVzdF9xdWV1ZSB0byB0aGUgZ2VuZGlzay4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAt
LS0NCj4gICBibG9jay9ibGstc2V0dGluZ3MuYyB8IDIgKy0NCj4gICBibG9jay9ibGstem9uZWQu
YyAgICB8IDQgKysrLQ0KPiAgIGJsb2NrL2Jsay5oICAgICAgICAgIHwgNCArKy0tDQo+ICAgMyBm
aWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KDQpSZXZp
ZXdlZC1ieSA6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoN
Cg==
