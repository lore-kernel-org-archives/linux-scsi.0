Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A49C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 14:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C991B64E49
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 14:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBGOJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:09:12 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:47152 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhBGOJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 09:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612706943; x=1644242943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UecLnoXflpW4/2ptE9LcV5IrAn2GDBIWUROR/ayI6h4=;
  b=k5wo8naueZ9uSgwgaXJ6jFeyfadtc79fz5vfY8pxSuVmGULS3kf89bWZ
   qD3LTrtmm//1hzh9HgBHN2jI/M0S1HLpGXLRnSWSQOm9vMZvqrKKetUH/
   mNCQMLHmdW8PJHkWSfb45oQ1NgEqumpEs+dHP9rT/3fbdmBPei+wS2+iN
   ahlLSkXrTSPo7oTblY7hau/kd1vgmglvEg87tme1I6+j9x/d8o5Q2Bjq6
   F5kyiFk7yxDwV0cQzu5aphSyEgQjUzShUog9nnMfizpskt38+Bb7CHVSZ
   oTjX/fst/W1gpEtB9Gmlhs4RuGzA/Om8XbPeYEIh9iZ49qoNcfIvDuVyQ
   Q==;
IronPort-SDR: GuX1GSrXc0bKklaQ7agKcUTCDSQ0Zl50sQGHr5vbLpCWOlKddZQkViSS2TPRDCFbtjdaYzGA6R
 d0Xas6f1/UYq5YJLc1rhfnPH52QAwDS0k2v9/4UVte+KnNTApmq7XIaGSfQnoqORgEzGx/I1QU
 L1ajbIgqtJo/1bG6JztwieNBp2tHsrsuGuMKNLec8B+EmyWf8FI/lDudDT4DTWZwRE5q9YXJF3
 CICSouaawZkUn+Gb7tmNl3bUPwFSb3aqX98PP2TT87FQ8G6Dk2ivPJyV3FurZOkVOD2n6G+bJF
 c1Q=
X-IronPort-AV: E=Sophos;i="5.81,160,1610380800"; 
   d="scan'208";a="159376416"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2021 22:07:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIGz3fBoXBl9LP+Bfsq/Qd7MUF+RBTeBhkxp4eNPRXxYkMR29zXRwEOWoQTIQvGrLq+6OGM/QtLHTpJK7/uKDrZxVUbiqfQyomS4sTI89BPdOl0MvijwQB6Sb7FjVec1rV16V8Ktl6aryWOlMLDHto1rGD+p4F5CR+7NQbcI5YP3oOtdRiME2ob/0hM3cLJn+ojm91GXGhb4/Um3rEbvA6Z7n06YjP35XIkLIQalGE9wn2vA9waWEIKWDYrf6BPp1PL+qdNR3huP1fukVq45DKLWWFOR6vHiYGDk4GL6f5yqmoY4MZFnkM+MyqpE7vUtU8V59WcCd29pC8+B5nQJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UecLnoXflpW4/2ptE9LcV5IrAn2GDBIWUROR/ayI6h4=;
 b=WLM0vQrb95tzfrx5374w9ItxUkh/D46P+R/gKVQlSSTkMa/DYHHPlBIzD+Cl200AF08NZhGVm6seRTNsgPH99WXjEVFIgcMwDHC250PzK/kGJXtFtg/MjoPKNXNjl2x3/kyxWMrThE6xDnwCxFLNVEwG69bA56EyzeMsfyoY5ouprXaxTUqv4CumaZf1jSr2CmEKDu9vCUf5QuSFUPW6/n0F0MsDPJjAgwwGIm6eQbx1vPEZ52nG5qEiA8CwmzFhE36KwLsSml1i11zZOASjdRmOOEP5qmmJgbxAQaM0do2fvMXzfVjqrWxpUPasAtdHvluQxTDWbXIGCXTmTeoNjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UecLnoXflpW4/2ptE9LcV5IrAn2GDBIWUROR/ayI6h4=;
 b=lh9OadzbGN/Fm/vsWpSJS6gfManZ2hIJUkdf+bQL4KoEkPZR9KIJHNcSVbZv+ZcQXetk9nyo8Ar/qQ8IoUTvKrmzDNZGROcaDIHJncLzA12sQDTUGQl7L/wwtDdcNxAEVSpF2fa9PqmD/dU10yDxBx8O9QVEiR74WOuW0T4lmE8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6969.namprd04.prod.outlook.com (2603:10b6:5:240::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.27; Sun, 7 Feb 2021 14:07:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 14:07:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 0/9] Add Host control mode to HPB
Thread-Topic: [PATCH v2 0/9] Add Host control mode to HPB
Thread-Index: AQHW+T2pDR5iHBOyAEKwD+lDN07qHapJc8gAgAAB84CAA0efoA==
Date:   Sun, 7 Feb 2021 14:07:11 +0000
Message-ID: <DM6PR04MB6575FA76F94CA00F9804642DFCB09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
         <ec32248a3e56eef83744cd4844210d347add27d3.camel@gmail.com>
 <304cb44c67dc1d5fe081ea4450823c1c3b456284.camel@gmail.com>
In-Reply-To: <304cb44c67dc1d5fe081ea4450823c1c3b456284.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f8e986d-1335-4332-033b-08d8cb71a9f3
x-ms-traffictypediagnostic: DM6PR04MB6969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB69692324179DA2347E22380AFCB09@DM6PR04MB6969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5cgF3BzBTrNaG2gAEnI9Bz5GrAksLhr1FoZ48d7MpreReVmue7UnBYP+3DVe1VORMDDkkxIdx2qhxD8gyKY/QD9ttRuGy81v83CP/S2Z3d5/tD1+zglNyhRenlICzaIyHA0ZSQBAfJ+a0R4d+Na4nnByUsulyzA8p7QxDGiuATduAqms25bbw/ersRptAXG/rvmIT8qJjRyc9ClieMVfmEAmUePYpM0bVc7MdcTO7Yx5VtWeYUgpq9J0ne2QhX0e6ZenF7cOgyB6b1+uPH4nAVLFBQXQQ5IpLnwXhygN1wBoULhegucCX72Tv12XAop3q7Vf2gGMd2xMi2JN74IwKzsv9keIAh+tPqor/eIIjhgraZ2B1ml608O9ax6Jh129GdGjvOW/7rg0ZfOrnwu+nmFq8/Lllk3VziSr2ysy/9UUywdic7iZql6zaPuzO/fFkIID5w6BWBsNBC13JLwL3p4bcB5VECXa2VLp2FPLvQ78cwl+m5yBi67VoAj8qUsytd/K19fLOOeURS2JGLnu7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(316002)(33656002)(2906002)(186003)(7416002)(8936002)(8676002)(9686003)(83380400001)(55016002)(54906003)(52536014)(5660300002)(26005)(71200400001)(110136005)(478600001)(4326008)(6506007)(66946007)(7696005)(66556008)(66476007)(66446008)(64756008)(76116006)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cTllaWdFZDZuUzA5Yy8yOUk1YngvT0ZzUi96ZUdja1pQMTE5YTJILzZNTGNP?=
 =?utf-8?B?MDBoaHgxb3p2QVJIRERHeWsxN2ZpamFOaVdaRlljVEprcG5nT2plMStyNUtJ?=
 =?utf-8?B?LzZ1S2toWEkvT29tMXdNSFBXeTFXUlJGS09VUWxnRE9lRW9yQ2NNanRONDlS?=
 =?utf-8?B?eWRnNW5YY1plYjdIV1l3MDR3TmZkWCttcFQwNmdaZ3RRRktmNFI3c1Uyc1hP?=
 =?utf-8?B?a24yQnEzdG05bTBqMzZYZUlDc3I0R05JMi93TjMwMVV6b1JxYmM4RFBmQjh3?=
 =?utf-8?B?dlZQY0VOVUtaaGd5NENiNmFFNjY2T3dBaWoxZWVQejN1SkhPWGljMTZJV1k1?=
 =?utf-8?B?VWtjdTYwbEN3N3JnWWxjaTFVZUxzRU5wb1RYQUtEYlhjbTcxUHRUQTYrZFA4?=
 =?utf-8?B?KzhvNy95SUcxMUhMVzVwRHlvTy9WUm1nNW5LM011RTFDZTlTY2FrdU9IQUlm?=
 =?utf-8?B?R3NFVWhLUHFVQmpscnJqeTNsWnpzVS9OSXR6d0lJR2ZBdFBQQmQ4SVMvQnNY?=
 =?utf-8?B?bllZcW96STFQYmxOMHNnZ2w0bis0THF2a05xYk15VDhzMnFGTENmWDZHK2g0?=
 =?utf-8?B?aGJZZjJaTTAzMmw5TEo5dVlwa29zeWRBbUJhaXdVQXY5Z3VCSTViQmtYZGhV?=
 =?utf-8?B?RHJhT3pTVnFISHl2OGhrTHBRRDFEUVc5cHRwWjZLWUtTUVoxaXpNck5Pb2Fw?=
 =?utf-8?B?eVZsVXVjTGlvRnFGc0ZGSXZmZUt6Mm4rL0d0SjFJRXRycFhWa3YxU3R3a2ps?=
 =?utf-8?B?NFZlbFU0cCtiUW1qZ3J5WFFyK0hWYng5ZFhuQ1A1QVE2a0ZZWmtrUmJOajFs?=
 =?utf-8?B?V3FoUXE0VUxQTkhKdDhRK0RYZ1dCQXluY2ZXUWpVMDZFRXNIeUVTcWkrV1RT?=
 =?utf-8?B?c0Y2QkU2ckJZUmxiMVE2R0dvOGVKb1ZQbTZsZGF4N0V3ck9abFRXRGFCNmlD?=
 =?utf-8?B?UzVDaXN4Q1BpZVVVTC9sNmloUkcyaUY4YTJGdTBSTSs2RjFtSHF6QWpkU0Q2?=
 =?utf-8?B?T2V3ZjBLb0FQK3VEZDlISDVIQ0tiUW4vNXF4bjZVcm5qd1htS2tvRmV5ZzJJ?=
 =?utf-8?B?UDN6TDU4Y3RoK3RtZ01NRWsxVmliKzZIUTc1ckhPY0tHUzBwSE9pcTI3QWlp?=
 =?utf-8?B?TkNWZ1hua3l4N2xUT2ttS2ZuUUdBd25NdGpvcW1LMVVPczRSTy9DRWlqd2oz?=
 =?utf-8?B?Q1lGdUNPYmZPWnVoeFQ2MlQyYytMdXVaV0prRnNRZ3doazBlbEdnVE9LVDU3?=
 =?utf-8?B?aVZNeURuQmhSbVpMVDQwdVNyR2VyeE1rM2N1RjhDb3dmUXExN0pCMmZoTitG?=
 =?utf-8?B?c2RuaGRLK1RmU2hSN05Rc0VUZ2RlRE5XT3JleXZTL2UwQWhndDRCM3dYaTNL?=
 =?utf-8?B?NFlqazZBMUx5bDVFeVA3aWlBRlozbkVNblJHYjd1dHVNZTRRSkY1V0lOT0NM?=
 =?utf-8?B?VmFJcm1PZjNtTmdSU3ZmaFZDay9GMk90QlovVFpGN2R6OThHa1NheDZhaXB1?=
 =?utf-8?B?QjdmMjlkK2Z4WXg3NjVLTjV6RmRTSXFGUmdaUEZGMllhQVFBMDlIYzBhNDM3?=
 =?utf-8?B?cWNBZFNwRmIxY0JvNlN5UGtDdCtWTU42T0QzcW4yam92end2THhzcm1EN2Zu?=
 =?utf-8?B?eGJXTXFuRG5NZklpcnJNd2t1NU9hejBaTWRCem82bGp1WkVOMmp4bGFNTlB0?=
 =?utf-8?B?SlFsWWlKakpzTUh0WGcvVnlWZVkrakZmTGYyanhiS0lnVnc5d2ZOZFgvSGkr?=
 =?utf-8?Q?d23f1pkN6g8TNsvpzR+1Wdpmuk0FFai1tGt8eXm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f8e986d-1335-4332-033b-08d8cb71a9f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 14:07:11.4111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UAm4pI56879/v+618tJbxvqSq/Ad5DSjIlms39bRfMLB5xDlvQ9Ny5m6/cEHFl0GbL/gl05sQEaeaprula+9CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6969
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCiANCj4gSW4gYWRkaXRpb24gdG8gdGhlIGFib3ZlIGFkdmFudGFnZSBvZiBIUEIg
Imhvc3QgY29udHJvbCBtb2RlIiwgd291bGQNCj4geW91IHBsZWFzZSBzaGFyZSB0aGUgcGVyZm9y
bWFuY2UgY29tcGFyaXNvbiBkYXRhIHdpdGggImRldmljZSBjb250cm9sDQo+IG1vZGUiPyB0aGF0
IHdpbGwgZHJhdyBtb3JlIGF0dGVudGlvbiwgc2luY2UgeW91IG1lbnRpb25lZCAieW91IHRlc3Rl
ZA0KPiBvbiBHYWxheHkgUzIwLCBhbmQgWGlhb21pIE1pMTAgcHJvIiwgSSB0aGluayB5b3UgaGF2
ZSB0aGlzIGtpbmQgb2YNCj4gZGF0YS4NCj4gDQo+IFlvdXIgSFBCICJob3N0IGNvbnRyb2wgbW9k
ZSIgZHJpdmVyIHNpdHMgaW4gdGhlIHVmcyBkcml2ZXIuIFNpbmNlIG15DQo+IEhQQiAiaG9zdCBj
b250cm9sIG1vZGUiIGRyaXZlciBpcyBhbHNvIGltcGxlbWVudGVkIGluIHRoZSBVRlMgZHJpdmVy
DQo+IGxheWVyLCBJIGRpZCB0ZXN0IG15IEhQQiBkcml2ZXIgYmV0d2VlbiBkZXZpY2UgbW9kZSBh
bmQgaG9zdCBtb2RlLiBTYXcNCj4gVUZTIEhQQiAiaG9zdCBjb250cm9sIG1vZGUiIGRyaXZlciBo
YXMgcGVyZm9ybWFuY2UgZ2FpbiBjb21wYXJpbmcgdG8NCj4gSFBCICJkZXZpY2UgY29udHJvbCBt
b2RlIiBkcml2ZXIsIGJ1dCBub3Qgc2lnbmlmaWNhbnQuIElmIHlvdSBjYW4gc2hhcmUNCj4geW91
ciBIUEIgaG9zdCBjb250cm9sIG1vZGUgZHJ2aXZlciBkYXRhLCB0aGF0IHdpbGwgYmUgYXdlc29t
ZS4NCkhvc3QgY29udHJvbCBtb2RlIHdhc24ndCBzdGFuZGFyZGl6ZWQgdG8gb3ZlcmNvbWUgZGV2
aWNlIG1vZGUgcGVyZm9ybWFuY2UuDQpJbnN0ZWFkLCBob3N0IGNvbnRyb2wgbW9kZSwgZW50YWls
cyBzZXZlcmFsIGFkdmFudGFnZXMgY29tcGFyaW5nIHRvIGRldmljZSBjb250cm9sIG1vZGU6DQot
IEFsbG93IE9FTSB2ZW5kb3JzIHRvIGhhdmUgYSB1bmlmaWVkIEhQQiBhcHByb2FjaCwgd2l0aCBt
aW5vciB0byBudWxsIHBlcmZvcm1hbmNlIHZvbGF0aWxpdHkgYWNyb3NzIGRpZmZlcmVudCBzdG9y
YWdlIHZlbmRvcnMNCi0gRmxleGlibGUgYW5kIHRyYW5zcGFyZW50IGxvZ2ljIHdoaWNoIGRvZXNu
4oCZdCByZXF1aXJlcyBkZXZpY2UgZmlybXdhcmUgY2hhbmdlcy4NCkhlbmNlLCB0aGUgZGlzY3Vz
c2lvbiBvZiBob3N0LWNvbnRyb2wgdnMgZGV2aWNlIGNvbnRyb2wgcGVyZm9ybWFuY2UgZ2FpbiBp
cyBjaGFzaW5nIHRoZSByZWQgaGVycmluZy4NCg0KVGhhbmtzLA0KQXZyaQ0KDQoNCg0K
