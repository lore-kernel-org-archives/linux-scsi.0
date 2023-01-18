Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9A5C32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 19:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjARTrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 14:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjARTq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 14:46:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA4589B6;
        Wed, 18 Jan 2023 11:46:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYjdkhGPFexS/DSRcd7/bdkRZWKlkNYxZwnwMRUQAS+Benyw18T1Flg95xvWQlCIuMPE9nPEBZNhBWHS3A2qsoDOpjg4OgoWRFTFBNTxtpKQd3CsuSPkgb4WcNsqqBFSCxW7bBSuv/I+pWkZecBnMKp1lN5LJjJTBwDBqERB6nNdThCmcdHrfSFAFxStFcYGi49pQT8vfSwECF6Ma3z/WwlvxD3iFoa4ebB/5wE6Jtdb8uUiNue1ZQyj5tZsJ6NCsJhOOnVeZ5s05a+b9pzJUs2678DRnozKfJAzZK5NdEGoyURZz5KL/XMPPr1U0lxmXo+XXYnLG4Jv+hu11sOCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfMoCaCBiPvmjtODfolUE84n86uSEmfzIziSQ+EvUPw=;
 b=i5rQwUckLcFDuZvZYPfr4v4UT5PB/mLNeij2rMlWQYPo12pkLqNqkyPm+/isRqADlvjhD2V9zcZcelT0rfCS2/gnE4rxUGnCVmZ2YjkDfUeDg/+JmJo7Un+w9+rw/E89PrVh3KRgf/2fuf579luVxFwBdK3qIocNUkbmGsEOVYeDQ8m28LOzGRhkwoc8v5wRUih9MUpJttrvie1QTWulKEYUlEqhC2ILbLR1P0s7e1vLbaiFYtu6G+1j/Ucu6zK0cc6aegI4wDlumRglNZRDFbv3fUO9uEzd03/QLkwfT07EiPHt7zWqeaCt8fZDMpAFChO97ZVYOi3e1wIgnB57mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfMoCaCBiPvmjtODfolUE84n86uSEmfzIziSQ+EvUPw=;
 b=i3malUr1w/VQASNFeHvYxM+nRW10XSKFa1SJJAvd8k7kGqlNU2IwKRER7fbVL0e+OJ3LiC1xb0BhQpXE5Xs283fy75/eLhcGHEcm41BaN39YVsJ1eh8Va0/gcs65aCiIWPBVF92Fb57cH6oo73YMivEbNCFel3CMTJxD+3jX0/2IFllsdo7QRmXROotRbLR+8pAGWexx8f+19tsah14xgibRo1I/4XBFzp4R8fIYME3QVQVR72g9pYYNCVFRcnf2lx2vXD6eT9Ph8RuhMgc/Pm/OdoKv4ObGOqat33u7vVmw58pCiKwBesYm2ZbhyYPCovcJQClwhdbNt66UopCsMA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB7360.namprd12.prod.outlook.com (2603:10b6:303:22b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 19:46:54 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 19:46:54 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Enrico Granata <egranata@google.com>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Jahdiel Alvarez <jahdiel@google.com>
CC:     virtualization <virtualization@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Virtio-blk extended lifetime feature
Thread-Topic: Virtio-blk extended lifetime feature
Thread-Index: AQHZKLbSmDz3opX+ik+cSQeZMItVzq6jNSIAgAFkqoA=
Date:   Wed, 18 Jan 2023 19:46:54 +0000
Message-ID: <a9cbed84-330f-472e-0cd7-90c6623bb5b5@nvidia.com>
References: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
 <CAPR809uYp6vGvCk4ugWOjbmd13WTm8fRg0f2Mdq3pxj6=d1McQ@mail.gmail.com>
In-Reply-To: <CAPR809uYp6vGvCk4ugWOjbmd13WTm8fRg0f2Mdq3pxj6=d1McQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB7360:EE_
x-ms-office365-filtering-correlation-id: 3305904b-f1a8-4ace-c124-08daf98cc049
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4i9bk37wdxmzjPI5eiAzp73CL9QmGI+1XoriFpMxdsBLnfl7xNDCldR1rJZ7RsmEzG0nhXkSE6estmWjww8+qmuH/SjdkMIO6lbPCN4HMydJZYLPMbr0vW829xL2pc5XkHcmDVWASuddF1s7Af7EyU0ddXfdyEdAdBbVYEdcBut13aUf2b4HTGiMT4LT5P5sWYeO09ClfW+mn0zWAz0JlpFQB+gBjrslwknfR7NQ1DHoXCeXToz+Gw96s1NRR+gD06us1RrT8kkQ46LVGaEQ5gkgQoBmaneG0jgkJTat5xEduXrMpZyu6ohnbTwjR2Yqk3D2diXU3TA7V+y4C6qxSHtOWQRSelTh4R6r7tP4m1CDoYrGa+WSLtkqvjmn+JTmRG/KXET6VjmFVNKrmMjrmXkWSjRGbiLQCKIQsVyB1MkIfVSdqskfqMLYE+ifbkO+qtWteiq+GCDO2Oh6iJGYCatGGVT1WAJ0bSRDO3hR1lOzmMyahr/axPKHnu5rGgYct6n0bQJTE0sFRna2qD7wNFli2JoZE+WeASL6caRjYDBvRARkKkBmv4m4vhTOpcYunsrEexh3NMFGXLXylc9fVsVfffdSsa4vXvhyN7SgjW0+rosdm+nJwBvbZ8K350y21y9am7UAD27p69jFn91LDEdTiq+tKjFAa6vbpBevVnWn0sIZkzKDupO6pT+p+lLpvXObnoNz2UlTUPfQkUdgg3BTfjKnAZk49rShFL/LDN04sQGep2EJoeuLIqLouJrO75yYmMFxbqtFqcNgYrRpv9a5LMNMdi7p42L9KsvMPiAalAT6X24AbZPHwdfhiRDzyHK8A1zJ9q6Tvw8VBtlCE8cu2NNgi4xd/X9Bb06Ep1ufYbjJzpEDkIOVyzj0nBxf5kJ9VwIgkovqNE2ceH92+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(31686004)(86362001)(2906002)(7416002)(66946007)(66556008)(76116006)(91956017)(8936002)(5660300002)(3480700007)(31696002)(122000001)(38100700002)(66476007)(316002)(71200400001)(110136005)(54906003)(53546011)(6486002)(6506007)(38070700005)(478600001)(36756003)(8676002)(66446008)(64756008)(4326008)(41300700001)(186003)(83380400001)(6512007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkJvUmk0NWhhVkU4K08wZ2s3TXhQb3pyaTRzKzJEOVBUaHh0QXZyV2RnUjNV?=
 =?utf-8?B?aGxFM3pmWFoydy85Q2VtSHl0OGdiOUFaZVhIQUI2c0RQbGVzWTZ3NUttdmhJ?=
 =?utf-8?B?Z1ltNmJ6NStYQXdKV0FTOFdvNG1xdlB0N0lzUlVOOW5XekM1bGtVM256ajdv?=
 =?utf-8?B?TWVQVko3Vk9QWkVFQmY3Vk82WkpCNzEvcmQyOW5va01xaldkY3R1aXVPd3hK?=
 =?utf-8?B?bUdScFFpMFh3N2RUT25pMlBUcm5LTTdCQU5hczVDOGNsT21IbWdvV3FZeTg0?=
 =?utf-8?B?U1VxcEpjaVJRam1CTFkwL2Jlb0liMW96YUFBazRibVdnTHVxbC9OS0hVc292?=
 =?utf-8?B?YnZaRU9TZEs2bkRZWEd3dHY0QlZBR2poMkhNSVFpR0FDTkJrNy9BM0xXNG95?=
 =?utf-8?B?dGN1cFo5aHhHckl5d21nQmZwL093b09jekJEL3ZUUWZIT1RINHQ0NjlqdFcw?=
 =?utf-8?B?Zy9aOXNWUXVUL3BMeHo5ZlpENklvMDRwSUIvRG43VGJIa2NqVVpPakF3aXV6?=
 =?utf-8?B?b2tmMGpUbTd0VkpPaWV4M01SMS9wTis5WHJUMDZYRWRGK0FQK3hMdzdIaEZU?=
 =?utf-8?B?eE5VangxNE5PUUx1dmwySHhxaTYrNlhPMFd6QXlLc2QyNGpmQ1dQc3FZTG5J?=
 =?utf-8?B?cmxIQWZFZU1LcG42STdxWTBDMStVaE40RVJmbm8xSXlWbHVwQ2pWenlxV2px?=
 =?utf-8?B?VWZBU0FpcHA0alNrbC9JMDJRbFdxY1llcWhtaXQ0Wk40dFd2S2xGNTlSOEtR?=
 =?utf-8?B?QXl5NEJqeEdNUWltb05mV2wyQnVua1F6TzFncUtaY0swU1g1Q3Eva3VadG1I?=
 =?utf-8?B?RVFocEF0SkFxellUY1NwN0dwMHA1ZEhGNzYrcnBMSXdURjFIbU5BOGtUS2dM?=
 =?utf-8?B?RlFaSXJsUTNXcGhoNk9YZWJTVU1Cem1OS20xeTRmM3dxQ1lUbkNYQzZvY0Rh?=
 =?utf-8?B?U0J3NWF3VnNSZ0tZRFlYTGZYM2s2MlovSy9xbSt0aUJKMDdkNnFCdDVkc1BH?=
 =?utf-8?B?cjJKem8wYnU1cDRLYWU5aXVWYi8wVHRlZFJhbmZuU2xab0RrdUFyRjJCODNh?=
 =?utf-8?B?ZkVzdFdZclZlbkRBOWVGTjRjajZFU0ZtNlI5K28yYzh5NUdIWXdPWlhiKzh0?=
 =?utf-8?B?NWVOUWNkMHhUSG02WmxUMzBkbi9CWUZENWR2d2tad1RjRmhpcDZpNDVnSGUr?=
 =?utf-8?B?M2ZINnUwMUJUMjhnY3pqVFRPQi9oZm5pNU0yckRjK2NnUEFzL1BQbndUOEh2?=
 =?utf-8?B?UGNjeUVUcWNDNnNseE1GMWVkNE00WlJ2VDZSK2RPZExkQURlOUpWYVBZSXQx?=
 =?utf-8?B?RmU2cGhlZkVibzMzNVZUTTczUi9DS2lkeDRtS3ltRFhvWCtWUWpRaUxXUksw?=
 =?utf-8?B?VjBlOHBvY01YdEg4c1hIOHo3WjNUbm5UNGhNTXRrUis2amMxQUxPZUFXV0dH?=
 =?utf-8?B?QXFDRjJncVJNTU1pNjZ5bU5yYzlrajFKcTNneXZ3UFdDTHBZMVlPR0NpZVZx?=
 =?utf-8?B?ckx6cUVKODZGV1RIUTMyL09FY1B3UVNvQ2U2Mk80V2Z4WEpURnBCZ3NBRXBB?=
 =?utf-8?B?d2hTYmRsUlcyNVJBMnZVeEFraGxvenMvemp3L3htME5aSk1pY1R3VzNuZmh3?=
 =?utf-8?B?bEFaYVFTQzVDNnZabXV3SWFxd1o4eUM3MUJwTHBKTTJjVkxsOENOY21DSWZR?=
 =?utf-8?B?Vk9JRWVRQzJCSittdmw1SWp6KyszanpnRDVhTDI1MFlDemxzZEh0dS81di9H?=
 =?utf-8?B?V3hGSzlqL0RuUnc1OXNJbWxaTENpUzhjeFJSYXdUT2Z5ZUZVS0phNDZMbFFV?=
 =?utf-8?B?cFNIOGdIdVdDcmNabTljUmtNa0tWY3NuZW9KS0pjOXNyYjYySUltZGxyVEkz?=
 =?utf-8?B?eUVHK1drL1lKWEJkTXRzZnRRQWZTbDc0TkpwR2tlcjRFbEFFWmJaUnEydVhC?=
 =?utf-8?B?RWJUaTBqUFNGYVZuR3pCRHlGWGdVaFhPZC9sY1NSYkRTdHNDR0N5czR1Z3Ro?=
 =?utf-8?B?Zm4xUUhjTFY4emtjYmIzTVY2RzVuZFFwQkNmVjdEK0NlcGgxa1VyVE1jQ216?=
 =?utf-8?B?K1RBS2tIek9ES1FTczJCTFNKcDc0YjZMazhUZFFFd1U5bWxIaFY5MXJpcytG?=
 =?utf-8?B?a1ZNKzVuYjJid0QwL1BTOVFWQVA2dUR4WUN5ZGFtSzN0T0kyZ2hCVld4Q1Jx?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1B0552373D580469EACA45D60F79361@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3305904b-f1a8-4ace-c124-08daf98cc049
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 19:46:54.2518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: apZCG8eAMw4y+5oD1P2lhGeXjufHfn647H2Y1X9Uog58aj9htFoDPYUV5cO4vrHyyWp2fS2y9pRieuD2dnuGiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7360
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMS8xNy8yMyAxNDozMCwgRW5yaWNvIEdyYW5hdGEgd3JvdGU6DQo+IEhpLA0KPiBJIGFtIGdv
aW5nIHRvIGFkZCArSmFoZGllbCBBbHZhcmV6IHdobyBpcyBhbHNvIGxvb2tpbmcgaW50byBhIHNp
bWlsYXINCj4gaXNzdWUsIGFuZCBhbHNvIEkgd291bGQgbGlrZSB0byBoZWFyIHRob3VnaHRzIG9m
IHBlb3BsZSB3aG8gbWF5IGhhdmUNCj4gd29ya2VkIHdpdGggKGVtYmVkZGVkIG9yIG90aGVyd2lz
ZSkgc3RvcmFnZSBtb3JlIHJlY2VudGx5IHRoYW4gSSBoYXZlDQo+IA0KPiBPbmUgdGhvdWdodCB0
aGF0IEphaGRpZWwgYW5kIG15c2VsZiB3ZXJlIHBvbmRlcmluZyBpcyB3aGV0aGVyIHdlIG5lZWQN
Cj4gInR5cGVfYSIgYW5kICJ0eXBlX2IiIGZpZWxkcyBhdCBhbGwsIG9yIGlmIHRoZXJlIHNob3Vs
ZCBzaW1wbHkgYmUgYQ0KPiAid2VhciBlc3RpbWF0ZSIgZmllbGQsIHdoaWNoIGZvciBlTU1DLCBp
dCBjb3VsZCBiZSBtYXgodHlwX2EsIHR5cF9iKQ0KPiBidXQgaXQgY291bGQgZ2VuZXJhbGl6ZSB0
byBhbnkgbnVtYmVyIG9mIGNlbGwgb3Igb3RoZXIgYWxnb3JpdGhtLCBhcw0KPiBsb25nIGFzIGl0
IHByb2R1Y2VzIG9uZSB1bmlxdWUgZXN0aW1hdGUgb2Ygd2Vhcg0KPiANCj4gVGhhbmtzLA0KPiAt
IEVucmljbw0KPiANCj4gVGhhbmtzLA0KPiAtIEVucmljbw0KPiANCj4gDQo+IE9uIFN1biwgSmFu
IDE1LCAyMDIzIGF0IDEyOjU2IEFNIEFsdmFybyBLYXJzeg0KPiA8YWx2YXJvLmthcnN6QHNvbGlk
LXJ1bi5jb20+IHdyb3RlOg0KPj4NCj4+IEhpIGd1eXMsDQo+Pg0KPj4gV2hpbGUgdHJ5aW5nIHRv
IHVwc3RyZWFtIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiBWSVJUSU9fQkxLX0ZfTElGRVRJTUUNCj4+
IGZlYXR1cmUsIG1hbnkgZGV2ZWxvcGVycyBzdWdnZXN0ZWQgdGhhdCB0aGlzIGZlYXR1cmUgc2hv
dWxkIGJlDQo+PiBleHRlbmRlZCB0byBpbmNsdWRlIG1vcmUgY2VsbCB0eXBlcywgc2luY2UgaXRz
IGN1cnJlbnQgaW1wbGVtZW50YXRpb24NCj4+IGluIHZpcnRpbyBzcGVjIGlzIHJlbGV2YW50IGZv
ciBNTUMgYW5kIFVGUyBkZXZpY2VzIG9ubHkuDQo+Pg0KPj4gVGhlIFZJUlRJT19CTEtfRl9MSUZF
VElNRSBkZWZpbmVzIHRoZSBmb2xsb3dpbmcgZmllbGRzOg0KPj4NCj4+IC0gcHJlX2VvbF9pbmZv
OiAgdGhlIHBlcmNlbnRhZ2Ugb2YgcmVzZXJ2ZWQgYmxvY2tzIHRoYXQgYXJlIGNvbnN1bWVkLg0K
Pj4gLSBkZXZpY2VfbGlmZXRpbWVfZXN0X3R5cF9hOiB3ZWFyIG9mIFNMQyBjZWxscy4NCj4+IC0g
ZGV2aWNlX2xpZmV0aW1lX2VzdF90eXBfYjogd2VhciBvZiBNTEMgY2VsbHMuDQoNCkZvciBpbW1l
ZGlhdGUgY29tbWVudHMgOi0NCg0KSXQgbmVlZHMgdG8gY292ZXIgYWxsIHRoZSBmbGFzaCBjZWxs
IHR5cGVzLg0KDQpVc2luZyBuYW1lcyBsaWtlIHR5cGVfYS90eXBlX2IgaW4gdGhlIHNwZWMgYW5k
IGluIHRoZSBpbXBsZW1lbnRhdGlvbg0KYWRkcyB1bm5lY2Vzc2FyeSBjb25mdXNpb24gYW5kIHJl
cXVpcmVzIGV4dHJhIGRvY3VtZW50YXRpb24gaW4gdGhlDQpjb2RlIHRoYXQgbmVlZHMgdG8gYmUg
Y2hhbmdlZC4NCg0KPj4NCj4+IChodHRwczovL2RvY3Mub2FzaXMtb3Blbi5vcmcvdmlydGlvL3Zp
cnRpby92MS4yL3ZpcnRpby12MS4yLmh0bWwpDQo+Pg0KPj4gRm9sbG93aW5nIE1pY2hhZWwncyBz
dWdnZXN0aW9uLCBJJ2QgbGlrZSB0byBhZGQgdG8gdGhlIHZpcnRpbyBzcGVjDQo+PiB3aXRoIGEg
bmV3LCBleHRlbmRlZCBsaWZldGltZSBjb21tYW5kLg0KPj4gU2luY2UgSSdtIG1vcmUgZmFtaWxp
YXIgd2l0aCBlbWJlZGRlZCB0eXBlIHN0b3JhZ2UgZGV2aWNlcywgSSdkIGxpa2UNCj4+IHRvIGFz
ayB5b3UgZ3V5cyB3aGF0IGZpZWxkcyB5b3UgdGhpbmsgc2hvdWxkIGJlIGluY2x1ZGVkIGluIHRo
ZQ0KPj4gZXh0ZW5kZWQgY29tbWFuZC4NCj4+DQo+PiBUaGFua3MsDQo+Pg0KPj4gQWx2YXJvDQoN
Ci1jaw0K
