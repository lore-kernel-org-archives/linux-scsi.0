Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3A4FA373D
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 05:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKAFZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 01:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKAFZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 01:25:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA60F0;
        Mon, 31 Oct 2022 22:25:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U85xfyVHyAa3sYNoB9g4ieVsdxvpNJToyz/B8le1Nx9qTXZfB6xgLp89eMSAbDu2eyAQw1uMyc89nNFJh5g8r6JjMwYhPCQ+bcEzejaipev4Aa9osaagu0pky4gP4NR6OTUVzwvtxIWcI1HV6vpiNcDtBsH1ids65B5IhdyqjAmi5fOQD7/oQtzccIoviUwxhB9B3Gf6fgPweG0jqWQDfYG/9V/D60cQ1NfNWVp1x+2hTUrzNy2cL44HlfPhtHifqZY/S7x5Od6laQWC8mfbO0k77STW7e+76MFJY+rJM3XNhF4UzS6yhUs71i9xGBnjPHqBpC25SSbx6/9PLeBKAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSQAcLn8Y18hwfqn2yJgQxt0ULBxPkxGvfBTFzeYb5Y=;
 b=SuuqlZFiU/tiIic3G/Q+1jTzBaWrmO4PpaFW/oNEUTiwQDE5+n+e+4BmJTV3YGjtPyXX9CkPDZaEJ7lPnavokzRu/kQpd4f+8XKGe8geC2LfY6DuRpOLy3lQA6NbBH3Kx698zF0VfUfogDFLhCvFqOspPV3OKoJHyvURH/JVVG2V2kWkPhd9lTmIMm69kSZ5we0j9Fx0xNEdfMWp+4awz+cP/cLbwetLe0Smhr97z21KA8Bfz5XMTuTuoHSx1Z3GkQequkATCllo8XR4kGM0xiK7+M51i3K91Un/Ny5dKyV0xKyQcjtLh6O9iTc0l0v6+7hIBBZyZtxZSuA+s6uTfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSQAcLn8Y18hwfqn2yJgQxt0ULBxPkxGvfBTFzeYb5Y=;
 b=j+YcIT//VKnpIpZpTT3yzttDCHjhlBOniLPT3NPyioYnk/MxDy/2hBD5X9clGUOqzIe/kRu3YipGF6k7y6JyFChJESHUGt7tphTLDGZ7zcdt+frb9B/O6i/jbl88EoDUvyZMC6TZi7QjDiEgudKCxeSxMhoFc/nb+5oO+462Z+I8m/vpX5nhRuUl92motvDylmJp7tOgBa0N7UBZE+c6KYMQmJU/HJOIxXefMuWpc9NYGqmqJ7C8JAEd18bp2TQXOVejlF87g9qrMQgdqqYDC2kJ+37s+44hTb+vJ7Yf93EZ1X3mIKW2S0T7hq2v5cs3l6fS2gyBThlL9po2gnkELA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 05:25:31 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:25:31 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH v3 08/19] nvme: Move pr code to it's own file
Thread-Topic: [PATCH v3 08/19] nvme: Move pr code to it's own file
Thread-Index: AQHY6ZHJfE+OIdc3m0OxwSBGDmQWbK4pkZMA
Date:   Tue, 1 Nov 2022 05:25:31 +0000
Message-ID: <f4b3fae4-d2aa-b017-6157-a14ba170fec0@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-9-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4322:EE_
x-ms-office365-filtering-correlation-id: 96e97965-fb9a-4be3-815c-08dabbc97ea6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5rJ4BjuF4oOMrqc8lqpvhu0kvMqw9x8kKRysGhAWc6So3bFfeoeefJ0/cFXGg8r5DlU4ygG+o597IAFMRUpYKplOUqkxtObYgGhrNBdFGCDNYHzkWXD6BL27ycAxy7t0ZrB2XNYN1LkpKqa/nplZF3so0W0C5IvN1Ix2Tyquo6Wgd2y4bKFD/uDaNLqTPBcIdlL+iik/p9G7/tr07gu7XqR5L4Czb9Vvhr6oiiFXDN2Q8zQpfQDkgOyC6M3DZNp35pKRBgv2c/1AvNhg78JTfrjHgJkQRjsVBDzUz+QEe6ikQnfvTVv1FYxRLbrVwukSconruAUWeBY/e7XK7cHIXTPT5zfcjCx51oYxUGj6Z6tpA1iUhRCpElcK79RY2oB0JFy4Ih1+Tvz/hGfrC9PmpD0QEZ7WF6XA1gE5jPT/GZIgAEDMBLwOZW7Y8iejm0LMAviwzVdB3OwYaBxYRHCJHIh4ALE9sZCp4wNnTZP5rjFvlGG0C7Gl+0NTrV3vj9vl18Ey7io8L66TfGhJxJ1tG6tgFy3f/iOvOB1apQwLGk8q1CdUJ9FHw7DnmE/wpeAV9QCZgBkjLTAa86JAioVnGvw9j8GDNPbbut0eY4dn0yU0icit0SsuC61Wwmpyn3P/vCs9A9SXj2pZ18UjjC+I/QQoNjJyOXUhuDy+rshMQ4EJHXv8TYTz5u+fVZE1PYbndcHc9F8YAWVV6DQXchEM3uPXR0D1S5XNLRTReMdLLC/hisOYoHsvod+d2YDbaJ0C3Rqrt3/7NLhhRQYI6IhAZJEFi/fbtaQwEB6vUmJwt6hYl7bQ9QvqgwuZG1IryP2v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199015)(66946007)(8936002)(4326008)(7416002)(5660300002)(36756003)(54906003)(478600001)(316002)(2906002)(91956017)(2616005)(76116006)(558084003)(6916009)(38070700005)(41300700001)(71200400001)(6486002)(186003)(53546011)(6506007)(6512007)(66556008)(31686004)(8676002)(66476007)(64756008)(38100700002)(31696002)(122000001)(66446008)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlBRZ0Vra1dSWFBydi92TjV4QmJad0xvV3pQNEZNM0J6UzNPQVVJOSt5VWxn?=
 =?utf-8?B?TlBKcjNOWWxsKytlNURIa21TVTg4bzgrdzBWNzFuZXJBT0xMYlRtQjM5bERU?=
 =?utf-8?B?Z1gvaE13SCt3ZmRibWdFb20vTnBYbjJwOVBmbGMzMXB6N3A1cFNyNFFMaWo0?=
 =?utf-8?B?MjRTZndoU2xvVDJ4TzB0TStZc3pjd2tJSXl6Vyt2bFBoL0Fhbi9UTDdvbUxx?=
 =?utf-8?B?cDdkcTBiMVVsd3l3Ym45SWRFVGxuOFhyS0wxazMzeUE3a2srN2dSVlQrZ3FR?=
 =?utf-8?B?ckZxNWt2RjFGd3NISVlRbXdTN0pwdFBaQXYrRDJNL3grZEVkUC8wTUlkMGhm?=
 =?utf-8?B?TjlsZ3ppL09FK2wwSnpKRVBMcnRVM0tIcjBHcGhHdzlyRVRnaVlxTUtJdkRp?=
 =?utf-8?B?L2YzdkN3VzF6ZFRzejNoUkpSWTRZVURPVjlNSmx1OXVjQ2ZVQXBqdkN3MzZM?=
 =?utf-8?B?dVNhUHp0TFllMHJXZURLdXpDNVZRK1RZcitOZjFGZlI1L0NQTzVTT3RtbjBE?=
 =?utf-8?B?NkJ6OFZpVTJrdVRDeW1TanRtMngzY2RFUkdpbzVMM1VFRFFOOHc4amZnV2JV?=
 =?utf-8?B?R0I0SmJlaGNWL3Z4WEo4bWliNXJjSm5TR0JCVG9MOGRFbytEOWtyZ3FBWW9M?=
 =?utf-8?B?elRMSExidnVUc09JUGZCellpL1JLdU5LM0RqMnJncXJpN2htOWhDSHA1Q3ov?=
 =?utf-8?B?SnVONWM4bFRwNU9mQWo1U3I2Zmw2SlRCREJGMGFzeDZVVEIyR2t5S1Yxb0F4?=
 =?utf-8?B?UzI4UWpTM2M3UGRmMkZLSW1uR0lCeXk1cjlqSnRXTVF5aHMvOU9ra2IwcFRQ?=
 =?utf-8?B?RTkwUllUbjAzMFNHcWlWdjVXUS9YMm1aaTNndW9BcTlYODBwSUVvcXBqaXZr?=
 =?utf-8?B?TVNzaWJOWSsraitlWmZnS2xEL1lxcGVaRVpqdUQwWCtuNlBrTmF5V2tCMi90?=
 =?utf-8?B?TGxMcmc5R056bUFtUWZnZnZRcHF0MG9zWmMyYnVRd2VIWHVIVFoybzVwdy9a?=
 =?utf-8?B?UHk3YlduVWZtVFY2KzJYL1JoaGNQWVRZT0NSS29SYmlhMjJNKzVEQk5TZ3Az?=
 =?utf-8?B?cWo2MkZBQUhoTkVHTzRxbHNFZ2RENjI4TjBFVVZjZTlhV1JZQ2U1YVRwWkJJ?=
 =?utf-8?B?ckF6dXZSVXhMVGFQRXhxa3Y0dVpNOUJhcldzV0hBNzQ1eUlwNGJzZmFRNDZm?=
 =?utf-8?B?dGhTWCtIMnZuaCsrQkJUcjF6TEU1WmNxVzJFS2hyTnBmWGpoeEpHSGk1Q0E1?=
 =?utf-8?B?WnVSdTgybGIvNVpuUitIc0FwREVxRTgwNGdNZzRBam96cEx5b3A3MEpUYVVG?=
 =?utf-8?B?VEF0cVZReFFUL0h4SmFaUXFMK2JBTVlDK0l5bWRvSWVKQlVyM01DdytmNUkx?=
 =?utf-8?B?c1Y5eFk1ZGRaZEI0L0YzQjFFN2hhME5IUnZQc1RPa09nMTBRRmRlQVBVVXMw?=
 =?utf-8?B?WGFzODQ2c1lvdlhJWlVKUWxLK0xBNmo3em40TUswR0JpcHE0c0VCQWM0Z1lj?=
 =?utf-8?B?Nld3WjlsRW5xQkNvU1locDV2MGNsR0lUbENDd1QyYjA3YS9EY0hxM0tqNVNN?=
 =?utf-8?B?c0lKaXB3Q1VBRDRFTnJVakZiZ3E5VlhLZFBzS0JiNkd2TmlZZFpOSmFTUXRt?=
 =?utf-8?B?OTFwVHl3UVlEUnZReTVFVGRmQXl0Tlk0MVhYQUtxNVRkMEllQU00c0x4QUxX?=
 =?utf-8?B?V0FYMGdKYUpvLzdLK1ZEcW8rdFY3RjJIbU5Wa2tFOTFoMnFkbm8rRjY0OVZ0?=
 =?utf-8?B?TjQ4clZVeDV1dEgrTHM1dHRTeis1QXNvU0liYTFPQU96endFZ0t3NWZGVjlp?=
 =?utf-8?B?SHNicy90Mkp5QUpRMXhYMVVWVGkvSDA1VUdFdlNGWjlHcHhseWZrYnh1Y0gw?=
 =?utf-8?B?WHQvdnF3Q0VlSlp2eFVDOEgrdUJydmw5dGRHakhwd0ZIRVRpM1pSdWsyUzEv?=
 =?utf-8?B?SUsyaCtuVFVMZFJsSXQvNmhuZ0pWSzhickNRa3ZzVGRlQ3gzRFk5SG84bzVp?=
 =?utf-8?B?OWlxd1pabGRuWUlENVFkUVJXdDFsaFVKQ1I3bk11T2lNWG9Ca3dMRWdEOWdC?=
 =?utf-8?B?MzBteHhYbEE0MjZCRlhCQ3MxTTROdUtqKy9MRmpVSDd3UmxLOXFpYXNKU0lw?=
 =?utf-8?B?M0NnZ0NKd21TaEF5VlIyNmdxNW8zamdqT2llUU9xL2wvZUUwUnJBNVJOU2JJ?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1A3810BC69AAC44AABEFB1F6104E4D0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e97965-fb9a-4be3-815c-08dabbc97ea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:25:31.3539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7H32oujuHEwu1QXYys/CAaAeJw/hfrZQxHgAL46bD3wbz7uOXZTNuq+aNtcVFX4qWPuouIqHqeBa/JuTBCdMUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjYvMjIgMTY6MTksIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoaXMgcGF0Y2ggbW92
ZXMgdGhlIHByIGNvZGUgdG8gaXQncyBvd24gZmlsZSBiZWNhdXNlIEknbSBnb2luZyB0byBiZQ0K
PiBhZGRpbmcgbW9yZSBmdW5jdGlvbnMgYW5kIGNvcmUuYyBpcyBnZXR0aW5nIGJpZ2dlci4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xl
LmNvbT4NCj4gLS0tDQo+DQoNClRoYW5rcyBhIGxvdCBmb3IgZG9pbmcgdGhpcyAuLi4NCg0KUmV2
aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQo=
