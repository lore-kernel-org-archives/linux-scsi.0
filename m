Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC5EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358282AbiAaKji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:39:38 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:14978 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358280AbiAaKje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:39:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643625573; x=1675161573;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f4ODFbFRhtzzTfDrnsifMuiUenOoT1fhgAm5kM98XWc=;
  b=GvfBJPP/ET6cgY2I1euwbfWFIhrLPQog6P+WXGwrMdtP2CGqhFidcLcQ
   pRtCpbmYGrILtc1C5wVQ/FSuvvUSbQM79Tml1ru2F2rtdakSYXi9gIZDO
   +UgPaIA/S1dVdIReTaH7ql/sH6IskMPwjPWrqwh1wkyyl347Fyh35dnvL
   TUx/uxPOt2PKFothzjffSdDm6K5cT8bv1vJldlyohot5VCb42lwlaoJ05
   5QUef8pGUu1AeKIFznJuvyukztwzA9D7DOWdT+SlgqZsVhNruuuRu2uK9
   F9vr0O1uIdWmofbgsBOznGfuaRmY+KF1dTInMD410f/SjIF8mzcdJ2ZFR
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295877227"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:39:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3gXwIPIR6eHmvxsRj7I1QosSCguxVlEUvvyPWmjw+3hEvHJQGIN0dQnG67Y42IWLwaJpQvpy4eEd5ajDAc+a1ZkhojGTnJ28X7C/PCSZwKtm77C7jt/Qsn/qbATd9+PZ5n+sQB6h2ZC/KWFPuN+p6SKGUE3puTUpfBRNFqxmYEElRbTvHi0fuMfBRVaG2F18DSP5zAmpZrUpVCzuoZ+9m4wTQk41qhBFrZl+OZupOxI+DvFNCi+EVkPIS+TmfTJZTnBIoD5uuOJMcZGN0S5mcbKSKXkL27Do5fX6rL0AVkNb1sQIkocpzCxSmglPR/QMZ7qsgA2ZOXYqnWKITyuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4ODFbFRhtzzTfDrnsifMuiUenOoT1fhgAm5kM98XWc=;
 b=X1SiwBx+NZjci6UydqkT55EjWsrUeiwtqXp/uvgCgJQy0xYvdjHswOpkhXuQkv6jarYe4mJ3eBeYLcsX3fpC3DT4vsFkG5TZj1hZJXrSPz2e/JmL+AMoKhs3RQYrEGWMMke+W2YtyzoQ62LUh2yCT2omG0u5vcHoEIDncM+SRC1vejJtwgpeJ60ocazoPKxTeea8f4jx2OhfhL5dXTrzTi23h+zJIe/48eyl89hh7dP9UVl3SklR1pxoKO7lAhsEJHgBFWZ11yoj3mXO/yFS5pun2tPW6gPZXNO8u7+aXT2xqfTSBK8C2WS96IY1QtLqy2rJfhN/Q1L1j1mTwG6qHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4ODFbFRhtzzTfDrnsifMuiUenOoT1fhgAm5kM98XWc=;
 b=UvpY9bqwbVvbRO07weZjOi+ipQwMAD7m55vTHqAS8XnSK/XkkFwcj169Entl4/bdhQ6wEh7zWH0Q6zEA+f+6XWenebvz+ZeRdIqp86pE9Jxuy0WnkTBF4IG4LysqbooDreIrNW4e/vrMbU67/kg9z35uhaufMrCclOZelqG33Ow=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY4PR04MB0454.namprd04.prod.outlook.com (2603:10b6:903:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 10:39:31 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:39:30 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "sudarsana.kalluru@qlogic.com" <sudarsana.kalluru@qlogic.com>,
        "anil.gurumurthy@qlogic.com" <anil.gurumurthy@qlogic.com>
Subject: Re: [PATCH 13/44] bfa: Stop using the SCSI pointer
Thread-Topic: [PATCH 13/44] bfa: Stop using the SCSI pointer
Thread-Index: AQHYFJVacFuVKvVTbEiG11DkkDBn0Kx89HwA
Date:   Mon, 31 Jan 2022 10:39:30 +0000
Message-ID: <737e4d80bd7843284825e4e7664f17fed8f488a0.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-14-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-14-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a261467-225e-4e11-5215-08d9e4a5f6ba
x-ms-traffictypediagnostic: CY4PR04MB0454:EE_
x-microsoft-antispam-prvs: <CY4PR04MB0454D364D12276417AFB4E979B259@CY4PR04MB0454.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r0+yY27StuEav17ZbadpBRo8ecM1tWx9ZQ2VenPOJAZDlQYGw+s2zQYm//FEABXNjQi/g3DF6yeDkhRWb00aF1+klj8BfRCiwAa1S/zTqfXXePCd/d5xnWjQJK8jp88rWQ727XhB1TirjF+NdX3ouKuu1JhkIRfW+IF5UwbShHBaxxyZ7GVJSJ6Ooy3kfM5FZulCd9COxE6gcxGZtOKvDXPqcz4D+7hGh6kUGf++JE+YEuaWQJoncRWMeDyc//3JtdMRSnWYpOizYsDo+YYXAIR9HFe4BkdpQXqJohMF2Ep7r++A5t+So0JbLjV1sfHX2bkfSOtsZoAm0OsNsuuFHSEmmCwf50i7Fdvmj+RzrnRD6vXFx1YoP5rAoCpp6MNxuAjBinA2YZZcIZD3WospWxJF5yvqolL5U2XZRfNRKiD5qKw1DuKWsjbfWJHEFdXXpD3UQQo+6FAxzW9sLI5fuMBg4byUKMd8uRFd5SKpjxsOgaBHbdCpDdsWy9lASrHhxs970K2fS6z6C9cojrXSgm5yBdETbGQJxiKzeV+hATjcPwQIlFYSDUo1KUrpWVpF8u77VBNHNKOZ19nig2onIkoe8XPotKTSptA2yrkxjp4QTl2Mhc62of9Agw96TTTHuFiaitrS9qOOaMj1fVg7eOw6PwSVuAqdOFb8dBssqbB320PB5K4+N+rdbJGM8eUWWiptZheF1qBP8wGkrYViyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(76116006)(91956017)(316002)(54906003)(110136005)(122000001)(38100700002)(558084003)(82960400001)(8936002)(26005)(71200400001)(2906002)(6512007)(186003)(8676002)(5660300002)(86362001)(36756003)(6486002)(508600001)(66946007)(4326008)(66446008)(66476007)(66556008)(64756008)(2616005)(6506007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1BvRk42RmtUbmhRN0oyeXlRL1ljSHREZU5Kd01rZmtHWHhaSVY5Qk9TanFx?=
 =?utf-8?B?M1gyKzVvZmo5LzFxRVlXK282UUZjcVBrTjNHdFUyRzNvK1lIQ2tUZXgvZHdT?=
 =?utf-8?B?a3dtR2R3b0FZV0RmdTdseGU3YVgzYVFBR2hKMkJEeldaS1lnU2tlODFNQ01Z?=
 =?utf-8?B?bUVlZ1hwMVk0YXVxdDhDTjBJZFlXZ3ZiRFU2bDV4NjZUQnd3MVFaa2RNU3I5?=
 =?utf-8?B?L2laQndwQ3JidnVpZGVRUTZscDZ2VVozTnI5OFR1bjBJeXFBNmxDMlA4bmFC?=
 =?utf-8?B?bHVoYytwYWt3ams4eWc0VTlxWGFmWHQ4bHZLaS9SZ3p2ZEdzOWthUCtaS0tD?=
 =?utf-8?B?b2xzZnkwU3kwaGQvSC92cDA1eWdmWTVsV09NU0h5TzdSNllOdWFKdStoQlZF?=
 =?utf-8?B?SVMrNENFRk55SUZwOTVPSkpzRjFQaXpvNU5OY1NtYmp5RFprSG1ueVdzdjcz?=
 =?utf-8?B?eUhZL055VEpZL1pOeHhtVWtzQU54N21sZ2lhdkpuT2o4cVcxWkxFZUN2TWNX?=
 =?utf-8?B?ME9USFdXNFluck1TVG9lQ3dSZVJsa2w4RjBkd1F6U0VFTGVBTmMxTGFadFFr?=
 =?utf-8?B?dnBlc1F4WGljTiszZVNZd0trT0FpeHdwb01VNFRpaTZhcnRVbXlKaWNGUlJM?=
 =?utf-8?B?bTl3OUZlRUJzQnZSRGxVaGlGazZQbmRVd01rekpoUlQ4ckpZMEJ1SGNRcGJw?=
 =?utf-8?B?c1I5Z2g2QVovNDQwS0krM3JJZVZxRjhZNDc3VmNaNnlySFUwdVZleFMvMWxj?=
 =?utf-8?B?SG83bEo3akROelExUjQxdkxTanc4Y0NoSThuNUZ3eUlwUHB2UXViRVdjQVBu?=
 =?utf-8?B?SUhlQVRFd2wxTjg2ZElxS2hNTjloYjZXUE9yOXJUR1dGRzJ5VWpLai9tNHFu?=
 =?utf-8?B?ZytDekZ1clp3cHM3aHJ4WE5VdWVjMFU4YitLajZvRklnTXJnbkt3QTNTak5p?=
 =?utf-8?B?ejYxaHNPa2IxVEVwVWFLNUZPTC9BTzlSMkdTWUFUbEFORGxSYWV6YVV0K2Mw?=
 =?utf-8?B?WFg3RXFkZ01DTUIvZ2ZzUFc5dXRBeWdHZEI1bjJGZ1lXdjdkWG9kU1VWby8w?=
 =?utf-8?B?VXJDUTcrUmdKcWJYNGxCNzhCSGNjTC81dFRYTXB1cms4V0x4Q0EzZ0QxaFYy?=
 =?utf-8?B?L2RsWjQxNzZiWjEzdndFd1NGNkhqK0xMODUrOHozOXVCY1JiWnJsaWNrS05r?=
 =?utf-8?B?eW1Bcno1anUvR3paUnpQU1p3WEhzUG5SZis4V3hZMEN0NVpaSDNFOURlYW93?=
 =?utf-8?B?VUNhL0lROXQ1Ym0zTWpyUVJzeUMrblFaem5WYXUxN2l3dnc2V0lpR1NCRnRV?=
 =?utf-8?B?SUJNMWtCdjVlOGRCcC9XNXgzcmhHalpDU1VESVV3dHIydGdzc0pONXVkdHJi?=
 =?utf-8?B?bmZ0YXozdk1ESTl6eDdNY0ZQbDNUdkhScld3N3JJbk15aWk1Y2RWZytQSGdr?=
 =?utf-8?B?aWdMUXBkTnpKaXBwSm9ZZFJJYkZMVHlkc1EwbG9ncFZDVGV1YmVOa1dyeHlU?=
 =?utf-8?B?L1ByelkzbUhWZE5OUTh6bXBVR0Y5NUsrWGlsR01wQmhaUHkwRFJ6MzBVTERB?=
 =?utf-8?B?WUdIYllzZTI4Wm1iY1BNWjJtSmp0MTBqR3EzelJIU1FKWFdjVGFzK2lydXY4?=
 =?utf-8?B?VEY4NW41V0JCVTJzdmtJRFdGVW1QYVJ4YTdnNHBRRTBwZTNDdi96bHBSOFpy?=
 =?utf-8?B?aFp2ZUNEcTdLcUhoOFZNLytPSHg1dXpFRWhBRjlSeGNtRHhESTAzekh1djd3?=
 =?utf-8?B?eFNVZ0JONzcwSHAxZkUrSEIyb2F0MmNxL2pWR2VNL3NZbGZFZGYxdVFUV2M5?=
 =?utf-8?B?K2VPVXhBeGFQSnVrYTV4eDN3RmRXR25WTUFXdzlNQVpZVnhLRDFaVnBKNHhM?=
 =?utf-8?B?M1psaGVxS2tQdkJOZDd3RENtWVZTZnRxSWNKTGxudDNiUHBnc3NYbnN5UzVn?=
 =?utf-8?B?N0lBR3diYlBQNW1RQkM5MGdKWXFFYlRIc0R0Sm1JNmhMTFVQVzd3VHBCY2Ev?=
 =?utf-8?B?RXlTbGlXcWpKREtTT0hCRG9QK3hYU24ydVEyTitDcmxsWVlNNWJNVldMaFc1?=
 =?utf-8?B?RnNvaktyc3FadjhXcDlRWlJZNTgrRlVvMEdBY05jdFBBOE5ESjZ6by9zMUw4?=
 =?utf-8?B?UERLMWt2MmVtR0czRldhZkpvdkhHUHQ0dHFoWElkMHhMdDZJcXB6aXZOL2Iy?=
 =?utf-8?B?RERvd2pONGV1VEE3cHNsYzc2SWYrSkQ5VjBnUE9kSklpaWFvUmNjazE1K3F6?=
 =?utf-8?Q?iT0dUNy/QREvszYU8yjTJY8jz5eeBkrH6AidWj0Fk4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C605239D13400F468398F63DB59D8043@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a261467-225e-4e11-5215-08d9e4a5f6ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:39:30.8372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ak8wLk++nPj/HlYdqeM5iG05lt88rAIuOQYNIsHnoaJ7aFSA3bPpAPZk5tQlqV282R6up6chDfe3jA9yJiv3aV1uAQ2EbB5nxw3Igrr00hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0454
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTI4IGF0IDE0OjE4IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQoNCj4gK8KgwqDCoMKgwqDCoMKgd3EgPSBiZmFkX3ByaXYoY21uZCktPndxOw0KPiArwqDCoMKg
wqDCoMKgwqBiZmFkX3ByaXYoY21uZCktPndxID0gTlVMTDsNCg0KQ2FuJ3QgdGhpcyBiZSBzaG9y
dGVuZWQgdG8NCiANCgl3cSA9IHhoY2coYmZhZF9wcml2KGNtbmQpLT53cSwgTlVMTCk7DQoNCk90
aGVyd2lzZSwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1z
aGlybkB3ZGMuY29tPg0K
