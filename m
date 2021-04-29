Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54198C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 06:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BFB561446
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 06:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbhD2GqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 02:46:11 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32467 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhD2GqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Apr 2021 02:46:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1619678720; x=1651214720;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=fpjzoL4VFOdYmtfMCnJ2cA76rqMsqck89ri0DmLZtOU=;
  b=mwk6wfi7mueC/3f4cA88jh/Psf0d4oHOWdAjwJdJLBF1hZpkheGpDQwU
   XzBg89hkDyOf01TD3aQEMM7u6TCKbmdcOhwdqlq+fnLF4Y/IMxJ9fJuCD
   e4rQotj5S7aMil+miztWyOk9hnL88TBNfPKHGh1FbeOvS3bWbA37K5yVQ
   jlX+dX1iAjqJgc0b7KvGgTHzXXsQzyG1/z6504ktX0tkTCwgYtnqRWlkw
   hZPIR4Ba8SzPerXEWr3gsKNfhTUoagjaBPpmMMI3TLlcfZW1wByHOw0r5
   +BO5SJ9uPUQfnCqZHo2vL8XQSvmDSfcxAJwpBc0Rr1+wDGiNXMpEIcCjJ
   A==;
IronPort-SDR: 4OdvUGN8sgLZ4TFxbyy3VEEVxg4+pREzvGXKSsDI/qWtKDFLV6NtgliYW5yHJBDojMNMPAPjkR
 FErk2wIE/zCwc+oaxqLIef1NQ1fMFtMwPCpg6NXfAuuQ7Ohmg+4caHW/mQwuG6X4Z1MbwDltPl
 OpwbugiEWfSLdN649nwouVoZmr/rUHz77G5iJSih/UJdgxEHxDWznn2XnwhFTEbCzhFziHxWJJ
 ue+qR1DnPH87EAPbhPVd8pqsac4a9m6/NPMo6EpwYkREHxoe5Ag66ScD+xBMiqHz+MvWOEKoor
 w24=
X-IronPort-AV: E=Sophos;i="5.82,258,1613404800"; 
   d="scan'208";a="277663283"
Received: from mail-mw2nam08lp2172.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.172])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2021 14:44:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=en+lCGn4C9lgLM3TcQWbbAfFI7TISorqb+AmjfZ20FEk7wRmoAxru7sDYhzB+Cdd3xFXdx8MIykzNZGKhW6mg/tauACdjzm8/bCblnB6FVszOLqpxuCj8qcHm8mqmUdTjSFlqb0cBTr096z8E+AieZw7k89eAWPIwc1+Fd613X8a7Rr/yojKFue6CFBcATYVuGNQt6Tqayg9eYoCy3gchOsU5Abu3xlxxg9SsrsHo9W6SC6h2B7zciWxvgn426+KgZ/m7MK7ev/OVMbJSpcbsV4Io58DevOnmUl+fDSHLLawXOuYIbHsWARl5zwTHmIwNRmbfOJsgmMYT8G6hB2UGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpjzoL4VFOdYmtfMCnJ2cA76rqMsqck89ri0DmLZtOU=;
 b=dwBhwZTi1MaV1Vorw1VJkBCWvENfpdQ14M3J1XW0YOS6YR26XwFCOycmr9BflOa/t1trwvmk1xDyUq2KTlb+yhaQRkkYTGyG8/m/kGwCtPz0rkKiFK2PZEhqnSfhP0B/ETeNo7PQaEwc/V7qSdzUTfLpPBd2BuIji0f1pdy4uES5t/3FBZDjKbDeAXVhdojpC0eCsP6CVGeVyZEk9MmrpyMKsZyEvhjyGCrysIiVgq16vvosWwleTWUgaRgKbmOcM1yVxCxekAfz7KRc1fxiJFH/9MJFPq+h96kVmLIhzARLPrmCo0SgafH8sOEaJb+VNsu4oMH8h2dV2UBcN3LJJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpjzoL4VFOdYmtfMCnJ2cA76rqMsqck89ri0DmLZtOU=;
 b=deq9rmJv+JjPASVBbzX7bW+kkm8EcJP0jmZZVtJIKvLrIqRKBpbZDPToal8QfS6vbl8cAAbknS75iY/C/97lNZVWOPCZ0xOSVBPE3DjcTliQ6inCeuFgVZxljYWqzO6N/l6emIC++N9pFrfgjkBff5K0IsuAcI2zz3dUSUEYxes=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5628.namprd04.prod.outlook.com (2603:10b6:5:163::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.26; Thu, 29 Apr 2021 06:44:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%6]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 06:44:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: RE: [PATCH v34 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v34 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHXPIV1EQrhDmFc4UuXv5b7bi3TqarLDQKA
Date:   Thu, 29 Apr 2021 06:44:51 +0000
Message-ID: <DM6PR04MB6575E1F6149F099382CAD388FC5F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
 <20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
In-Reply-To: <20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1cd7fc5-6d7d-4065-48c6-08d90ada4a20
x-ms-traffictypediagnostic: DM6PR04MB5628:
x-microsoft-antispam-prvs: <DM6PR04MB5628F02C97DEC07986E38E23FC5F9@DM6PR04MB5628.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LYASdMAPX8ItDxcIJxqiMsn6AqJQ5mhCzZDUTQm2AVSajsEGo39EmFMFjaqmfxjerJal2pdZQLcFU3TXMgt8ieTcfg8hyASEeG61rSWQCa01pilCX58QrciOMY6LLryyKADEjYUlFx3MamWL5lIje/PLSoFvBcWkJikPSlj+1iJt7HjET1WeKDXU5S4YBgLJ13krRVZ4aF931fHG7WjWPP84mkr/j+dun8s6cno/5a/NqPuzEh+f9deuTXpMabalxyV3AEn89710JQXh54/UgaAdtpnPVg+69sRJ/ECbsxAAfPILiL2dPL4hSK95NKocLDbL+Mgcomu/y6b1EgLg0hB7o0weNr2V0jSPu6q5tzNXX5qkGc8dms2LIstMhtE72bqV9ZzZ7+nFuoV9sMPDihL31NbKGkt9xbZYeoD3wSnnAcW0ZtsIhMu4WRLZS89v2jCi9sxcN52+JKLupa/lZIPMi6Vg+IMRxyEJaLBES7S0Gctdz7K8BMXZZ3pBw2rgvqM5z9yjyvmWPbCBfpv1zmb2+tiPDD9CiCUofJ3Eic81i208iYxAEODBlBzaIqNc9anCY2GTdadN8wUbo8VTQ0LnrlrhEhF1yiPvl0rpl5cM0aNLlr2uH+Td8zRs+2Kr0SU1n8UeHoBZo27dcPxWRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(66946007)(558084003)(186003)(316002)(7696005)(26005)(66446008)(66556008)(33656002)(64756008)(6506007)(76116006)(9686003)(8936002)(71200400001)(55016002)(66476007)(8676002)(921005)(478600001)(2906002)(86362001)(110136005)(7416002)(52536014)(122000001)(5660300002)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a3JXazE3MkVldVdlWVNXZjNtK1M3M3dad2tSekFPMmhyRWZqWXV6QTJrVG9K?=
 =?utf-8?B?d05FaXcwK096TlFaSnpuVUdYSzc3Ulo3NXBYb0FwMEpHd3pZMk9mSjFpNkFw?=
 =?utf-8?B?UlVMU0NSOWFwMmFGRlEyQ2o0WExkNXZxaEtoUzJiRlVaTkZabURXbTliQVRS?=
 =?utf-8?B?RmJtTlBjb3NDeEtlME0vbElsd25uME83MllJQXBwTFE5bkRQVlpMVnJaR3Z4?=
 =?utf-8?B?Nkc5SHc5QWp0bXFtMDNJM2JNZ0UvUjhsNkNKRnlTL3kzSm5QUTBHWEFxVVht?=
 =?utf-8?B?UG5lRzVRcG51N2h2MTNKRVdkdUc4Z0tTSzQ2S1hnL2lNK3ZCMGlwRDdBUEMw?=
 =?utf-8?B?ank3aG9saGNkV003VUUwd0kwLyt6aFoxQ0xmalpnV1AwZE5pbWcyY0VzZ0pS?=
 =?utf-8?B?cHBuQjExbjNWRjNvRExXWTB6T0JqOEkzcWJnZTZUUzZZcDZpRTZXVjdaclZk?=
 =?utf-8?B?cExQbVlMcHU5Y20ycGE0TVBpS0Q0NmtybDJ4bWluajE4WFVXaWtnUS9kcWpX?=
 =?utf-8?B?WGtIOXFROTFhT2g5dUJELzdkOGFERjZPZ25iY1BpQUg4aTRPZmlldEFpSXVt?=
 =?utf-8?B?Z054ajcxVnpjU2FIbE9GYlNuNjQ1VjVKZE5RZkUwc3pOMFIwVG1mdXJZZkc1?=
 =?utf-8?B?RTJmNG9QMXo0eEpvMktpd2gwUDVSaHM3ZnRVUjZ0aTZ0dENkVktPNk1sSGV1?=
 =?utf-8?B?dFQ4dTV0bS94MmptZ0d2R1B6ZGNVejBFcE9KWlBRTkRORnVQTFhFbTNkdWsx?=
 =?utf-8?B?d0JDanBhSXBucTVZQkF1UHB4QnZ2Wnpoa3hqUFNnSEpEVGVpWGJsZUZVM0I3?=
 =?utf-8?B?RUJXREttSzB0L2tlRGNCRFZJTUVuajdqd2daci8wamZrTTdwczRzU2NTZklm?=
 =?utf-8?B?ZjI0TFdVbzAzVTBqTUY4OHo2aFB2djFva3VMdUYrSmpPT1RYbmxST08xVFNL?=
 =?utf-8?B?RUU5eXJYSkVDMnNNQktDQ2c3Qk8zUjk2UEVMU0dvT084Ti84L3k0TXVCUjFD?=
 =?utf-8?B?bkJmd2wwUlNTWkJ6NHFoclE2UE9GekpnTXNBVXVncWd6SStqQXh2OTZBQW8x?=
 =?utf-8?B?UEtQMDMzWFM4OW9MSmk2RlNqVE5DMkJvVm5jaEszZmRDa09hV0NKRjc3d2xG?=
 =?utf-8?B?cC9QOHhNSzltOFU5NEdJMVovZ0NUMXRCVlVuMkgyT01IK2x4ZXUwSWhuK3Bk?=
 =?utf-8?B?b0FRanpuYXBkN0paQmJ2NnMwelI1TlA2aWEvSkFDTWNaUTljZXZaY0N0NDVO?=
 =?utf-8?B?Y1Bad2xYTHpQb0NEbnNCY1lGYWhyaURydEUrU3dEcjR4MWlJUkRoS0IzRStw?=
 =?utf-8?B?YkwrTU1qVmV0VGk2M1lmU2xCVkZiS1VKTmJsMUFzbWs0UThUSzhFN2JmVlpB?=
 =?utf-8?B?SlRyck15V1BseU15d3preFNLVk1HSVZKZWhyZ0EwR3dqVlJQM3paekJOaW5T?=
 =?utf-8?B?Vk9QMlV3amtNc0JIbVZVVTVkRVNlQkV2UlViWUpCVDc1L0JVbmR1Z3BtVGU2?=
 =?utf-8?B?VFBqNW1ORTcvMTdkREpkeDB0WDZVRVlGUkRneThlWFFpcFpCQWVRdDVSQ1U3?=
 =?utf-8?B?TyszdTg3YmxkbXlDZjFnZXk2V2szaFU1MDlkY0xWajZWclI4My94VmZYUTV0?=
 =?utf-8?B?ZkdWdC85c1luZkR4dzRSaGZlZlJ6N0E5S2RUUnJYcXNkMVBNaGZMVmhnRW1x?=
 =?utf-8?B?bDZwWFlqRlQrSEU0TUVmcEFnbjV6SnBWVVo0cCtITlR2cHpYaUlRTXpDdzFG?=
 =?utf-8?Q?b+6T9WackQ35zCq+1IufEQ4oWdN7eUEgVe4Zp9S?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cd7fc5-6d7d-4065-48c6-08d90ada4a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 06:44:51.1487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nvmy4b6wUnDK2GpyjYsFGv94PLD4m562C3Jr9MI0kaeqoqDe/ZGU3O3QantQQDm8mu6hPdshTgYGmGmxCu1oWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5628
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TmVlZCBvbmUgbW9yZSByZWJhc2Ugbm93Li4uDQoNClRoYW5rcywNCkF2cmkgDQo+IA0KPiBDaGFu
Z2Vsb2c6DQo+IA0KPiB2MzMgLT4gdjM0DQo+IEZpeCB3YXJuaW5nIGFib3V0IE5VTEwgY2hlY2sg
YmVmb3JlIHNvbWUgZnJlZWluZyBmdW5jdGlvbnMgaXMgbm90IG5lZWRlZC4NCg==
