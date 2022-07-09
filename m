Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52970CCA481
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiGIAMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiGIAMP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:12:15 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37B18723A;
        Fri,  8 Jul 2022 17:12:14 -0700 (PDT)
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5CBBCC0D67;
        Sat,  9 Jul 2022 00:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657325534; bh=We7CWrPnzNdeXNBwAeYARgswwHSsQnAZM9VqIMyRPo4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Ap2dIn159/+AzWej9iRAUMc8SCC8HI3nHrB996WjlSqAnip76UYEkadvoMCsn3CAS
         ME+bw+UaxyJHfIwCLDN4lWMKvbd5xRs3SUKXfKRpZHGmAjQvz+sPJOY+S8XHYhOPvk
         lLf0EAFygQ19+ZLLI0dcSzHA7jfnEMiMa6tGarInk1Usqp8kKIpxw8gnq+sSHmeuDT
         gw4IfQNNlT31NRqRd70AAgkN/6o5TipwJt8dLVGuQ56G7ut3i2CIMOEXIZpxSEcqJ8
         lD7X8/gdkfFoZc+Q5Xnnp/ix5dZIyIekujySoBMectAWMIv8tcSMMV/ulxPlGRBp5W
         yAR4Q3ValuqYw==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id CCA28A0080;
        Sat,  9 Jul 2022 00:12:13 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id C614A80078;
        Sat,  9 Jul 2022 00:12:12 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="s2YNmfFT";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVWOqEWdv3UbIV7Ok+YOeIyVnIirWyioQ7GxBO3dDvtKPKHVuo3Ozx2XesHy9wh2915eXfYSUOLFjLBh3fcnPOZ+yL8FQ24qZ9K2aBwm3bdjMy1BoYQ+byEgnKVYmUxmcKPEUF0t9AiGR6/g5wSMbfJ8mf5bAyfKA4PC1AEYy5aAKhKGKTRB9EEq4J0M9a4E20IOlTMHUA/uy4v5Fo0XSTOQDYn7hmlIhIS6/V482bj2VxOjV2wXEtJZviGYY4vqL5nGi20xVJ4lrAkJMI43AABbXas2h/mnF3kDidfGR5lzFBnzifqOHh4TPPN3Gtya+qcPorFy9TRa5q67N3V/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=We7CWrPnzNdeXNBwAeYARgswwHSsQnAZM9VqIMyRPo4=;
 b=jPSxZJ2EP200+W0yUN3pL0DsW1vSiG8tqj43t+mU3D1alXlTXtJ3fv7h6fZLXkzvjqawaiU9zMUqWxy4ij4ESWyfnSF5S5mrimDTCCFs3pOtJPjJpm/+fgypvve1pht9HgHahI4S5QC9Vvm+eRm4k7jdzxaj4nZ0PKoDOHYA+GrfoM+NZ9lhHkjjLkx0NJhzjBGY2bWi62B9NaILnl3YBKxa4OiRq8uV6Vsk8tBkx+XFbKF4q9OJk1qQkEk1sKEpw4b6wzpCF1oCfSkDqpNn0hd8C4B3ATyS46IVvgZvdWzKIuXYIEO5ln9uwauD/FWzNaBgI0pE24o0fz2k5EgsXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=We7CWrPnzNdeXNBwAeYARgswwHSsQnAZM9VqIMyRPo4=;
 b=s2YNmfFTUu6MZsdPLenXdJuvqc6AqaDSox8u6x0EVhhW3kIV3zi3DaNTitMxH7bZH18I9GcW3c3ka65TUoehUMLrxUPgbE/E33NVzoiUPMyshFPFclYY0n04SFj7wgq30elR4rP2s/nAVGWoM3ePtIWg/MZWb9HHgtu24mpRYEw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BN9PR12MB5194.namprd12.prod.outlook.com (2603:10b6:408:11b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Sat, 9 Jul
 2022 00:12:07 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:12:07 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 18/36] usb: gadget: f_tcm: Don't set static stream_id
Thread-Topic: [PATCH 18/36] usb: gadget: f_tcm: Don't set static stream_id
Thread-Index: AQHYkZEy6rUR6FXMvkiQ+E8aepbOSK10DaoAgAEgQIA=
Date:   Sat, 9 Jul 2022 00:12:07 +0000
Message-ID: <14f1eebc-4424-7d56-eef7-b9ee676b9f19@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d9863f8d7065cd9d5f6923ce002a86f6ee6509a9.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220708070026.GK23838@yadro.com>
In-Reply-To: <20220708070026.GK23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a158e4e-866e-4ece-475a-08da613fa942
x-ms-traffictypediagnostic: BN9PR12MB5194:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8S0e71iJqasjucqzSCucw0YZIVuC9AEXP8DX0RbJLLQWhRxcQGuQcNMhNNEHLIQZ9MItl+54dsdXGLcIM8p3UPzOkB9PKrDYIVAIOIk6hyx7MeBNcpu86QRf/B+RK7vyMHJMiWPZs/AGneH9oURZzHsFXz+bSJmE8cRU2CYu32eatTPU84qw7wvRbp/hq7BEI3YSgKrgUvq+OyVXiFDT9q0+VPDJ/1mBVFu66BPlEyVod+Pz5C+iy1kfqLzPNK2YlwR+QL4RXXOkmoYnNonx7u7aDjDEaKVo1tHQxH2VmCYrcA60SHdZk0ZKEjOxt+OiBHem9S1oaaqW94VJ2XWH//rjH4VhqIAto2NBuE+05UnYjcBcPYkDVwIROwniWZVcYo6PQzIN/kjJD9GwNC8JgzVG+GaPCS3jkLTtn/bJf/gHsfF9MtgxPhDuW2P8z2F3oB3AwVDeQQdWRZUk8a3jZ0FflADB8X2EFlV1AKmjmygRpleLbaSoqPCZbDJ4dZVX/EDTKytAbmGcQiOqsQcAj07/OSmma27b/OaV9AsKJvrZFxPhy2RpDpJuRu+WcBdW7K+tFTsm35zdvnERO3Ay8PgP95fIU8fFQO/F7gFTLYo+mnRvBqxG3+i72oj2wZSEK5b9G9tr4XxqluUB4HBpwwlQ5D5xUwolWmNT0iPEelekeIaIqImUkcH/unOLTSK5qhqQHnqsuDANBA4YMmn2uEoYfqvN300sBHWjYwy743Cgzp38Q1dUhcjjICSRZlae/R27/G275IVVwXWJZL5PzFL1WQPA0sZ2Zmk0XcRz0yetXSB7Zb8zGjKAlpGotvRhwJCBoc3t58NkQeaKuN7HA1O8FnmC2Ld+IBOkU71dxkLsUb7KWMs9CqkHko3/yq+l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(396003)(136003)(2906002)(36756003)(31686004)(38100700002)(186003)(8936002)(5660300002)(122000001)(66476007)(38070700005)(6486002)(2616005)(64756008)(8676002)(66946007)(66446008)(66556008)(83380400001)(4326008)(76116006)(86362001)(110136005)(31696002)(71200400001)(54906003)(26005)(478600001)(6512007)(316002)(41300700001)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzVvSThtbGZMSmxjTnhZOGZFdlNOTExoU2RoemQ4M0tpWFRpOERyRGFweEph?=
 =?utf-8?B?YmxTamZGbXphVFNsOEFXNHdScjg4b1dnMXNYK1M3WU91T3Fpc0pHZmFwbFU3?=
 =?utf-8?B?b2JTZDVMOGdMWHdwZDFSaDUrOHdza2dxeUUvVzlQdVhaUFNaTUV6aHZDYjNK?=
 =?utf-8?B?NS83RXVDemZlMU40S0ZhNTkrR2g4Yit5eDBsbnVSYWxSWERVeVBQK2krNXNx?=
 =?utf-8?B?Z0x1bTVLQjdxVXk0ZmhJek9JQlRPV2hBWkJuUE9sQ25BT2FoTUYxT2kvWkpT?=
 =?utf-8?B?U0NNWUVPQVRYNmRIWVVBUXNSdVVrUHd1UGNBUDFKOFpDdDlaejhCVUNNZlFy?=
 =?utf-8?B?aDB3dWZISU5Idi9uWWUrOXY3SHNZM1hvbithUGplVnRueXRFWk4xZklZcll3?=
 =?utf-8?B?enFqWTRvMCtML05scDR1Qko5MWkxcy8rR0xMUzhjYWJYcmt2TW9IQThDUHNW?=
 =?utf-8?B?L2hnSC9MbVovU29IdVVsVjQ4UWkzaFlDR3ZKb3FlTHhjd2NwQUpBYlU1RWFx?=
 =?utf-8?B?OG5abE43Q3VDZGExek5JTXVocmF0Q003aXV0aFZMYjIydnNRM0hjNDl5NTdr?=
 =?utf-8?B?bG1pZWhPNmdWVmpzVFVoOHNheFUwR2xleElLMGhlczJjK29uZTJDQUlNU2Y5?=
 =?utf-8?B?b3h6NXcvQ2gxZFp3MGcvR21oSERoRWtWQ25iNHZ6OWRDOUprWm1EWTA1Vllh?=
 =?utf-8?B?QW5WUUc4a3dkc2tQNWRKWjlaeER5aFN1QW05Yy9pTnUrbWNoWjF0R0prdWtW?=
 =?utf-8?B?c1ZZZHlVUWRuK1JwRytBWmFKbzA4K3NuTzBQZVhSWUx0a3lLanI1NjcvSE1r?=
 =?utf-8?B?Vi9XbEM2ODZVZVJvT0xHVGUvNHVoS3JtN1BPeGlkT2FyZjFMV0JGaDVCQ2h4?=
 =?utf-8?B?Zk93WGRKQ0NjS2xBUldvQm8yREl6MytFZk5teTB0dlNYWlRsL2lhcDcvUHVT?=
 =?utf-8?B?aitwZVpOSnJMRFgwL2xpNkprWkFieVRwMlZZWU0xYjZkclpFVXloWVNpVjQ3?=
 =?utf-8?B?TzJQb2hVZ0ZjMGVrNVV5OTJwVlppV1FSUVZIdk9idjBoNG16enhLbGU0OWpU?=
 =?utf-8?B?WUhWNHN5eTFsMXZlaW1TY1lrbUJidGg5Uzhhek52cjZKM2g0WWdFTjVVNWNH?=
 =?utf-8?B?YUg1MWkyclY2ckd5TDNCRWhaaUZ2UnllZjVSYVc0aG1FUGhFUnlBSklkQUJH?=
 =?utf-8?B?WTlpTjBOdFBRMmExRnlZSEZiSUdXYlloeGpwaEVpa1BZZkoyNDdjUDFscE9Q?=
 =?utf-8?B?dHUwaFJVNkVSOGxsR2FJTzZ0eHY5UHRLbGRkMG52MFhxWUhtZ0ExaTN0Rzdk?=
 =?utf-8?B?MDNTTWE2TGw3dFVDVVpFZlNuTkcvLzZkaU1jc0NtdkRveWttTXJWZWlFZWh3?=
 =?utf-8?B?elJxbFR5MzZpNVJ0VkdpN3RCV1h6a0daNHRXRDBNZXBjcUJ5Q01zd1IyL0la?=
 =?utf-8?B?TXRYeDlubDhMdTRVcGowRTZRQXBQb09iLzlCc1R5QUkrbUxHMWJieHB2MFZQ?=
 =?utf-8?B?akhwZnZkM1BCYXM3L0E1eE83YnBsV2F4c0pMMTg4RDRyUzV4Q2FTbTNNOEEx?=
 =?utf-8?B?YXNkNXJVZkxNMTBsMUVTeVZ5bE9VS2JaN1cyUmM4MEVIVUNtaG54cUc1eEdl?=
 =?utf-8?B?d0tBcU42dTlMS1MvV1VncG1ERkVYRDVrTDNIMlhNazZza0ZSRkpGZmloeEJp?=
 =?utf-8?B?WDU0K0J6SElmVko2RWJwU2grTW9MUlc3Z0FXcDVsTnRtZkRzVE1WRHI3dk4r?=
 =?utf-8?B?T25FYytOaG03TU14YnJYcDBKYnJIVHZDYmF5S0dscmtLY0xuS2JWUWQ5NXNS?=
 =?utf-8?B?VnBEdEJNNHh5NjhiblNUQWFGTTJ6WkF3SllsWXJBQnhaOWpXMXc2OWVZZC9X?=
 =?utf-8?B?eWVXKzRUQVpFczZuS28zMmg4eE05ZHNSankzMGNpSDV2LzJPenBnWXZWalVE?=
 =?utf-8?B?bGFLUGh2bHRESlUrSTk2QVFiUHNmanJUME05dmo2eG9aQ1JsbnRTc2RQUFNq?=
 =?utf-8?B?eUR1d1MwdSt2bitVdW80WlovYTdteDVNdzBINHVtbE5TSDZyRE9la0NnL1dP?=
 =?utf-8?B?akw3RXZsamg1NXBNYW5qdktLMkgyU2FBZEs2RmtFTkJsM0pYSmFQdkpIZXd0?=
 =?utf-8?Q?B3AL+/egrdqc+Ldqr4LrwOCiv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3B94DAF0E99B441B5BFF8876C7A58CD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a158e4e-866e-4ece-475a-08da613fa942
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:12:07.6561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vy+6/Dg3DeztsBJQb1E/T9oEpx0PM1yn3mtvZk4IXLygAPHWBiqO2rdySvb5l2LGizjCAncx4PxjeVi9gYCPeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5194
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy84LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gT24gV2VkLCBKdWwgMDYsIDIw
MjIgYXQgMDQ6MzY6MTVQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gSG9zdCBjYW4g
YXNzaWduIHN0cmVhbSBJRCB2YWx1ZSBncmVhdGVyIHRoYW4gbnVtYmVyIG9mIHN0cmVhbXMNCj4+
IGFsbG9jYXRlZC4gVGhlIHRjbSBmdW5jdGlvbiBuZWVkcyB0byBrZWVwIHRyYWNrIG9mIHdoaWNo
IHN0cmVhbSBpcw0KPj4gYXZhaWxhYmxlIHRvIGFzc2lnbiB0aGUgc3RyZWFtIElELiBUaGlzIHBh
dGNoIGRvZXNuJ3QgdHJhY2sgdGhhdCwgYnV0IGF0DQo+PiBsZWFzdCBpdCBtYWtlcyBzdXJlIHRo
YXQgdGhlcmUncyBubyBPb3BzIGlmIHRoZSBob3N0IHNlbmQgdGFnIHdpdGggYQ0KPj4gdmFsdWUg
Z3JlYXRlciB0aGFuIHRoZSBudW1iZXIgb2Ygc3VwcG9ydGVkIHN0cmVhbXMuDQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPj4g
LS0tDQo+PiAgIGRyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX3RjbS5jIHwgMzIgKysrKyst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMjcgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2dh
ZGdldC9mdW5jdGlvbi9mX3RjbS5jIGIvZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9uL2ZfdGNt
LmMNCj4+IGluZGV4IDI3MGVjNjMxNDgxZC4uNzcyMTIxNmRjOWJjIDEwMDY0NA0KPj4gLS0tIGEv
ZHJpdmVycy91c2IvZ2FkZ2V0L2Z1bmN0aW9uL2ZfdGNtLmMNCj4+ICsrKyBiL2RyaXZlcnMvdXNi
L2dhZGdldC9mdW5jdGlvbi9mX3RjbS5jDQo+PiBAQCAtNTMyLDYgKzUzMiw3IEBAIHN0YXRpYyBp
bnQgdWFzcF9wcmVwYXJlX3JfcmVxdWVzdChzdHJ1Y3QgdXNiZ19jbWQgKmNtZCkNCj4+ICAgCX0N
Cj4+ICAgDQo+PiAgIAlzdHJlYW0tPnJlcV9pbi0+aXNfbGFzdCA9IDE7DQo+PiArCXN0cmVhbS0+
cmVxX2luLT5zdHJlYW1faWQgPSBjbWQtPnRhZzsNCj4+ICAgCXN0cmVhbS0+cmVxX2luLT5jb21w
bGV0ZSA9IHVhc3Bfc3RhdHVzX2RhdGFfY21wbDsNCj4+ICAgCXN0cmVhbS0+cmVxX2luLT5sZW5n
dGggPSBzZV9jbWQtPmRhdGFfbGVuZ3RoOw0KPj4gICAJc3RyZWFtLT5yZXFfaW4tPmNvbnRleHQg
PSBjbWQ7DQo+PiBAQCAtNTU2LDYgKzU1Nyw3IEBAIHN0YXRpYyB2b2lkIHVhc3BfcHJlcGFyZV9z
dGF0dXMoc3RydWN0IHVzYmdfY21kICpjbWQpDQo+PiAgIAlpdS0+bGVuID0gY3B1X3RvX2JlMTYo
c2VfY21kLT5zY3NpX3NlbnNlX2xlbmd0aCk7DQo+PiAgIAlpdS0+c3RhdHVzID0gc2VfY21kLT5z
Y3NpX3N0YXR1czsNCj4+ICAgCXN0cmVhbS0+cmVxX3N0YXR1cy0+aXNfbGFzdCA9IDE7DQo+PiAr
CXN0cmVhbS0+cmVxX3N0YXR1cy0+c3RyZWFtX2lkID0gY21kLT50YWc7DQo+PiAgIAlzdHJlYW0t
PnJlcV9zdGF0dXMtPmNvbnRleHQgPSBjbWQ7DQo+PiAgIAlzdHJlYW0tPnJlcV9zdGF0dXMtPmxl
bmd0aCA9IHNlX2NtZC0+c2NzaV9zZW5zZV9sZW5ndGggKyAxNjsNCj4+ICAgCXN0cmVhbS0+cmVx
X3N0YXR1cy0+YnVmID0gaXU7DQo+PiBAQCAtNzg2LDE5ICs3ODgsNiBAQCBzdGF0aWMgaW50IHVh
c3BfYWxsb2NfY21kKHN0cnVjdCBmX3VhcyAqZnUpDQo+PiAgIAlyZXR1cm4gLUVOT01FTTsNCj4+
ICAgfQ0KPj4gICANCj4+IC1zdGF0aWMgdm9pZCB1YXNwX3NldHVwX3N0cmVhbV9yZXMoc3RydWN0
IGZfdWFzICpmdSwgaW50IG1heF9zdHJlYW1zKQ0KPj4gLXsNCj4+IC0JaW50IGk7DQo+PiAtDQo+
PiAtCWZvciAoaSA9IDA7IGkgPCBtYXhfc3RyZWFtczsgaSsrKSB7DQo+PiAtCQlzdHJ1Y3QgdWFz
X3N0cmVhbSAqcyA9ICZmdS0+c3RyZWFtW2ldOw0KPj4gLQ0KPj4gLQkJcy0+cmVxX2luLT5zdHJl
YW1faWQgPSBpICsgMTsNCj4+IC0JCXMtPnJlcV9vdXQtPnN0cmVhbV9pZCA9IGkgKyAxOw0KPj4g
LQkJcy0+cmVxX3N0YXR1cy0+c3RyZWFtX2lkID0gaSArIDE7DQo+PiAtCX0NCj4+IC19DQo+PiAt
DQo+PiAgIHN0YXRpYyBpbnQgdWFzcF9wcmVwYXJlX3JlcXMoc3RydWN0IGZfdWFzICpmdSkNCj4+
ICAgew0KPj4gICAJaW50IHJldDsNCj4+IEBAIC04MTksNyArODA4LDYgQEAgc3RhdGljIGludCB1
YXNwX3ByZXBhcmVfcmVxcyhzdHJ1Y3QgZl91YXMgKmZ1KQ0KPj4gICAJcmV0ID0gdWFzcF9hbGxv
Y19jbWQoZnUpOw0KPj4gICAJaWYgKHJldCkNCj4+ICAgCQlnb3RvIGVycl9mcmVlX3N0cmVhbTsN
Cj4+IC0JdWFzcF9zZXR1cF9zdHJlYW1fcmVzKGZ1LCBtYXhfc3RyZWFtcyk7DQo+PiAgIA0KPj4g
ICAJcmV0ID0gdXNiX2VwX3F1ZXVlKGZ1LT5lcF9jbWQsIGZ1LT5jbWQucmVxLCBHRlBfQVRPTUlD
KTsNCj4+ICAgCWlmIChyZXQpDQo+PiBAQCAtOTk1LDYgKzk4Myw3IEBAIHN0YXRpYyBpbnQgdXNi
Z19wcmVwYXJlX3dfcmVxdWVzdChzdHJ1Y3QgdXNiZ19jbWQgKmNtZCwgc3RydWN0IHVzYl9yZXF1
ZXN0ICpyZXEpDQo+PiAgIAl9DQo+PiAgIA0KPj4gICAJcmVxLT5pc19sYXN0ID0gMTsNCj4+ICsJ
cmVxLT5zdHJlYW1faWQgPSBjbWQtPnRhZzsNCj4+ICAgCXJlcS0+Y29tcGxldGUgPSB1c2JnX2Rh
dGFfd3JpdGVfY21wbDsNCj4+ICAgCXJlcS0+bGVuZ3RoID0gc2VfY21kLT5kYXRhX2xlbmd0aDsN
Cj4+ICAgCXJlcS0+Y29udGV4dCA9IGNtZDsNCj4+IEBAIC0xMTI1LDE2ICsxMTE0LDggQEAgc3Rh
dGljIGludCB1c2JnX3N1Ym1pdF9jb21tYW5kKHN0cnVjdCBmX3VhcyAqZnUsDQo+PiAgIAl9DQo+
PiAgIAltZW1jcHkoY21kLT5jbWRfYnVmLCBjbWRfaXUtPmNkYiwgY21kX2xlbik7DQo+PiAgIA0K
Pj4gLQlpZiAoZnUtPmZsYWdzICYgVVNCR19VU0VfU1RSRUFNUykgew0KPj4gLQkJaWYgKGNtZC0+
dGFnID4gVUFTUF9TU19FUF9DT01QX05VTV9TVFJFQU1TKQ0KPj4gLQkJCWdvdG8gZXJyOw0KPj4g
LQkJaWYgKCFjbWQtPnRhZykNCj4+IC0JCQljbWQtPnN0cmVhbSA9ICZmdS0+c3RyZWFtWzBdOw0K
Pj4gLQkJZWxzZQ0KPj4gLQkJCWNtZC0+c3RyZWFtID0gJmZ1LT5zdHJlYW1bY21kLT50YWcgLSAx
XTsNCj4+IC0JfSBlbHNlIHsNCj4+IC0JCWNtZC0+c3RyZWFtID0gJmZ1LT5zdHJlYW1bMF07DQo+
PiAtCX0NCj4+ICsJY21kLT5zdHJlYW0gPSAmZnUtPnN0cmVhbVtjbWQtPnRhZyAlDQo+PiArCQlV
QVNQX1NTX0VQX0NPTVBfTlVNX1NUUkVBTVNdOw0KPiBVc2UgVVNCR19OVU1fQ01EUyBpbnN0ZWFk
IG9mIFVBU1BfU1NfRVBfQ09NUF9OVU1fU1RSRUFNUyBsaWtlIGluIG90aGVyDQo+IHBsYWNlcy4N
Cg0KU3VyZSwgSSdsbCBkbyB0aGF0Lg0KDQpUaGFua3MsDQpUaGluaA0KDQo+PiAgIA0KPj4gICAJ
c3dpdGNoIChjbWRfaXUtPnByaW9fYXR0ciAmIDB4Nykgew0KPj4gICAJY2FzZSBVQVNfSEVBRF9U
QUc6DQo+PiBAQCAtMTE2MSw5ICsxMTQyLDYgQEAgc3RhdGljIGludCB1c2JnX3N1Ym1pdF9jb21t
YW5kKHN0cnVjdCBmX3VhcyAqZnUsDQo+PiAgIAlxdWV1ZV93b3JrKHRwZy0+d29ya3F1ZXVlLCAm
Y21kLT53b3JrKTsNCj4+ICAgDQo+PiAgIAlyZXR1cm4gMDsNCj4+IC1lcnI6DQo+PiAtCXVzYmdf
cmVsZWFzZV9jbWQoJmNtZC0+c2VfY21kKTsNCj4+IC0JcmV0dXJuIC1FSU5WQUw7DQo+PiAgIH0N
Cj4+ICAgDQo+PiAgIHN0YXRpYyB2b2lkIGJvdF9jbWRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQoNCg==
