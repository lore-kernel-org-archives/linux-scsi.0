Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD4CC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 09:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A804460FE8
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 09:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhESJvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 05:51:01 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:57504
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229470AbhESJux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 May 2021 05:50:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYAbRGks0Wvz9NYRDFrGgNnhaGdb2Fc/5XQ1+pT2NIEi5auwpmAa1WStDCoQr6QXOpqi18qosw0yX1Yp5C5uu7WC3c6Tcs/CHjqv3OYUsWxi0VIcHrFRWCjNQGT4/s5iUVP/Ee9tvlyTrY93qoff0ZwxOBArXKWC/U2eKMtdqyGFMnXOGEmz/kw2BmF9J6j8Vd0mCFMGOdsF0u2/n0y7Z7OHvatxm9ePsLQV5W2Hcsiu10xbWv6qe1GbO9Oc9C2c5IvUhmajIl2BSZvMMSN12oHzt7IukLwimkix1QbrGG0W3EwxcrBQkfZImReHDXLAMgoJEagYnuzbXQzo7XL87A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpP+dKxiLgAODHXDDdWWgWiLPRl+M7TGIaYRdb9YMaE=;
 b=FP3TYh3GuBckLE10ZXFE/EB1/fluTTY00+eAHeZ5L0PyJRjvtlf1uFLNIuuS0lSVPijiVzL9naVUXOsv0AzBwY13AOfoJNCW2RuTB/fc8iJ3Fbg/Dg1qxRSfaT2MvISt4VOQm+yPDFqZA2SMidqfd6PmlHCquw6aK6e2ft7eC56hwIZJbKjM7tluuQ2X/7gRoZICmf7igCVy7sfu8jPBA8e9u3pD8q8htjz6PyQxvHvwsPwzaggheUkoA2Oa0g7vEWJFRT0y64uaLXT/5zSI8wsoCcrqwg8gQgduq/utqCpD5BQKQyeJvZ5IBBF3L2Nj8+mm3Sg2u8IScVWAlq27cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpP+dKxiLgAODHXDDdWWgWiLPRl+M7TGIaYRdb9YMaE=;
 b=R8y4JLUuK4ieUwVry2BCJWHPGA6oBiEoHx3k5TKOu4Pm7/6Q1sOdGMQj8W9UlZ2dxU7egLcISxwjy+aESOVFPew5lyf5flv3NszZUZC67xeKF3DUCNZ2CFze128KPdxRfOvVafmASJKJXU5ghSGiDfIoyqBbbOlZwuxyLoFp6hU=
Received: from SA1PR05MB8609.namprd05.prod.outlook.com (2603:10b6:806:1c2::16)
 by SA1PR05MB8456.namprd05.prod.outlook.com (2603:10b6:806:1db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11; Wed, 19 May
 2021 09:49:32 +0000
Received: from SA1PR05MB8609.namprd05.prod.outlook.com
 ([fe80::45b5:ce95:e86d:4fe7]) by SA1PR05MB8609.namprd05.prod.outlook.com
 ([fe80::45b5:ce95:e86d:4fe7%6]) with mapi id 15.20.4150.019; Wed, 19 May 2021
 09:49:32 +0000
From:   Matt Wang <wwentao@vmware.com>
To:     Vishal Bhakta <vbhakta@vmware.com>
CC:     Elaine Zhao <yzhao@vmware.com>, Pv-drivers <Pv-drivers@vmware.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH] Set correct transferred data length for PVSCSI 
Thread-Topic: [PATCH] Set correct transferred data length for PVSCSI 
Thread-Index: AQHXTJREU/9HVwM3VUiC7yNrCeCMcw==
Date:   Wed, 19 May 2021 09:49:32 +0000
Message-ID: <03C41093-B62E-43A2-913E-CFC92F1C70C3@vmware.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [114.250.227.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17389f2a-aeb5-4b52-847b-08d91aab6730
x-ms-traffictypediagnostic: SA1PR05MB8456:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR05MB845627FE4B1474321EF5AD52DE2B9@SA1PR05MB8456.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:158;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oPo7kjJ+R2MmQ3O/LOvrW/1C94WuORKailV1v/hy3XHVOKFIibwelGlepsCfjJi070mnpCWErv2BOsVEtGFCI/+7/f87+NEpaxbfYGtrcq2ThiwBoQKxpmcHcdZANSmrPbl1UgYneHnDF0RE38RubroWpXw9eBOimQq0468SMSOYFZGeZn6kbX25Zn2DWV2P+kBfuC3809OFMx7c+dFVyRWIT7JwrP8ge8Fa5iJWlRhE07M7DT0vMdB0HvBNR+pVZ5gOGohCY4av/p/c5tpdsOhAK95E67TTPNAV/3HyjmUnl7Ayx8+WAkwGSCZrbJTBE7G255GQzlVvUaJ7EREMiV0AH5lS3BLPfzmNz9NasE3JZUcAUmfi4We6+QAKe+dArP29yuOXRv1OCrNlxI34wrgrwBJuna64Ex0lhg6RnyYIc0rTfDffge59L8KkIj+oJn7UU4NV2Hsa9j0iWjLPOTjShXlyBMU+EoWU/s0Cle3shgnmoDdvFa4mF+DMCMx4nfKCUcZmH7ygp74TMuOoiMGLBoruk6cXcUWS2QmY4xq5+84uif+sRUooyn+DxX6vjX1umr8UkRahh6ffTLwoqhjd4RRzzx2mpkg9dA0vLs32XH5MjwHdsVF7JX45QfaHYw67G75BZyilaX7njwe85iBvxiAiSTd7KR4oYLk/KdCzYnxJ6w1gxPAlCH+zBkYY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8609.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(316002)(2616005)(6636002)(8936002)(478600001)(6862004)(4326008)(5660300002)(36756003)(83380400001)(6486002)(6512007)(26005)(4743002)(2906002)(122000001)(186003)(8676002)(38100700002)(6506007)(71200400001)(33656002)(91956017)(37006003)(66476007)(76116006)(66446008)(64756008)(86362001)(66556008)(54906003)(66946007)(45980500001)(505234006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MmUySkhYbDJVTmg2aVNoUW1vOVB4eUZkTlMxWjBmZWEySjhqZEZpdjhLWTlF?=
 =?utf-8?B?eEZLczdXWGNGMHhzdG5pOGZraU8xZExJNDhiODlTUi9kMTZ6TVpNbmkzZW13?=
 =?utf-8?B?WG5DVmhacVFjWWJnQ0xYbjFMeGUxZ2RCa0YrdE9rMzY0UERGanhpS0V3SC9l?=
 =?utf-8?B?WHF4ODluK3JXVXNyeGJ3YnJ6Znp6T043Sno3eDJPK2tiR3JDck9SVlZYdFlG?=
 =?utf-8?B?SkpoSzlNQ2pWWXZ6N3VlOCt6by94cE1hZ3kxMUZDYjhtMDVtdXVVcFF6RGlB?=
 =?utf-8?B?RnVUOEFxM29RODJsMzVlK2trMWsxMGJrejZsRUIwVUxzL3FGc2N3U2RmWWF2?=
 =?utf-8?B?dDNieEJpNE45ODhIaHJPT3B2enk3UHlrZE4wenNLc2YwMUJqSmVjN2dUbTVt?=
 =?utf-8?B?Q0tKN0lzUUNUTEo1UVFWbzZrL3YzSXBSZnVRanZZLzNqb2dQcVV5a3BjS281?=
 =?utf-8?B?WXc3SmVMQTNucnB6eVJEVXdETHY3amp0THBDZXZVdkd5RmJ0M3d3YUVpZW5Y?=
 =?utf-8?B?dVY1d1lkL3VqQmhOV2daL043RzBybGptbGZLUklMcG9HaHRMTVB6Skl1RWtr?=
 =?utf-8?B?QnYwaUVmUTkxcEU5ajlMVWdmMEpOZndBMmtQOTVYOUxtQjZTQTJJOFMyRlpI?=
 =?utf-8?B?ZVBrMldmWGY4a3hWelFpN01sMjkzTzJpaFZDSW5kODBkOUwzT1RocFVrZEtF?=
 =?utf-8?B?MldhZDczT2pZcnhKVC9CNzBpUVY2aTZuNFg4MWZaWDE2d05lNXBoRmo3N1BF?=
 =?utf-8?B?RWZ4b0JxZmxaSjRiVUxGQzNZWGc1bU5BSi9lSHZUZ0dDaW1zaHlRNnZ4eUlh?=
 =?utf-8?B?K2ZkTEVVeTIwZmxXeU10SVRxMlc0dFBYYWFIdXgzbEl2U2tQc1ZUcXN2bzg2?=
 =?utf-8?B?a25VSGRaalRzanhueUQwZFVvK0grTG1PNW1mQTZlVE1uS3h2Q2wrVExiM25s?=
 =?utf-8?B?Ym4yamRlSTM4eDNLUlhuSmFUT0VIeDgwREtiVGJ6OVo1dEI5ZmlXcERrNzBI?=
 =?utf-8?B?MXlyeC9LZ2RkaDVNdzVXeG55b1F4M2NIdTdCa2xRL3hMQVN5Q2UvN25GbWNi?=
 =?utf-8?B?YmIyNnhxL1BIZDRFRW1yMlQ5WFFnZE5rMUVCemdDNlR6UGx4dDRLdWdnR1dK?=
 =?utf-8?B?NVZvN1VFczJ4SnBham9sRU9YS3JoMzFPdWtKcVBia2hoYWhlTFJOZ0kwaldl?=
 =?utf-8?B?NkpKc2tKSFZ5ZC9BTDdITFhlOVNzckd1cmd3TE1Tekt6bGsycGlNdkNPOWQ2?=
 =?utf-8?B?Yk1JQWM4OVJuL0MvbmdCdDFkL1FuYWpKaW4xRjNoQ0FXeDFneEhpbENxeCts?=
 =?utf-8?B?S3lPeTZPOEx0RGYraDRLaTBGQzRkVG1xbkhqNlovL1Q2ajMzWGF6bGxXK3Br?=
 =?utf-8?B?SDZnL0tJeFcycDJHbVQrcjNmc2IwYkI2MFhlQ0s4aUpQNUlOSTVkY2NnUWE4?=
 =?utf-8?B?ZUJJaGlXQjVtV2Q1MXkra1d3R2pkN1M1cnRVTDUycFk0WWlxMEQxWCtHOWdo?=
 =?utf-8?B?eVZqV1lmOVVYdTE4Z1hEbHdqWW1XV1RtQmJOb0lNcm5hRkF0cmtjSXE4SjZR?=
 =?utf-8?B?NVIyMUFSSU41Yzloc1NqTjRNbTlXUmhieWZBZlpleVpXZ2hTVWI1Q2w0cGY2?=
 =?utf-8?B?UFRNNGcxOFVGdUxqakgrcnFrOFYvRVZoazRmMlJ5R3pKU0tzaE5MMG96aGhJ?=
 =?utf-8?B?UVFKTEMxM09WZmtRbms1c2t2YVhEUTgwb3I4NWxwRVA3dFhzbURZV0VFTDhI?=
 =?utf-8?Q?b++zg1PsyNSULSRBpU8Dkqmjt4TjBVSGOCdjieK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30FDC38FB7CF6B40AA6168CAADAD2BCE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8609.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17389f2a-aeb5-4b52-847b-08d91aab6730
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 09:49:32.1493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CpsTY50X51zKgbLOOZDkJLdLjtI/b4EvjqeqX3kq8YWEAAJTZZqCKPBpJPC7d9f0vqqRPp+oU6IQ1iDujPACnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8456
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29tZSBjb21tYW5kcyBsaWtlIElOUVVJUlkgVlBEIHBhZ2VzIG1heSByZXR1cm4gYnl0ZXMgbGVz
cyB0aGFuDQpjb21tYW5kcyBkYXRhIGJ1ZmZlci4gVG8gYXZvaWQgY29uZHVjdGluZyB1c2VsZXNz
IGluZm9ybWF0aW9uLCBzZXQgcmlnaHQNCnJlc2lkdWFsIGNvdW50IHRvIG1ha2UgdXBwZXIgbGF5
ZXIgYXdhcmUgb2YgdGhpcy4NCg0KQmVmb3JlIChJTlFVSVJZIFBBR0UgMHhCMCB3aXRoIDEyOEIg
YnVmZmVyKToNCnNnX3JhdyAtciAxMjggL2Rldi9zZGEgMTIgMDEgQjAgMDAgODAgMDANClNDU0kg
U3RhdHVzOiBHb29kDQoNClJlY2VpdmVkIDEyOCBieXRlcyBvZiBkYXRhOg0KIDAwIDAwIGIwIDAw
IDNjIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIC4uLjwuLi4uLi4uLi4uLi4N
CiAxMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCA0MCAwMCAwMCAwOCAwMCAuLi4u
Li4uLi4uLkAuLi4uDQogMjAgODAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMjAgMDAgMDAg
MDAgMDAgMDAgLi4uLi4uLi4uLiAuLi4uLg0KIDMwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIC4uLi4uLi4uLi4uLi4uLi4NCiA0MCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAuLi4uLi4uLi4uLi4uLi4uDQogNTAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgLi4uLi4uLi4u
Li4uLi4uLg0KIDYwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIC4uLi4uLi4uLi4uLi4uLi4NCiA3MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAuLi4uLi4uLi4uLi4uLi4uDQoNCkFmdGVyOg0Kc2dfcmF3IC1yIDEy
OCAvZGV2L3NkYSAxMiAwMSBCMCAwMCA4MCAwMA0KU0NTSSBTdGF0dXM6IEdvb2QNCg0KUmVjZWl2
ZWQgNjQgYnl0ZXMgb2YgZGF0YToNCjAwIDAwIGIwIDAwIDNjIDAxIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIC4uLjwuLi4uLi4uLi4uLi4NCjEwIDAwIDAwIDAwIDAwIDAwIDAxIDAw
IDAwIDAwIDAwIDAwIDQwIDAwIDAwIDA4IDAwIC4uLi4uLi4uLi4uQC4uLi4NCjIwIDgwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDIwIDAwIDAwIDAwIDAwIDAwIC4uLi4uLi4uLi4gLi4uLi4N
CjMwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIOKApuKA
puKApuKApuKApi4NCg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXR0IFdhbmcgPHd3ZW50YW9Adm13YXJl
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS92bXdfcHZzY3NpLmMgfCA4ICsrKysrKystDQogMSBm
aWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3Ztd19wdnNjc2kuYyBiL2RyaXZlcnMvc2NzaS92bXdfcHZzY3NpLmMN
CmluZGV4IDhhNzk2MDVkOTY1Mi4uNzNjYmEwZWM0MWFlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
Y3NpL3Ztd19wdnNjc2kuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Ztd19wdnNjc2kuYw0KQEAgLTU4
NSw3ICs1ODUsMTMgQEAgc3RhdGljIHZvaWQgcHZzY3NpX2NvbXBsZXRlX3JlcXVlc3Qoc3RydWN0
IHB2c2NzaV9hZGFwdGVyICphZGFwdGVyLA0KIAkJY2FzZSBCVFNUQVRfU1VDQ0VTUzoNCiAJCWNh
c2UgQlRTVEFUX0xJTktFRF9DT01NQU5EX0NPTVBMRVRFRDoNCiAJCWNhc2UgQlRTVEFUX0xJTktF
RF9DT01NQU5EX0NPTVBMRVRFRF9XSVRIX0ZMQUc6DQotCQkJLyogSWYgZXZlcnl0aGluZyB3ZW50
IGZpbmUsIGxldCdzIG1vdmUgb24uLiAgKi8NCisJCQkvKg0KKwkJCSAqIElmIGV2ZXJ5dGhpbmcg
d2VudCBmaW5lLCBsZXQncyBtb3ZlIG9uLg0KKwkJCSAqIFNvbWUgY29tbWFuZHMgbGlrZSBJTlFV
SVJZIFZQRCBwYWdlcyBtYXkgdHJhbnNmZXINCisJCQkgKiBsZXNzIGJ5dGVzIHRoYW4gYnVmZmxl
biwgc2V0IHJlc2lkdWFsIGNvdW50DQorCQkJICogY29ycmVzcG9uZGluZ2x5IHRvIG1ha2UgdXBw
ZXIgbGF5ZXIgYXdhcmUgb2YgdGhpcy4NCisJCQkgKi8NCisJCQlzY3NpX3NldF9yZXNpZChjbWQs
IHNjc2lfYnVmZmxlbihjbWQpIC0gZS0+ZGF0YUxlbik7DQogCQkJY21kLT5yZXN1bHQgPSAoRElE
X09LIDw8IDE2KTsNCiAJCQlicmVhazsNCg0KLS0NCjIuMTcuMQ==
