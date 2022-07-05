Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916E0C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGEG0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGEG0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:26:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF0A1AB;
        Mon,  4 Jul 2022 23:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOGAbisC3EW493LRvFHIZmC+/SecCXjrgkKsRwajZbIkahIpf2n/uRyDuFCrOu5kqGBvTw2yKpphZou/q9zrHtYZ4trrVCtvbAEJApQDjPVdOXKmeTu34BPDTURkADbqu/vo+IhvE5o7xL2G6yGKPsIdgScGKG1WrhNZGMLgkwCh/DGljep3h40Zg5XrTT1uPvSUOJckl5wWuB4ZXEedtu9j5Kc1n9wRn6INqfFRlXjVickj+yRgHoXvF26lFUlJgqR1/hXn+An+2wOZXgIDqA2gJEXAjVjZQSSSzCN1chBYguc1Y9XKFyupELJ8iODPQCE8b2cUrhFHi0ztWc+bqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+PTY4aWJ1PQqZIY6nwOiZDE66gadcCRpjb8LlbAJLA=;
 b=CUx+5OeZHiKTL6LMbEzyNmKZTBXaAyurvwOEudVpejZS69F+EuAbNVSqZWududSdQG0snnQPJOjz77wHJFbqSd07CZ6Y7kYL+ZRic1viPbTr6WQmnqo2skWy87QUEIqOgNCf1uA1zSU24/tiw355d/m1+1F7SkgNMQZfKV7gyGsDvMlTo8PPqtbFQTVE8UvPmT/J7irtPwHLJS2m7auRg1nazjqXSf3qlhvO4shSgAXGnQm5Tn+CLtaWW0o4grcr6Sl6UrA12ok5wUDD1QBW9vThoxRbCO0bVp1VGbxSkteVCClDLQ78mvQ2ZEM+uWuoBojUZ3fx4Ogxqplgcvr08Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+PTY4aWJ1PQqZIY6nwOiZDE66gadcCRpjb8LlbAJLA=;
 b=Kb6cvQ3s1cXSWQTdFdbPcW5pCTch/fWxkg+5z2QAnhNA+PvbX+rHFQfVTBtgvjyn+DzfVD2CPCCO1Mn0qNyHQUr8cM+uL0T9S8jIegnUXCH1pxJu4T12QSIpjcVvFxYvo8TgF+khrwQ0bXZIajQLkB/eKtXovy3bZR66OqE5K95+w5qow2BTpsHQULAZRnrFlWW02lHD3RU1JagatK/dIsEwzJBPiDgDCD4OnDIofnZIcLlz+yD39N/12jOj+Kn4e6zA6zmFJYclo26RTjmfGFrpmq7EC5EsK5lE03c5DxkazuAx8B7/qO0pADVHyGPPi4BgkCTX2IvZlJdCF1LR/w==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:25:58 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:25:58 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Thread-Topic: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Thread-Index: AQHYj6PzAMv498bCbUytQMJb/PvPEq1vUOaA
Date:   Tue, 5 Jul 2022 06:25:58 +0000
Message-ID: <89a89371-c606-e1cf-d707-2f87bdad6ffb@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
In-Reply-To: <20220704124500.155247-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc21c5aa-3c4f-4bea-a9b1-08da5e4f395e
x-ms-traffictypediagnostic: MW3PR12MB4523:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BqXpG7uxW921hC6PW3OPCJe0jPFOG7SKKK2RaqUK4CWcjbejHssfOXYl7Prb0QcstmmvMFeRU8yivmQSw0AJvXOHN6dJVPfb5aeBxwNFtAZUovwPW1eQQMwGzBfK7KGJXr0eksUy8x55tJOMUaO1F7JotVRQ0Ml3vmF+COVImqsa6md8QaUXvSaPgzqnzOgoIDuJG5TaBZRO+8qx/oJV6E283a45t1XtSIy5GAfoxtlWG+iZ+4xHp6KE8g84tZBfA48CQiQTbj9OuD7zyw+HH3YDDqk9mRys7OHO20WTbC4l3JPorOvU6RwF4Ov+MFTU7YBbQZy/VXTdJ6uLNQ5mjhgur21VXuE8sZ2WfKlzULRhxgJM45oMinolDIhiu+Sl1TeqJf/NQFDK4OPrv75bm90U0q9tyS8EBEDkxxTrnRQzA1rpPzLAr4k7x4jbROh2tWTYm574OXdLh1WZAGaIdDwmPASJ3buSn4CCEQ0eLX6COmqhtkM6jiYJpZlHRr88zGi4+yfWcjdHmtOY2kEwTdQlx8pBkIyW05ggL6mRVjrwN/a0HHg+AWeItrq7J3F1NfYgV7Jq2NtW4r5jb4WHO/p15tV5BCMKGwYG+DxcnoTeUYpIGEHJUXydVwZYFFeJa6+F77ccNmJveMvDKO9g5aYgwm2AuKYsU5qp3Sv2DUxhZMC6NbAX7jZB1Lbf88rKNWExI1bFX4OTdoB1Y6MkR8PpvmoZh7O/yqFy3CL81ZvqLqdF1a4wvfwiNGtBk9Na5wZ0tMfo3vLtaajrnQH5ow4x2KkjttG8n/UN4ysCtuTmHzlplup5YU4qdSceHDIHToRDJjKW+BYtNgtVZyKJnd2Es57geeYB1O8ZSMLhK1Us1pj+vNMpOa5lSwVvZ8Un
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(6486002)(91956017)(76116006)(6916009)(31686004)(8936002)(54906003)(66446008)(66946007)(8676002)(66476007)(71200400001)(66556008)(36756003)(64756008)(5660300002)(478600001)(316002)(4326008)(38100700002)(2906002)(6512007)(2616005)(41300700001)(186003)(53546011)(31696002)(86362001)(122000001)(38070700005)(558084003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFJDNjUwQkpOblY2cDRsVktVc2dUbkNYaEJFMXRDNXNSQmt3ejIrbHlpWGIw?=
 =?utf-8?B?VDgwVnVpK0lDYUNxS2lLb2tXaURqZ05oWjRHc1JCV242SWZlUFhESU04VGJw?=
 =?utf-8?B?L3JJYkhDZmFZSlZsVUQyc0lZQ2l4bk1NMjM0RnArTEVuRWxFK0s4Vm5CTXNW?=
 =?utf-8?B?NTVSUERySnVGOWRPWFFubVZicnYrcmhGazVXMTN3ZFpNU2JDcVBEckFvd3JT?=
 =?utf-8?B?N3l0bXc5RzM3UFhXMWpwcXRtWjBTYWhpbVd3bEkyNEFlWmRLc0NWUWg3a09S?=
 =?utf-8?B?bVFPVHM4dTlqZGxzeDBSS1lyV3Y1TUhwQy8xK25VMENKNFVON0xybExKd2tk?=
 =?utf-8?B?bkZjTktXaVRQSFpUTnFpYXdQRENsU01UcXQrREY5cVA2NDNWQ1BmcHlkRC9T?=
 =?utf-8?B?MCtIc3pSZHh1S3Zwa0RXM3pZZmg1ODhEdmlZZVhyQUJQOHRuZTBOSGVpR0I1?=
 =?utf-8?B?ZFQwZnc4VVRnUFNzYlk2R1NrRDlnM3NZKzRJTWJydGRZUGlnTC9LNS9BZk9Q?=
 =?utf-8?B?V0c5dXF3aWdtekxPcnYzUE9Mc2tNcjMzZE5QbnJ3R21Gd2h4Ym5ldVN4ZGFw?=
 =?utf-8?B?ZW1GVlYvajRDZ3gyZ1lnQ1NpaGFCN0xxV3ZsQ0hFUGM5MHJmL21iSkpSVEU5?=
 =?utf-8?B?TXE5NlZ4bS9kSmw2cTVzbWRLb1VKNWpOY3J4aUtIdmlsVkZBakl0Q09Zc1VM?=
 =?utf-8?B?NXJsMjE0aFFrZ2pnekFBbTAycGdzYWRTN212clpmT1N5Vk1SQkU1MG9Sd24x?=
 =?utf-8?B?QjZ2eUR2RjNCZkZHcm5XRGdHZGVKc0IwSlhEMFRzR3FnZTRHdDNlQ0Ftb1Na?=
 =?utf-8?B?OW91ek5rTDhZcXNUdmlYdjcvWkw1bDU5aHJGN1lmRVFXR0JSUjVJSVRJb2FX?=
 =?utf-8?B?RWJrdTE3b0FoR2tYQTAyOEc1RTJvSzh0Z0RTb3hqWlY2K1o3RXdZeU0zZzJI?=
 =?utf-8?B?UXc2QklkK2pZZHRlajRib0hTak1vTk1WeHJkNUxQdWdBWGRDbkQ3UkFvWHdN?=
 =?utf-8?B?bWhmQ1dwU1phcTlTajdBUDdIYzVpUnFhK3JqWW5lWW13UHNScitvd3pqcjM4?=
 =?utf-8?B?L0lsaXNOdG5QMHF5RDZPL2xPOTRZTVNYRG9zYnN0TE5jTFVoejNrK1llWk9S?=
 =?utf-8?B?RGtNb3c4YkdJdE05N0F0L0V4bm0vTmlyQ2tqejlPclBFMmRlcVpBNkZqZzIy?=
 =?utf-8?B?VXpnUjkwdXIvaUUxQ2swRGdqdG9qeDZQcUxTMUQ2QkU4bndTS2p5K3c2VXZj?=
 =?utf-8?B?Mjh5Y1BHYmVCd3F0SDhGTVVxV3llZDJWWnVEY2U0blpDcHRQeFpyeE82L2hq?=
 =?utf-8?B?NXcxMlFTMmkxcjhBZTFJQVk4V3hYMWdmK1RudElDUHNMK282RVJKR2RwakVO?=
 =?utf-8?B?TERQVEhqeDI1OE1FVXE0ZTkxWkUxZlc0YmpiNzdVUEw5VDlHQ2REcU5rRDhK?=
 =?utf-8?B?eE84N2ZtRktFalZLdUh1Vm9vZXZkUm14RFBzdDl5Y1JuWERHSyttV0kvTk9t?=
 =?utf-8?B?U2FZajg0eDNsNDNnY3NRbUFUMVRDTGxLTllwb0sxY3Nla3lhR0w4RC9EVkpG?=
 =?utf-8?B?dlZxUjBSdGZoT3dEa3crVXFJeTZic2k1MFhSWldIOVNzZDFqUzdQUmRvcFVt?=
 =?utf-8?B?QUFDd1hlZERlZWxjM0FMelVMOUhKQTJOVk5hWFZvVnBQWktLbS9oN25DdnpL?=
 =?utf-8?B?UXNWQnpoRFk2ek1mbWJVREVVR0hpYVNIMUpaNlBXVGgwMEpFSHg0T01Ec09x?=
 =?utf-8?B?OStKY1ZJNFBPYmp2bmJMSjFmRXFKekVzZTRWckMzR2pIZzI1bllESTUxSTVJ?=
 =?utf-8?B?bFFWcXk2d1pnMXQ5dUg1ckdVVUd2dGY5b1d4eGNOdzcxcmtQNXhGNzAvQmpV?=
 =?utf-8?B?WHMvMnZ6QWNoQUU3REZHN3dncjhoNjBkYStlRHVkZlRzYkkxYXJ4T2pHc1FG?=
 =?utf-8?B?Ui9MU3M0eVgxUW1CenFCdm43d0dHalR6VklnRTFUWjhXdEV6REFnd3I4OHgy?=
 =?utf-8?B?MnNBbnp5Ly9LU1NhK09Na0ZFT2ZqRXFZTlBnTnkrUS9jSnVLSjRqUU9ITEQz?=
 =?utf-8?B?Vm00N1NKL0RLbXQ4SkxMWG1mR0t0UVg5bVhwT3F2N1JLNmlnK1h4OS9KZ3pM?=
 =?utf-8?B?TnVVbmlTVXl1QU5rQW1XL2hTTmFabmF6UW9Hb1R2aG9rc3UvNjQrWVBzdC9i?=
 =?utf-8?Q?HtoVAE2fpLs6mUy6wrv9klNY7EtySVb8mf5/c3m/J8+0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D27DD6EDF12DD4EB2D23C12645E3267@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc21c5aa-3c4f-4bea-a9b1-08da5e4f395e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:25:58.3810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jzey6JCgW8pgjkIRwAnrWO/sH3sXKmO9OA533oRJ83exFcQLicPTNgr0X5QxCwWhVxsI4vK9zS80Hdy/duzU+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEV4cG9ydCBi
bGtkZXZfem9uZV9tZ210X2FsbCBzbyB0aGF0IHRoZSBudm1lIHRhcmdldCBjYW4gdXNlIGl0IGlu
c3RlYWQNCj4gb2YgZHVwbGljYXRpbmcgdGhlIGZ1bmN0aW9uYWxpdHkuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNClJldmlld2Vk
LWJ5IDogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
