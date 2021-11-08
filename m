Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67D2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A4661074
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhKHR1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:27:17 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50858 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhKHR1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 12:27:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636392273; x=1667928273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UA8wwSITVRStIq5w7Js7c40VkyiC1K3yzybXP8pII28=;
  b=re2iSrYyhWQiUvujAkLKONM6kAC/Yjk3WSqmRTqFOZGcIAnSBTqRtXY0
   Xz/9FHAa6IAdNckz/O/DGMfcXd9iuXgHDSasHyxkLkNA3tuc99yq+dJud
   ByJRg+Qt0ZQysKr1dXSCBqy6NGo4LYapU345q0PuB1dlOaPajuhWmmtES
   qMs6j5uF/jI4bDb76JC8ZpDftNs3WqV3rkPSDyrg4vUwtO0wNoouOoGs6
   mJuLYJ2me1cMUTOventCoAQ/EieyEbwkp7KlDyJbSW+40VfxtoSgR3D5d
   kaUnX2niXJBEdjoVcHThA3ce6vf9+QQXyaIASyeSFN4Ds5LA8SGzBH3jU
   A==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="186028056"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 01:24:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/iY/3VJ6F0JgTgg1NaoktdhEe6Pn6mIFk5QqgUFIrJjNdaJs8xkoiGJiBs8LAQmUSv0wRK+UHFgii40RHfMSvLn8RsMArZR1lJolNxNFrYuNxDUUtyM+EVYHvnSahqtXueSypDpw7/bET4Uq3L53S4lP38KDD0l6d3ZykKeesoqLBKmImdA6v64n8BJbDZBja6Y3zn7pE/JiKd0QZCCo7STfS4ENil3TPmE/QEgBdW8E7Oe3yBTgRNqiWVdmk18yovzkVCT95yjbx7xO/YUyD9UDV2noHkEeCReOEF01X2MlEyfG6tq2jRR8c3wTclnA1lLsqlOrcCHpXIqRuYFBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UA8wwSITVRStIq5w7Js7c40VkyiC1K3yzybXP8pII28=;
 b=cYXaf+klbGnm2PQt+bAWRnoJp2r8MDUDDNCLuRkqjfHqHIyRmxMQ3uM1lSMLpyAU/Itf/fG9kiaImMg0C8RoOBLrmdyZtP+h60z3G6GRncuXbpBWfBu8e4lJE/MF5D7mWQpmqg1llj+6M2mvK/R9ycj2MfkZajdmCDgYFQTGZ+uc0Bjb1gN9vrNNXcMo1UTkfdKy2LTaUqL4xheX1Ego98XwWywhGIHAxn9edc9Q8rMIwPRai0C8winDHOJSJMkd7fQaf/QIpp25USP7/MepKc7tcrnUx56iUsGvonkU+m4j6VkWVChJFufLOn5NiA2ikGn+iJe3WuD66hFm86Eajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UA8wwSITVRStIq5w7Js7c40VkyiC1K3yzybXP8pII28=;
 b=W0yJkqvUlxansLoa/Oo76r2SOMMa8lESc+oBu763/HjEEbpKopWrwTSfQtFDOE9A3dN9oDPawk6yngIosopmaDySn07q5rYLidKyYQ8r77opUoAwUPlAmIB6xxaJtMlrTEb5/kMag6lAdB7EPf7xinw4YkVT8kZHcaGu9b6bDlM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0730.namprd04.prod.outlook.com (2603:10b6:3:f9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Mon, 8 Nov 2021 17:24:29 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 17:24:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: RE: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if
 eh-in-progress
Thread-Topic: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if
 eh-in-progress
Thread-Index: AQHX1Jllkib5cKZqeEODTm5D9rZeX6v536AAgAAAlgA=
Date:   Mon, 8 Nov 2021 17:24:29 +0000
Message-ID: <DM6PR04MB6575F4831649503EE848C4CFFC919@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211108120804.10405-1-avri.altman@wdc.com>
 <20211108120804.10405-3-avri.altman@wdc.com>
 <fa7dae1f-06ac-9d5a-616d-cc00c38e5feb@acm.org>
In-Reply-To: <fa7dae1f-06ac-9d5a-616d-cc00c38e5feb@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70dbcc61-2bc2-4e34-4113-08d9a2dc9ee5
x-ms-traffictypediagnostic: DM5PR04MB0730:
x-microsoft-antispam-prvs: <DM5PR04MB07305BA0E8D2970EB55FE1A5FC919@DM5PR04MB0730.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ii6vyUi02v7K8pFEackb7fQ/zIWWnoOSnDqEeOaSqNdHbSaiJHdhnf7dB63NE3AWwNKjVn8M9sKC4Otmo6dd3lgek4LayUZllNUkx23FfMg0O4UpSzhosO9Lhyd+vCBWCq0BWsUt4w+ovlvJoXv9Cm9ZbzDVIm8jskzqG7O/zqPBOrstoyA1AXVEB0Fk1VHHMEEvN6UggrA24HuRaTFB3Dx5MsvV3a/TrY5gBoH3+0dTnkuKTGzRrQsud3spAtS4IUjX/RiUnMtcAuUpv90/Dy8izmwX9xJgszsX5rKr2o/FWl5ELjJcYsHuNjWtcWeP2WZM8dzln7Vq8zntP58LEuV+RnoQ4lG25zc+OECmiSyqjMeTsiyrtBUzJPPPvaD9+mwB6JTEIT4XkGemevXuPHxv9Zgn0coE8fiKRoOTW/fMeEpx4YeQT8oLDaxphwezfG67wFh07xsMQvDCXyIbmYK0p/YKrOwE0hnH5x1pdssjPu3WwLgVkdGmITu6QzPAp/t0X+HItwc5lS7bb2UY5gmFqTFPRbbJGGe7zN/CSVccK0HTW5WOssXGqpenOESjamxT6lC+xpMQrgZmum7SJ2PseYEiLy0VN62b0u+FTb3NDtXLi10S1VtcJW2205GYS2+Nx0CSWRHZeOW4vbrxIaEGEEvA/Rvrq9oAdM4mHnqUGlD0HD25G3fJ0JfgNSYwDCyrqnj0qDQcTvdVPRdGR+L4V3SVk9j219v7zs7D4UbT8VbmcbelrSkOAaPuOE1W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(8936002)(9686003)(71200400001)(26005)(55016002)(66446008)(110136005)(186003)(82960400001)(86362001)(5660300002)(4326008)(2906002)(76116006)(6506007)(64756008)(316002)(53546011)(66476007)(66946007)(54906003)(83380400001)(52536014)(8676002)(38100700002)(122000001)(66556008)(508600001)(33656002)(38070700005)(118133002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0VzMUxwTkRxNnQ1MmhpdnhiZzh1K0UxdTViZnpsOEtSMWNjNGpRdy9hSHEv?=
 =?utf-8?B?ejluWm02RTZZUnhSZXVySDUwT3N2NkIyK0NYR3JsZ0tlNnVvclV4MEh5RzJO?=
 =?utf-8?B?Zk9zN1dqNUN3Y3NaZGQ0SHc1S1dXcVFXVlk4RC9ZOEw0SnBHZDRCdkpZeHZl?=
 =?utf-8?B?TldydDJpb2szamlyckl3WTNPQ3Q3SnIzM3VKdW9VQWh0Mndvdlo0OFk4RTZY?=
 =?utf-8?B?eEhiN3ovMk9kVE0wVDcrS0tVRUlkUjNmcUpvSm1nWFJOcDBhRWpBWFFhMHdI?=
 =?utf-8?B?dUVUZnJub0swVmQ1cS9Rb2IwbVFuK2JYM2w4eUdnUXNSNlRvUXRJdXNldzFK?=
 =?utf-8?B?Z3B3SEhJc2xzVVEzZFc2SE1wdGtDWU40cDlIZDZyUlgrSUlCVUpFc2FBWGdO?=
 =?utf-8?B?LzFkeUdhZmJXSnF5ZUFpOU5mcGdIdXo4N204VkJwTXVMTmJaYnVVWGRlNTFa?=
 =?utf-8?B?Nnd6cWNuVWc4MDlaanQ2OEd0aDBWYVZHeXpDTFV5Z2RmZVA5SjBxNnpPWjBB?=
 =?utf-8?B?TXZ0QnhTUndYR2RxL2F5NWtiM25SQ1B4TXF0SkpyUTZ6Y0RwdzZkVjJORWhw?=
 =?utf-8?B?b0Z3d04xMWRQTlhBcVRkTTdybVdidU1qWDc4ZmJPeG1QYm9YSHc1NWh4RlIz?=
 =?utf-8?B?UERObkZnWGFSUW1tL0RqYldPSi95Z01mb3daKzhtREV6TkhpQnBCdU5yMzFp?=
 =?utf-8?B?dTRQWWZIOHVySC9MbGZBMVJqMmMxYmNORmJ6RUxpRzVIeEZzd2IwT1ZiTkl4?=
 =?utf-8?B?aldQVW9SZTRRRUZTTDNJWHVHcXFLTlhFUHJsTWJnSzFKeUpaRkN4bjg0NFBt?=
 =?utf-8?B?NG14TDBnVFJFTjhiRzZ1SklaYWQvQU9aQ3VFVVQzeFViYjRnUkR0bnk1cEE4?=
 =?utf-8?B?NjFyRWsxTDUrU29Gc2F2d29uUHBXbVNLNmJ3TGtxSklqSHM4UjNhYWJMSnNP?=
 =?utf-8?B?VGJsM1JLVlpLMTlYdFI1VnU4V0JOU29YajBQaWlZSEZlYUFIZ0hoRDBNZWhD?=
 =?utf-8?B?alFKZjRZTUloWWZvTUR0QitPMXdBUG1sNUdPUGJDNEkyVFM0Ny8wemFFSmJn?=
 =?utf-8?B?Z2RybkNJQVlIUGxhbEZpNXIvRCszSjBsMXZzbE0wN2lWbXlxT1BpZktQVE1L?=
 =?utf-8?B?aHkyVGkySDNnSFJieFJLSjRkTGQrd3JmRXk0ZjhYVE9jOCtEbFNINWpiakI4?=
 =?utf-8?B?ck0zYTJFUEIxM3FhMkJrbzBRemI1SjVYbThGaVZEeFJjOFVtT0syUVRwUWFN?=
 =?utf-8?B?SXEvdXprZ21wY1VCUGFhYnBuNHQyektOdUZySUorektYWllYSWlROEZXaU5I?=
 =?utf-8?B?N2ZJUTlMellGMzhJMzdNOFlXTVJMLzNyYjhNaGRlMVp3Mnl1a1RTbHNneEMr?=
 =?utf-8?B?Ri9aalNKZ3laOVJ2TUFnWjhTZi8wM0w1ZC9WTXBORGNWaHVPVGNoTzFIKzBX?=
 =?utf-8?B?dExoUlJRQzNMVGhTOURIVEZBd0VLeTd0eFNEZnIxeURBc05BRWlaT2taYk14?=
 =?utf-8?B?TTY2S09PNFV4OGdCQzNzSzFlRWRwTSt0OTJtbGppekcrSzJYdWJ5eGR4M2NN?=
 =?utf-8?B?WFJZdlVUdUs4dENVMGRvSGgweUZXeHVVeHc4YWFPU3ZLSGFPM05LeE1BWWhG?=
 =?utf-8?B?ZElHUlJGOGZUaXFhYXExMnZKUXBCZUxyS3Jxd0ttSDEzQkd0SG9DVEVPWk9W?=
 =?utf-8?B?N0t1eDAvclBGQnR1WHkxN0VCS3FPL29GaE5VNU9WOFphWmt3cHNWWjllM1hV?=
 =?utf-8?B?U0JIdEIyRXJNQTFzckdJQm1jZ0hVRFNhS1Nra3FHWlpLYjI5NmdnTy92WWZY?=
 =?utf-8?B?MUFNRVhHQUlNQW1HQzNnWHl5VTAyWnZSam9MMlBxNVd4cW9ML0cyWStwRHpJ?=
 =?utf-8?B?R0Zwd2RPOUtleUZBQnUxcnFOMjkwZ2VMYXNXYXVOYlNSSW9xTE03Uk85MGtu?=
 =?utf-8?B?TkRiTkc2RkM5M0luWmFzR29HM0lUc3E5YXhuYk1rMWJBQllZK1JQTWhEOHNJ?=
 =?utf-8?B?MnpPYzFncVlOUEdmM2ZxQTNpN1ZtYVpKc2RnZ1o1OTVxUjRmekhqcWtlTGNz?=
 =?utf-8?B?dFN1U3VCTTFDWUJDTk1BdGxDNXRVMCttbXVoWVhFRENkeVF1V1g4OW9pbmJH?=
 =?utf-8?B?WWhFK1l5VVRhOHJodWtqQnNRUHFXeEFrRjZJOHl1b2hENlVraE5ZMFgxanFG?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70dbcc61-2bc2-4e34-4113-08d9a2dc9ee5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 17:24:29.1646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3/qnsRffBkwZROnKxvWk3KRz7nuKjgJvleOxqAFg1tIkhprpFribaGwYtb3C1KjWsV0mSOTadN3XwaKCAUE1Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0730
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAxMS84LzIxIDQ6MDggQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IHVmcy1ic2cgaXMg
YXR0ZW1wdGluZyB0byBhY2Nlc3MgdGhlIGRldmljZSBmcm9tIHVzZXItc3BhY2UsIGFuZCBpdCBp
cw0KPiA+IHVuYXdhcmUgb2YgdGhlIGludGVybmFsIGRyaXZlciBmbG93cywgc3BlY2lmaWNhbGx5
IGlmIGVycm9yIGhhbmRsaW5nIGlzDQo+ID4gY3VycmVudGx5IG9uZ29pbmcuDQo+ID4NCj4gPiBG
aXhlczogNWUwYTg2ZWVkODQ2IChzY3NpOiB1ZnM6IEFkZCBBUEkgdG8gZXhlY3V0ZSByYXcgdXBp
dSBjb21tYW5kcykNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFs
dG1hbkB3ZGMuY29tPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8
IDMgKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMNCj4gPiBpbmRleCAzODY5YmI1Nzc2OWIuLjgyODA2MWMwNTkwOSAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiA+IEBAIC02ODMwLDYgKzY4MzAsOSBAQCBpbnQgdWZzaGNkX2V4ZWNf
cmF3X3VwaXVfY21kKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsDQo+ID4gICAgICAgZW51bSB1dHBf
b2NzIG9jc192YWx1ZTsNCj4gPiAgICAgICB1OCB0bV9mID0gYmUzMl90b19jcHUocmVxX3VwaXUt
PmhlYWRlci5kd29yZF8xKSA+PiAxNiAmDQo+IE1BU0tfVE1fRlVOQzsNCj4gPg0KPiA+ICsgICAg
IGlmICghdWZzaGNkX2lzX3VzZXJfYWNjZXNzX2FsbG93ZWQoaGJhKSkNCj4gPiArICAgICAgICAg
ICAgIHJldHVybiAtRUJVU1k7DQo+ID4gKw0KPiA+ICAgICAgIHN3aXRjaCAobXNnY29kZSkgew0K
PiA+ICAgICAgIGNhc2UgVVBJVV9UUkFOU0FDVElPTl9OT1BfT1VUOg0KPiA+ICAgICAgICAgICAg
ICAgY21kX3R5cGUgPSBERVZfQ01EX1RZUEVfTk9QOw0KPiANCj4gTWFraW5nIG9wZXJhdGlvbnMg
ZmFpbCBpZiBlcnJvciBoYW5kbGluZyBpcyBpbiBwcm9ncmVzcyBtYWtlcyBpdCBoYXJkZXIgdGhh
bg0KPiBuZWNlc3NhcnkgdG8gd3JpdGUgdXNlciBzcGFjZSBzb2Z0d2FyZSB0aGF0IHVzZXMgdGhl
IEJTRyBpbnRlcmZhY2UuIEhhcyBpdA0KPiBiZWVuIGNvbnNpZGVyZWQgdG8gd2FpdCBpbnNpZGUg
dWZzaGNkX2V4ZWNfcmF3X3VwaXVfY21kKCkgdW50aWwgZXJyb3INCj4gaGFuZGxpbmcNCj4gaGFz
IGZpbmlzaGVkPw0KSSBhbSBub3Qgc3VyZS4NCkkgd291bGQgZXhwZWN0IGEgcmV0cnkgLyBwb2xs
aW5nIC8gb3RoZXIsIGlmIGFueSwgdG8gYmUgZG9uZSBpbiB1c2VyLXNwYWNlIGFuZCBub3QgaW4g
dGhlIGtlcm5lbC4NCmUuZy4gYSBjb21tb24gcHJhY3RpY2UgaW4gdGhlIGNvZGUgdGhhdCBzZW5k
IFNHX0lPIG9yIG90aGVyIGlvY3RscyBpcyB0byByZXRyeSBvbiBFQlVTWS4NCk5vdCBzdXJlIHRo
YXQgdGhpcyBpcyB0aGUgY2FzZSBpbiB1ZnMtdXRpbHMgdGhvdWdoLg0KDQpUaGFua3MsDQpBdnJp
DQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCg==
