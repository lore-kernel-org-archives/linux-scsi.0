Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA41C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DEFC64F07
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581357AbhCBSuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:50:44 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13557 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381795AbhCBIqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 03:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614674794; x=1646210794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yttp2WkP80fX48wE7Z8Ona1ylW+1XTXc//Uqsh4ebqU=;
  b=gldmRhJspGN09cvlHz1iHmFmb4zmnRf5s+EGcJY3K9e586UkNdb3MepP
   nwnj1fwIjbJHeLmkjA6k3RQr4KbinQ+SPF0Pyx4pbhDdSRlmW89qvvpAe
   g0RbWOvabPZRc8keqvTsGefeZ3KYnGIQKjDp2V38RtaGuEd+n09I1ATh4
   4s6NzEUgCSNPgFIlBXy9PqM6CijeM9IBIEafMLrmLVl2/y+iVuWSOBJHk
   r4UPHZloq4ztNP5gJoMyO8PB75zIo4PqZtTjejuefLGdex6sWBeCieB2f
   ggyw4Hyxzag5fZ2gZrvoZ/H8MyOTrFt3neGB2t7MIVBgu1kr23EXYsUm2
   w==;
IronPort-SDR: nGba/raSNQXHA92VEFVshWzMA1BsP2COG8zq2RLKWvwMGi8JeL4ek5b/kZ83UWetvpwjHhyMA0
 ivyChF64XS6UdXvUrMLW6XfykXB7J/xYM6JBSMcdcD1cgpsyJmgQK2PKjyusnvMSzZRFLllygv
 c+K4DGVduGLT6EtcDRNJ6fcGyaGoyA+xlkEl5qFOHaccvatw2yqGMgh9J5p1mlqBFwrkWzGhVu
 y53dGl9gpQmgUo1emZcLiciXlXH7wIXXJH/rvJIC2E+BVr9qFCHYygZp6v5L7uTc6F7Mqskk4P
 nDE=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="271747635"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 16:45:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=my/qs6wDnkr5zOXw+rICLShrEyzLG0+Qghylmjl0azRVBKVf5+PPXcQO6fu5vXVGQ2B0NK4s74r8SlqKygzUGvVggq8gnHkSzvV02cnC+HWyoVZQzxRUF9xPHf+M+zGWnEBU9+YOxtbXMCVA5ZFmNb63G1ijZabOZ9k+ijYkzaSRB7rM1fan0We+onCrfIaqRNxAMpTxTPSDzdTMyF2uegKNuMekNAEQo8UCySf/L02DeWdZohoz70FUt7S0YYANx8NIb08+TIc9W+q6MC3nfX7DplDBtspT78xohbXfdk53qFTErMLPH8WAsl0JFfuf3bXMniFY3D0OiTQsrU8Wwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yttp2WkP80fX48wE7Z8Ona1ylW+1XTXc//Uqsh4ebqU=;
 b=ARAqv/J9uSQ9txs/iXRYWjKgEOqAaAViILxV1UeqONHKoxqQzelLts+zJ4CYW4Vb7PMsh3hcaTAtX6h6iAgao4wBBXxzIc+tIPlesnrT2fYhQVkpbyHuL0ny0qNvJqcu7+nh0CdYUG9R83MF1ImEoyj/U1t8alaTTtovHol5FormSdqpE6flWh1JypdVNxOrk9tqdGI2qqz755IPQU43icrpsBpgYfKy62mH7WwYxako/WjZ9lVSAU/80sBpje5ek9FKGW0z3P2uVL4sItFG3MPGVTBPBQFbmx2b9WFjtkzojjMnegE4xK7SoCArsi6farKzV+t7H3CZASOJIktVuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yttp2WkP80fX48wE7Z8Ona1ylW+1XTXc//Uqsh4ebqU=;
 b=Txv3wOJQ2xSR8SuhvK4IvJq6IMqQIStSWCafr/NYZ6xHFqDW6T1Sc25uYvpmdciqtzOACDDOfY2WS8V9fh7jmFI15/D3nSc1f/rno/ZO834hrDaRLpMd78RSmEuBFGFMKYqe15UiAw+JK1hUYJlbyzEeEZj8TWibcjgIteMYs9M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7115.namprd04.prod.outlook.com (2603:10b6:5:24c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.23; Tue, 2 Mar 2021 08:45:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 08:45:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v4 7/9] scsi: ufshpb: Add "Cold" regions timer
Thread-Topic: [PATCH v4 7/9] scsi: ufshpb: Add "Cold" regions timer
Thread-Index: AQHXDBpHkJd5xoB5OEu8nyMX9CCV1KpwY0YAgAAD4DA=
Date:   Tue, 2 Mar 2021 08:45:20 +0000
Message-ID: <DM6PR04MB657580F9080C31AB5AED1FDBFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210226083300.30934-8-avri.altman@wdc.com>
        <20210226083300.30934-1-avri.altman@wdc.com>
        <CGME20210226083459epcas2p1862e3e2c18208074336cc9faf14a7139@epcms2p7>
 <878274034.81614673683390.JavaMail.epsvc@epcpadp4>
In-Reply-To: <878274034.81614673683390.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6eb924c7-100f-47ff-baca-08d8dd578349
x-ms-traffictypediagnostic: DM6PR04MB7115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB7115350B2A94470F8A5EDCACFC999@DM6PR04MB7115.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RjxoJgA8gTSjdNQgGnJ+c32int5zIHGA4VNaNgU2958gO/Olnu6x3FIj7bu1YRG37qr8M0nGXezW5fXLl0EINqF4yT68W9HlDuCD7YeTI7wa17F9Xayhv7K8qUkHbHipFy0MNpou1Uag0EnTxfLLhdrETHytgN8S29tP+yCjo+nEiobkLuPaYqQ+fItNJcqMAHdPVWVFRJBYzWKUN1FT2BJMFDdaXbEegWZWWYGrEuPnB1twBNQFATfkJVQntkDZMVlRZrAw+BYlJp69N8PHLGkkAaw2isXe5llT1XJ/blehbZGWhU8KB01OSeiVvBBYygyqvdYuFCKdBo+2a8yPX0pjxhD4nrbVynYvFaytPR3wNNj4rEb33SgnXxeGE2ivoTCl62n4jgr1nQIBQjUPi7MnNXiR+uBn5hVd5vHbFjKqqYx/1DcBTUF+cvBMKHe/ZlZtSApeIup2heN/8XoUDE8v2enuEAN8VB2DZtwjUn+wIohhmt12gMqFMnzoJQ4ZKgMRlAn6HZLzuXr6e5wUwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(66446008)(71200400001)(76116006)(186003)(54906003)(110136005)(83380400001)(33656002)(6506007)(8676002)(8936002)(316002)(7416002)(7696005)(2906002)(52536014)(9686003)(66556008)(66476007)(66946007)(4326008)(64756008)(55016002)(478600001)(86362001)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ajhMYnVycnJSTDkwdVozQTFIbk0zNng1NkRZQk9vUTBsanBRWGtlNkJlckxB?=
 =?utf-8?B?QkhudnBIVTFBMkU0aExlbEkzVUw0cnFlTFFtU3VOa0FRZndpTHlFK3Y5ME1F?=
 =?utf-8?B?eS84NUdhYXBLZnlTTVMxSTVZeS9qLzBsYWE4ME5nOFoxWGR6eXlkcEx0SFdw?=
 =?utf-8?B?THFjSHFBYVRZcnZWT1k1MDBzRld6SlpZYmh1aDJXMHc0aU9oMUZ5SU0zeFI0?=
 =?utf-8?B?QzdJWDUxSnJQOSt6OStKeU5ZYURObUtKODUvL3lBR0s1K3BQem9UQXRUd3Zr?=
 =?utf-8?B?MDhpWmswUEVYS295UHBJNEc3RC9POE15VzZvWUFqZTdiblZoYmpBb0l1OTFO?=
 =?utf-8?B?TmlNemppa0ZhUkhQWmY0ci9IZ3E2ZmVFdEZiOFN2QnJ2SGQ5V0tEUXdtUnhQ?=
 =?utf-8?B?ODNqK2V0dkNteGVVMmZlbmV6b05UV0xSYkpsY0J3YUN5ajhFQWc4VCt5Tjl3?=
 =?utf-8?B?cFdYbjdCRFg2MWF3YWJjdWo5ZzQ5VTlRM3NBbzVmRVNoUWxObFA1QjRmZERY?=
 =?utf-8?B?a21BSEZacXBSQzdOcm9CZnRVdWhTclA1VW5Pa1hrMTE2endnOEtHOFhmTmlx?=
 =?utf-8?B?RkxnU1R1WFRxbWoyQnM2cUhrM3hGTC9DSnhhMDlmQ0VxaFZiOE4zbGdSeU9M?=
 =?utf-8?B?VTYwUE5XcktNbTExdEVsUk53aWdJR2ZUMHcyek5RdDBUYXltU2lSVGgwVmVU?=
 =?utf-8?B?R1ErQ09xNHZhL0ZYYTJBLzMwYjFJV2g5dmpGRXdDNndZYTlvUDhFODUvOE1v?=
 =?utf-8?B?cVRGM20wa3ZOYXk2c050M2tHTXBtUEtYRWQyQ1JDbW51eVREd2xqdGsyaUx1?=
 =?utf-8?B?cnh2d1I2WWlQYWNPTDhzNVVwM1FuU2NHVDY3TG1SL3VoTncvWU5zZ3MxdHA2?=
 =?utf-8?B?aXFOWWU1aDh3Q3R5dWUzUlhic3BidnQyRUxYbzdickNEbnJHZ004WUhaUjZn?=
 =?utf-8?B?K0UzdENqQURabXdxY2dZUTJDTDhIWDRHVWkyU0p0c3NrYUpkQWlLd2dicFNJ?=
 =?utf-8?B?RWFRclFtY2VLeVpHNHI0MFlDSnp5T2FqaHFGWGt2K1pvV3FDVXpqckJVSTRW?=
 =?utf-8?B?VXRPZFRhKzZDK0R3VUxpbXRYeG9sSTlQUmpJeFhjNitadEVOY0RQMUdPSUQ1?=
 =?utf-8?B?Nm5sblBiMTZpakdobjV4MXpnZjFBdWlrSTBPK2o2ZDVyM3BsbkVncS9lYzQ1?=
 =?utf-8?B?Y3VjT2grNVo1TDk3NXpuVmg1MjV1VnloYXVDQ2g1UWdjV3h0V0NrOGtuWitX?=
 =?utf-8?B?WElmbTlkZHBVbmVxcjJsWFdVQklEckcxUWZaQ0tBOFIvRlJBMGI4WjNFVlYv?=
 =?utf-8?B?cmtHYkowcERNRitLdHlPbXRQcldHajV6ZzZCdjN6cGlzUzBITkRXN1hQaity?=
 =?utf-8?B?R0dZMWhaY3dVTDBhNHZwNFRYbk1DV3k0REVhTVdnd2E1MDg0WG5raGpMa2R0?=
 =?utf-8?B?VUxxblZWUmxBblRJWWw4QUtVZFo5eUg1SUxMcDUwaThXN1dPamdMbm93L2Rr?=
 =?utf-8?B?emxBejhoeVpHYkVSQk1zS2lob211ZjBOZUxqNW03aEVSWExaUWtrWXY0K3Vs?=
 =?utf-8?B?TUFKeXllUmY3MDlGQi80TDRyeklNTE16cFN4U1d1S0I4M2RHMXE5WWF3dmFM?=
 =?utf-8?B?aUl5cXJveU1mbE1Zc1hTMkhMUWphU25DMzJnQm03Rnh4VGExL1Yxd3dQUVFo?=
 =?utf-8?B?dGErR2R4MSt5bXJIVDdBUW05TVQ0ZWxSQklGb2tmR01QcllYL0IwZzdSWndh?=
 =?utf-8?Q?W2Nne7WvuRXJPig39K1lXkTLRTjkgVHvIANnzJD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb924c7-100f-47ff-baca-08d8dd578349
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 08:45:20.6629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GxlemZtO9/YG5fswPAFzX2cRP2S1v2MI4DBaygkfSgXwTPH6Z7tg41uz0MHMPUaTZhzeG6ysTgzFauuN62gYgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQXZyaSwNCj4gDQo+ID4gK3N0YXRpYyB2b2lkIHVmc2hwYl9yZWFkX3RvX2hhbmRs
ZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+ICt7DQo+ID4gKyAgICAgICAgc3RydWN0
IGRlbGF5ZWRfd29yayAqZHdvcmsgPSB0b19kZWxheWVkX3dvcmsod29yayk7DQo+ID4gKyAgICAg
ICAgc3RydWN0IHVmc2hwYl9sdSAqaHBiOw0KPiA+ICsgICAgICAgIHN0cnVjdCB2aWN0aW1fc2Vs
ZWN0X2luZm8gKmxydV9pbmZvOw0KPiA+ICsgICAgICAgIHN0cnVjdCB1ZnNocGJfcmVnaW9uICpy
Z247DQo+ID4gKyAgICAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiArICAgICAgICBMSVNU
X0hFQUQoZXhwaXJlZF9saXN0KTsNCj4gPiArDQo+ID4gKyAgICAgICAgaHBiID0gY29udGFpbmVy
X29mKGR3b3JrLCBzdHJ1Y3QgdWZzaHBiX2x1LCB1ZnNocGJfcmVhZF90b193b3JrKTsNCj4gPiAr
DQo+ID4gKyAgICAgICAgaWYgKHRlc3RfYW5kX3NldF9iaXQoVElNRU9VVF9XT1JLX1BFTkRJTkcs
ICZocGItDQo+ID53b3JrX2RhdGFfYml0cykpDQo+ID4gKyAgICAgICAgICAgICAgICByZXR1cm47
DQo+ID4gKw0KPiA+ICsgICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZocGItPnJnbl9zdGF0ZV9s
b2NrLCBmbGFncyk7DQo+ID4gKw0KPiA+ICsgICAgICAgIGxydV9pbmZvID0gJmhwYi0+bHJ1X2lu
Zm87DQo+ID4gKw0KPiA+ICsgICAgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkocmduLCAmbHJ1X2lu
Zm8tPmxoX2xydV9yZ24sIGxpc3RfbHJ1X3Jnbikgew0KPiA+ICsgICAgICAgICAgICAgICAgYm9v
bCB0aW1lZG91dCA9IGt0aW1lX2FmdGVyKGt0aW1lX2dldCgpLCByZ24tPnJlYWRfdGltZW91dCk7
DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAgaWYgKHRpbWVkb3V0KSB7DQo+IA0KPiBJdCBp
cyBpbXBvcnRhbnQgbm90IGp1c3QgdG8gY2hlY2sgdGhlIHRpbWVvdXQsIGJ1dCBob3cgbXVjaCB0
aW1lIGhhcyBwYXNzZWQuDQo+IElmIHRoZSB0aW1lIGV4Y2VlZGVkIGlzIHR3aWNlIHRoZSB0aHJl
c2hvbGQsIHRoZSByZWFkX3RpbWVvdXRfZXhwaXJpZXMNCj4gdmFsdWUgc2hvdWxkIGJlIHJlZHVj
ZWQgYnkgMiBpbnN0ZWFkIG9mIDEuDQpUaGVvcmV0aWNhbGx5IHRoaXMgc2hvdWxkbid0IGhhcHBl
bmVkLg0KUGxlYXNlIG5vdGUgdGhhdCBQT0xMSU5HX0lOVEVSVkFMX01TIDw8IFJFQURfVE9fTVMu
DQpCZXR0ZXIgYWRkIGFwcHJvcHJpYXRlIGNoZWNrIHdoZW4gbWFraW5nIHRob3NlIGNvbmZpZ3Vy
YWJsZS4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
cmduLT5yZWFkX3RpbWVvdXRfZXhwaXJpZXMtLTsNCj4gDQo+IFRoYW5rcywNCj4gRGFlanVuDQoN
Cg==
