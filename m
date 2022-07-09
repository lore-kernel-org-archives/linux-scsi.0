Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C077FC43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiGIAEP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGIAEO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:04:14 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B3E6B746;
        Fri,  8 Jul 2022 17:04:13 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 87002C0D67;
        Sat,  9 Jul 2022 00:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657325053; bh=prPZlKYYhA/q9YjjDIBvF8AVzE0xwmXypQAHDY2qAGc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=BMYUK4pk/1y3quc0tTQDk6QJxlJgs31kanierpWdcMvIWApxMSmypRpwzn/3eWYN4
         4Xj3lIa88PrxUND1/uf2BsOgeYxknhjVcMvYedN/bizL86vQJRbrw4weYUuzMxQLd5
         RNAurjyOfHrMrPPMyR4wbCkJVzopWExJQu5P4aqcj47nvH+k+C1xMyb/2yztq/lRbR
         U4z2YkI3lL0ERvdvs5M3huiMLstu4gqycjhRcKl/mgstfryuLOaqv00LKXPyUZj7Az
         qaiZaq3W0emxJ3CP3YMl3x48VRfM3JZcCCNLyEPdldYON5qK1YtAiiFU06mfSnr7vy
         ZELhU6xG+e2dg==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id DF899A0065;
        Sat,  9 Jul 2022 00:04:12 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 49C2B40053;
        Sat,  9 Jul 2022 00:04:12 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="cJl8hFmc";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGM5rw8Spw/Q4u9OvTc1R0KkORGxNU963KY3QkdzYEU7SBOrW/J1eh0Rl1bxJrD3f4tI3XLliSgeMYenwsrGSA7+WrHcaEwdqmLyfUcsMtIrCCgGq+EuonbxVOcYIbUw0c+gr52dDlJCHS+DX0rT16ctIXoxqt9DYDBj5aa4mY5pUOu8ZO4g13QocaxMcDlj1PcSdV1HRZNY3kY19I7HH3V17oP25raMQEMja0JufHHjvKcOf0csGRbvXTvLce9wZQJLhO86vPf+KxT4F2ugzCj8wSqPxywJZ8D7D0pBsaiJxeI5zed4Ene/7FjiB2V8qsioFxP/Tq3k6EC3nPCXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prPZlKYYhA/q9YjjDIBvF8AVzE0xwmXypQAHDY2qAGc=;
 b=RkR8DG5n+1J9wAQpJU/1P/fjOHz0PQF8sCHKS3RD+GQGpY8cy1O4+VioGerruh+TuhY103l1i6R1kl3X4e5M+GDsrJRBD3uYoDy6KE6xjLLULWii+qXDHm5t7KCbx1dNaEdu2ZTr9hPQZU93eLj51/1XsFhOpxiMsMF5fHmfxTzi67K38hyikKtHMWrB8oVxYvgGjK9ZZuwSxOGhgS+gtivukAoPhO2g1WAUFyCwFIjzWIV6fNWf4UBMvjHLZD365hdED2ppU7U0SjRTIgH1NmAiI6uUY4q0Rw6/VHs5umF9rE0B/zek49E6i3r62t3v5BDOp+ScDIR4BZ+doIV/tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prPZlKYYhA/q9YjjDIBvF8AVzE0xwmXypQAHDY2qAGc=;
 b=cJl8hFmcJi3OCdhC/k3BHdgWfYLVjieu7tUh1d2TQQVKcDhgI7EVObyT4XSUiwNcOEFOMvK7/Lg5IbgL5XG95QJ4aK8KMSFEbZNrLG66amLq4y9+dlA+HxMLgmBwJpCnvaT7gjlpgfIArRi6ev73roANPlbSTVmTnirpsqTfwig=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BL1PR12MB5301.namprd12.prod.outlook.com (2603:10b6:208:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 00:04:09 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:04:09 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 09/36] target: Add common Task Management values
Thread-Topic: [PATCH 09/36] target: Add common Task Management values
Thread-Index: AQHYkZEQht7W4WWuTkCXZvpsbEOD1K1zTn4AgAHdMoA=
Date:   Sat, 9 Jul 2022 00:04:09 +0000
Message-ID: <5f14641f-c4f7-f77e-fea3-ed5c80a725d0@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d89b41eb3be83be3ef532209245caca356a8db49.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707193612.GG23838@yadro.com>
In-Reply-To: <20220707193612.GG23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5801e5a2-9649-4f90-cff5-08da613e8c43
x-ms-traffictypediagnostic: BL1PR12MB5301:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PpLU7PCNv7DvaRvqqaIOJrVfAqa6cs80QFbnz6l/KXponS7mRZEOo+vi7L/SJmCor3DkRnp23kvQ3g0ZyWVvL7YjH305Bgj9l53jUmwEE91EiLfDrr74SYIsUuNORthEh7yb0fwML4FmOG71ROixUXkPVj/diENDEoWvbuFRjDkyAFTQujOboxDTK/+MVRmI9aJPthfKi42mz7+SZ1JlReuhoeLXhseIlaQig7wrX3g8jTZZBL6BWQftpP3RAN+0UlzzZQX4KP2ZetkG5JS1ycLR3EoNG/nEXqHP6IfMDQmDmZL3GDavAU2eaY5bG/Gz9qDWvISYKStgDd4gEpMkahjAUMB4c+KaLTp5wiC4KwxWP7Bku+tpTZiLJFPEmwsoVkiPG16/iP+WAj1TkOPGyy2y/rO9szwzVOzKMVpbNeoiW8nNn1j3Ncm37umXW6K3JV5jmJjLbdnTqc3PA1IT48QscbzEP6hl78frs6mwIdX+UbBNWL49/9Z8/7bClJGHcWU+jEqli18GuoF+Ma1sQ3lWi2ihTZNx7pEP7rHevljPwUH4GJ6n2wOxMu5z9RAhv5gf5XiwAeLbnmz13a6zg3fMb0FftodJVnaDKqrBU0Pi6+hooHu+3OTImV2sEqoNX+X3MgydJmVJNJCjQBj5eDh9kWw+vAaZSqo8J1IlfY9ReGqrN2zOFJJ+wwRVCaPXfuL85lhPkunJQbKohHlLS05IKlNQkIxWjYMWax+yiFR7nMzcuKPkyHg10QMLmxf0hDPRBCXei7+AXkIPBymF9Cp93ZXyapitH7pA4S6cMAlIG6WmZvoQTMMSLrsKJlamudvv7iKYB60UGEPbHYAJpdFqZIV2N8pMrCrBQJNkf1lKAyWaOaefQJ4tNCnDNCoC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(39860400002)(366004)(396003)(26005)(6512007)(6506007)(2616005)(86362001)(5660300002)(83380400001)(8936002)(41300700001)(2906002)(478600001)(38070700005)(6486002)(122000001)(186003)(31696002)(38100700002)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(4326008)(76116006)(36756003)(54906003)(110136005)(31686004)(71200400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmZBaUhGenMwVGpRdXF6TjFqWmdaSDViNTJRV2tkbSs4US8yUUVPTmZ2R01C?=
 =?utf-8?B?RGxnL2FEaXBuQnIyVE4zYThyM0puMU5xQVpMdHlhMUErYktxZ3U0VzVacGg2?=
 =?utf-8?B?d25POUlYam1sM2lxL3BlblpUd2MzcktsNVRDT1F6a2FWd1hmMmhkc0FyVjdy?=
 =?utf-8?B?U3lTVzhiTXRvanVZQ1Bpcnp3dmlhdHVIV244WkRIMzZKQkZ1UWVwVnpqeUxY?=
 =?utf-8?B?c2hHZXdUd3lRS0ltZFoyUjN2M0xyRGoyWUU3eFpkdE1RU2M3eVFJQzJaRDZS?=
 =?utf-8?B?OFRNT2dpam9SQUtIUFM3YnVYbEdjVllHRmRWWXRQbi9UVnlPT0JJQnVZNlVq?=
 =?utf-8?B?T2JlMjZXWENNc3QrTjBEUm9QdStTUG8yU1FPeC9JNkFDMUkxR3UySlhHRHF0?=
 =?utf-8?B?WGdpdXBsaWwvTE43TE1vbnF4NkZsNnBSRHZRdjl2Z1VBaUhLOW4yU2hnVC9z?=
 =?utf-8?B?MXpzMUNMQ3ljM0V0UzM0Qm8vWkZ3L3RST0xiU1BoU1NOc2x3dHVic055a1RC?=
 =?utf-8?B?bE9ZRkVFazhnWitKQ1pRODJXNFJNTVRud3hpUkZmWkpyaGo1SmIzY2ZDdVJ4?=
 =?utf-8?B?WUR3WHZFcGoxcksrenEvTVN5clRHVVBwc2gwNGwyZUhTZ25JZkxLUFVXdXhs?=
 =?utf-8?B?Zlg2UTg5SDJ0YnZOY251bmp3cm5SNFlscnJrUG5kd1ZSbGpVc0phNzgxcTZL?=
 =?utf-8?B?aDJVNTB4eFlLZXppdTlaWFlwNThyUGN4Wlo1Y09mWUc1SG5td3FxeDdsQTlH?=
 =?utf-8?B?eFBGeFZoWVdJMG5uT3M0amdOaFd4ZVM5ZHgrc0V5SXJydWYzWnhqb1N0OWxN?=
 =?utf-8?B?bWZKSC9GWDVJT1pSY0ZsMDFUdFlpTFFSY3J1U3RUMDVIU2NjQ0lCb2t3UkJY?=
 =?utf-8?B?Ti9zWXlYVWw3MXdVSjBIU04xbDNNTkZoS0Fyc1o5eEZKRGpJNGlaM3Z6TitD?=
 =?utf-8?B?QXg5SmNSTSs0Qk96UHp0ZzY4RGswTGNCSzhvenczVXk3RWY4QVEwNnUranRv?=
 =?utf-8?B?aGJybVQwV1k2ZHJvRFJsdlAvRGNvQU1WWXZOOERtQ1dVNUxNZnhUQXlxWGxL?=
 =?utf-8?B?Z0tZU3hxTTB1dmZGaHdHSmRJU08vTi9WekF5Ykk1bzdFZnBiNnh6ZW9Wam43?=
 =?utf-8?B?OFBzMHRjeUhPdE40aEFjU08wa1dKUHVXWEN3dnpVRU13eWFZRHVnWFhkeW9r?=
 =?utf-8?B?ZFk2L3hxamV3aTIzdlhaVVQ5b2g5VUlMWDRQbzFoanpKL2xSOWJDb2MvUEhh?=
 =?utf-8?B?U0VwM2tqTUhFNFYzYjk1dTBHdGtsRnJQT3VCaUVldm5kQ3FEbzE3ZUtaRVcv?=
 =?utf-8?B?SUJ3bkdlUEpDOCtyS3dwTmJDVkppZU9QRTV1bnovM0xCZjRMNVpNWUZIVXEw?=
 =?utf-8?B?dHI5OTN5eStGd2tRWlBiN1NlUVBqczdINEJ1bjU3K21TcUhNUzZhWFV3OG13?=
 =?utf-8?B?a1NEcU9YZTc5NVBTK21vdU9vb2tOZlFJTzQzZllyRlIrdWxLUVpJa2pZQkF2?=
 =?utf-8?B?Q0pJSGROU0lvK1ZoQ0dKSEowQ2dMSFloVlFIMVFPa1RPdS9LdnUxYUh2aW4r?=
 =?utf-8?B?QUVKZ3E0aUNCbWxUSHk5eDJ3UHgzZHF3T0dtTHF6cVRPU3VtaGVXaHo1LzZS?=
 =?utf-8?B?dm1MdVNVM3pSZnpCUlc2bEhtVmpFVDRIQ0dHT0FxUDNLdklHUExTL2hIdG9N?=
 =?utf-8?B?T3pDYitFc2o0SWd0OUVXaXNsNTIzUUl3TVp0Z0VRWSt6blFld0NVS3ZzWEx3?=
 =?utf-8?B?QUZYRnpaUDBxL1BqdmJsWjNvdG1RWEJCUUlZd1Q1dHdGU01Fd1hRMEhUcXRr?=
 =?utf-8?B?c3hwa25jcS9jdmI4TVdCS2Z1UUtvVDd1SHBEdm9xNFFIcTEwSUZ3SlZxZjI1?=
 =?utf-8?B?M25CbTc3SHNtNmhjUzVDanc3dlliZ1FhNkM0RjF5V2ZROGxhYmZERkZHY1J6?=
 =?utf-8?B?bFVabmN5UnduN0Q5eWpvYU94VDIxVjRyWWxhYzVvcEUyQ1NFbU5xNGQ2VTZ4?=
 =?utf-8?B?WERiYUFaUXlkeVpFc24yU2Y4ejJqTVNldmY1ZkZNNythS1dUUUNqWW5vcStk?=
 =?utf-8?B?bVVZdTQ0Z21uQlpHWVJpSnZxWC8rendoYXhDdVRsbGZlamREempFcDIzVDRL?=
 =?utf-8?Q?06Fcz2Hiew7pCMrnOkOgVQ/49?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F56FFD310CE9554F9ECF7F75CD3AE863@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5801e5a2-9649-4f90-cff5-08da613e8c43
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:04:09.4842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkuZM9Uk8taGbEDx9gBjXovTXosVsQdzWXTYbeR3Xf4snv80WDJXg2ypqA8DtZnCU8gkeDjg4t7r8z0UcNJ1oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5301
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IFdlZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM1OjIwUE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90
ZToNCj4+IEFkZCBzb21lIHN0YW5kYXJkIFRNUiBhbmQgbWF0Y2ggdGhlaXIgY29kZSBpZCBiYXNl
ZCBvbiBVQVMtcjA0IGFuZA0KPj4gU1BMNC1yMTMuIE5vdGUgdGhhdCB0aGUgbm9uLXN0YW5kYXJk
IFRNUl9MVU5fUkVTRVRfUFJPIGlzIHVzaW5nIHRoZSBzYW1lDQo+PiBpZCB2YWx1ZSBvZiBRVUVS
WSBUQVNLLiBDaGFuZ2UgaXQgdG8gMHhmMCBpbnN0ZWFkLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4NCj4+IC0tLQ0KPj4gICBk
cml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90cmFuc3BvcnQuYyB8IDEwICsrKysrKysrKysNCj4+
ICAgaW5jbHVkZS90YXJnZXQvdGFyZ2V0X2NvcmVfYmFzZS5oICAgICAgfCAgOCArKysrKystLQ0K
Pj4gICAyIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5j
IGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+IGluZGV4IDEwNWQz
YjBlNDcwZi4uY2JkODc2ZTQ0Y2YwIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy90YXJnZXQvdGFy
Z2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+ICsrKyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3Jl
X3RyYW5zcG9ydC5jDQo+PiBAQCAtMzA5MCw2ICszMDkwLDEwIEBAIHN0YXRpYyBjb25zdCBjaGFy
ICp0YXJnZXRfdG1mX25hbWUoZW51bSB0Y21fdG1yZXFfdGFibGUgdG1mKQ0KPj4gICAJY2FzZSBU
TVJfVEFSR0VUX1dBUk1fUkVTRVQ6CXJldHVybiAiVEFSR0VUX1dBUk1fUkVTRVQiOw0KPj4gICAJ
Y2FzZSBUTVJfVEFSR0VUX0NPTERfUkVTRVQ6CXJldHVybiAiVEFSR0VUX0NPTERfUkVTRVQiOw0K
Pj4gICAJY2FzZSBUTVJfTFVOX1JFU0VUX1BSTzoJCXJldHVybiAiTFVOX1JFU0VUX1BSTyI7DQo+
PiArCWNhc2UgVE1SX0lfVF9ORVhVU19SRVNFVDoJcmV0dXJuICJJX1RfTkVYVVNfUkVTRVQiOw0K
Pj4gKwljYXNlIFRNUl9RVUVSWV9UQVNLOgkJcmV0dXJuICJRVUVSWV9UQVNLIjsNCj4+ICsJY2Fz
ZSBUTVJfUVVFUllfVEFTS19TRVQ6CXJldHVybiAiUVVFUllfVEFTS19TRVQiOw0KPj4gKwljYXNl
IFRNUl9RVUVSWV9BU1lOQ19FVkVOVDoJcmV0dXJuICJRVUVSWV9BU1lOQ19FVkVOVCI7DQo+PiAg
IAljYXNlIFRNUl9VTktOT1dOOgkJYnJlYWs7DQo+PiAgIAl9DQo+PiAgIAlyZXR1cm4gIig/KSI7
DQo+PiBAQCAtMzUzOCw2ICszNTQyLDEyIEBAIHN0YXRpYyB2b2lkIHRhcmdldF90bXJfd29yayhz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+PiAgIAljYXNlIFRNUl9UQVJHRVRfQ09MRF9SRVNF
VDoNCj4+ICAgCQl0bXItPnJlc3BvbnNlID0gVE1SX0ZVTkNUSU9OX1JFSkVDVEVEOw0KPj4gICAJ
CWJyZWFrOw0KPj4gKwljYXNlIFRNUl9JX1RfTkVYVVNfUkVTRVQ6DQo+PiArCWNhc2UgVE1SX1FV
RVJZX1RBU0s6DQo+PiArCWNhc2UgVE1SX1FVRVJZX1RBU0tfU0VUOg0KPj4gKwljYXNlIFRNUl9R
VUVSWV9BU1lOQ19FVkVOVDoNCj4+ICsJCXRtci0+cmVzcG9uc2UgPSBUTVJfRlVOQ1RJT05fUkVK
RUNURUQ7DQo+PiArCQlicmVhazsNCj4+ICAgCWRlZmF1bHQ6DQo+PiAgIAkJcHJfZXJyKCJVbmtu
b3duIFRNUiBmdW5jdGlvbjogMHglMDJ4LlxuIiwNCj4+ICAgCQkJCXRtci0+ZnVuY3Rpb24pOw0K
Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdGFyZ2V0L3RhcmdldF9jb3JlX2Jhc2UuaCBiL2luY2x1
ZGUvdGFyZ2V0L3RhcmdldF9jb3JlX2Jhc2UuaA0KPj4gaW5kZXggOGUzZGExNDNhMWNlLi5jY2Q5
ODYwNGVhZjQgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL3RhcmdldC90YXJnZXRfY29yZV9iYXNl
LmgNCj4+ICsrKyBiL2luY2x1ZGUvdGFyZ2V0L3RhcmdldF9jb3JlX2Jhc2UuaA0KPj4gQEAgLTIw
NiwxMiArMjA2LDE2IEBAIGVudW0gdGFyZ2V0X3NjX2ZsYWdzX3RhYmxlIHsNCj4+ICAgZW51bSB0
Y21fdG1yZXFfdGFibGUgew0KPj4gICAJVE1SX0FCT1JUX1RBU0sJCT0gMSwNCj4+ICAgCVRNUl9B
Qk9SVF9UQVNLX1NFVAk9IDIsDQo+PiAtCVRNUl9DTEVBUl9BQ0EJCT0gMywNCj4+ICsJVE1SX0NM
RUFSX0FDQQkJPSAweDQwLA0KPiBUaGVyZSBpcyBubyBuZWVkIHRvIGFsaWduIHRoYXQgdmFsdWVz
IHRvIHNvbWUgc3RhbmRhcnQuIFRoaXMgZW51bSBpcyBub3QNCj4gc3RhbmRhcmQuIFRoYXQgaXMg
ZXZlbiBzdGF0ZWQgaW4gdGhlIGNvbW1lbnQgZm9yIGl0Og0KPiAgICAgLyogZmFicmljIGluZGVw
ZW5kZW50IHRhc2sgbWFuYWdlbWVudCBmdW5jdGlvbiB2YWx1ZXMgKi8NCj4gU28sIGp1c3QgYWRk
IG5ldyB2YWx1ZXMgY29udGludWluZyBmcm9tIDguDQoNClN1cmUuIEknbGwgZG8gdGhhdC4NCg0K
VGhhbmtzLA0KVGhpbmgNCg0KPj4gICAJVE1SX0NMRUFSX1RBU0tfU0VUCT0gNCwNCj4+ICAgCVRN
Ul9MVU5fUkVTRVQJCT0gNSwNCj4+ICAgCVRNUl9UQVJHRVRfV0FSTV9SRVNFVAk9IDYsDQo+PiAg
IAlUTVJfVEFSR0VUX0NPTERfUkVTRVQJPSA3LA0KPj4gLQlUTVJfTFVOX1JFU0VUX1BSTwk9IDB4
ODAsDQo+PiArCVRNUl9JX1RfTkVYVVNfUkVTRVQJPSAweDEwLA0KPj4gKwlUTVJfUVVFUllfVEFT
SwkJPSAweDgwLA0KPj4gKwlUTVJfUVVFUllfVEFTS19TRVQJPSAweDgxLA0KPj4gKwlUTVJfUVVF
UllfQVNZTkNfRVZFTlQJPSAweDgyLA0KPj4gKwlUTVJfTFVOX1JFU0VUX1BSTwk9IDB4ZjAsDQo+
PiAgIAlUTVJfVU5LTk9XTgkJPSAweGZmLA0KPj4gICB9Ow0KPj4gICANCg0K
