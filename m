Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30775C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 21:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241843AbiEXVDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 17:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbiEXVDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 17:03:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FA06220C;
        Tue, 24 May 2022 14:03:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMoHP60TUtyuG66nI/HCttOt7hc5m7PVl0dzfN/l7pQ1wQYek8GLdM3qqFvSHV7vZKzGJx/TKdutuQn8DUNZ4NReUNksWORz86H2O4t9W+4trdGuGmLaeHrCQ9TyHIef9qQici20Bt7nyV5HdBCsuvJI3ww6adgPxbBIyO8LJp/Pre2QD93upt14P8qh8Yj8Z2vqvgJUo6aslxsuvCjBTsX9mUq441rBAFkG/xvh43YNppvvNIyD6BjRR3p140ul7+1GUrJ2nUyPTjhSk+RTkJirXMLarOkbzeT+jzgmMEZce/kG/TYruy/o3xQoEbAkw5Z2dR0zucFZzIsWJ1RkKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8tmjeXjEs3TVUpVDourE0Yr39gJ1AE9LA9QXwMrRbI=;
 b=KY9seUeS8HfxBjF/DJ9CUJm8oQnh069jW10+8T1xEay2eWURPe9g0tT+bvpxZSwtBWea6YOLyKrv7lCXhDkjsmL+fiZHuU6Eruk4yrnl8kQjcKBV82xLcJw2yfW9cQULken5vatKDTxbG1ywxRAqu6MTrxGBCf4zlipf1jkJiP+05eszdMzlV0+5FYVmQ+/bJAfX36MxtkB6lG9/ASjYP2OKIzHbDXI8GK5Poqjl6njYNlfAqs4TtDfrsjk0L0VDDf6qtOhUmVw81Gyjq0pT5tSW+/BtJ1Y8GQIzsCyuRu4hl+46C3gfvVIN1uZcIpx9uS+OCqDWZxY/L8jry0uCdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8tmjeXjEs3TVUpVDourE0Yr39gJ1AE9LA9QXwMrRbI=;
 b=ZHP1kGAoISdyX6hrR5XcG4PvNIhVMqr8nOW8aS9hg3LH81uI17raxg5Q1Di/SIDEW6KIIws7rCe8olWi9AuQTOZljBkhqSpRMV/Nc2gMegq7kc/2klJJQnQzs4r1b4EdAh+mKA2wYl9mPAJYvGcVqWlNm6YwNqJ/HHDh9jVT5WL1iQjktBnRnJ2N8Gdaoi4gtNDgsIferZ4c4J7k8uYyaqVJkKzH82emPBfr7+Eh2VLNERdY6QzonHQDIbiDc7dSVm7m5Q2rWuvbtU2Jv236ipQFTheOP/nfTPh228gO2w1RLDwT4tsS9gdUMlgHIXVsZ/xi5aPgztGbupwmDXTh0w==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM6PR12MB4795.namprd12.prod.outlook.com (2603:10b6:5:164::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Tue, 24 May
 2022 21:03:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 21:03:27 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 3/3] blk-mq: remove the done argument to
 blk_execute_rq_nowait
Thread-Topic: [PATCH 3/3] blk-mq: remove the done argument to
 blk_execute_rq_nowait
Thread-Index: AQHYb2gA7Q3Aq6lidUuRPk/NrAnWFK0uhJ2A
Date:   Tue, 24 May 2022 21:03:27 +0000
Message-ID: <ff838aee-2259-dec3-c68d-071e774f6454@nvidia.com>
References: <20220524121530.943123-1-hch@lst.de>
 <20220524121530.943123-4-hch@lst.de>
In-Reply-To: <20220524121530.943123-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4260e876-23a1-4fdd-f14f-08da3dc8d965
x-ms-traffictypediagnostic: DM6PR12MB4795:EE_
x-microsoft-antispam-prvs: <DM6PR12MB4795E10FD2E2F7ADC55890FCA3D79@DM6PR12MB4795.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pn34flY4FyWibRBf5F+7iEvptkzFuiyBltLEhYuOqJ58QqnTYKjKonqMlOAqDHZPzWTXjNhftXI1xCpPS+RJ88+8YsMq6YxiAVevQst+5+szQ5BrU3bwmgem3HDpze8UbCmud2YP1YWytpJaCB3UyYb4inRQKc8i+Rl+UYiWtK7nbh8dOUfZ1MtfIgjmK8xqF6E5gEC0eXzoXagGqtv2LovcOrm50m/nNysTwvF3BQvZfUbTGNqeskk3fV2mw/9SYPBFDcIJiPDdz26old0ku09BJskFaY3mbQwee9wRelloqcg3TtxR786IAkWLV8eE5lywY6Uj6yHaJKz8a3KbxHD/h45wTZj0nDjBtCf+LAdvqaxTi6GaxBUSFc7lr03t2QBTuvPzsOXhSEpXBKmbNLpb0Fkco8juVVpwPwHZEPCoi09oSONb0WO1xAhcSPIxP7msRx2Qk0wav87x+x4Vmio2S4QdXb2dPGX+KdXBoWdXWCPgy0x2+4YPOHdaqTSdps+97zMT79PxjOGw16oEDNNoezATzLJd0zIZAgVvAUyG16jllW3qREcj4ZXLh/3XlE5Y0ge415DNU/Qx4p1h4WfU0XFwiCNknqSe7n9BvIQ+ocj+iXj7xOlME2wzuEPKqQN8uHiB5t3WWYEJrumOv0h1UXN8Rf0+pTLrzpDR0Faj3PgX7wQonJ47P2w+ErAltUBccOr6PnN04UqsRIrhO7VdZx6QZraxIl4sC1c/elr2Zutjzv5RjztmMgx/tU8HSCbBWopRebSYdy2niVi5NQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(110136005)(316002)(4744005)(8676002)(8936002)(31686004)(76116006)(86362001)(54906003)(53546011)(6512007)(6506007)(6486002)(2906002)(64756008)(66946007)(66446008)(36756003)(66556008)(66476007)(71200400001)(2616005)(186003)(31696002)(38100700002)(38070700005)(122000001)(83380400001)(508600001)(4326008)(91956017)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWorSEVvdWVvNEI4QXZtZXBUZHNSUXZDZXorSTRFOERodFVVbFV0aHh2UHNI?=
 =?utf-8?B?TXRaODIwVXZCMVNDeGlqS0tUSm13bnZJMHZEU1JOdnNPQ3BzeDkvelhLMW1t?=
 =?utf-8?B?T0Y4MER2NDBiUi9jYnpWbGFWQlpiVFdBSnZPSXlwazRWT2wrZ1Q2NDJEdWp0?=
 =?utf-8?B?c0pOK3pyVHBoSXl3bi9hbWRCd01LcDNSSHRZWEoraitYK0M2U2NyZ21zRjhV?=
 =?utf-8?B?UUpqQWR4KzEzZ0phRkg2T3lrcU44cDJVMHYzTnZGLzcvWHQyTEt6Y2JOMkdK?=
 =?utf-8?B?ZFRnejhEYjVpY2RiVnRMN3V6MXo2TWxUYnI4WXBUV0tTMWprWDBRbmUxVzdX?=
 =?utf-8?B?NnZlTjkwbW10RjhQdThOV2RJVGNDY3p2VHRKVTNSRFV4S1g3UmNHOTNwVkh3?=
 =?utf-8?B?aDByVjVuVUdrWXdqQTJLOWt5QWRnbHhSYzNTUGxENzhTTWZCN2w5cEZZbFZi?=
 =?utf-8?B?UGJncFZTVzh5bElkaUpSSmdwaldUZitESFAxWk42RE9xN1JtdlVUOU9UT1Bk?=
 =?utf-8?B?TENTRysrUHlIclVjUDJsdGptdm56SEYzUXpzUHNDaWlrY2wxYkRxYk1IelNv?=
 =?utf-8?B?YUJDbkVreW1JVmZiMlpnMEROM2RJYWhiUlordFJrK3hVakVBYjg5cVZSNUxZ?=
 =?utf-8?B?ZklxaDFrU3pjQXRRRjRtUklTNXRhR3BFcVNjaWhTdXBONzVUYzVPVUZBck1v?=
 =?utf-8?B?UlBxZGFndFZJS3NJTkpvZzR1SjRxM1Q2aUtrMDVMYzNzU283SHlrbTJLbUYx?=
 =?utf-8?B?QUpvTEtSMFRiNjA5eVFzTzl0M0t3WGZQSzZIaHF2aGYzM1RITGVQYjZHTzla?=
 =?utf-8?B?VnVHd0w5RVZJbU96MGM5c3o5U2UvbW5rVXBpU2JxM29GeHYwUjhXWkwxaElW?=
 =?utf-8?B?L2l6YkU5bmM1MVNRKzZpUFJ5QWgrMmQxNC9NdGFqMGFwWUdlbzZXVE40Vng1?=
 =?utf-8?B?K0RzYkF6UWdSYmZ3bGdkZFppcFdGT1l0L1dXZ1M5cXYzVEY1dXp6bitwakRC?=
 =?utf-8?B?UTR4dEs0TFBTOGI1ek51dnZjbTN0QjhPaVdoVXJGVGtlVzgvMlJDUm9uT0oy?=
 =?utf-8?B?RXprWjhJdzB2Qk1HOStWaEFDK0hoVEhDRUFIU3JjaVdTd0pTeGZ3RnVtN1I1?=
 =?utf-8?B?R1p2ckxyck94RWdxZG42WkpkOXlMQW1zd3hhRloydVh1dDZxMEwyVGRSRjVp?=
 =?utf-8?B?MmhKRVh1ZUZhVE41TVo3cE5vbjZQczZPekVNVDVNd2J6V0RpL1FxbmdJMVBC?=
 =?utf-8?B?cUhWbnlrc25rNXowR3pzNXVWcFdwYitXOEQ3TlJ1OEZkbUt0NUNKWXdJV3p2?=
 =?utf-8?B?dmp3ODJKbU1FVjg1RWhlcGFlQUI4TFBjTXQ4OEJBZnJuakU2YXBROEtRV0xS?=
 =?utf-8?B?Y21UaUhZRjhPYTBIME9IWTlQSHg4dzM1WGkyaHRONTNsS3ZOa0pJSFlqTmhZ?=
 =?utf-8?B?SHRQSGtXY3FJZzVQMlFaclYrYzVJWkwrRWhaa3FoVzIyUXVOOEY0YVprVFE5?=
 =?utf-8?B?cXQ3MlZvQ1p6dFFxck9hb3VYeFZUdm54MFFoTUJvcUU1b3VCSlc5QlpIRDY2?=
 =?utf-8?B?MHlVVmZSY2twMmxpa3QwZ1YzdmlIMUljNDMvTnZTSk00RkxmT3BYbWd1M2hU?=
 =?utf-8?B?bVNwK0oyQVA3dnFJRnJVVlNmbEJET1MwdmhFL1dHSk1XaTgzWmRqSGk5ZXJw?=
 =?utf-8?B?alZKRDR5NEwvTlR5K1psWUNocWhKa3QzZGZJZmM0bWdLMWtaamhXNlcwdk0w?=
 =?utf-8?B?WjBsZ0dtc1JtM2M1Nm1sd29zRzBlOUxwOHM5V0NLVzVlM0Z2UUFCbUluMlJn?=
 =?utf-8?B?WTR5VCtpYTI2cGV2eVZnVnZNZ0VuR1RkNDFXYVJJUXM3SmFmUDA3T0Y4VmxC?=
 =?utf-8?B?U3pDNUZkZWxIblQvS2NJQ254aFFvYTdvRjVEU2NnSXJwNy9yMk53aG9xQXJL?=
 =?utf-8?B?dGJCVE1OSFptV0thcHlaaDFIbGhJYXZwVUt2OEoyQkR3TDNSWU1DcjRnbGd3?=
 =?utf-8?B?b2lTMElwY1pGMlp2M3BNZWpLcUlPcnBUMFFrRlhZSlJDbU9XdkIyQk1zcUdR?=
 =?utf-8?B?MkFIV3ptREpqbU1yS0pRVTI3WW5iK1NHT1hEUFpqbXhWQUhzNHpKWUdyeFJ0?=
 =?utf-8?B?bGM2eXhhQ3VCOFQweWNhR2RxSXZWQkxLQXZZUlRhNXZyOXZPUC91WEV5S2hw?=
 =?utf-8?B?MU5ydkVacVdhOUUxaXRlM09ubndZTENjaExIU2JiNjZ3SjAzSktNMUwwdEl1?=
 =?utf-8?B?V1B6S3ZMaEc4Y3RTOU5UZzBBZ1ZYOTYwQkwxc2Q2WitMTHpNMzNmZnI5WXht?=
 =?utf-8?B?VFJsV1JkV09DNkZWdW5WcGJHM3lXVjBiNHkxcTdGTHZCOWI0Yi8xVzJmbGxW?=
 =?utf-8?Q?Vx+0LNveaAea3efKdBtY7FFy9wzi9w41nNkIj0kbNeJc5?=
x-ms-exchange-antispam-messagedata-1: v9FmnLijkOh2EA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <80CB5E59736D0E4A8A67A897FE12F159@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4260e876-23a1-4fdd-f14f-08da3dc8d965
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 21:03:27.5968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AQpwusE0mP5xXzc/RLa0a1n/SYiDttYmS69fHmKgFyC00TxfLNDBJu8gBfALOD/oPUKyzzMnQj8/ifv32TyVOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4795
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNS8yNC8yMiAwNToxNSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IExldCB0aGUgY2Fs
bGVyIHNldCBpdCB0b2dldGhlciB3aXRoIHRoZSBlbmRfaW9fZGF0YSBpbnN0ZWFkIG9mIHBhc3Np
bmcNCj4gYSBwb2ludGxlc3MgYXJndW1lbnQuICBOb3RlIHRoZSB0aGUgdGFyZ2V0IGNvZGUgZGlk
IGluIGZhY3QgYWxyZWFkeQ0KPiBzZXQgaXQgYW5kIHRoZW4ganVzdCBvdmVycm9kZSBpdCBhZ2Fp
biBieSBjYWxsaW5nIGJsa19leGVjdXRlX3JxX25vd2FpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogS2VpdGggQnVz
Y2ggPGtidXNjaEBrZXJuZWwub3JnPg0KPiBSZXZpZXdlZC1ieTogS2FuY2hhbiBKb3NoaSA8am9z
aGkua0BzYW1zdW5nLmNvbT4NCj4gLS0tDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBD
aGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
