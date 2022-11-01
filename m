Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4AFFA3743
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 05:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiKAF3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 01:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiKAF3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 01:29:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2694265E;
        Mon, 31 Oct 2022 22:29:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVdz04RhpGntzspXh6gFkbFxu8anSFE8R6kuiUiVKEDKjPeK9UWhyYPAPShF80w8eX3qMkZualj6xNiaZdBpXzhome2zsBCDUtSOFTvFTtD0zpCC9zNoT8ClYdNVvWhIN9SQM3RbeQv26KLpiSVQJ4zL2DxABUpwYAiPj5nYvQS1XISCVtfzisNlnl+1ygpC62fshbbFErDEMCis5X1j/u8EGNCAFErTo6yaCXVWi1KbN7ttEMQm7JzJUCpHZC0fSVlLxTVf+V2vvwKxxt9Yg7A0T8UBbhH0fPbAhOOYIv8vXBK6HkMIzkmWIiYiSRJph1LaHc9XEljy/qIk70Ugfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRZh30ZsMpGbRRboXIwOfd1O3aX03rG9m4ZXYV063iw=;
 b=l0fwIny6EFncsMe2ZLm3BChB+r8yJIkUvXYwnC0+SU99R8jXXZlUF0qrmyy1igUKKICueIfFyCKScvMMqnnIQwjtE9A53OAeWQOhGoPfWn1pMS+kuPwlnV2ypq6tI7Grq+IiecII4xfgMRA+N2QoqWrCTinIHpn5CKDZGwVpv3RIYV2ACuu0pb/0ESQ/Oet+8qMeKZWpUxsxik1YAY/8D0lmJ2O+OyXTNFrcTIv1Fe/Ej/ynO1wW9ZvRMhnEQ86L1KU9WnuTjOsMpKlbbA7EIzRy75JwfEBEXlEtQCg6Z5n3whmXAMTgBn2O40RuorOLYKiplUIIK5eFxVSEFOOYFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRZh30ZsMpGbRRboXIwOfd1O3aX03rG9m4ZXYV063iw=;
 b=uH3jHDR07PrO0jik4KReZCYStJJgh/SjK921fTJaZvtoMpnKxxsjxmhLWpFpeYDnBF/Z+gIn6RrqwKtoLHzlrncyVOF30bkEqh2SiAK6OlTCZmgDL+iWXobrrodqs4AK1yiNLCzg/42MqwuH8k6p5SUWv6Inpr3cDMcPA2QGUikBuqItPRq+txgp/Y6exezcv6G52X5KNLjtqHUvS/18KiTMnM9O4bevtxRQ9IFLuU+R6JRCHwkU0L10vgTCf+XOnRtEVnzTbTW+ffic9l4lp/wcCXm+7ZuTOH5htt0j3FHIAXzqTx1pZ7vR7gAtsDrWBsox2yEX9xm2m3LJfMe9pg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7019.namprd12.prod.outlook.com (2603:10b6:510:1b9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 05:29:43 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:29:43 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH v3 07/19] nvme: Don't hardcode the data len for pr
 commands
Thread-Topic: [PATCH v3 07/19] nvme: Don't hardcode the data len for pr
 commands
Thread-Index: AQHY6ZHK2YdR6BOC202vDNvo7lAVyq4pkr8A
Date:   Tue, 1 Nov 2022 05:29:42 +0000
Message-ID: <fb73946b-acba-3647-69fd-8ed90892710b@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-8-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-8-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7019:EE_
x-ms-office365-filtering-correlation-id: f4898006-7d6a-4086-19c0-08dabbca149f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NE+jXhEUppWJ0Yw3aKWjjH/vaCedy3vOZ/bu3JakxCPbqyoYfoJ1tx5o+9wmb8GW1LTQlNa0z8WMPe8DDugmK6o6fzDj2E/RNLs3js5WkkAV0eN8GrflwyPo6RpUF7YXm8q1L8LFTSsfH0nJw09Jb5h8LhwNQcJXh2prkygYFzJmkCcLTcPKq4IWTurE0tCX3BeJeBkSnGyYnlmu4UtseqneR0izp4sePuWlOeAXxdztdFYi5pNr64x6LFCBuGLEzgfo4vg0zdf5+11wvvEPD4wKxA4qlMlpqKcCNEhovxZ9PbiUk8jBVRtSfxTH0q8H1gGfaD8haDndlqbCjk/bn3Q+4Cc54zGQk+xV9bNLJWl/AtUYBljiakIL23626O021BuE84dF2wVKnulv3ywSSX6NsyQR8lJeVfUF8EFUHEix2RcQN99Qhf+NM9I7wdp3OWh5LbCZLdXNWt/wEhp/rcq3ybO3F+WcIHgSeUt9TGjYf+KWFK/6yHQMc2uD5BOnZeZyxpzeg9JCURM6EOO8Xq2C5+mWaQXy3sUygvELMuWADRkVTO+D1x/C2pCueseu71v5BrHADY1Qw9mnzwAGDNyg25lf76R8iOqkjPRLnpOaIL4NppmoCHYdgpZbN5s6JotHM9PuKWmnFY6J7rx7IkxS/ivz5iNXDs5A+Uk/frVo+MPF1FuQQfKvfyZUD2c0caXx2lTJz+l5D7lDmn9zxMYXg1wVc7VEfQbOT6PqjcjsAzcFHo88pIAEXHgw9ojaa0TJMyoraFgZKCJHRsHBbySlKrGriZCCK3r5xR9MV9VZFXWbIl1IBkqLp1gK+J0fRVtCVeyEv9tBUSEms4lt+Nc2qdDyLRpf1155w928lo4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199015)(8936002)(31686004)(36756003)(7416002)(122000001)(2906002)(5660300002)(38100700002)(86362001)(31696002)(66946007)(558084003)(921005)(38070700005)(478600001)(186003)(53546011)(71200400001)(6486002)(110136005)(316002)(76116006)(91956017)(66446008)(6512007)(8676002)(2616005)(41300700001)(64756008)(6506007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dG1uYlJCSU13bmkxNDJhUkR5QkMwdmVvSmwzU2p1eGczRlRHTjM0M2J5Y1Ey?=
 =?utf-8?B?YUpMa2tVeVBTbW9PZzNCYjdxQWQ5RVh1NUV3SDBselVBQTBqL0RDaHVTeDhL?=
 =?utf-8?B?dEQxZWdTeDA1bHdqQW5kYUhwanpaMlhkd20wcnRRaCtWQ1hQellZcllYaFo2?=
 =?utf-8?B?Ui96SHc3K2hNanA0eUZvNjRPZDVXSVB4Y1ZhL2grSGhadkJmTDJ3MmFYY0NK?=
 =?utf-8?B?dW1BQXJaSXBUZnVLdGRyMm1Ec0xvZlVhV3Y3elJmNlh4ZFJPU25qS2ZxSUR5?=
 =?utf-8?B?RTgzVjVFSDNyWXcyN25OeUNpcUtKcnVIYmtKOEV0VlBSTWp3elZLdU1BdGtk?=
 =?utf-8?B?eFE5cnNMT29EUkxCUTdKNVE2NkV6OUFVUGU2VXFHUUtxdlN1U1FTalBrM2ts?=
 =?utf-8?B?QWhXR2FpbnBjV2lNdFRpTytTWm1SZ1V2Yk5heUc0b0JuMmNySTdUQmhpK2pT?=
 =?utf-8?B?YVJkUytTSHo3VEx0NUdOOHBBdlRKajBQNkJrOU5wL2kvbW9ZMkJKYkZ6bkNC?=
 =?utf-8?B?NGJwSUxrWnFESmU1MGRTdE9zblN2ZXlMN045OG4zUjBJZjdsM3pIa0ZQdkZ1?=
 =?utf-8?B?OU5SZlJsZjJqTnlFKzAvbkNubzNuNnQ2bkxtazZsNzlLN3M4YWk1Y2k2aXdH?=
 =?utf-8?B?MldUUTBkeTVaRGZ0bk1OVjNTbzBGNWdvNW9xaDh4czdDWkRnWlJmL2NacTZa?=
 =?utf-8?B?TlJranY5bFhQR2hGenRzdGw1ekY5ZG5ha3NhWWVHQmhrZHp0M0JvaEZESDhh?=
 =?utf-8?B?eFpmOElvUkN1clRhbXFSNWw4R0Q3Mitva3pCVzlCdHVlc250SjAvbjA1Zzdy?=
 =?utf-8?B?cXNqY0F1RzdnNDh0OWxWRnh6U2FOOTVGYU90cWF1eGRWTW0wYlpJZGc1MDdw?=
 =?utf-8?B?Z1FoajhGSlEyQXN2S3pqNlN5OXVpdGNSMjZFcUcybytwdHUvWGgrK2w5V2Ri?=
 =?utf-8?B?akhldkhyWUpuR21HSHB2SnFsRExyVE9ROTRxOUR5ODgyWHlkY0R3bUs3WENk?=
 =?utf-8?B?VEp6NHZkbDBpR2dXc3NIb3R4U2hqc1BjdERkVldPR2p1UURZeFdVYTREY1Er?=
 =?utf-8?B?dnNZUHAycytjUE1zNGJXbjViV2xSWkhMOE1BNlZNeGhlT3NJZis0QWxKWHVN?=
 =?utf-8?B?Zko3L25aR3FLT25mOHM0aWNmUFpCYmtic084Q3Bib3dUYnlreVpiRDV5VWx6?=
 =?utf-8?B?MmdBVGs1ZUlqbS80Y3hkNFA4YjNBQ1FFVm5kTDEvU25TS3A4NUdzQ1RiVE9L?=
 =?utf-8?B?ZXQyTlQ0QXNRN3A4QlZCbkJ2bXh4MW05QUNSWUoxVWRVRGJoUjFKYW9ES0x5?=
 =?utf-8?B?SXpMWlNsV1k2dXZTZ3hiZHJHZDFwNUhzeWJFSE1WKzF6N0VZMmFRcmVURE8r?=
 =?utf-8?B?NVd3cnJpMkpaMGdsVEFpTTJsUHZHYks5bjl2a09IeG9VdDRqbmh1U2p0ejBr?=
 =?utf-8?B?N3VlaUFialZuY1dDY2tlN3lKRTVGVDBqUHNXNncveTJWajhQQnAxNWN1S2tk?=
 =?utf-8?B?VjBqeHdKcUovdkpuU0FtaDJZMEp6b29iZmFjV09XNkNFK3V5Sk53MEJQeFQ3?=
 =?utf-8?B?SGFUUnBqQ0ZTSlg4Z1dOZnZYOStiOW9EQ29zQlVmOFFIaGlRNXZtbExaVko1?=
 =?utf-8?B?TFJOM0JYaVZQYm5seXBGQ0ZWUzJReVZuSWRDa2pHN0NMQXN5bTlBMW1wSmhW?=
 =?utf-8?B?REVFNkJ5aXlaNHBZcXNDNWNBRzBwVFE1MVBwbHFlVDhhdzUzdjVBYXpPVStK?=
 =?utf-8?B?Z2ZsdFZyU01Idm1jOGtTc2NRYUx3RzNYZmE5MHNOWnJ6VnltdHltajlYQ2VP?=
 =?utf-8?B?YjFNaDB4MjUrOXpzQjdQTXVZODdWMWZuNVFIQVkyN0h6NGVwZGhFKzJkSWZP?=
 =?utf-8?B?RW54ZWxrVU5JL3JBOENsblRDT3dkdkhKQzBXZys1VnRtcnA2RVU3YlgrV0Qz?=
 =?utf-8?B?Mkt3Um0wNXcvdHJESHJMNGFQN1hLOGc4WnI0YlZwQ1dQNzA3a1laYXp2SXEw?=
 =?utf-8?B?TXlCMms1c09sZzQ4U0FKLzYyOEdCMzMzSjQ4NmFDWmlWYmdCMmUwb09IcUg3?=
 =?utf-8?B?bnRtM0V4dEhVU2l2bXZrdkkydzB6QjlyZlpOTVZ0NFVIa0xOL3F6Qyt6eXdo?=
 =?utf-8?B?b1RNRVZpandOSzNLYTFsRW4wRmgyV29iREhVRU9CemdGN1IxT2JSd1VaQlhz?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCA781A508452740847D057B54921DFB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4898006-7d6a-4086-19c0-08dabbca149f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:29:42.9636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevQOWen2cZgYHkmLaUungchRXbTfUgfv4DdiBYhHtAFvPQGjcnR1N4/NYt4ly+6d3X5zX60W9xAzJ9zYScr1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjYvMjIgMTY6MTksIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFJlc2VydmF0aW9uIFJl
cG9ydCBzdXBwb3J0IG5lZWRzIHRvIHBhc3MgaW4gYSB2YXJpYWJsZSBzaXplZCBidWZmZXIsIHNv
DQo+IHRoaXMgcGF0Y2ggaGFzIHRoZSBwciBjb21tYW5kIGhlbHBlcnMgdGFrZSBhIGRhdGEgbGVu
Z3RoIGFyZ3VtZW50Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZSA8bWljaGFl
bC5jaHJpc3RpZUBvcmFjbGUuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fybmkg
PGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
