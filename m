Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC3EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGEGlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGEGlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:41:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5781B2;
        Mon,  4 Jul 2022 23:41:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlUwFOv6mK4xJ9Y7y4Pe7a46n/JLHRzdbuC3IKOsE281HOU5X5UjzkNOx7WE0gw2Gf7lseo6MU/eDiTQrvmAlz43ph3wNCUMuahugSGLW4Xl4T7jGgYPlO67f5fNpmekNsnQdj3fgxnozI+wJo/snwe1X14r3tzBrPmUHbnDp5x7OZmGpqayFWZxAfhnC9ogKbFL1pECUpzmBn4rfjRMeBkS+mfaqsGDlXv6bQGLU1PzQHdTMx+qfO5ppEibpSM27kOMg9r9Q8cqAY9lSTwJIlcHwU43MtuwmSpzP1q+BivJaJlvP4Ur73O+FbzgpP47mcQ7edVcPqQFjx9nFiHWHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWPaw8YvFXaaMmrak6o8vz/GS7GcgfAf1T9OFKfkamU=;
 b=csKW/iEEL54Y/Ub3KqZcxE+ppdiInBlyisHgpiZkdfr38iS+gXviPc9e/a05WxDJ/YixS5oxOKxHUM5GEwSoGo2pwUfKNGWckgf8sLRdAaotMdgtXimqknq9PjeE1mFaTZ/BcoTXynRwxSNPDTxz1tjKOvYMIECQQvOl36Ae2isKnM5WUqVDmBSwT99F/IyZvnr/P3rlVgSSrgOPvEC4ekEN67yEfgDcdyUTYr+tJijgmP/vK7+1Ne2bHrI8OHo/hY3y+FATxhtjK/fZ1eW/qq6ZSlUmsBalFfkdPnQ9tcUelETvGled1s5X5iKf6xTdrWK/bfJxEiPpMTMtmnX89Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWPaw8YvFXaaMmrak6o8vz/GS7GcgfAf1T9OFKfkamU=;
 b=cyZVhz8gMVkyn47CnttBNu8R0DKfT3Gyn+waMOCEYbl2wYGSGPc6OVwGku4IHS7VoYGpzXKbVPg0U+lGWd6UCIi67ES5V7ZPGJuqgsheBkWH6Hx2O8KBMNYigWl+rJx9258ruPqHeRtMWlu00cFR5irumxkK1LU6Dp8sY8Q/UrjQ/43GrxyPgrNesamBebESt7/JdovlxzRpDB1O/fc1n6zPo0QCLl1jz3ynnKHkivjaya6gFL7ZkvHbvFWQohJMRNg0Xf1xkm39XoB2WqRmGDa7iUwrX1mCG2TYAvhluCZ/8AEuec4SFkzYuy7DHi2e2yBN5FCM15w3ezICFiATew==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:41:43 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:41:43 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 12/17] block: pass a gendisk to blk_queue_max_open_zones
 and blk_queue_max_active_zones
Thread-Topic: [PATCH 12/17] block: pass a gendisk to blk_queue_max_open_zones
 and blk_queue_max_active_zones
Thread-Index: AQHYj6QD0eaI4k43GkKp8FM3917Xm61vVUwA
Date:   Tue, 5 Jul 2022 06:41:43 +0000
Message-ID: <2e8b8d86-f79e-9189-b274-7d5e8a86ecfa@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-13-hch@lst.de>
In-Reply-To: <20220704124500.155247-13-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20d445d6-2c10-4c0d-586e-08da5e516c84
x-ms-traffictypediagnostic: CH2PR12MB4837:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qY5gRgJ1tdBI6X9U206u3TOQMWMrodBnKR7byKqZsSS+i8LGka8EpRm7fddV6Vc3oFCC3Zyj1GsFjQTlcTC+I67Nk+ikoBuaax0RBVRKOFE3IRJnMWdFLsFfkhuAdhaUKi0bZUiVYIqV2VEY4aLy2zdLsB4kefbuSTCzBd8OP+SSqwsCFUfF3EQWe7kbd2JHo6RZ4RFdmyfroM5Xgg+hiSfBMDUesL6dDgnhFnBg2U8o2ln6/3KCQ1YbWQQNmq7M8Y6qnNPk+KHD37+2RLWailyrtla0mpw/aJxDuK3zf0iv4ruEoy19K0gZpIZB7kwFPNqvATNGtGvEhtjahAmok4gOTuaOdQ2Wfu9Mlu7BSg8tO2J9MrGyugFTNSPjARRbZwOUIB+CKJQFc98CTKLhhsbcRdB/nLsWbxTS/pcW8BlcqUAl5/3Ov1A1CUrn8FrAEMa0A6o4YAYRYlfRYZ67x+ac7VmUz7U9SwTUsFsm52av+80E776ud0m9YPw59w8wCdH8Xt6ChRDLqV825Y/UYIqHb+dhX+p2Fpta137FxNYPBUHH7vkxBpepOIjT8tXeKNJNRZaj8Ai+ZaVQr91zpsPt16PypLmC+p0k09m69EASpjhhp3XVp+0OP29H3UhIaXpzUUyrqwn94WmL55iN6jvn4IBCpz+af4x4z4qjIoCf+SwxJ8/WzqLLIAcSj6zQKjMHIZzv70OpdqaVcfAxm08DQnbuWGI2Fx87tDCqCam1V10x+RrwptDuuSkVo1qtpB6aE3wSPkFTMfztwukDAjiCiUX9gKRKEhhGNAF0CVxmKgGhRtRMs2sOuns5yKNq69ET5QEZ6d7ZSTQVSS0JZ4L9VLhHrgOES/87U8bIPMP6DYN9hhHSZIpFe9lu5IMW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(8936002)(31696002)(86362001)(478600001)(6486002)(83380400001)(5660300002)(558084003)(2616005)(36756003)(186003)(31686004)(316002)(54906003)(110136005)(38070700005)(2906002)(6506007)(6512007)(38100700002)(122000001)(41300700001)(91956017)(53546011)(76116006)(66946007)(8676002)(4326008)(66446008)(66556008)(66476007)(64756008)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXRLcXRzU2dHb2ZIeWlMNzFFY0JTY0Q5UmM1WGNyZUo3QStHY2QvVGI5TVVI?=
 =?utf-8?B?N0YybFNYOVBWSnhIMmpaTVU1NVFOVnlITytzbDNlSkVITFVRU055b09aQy9v?=
 =?utf-8?B?YU1ZeGk1cEJvdEo4bGZPc0hUQUVVTWt1Zk5JZUo4d3c5Vld1ZkdOTVlYakQ3?=
 =?utf-8?B?bnVFUE1uN0R3NVhPdGFqZjhPUnU0UjkrbXBuaGVPSklCWm9QNWV4bngxbjdV?=
 =?utf-8?B?Skl6eHlXcjIwN0RKNFJ1Z0tvTlJhSC9VTFRJM2hldHZhNTVGZVlaUzJYL3N5?=
 =?utf-8?B?eDlEMXVCa25iL2lmSmtwclh4YjYxZkZJOWhQQWsveS9XRDlXUkNrY1lOSE4r?=
 =?utf-8?B?NVlXNWx6b2w4WXhJaE5sQU1CSnN2NVlDTmY2TXZVYVJ2RWVrN0NzODlMVnE0?=
 =?utf-8?B?MS9salRTRXRJcFRnWGZrWXRmdDdEV2JpamVWSkx5WHZoSC9WSGNyTmtJNUNr?=
 =?utf-8?B?anlGODg3QVhnM2FjSzdnOWZHR1hRUWt1VU9hTVUrTnJJRk83L01EdnVzOURi?=
 =?utf-8?B?eHpXbTR5NG54WEVEQ1o5MUpyOFk3ZG5FZnZVbFVvWEVMWU52Rm0xQkMrekpv?=
 =?utf-8?B?bmp0YWFhVGJ3enFNWEJUTm5YMnl0MVlKQ2twSEhLTWNuQmRCaXNFMVRKR1RR?=
 =?utf-8?B?S0pIZWlGeHR4Rlc4U2MxamZyQXduWXQwUGx3bW1FVEN2ZUw4aE1hVDJkME44?=
 =?utf-8?B?QnVrNGxJa0JYNy9qMVdvL295YlVtMlZScHpiOGRjMmNIUjBwdm1CaFZkdzdw?=
 =?utf-8?B?eFB5UU9weDBPaWlLYURVQjlnUTk4NDhsTzhVYVZ0WFpicmJFZmcvbk1IdXFp?=
 =?utf-8?B?aG9qd2NKRU1EczlkS1JZTHpTcVp3NXZCeFphNXpMK3krd1FaRFE0dmxGakZS?=
 =?utf-8?B?cTV2dTZxbjhuV2g3VUJyWjJkc09yamJjZFNwcGhieElkQ0lUU1RZa2QzTUla?=
 =?utf-8?B?MDV1YjJBd0FSc3JlYnhUWWJ6VXZ6VE5SNzdLalM0ZncwSm5kSnVuNkp0NmNM?=
 =?utf-8?B?OWRLYzkvbUJJYjgvc1QyUnNMaGZHM1hOd1FmRmtoOHR5c3JlbEEvVlFTdzZ5?=
 =?utf-8?B?aVdZQ29lZzdvNmQ2WDZWRFZWZktlUDBEZnNTMTM5SVJTRUgyWFpkUlkxMjVl?=
 =?utf-8?B?ZGFHbmQwSm1POXpCQStiWlA3NTlxS0JqUEdPVHU1WDlXNkNLNDJEclhVNjFt?=
 =?utf-8?B?OW91dnhFWmlLL01ZMTN2N3BNTVYrTnlxd09nR1pmUXZNRWRCelAxSVFXSlBT?=
 =?utf-8?B?MUVkWDkwRUNrcldzQUZFd2d5VU5vSzB6NTBMem9KL1pYMXExRW5LZ3dSR3hD?=
 =?utf-8?B?TmlIVHgwc3lIazFBNnNGcmp3cjRoeDROSEo5eHdhVS8vNHB0WXVOaFVyVGRC?=
 =?utf-8?B?VTFPTEQ0WU96NGQrU09FVkQ1UE00eENLb2F1M1JQWXZscGl5dUZvSVhMREtY?=
 =?utf-8?B?YTdnTE5nNmZqczFFRW1VREY5My95aGlLb1gyUXEvZ1NFREQvN205RGNyMEtt?=
 =?utf-8?B?ZDE4N2JDc0VJOUozaG9aU09DMTJZR1NrKzBKNTNYT3RUU09SeS82TjRUKzFR?=
 =?utf-8?B?c243ZGd6aFVmUjQwSk92ZnlYZTJuMkFiWUZZQ29qWDBXNGRIVk11Y1RJY3Fp?=
 =?utf-8?B?SHA1YzByZTJ0TU9zaDRDcy9GYTA5MEx3bzdIS1N4RzVQOHdtS3FaUTJLNDBj?=
 =?utf-8?B?blBXaHF5NXBhTU5Xd3hqZkw4NDVNRjNIcEFqRTVPQjMyU2M1TjlRRHhpMHY4?=
 =?utf-8?B?VjJXTEF0VElxOFZIZUFoZUdKdmJ2NWpzdmQvQzAwL0U5d0U1SDJ3cmZPSEdr?=
 =?utf-8?B?S0JmN0I2YW43RjMrUmZEdVhQS3g0NW9lQ3haQVcra2Q2QW8vNVlnNC93RGpj?=
 =?utf-8?B?aHV6U2t5UmhUN3dPYmdJbm1EQWR0U2hFOTFnRkxsdktrTDhCbWQrSFVic1JQ?=
 =?utf-8?B?Syt4ZkMzbDZtL0pHMHZlaHpSL2RZUVdDTTl5WVVtNzhSakRZMlVURnZpNEk3?=
 =?utf-8?B?OHNwQnJUb0VQZ2RuOXpMTy9OZnpEMDNHWU1tYzFBckhoRmtERFB0UkNMMk1T?=
 =?utf-8?B?SDBmcWFxUndyT2NsNHFqTHFBVUczNVJuc2FjQVlTeVMvQ0hMamovcEZDUTBU?=
 =?utf-8?B?RmZUVUVzdTBteThtRmJwcUFEWjBWKzR5WUhHZGRDWm5HclRicVppSTcwRHM2?=
 =?utf-8?Q?Y9mx+8yyDEr1msMmT+iH8kZfpNTcpThjOIrlWifoVygX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66DF0209A073E043B2DF7E672F3874F2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d445d6-2c10-4c0d-586e-08da5e516c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:41:43.1852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9lcxqBUDZC/ObW0W5CHXPhpucN3tzvHSFS3aVPCLPRmXbix4HgaJ1sxffsHlhprblAU3Z96plLeCpK1s1166aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFN3aXRjaCB0
byBhIGdlbmRpc2sgYmFzZWQgQVBJIGluIHByZXBhcmF0aW9uIGZvciBtb3ZpbmcgYWxsIHpvbmUg
cmVsYXRlZA0KPiBmaWVsZHMgZnJvbSB0aGUgcmVxdWVzdF9xdWV1ZSB0byB0aGUgZ2VuZGlzay4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAt
LS0NCg0KUmV2aWV3ZWQtYnkgOiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0K
DQotY2sNCg0KDQo=
