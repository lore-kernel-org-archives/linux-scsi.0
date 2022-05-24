Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14A6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 20:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbiEXU6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 16:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiEXU6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 16:58:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FB129827;
        Tue, 24 May 2022 13:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOuR9e4h2YIrQiWDhTYpeoWHs25LB8qM8X3O2jtlTJICAXDfw/n7o/7Nf1voG1fq5Zq982E//aLBTMPeAK/i09X5Kq09edVkyCS7j+3NFb518dA+zzD2w5Jsnfd8so93n86XBpV7YjIPey4bFeJnnB/BprweUehjwrwGTDvYrs+gk8TbdB7e1kLqjHxRctMYNSwgQifBuFjlEs2l5i2qrfRosKgsIuBV7rRIEGkbSC5kFn2KcKFNGkia1RRMsd2tV6UJXJ2hD950cPh+Amxf++4450xRqriiyDoMEp0YPA+i0e6cwYJ6m07Y+XK1wzDy+Pq2y+3cJiBpBgcaH0my3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQt7Bf1ob2WOTSFyH3XfeRd2kz+riwnU5JGaukPsD1M=;
 b=epc0s7ecQ5hT+Pl5l15jFqELZJ3KTVwr1kHY1aWUMBE85crWqecxiPTUHS56chHLBogD3SK6qG0JeDA4zpImO1v7mx2HEQRwC2XOeGil/l0ec3l8q1sA/S2HY17jNYPkcCFqHFRbVx3rrSUNt1aF/uI+iL7JTe4gZBwv2EKSlsm7RHIGIvuyyMSA7bgCtbnl/uFGnsgV8aqdb25u6iXRns2wmoTbAl/Pm8OK2Z7KtxBSY/sB8egfNvGs119ej3vKmjKu8vCDWMhE7RCi1u92pg17oZ1CnV+e1XH83hT/0ltU2TuLsPxKD0HkIdfuXjWQIl8NSKIUiXBaqyZz9x2wJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQt7Bf1ob2WOTSFyH3XfeRd2kz+riwnU5JGaukPsD1M=;
 b=gUrrxafQO90YJ8op4E0MOZaPvcai0AWwaxrzKCzepAethuVDgRE+DohnqeAJSZUg3J/v592TGruIXU42zGH14jaDeeWeIhbBC34kqEjT6Lk60+RDrHkDBFF8i/O5fGTMIfZ8Md1nlyGZFAvJTk+NpLK/IrdsFfzfkU8BeaePZmWHx3Ut2+7+JXuRTvRIrzgEW/Xmq+9TtZ1+FSqkjgcwqzeWGv0k+vonwgEQbXcL7Uvqn4oBttokwLHiE7UL+Tl6FPNlrzxOc7FPOvs6/NignVMEK1nu14I+aBhccVMjKl9SjAUthqLc4VnstJwAMBVq5JQ14ZfDKXVCMZqm6+WKTg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL0PR12MB5524.namprd12.prod.outlook.com (2603:10b6:208:1cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 24 May
 2022 20:58:34 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 20:58:34 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] blk-mq: remove __blk_execute_rq_nowait
Thread-Topic: [PATCH 1/3] blk-mq: remove __blk_execute_rq_nowait
Thread-Index: AQHYb2f9a7bWjvxaIkKEvxv2X/oGSa0ugz6A
Date:   Tue, 24 May 2022 20:58:34 +0000
Message-ID: <626be8b4-e7b3-c3ad-931c-0a71003c5e6d@nvidia.com>
References: <20220524121530.943123-1-hch@lst.de>
 <20220524121530.943123-2-hch@lst.de>
In-Reply-To: <20220524121530.943123-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d74af85f-b5ed-46ec-c545-08da3dc82a69
x-ms-traffictypediagnostic: BL0PR12MB5524:EE_
x-microsoft-antispam-prvs: <BL0PR12MB55244C7ADD3CCA0D3CDC3A2DA3D79@BL0PR12MB5524.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /v0mBsMZRuw9kkBdYaF4IgEeFGSpb/H8L/RDgpfwY3Tu95tb3rwa1ToSOAF2R1WRKYpX7vTxiqOWJrm8Ok4yqGbKSlHkqGT64ybMJfKF7U1BxqOGnAypi6FImsNfFwgFKCH/kKCOjIh6jzr4SfqREXtcyT2tYttqq/81WJgftIZJ80xFU/LkdmICZVDOo4+bjO8v/vbObrKvAjoLuUaVNdjVrklI5Zg71xoNPRWXGE7OGu3sMYw7HeSoP8R6mMXJIKfyuATyXF/0IV+JgQJheyKX1c/i7x+bXPSx59KXBe22upVFn5WZA34400mbpFNUheidJ+DxWDdOLWqHJR+oJhoCSUdLjhIGST1gPLMgDxXog16OqI4M/+yzJcRQY6F9aNvBKzwoUmDxD/Kv71yoxRVQPH4ZLLMvvrpuPeXbImYpXR07ONZ17r39Hn86URZNCw1wOi8tKLpet/zy2ea4w4yYi4CzuUL7Z3fStSU/ZPoABU7yNzGRzRS5betJiF2ijZgcE8ufkppl2sNG04xJhQ8d/IVyKGMN7aJ/Q2ebtOKXV70d8omZo7S7ETkyPjfMKZrrL2PgK2dwUJxs0GPaIKgBKygvD/FRI83fLPqftMdzshkSvwj4tab0EnAjOo6wYtaDPYkQf69N99cB03HO8CPkXBl6yq94NLc7oRY15yzX4HPgYEpym+oI8xKYTdMe8K83C+MDGv4/tMznv5lDCVhc54rvk6JKekC6WKlGMIokLBXcqH9IVsJTVhgiKm2AOoUnYcAkhlCGLwtxXuNBVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(122000001)(38100700002)(54906003)(6486002)(36756003)(316002)(8676002)(6512007)(31686004)(53546011)(6916009)(508600001)(71200400001)(6506007)(186003)(66556008)(66446008)(66946007)(86362001)(66476007)(64756008)(31696002)(76116006)(91956017)(2616005)(4326008)(2906002)(8936002)(4744005)(38070700005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3FNSis1SWROcFZCY09MMVlrTFFMTmpXc2ROOUVtMG53UU1DZm1sQW9mbk1u?=
 =?utf-8?B?MGlYMVZRSDI5L2Y4MmZSd0RhMnNXOTFrRGY2bXRnZDNwUDRiakVqM2krd0RB?=
 =?utf-8?B?d1BuZFR2TkZKTW16RmkxNlJ5RXhvYno1OGFhTVBwSCsyM2FnWkFqVDd3eWsz?=
 =?utf-8?B?bmQxZS9teHpJeE1yZ0ZHZms2NVZVQlNmU1lhUE80Sy9tbEpNWVAxeDRCNFFT?=
 =?utf-8?B?TXJCc2lpdmtWRGxTKzJSSjIwcjF0Z0VLalEvWU8rdFNBMWxETkU2Z0JHNERP?=
 =?utf-8?B?eFNOVjFBbE9uRDNKQlBpQXJSQWFLdWg3WFdjQzVmQ29HK0kvMmtITDl6a2dW?=
 =?utf-8?B?bE9CalZpZFlJblF1SVJhVVlPVTNSdzByZkw1czBqeERwMVRZNkdaNXJMblRw?=
 =?utf-8?B?OXN0cmFEUE1VL2VaaVJucWNqcE5jTzlSZmpwWFVHZmpCMjlqT1djUFU4VElv?=
 =?utf-8?B?NmNqOVJBMzZVZDA1MDVSSmExa1JMdzhpa3UyMi9CRHNuMVJhNWZsTitsNnpQ?=
 =?utf-8?B?T1VuQ0MxOGQyeCtkdHdZMCs3aFl1cEI1VWxWVmFEbzFKc0dVY2Q2L0srS1Y0?=
 =?utf-8?B?b3VIa0I1SjBLSXNCS1hudzBvZWFMRjNmcE05UnkrRndhTEduZ3Ridmd0NnZM?=
 =?utf-8?B?MUwvdDZsTXlXK3RwbkxsQy9kMHQzMGc3aXNLdm1YSUVLWTVValBjbXVBaUh0?=
 =?utf-8?B?UGZJU21Hd2xHdHJhakhYS2JCemIvb29PY1czaHlvV2lPcko1VDRwWUpxMVdx?=
 =?utf-8?B?dnBiQVdic3BTbVZ6WkdwNzZuUWdiaUJtNWZDU3RkR2V2dFo5cGJOZGtzUU9D?=
 =?utf-8?B?VGQrTFpyS1RpYnpBV0pkWUxGa1RVZU9BUHV5cERxd2lIZDZZSUVpZjdZc0x3?=
 =?utf-8?B?RVJia3NoWC9qdE0yZE9IdjExbWp3TEZ3d1hjSUhveXJSU0Q2OFRXWUR2WXZV?=
 =?utf-8?B?QTFXSUVuaDBLcGQxYWJ3MVZscDlDWm1FR3dIY29EanFiVHdzdWpmdXJnZUNh?=
 =?utf-8?B?cXhKT0p3OG1UbllkWitPNS9uQ0pjZWN5OHozMUxQaDdOT2Y3N3VuMDlDYjgy?=
 =?utf-8?B?eTF6cWU2UThGYXZ0aXAxNHJpeHEvRFlrQ0IyVktOd1B2aHhMaWdJczZSblNk?=
 =?utf-8?B?TlJNMlZZUFVPY0x5S2dyZElPZlg1Z2VJMWdmQ29QSUdsSXdRWDN5alZaVk9z?=
 =?utf-8?B?RTdKVS9UZEt5d1NXZkhYalZIN2dzdllNdGNIdXB6Uk1LYWZhUFBJNi9sblJY?=
 =?utf-8?B?UC9qVm92K014RUdhVjJlWFdwMkFoQWNHbmduV0dJS0pQdjRaVyt0R214SmNW?=
 =?utf-8?B?T1JucVJPeWI3R09mOWpHM0ZsdUZETFYzUjMzbnZKdkFBVCtNQkFSWXd5N05n?=
 =?utf-8?B?bXd4Z25Qc3NRUHZYbm1wUkNpSHNzempRVXl6Zm05TXVUeks1d0h0SkE0QVNi?=
 =?utf-8?B?ZFhpdk9keUxHZXNjNERJNGNYTkFhMW9jMGF0VWZmRDhRY3FYQWZ5SUpqTmpT?=
 =?utf-8?B?K0hjZ3NrL3diMmgwZVFMNERFUi9UVGdZdkVVekFNNFV4emhXYnJjRmUxUEY2?=
 =?utf-8?B?L0FqTUZUaEhUOWdTUmpxMXB2OEt4SXlGWDU5NkNzNEVWSzhJakYyRld4cita?=
 =?utf-8?B?MDV4MFlqUkY2KzB2L3ZZQjlxU1A3N1ptcXJlV2lRbjBERDRYUkd2eXVkOFQ3?=
 =?utf-8?B?Y0R0K3BGejRRUE1iSlUveXplSmZXZjM5U3hpTGw4dzR1S0RXdDM0MlRoaFAv?=
 =?utf-8?B?OHBTeFJjQkhPclFxOE1kcVBHcEM1emtXTUtVSjVPMndjWHgwS0Z0RFM0WTBx?=
 =?utf-8?B?UHgwV3grK284allWMVB2SUdGeDFtV294bnUxRDd6Zi9IRWxDb3k2UFN4TU5V?=
 =?utf-8?B?S2RkN29GY05MSi9BZG1kc2ZTSGVucTB0NUpzd2ZWdkNmY0VhY2RXNHg1bkxC?=
 =?utf-8?B?MGdhb1NqNE05Sk1hVGVOWHpGWVIrVUZhV2toMDN1SWJvaGFhVkk2cnF3YnVw?=
 =?utf-8?B?allJanE2bi81QmRUUEdaZ2xOVWg2NlBvbHk3RjJkZCtjUUlCLytUYmNGS1VL?=
 =?utf-8?B?V0Z3aWhTTlZINmFmSE5QNjdmUGV3emZsVXUwU3JxUjFJOUl1Z0FVNFlWVkQw?=
 =?utf-8?B?ampwaEQvSHpKbHd2MHV4M3FMOERlUkhzOCszWXpNTUtpMTRkMy9qc0hxMjlG?=
 =?utf-8?B?VnNzQ0FwdDBwcnkrbnAyTTRaVklRR3JyT1NjUmFWdnBycktSdTdQYmtHZDdN?=
 =?utf-8?B?dHlrb3dDVFVXM0tIYXo1R0JuWXVMYXhsa2pOR2ZyOU5EaHIrQ3BkdW5WZWwx?=
 =?utf-8?B?OUpWRENUTGthTGRwMzNmaGFiaWRTbzBUSnU3SkYxbnFmYlBhcTlOTkpzYWdh?=
 =?utf-8?Q?L1mlNsFjhKAPU1JaWNQVHFe77lqGh1q8LXIJj54aIOHQG?=
x-ms-exchange-antispam-messagedata-1: E9cIrTKyYDTl7g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A296827571DD794CA1B414C7CFC9594A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74af85f-b5ed-46ec-c545-08da3dc82a69
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 20:58:34.0362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1hbBtR/pg+rDwOmcS60I2htgGkh7Odd0lNZtQs+s3i9s1Z/zQUj9gswJm4I1ky2CBwS5u0+ef20y3LXkWO1eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5524
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNS8yNC8yMiAwNToxNSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdlIGRvbid0IHdh
bnQgdG8gcGx1ZyBmb3Igc3luY2hyb25vdXMgZXhlY3V0aW9uIHRoYXQgd2hlcmUgd2UgaW1tZWRp
YXRlbHkNCj4gd2FpdCBmb3IgdGhlIHJlcXVlc3QuICBPbmNlIHRoYXQgaXMgZG9uZSBub3QgYSB3
aG9sZSBsb3Qgb2YgY29kZSBpcw0KPiBzaGFyZWQsIHNvIGp1c3QgcmVtb3ZlIF9fYmxrX2V4ZWN1
dGVfcnFfbm93YWl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhj
aEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5OiBLZWl0aCBCdXNjaCA8a2J1c2NoQGtlcm5lbC5vcmc+
DQo+IC0tLQ0KPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGth
cm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
