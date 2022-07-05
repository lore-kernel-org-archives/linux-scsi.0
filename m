Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF940C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiGEGoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGEGoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:44:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E4F5F50;
        Mon,  4 Jul 2022 23:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoDlATjnDqapp7PewX/FR5UwYR5kVZIPDo7CeJ0I2XYv2Fv5ikCLHOLsHeMwkZD8WoBXfPFfWpxRGfbmWFkGRk3xPJtLExyW4EpXeOZo56avmOiGfQHMDcQAbRL+3ETg2hgKR6uVYlB4KBdFwZcVBembDhepkvwUn4BHWJIDRDwBTI2b8u1s9PUAU9yl1AAYC7QDYT1dxgbeSbtYMXr2YTURjPOFwg8CJNpBAHOkL4XPuAe8efy/hzT2OYc6AGNeXHRwWOwYhbtKZrFHN+4w1eZoZMm5G6nKEt8T+G8U83YNclSX43qCyKHZH9e9lfbq9pCWSNLg7qLNQ7iH8sImgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJeikLmqkKfxxcglfX9TsUv0FEqXRtDhGRRc2ZHlo6o=;
 b=MTuuL1Q5JhtjU4XY+byuhEiqftk80Vb3BWjRX4T7nsJMujl55hbP6vZ7zdbv+pjgw1OhCGmm9BgW3R4fEgDdO06go8Kzj9WLpZ7MHs4x5ushuVIi+/Z2L2VuHNtmSRUvQOsVvAyJyhK2xxunkFEOMrrdgkYJxTEat/dF4BY8l/bk71V+uNLIMzuMrlfAaMHC6LOUzuDtRhvbr20pEBukXQDsgh5PFXKPCUueJ8NnTtUYJt8g9p6e8K1n41kZQC0VSNfOf3XCMQHWgT8OnvoN8kceyhC670vkqiABjcUST/w3Gn02ThkEtevEW8l51qmwyp+hcBtTtZlDyhiRSoXn/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJeikLmqkKfxxcglfX9TsUv0FEqXRtDhGRRc2ZHlo6o=;
 b=GbGNDhAr0ZX7HTYRhkZLoLQP1+mG6QBmBKCr8CWKc3yXxpBootvcmnTEIZ17iUrKZeysL5ReaI9NL9CcCqf3rDlkCX0XLtRsP4UUC52iuxjnsi7QXUCAoalRH6MbQH3EoJkkx/0Gm/wA15mjJOzBEmYOJIw3lR1J9GZEGqy/gPnixQ+uGu5Iae1XaAL2Njq+aI6aBnHAVgRVK2SilTPNMYbNOuUSDpUqrPVrRbDJEZB57dlOcodruXS5KTlZmBq2B9kKbZ+E+DsdoRhYLa3OJAe8ANwWApnCoRQtJz7s+htisZ/cSlJXVbmLQF+4rJCT+/YkbSiNBOB7deiXH9e5xw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 06:44:05 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:44:04 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 16/17] block: remove blk_queue_zone_sectors
Thread-Topic: [PATCH 16/17] block: remove blk_queue_zone_sectors
Thread-Index: AQHYj6QOTS7ygGc31U2GItgion9Bjq1vVfSA
Date:   Tue, 5 Jul 2022 06:44:04 +0000
Message-ID: <a9449447-a078-a37f-0db9-ecafee70e2e7@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-17-hch@lst.de>
In-Reply-To: <20220704124500.155247-17-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a95bf6a1-162f-448e-6e02-08da5e51c0a3
x-ms-traffictypediagnostic: SN6PR12MB2846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 82yceVZ1HkW4DZJDrO+tsnw7VE7D0jc6dFcHQVEZnb5lYn/UmcGTKhuMbmNcJG+94xpVijAZ63KL/QrqFtSKEOPuiJjLYxOASVLyj0kpoj96y39gBpfHT4yuSCW+y7NHsaiN1siGwryEE99JSzCKGTXyQIwSwKgVUOy2c6Iw81SL59VfS3fH405v6S7mgpYw74inBGJvhuS+uxdJEkGW328QU4kZpM60cmGxxfEPkmOI9CLBdzz9iUnkvbFnD+s8tbqF5govktY0mTI7TStFVV3b20nyPEWsmbc9XmYQX1G9sNSI3xZ2m8UvbWxKd75fzsiqYMkeh9gKEqYGzBkI3ZQeiJyNKgD4Zzm954BKD8dS7nXczweb8hTlJY7xODdu0LcJlaSvsa/LAAxjMBuq8yPDuuusEztblGMRF8TldXsnbpjPWXv01FfZ8X7Qv1tg9QxzZACAfuWzrXVLCCLdMOVZHwCtR481mqqk7opEtreW9QjBkcbKyZAkeWNq+Eja8IsUQ6PSZ85xmACtJrJ6JkjReKhNP9ZEwKCssAmYQMHA5lEfzFM6epeeOHgW/3nhC1kQdZKpn7CWHv19fHKIaAKgrmEIgmMBuVPDvjr3msmcLoRPD9K+SJGjFoB9DH7a1S0BveiJOLroCJiSY8ZnlFTeyaYPxTNczRHSb+YsCiFlhVYaNYjlhnLIF7hMq19ecRhuOgUspmSfILfY7NpIiRcfqka3/qp0hqd2yRBAu4SKb1tkw8yEcNw3EJQll3kDPk1A501dOGaqeFRlB1C9UaBbYyCWeyso+TxHXo1lt1h6LwVThXm4kw1arwpcwjeaf/0RhQhAjVLmiu25bo1NUT4AvdZTSC8YsYU9lovjn/gILjlQ+kePno7kQD96z55g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(6512007)(53546011)(71200400001)(478600001)(2906002)(6506007)(41300700001)(31686004)(4326008)(86362001)(31696002)(558084003)(36756003)(122000001)(38070700005)(38100700002)(6486002)(8676002)(110136005)(186003)(2616005)(5660300002)(316002)(54906003)(8936002)(66946007)(66476007)(64756008)(91956017)(76116006)(66446008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3BRZ1I1b3VjQWZBaXFYY0pBSndpcDM2Q0NSSjJZbkZ0eThxWXFGZTZMMXN0?=
 =?utf-8?B?V0NPV2dtS0VSNjBmbEk0MDJJejVCTW00STl3N0ZtS0VnQUhCWElVL2I0cEtu?=
 =?utf-8?B?dTlGb0JRZ2Z3Tm5hMmZVWGxzOTM3ejZIWGdUN1VwOTRNdHB1Y3pEc2JWMngx?=
 =?utf-8?B?Vmt4bGY4THc4UWJJbU8wanQ4Zy9UVkc3dEZJUkNQRXV2VC9URXkrOExlK0xr?=
 =?utf-8?B?ekxJOUpVTkFxbTg1RnluQ2Myd3NCQUk3bCtJekRjeWtDeDNVU2UrRHE4WE9U?=
 =?utf-8?B?dFlUUWplbHRsNE1ZK01nQXF5NmpLRFhwSitiMEZwMEgzbHpJaTlHQ3VlNkM3?=
 =?utf-8?B?Uk83REZkM2xqY3ZtQnNUdFpnbDAxWEg1aVNPbGNGNGRvdXRzWlV1bGYrWHFQ?=
 =?utf-8?B?dHNGRGg5NUxmWWFGbSs0RzBHZ3RhaXAvVUMzalA4ZXpwdWtDVVpnN2h1TXdJ?=
 =?utf-8?B?OTI3aFFTY0VONkVHWVViUjRqYlN1NkdaVTkyRFdnejRFcFZ6aXZlT0ZSZ0FF?=
 =?utf-8?B?aitsVW1hcDJjK0MxWHNmVnlGYXBXaklCaDJhalJUWDNDU0diVWRjSDZ2QWo2?=
 =?utf-8?B?UDZWSC9YSkgxTExHbVZEV00rcm0ySmh3dHcrWnhBUVYrdURRakNtZENWTi9a?=
 =?utf-8?B?akpnUnY2ZmY3c1YxMWxLbEx6TXhJSWFyZlNWV3BDTTZtY2xuTm1uUWRlblN0?=
 =?utf-8?B?QWxPS2RzUyt0SnBLemFoR1pycGRiVmNHOUUvekE3MEo3Mk1KUC9jd2ZsSHhm?=
 =?utf-8?B?dExKTDdKTE9oRWU4ZHlVUWFwdnFON0RqdmJ6RXU4R2J1T0dscjBwL3dVWDdX?=
 =?utf-8?B?UkI5Z0hYbjlWSXJBdjdzLzFTT1hVQTBPTFB0ZThvZGsyK0dQU1NwUmpSa2NW?=
 =?utf-8?B?NUdXd2MwNGtTN0VwZFNGMlR4WVBYV2RONXM5U2RlaEIrVlBDbjNXakoyZmxB?=
 =?utf-8?B?MGFRV28xSmVYSUw3OTR0c3dtS05INjk2WEFGaWMxK3FuYTF3UjJxSjlCK1dx?=
 =?utf-8?B?ZW00WllvTmxQa2tDeVlWY3Y4MzZQTG5BcWJQQjhMb0VxZnU5NmNBbk9lVGNO?=
 =?utf-8?B?QStWTHpKMzhSYUpiM0ZYWWZxZGNJR2Q1L0diSGUzMEpkNkJOOEkvbGhuQ2xp?=
 =?utf-8?B?dktHLzZHTms0SlczQzRXc3hyZnpkZEltL2h3ajJUNGc5TFNXVXBmYjFETW1X?=
 =?utf-8?B?SjBHK1JCY3o5QWNXY2lOTlNxVS9GSVFONzJCdFVBdUQ3OUJYb0dDTGIyVHpY?=
 =?utf-8?B?bXY5VSttWjBhSk13by9UK05wMFFyMG54TzJUSEw5WEJhZm1KamZNeUF0Nno2?=
 =?utf-8?B?SUZKdXFqSTlGdHNVTnFNNXA4bHJnL2s2QnBNKzZvdjllOEp6MGNDYW1DRjJS?=
 =?utf-8?B?YXJwWnd6YXVCeVBxQSsvcW45b2tneGtjbm5KM05WVGtBVTZNNzJJdkl5U1NC?=
 =?utf-8?B?ODVjcHlXOHpJZkl1bUgxck9WM0JweUdhbWwzRGpYTGhnMnl6NEVYNmlkNHQz?=
 =?utf-8?B?MzBFdlQ4cE5BcnAwVGw2MENKWE5OaFprV2ZtUmpPK1kveXAyVEFOTjNXaUtn?=
 =?utf-8?B?K2NaaythYjNGdXEyL3djYkJsSHBNeWRQR05scDc2SDliWkY5RExtYW1tZFRr?=
 =?utf-8?B?UkpzSTV0V3hNQlVmSHg1NGR4UjlrWXdhdjQvOEwyVm43cFhuemZ3L3p4Lzdu?=
 =?utf-8?B?OGsvNnRtdVRZOHg3NFJSSGMxcVlSNGJpbVVMdi9SRjlVWU1yS01xK3F2UjlM?=
 =?utf-8?B?NThabFdXT1hlNk9BMlFpMWlHS2RObm5xMXFpa2svWGRpNGRyZ2M3MEY1Ym5U?=
 =?utf-8?B?L2hucTVMK2J2N0VvSWtaNUNUS0dNWFVzQWM1ck5lMTdBVENiTzNteW9tcUdG?=
 =?utf-8?B?T1VLajVKZ09jcUl1L21rYk5zeVZGbXV1UHlUbWt4bkZseDUwcitzcTV4T01M?=
 =?utf-8?B?VWJpSEpjb2JuTnNxenVQOFFtUlhNd3FvM2pJU3E3Mkh3R3Zjd0ZSVlFhTFNU?=
 =?utf-8?B?SnBFalFIK3UvbmQrbkw4Wjh6eXpSanR4WkdpS2pvZlNJOEVUbWgwUEJCN3Zo?=
 =?utf-8?B?dkZhSXI0MTV5bmhYNFJhdUp0QWppaG54OGszZHpWajJYR0ZranBoU0p3cDBq?=
 =?utf-8?B?Sy9ybFJyY1NRclh5bkpRTUhCaFVheUpXVSt2cUZaM0swdDNVSEhabVlWZ3Ry?=
 =?utf-8?Q?dp1shvAm6YW8B+XosiBKbRPq4gizSC6KFuAlONimf+Ki?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FF7C5A004A78F4F8B238A5020DB9713@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a95bf6a1-162f-448e-6e02-08da5e51c0a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:44:04.3488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vLNT3RXAzdiddVCOnSHDCqYstoj75KUQ60+ABxubCUChnUjab5MzrqCRCliN4dfRS8XdOxLgK5wIujBSYPNobQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFsd2F5cyB1
c2UgYmRldl96b25lX3NlY3RvcnMgaW5zdGVhZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlz
dG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnkgOiBDaGFpdGFu
eWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
