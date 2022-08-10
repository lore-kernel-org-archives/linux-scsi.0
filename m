Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728E3C19F2D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 01:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiHJBqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 21:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiHJBpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 21:45:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BED71BD3;
        Tue,  9 Aug 2022 18:45:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVgByKdUj8SzR7zSbyfT1t5ZttXTM4zbp/4e8XGKauBH2m5RI2PGsMxEf61RU97TdgVhaL5kDZWllI+x7OrXRWvmGab2bnl4u2V6beixXeHOqpLF3Ju1pQHlxV1ls+0AYbsJKGtTcZaeJceSq72ehu67VvcNVS+45LD5h32twKrbu7hpsh6eMJbKgAPRs05+dqDdugYpeR3Ggh4yUxNkP+NCWMk4TJ4ZVjv7Pu0IcuEwfw7WxXaxPGQ/ZKJyaQlyBZlZMWrc1B1Cns8tM6P1Rm+5W5hoE3vwVxaLMPAOfCP5gq/JzcPEm/eOWVdbpglFu+7ah0YqzSWOWSt+ndNdpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBTkTu7LHOISClDy++C/vM75iI6ErJ2Smkz24Nquyc4=;
 b=ILd8yD0JCSv5FSCzTHC0+ag01WHpamBo8Av0qNsS0B6UhjjhgsKE7Wu+95CKxX82ezjzlNm4Ffs0HRpaXTnjO5DWDlP72x7XKxU2DuzoSTHNJL0Q6his9F3QkBIwznW8gXDcR6dcr3B2F52BbofP/I5NWhRrcuWv/YwhmnY6qk4xj1Uc4Q1bI9eKfb4VGfUOQuLYQquWmS5JUqRS0vDttEvY+3OlyqSwHOODDZ6JfixNJnE4tsAmc12BkcuvHnh7y7I3Pup4hkE++UaO4F1+VMj4hwVuxAJqK+u9qxXlCLyUaZIAynfIqpVYFe37L8NnL7MSqvhcjKry17UJJo1HDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBTkTu7LHOISClDy++C/vM75iI6ErJ2Smkz24Nquyc4=;
 b=KGxQwhSGnv1h6K732hXqI7qNNjzQHAstW1vzynE5Appe9DnfiLadV/8/UH8CTKEfgdXTTB0CEZ9sZFeMHlxZp9JC1N9W02nQqEwK66ahh+qRt8mdFumPfvfXG5ZeqEMK+LtV/pqxNbAl3GIgCEazHS4Ay0MtwAG1uOBi//+94NfX1zL+vJseBqNIMBqY6GUC4PesDP42Wy3XziwXKtYCDkMVpteOOdDwW+cPHq399TN8Qk6+G2WUWuqgVckyIV85AYATWEpDGN3XEnIZdyUltkHuZmikN8Q0Jt1JiBNkcSIuONK336gTx9Xu6WC7j4W8OaamgS97Tc3NVlknPMzF0Q==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by PH7PR12MB6610.namprd12.prod.outlook.com (2603:10b6:510:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Wed, 10 Aug
 2022 01:45:48 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Wed, 10 Aug 2022
 01:45:48 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Keith Busch <kbusch@kernel.org>
CC:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Topic: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZnKAgABBcwCAABkjAIAAncQA
Date:   Wed, 10 Aug 2022 01:45:48 +0000
Message-ID: <a0184a51-ef30-dc80-412e-6f754c4d9476@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
 <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
 <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
In-Reply-To: <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b18d4017-3e25-41b0-cb79-08da7a720cd1
x-ms-traffictypediagnostic: PH7PR12MB6610:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kaBKR5UL8TlRqGEjQTxJH7kekJXssZyxXvI19NpRU8+DCjL6XBHMC/5MBV3uRScy54GWqlNaI7xrM7GVZLXgJ2VwOqe5t1qSLZoDSy0hYoXXFMoY22y+7tWj9q4MwoeeVdfojnf7ILJIr21HcS+iNYDXuSnlyx5xcnVI3iiJPRZhPO/OsnTXWurNgYXYTlQqIWdwSxBCr2A3Bs4CtKZNRNV025pDyQErVPiy/Qe5tsiDK52KtGLQhNe+0uY7VcPDbQI+4fUEDLt6uX8KHQmyL3SDFtRJNyb2n/LEoMAIw/1fdRK3kX9MrJgUcUEHOTs51fxBmm/uzbgGhHgPllf+1T/uYjwv4PtYYYnv4u/oN97A/ipUX7l5NXYDoJbNO8ythx63S1i0yMorgy4QFwH1HvlKyn/teRmsxhGmVqqcmi3lRfSpi5aNzYR4NaGknPrNianov/Y0wenneyAZCuZalbUQkKE2bfasa0Ce92g+UjN/1F+P3B+1hw8dwI0KxCttkA8ea+E0GR8DfZiVtJK50hWi2kqQ5GUPpFBJGjDogwOapuzutpd3B7qTl2ySODrh3wYU8GGCPJ9zAprjf9S9DXxGP2FGzRyTRomgxqs7U7b9gjgauTFFWpMzMMAwqmdMPTkQtjCr5qQwUnrL11kM693/cyDaqshiJbLmcGIsJPPWyPAD0zFdGPuzyO9qhaCUaupJ65m1ITldyK+vMrMWefmfWZyPSC0NG2rqsmAU/soIQNMaAyLrbz5oRQonh7lbTMCsutocsIv2QI9JqFvLfUC9K61RZN5jYkf9nUYfSYW0sZs3+zqcm2nHvptLGbQlnBYhzwNx0gsKLEwlcFo/BP9FdUhyqLuhNeH1ajGpKwo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(71200400001)(6506007)(7416002)(110136005)(8936002)(76116006)(478600001)(86362001)(5660300002)(53546011)(122000001)(38100700002)(6486002)(2906002)(31696002)(2616005)(38070700005)(6512007)(41300700001)(83380400001)(186003)(4326008)(31686004)(66556008)(316002)(91956017)(66476007)(64756008)(66946007)(66446008)(8676002)(36756003)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWE0cTgxc2RiNEM4OUUxekRZMEdQUUtBaXR5ZjRGWWdIMm1vZlNDeUpoKzNw?=
 =?utf-8?B?SlNWSkxLY0JRQkNvVVRUVEF0a0FwMnl1ZnZtUUpGSWwyRGJ2aFNEZTArWUZs?=
 =?utf-8?B?WXNnUy84SThJV2s3STMrQWE0OXVJZTMvdFYwUGtVaG5YZzluMkVJYmNIRDRw?=
 =?utf-8?B?UWhJZENaZzYzT0hIK2RwaXFlL2RlSk1aaXhzVHl6V2pxaVVIRkFVTnAvTjdl?=
 =?utf-8?B?Ykh4NC9pa0Y4N1B4QjdYd0tMN1doQVJuQTlFZmN6UFZPeFZvVmZHVm00WXdS?=
 =?utf-8?B?ZkVIVUFSNVZUTW5zRU1aTllmcEpCcFVFaU5jRm56TXphL0p5bmtUeUNkd0c1?=
 =?utf-8?B?ME5pd0M5S2RYZ05qeHNOeFlmdkhtMjNIOUtEU0ovWlQ1UUVQMUpvaUd4ODJ6?=
 =?utf-8?B?M0pJUWtYYkVhWm9tSFBvUjh4cGcyZnM4alArN0I0bVNNL3M2RHovTGxXSC9D?=
 =?utf-8?B?UG1DVW5URDNBeFJ4c3ljYU01YUNPbnRYM1AxVlZtT3FLbDNzQXZpbFNuelZk?=
 =?utf-8?B?QS9wYjd0bmVxcStYWDFEdlhsREtudndRRGFPTWhRclBqZ0NuOWNhYm9wMWxN?=
 =?utf-8?B?NnpIUTRneVNET3l1S2hoUTZ2Q3phdTQzRkNUMmRtWUpiYXJrRlF2L3czQndm?=
 =?utf-8?B?ZW95T0tqaUFSVmV6c1NzRkM0c3B1dHpXSWRqT0xoMnZMMzJDUjFrU1l5VVNC?=
 =?utf-8?B?MENEdWxrcUlBNmV3L3hYN05iaU1pblA5Z2RUMmQ5dk5GN1lzM1R0U0dkaXkz?=
 =?utf-8?B?MDlFL1ZzbXJZQW94SzY4WDM4R0dFLzBSQnNUbjZsZHlqWWg0a2NuVElaT2pZ?=
 =?utf-8?B?M3EvSThrbkVxSWs2UEUzeDQyRmFmYnBZbWlsVm8zOUpGSlpiVkYxcnNtTVk1?=
 =?utf-8?B?TnZqTVhMMDJJYm54TjZRQlFHWkFLWXBCbzJmNGczZy82K09oVGZSTkw0QUVO?=
 =?utf-8?B?TkNCVEJmbnA3d2pYU3VQVDYrdDdid2t2VVlieE9UWGE0M0lUUTI1U01BNHlU?=
 =?utf-8?B?ajZycnpYYVZ4TlI2MlFhOEFnZUFnNERld0dseEhldkxFWnhZdzloTkpIRlNm?=
 =?utf-8?B?aDk4OE95ZjEwV0FHUHpJUUxqNkh6RkhDL3ZjS3MvUlpOL2NqQVhjOW54TVkw?=
 =?utf-8?B?dmVVQUptdjRMN3lIUjBEb1BzNjhSZUtKOWVjZFM4dVZ5ZnFmYVBJd2lwU0wr?=
 =?utf-8?B?cVJpTEJKY3g2ekNITWlOcmNwK1pESUMyakoyTzhxamUyVUxTOU1rcXFoM0lW?=
 =?utf-8?B?bUtwOXdseisrTDZNSXA4L2V1YWNxZkVJemxENHh1bGZNWGR1K1hZR2NUUWV3?=
 =?utf-8?B?QmsxYkVsYnhUN1JaVjh0SlU3RW9abFltNUhXMzRFTlFSSld2eVFzb0pEUURN?=
 =?utf-8?B?d1lVcEpVekZMcWtDaTRFVHIraVpLZzJsSmF0T1hxbmk2dk5USmZqYkUrUmVq?=
 =?utf-8?B?TDRLREprZ2wyRkZIc0FzeFZqM2Y4MnY0ZlFWUDQ4d3RuV3VOR090UGtvRG80?=
 =?utf-8?B?REg3aEUwbFZDZDNEWTZGNThweXpQZlczMW52bEQwVjNxc0J0c2V6cTdUTWJF?=
 =?utf-8?B?MDhWTjY5aWJqTXdva0FmQzVRMHFHSC9rbEUwYmo5TFBYQm1jY3oxa1ZMbnNK?=
 =?utf-8?B?RktqZGJxazVBUXl6OFFMMEQxQnNzQ1hlWEVYVEl4UmQ5VWRqMllRMmZzZmlM?=
 =?utf-8?B?TzFNTlNueWw3N2cvQ3ZTYWhWTmkrcG9mN1JJK2h0NDh3dXcxRkJYUzQrYXhT?=
 =?utf-8?B?L3I0WHcrZVFEcUo4TmxUSUZkRjdtbFlyNi80aDBXY1RpaTBrWlpjcUQ0Sk1Z?=
 =?utf-8?B?cHQ3MjVCVGVoZjdEWUd1blBKSG00QnpIMUZpNHoybXRpSjFJYU1SeWFqdllq?=
 =?utf-8?B?RXhXQUs0Vlp2Y3pjYkQ5a29pMVIxVTN1NEcva0dMaEtmemx3K1BsRzh6NXY1?=
 =?utf-8?B?WXU4dnJhOFJrTGZlS2tJaTJpZE9zdnQxdHZTbk1NNzFzaEV0YlNFWEtsamMv?=
 =?utf-8?B?WElGTlVuZmIxcXMxU3YwYXBPemJOcmtzLzlmSE5XelZkb1I0MzFqczE0ajRY?=
 =?utf-8?B?T3FNd0VvMG4vem9kem1PZ1BTdXVQV29QVjZSQjZ0TUMxak90VWsxRHI2Yyts?=
 =?utf-8?B?OFhIZ3V3UHZSRTRzeGk1a3d5OFJ4bjdkSzZIRmRWMmNJL202K0JEWmE4OUc5?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46C78720EA490943A6AF2FC6B0A2BC79@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18d4017-3e25-41b0-cb79-08da7a720cd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 01:45:48.5813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F3L6yz60+JB4g+zWOs/kIlCrBHcIB9YLI4fWPxfkmGzDTKUDTIIyrdkLG56hylVnf6jLP88zYU1Z15pe23Bi/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6610
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC85LzIyIDA5OjIxLCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBPbiA4LzkvMjIgOTo1MSBB
TSwgS2VpdGggQnVzY2ggd3JvdGU6DQo+PiBPbiBUdWUsIEF1ZyAwOSwgMjAyMiBhdCAxMDo1Njo1
NUFNICswMDAwLCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6DQo+Pj4gT24gOC84LzIyIDE3OjA0
LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPj4+PiArDQo+Pj4+ICsJYy5jb21tb24ub3Bjb2RlID0g
bnZtZV9jbWRfcmVzdl9yZXBvcnQ7DQo+Pj4+ICsJYy5jb21tb24uY2R3MTAgPSBjcHVfdG9fbGUz
Mihudm1lX2J5dGVzX3RvX251bWQoZGF0YV9sZW4pKTsNCj4+Pj4gKwljLmNvbW1vbi5jZHcxMSA9
IDE7DQo+Pj4+ICsJKmVkcyA9IHRydWU7DQo+Pj4+ICsNCj4+Pj4gK3JldHJ5Og0KPj4+PiArCWlm
IChJU19FTkFCTEVEKENPTkZJR19OVk1FX01VTFRJUEFUSCkgJiYNCj4+Pj4gKwkgICAgYmRldi0+
YmRfZGlzay0+Zm9wcyA9PSAmbnZtZV9uc19oZWFkX29wcykNCj4+Pj4gKwkJcmV0ID0gbnZtZV9z
ZW5kX25zX2hlYWRfcHJfY29tbWFuZChiZGV2LCAmYywgZGF0YSwgZGF0YV9sZW4pOw0KPj4+PiAr
CWVsc2UNCj4+Pj4gKwkJcmV0ID0gbnZtZV9zZW5kX25zX3ByX2NvbW1hbmQoYmRldi0+YmRfZGlz
ay0+cHJpdmF0ZV9kYXRhLCAmYywNCj4+Pj4gKwkJCQkJICAgICAgZGF0YSwgZGF0YV9sZW4pOw0K
Pj4+PiArCWlmIChyZXQgPT0gTlZNRV9TQ19IT1NUX0lEX0lOQ09OU0lTVCAmJiBjLmNvbW1vbi5j
ZHcxMSkgew0KPj4+PiArCQljLmNvbW1vbi5jZHcxMSA9IDA7DQo+Pj4+ICsJCSplZHMgPSBmYWxz
ZTsNCj4+Pj4gKwkJZ290byByZXRyeTsNCj4+Pg0KPj4+IFVuY29uZGl0aW9uYWwgcmV0cmllcyB3
aXRob3V0IGFueSBsaW1pdCBjYW4gY3JlYXRlIHByb2JsZW1zLA0KPj4+IHBlcmhhcHMgY29uc2lk
ZXIgYWRkaW5nIHNvbWUgc29mdCBsaW1pdHMuDQo+Pg0KPj4gSXQncyBhbHJlYWR5IGNvbmRpdGlv
bmVkIG9uIGNkdzExLCB3aGljaCBpcyBjbGVhcmVkIHRvIDAgb24gdGhlIDJuZCB0cnkuIE5vdA0K
Pj4gdGhhdCB0aGF0J3MgcGFydGljdWxhcmx5IGNsZWFyLiBJJ2Qgc3VnZ2VzdCBuYW1pbmcgYW4g
ZW51bSB2YWx1ZSBmb3IgaXQgc28gdGhlDQo+PiBjb2RlIHRlbGxzIHVzIHdoYXQgdGhlIHNpZ25m
aWNhbmNlIG9mIGNkdzExIGlzIGluIHRoaXMgY29udGV4dCAoaXQncyB0aGUNCj4+IEV4dGVuZGVk
IERhdGEgU3RydWN0dXJlIGNvbnRyb2wgZmxhZykuDQo+IA0KDQp0cnVlLCBteSBjb25jZXJuIGlz
IGlmIGNvbnRyb2xsZXIgd2VudCBiYWQgKG5vdCBhIGNvbW1vbiBjYXNlIGJ1dCBpdCBpcw0KSC9X
IGFmdGVyYWxsKSB0aGVuIHdlIHNob3VsZCBoYXZlIHNvbWUgc29mdCBsaW1pdCB0byBhdm9pZCBp
bmZpbml0ZQ0KcmV0cmllcy4NCg0KPiBXaWxsIGRvIHRoYXQuDQo+IA0KPiBDaGFpdGFueWEgZm9y
IHlvdXIgY29tbWVudCwgd2l0aCBhIGJhZCBkZXZpY2Ugd2UgY291bGQgaGl0IGFuIGlzc3VlIHdo
ZXJlIHdlDQo+IHdlIGNsZWFyZWQgdGhlIEV4dGVuZGVkIERhdGEgU3RydWN0dXJlIGNvbnRyb2wg
ZmxhZyBhbmQgaXQgYWxzbyByZXR1cm5lZA0KPiBOVk1FX1NDX0hPU1RfSURfSU5DT05TSVNUIGFu
ZCB3ZSdkIGJlIGluIGFuIGluZmluaXRlIGxvb3AsIHNvIEknbGwgaGFuZGxlIHRoYXQuDQo+IA0K
DQp0aGF0IHdpbGwgYmUgZ3JlYXQuDQoNCi1jaw0KDQoNCg==
