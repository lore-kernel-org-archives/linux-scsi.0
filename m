Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA382C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 03:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiCGDNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 22:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiCGDNE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 22:13:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F7838BCB;
        Sun,  6 Mar 2022 19:12:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yxck8BlHY/2xrsW78rMKXIP9esJXoHNUxHKj6cJ2lBzGzXL4MEWb1fUaAOMrmscew0z1NdYJkOy6T0BeQxkNIIF4tWzCT8TNNKJ2SF5npnvNpaERRnkPmd9S7fxbPItcPLQgxKo6Wc38i+9693Ji++kuwA2dSOUecb04bYa1II5ZWzBWw2ApoaegmdnfTI+HqS2zEGapsyWJkEU4VsKdVwaoFo6YTuKYuHo3Xg6bHfAnuf/tPGpMY1FaeZGxKKs6Psf13tGwSCcofbs4NfMu7+GRPpO5wA1Q23Y2BBaAlQliNHNCeuSKQNYgg19WqTby7t7fYg+E+E7T5KIhUlkJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8toNNfIRiorgXMqkqPK7Ee8FO4jwUhEBRSv87/GveU=;
 b=g1Kn/gImNaHxsVoYSm5uIu6X8FSgNIOZg5SMYA+JOtYEtNSPKcq2lowX+cowZG7ED4XB6x7FnMAoi92+cognuHHJsmMbU87dxBfI4jpPW4JOnUYczB7OJMJl3e0EcYkQa+3dAhwIs185x4MQRfLMJrhmRu+PyOH8FnGootudhCSQgu3l/kCuc4RpiidcG0WVm53/gsX8WmgP6NjgCUPQKSoJOk6B83QSv/EgRq5gdTJSn6Am5LbsCEbLeCTSn7IiBW97QBydOkVdzHkGJTTWW/38ehGCwerExAa/KOrpd0mz70Iseo+qNOawOCRmm+JvFqhiXr+23qpvbUf4VMQi2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8toNNfIRiorgXMqkqPK7Ee8FO4jwUhEBRSv87/GveU=;
 b=kG+v0lAzdR0cl6uV5mmSg+EDnjOgyF7UrFd8yrBoZsR/Y2hydoz2IJOJ1db7fCEzawFKb7oYMpSnxC7GTeQkc1+fQ4pUzpgrNjjiWY9NXhgFQsPyqNZNlik14cBm5Hf3Xt40RCEmcWQQ8lkpXy/GVxGNIg/TPa52pUoZ6FcEAW0oQ5bHYrqT8GizpfqCfU7cZm/olvaOcPlhF5PzfSO1vQMB6+HSio0f0EV4UcTWprXxzCBh37DAYW0p/8yAFQGRkCagKZ0QoMb2t6dRiiTDH8ETrcEZDXEnpbE0R48Bwm4tDyl5CgpGvX6v+ylCj1i+8CVibHhXk2zfNBzKCI0Qcg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:12:08 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:12:08 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 01/14] blk-mq: do not include passthrough requests in I/O
 accounting
Thread-Topic: [PATCH 01/14] blk-mq: do not include passthrough requests in I/O
 accounting
Thread-Index: AQHYL+FxlEIC2Z9nb0qh1RN9XAmhN6yzQn8A
Date:   Mon, 7 Mar 2022 03:12:08 +0000
Message-ID: <bf40dfc9-b789-8e90-0e69-9ca96a35e93c@nvidia.com>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-2-hch@lst.de>
In-Reply-To: <20220304160331.399757-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fab736e-a659-4264-1d2a-08d9ffe843e4
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB185332A6DB519A3626C46EE6A3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: homFzEPrt6IQRpXrTOU/oKP3PAUBzGp2/uDr7zx5ZDUDP5S3XGV+JSqwzzevy/jP5ig0jjROd1UI67D3eOaAXtvlpj8GeIWaIDUspj4WRpDNcr7M8bp1A9wGfTVuUr4nhCBFNHCkjMnavPo0meBZ3xwD0b3JOxfhGemoXvUwUu+GTbvN9GTAunsq7zbBfQFQrVC5jhAEtrYFCBih8xiY1QjETeDlW1MiizXuRLcG3qkPiGT48mHDBbj+6rGHZK5FVv4olchyY1kdK+D9imvpwQOd3eRwztQhXarfle68x9oS24US4m55VmegI896DdfjuEKFrrSPq4wDbrcZrPIIAdFvA/9PGJMpnNbQXfivVEowxVHBuHWz3hoq2cHQTQnAEwrWxYfnoveM3/qPuCDkpKug3YYp62kq6z7wQ6rZqZcq/TPXKv3zzv79HoMQVmSgnCzDeWykVcShb5yy1rWRJ5LQB7cifj9Aa0Qcd3fmh1M/Q1PqrbhSI2mhxqjdolcUCSVbW4cp3N9lSC5nt3EW2X6I3kcMAyL94b+QB5q3AuTv/Yyqvd8tauvCtlZ0d3HEeTitSUFk4vaDsBKLhhSCpofiC+6vJRVUs6bWu8Cc6HxIIGPoLXBpkokL13m2ErNBhfnAKSqO/Z7gV1J5n+zCQAgyYn+LldqiUYqnCyjWZ4EJ0EUnvrrNwRtup/FH61MGUX8xadvS599YMc6cJuALgErMkb+WBHSsEbTVCNd8b0WDqKQ9e9hfqgqMneN8LdBooroPAXdN+HVmquFDJopE9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(15650500001)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(4744005)(186003)(5660300002)(83380400001)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHVDQXQxeUFQb3YvTGJML2hVdG9PYktkeGNGSHBFczUyUlk4SVpBN1V4L1Ix?=
 =?utf-8?B?STUzRENucy9lUFovTHNrWlJvVVM4VVBwUWhmYTluVW9tSnp3NE5wajlEY1o3?=
 =?utf-8?B?UVlVZXMranQ2SWJIWnhhanlYTzk1THFza29JSVBJTGpTelV3RkRaK0kvUlZy?=
 =?utf-8?B?RVhySDlCNWtLZ2tQRXU4NXhnN2V1YTBMUWhCbDdDUUNoMVBMYVllMlFQdkdo?=
 =?utf-8?B?VFF4K0E3VzdiM1BOYy9xbVk5azJ2QnczdnZvaC9XM1UzTGpORFAyYWh5YXBC?=
 =?utf-8?B?eWdZODMvd05neCs0VHowaDdOQWlNbFUrSjVNN3FLSjZxeDRaMytldkZ6Y0F5?=
 =?utf-8?B?dlNBSXMwNUhxM3JzSk9IckZvOGNGejNEOTU3NEZmZVZJQ3YxK2xBMnVrNHF2?=
 =?utf-8?B?MjBCNFMvL3hhWU9kNWprUDM1VTZHeW9kSFM4SWk2Z0pIU2VWbEJxUlJVV1VB?=
 =?utf-8?B?eVlZMUl0TVZseHR5VFlsSVFMRG1xaDZkVUJ2TmpKZ1FOS0RMRE81N3d6b1A3?=
 =?utf-8?B?WHpyeGkxQWRmdUIvZXEvTHpKSmtUeHEyWldUNzRFaVJwVmdOWU9WTzV6cUhz?=
 =?utf-8?B?RmpuTVppeE9aR0lsM3l6OFBBWmdtNVVKTzYyYlJ6c0tuazBIS09rTDd3Zlpq?=
 =?utf-8?B?akx6cUZDb0hNRy9iVEw3R3JVNVcvdU9CcHdqcGs0cjg1RDhCaC9mbjc3eFgx?=
 =?utf-8?B?RUVpR1hGaVNYa25SNjNXc283NGhYTDY4ZzI3YzlKclBtZlFYTTlMMVdPemJh?=
 =?utf-8?B?d2xTekdweFgxU3ZBclZmMnJwdFgrYmZIc0lvTlN4ZHhrOTV0UFQrNnJIVTZl?=
 =?utf-8?B?VmtpbzNHTTBXMStIMkNiM0x0eGxLb1R3MzNIYmVLQzVNbmZ1ZStSaXhZMDVt?=
 =?utf-8?B?QjRFbHh2TTNlWnBKRzJ2TkJ3cnN0ZEtrcHY5d0gvSzNkdjR2OE96TEluU0tQ?=
 =?utf-8?B?YUhDQmpJOUpETVVqemYvV0VPQWxiVXFpUENNKzdzZTMvOHBVTlZZaHRndnNZ?=
 =?utf-8?B?Zy9nb2dVU25pdTAwQng2NzBRQ0h4dHZ6ZDE3OWVDeFdkbnZZalpXVHA3Mklu?=
 =?utf-8?B?L0RTR0kwaXQ1cTlPeWd2QlR2RitBdkFpSWFtSHUvNTgrc0dIN0pzUTd6VTdX?=
 =?utf-8?B?eEFKUjNEOEIyV3RWcWcxbFpNS0RwSVk1OTdLb0dzT1lxVUhHc0ZJeEVvQmVR?=
 =?utf-8?B?OHpyRTk0SVNJZkMvS0RMNVJNT1VWeGhqcENuRi9ZWlNRZDNFZUVLN2pmNDNW?=
 =?utf-8?B?Mm52dGhUQ2xFWGQ5WCtDVFgzbnVKQUwyaCtPY3BLRTk3ajZzNzVWNWF1VTBv?=
 =?utf-8?B?NWNLSzhscEZaRys0NmcvejJ0emZrNnpVQUhBQ0tPczBIY1Y0NHNROU1rdHpw?=
 =?utf-8?B?amp0SVcxMDV1MVBqUFVFNTdTd21INUk5NFlwZ0xIOUd1bWFBOHpYOC82RXRh?=
 =?utf-8?B?QnZIQWdQa29zeElZL0MrOUg5REtJSTZKZ1luWUxoblJ4UURGejNnbnMrQjhp?=
 =?utf-8?B?L25NZTFKV2o4d2VFbEpacUNRQ3pZRk53c3l4blRHTytwVE9TQUVwL2xoOGpv?=
 =?utf-8?B?MkQ5UEVaYW15SzFMSjdtQkl3NkZQaTg5K2VicnNIOHZndUxiNGdPTVMrK08v?=
 =?utf-8?B?bjhRZHJrTWVLY0dLbG8vYUwzWjJ4YmlPTkJ5VFJFYW1JQzE1RmJyMHJNZ1hr?=
 =?utf-8?B?ZWZTaVMvYWRKSk5KeDV1ampqOHVSbEo3N1NQOGtJVWh2NjFUT0FtVUJMKzRQ?=
 =?utf-8?B?bHJUMzBkK21nWVlJZHRsR1g5SDVmSzh0Yk9WOEcyYXlzUW1aTUtOaWNSdEpN?=
 =?utf-8?B?c3dDUXh2RGpmR0toVmxTYjRldzA4RDUyb05zWkhFR2pCcnJiWFFYMXJrSElS?=
 =?utf-8?B?aFBVQmJ3UENaQVJIc2w1NXZNaEUwM2Z1bXdtcFdLY2NySSt5UVhIUCtBTU5v?=
 =?utf-8?B?Vkl5NHUrOHZGTVIxNnB4MUFkTnU1VDViM1lwcVNvTUdGdzFUYStzZmlET0s3?=
 =?utf-8?B?TTA5bnc1L200bERwTS9QWkd1YXA1L3RSUUhjU0pBRjMvZUx1TXhBUmJvS3Rm?=
 =?utf-8?B?V0xWZ0dnWVc5VmxtVm53SlNtWlpkdzRlTkFZUmp3WDAzWk9kOU00NG1BSDBI?=
 =?utf-8?B?cFFkYU1YYUJXRXhqWVBhczFuUFJZY3B6Lys0SFlqM2E2REx0bUxPTEVOMHFu?=
 =?utf-8?B?S2ljdTUwYUx4V1pseFJReTQyOHl3ZWFJZ2Q0ZmJDV09UT0t3ZW1lNG5Xa0Jw?=
 =?utf-8?B?MTRGVmtNZlRkSS9uaGQ1TDR2ODV3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90E523FACC89774DBDED4238012B472A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fab736e-a659-4264-1d2a-08d9ffe843e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:12:08.4592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TB7Tu3pgbLq7Cjdd2gR6AuA43ipWCy+hGe3VuDv21+kS4rFZwurM5nGXdz2JQ+iS96AojLD5zE4HLMNtXOP4nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMy80LzIyIDA4OjAzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gSS9PIGFjY291bnRp
bmcgYnVja2V0cyBJL08gaW50byB0aGUgcmVhZC93cml0ZS9kaXNjYXJkIGNhdGVnb3JpZXMgaW50
bw0KPiB3aGljaCBwYXNzdGhyb3VnaCBJL08gZG9lcyBub3QgZml0IGF0IGFsbC4gIEl0IGFsc28g
YWNjb3VudHMgdG8gdGhlDQo+IGJsb2NrX2RldmljZSwgd2hpY2ggbWF5IG5vdCBldmVuIGV4aXN0
IGZvciBwYXNzdGhyb3VnaCBJL08uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6
IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCg0K
