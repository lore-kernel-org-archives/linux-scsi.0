Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45A9C83012
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 07:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61ABE221FF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 07:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RVD8TaP7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zWP0P3Zc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgLAHBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 02:01:30 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19483 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLAHBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 02:01:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606806089; x=1638342089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nZbMzqbfUa7pEhGe5SPuBQ4yXF0KlBP2btAGb4BI254=;
  b=RVD8TaP7l3YRR7AJaVCY8MHX7P5nCcsmjP8P3+VydKBQsGh5R4dVwIfC
   3jVk5FVR50VfLsO6AdIAsZqin/CdSZZySLMcvtHTNAJKPyGjrEff36q8+
   iVZpiqcgUtCimthzKcl4m0q2pEsHIxjof5+eqvoKILYdu2QDDX20V3g9s
   Qt7HL14b1TyxBISEwrt126dWEj5IWU8pjHRAShmukZJBLXKruaYMMAdnb
   VNivIDrbYx4dMl3hpPVKnuJrFRmRdxQhL7UTRpw02NIw9DCpM9NJGSjAI
   ruSgIeNemrQEyig5BbaR/wCaFw7kLq3S2gUYVgaBOFayZ1gwLmJECDx0l
   w==;
IronPort-SDR: EmMqvxxdL7eVbFin/apA86f/wkVDVew46UYFvSxAXUdddLawvcE8HkhPkgPoRt7WW+iUmYyR4I
 unI+oFSaDNEl35+rpARzXDDrVYs5nahfJB08p1SdVNhueI/Wco7WwpXpgbIDwVDWunZ/9GPTDu
 wX/cteE1+kyI9o/LrTRUwXR7PxnrCFsNBMMgVPtX2dsqFBSL94NnNvE5QEClFW+xnLWvKYPNMi
 6JCVZie1qMM83GoCo+xslbf2X/GJQldVm7bU2miANzcP0Uv6FMStQh11VDUCdvYfLeni8WswNX
 LeU=
X-IronPort-AV: E=Sophos;i="5.78,383,1599494400"; 
   d="scan'208";a="153958379"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2020 15:00:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOZWz4nP827F+ZSjYRco7Arcuwxxuh7W2swrDwGXHYF3MOxqeuhsIN3BJARvlr1yWvOMXHtzvzJRIV7GmEA1C27RLish1FPSt0qzvLixgzv+omspdfwb/BNhszSAYoUmI+jUqeZ/Ibkgscq97uuvF0y7xPqFmMmbfM5i6NnD8NwZwW0SABGDtYnT2EVdTDKJNJDXZ7UGYX9iCruH9qGG1SlAh833ltd7hxo3g03Yk5ginzCYT7DHvtymtI+FZmsle7nXIwYbriUw1YmltecXarcX5GALAGT3kAsBiaYr+YtYrNIfKOeVesVsjudgNrjccNONbX+n+dnLo8wzkdtK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZbMzqbfUa7pEhGe5SPuBQ4yXF0KlBP2btAGb4BI254=;
 b=ii0GB4jHTDVk1x8Ofq5ZWbeD7oZ04Y8xGY7dySNVt4D3ZXKGFPphfUtDH1yn7uBLtV4x5bRbLuLYCeK3X3Oe7YgSg9uSINebWOuk2XlBLA2JkYBIcYPbxnwO5U/lqUMIUEG9gtTeNh5yuo+VxoxumjsiHJXPjlKXtE4AKxFudkdUJaYf360obimy0ZxNhZa5ulSk6uPFeBjnuQPVQjuSmrT3pi8JvOBM/FrD44Q+heuHgemf5cj5pr/bhwVi/BMw0vmszPMmnZFMMNFhdYfy9+eCqrSEO2ozbS5uIBIj16cd11sedriwvD9eM/dOJE8Y0kbC36bc5kgLthP3pPxX2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZbMzqbfUa7pEhGe5SPuBQ4yXF0KlBP2btAGb4BI254=;
 b=zWP0P3Zcyi3V4UEdAIjoHSpRGKW1Alm6tUAXz0tqljNAKMAmLDhrC6O85UY/+aR9lobMnLYl8a1M098GQ9t2T03fXKsTVfFynFl6fH0bWKFcDLuFf6H8Zm9ydDQPxii3mxp4ISCt6avOg/L1fNGOPHF4EOa/lLKvn1fRW962RFg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6140.namprd04.prod.outlook.com (2603:10b6:5:12c::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25; Tue, 1 Dec 2020 07:00:21 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.017; Tue, 1 Dec 2020
 07:00:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "Asutosh Das (asd)" <asutoshd@codeaurora.org>
CC:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Subject: RE: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC voltage
 values
Thread-Topic: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC voltage
 values
Thread-Index: AQHWxvl86T293PgVNkSYZJFhGzjYYanhSMmAgAAGaICAAAsZAIAAGVoAgAAcuoCAAD9pAIAAAHEQ
Date:   Tue, 1 Dec 2020 07:00:21 +0000
Message-ID: <DM6PR04MB65752A87CA471D9D76BB75EEFCF40@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130091610.2752-1-stanley.chu@mediatek.com>
         <568660cd-80e6-1b8f-d426-4614c9159ff4@codeaurora.org>
         <X8V83T+Tx6teNLOR@builder.lan>
         <4335d590-0506-d920-8e7f-f0f0372780f9@codeaurora.org>
         <1606785904.23925.25.camel@mtkswgap22>
         <d998857a-1744-a8bb-1a3e-77166c171f37@codeaurora.org>
 <1606805690.23925.29.camel@mtkswgap22>
In-Reply-To: <1606805690.23925.29.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b94a626-3274-408c-b637-08d895c6c530
x-ms-traffictypediagnostic: DM6PR04MB6140:
x-microsoft-antispam-prvs: <DM6PR04MB614065661C36D48879FC74EEFCF40@DM6PR04MB6140.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8OSaQLK5BKlep/JmkeGvA0E/arkZVE44IBYIGHLPINOexMhSBTqWwc9ul8vKt4fxQNE0IZFc9Y5vWWNQyd/lOrIFSwx+n6Aiq6/4Sk2TgOTBQLzdeGxqWGyJpuuB3e3pm10fwm1aOGoPGti6BRKJY9XXIBe7BTdBNMyr4mfScR1cQ8QsHQsfqeuPtNzdwAGa5NL0CKuD19KFz0uJkv9m/HD10RFkYjsMKV/C/94Px9EuTI2gV0YwKfWaVNDWMv7tpIP3ShlKMU/Z67nMK7kTVa1ZPwjZ1tDOv/NuvAiaumRWovX5YYsP7lN/2fYHsoSHcHQe7n9ETbM017lZnrX5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(55016002)(7696005)(4326008)(316002)(9686003)(86362001)(478600001)(54906003)(26005)(7416002)(8936002)(110136005)(8676002)(186003)(66556008)(66446008)(33656002)(6506007)(71200400001)(5660300002)(52536014)(64756008)(83380400001)(2906002)(66946007)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?LzRab3dPWDE5azAyMm1aWEswQ0JVUkVwOStRRkhUK2hXMW01bVhRZi9aYnJ1?=
 =?utf-8?B?RGpmeDRIM3ByZ0gzR0VNWnpOTEhQWDNNOFVlQ2xMcm1UYlErbVM5VmtCY05y?=
 =?utf-8?B?VG5vc3pnNXZvejk1ZG5kSENiQ2piVWdQZ2J4R01VY0ZzYWYyQU0wbWFuNkhj?=
 =?utf-8?B?djA1R3dlanRzTUVCV0I2dFAzWGFxcy83YzVUZEZhZDBNMWxSc0lFUHl0ZjdJ?=
 =?utf-8?B?bGxLUjVra21sd0puaGNSSExUQUNaOThlQzdUNk5iSnJ0V3l1MitxY2Zsd253?=
 =?utf-8?B?RW9uajJlaTIvYU5ZcVJ0VmduUi9UazF4aXVjSmJjN0w4M1hMUDRpV2VJajFT?=
 =?utf-8?B?a0VVMlBVdlNzam9SbkRraTlIZ0RPU2pHSlhsVVdJM3lWMERieVZmSytOTkdu?=
 =?utf-8?B?ZTUzcTg4Y2ltTTBtWW45WDdUODZKQk5VWnFmZ2J3NHdXWmlYOENaN2t3a0Ru?=
 =?utf-8?B?MUdsSERjazVnTWx2YXVqaE0rMmpNZ0pwQU9OUnZ3QW10NlBmMUJlckJubWZU?=
 =?utf-8?B?NTF6UnJJYmZNVGdiNStvVG55cFNTTmlHTUJEa01NeFpLUktSRzVRRTFHRVhR?=
 =?utf-8?B?S0IwOTRvL1QyVkxxSjR6V1YwSVZoNEkzUjY0UXBMaTdnMHFUcjZYcVZlc0lH?=
 =?utf-8?B?QUdkaVI0eDNuYU14WllHdjc5N1FJdXdkYlRFRmtwWkNUZGE1M2FsbDl2TU1n?=
 =?utf-8?B?ZVBnakdzaUFBdDhXUVRSUVM5VW42OVlDbU8yR2lCMWdTWUFLR1VoZ1A1d240?=
 =?utf-8?B?S1Rsd0hQSDlPSGdRd0N6VHFpT1NLWVphUUJ4WFlJVWhjVEcrcWpxNVl3Q09Q?=
 =?utf-8?B?ekUvclpPaE4wOThqU2VyZ1JQUXFUQnBZcnIzOUpJRC9YYUxVK3poa3hlckZO?=
 =?utf-8?B?c2FYMGhTZVJKTzFGcXg5dXBDaWM3TFNqN1dwYVF4QllVVU90cU9va1VaMkx2?=
 =?utf-8?B?Z1Y4NUJ3NHpBSVlQZncyV2dzR3kvNjFwR2J4SFJ5VXFiTDZSMjBCRjBhbnQr?=
 =?utf-8?B?cktIdFg5NkljVVUxbGxkdTA0SkNqRHFEV3ZvRHFyNzVpZVEwSGt3OEErM1dh?=
 =?utf-8?B?UVd6bm9PTGpBd3hpb1A1ZW93cTdmdDJPSzh0cFUzOXk4K281NTVtNkIzZVBT?=
 =?utf-8?B?bkdCanNuTWl6K0NuMzQ4M3p5d1BTblZPVnVyWkErS3J6OGV2Y3k2TkovcTNl?=
 =?utf-8?B?T3lxMWN0cW94NjRqR2lFV2s2WUgvS1lTd21QUmVmR1RPSTdRbmtBYUtMNmZM?=
 =?utf-8?B?bFdLTEkrT3hkU1ArbXRCZjFKSkYyRlRrN3JINElLTnVlWSs1aldpMldoZjNX?=
 =?utf-8?Q?NqKTj3nhJAOsU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b94a626-3274-408c-b637-08d895c6c530
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 07:00:21.6854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTcubyxIagWj498nGrusCyJO/7z8NWvgaSX01CO5hrX9wC59kTyVdtDw9r/biqTiMTuBYkDtiEK/epd1tM4Emg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4+Pj4gSGkgU3RhbmxleQ0KPiA+ID4+Pj4NCj4gPiA+Pj4+IFRoYW5rcyBmb3IgdGhlIHBh
dGNoLiBCYW8gKG5ndXllbmIpIHdhcyBhbHNvIHdvcmtpbmcgdG93YXJkcw0KPiBzb21ldGhpbmcN
Cj4gPiA+Pj4+IHNpbWlsYXIuDQo+ID4gPj4+PiBXb3VsZCBpdCBiZSBwb3NzaWJsZSBmb3IgeW91
IHRvIHRha2UgaW50byBhY2NvdW50IHRoZSBzY2VuYXJpbyBpbg0KPiB3aGljaCB0aGUNCj4gPiA+
Pj4+IHNhbWUgcGxhdGZvcm0gc3VwcG9ydHMgYm90aCAyLnggYW5kIDMueCBVRlMgZGV2aWNlcz8N
Cj4gPiA+Pj4+DQo+ID4gPj4+PiBUaGVzZSd2ZSBkaWZmZXJlbnQgdm9sdGFnZSByZXF1aXJlbWVu
dHMsIDIuNHYtMy42di4NCj4gPiA+Pj4+IEknbSBub3Qgc3VyZSBpZiBzdGFuZGFyZCBkdHMgcmVn
dWxhdG9yIHByb3BlcnRpZXMgY2FuIHN1cHBvcnQgdGhpcy4NCj4gPiA+Pj4+DQo+ID4gPj4+DQo+
ID4gPj4+IFdoYXQgaXMgdGhlIGFjdHVhbCB2b2x0YWdlIHJlcXVpcmVtZW50IGZvciB0aGVzZSBk
ZXZpY2VzIGFuZCBob3cNCj4gZG9lcw0KPiA+ID4+PiB0aGUgc29mdHdhcmUga25vdyB3aGF0IHZv
bHRhZ2UgdG8gcGljayBpbiB0aGlzIHJhbmdlPw0KPiA+ID4+Pg0KPiA+ID4+PiBSZWdhcmRzLA0K
PiA+ID4+PiBCam9ybg0KPiA+ID4+Pg0KPiA+ID4+Pj4gLWFzZA0KPiA+ID4+Pj4NCj4gPiA+Pj4+
DQo+ID4gPj4+PiAtLQ0KPiA+ID4+Pj4gVGhlIFF1YWxjb21tIElubm92YXRpb24gQ2VudGVyLCBJ
bmMuIGlzIGEgbWVtYmVyIG9mIHRoZSBDb2RlDQo+IEF1cm9yYSBGb3J1bSwNCj4gPiA+Pj4+IExp
bnV4IEZvdW5kYXRpb24gQ29sbGFib3JhdGl2ZSBQcm9qZWN0DQo+ID4gPj4NCj4gPiA+PiBGb3Ig
cGxhdGZvcm1zIHRoYXQgc3VwcG9ydCBib3RoIDIueCAoMi43di0zLjZ2KSBhbmQgMy54ICgyLjR2
LTIuN3YpLCB0aGUNCj4gPiA+PiB2b2x0YWdlIHJlcXVpcmVtZW50cyAoVmNjKSBhcmUgMi40di0z
LjZ2LiBUaGUgc29mdHdhcmUgaW5pdGlhbGl6ZXMgdGhlDQo+ID4gPj4gdWZzIGRldmljZSBhdCAy
Ljk1diAmIHJlYWRzIHRoZSB2ZXJzaW9uIGFuZCBpZiB0aGUgZGV2aWNlIGlzIDMueCwgaXQgbWF5
DQo+ID4gPj4gZG8gdGhlIGZvbGxvd2luZzoNCj4gPiA+PiAtIFNldCB0aGUgZGV2aWNlIHBvd2Vy
IG1vZGUgdG8gU0xFRVANCj4gPiA+PiAtIERpc2FibGUgdGhlIFZjYw0KPiA+ID4+IC0gRW5hYmxl
IHRoZSBWY2MgYW5kIHNldCBpdCB0byAyLjV2DQo+ID4gPj4gLSBTZXQgdGhlIGRldmljZSBwb3dl
ciBtb2RlIHRvIEFDVElWRQ0KPiA+ID4+DQo+ID4gPj4gQWxsIG9mIHRoZSBhYm92ZSBtYXkgYmUg
ZG9uZSBhdCBIUy1HMSAmIG1vdmVkIHRvIG1heCBzdXBwb3J0ZWQgZ2Vhcg0KPiA+ID4+IGJhc2Vk
IG9uIHRoZSBkZXZpY2UgdmVyc2lvbiwgcGVyaGFwcz8NCj4gPiA+DQo+ID4gPiBIaSBBc3V0b3No
LA0KPiA+ID4NCj4gPiA+IFRoYW5rcyBmb3Igc2hhcmluZyB0aGlzIGlkZWEuDQo+ID4gPg0KPiA+
ID4gMS4gSSBkaWQgbm90IHNlZSBhYm92ZSBmbG93IGRlZmluZWQgaW4gVUZTIHNwZWNpZmljYXRp
b25zLCBwbGVhc2UNCj4gPiA+IGNvcnJlY3QgbWUgaWYgSSB3YXMgd3JvbmcuDQo+ID4gPg0KPiA+
ID4gMi4gRm9yIGFib3ZlIGZsb3csIHRoZSBjb25jZXJuIGlzIHRoYXQgSSBhbSBub3Qgc3VyZSBp
ZiBhbGwgZGV2aWNlcw0KPiA+ID4gc3VwcG9ydGluZyBWQ0MgKDIuNHYgLSAyLjd2KSBjYW4gYWNj
ZXB0IGhpZ2hlciB2b2x0YWdlLCBzYXkgMi45NXYsIGZvcg0KPiA+ID4gdmVyc2lvbiBkZXRlY3Rp
b24uDQo+ID4gPg0KPiA+ID4gMy4gRm9yIHZlcnNpb24gZGV0ZWN0aW9uLCBhbm90aGVyIGNvbmNl
cm4gaXMgdGhhdCBJIGFtIG5vdCBzdXJlIGlmIGFsbA0KPiA+ID4gMy54IGRldmljZXMgc3VwcG9y
dCBWQ0MgKDIuNHYgLSAyLjd2KSBvbmx5LCBvciBpbiBvdGhlciB3b3JkcywgSSBhbSBub3QNCj4g
PiA+IHN1cmUgaWYgYWxsIDIueCBkZXZpY2VzIHN1cHBvcnQgVkNDICgyLjd2IC0gMy42dikgb25s
eS4gVGhlIGFib3ZlIHJ1bGUNCj4gPiA+IHdpbGwgYnJlYWsgYW55IGRldmljZXMgbm90IG9iZXlp
bmcgdGhpcyAiY29udmVudGlvbnMiLg0KPiA+ID4NCj4gPiA+IEZvciBwbGF0Zm9ybXMgdGhhdCBz
dXBwb3J0IGJvdGggMi54ICgyLjd2LTMuNnYpIGFuZCAzLnggKDIuNHYtMi43diksDQo+ID4gPg0K
PiA+ID4gSXQgd291bGQgYmUgZ29vZCBmb3IgVUZTIGRyaXZlcnMgZGV0ZWN0aW5nIHRoZSBjb3Jy
ZWN0IHZvbHRhZ2UgaWYgdGhlDQo+ID4gPiBwcm90b2NvbCBpcyB3ZWxsLWRlZmluZWQgaW4gc3Bl
Y2lmaWNhdGlvbnMuIFVudGlsIHRoYXQgZGF5LCBhbnkNCj4gPiA+ICJub24tc3RhbmRhcmQiIHdh
eSBtYXkgYmUgYmV0dGVyIGltcGxlbWVudGVkIGluIHZlbmRvcidzIG9wcz8NCj4gPiA+DQo+ID4g
PiBJZiB0aGUgdm9wIGNvbmNlcHQgd29ya3Mgb24geW91ciBwbGF0Zm9ybSwgd2UgY291bGQgc3Rp
bGwga2VlcCBzdHJ1Y3QNCj4gPiA+IHVmc192cmVnIGFuZCBhbGxvdyB2ZW5kb3JzIHRvIGNvbmZp
Z3VyZSBwcm9wZXIgbWluX3VWIGFuZCBtYXhfdVYgdG8NCj4gbWFrZQ0KPiA+ID4gcmVndWxhdG9y
X3NldF92b2x0YWdlKCkgd29ya3MgZHVyaW5nIFZDQyB0b2dnbGluZyBmbG93LiBXaXRob3V0IHNw
ZWNpZmljDQo+ID4gPiB2ZW5kb3IgY29uZmlndXJhdGlvbnMsIG1pbl91ViBhbmQgbWF4X3VWIHdv
dWxkIGJlIE5VTEwgYnkgZGVmYXVsdA0KPiBhbmQNCj4gPiA+IFVGUyBjb3JlIGRyaXZlciB3aWxs
IG9ubHkgZW5hYmxlL2Rpc2FzYmxlIFZDQyByZWd1bGF0b3Igb25seSB3aXRob3V0DQo+ID4gPiBh
ZGp1c3RpbmcgaXRzIHZvbHRhZ2UuDQo+ID4gPg0KPiA+DQo+ID4gSSB0aGluayB0aGlzIHdvdWxk
IHdvcmsuIERvIHlvdSBwbGFuIHRvIGltcGxlbWVudCB0aGlzPw0KPiA+IElmIG5vdCwgSSBjYW4g
dGFrZSB0aGlzIHVwLiBQbGVhc2UgbGV0IG1lIGtub3cuDQo+IA0KPiBUaGFua3MgZm9yIHRoZSB1
bmRlcnN0YW5kaW5nIGFuZCBzdXBwb3J0Lg0KPiANCj4gSSB3b3VsZCBsaWtlIHRvIHJlLXBvc3Qg
dGhpcyBwYXRjaCB0byBzaW1wbHkgcmVtb3ZpbmcgdGhlIHByZS1kZWZpbmVkDQo+IGluaXRpYWwg
dmFsdWVzIG9mIGFsbCBkZXZpY2UgcG93ZXJzLg0KPiANCj4gRm9yIHZvcCBpZGVhIHN1cHBvcnRp
bmcgdGhlIHZvbHRhZ2UgZGV0ZWN0aW9uIHdheSwgY291bGQgeW91IHBsZWFzZSB0YWtlDQo+IGl0
IHVwIHNpbmNlIHRoaXMgd291bGQgYmUgYmV0dGVyIHRvIGZpdCB3aGF0IHlvdSBuZWVkIGZvciBm
aXhpbmcgdGhpcw0KPiBpc3N1ZT8NCkFnYWluIC0gd2h5IHZvcCBhbmQgbm90IGEgZHRzIGZsYWc/
DQpUaGUgcGxhdGZvcm0gb3duZXIgaXMgYXdhcmUgb2Ygd2hpY2ggZGV2aWNlIHNoaXBzIG9uIHdo
aWNoIHBsYXRmb3JtLCBpc24ndCBpdD8NCg0KVGhhbmtzLA0KQXZyaQ0K
