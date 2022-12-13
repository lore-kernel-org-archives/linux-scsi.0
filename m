Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886FEC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 04:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiLME6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 23:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiLME6w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 23:58:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAF31DDED;
        Mon, 12 Dec 2022 20:58:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSCUiM/ab4h5SQqZWgM13AC16V8B/6gx1liSWgwWLy+vJQ+oh8ioZXDFwhDfIKUFfWhE7gCt/ESKWuo7GTyXIz1oXmVyOwi1urKTXMi/I/rKdXP143fjNrUAfTj1lEjf8qVr33UrAAkHXUBRNM7Oz+BrqkqaH5PHbsXNqV9wbVWKULNsxujDqaW5FQNufvDaWtdWIgHGfXE86ziRtaonpJsom3zeM9Nsjvn7N6G7oVbprB/KM/Cemd2dnnpbCWTXKMDapWU1lgQvA238nbllOnfWDx/G6ID0xq6CFIazp0OAJtffAXPCqC4kixIEAZq0Zf8/yk6udJWYcTTIqspr5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5Cu40X7fBFJhXSmqBl0+uTQlWU+llz9IiXo4/DxclI=;
 b=dBdrkFC1ISB3oNpmNidwKeD3Q1vwz812YhA7zUz9hmYBco9NZk8OoBQ2NuJTW7brsQ/urc9tYfO2GdEUDtWarwqLENO+SOcY1B8MfQRHX/m+552PC7eSZDW/Y4we9eXYtps5E8BwUdB8jG8c6Z6Q7yTAuUe4AL+5RrL5F8q06Dk0VOyJshxK4ovyTAdnfX8rBULklCdGW33RiuBD4BhLBO/o/IiZ2oARdJnJM+dYAsX+KppZNu2HvnUgzAZFsHmNVZFYKGyFZF8q7jn1VmLpN2tUETslwtbfu685+chwwFrJP54K/NXbcsyDcyYIQkUIYcMS8rZTL69PCeTMs30qQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5Cu40X7fBFJhXSmqBl0+uTQlWU+llz9IiXo4/DxclI=;
 b=Vg20nHqwhY4Q3mouvhwD903w4XXxlS+q+d8SmuAXv3olQbeb1yC4n2dZzQVMWTKxWlTkSCCvYWuPEvPvwfqxjUEJPjXxrYg31gzpj8yUBZswFrngzgfvV/91pOkC+LyCFjNugXaB5RsFFLidkb8Mqhs+MUNfw+ctAEkm6PBJGb/et2flOYfWgvL2YWg3kgXhLNRgfDnj4qgYn+ZdjxU4cD0BgGowC9kR/nsGZCmjYAzHbNHOmt7zfk12RbCivRg57ab/I4MK+wBuNZGPXEjmE044u/cb4gnWginL9d9Q4vpVsxF6i1AV8y0GctRL25PYKC6KPDZfjGfkCwTQ9AZE9A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 04:58:48 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.018; Tue, 13 Dec 2022
 04:58:48 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5iC2yAgAAudgCAAGdJAIAAQiIAgAhqUoA=
Date:   Tue, 13 Dec 2022 04:58:47 +0000
Message-ID: <ccb5388d-4976-31a3-0559-e94c14c90573@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221207152116-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4084:EE_
x-ms-office365-filtering-correlation-id: fc9f4e0e-b726-449e-ae91-08dadcc6b854
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5c2C/jj3PCk/VcBCMbSxJ8aId34uqDeTKsd7c3aNtC00z6wN+SUl6Un6GCqo5pngq7aYcOtD2ofE9Z2f9pbyMVVH/dirpIso66eupOtK56JU4zGvTO2VOnrnhjCeUFWEmXE6TzVzIW+h/jQ+plhWvp0ntcNHrvca4E18Wi1pM8uCkQkZQuJiMaJxJihWb+bxBsF09fBWVGbPJOAGcfYdLtXXPNwoxmmwJ1u+tTRkUw3fpAuAf4dpQaky83gCZQRBd+PeR/9+WJc/Q0nYxYLWMJhNDiCevO8ZGWcjohNa2PPzzmEHn7RkDjXNeePk+DSbjMXm8mvPmN7+ceGHeWXbWBWeQ7IW0ZEgIoBmGHCwi7We4No1o9LBvWlvoZdddgM0HBjPVMB17V35hLP9a0g5TM8nAl3seHeFyG4n+P0Kg+E10ArqNr2vztVRgd1ITDdjyaJ/FuD0DRxg+MprMtvEeJfHZaEoAjnztlFh73fnqJ5NwOtndv86QopcRtGvQTwMwbei/vcx1OyV7X3hUyEtWRQjauSHs95glsaU+i/8OTZsWfW7VAQTGcpkk6uzbkSZTqqZWh6iuP3Bx4Hyc/M4Etevd9Pc2f2OZRm0HVgXMMVHRHM4eu3/aYx+6VIbJzqSjU3JPewJG1VkmamlFsoijgvDdwzlCCQrpjOqmWd6tLoyj+sTPjZqZr21grv271s0VzzFn/EwgnHG73XwObMY+alkG59wc6FfeBY9J4QE1gCHRcnqVMyUXxTXpkR3cgCZ8KxdSf5gW7mRj35zFcLK5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(478600001)(2616005)(186003)(6506007)(38100700002)(6486002)(53546011)(6512007)(122000001)(71200400001)(91956017)(66446008)(4326008)(64756008)(66556008)(316002)(76116006)(54906003)(41300700001)(66946007)(8676002)(2906002)(5660300002)(66476007)(83380400001)(6916009)(8936002)(7416002)(31686004)(31696002)(38070700005)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M25TcmVWcXZtbFE2OWFBTXhZM2JydXFMSXQ3V0k5cHJ4dGpudjV0MVpITEdG?=
 =?utf-8?B?emxBZFVOQ3YyRGZQREplNFpVL2RtOVhDTVVEZUI5WUNqaFZCLyt2eHlRM2JX?=
 =?utf-8?B?M2R3cGF2MXc3Z0ZLUG5tMUNnZ2lXdlkvYUJkZk1LK2FsMjY2NEh3UVRaRHI1?=
 =?utf-8?B?cnpiSU5tVlFLeFp0RzZGMVFMSGcreFlVWWc5bTZKdnBtajRRMGVuZFpmVVE1?=
 =?utf-8?B?SllBbEYxS2VxOWxXZmZPSjNmWWlUcGFGcVZMR1BkMXhFT1dBankzbDA0R0hk?=
 =?utf-8?B?V2MxS2hjYmtYT2ZLSHM0YlJUbDJvYjdaMUo4Um9Tcmk2c3F4Y3J5V21qazZ1?=
 =?utf-8?B?dStQTzlxYVo0Skdhdks4RUZvQ0lwb05VRTJzMitIRWYxdXpKb0xwSjF3V1RU?=
 =?utf-8?B?SHJONmRmazJtVWRDcXlRQ20vZWlPVUU4QzZLQVM3WHlNWG4vMlpkRGdVRGtB?=
 =?utf-8?B?NHhoSE84Z1ZMVy82M0E4OWNHMTZJMSt1cjFQRUl3WG1CSUQrWGY3ZXdsd2Rh?=
 =?utf-8?B?T0c2K0JMb1FCSGlCK0VYR1lGalRiaHZUd1ZnMGFzY0pEREVYT0p3MXBlZHhR?=
 =?utf-8?B?MDBsK3gzWkxiWTJGeU1xZ1hlb1NRNncxUjUya1FkS2JPd21yYlVDektrQXkx?=
 =?utf-8?B?UzJYYkplSW5kQzEycVN5NUVveE5xcE81YjVyNW1CSVRWbWhpNzlKZW9pdVli?=
 =?utf-8?B?R0xNVVFXVVNBMUdxdFFPZXQ0V1dZa3o1dWtuT1pGMmpiazMvKzJYK1c4djBX?=
 =?utf-8?B?aHk0RXFhQVpYaVVkQXJsQThVMjJhL3Z0MnppMllNWHhvRnRTRG5pcjJJMmtq?=
 =?utf-8?B?TVp4M25OV1JsQ3grMkR5M1NHWlJZY3ZIMTZld3RKZFNwNnl3bnZ6TW51aTBp?=
 =?utf-8?B?QXZCa1AxSVQ1d1U1Mm5lQ0RyU29QTTBvcUpkdXVmdlpZOGQ2TDJxWFNTVVNj?=
 =?utf-8?B?UVZnNmROeG5obm5ERSt4WW5RYnc5bGo4UzBqVDQyVEsyVGFVRnhzZkJidEtM?=
 =?utf-8?B?bkNvQnUweGFmSE1yK1FQSXJYWGNXZjJJZENtNTAvcjdyUTFPS3V2R0p4OHgx?=
 =?utf-8?B?bVpFUHRFZXBFZ0MwenoxaXZmbmdyS1dRUzlySHdJZmw3Q1hRTURLRXlQVksz?=
 =?utf-8?B?dXpmUkVpak1wYzVGanQwN1V4dU5GSlYvUVFjVmhpbzJTRHl3MEtGZ2JDMUJD?=
 =?utf-8?B?M1hSL29jQnlOMk1BSXd5M3hLeE42azRkcGtKcmkrRVRCbzkyeWxMTVNZOHlW?=
 =?utf-8?B?WHRoaVNqRDN2TU9yZHdLOUU5NUY5Y2I0NWx6djR0c1plVE5LTU80a0h4VzdR?=
 =?utf-8?B?bTNoTElPN1NWYTQrRHZ2ZkZWMTY4VUgxMGVMTk9tSUxqdVdlTEtkUmFzNTA5?=
 =?utf-8?B?OVJ2cTgvb2k0T3JLWWx2dW9jc0FBOEhCOGZaNFd5L1F3N3RmemxWc3NKU3lT?=
 =?utf-8?B?V0FMZ1RnMncwZWRvcEJnV2RQaFI5b1NyUmxXZ3NoS0hudW9XU2RPWjJ4QS9k?=
 =?utf-8?B?VWo0L3owQU5FNzhyM25qYzJJRll1eGo4b09jSHpTdmlkdjIzWWpvLy9xaTNP?=
 =?utf-8?B?RDB6bUM3OFNPMDcwaGdHa0Z1bGJLMVcyNThFSkNCcDhxOXF6VWZoVWJ3SGRh?=
 =?utf-8?B?V3FsRCtaWStwNE84ZjJHY0lzMi9YUjhrem1qM21vdEV6MEMzdEt1em9hU0hF?=
 =?utf-8?B?YzNDZVBXN3IvbWZBTy9EZkNJNGlJVldsbXJtZGhwNysrZDhXeVdIRTdyTk1o?=
 =?utf-8?B?MDhvVjhQQ3UvVDJQeHIrUlRDV1RReW8yYU51S3NRNDg5cG5URTZxeksrZUJT?=
 =?utf-8?B?RmltUW5sWXFQakJ6L3V3NExFN2pwQUxsZzRXNEgvemM1aTFleG9rWkNMZU1K?=
 =?utf-8?B?NUtoLzA0YkczZkpZTXYrenczWThndDVHeGtyTE5wSVZLZFZvTVZ1a2Y3OVhi?=
 =?utf-8?B?RTVJUVlrQWdJYy9zVEFwZWw4WU44OFE2d3ZTZ2pESzNyV052MzlpODVraXVI?=
 =?utf-8?B?YzRpTFYrc2llQU5CTkxtV0toMkduanFEQ3FCb0htaWhYUGdTZ0NPR0FqMW5z?=
 =?utf-8?B?Q2Q5SUNJWGhoVHY0ZDRqVzhHa2pjVXFtaVlpaUxpRjRIYnQ5Ri9BUHFaUlNn?=
 =?utf-8?B?RzM3YktuVWZGOGp3VEpsRlF1cEJaR2JTcUVJRmhXVFpIQXZxdEY5YlNaUzQw?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70AC3461D2143E43AFA0EDC75B1C868F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9f4e0e-b726-449e-ae91-08dadcc6b854
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 04:58:48.0070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 95YJvDqpkp620B7eP6xywRSfAjobBGVyVpAsDeq9uoWGFoK4SeVVyWFrw7f9xy5q0HfGALEIj5eRsnKq5Zs4hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWljaGFlbCwNCg0KT24gMTIvNy8yMiAxMjoyOCwgTWljaGFlbCBTLiBUc2lya2luIHdyb3RlOg0K
PiBPbiBXZWQsIERlYyAwNywgMjAyMiBhdCAwODozMToyOEFNIC0wODAwLCBDaHJpc3RvcGggSGVs
bHdpZyB3cm90ZToNCj4+IE9uIFdlZCwgRGVjIDA3LCAyMDIyIGF0IDA1OjIxOjQ4QU0gLTA1MDAs
IE1pY2hhZWwgUy4gVHNpcmtpbiB3cm90ZToNCj4+PiBDaHJpc3RvcGggeW91IGFja2VkIHRoZSBz
cGVjIHBhdGNoIGFkZGluZyB0aGlzIHRvIHZpcnRpbyBibGs6DQo+Pj4NCj4+PiAJU3RpbGwgbm90
IGEgZmFuIG9mIHRoZSBlbmNvZGluZywgYnV0IGF0IGxlYXN0IGl0IGlzIHByb3Blcmx5IGRvY3Vt
ZW50ZWQNCj4+PiAJbm93Og0KPj4+DQo+Pj4gCUFja2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4NCj4+Pg0KPj4+IERpZCB5b3UgY2hhbmdlIHlvdXIgbWluZCB0aGVuPyBPciBk
byB5b3UgcHJlZmVyIGEgZGlmZmVyZW50IGVuY29kaW5nIGZvcg0KPj4+IHRoZSBpb2N0bCB0aGVu
PyBjb3VsZCB5b3UgaGVscCBzdWdlc3Rpbmcgd2hhdCBraW5kPw0KPj4NCj4+IFdlbGwsIGl0IGlz
IGdvb2QgZW5vdWdoIGRvY3VtZW50ZWQgZm9yIGEgc3BlYy4gIEkgZG9uJ3QgdGhpbmsgaXQgaXMN
Cj4+IGEgdXNlZnVsIGZlYXR1cmUgZm9yIExpbnV4IHdoZXJlIHZpcnRpby1ibGsgaXMgb3VyIG1p
bmltdW0gdmlhYmxlDQo+PiBwYXJhdmlydHVhbGl6ZWQgYmxvY2sgZHJpdmVyLg0KPiANCj4gTm8g
aWRlYSB3aGF0IHRoaXMgbWVhbnMsIHNvcnJ5LiAgTm93IHRoYXQncyBpbiB0aGUgc3BlYyBJIGV4
cGVjdCAoc29tZSkNCj4gZGV2aWNlcyB0byBpbXBsZW1lbnQgaXQgYW5kIGlmIHRoZXkgZG8gSSBz
ZWUgbm8gcmVhc29uIG5vdCB0byBleHBvc2UgdGhlDQo+IGRhdGEgdG8gdXNlcnNwYWNlLg0KPiAN
Cg0KRXZlbiBpZiBhbnkgZGV2aWNlIGltcGxlbWVudHMgaXMgaXQgY2FuIGFsd2F5cyB1c2UgcGFz
c3RocnUgY29tbWFuZHMuDQpTZWUgYmVsb3cgZm9yIG1vcmUgaW5mby4uLg0KDQo+IEFsdmFybyBj
b3VsZCB5b3UgcGxzIGV4cGxhaW4gdGhlIHVzZS1jYXNlPyBDaHJpc3RvcGggaGFzIGRvdWJ0cyB0
aGF0DQo+IGl0J3MgdXNlZnVsLiBEbyB5b3UgaGF2ZSBhIGRldmljZSBpbXBsZW1lbnRpbmcgdGhp
cz8NCj4gDQoNCiBGcm9tIHdoYXQgSSBrbm93LCB2aXJ0aW8tYmxrIHNob3VsZCBiZSBrZXB0IG1p
bmltYWwgYW5kIHNob3VsZCBub3QNCmFkZCBhbnkgc3RvcmFnZSBzcGVjaWZpYyBJT0NUTHMgb3Ig
ZmVhdHVyZXMgdGhhdCB3aWxsIGVuZCB1cCBsb29zaW5nDQppdHMgZ2VuZXJpYyBuYXR1cmUuDQoN
ClRoZSBJT0NUTCB3ZSBhcmUgdHJ5aW5nIHRvIGFkZCBpcyBGbGFzaCBzdG9yYWdlIHNwZWNpZmlj
IHdoaWNoDQpnb2VzIGFnYWluc3QgdGhlIG5hdHVyZSBvZiBnZW5lcmljIHN0b3JhZ2UgYW5kIG1h
a2VzIGl0IG5vbi1nZW5lcmljLg0KSW4gY2FzZSB3ZSBhcHByb3ZlIHRoaXMgaXQgd2lsbCBvcGVu
IHRoZSBkb29yIGZvciBub24tZ2VuZXJpYw0KY29kZS9JT0NUTCBpbiB0aGUgdmlydGlvLWJsayBh
bmQgdGhhdCBuZWVkcyB0byBiZSBhdm9pZGVkLg0KDQpGb3IgYW55IHN0b3JhZ2Ugc3BlY2lmaWMg
ZmVhdHVyZXMgb3IgSU9DVEwgKGZsYXNoL0hERCkgaXQgc2hvdWxkDQpiZSB1c2luZyBpdCdzIG93
biBmcm9udGVuZCBzdWNoIGFzIHZpcnRpby1zY3NpIG9yIGUuZy4gbnZtZSBhbmQNCm5vdCB2aXJ0
aW8tYmxrLg0KDQpIb3BlIHRoaXMgaGVscHMuDQoNCi1jaw0KDQo=
