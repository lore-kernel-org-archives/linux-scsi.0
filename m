Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA561C636D7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Feb 2023 18:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBQSyy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Feb 2023 13:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQSyw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2023 13:54:52 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A3B1423B;
        Fri, 17 Feb 2023 10:54:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT1a4a822bJ4ARDiWLva4y1R5S/Tel+00XKpGlZ76fr1kDVPDz6vKw/ofMB601Wp3/fSr9FO15a3xXwclKrrk0M+xLCWb8g/8ybfI0ytdiC4UXkgpsjX+uBneFgXREi0IorE06A6+nYqeEv9Su6Icff5UHb5dvvwS9AVgwWY4mx688xbd/AbyXfv1rCb69w2JrSqUZnH2b4kuT5jxmVJjl75oOYNYqeJE200CzdU5p86V6A11PwYIp9L4U4XLd4bclCHN4xuidgPr/vNFUZF0VuaEq1hW3qG/BvZWn1rqqr/Z0C0zQzc+57pZCsDoKKD46jLg2J6vf1yhKoSILRzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcqElFx74R0zdCwNGwmd8tgK+H/QkX5K5QPgLWRqF7k=;
 b=c4FbHjksJt+l8bHfa1v3JKDqA3ZRrozn+81qbrbyYqGj+OUsM8yFuzjJLnY8VGFm33H/wtPNvcPvAZP2J3y6T2iT3vR3y3USZB74tiKgNGoRHQqC2GZ0JvrpuoGRdQmsStveYbGSDS6ab/YZtI4aVhH/JFLcvKyymGK1RPIK153R+E6AdZD5c/jbGTm40v9MajJ4VIggFw2Fd/q5cQRe51X8Xv2DKL86gqocBN3HU4av3cB33Cqk1XoKYQyO6rMCfWIT/DJV+BXhN8ZSGr/eSf9xqTX7jkwxfZI8YWtIGn7frsE0MnFN/tToX41VMVQn9U2n57oeD12S9zhiNR2/2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcqElFx74R0zdCwNGwmd8tgK+H/QkX5K5QPgLWRqF7k=;
 b=Xyk5bi00IRx0einzVZs/rML/c+e4p+a91r21FwKcdppkIwlRlgQEC0bpZ4NU7CvXuP5KC1FbzgiQbagqbL6MknLoUvP0Sua6eDyWOZhe+OEfuTwB7kEMkFINUKiFj1uxbBb67gtL9xJxtGa4aoskMl5Bea4KoS4YW+2scODpeaxtiA5nm+TzuNH/ncLZ4ZWonA0mrfT+Nean0nx+klHu4x9hw0YKYm8tUZFEaaJJckd7xW4pwvStTV9ZpDq3HaMlNFRzbKBfT6iybZqJlgphj9aOzQQxYflirjJKUDz478G1nA7mWUnccDnyeNO8PRwBRWtOQ8gSs8Owj09Wr6xLhg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 18:53:54 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6086.024; Fri, 17 Feb 2023
 18:53:54 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Thread-Topic: [LSF/MM/BPF BOF] Userspace command abouts
Thread-Index: AQHZQfzSsG6TxGrAL0SqQW/HeL2g2K7RxtkAgAG3iYA=
Date:   Fri, 17 Feb 2023 18:53:53 +0000
Message-ID: <e7b781d8-d5a7-cf7f-f681-c116fbadfd01@nvidia.com>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
In-Reply-To: <Y+5cjPBE6h/IW9VH@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH3PR12MB8659:EE_
x-ms-office365-filtering-correlation-id: 82911de6-652c-4675-ec89-08db1118510e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4FLX+PLyJ7rB6zUoIBhBpS6jSDPBYviW2C0+DZWHJH2kCMlkhdk8F1qerYhhp7wijJMRfztSWGCw8p2lw7yxztVyWi6bMl6WuniCoOqnxJ179hl3WdEb13Xv9uXI6XryCMEehxAqEnurYiQOxuKlHQOkN4Srfd/mlpbtUyHmRZVYRMl1C0pUqjwPk8oiqx0QK+a3rS5CUri2JReew7vRaf5lM5QABZSiahZmAmXKritOCYpFSArcjO+ZhZxpiA8pmP9oxdMamSll8F2kzqLSDxUZ9CZJsEfvY+7tmETbHptXlDbR/98ADU17H5aoiC3yCg109ghZV5GIp2WNt2gedjW344zsuxY31BI56L/s6vGjlNXzArvC4+1hyH0B62VSaPCx6AiYQy4g06BaCkbYkjvCKk/XbLWxt7FygEBw3T4QJqqik5M5LXnDnyfLUHVRbVL7SrD1pgVLVkgJB9y22fKT946/s+kZuvLGgwfi+gV/3TwKCooQixEal6nMq60KcJYR7TT/yJDx1RYF2LXWjFX8vbuEMmBIgKewU2XlYta8WyKWyJyLlMAgWLL5AZyqcth12iheEZclaCgbK2AjmN8vU4V8NG/LjuctsbfSSgFP+GaQI80e7pViGLSkUx8v54DMkKlUclEx97JmY0sRNfzh5/k/e49CJq2TeTIe0ZpWD/gNycwzjKhWwM1DR6FWjtGqNE3wzeTloDxMGcuJIjE0mx+jeQ5oGaLfPEIQFfUGF5vWmD5j0k9SzwNy9VJcX/k221CjnrcrWeFFoETALw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199018)(31686004)(71200400001)(38070700005)(86362001)(38100700002)(66476007)(122000001)(4326008)(6512007)(36756003)(53546011)(6486002)(2616005)(6506007)(478600001)(64756008)(31696002)(83380400001)(186003)(91956017)(54906003)(8676002)(66946007)(5660300002)(316002)(76116006)(66556008)(110136005)(2906002)(66446008)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WC82UkNmZWlZRmFzOXlzdWR0dnlmRGlxbENoRXRoelNpVWYvWHZpVlFBTzRV?=
 =?utf-8?B?ZVlqb1RFUmg3S092ZjdKaTY1Uk1kSlhuRTNkZzlMNUlBejl5a29xNHZ2dFlL?=
 =?utf-8?B?aVA4QzNLVFMyekhSQ0pDVTdsbGlFT1pKOHA2VE9SbU80Y1ZOWCswSHc0aFRk?=
 =?utf-8?B?RW8xZ2dNZlI2THVVa3puTFc2TFA5c1ROL0ZzaVdkTGMvS001NVdTNzIxMTVG?=
 =?utf-8?B?QkdkbDlNRnF5RlBpU1kxbWd6RlBrMFdEc0srZHpReE1DMERYM0JlVW5kb3Ew?=
 =?utf-8?B?K28yYkJ4blZaYWxwWGlIcVMzbkNsci94MlBrZS9WeEI5ZSs2cmNnRFBKdXE2?=
 =?utf-8?B?T1RtSm5UdlNmNm1DVjRob1p6bnQ1aGcrN1RGcHplUkxZTzk3WElvOHRPVEhw?=
 =?utf-8?B?VEpPczJBbGMyNE1SNGpZenVVZGNCbVJWblVYVThwREIwcXpwaXdUbkd6RUNk?=
 =?utf-8?B?UjZySXpoS2d5b0hSU1F3b0hweTdHbU12d2IxWXlMWXlUcEQrRTNOMzVoZm9a?=
 =?utf-8?B?Qm9WNFVmU29CRHVQSE1MNFJiL0RXaDlxU2ZMa01Cb3V5TkFWNWdvaXovQnhU?=
 =?utf-8?B?TGJOTXVtL0xyVlRtWTBxeGhxRmNHc082NU5PSlZjU3pvK3NyT21mMGRQeC9l?=
 =?utf-8?B?bnc2WDJFUTMyS1dwY2UzUGdodnBwMWdoUUNnWmovbUVscENaNyt5TkxGTFB2?=
 =?utf-8?B?bHVmUHRpMzM4eUtId2JCcC9HNXdnblRibm4xbElJRzZGYU5DZm1RWmZmaVBO?=
 =?utf-8?B?QlIxeTRibmhVZm9hdFpSSkNubjZySElhb3IzU3FIekdRWGx5dFhPYXhEMVVa?=
 =?utf-8?B?VWdSZ1NpQlJKcEVSY2hnZ0w1MFdjamh2U3Nyek5PaWJBVjQ1ZkROVCsyN2hm?=
 =?utf-8?B?NmZYWG9Sb1dRWFlPNmVxRnBKdHBYQVA4STFHWEIzZ2pZcGF4eDd4Z0Fkd3lx?=
 =?utf-8?B?K1JpWE1ES2JKLzF3TFBvU1lyRm1PU2UrN0x5eGJUc1Vhb3pLYkhRK1k2ZXNU?=
 =?utf-8?B?cGYvaGt6YzNBd1FVTVFITlovaWxBQmJ1RlBlOTVJQXJXZkNJVGk0dzM5Qi9l?=
 =?utf-8?B?TlpXSHJBT2pCTlZpYjdFcGdwZ1ljei9lbHhuTk9yem5CZ3BCWUhEZnIvNXlB?=
 =?utf-8?B?a01LSVVHazhlcWRjNnJFQ2ZXbW8yV09GNDRRbnBra0hhNGxROVBTMktIYUhX?=
 =?utf-8?B?akg1VWM1UXR1RTZqYmpYc1RLUXNOTmpkUDlrRlZPb0IyV0RTTmxSbFlSR2hz?=
 =?utf-8?B?WWxkSW4vcUk2ZWdRaER5RXR2bnlhNnlONk9NWWMwSFhXY1hlVXpZbC9DbVhq?=
 =?utf-8?B?RzRJc3AzMWk0aDFUTkhMQzNRWGpwMVFQb3YvWnFra2N5T29tcVE1RkNYTlQz?=
 =?utf-8?B?TmFwKytIZndHU0ZUNkViYmhNRE4ycHNsdFgwUmRndERnV3UyOHhtN2hjeWRy?=
 =?utf-8?B?d3lmZzh4aFZ1bkRwYkRWTC9BLzRLSUJhSUtTeDluaG9MVzVrUy9CUlR0bklt?=
 =?utf-8?B?TkdkUkZ0TVM3UFRUZzhKQkIyeSs2aE1NdlVyb2x0NE9HMXJJTXJXRzh0UWF1?=
 =?utf-8?B?S0FKSlBuc3V3NHZacWRyM0tmdDloZEk3Z240TlhJSC9OQ2d3YnVXeEwzKzBP?=
 =?utf-8?B?ME04YjNnZjBtTUtRYWJUY3BUTGJlN1lvamxmUitPS2tFa25mZWcrb1FzTlUv?=
 =?utf-8?B?S2RyZ243RUhzZm85SUdxdkVjcW5HdTllU3JBaVQ3VXdRZjJFZFRuTlgveDd6?=
 =?utf-8?B?TEthbmV0bm1IcXY3dURSK1FaWm5LQkdDUXdtSDdUODZKRTQwZ1loQStrcURq?=
 =?utf-8?B?Nng5TTNCZXZ2QjFPdkptV2hwMXozTW9FV2JVNVVaRWZ2R0oyZVJVeWpXU1Y3?=
 =?utf-8?B?eVFjVVZqRXZzWGlXNi9oRnh4OUxoYXlrWDYwMVk0VHN4MXA5RTR5WDQrTWxu?=
 =?utf-8?B?aFZHbGxiYW53MER3WGhkZDNBL1htdWJQbDlTMkZ3QjE5d2J6NXVxZk5qNmRn?=
 =?utf-8?B?L1Mra2M4V1JRVHJTYjNBYXl2QlhDVUFIc0dsdk42OGNOOXVtVUl4cis5SUdI?=
 =?utf-8?B?eU56bFFvdUVPeWJvWkk5OVh6RCtodWVORHEwY05wUStSalBxcTVjVTBoYW13?=
 =?utf-8?B?T0tHdi83MnpEeGdxSmJRczBmRVU1L21YUTBXSTR0Z0JxN0xzc0ZWYnplQXho?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0002BFF67B19554FA608DE5912C92C04@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82911de6-652c-4675-ec89-08db1118510e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 18:53:53.9408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4F7sAn1C8dBKGHFYDyNtfjIhUKAaMUW0sHEqm9YMXG4GlBK/2dbwaqmhDaC/o61LBCHi3ZRcdN16VGuPfsUnjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8659
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi8xNi8yMyAwODo0MCwgS2VpdGggQnVzY2ggd3JvdGU6DQo+IE9uIFRodSwgRmViIDE2LCAy
MDIzIGF0IDEyOjUwOjAzUE0gKzAxMDAsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4+IEhpIGFs
bCwNCj4+DQo+PiBpdCBoYXMgY29tZSB1cCBpbiBvdGhlciB0aHJlYWRzLCBzbyBpdCBtaWdodCBi
ZSB3b3J0aHdoaWxlIHRvIGhhdmUgaXRzIG93bg0KPj4gdG9waWM6DQo+Pg0KPj4gVXNlcnNwYWNl
IGNvbW1hbmQgYWJvcnRzDQo+Pg0KPj4gQXMgaXQgc3RhbmRzIHdlIGNhbm5vdCBhYm9ydCBJL08g
Y29tbWFuZHMgZnJvbSB1c2Vyc3BhY2UuDQo+PiBUaGlzIGlzIGhpdHRpbmcgdXMgd2hlbiBydW5u
aW5nIGluIGEgdmlydHVhbCBtYWNoaW5lOg0KPj4gVGhlIFZNIHNldHMgYSB0aW1lb3V0IHdoZW4g
c3VibWl0dGluZyBhIGNvbW1hbmQsIGJ1dCB0aGF0DQo+PiBpbmZvcm1hdGlvbiBjYW4ndCBiZSB0
cmFuc21pdHRlZCB0byB0aGUgVk0gaG9zdC4gVGhlIFZNIGhvc3QNCj4+IHRoZW4gaXNzdWVzIGEg
ZGlmZmVyZW50IGNvbW1hbmQgKHdpdGggYW5vdGhlciB0aW1lb3V0KSwgYW5kDQo+PiBhZ2FpbiB0
aGF0IHRpbWVvdXQgY2FuJ3QgYmUgdHJhbnNtaXR0ZWQgdG8gdGhlIGF0dGFjaGVkIGRldmljZXMu
DQo+PiBTbyB3aGVuIHRoZSBWTSBkZXRlY3RzIGEgdGltZW91dCwgaXQgd2lsbCB0cnkgdG8gaXNz
dWUgYW4gYWJvcnQsDQo+PiBidXQgdGhhdCBnb2VzIG5vd2hlcmUgYXMgdGhlIFZNIGhvc3QgaGFz
IG5vIHdheSB0byBhYm9ydCBjb21tYW5kcw0KPj4gZnJvbSB1c2Vyc3BhY2UuDQo+PiBTbyBpbiB0
aGUgZW5kIHRoZSBWTSBoYXMgdG8gd2FpdCBmb3IgdGhlIGNvbW1hbmQgdG8gY29tcGxldGUsIGNh
dXNpbmcNCj4+IHN0YWxscyBpbiB0aGUgVk0gaWYgdGhlIGhvc3QgaGFkIHRvIHVuZGVyZ28gZXJy
b3IgcmVjb3Zlcnkgb3Igc29tZXRoaW5nLg0KPiANCj4gQWJvcnRzIGFyZSByYWN5LiBBIGxvdCBv
ZiBoYXJkd2FyZSBpbXBsZW1lbnRzIHRoZXNlIGFzIGEgbm8tb3AsIHRvby4NCj4gICANCg0KSSdk
IGF2b2lkIGltcGxlbWVudGluZyB1c2Vyc3BhY2UgYWJvcnRzIGFuZCBmaXggdGhpbmdzIGluIHNw
ZWMgZmlyc3QuDQoNCi1jaw0KDQo=
