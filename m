Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3267EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 14:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbiKWO4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 09:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237941AbiKWO4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 09:56:07 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A85701A1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 06:56:03 -0800 (PST)
X-UUID: 13fe67652bd74d22b67d53bd90f3dbff-20221123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Gb8KOZ/y90mrtFMxSM7CxDkR389+4S2dkEEyaXDwX8A=;
        b=jS3JhooOgg7uA6UB4BJ6rdYMunPGX5Joqa7jSyAINaxEG1EngTRxZSSA/sT1GL1vJcLp+uOQ7B6wL+HUG2bl6I00Q3YcdOcNtO/epE+DUmN3Fy2DHn4Wapm5TbWOtqIsIRg1RxqRSAZQ9DWsFLQB+Nk0vYMbchlI6l5Jy28gUbg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.13,REQID:038513c1-e163-44d6-b324-26967cd36d2a,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:d12e911,CLOUDID:d5890adc-6ad4-42ff-91f3-18e0272db660,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 13fe67652bd74d22b67d53bd90f3dbff-20221123
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1830745407; Wed, 23 Nov 2022 22:55:59 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 23 Nov 2022 22:55:58 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 23 Nov 2022 22:55:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltRar7pvQBxmiV42r1ZhpNhRGHB9xvAlvpNg46LE3IFjIPRlub8DNj8oiV/FqriL5AtHapMDxsOxEksa71O7foL11d6wlCMyiEM4nsvVNcSiWorFj0Oy/6brj5lb2WWDT7iMOYZyqGZ8Sp3BnW3NMHIgl5454AHYdAv3+n1KIzo6Vu6VDqNf1XLeuXogmPL7yYcCNCN6K8lshSpPjLfraNQo5noXZm3ZCviGDMAI7ut8igi3ybn2wB3J/NlOk014x7zDaAM9v2b5QHit16GrWJch1AsuNwinlD3NT2Igb35Y4boNqQvJWD8UX/iFKd5mKBBVUBBUZ7cOCeMYt5yy3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gb8KOZ/y90mrtFMxSM7CxDkR389+4S2dkEEyaXDwX8A=;
 b=D3AwZeixe72kg110/bSFQtgCm87y1ipSDYZbe7pU5CwVSiI0ZQKdlz5mhqkjtWKT3cI9Ms+KFegnQiGn9B3No8a+WPSKNg4H+34ZDGNQ/aXqiqWEVICnz0wiBK/Bs2g/hAx9mwq/nb8CGy2gR+qMvM1v2ctD3yI3JlYDlnefZPDQUKKvOaN4N5Lb8IRq5kref9G+4Q6Zx51zH+qwKxYR4dNgfnjEuMm0N/I1wpKwWoYBJoH+A0qfWuDTYo1sJ9SrSJ3pVUnJ7uzEo1N1U8lLKIX1UpSHE9b8sAPt5to48/HF+vBFF5dUkpgyaWOcLRoc0QD7PW3606wge0gaJQ4fjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gb8KOZ/y90mrtFMxSM7CxDkR389+4S2dkEEyaXDwX8A=;
 b=WRUZ/OdA0dVLS8Hk4yxFhOsyYHWXfQGGFWxKBSF0qLQ5j58nnWUEXgGDlhqxjQzH4t81W7kkgB+Igob0ur3KyTcIG9B7YkwjExsmEzBfpfK+VSN1Iv1Pcq7Kw9kf3NdXNnQpITj+9LzQj8F4MImJZlpzmmu3Wvh41DW/yOOZAc0=
Received: from TYZPR03MB5825.apcprd03.prod.outlook.com (2603:1096:400:120::13)
 by TYZPR03MB6108.apcprd03.prod.outlook.com (2603:1096:400:12f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 14:55:56 +0000
Received: from TYZPR03MB5825.apcprd03.prod.outlook.com
 ([fe80::dbb9:6916:78dc:a8d7]) by TYZPR03MB5825.apcprd03.prod.outlook.com
 ([fe80::dbb9:6916:78dc:a8d7%4]) with mapi id 15.20.5857.017; Wed, 23 Nov 2022
 14:55:56 +0000
From:   =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>
To:     Asutosh Das <quic_asutoshd@quicinc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mani@kernel.org" <mani@kernel.org>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
Subject: RE: 52a518019c causes issue with Qualcomm UFSHC
Thread-Topic: 52a518019c causes issue with Qualcomm UFSHC
Thread-Index: AQHY+JRsLD9C7hYXDUSyXaMzhtaPeq5CrSKggAC6xgCAAAHKAIABqCGAgACMf2CABGmGAIACnPrA
Date:   Wed, 23 Nov 2022 14:55:56 +0000
Message-ID: <TYZPR03MB5825DD114BFEF6B8091A9AAB830C9@TYZPR03MB5825.apcprd03.prod.outlook.com>
References: <20221115014804.GA24294@asutoshd-linux1.qualcomm.com>
 <KL1PR03MB5836A982CAE0FE411743BF7283069@KL1PR03MB5836.apcprd03.prod.outlook.com>
 <20221117174634.GA12056@asutoshd-linux1.qualcomm.com>
 <584b6f9a-c4f9-8ecc-98d9-216923d85ddf@acm.org>
 <20221118191058.GA28646@asutoshd-linux1.qualcomm.com>
 <TYZPR03MB5825B4D5259FA22CCC876E7783089@TYZPR03MB5825.apcprd03.prod.outlook.com>
 <20221121225634.GA20677@asutoshd-linux1.qualcomm.com>
In-Reply-To: <20221121225634.GA20677@asutoshd-linux1.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB5825:EE_|TYZPR03MB6108:EE_
x-ms-office365-filtering-correlation-id: 8670d281-7554-4a5c-8661-08dacd62d380
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2i+kmw42zcRK1RIJ/8f/rqSHFWHVaXxQ9lXsrm1oqxatkpkfUrS/stY5nhyZHEQo6xkvf2F9XQIcFKhDFSAXeiQxgF4bOMmTe9DK5LN+Zvkh+yXI984l6Rcay0+Hrr07pS4AMRcijjKUVmiVOwf+1ELLLrG4b4ox2m+wSte23Hw8Xdxzd+tRp8+rILpQILislkQQ4JdxhBxgBqVONcr/zYVejKWKHeogRfwxH05DWWL03bFSSWo5WFTgGzuSFJ4AqcmKz+0o94LOQkZKP1ZmFqStc/k1MNbjrAFDwNkTeHO3VjkGuKcEqqeN/zjr8GN2EwwazwlWSerKVNZaD3532yb1BuaMNP7DqTbHYkzgdM8qLAOq8H2qXe5cAsrNd82ULCMRfT58s24vpwlP/6yIRMKTBCq3u7fJwcHhndO5PTX0cshmUHBG20sOI97YG44GHEFgYEjwmxX50IemvSsCNLdv5AoJK+YS8lRr7pOco6VCmMfBQMf6dM6y+BjQTCzuZOqQoJ7RXAoE98mIyoQNLvR59kiPagK3A7nefhsjRaYb01PtmJI7Y3vmj4x9u5Of59otOouePtLDNzBEkXy02ecspL+mGnK6sunwiP54OY5Wf/v+yjcZQ5kDWyYIdhgJx985+oAXTw15ZZvUsmTh1xN4nWVItZtpJTS5GXPaxAXFvPeqEITUx4l9RIre8wPbSts91eJ2FGq8JyVzonX4eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB5825.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199015)(122000001)(71200400001)(6506007)(7696005)(54906003)(6916009)(53546011)(38100700002)(86362001)(316002)(26005)(9686003)(76116006)(66946007)(4326008)(66446008)(478600001)(8676002)(66476007)(66556008)(55016003)(64756008)(41300700001)(8936002)(38070700005)(83380400001)(5660300002)(52536014)(186003)(33656002)(2906002)(85182001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zmh3MmZGcFZ3aUd4dmhySTVraFZJYUVZS2xOZTFjZFF6UngrVzJudngzTVl1?=
 =?utf-8?B?K2YyekZMQjRJQmFYaXcxdEdMczczcTRoTC83MzNnbzBqZUxNMXhCZGJpY1Ru?=
 =?utf-8?B?b3BkbkJLdEVleWZPSUl3aTFzdlFCMXpWUHJUd0ZwL2Z0L3p3S3BtREQ2R0RO?=
 =?utf-8?B?VUh3MEpUc004cDBpM045QlN0MXdOWGZwV2JzRWZXYjVZM0d4bVVMbENDMHdl?=
 =?utf-8?B?di9aV0tqOXU4MktRVW4xN3BUQ1BoVk03a2pJT2IwS1NYQzhsaVVhTWdoUWRW?=
 =?utf-8?B?TXVqbDZYSjFrbHJESDgxQ2VDOEhVcDgxU3gzaTVUdXl3eEdjVGYwUFMvMldV?=
 =?utf-8?B?RW9BSWtuQTJpQXlEYXRDMURVdHh6cWpSdVdUM3NXM3MrNmdWMGdWWTVNdm1F?=
 =?utf-8?B?QU9kV2tORndBOUUvdi9ZWE0rUkQ4dHRkZlljNFN2SGxMbWVRd2lTcGtXeGpE?=
 =?utf-8?B?a3lrV1o3dXlaeVhWanpnVUJjelA4b2ZXclh0UG9RN2VTK0V3VitpVm1PY3l0?=
 =?utf-8?B?RG5mc2NzZ2VzSzdsL2pXV0pLT3RkSDVmQlJpcjVVb1BvN2paMnZBVFVycTBD?=
 =?utf-8?B?alpkbGJTUTVVSVV3d1draUpBY0xvU25IQ3dQSkp0Q1JaSXRqRVlDbWdDN1do?=
 =?utf-8?B?QXJ6cmR4ZEpWNFBsQ0lkYVFYbFExbXM2VmlMTTcvaTFpc25welpORk95Um0w?=
 =?utf-8?B?T3htRFhmR2NibFV3blV5UlMyeUJzZlloMFVRT2Rick5qcm5JZHJYSnZ0RjhD?=
 =?utf-8?B?d05Ea0l1Q2svVWgwVTFFUkZJVHRRZFdEamFDQnVzSXgwV0ZCTFplRlM3dDZ1?=
 =?utf-8?B?N3ZPVm5SY3Rrb1N1dzdNaWduVWVrbEU5T3hURkFxazNELzlJVlFjc0NBdXFL?=
 =?utf-8?B?QWxheHlSanRIUEhGRDk5NS9VMWNhcE5FTXBZRHRMcFBJNFdwYStHOHduaHRJ?=
 =?utf-8?B?OXlEdmhNelNOV3hQRUhBbUltL2JnOHlhREVZK3VDRTJyRG1Mcy8vaHM2L1dt?=
 =?utf-8?B?TGU5QWhXVjFWU2tKZ095WjZVZklvUU9xWFozYXU5ZmltVUtscitLSGJIZ3Bv?=
 =?utf-8?B?R2xHQlc4SDlNVDRTWnIxR0FaRjExSzg2czB6alBGeUY0MlVqNktHUThEcnJi?=
 =?utf-8?B?TSsrdkJNWVRkdVVZM0YxTEt1OFEwdkcvVkVOMzRiR0FMVjZydFBBSTI0aEY3?=
 =?utf-8?B?NkV6Nlp4R1NsZkpoVnFSOFJtV2RaRHZlaVlnNEdWUVNhQWprQndJTlM0dXdz?=
 =?utf-8?B?akZRQkpZWlp3U3YvS3gwM2N6bEVNMldNU0ZMUzNYb2oxNmp3YlIrN2dNRFh3?=
 =?utf-8?B?Wk5KQjdFaEx6R05PWTZVUjBnU2RhUS9BYUwvL2RTQVVOT3ROVHVmRThrWXVS?=
 =?utf-8?B?UkorWm9zWFJ2cHRlWXRENDlyMnAvY2FjcHpXenZzZHoxaU11M2Y1encvZDRK?=
 =?utf-8?B?WlRvamN5aHlsTlVZcjVRQllOM05JZWJrNytlMlErTkZXeHJjcHdXZ1grNDI3?=
 =?utf-8?B?aTlVUkg1RFVVSEg5eldzOWpaWmpJbzFIczZuNG96d1Jrdmhvd0xEcTBDK1d4?=
 =?utf-8?B?cHUrdUhFcWNmSW1RaTRBQ3JrcERHbzB3K0x3UStQS1FOWTQwaktQMEZtVHkx?=
 =?utf-8?B?RkZsekxQZjMzblRZck9WUmNiWmdscnVVWFRoSU5OLzFkNVdvVFNUVWM2S25W?=
 =?utf-8?B?d05kbm9DVmsydXY4TXA3enErOHpjcGhJT2U1SGp2ZkJ2dzRyZG40d3UxN0dQ?=
 =?utf-8?B?VThPRWw5ZFlMdXpjbjlkNnVUTXlQaEkySHVJeU1tc2RmSk14L1drYlRnY1Rh?=
 =?utf-8?B?Nkx5SDVkdjRrdVVPa0FvQlcraU9MR041V0lpeEo3OWNoTHM4dFVWd2FOSTRR?=
 =?utf-8?B?VFBRVWxFTkRQTWozNVI5ejhBdUdRU3ZraDRXd2JWZkp3QVZ5NlZzK2RTWGF2?=
 =?utf-8?B?K1Q4S3dIL3FlZWNGNERlUlQvY2pKSWlsQ1JjMjVvSVcraHRxUE5QcGtDT01H?=
 =?utf-8?B?dlJWM0RzTEtCMzA4c2V4UEdNbzQyZDJIYXBWdGdWbWltNS95Yk9LQzlKYmtU?=
 =?utf-8?B?RFdVSXYrMk1LMG5sZm5McWU5ckxmT0pTT1I2TEJ5bjhBN25yM010bUxHVlFU?=
 =?utf-8?Q?+yAkqE5NA3prfLrCQ35Kto/e9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB5825.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8670d281-7554-4a5c-8661-08dacd62d380
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 14:55:56.4938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f1zexzKp0796fDja+MSOOLytuUrWmCsSkSDK+Thz1CwJQvdswKZJIhDKooKoZna6hNQSZbW/lOYTxjULkvKTAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQXN1dG9zaCwNCg0KU29ycnkgZm9yIHRoZSBpbmNvbnZlbmllbmNlLCB3ZSB3aWxsIGRpc2N1
c3MgaW50ZXJuYWxseSB0byBzZWUgaWYgdGhlcmUncyBhIGJldHRlciBmaXggdGhhdCBtZWV0cyBi
b3RoIG91ciBuZWVkcy4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEFzdXRv
c2ggRGFzIDxxdWljX2FzdXRvc2hkQHF1aWNpbmMuY29tPiANClNlbnQ6IFR1ZXNkYXksIE5vdmVt
YmVyIDIyLCAyMDIyIDY6NTcgQU0NClRvOiBQb3dlbiBLYW8gKOmrmOS8r+aWhykgPFBvd2VuLkth
b0BtZWRpYXRlay5jb20+DQpDYzogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+
OyBTdGFubGV5IENodSAo5pyx5Y6f6ZmeKSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPjsgbWFy
dGluLnBldGVyc2VuQG9yYWNsZS5jb207IFBldGVyIFdhbmcgKOeOi+S/oeWPiykgPHBldGVyLndh
bmdAbWVkaWF0ZWsuY29tPjsgTmFvbWkgQ2h1ICjmnLHoqaDnlLApIDxOYW9taS5DaHVAbWVkaWF0
ZWsuY29tPjsgQWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKSA8QWxpY2UuQ2hhb0BtZWRpYXRlay5jb20+
OyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgbWFuaUBrZXJuZWwub3JnOyBxdWljX2NhbmdA
cXVpY2luYy5jb20NClN1YmplY3Q6IFJlOiA1MmE1MTgwMTljIGNhdXNlcyBpc3N1ZSB3aXRoIFF1
YWxjb21tIFVGU0hDDQoNCk9uIFNhdCwgTm92IDE5IDIwMjIgYXQgMjA6MTYgLTA4MDAsIFBvd2Vu
IEthbyAo6auY5Lyv5paHKSB3cm90ZToNCj5IaSBBc3V0b3NoLA0KPg0KPg0KPg0KPlJldmVydGlu
ZyB0aGUgcGF0Y2ggZG9lc24ndCBzb3VuZCBmZWFzaWJsZSBvbiBNVEsgcGxhdGZvcm0g4pi5DQo+
DQo+DQo+DQo+Pj5JIGRvbid0IHRoaW5rIGludm9raW5nIGEgY2xvY2sgc2NhbGluZyBub3RpZmlj
YXRpb24gZHVyaW5nDQo+DQo+Pj51ZnNoY2RfaG9zdF9yZXNldF9hbmRfcmVzdG9yZSgpIHNvdW5k
cyByaWdodCB0byBtZS4NCj4NCj5CdXQgdGhlIHBvaW50IGlzIHRoYXQgZHJpdmVyIGhhcyB0aGUg
cmlnaHQgdG8ga25vdyB0aGF0IHRoZSBjbGsgaXMgc2NhbGVkIG5vIG1hdHRlciB3aGVyZSB1ZnNo
Y2Rfc2NhbGVfY2xrcygpIGlzIGludm9rZWQsIG5vPw0KPg0KPg0KPg0KPkRvIHlvdSBtaW5kIGFw
cGx5aW5nIHRoaXMgcGF0Y2ggb24gcWNvbSBkcml2ZXIgdG8gY2hlY2sgb24gaG9zdCBzdGF0dXMg
YmVmb3JlIGZ1cnRoZXIgb3BlcmF0aW9uPw0KDQorIE1hbmksIGxpbnV4LXNjc2kNCg0KSGVsbG8g
UG93ZW4NClRoYW5rcyBmb3IgdGhlIGNoYW5nZS4gSSB3aWxsIHRoaW5rIG9mIHNvbWV0aGluZyB0
byB3b3JrLWFyb3VuZCB0aGUgaXNzdWUuDQpIb3dldmVyLCBJIHdvdWxkIGxpa2UgdG8gcG9pbnQg
b3V0IHRoYXQgYSBjaGFuZ2UgdGhhdCBicmVha3MgYW4gZXhpc3RpbmcgZHJpdmVyIG11c3QgYmUg
Zml4ZWQgb3IgcmV2ZXJ0ZWQsIG5vdCB0aGUgb3RoZXIgd2F5IGFyb3VuZC4NCg0KLWFzZA0KDQo=
