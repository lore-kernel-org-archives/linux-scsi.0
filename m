Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CFAC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJRUpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJRUo5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:44:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0065FDD5;
        Tue, 18 Oct 2022 13:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRBbSGcut8N4g3Jy4s8ILvNMhi0QTUUMRnKN6daOziKd/S4+98H0FfeXERz/RFe0hlPSWneMXpzavZFGZrXwu/69CHsn/FpYPdrEwRwuAEhukTNUjAuzZn2RQbB5+MCThcJY4VrboHp0R8rxtua71lJmUPE9+XrnPpbO3Clt4dzyCxS1EMBk4eGYLUSuJ/PXkooZ8WcRePDXOSyu8+PMWvPFwtU8enaSvvyY8CM3eE0OVJdngp4sn+3bFU/UelnjOM5VCJ8OO7yxI5B7UeddJOtwwjSUyXcxkAo0V+YZOV+YvMuz272JmKTL+MdNGRi5QCrMmMMcjUVybXpgbehEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6t3m/8nbsx+dwq8SXL1pG7rLxCfc2n5JfD2PabepqU=;
 b=VoOdRj/kAeerCBQD0DMiKUqFnabgEGPCHsC4ZDO21MR+KOCt2f571vnVD1F1DMb+gUU/gqX2k7NBWi3mMJ7aSKq9H4Z46cj4HOpCgyYutBx4Ur7yo1ujQkBwCfKvxz4zDb8CLmscHJtVDlWouqnToS00fqHfvwnZLpt42hP4vUqhgV3vaimFQyefwufOi9/L1SQlwuxbdu0dag2m8efHJSzHe2W90OV9kWMiztWKwn1cUHKH3dTRJ2LESHR/caovlNBEJmDXt4m21Dyy0uFFGk3cLar/tPMp8KXrf6seXLTD9JKKPmKnunmcYgjHCqSPgImbDXCc16FRHLKl3bvTmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6t3m/8nbsx+dwq8SXL1pG7rLxCfc2n5JfD2PabepqU=;
 b=UoiXPcGNW10NmUpsV4kqWUnrEdNrAde/tKYJBigY8iJCW9tFCEhbNlVdCORCRZ5ri8c7CZPXl4k2KVDLMJc4oGECGI8g+8v85fBCbntRjFTegDXOuL+xlf++lYI38RKCcX7CvujdQfBDgLv2JTqx3PobSXwCFgokzZ09UkUitXj0Sb5YZigdgYVUI7YijfPKra/LLxmX9fAm8kSKOizD9V4tnZJ8N98Fm3YPAanKEVfIHpTiIJBp8fTy85M1DdX5lWBsm4+xS2PQMupN2+f+5fJVZ/3auXW6c/a27BgcB4q+1yCQcAYXYaCe/SK+yfxElHe2t3PTohqwEga3oaDWpQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL1PR12MB5272.namprd12.prod.outlook.com (2603:10b6:208:319::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 20:44:53 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::1402:a17a:71c1:25a3%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 20:44:53 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/4] nvme-pci: remove an extra queue reference
Thread-Topic: [PATCH 3/4] nvme-pci: remove an extra queue reference
Thread-Index: AQHY4vmjwsSsK+DeUkWeyuMM66G65a4Unv4A
Date:   Tue, 18 Oct 2022 20:44:52 +0000
Message-ID: <095dae21-f70a-a7e4-c8cc-02bb2263c649@nvidia.com>
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-4-hch@lst.de>
In-Reply-To: <20221018135720.670094-4-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: c006ff83-d2c8-4625-9854-08dab1499bc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aQqEok5GOE13K7h3d3T29Vj9GMLW+PelnNC7CbC0iXu/TktJgdrEnZbyURKUH2l9lze+EVJQX396Lmq+f83noAAbIH7nSZIrvCyBgeaeDX2hVfIBL+tZOgu5HQxYghduPNlSZZyVOv2SwlQXfffuhr5eJXUkIlIxp0AE040G1Y6UqTAS94oR0A8w5Gi+O20QcviLtF02G8/3s/ZJCtUkDJL1sOArpARlUm3Aj3Kzb9z1dzrcnxe4wt0Cg/lbEEhaVMQdIgNEIhD0pbZ7Gdr80407sLdnrLHzYjyyKD9JRygsY/rzw96fxbubmvvtCM9NX8k17ozV9RQ/Fo6AhOqytc+1+c0JlHBFBWpSYaqQBBvN6FRGPpL5B8EJd+smm8xkN+0Gv8oguvQkqJ4uD1NtkVsbdOnXLu49UiZM4HiPr2yQvagUGoguejY6SwIa7yZ0oh4y/UZx83E9UkTif7zzva7C763PFtIbR9vVW/mtlwh/jvIujG/O6176BKb2K9HGJ9fmUkSNmJRBRjb5kRmAivrceu0m26pQ8ZyXBB3Zk1EuPhAFz3w3jKVRcmGu9fKBJpPyzYZc10y3B+6JumYulYcMyGXWOEUcM0umEAtHsixKyfj1CNRT0rNfpiFU73y2ikmchxdlrSrHNmCmyj6oXJ9xQ+VYKgWNFlr5Nikl1xP/THyvk19Wi09bM3gahDiJHmHJRURI93BGj7ccBKkfyGKDujsQwWx+JA4PMIwyEcyDlSC4s5ogIMoZJyPeRAAa5/4t34z1lw2GpC4Sm3CvDSWBHKjW7PrFpFp2Q8lf5BouG2/b1ETQ+oYC16EnO2R/+7Uoya7szNFvfgiwmObs2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(38070700005)(71200400001)(122000001)(31686004)(478600001)(6486002)(38100700002)(186003)(110136005)(4326008)(54906003)(558084003)(36756003)(6506007)(2616005)(64756008)(316002)(91956017)(76116006)(66946007)(66556008)(66476007)(83380400001)(66446008)(53546011)(5660300002)(8676002)(2906002)(8936002)(6512007)(31696002)(7416002)(86362001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFNJclVwL1JxWTMvMnFRdE0rUWtCbFMzc2NIQ2E1TC9QYzY3WjBMbm5DQzh6?=
 =?utf-8?B?blVTRktrMWJjc2FER1c0VFZCRThubS9GZlByRmJTckcrNlRWVk1qSUUrbFRl?=
 =?utf-8?B?TEN2ZzZpNWh0aWVPcWgzQ0NETVp0UzBjclRRdE55Y2QyUVRxc2RZMllnYVFJ?=
 =?utf-8?B?UGNKamU2Y0xEdmQrTHI3WVZNYnFHTXBLQjh3c281S2tRMVI1TmlrZ09XS0hP?=
 =?utf-8?B?NWJFbEwvR2RneDJjaStZdlJuaHZOM1VDTGh6S2Q4V3NQR0JodnVxZmNuVHZW?=
 =?utf-8?B?aHZBeXcrYnFQNFlTL3h5dmtzcGJxK0p6QVhhOEc1b05TZlBBZU9OOW13U2xB?=
 =?utf-8?B?K1pkYnJPZUFRZ1R3QzJKNWVaSTN2MEhQblJ0YjkvT3I1SHh5OHpIaWlpVXlh?=
 =?utf-8?B?aGpWdk9rZFNBVjdVSDNxcnoyelpXZDlQdUVXUDNGMFIyUmVSb0JyVUMrMW1y?=
 =?utf-8?B?TGR2ajh4d2tmQVJVOTIyWEpLVXJxT1hia0x1dGhrZ0JHbWxEckZ3RVZvZmIx?=
 =?utf-8?B?bi93RVozckNRdVo0ellnMlFaOHNnbWpleHViOUswWm1QdjdWMTJ0bGE2c3dH?=
 =?utf-8?B?UXozNzF3Yk02MXlyenBpUS9IU1RXWUlVbi9JNTcwTmltYnkxcHdrdVZ3aWJP?=
 =?utf-8?B?UzYyMjhDa29YdFRCMVVibVFYRjZPRjRaRHY4RWp3RnZqQWU3Y0VDN3FoMG5Z?=
 =?utf-8?B?R3NpM1h0NVlVWWpRWUNydE1yV3NNNXlBZUh0TEFJUmJ4YVZnMTlSdWM0MEV2?=
 =?utf-8?B?TmY4SENIKzZUTDd4ckswVTVxWk1ucVRTa3NIK0lUdWwwZXF2RitVcU9MZUpH?=
 =?utf-8?B?UElPUFUrdk5xTDdWSy8rSDN5eWxUZ1A3QVRQNG4rVzJEbkl3eVZ3Wjk1RWYx?=
 =?utf-8?B?OVY5VkE0RDlDZnVjYU8zWGRaZHZrZEpNWEl3VXZkcUhFdlJNUnlTeGlpZE5r?=
 =?utf-8?B?S0pIbVJWREV5Y29tQk10VHBuQTBCeFdDWXoxMHRDaEZlWVBCeWUrTEhDWnZP?=
 =?utf-8?B?NEwyNUo0UDJSQ3UvMHBEdjBGTS93dnJjQUFxOXRZQkFPSlh2eno3NFF5enU4?=
 =?utf-8?B?bW9XWXBJRnlYbzRwSFpIQlZLNlZVa242Y2J2NjhwU1BsQmV0U3NSc09vallV?=
 =?utf-8?B?TWp3T29xNXhsb1g5cHlVTXdtUFJwZlJxMUVxbEFMVnVPYmw5ajZ0aTNuN0hH?=
 =?utf-8?B?cWZrY2JROW5vR0xWTW9JVmw4cUY1N05vajdtMllVaEdSNXg3KzVtNmE5NTVy?=
 =?utf-8?B?b0FDVFozamRlYjBYdUhmR1pPa1dTYWNsWE4xNlQwMWpDS2svZ0NVbGVPZGwr?=
 =?utf-8?B?eEZXZE1EdUdiMGtOQURGZXc0QjJSU1dYYkE4RjN3VDZ1SHJpZ0JUWklPc1Mx?=
 =?utf-8?B?d2FEdldrMk1vQWJrZmVVeFUyZElKV3lrdDdzMXRuM0NERUQrMytiVnJzME9l?=
 =?utf-8?B?RTZHd2h1ejIrdE9WTVRUVlBQNnI3MUYxcFNSYmdaYVYxS2FKbnY1alRRaE0v?=
 =?utf-8?B?aHRqTVpyQnorN2lVMnA0dTh3Q2tDZEhPdDVDTHE4c2QrRW96SS9SMFYyM0Nn?=
 =?utf-8?B?bHZlRDZpLzJxZVovMVBnYW1SZVFiRHRURVB2KzY1dVdsVStNQ2lRdlFDTW54?=
 =?utf-8?B?MXNKcG03Vlg2TzJPR3E3NDBObmRxd3JsN0dUUUR3VnMrOTY1V0o5RU5KZmIy?=
 =?utf-8?B?ajlNTHE3MVRoTnJQTWtESmF2NkNISUd4L3gxbmllQVdRZldrMDBwYmpuZWFO?=
 =?utf-8?B?Tld3T0tZeEJpc3FFZ3dhenc0OWJNWHdqSnFGNWFJV1h5ejFDL2RNQTlwek10?=
 =?utf-8?B?eHd3c3I3OVAvWm1raXZ0Sk43Zk81MjJwSEVKeVZDcE1SRG5Yc3JoU3FrTEZi?=
 =?utf-8?B?cDFaVmp1QW94bFhlQkphYS8wa0ZYR1d3Wk5Ud1JHNXFsN3AxWVN4emlHb21U?=
 =?utf-8?B?Q2NKWkc1RGx1Vi82T0Y3bHFiZ1FXc0FYampPU1daUjRGVGYyZXJLQlZrNndC?=
 =?utf-8?B?aWF0d2RDMEorM0NEQ1NJWVFPbk43bWZ0a0Q1YStWWk90WitHVStLVFZjbUFY?=
 =?utf-8?B?Ty9mc1RJOFNJK3pCMVdJL0tXbnFxMUpyYi9iaTBSQUxqalQweVJwUDd5cnJX?=
 =?utf-8?B?OUllbzdSMXNJbFk1RTM5NDd6ZHJMOEd0WFlGdzhta01xbjJNREd4QkpOelZk?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36DB1DE776717145A6741482DBEADFAA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c006ff83-d2c8-4625-9854-08dab1499bc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 20:44:52.9606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bZAv/dZKJa0Y3JaKONcxuZb3MUoEBaM8AQdXCr05ait+x7oAVnT6L5dF/G0wsPLPnIgkoTBGq4Zq3DT74Z4BzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5272
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMTgvMjIgMDY6NTcsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBOb3cgdGhhdCBi
bGtfbXFfZGVzdHJveV9xdWV1ZSBkb2VzIG5vdCByZWxlYXNlIHRoZSBxdWV1ZSByZWZlcmVuY2Us
IHRoZXJlDQo+IGlzIG5vIG5lZWQgZm9yIGEgc2Vjb25kIGFkbWluIHF1ZXVlIHJlZmVyZW5jZSB0
byBiZSBoZWxkIGJ5IHRoZSBudm1lX2Rldi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBL
dWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg0K
