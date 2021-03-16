Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AC1C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 09:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F2976500C
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 09:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhCPJVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 05:21:54 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34374 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbhCPJVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 05:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615886501; x=1647422501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gL2wBEzNMtTSgBfv44VN6tlGd2Re6UI8m+/Tohf77RY=;
  b=c22FEXOGkL5w8CwErQAO23wFSI0ELMiew/pye64gjRoBbbasUZ3ItIXQ
   ZO+l88do8HTQMn/ZEvpfwX0mSg9FZ8TBOWnopgT7tlwag3hRSvJ35Rn9F
   8legxOdT5SBmsWzJutm0Y2sBF34NoEY17dxQbrBtDFaWzNm0x+T8YrEx9
   iC/D18gPHySZSOsMxGcA+0QNNJe40phDuyDomJanjNwqhk2CA/m3Sbrgk
   HsVSG4ZLPz1OKMZV+AX51QXYiNo0+ZmOUoUIpPJC7TODKCHdvMH0PD7r3
   R2CktOhWo6TeHaFomWxzLUYdhIc3WZiKPJiD7sZiCQ4n7gihJsFyWe3Wg
   w==;
IronPort-SDR: T0b2yOxoGMbu6S0WKzaKDrQdvJEC9GQhikdDfKNqg7ZMd4thnKrMplGv5pP7SRrwsY+u2q8g2U
 g87k6XS8E7odch7dqlBvHzlez0G8/w3QWWVLsHKe5v9cejuEd44LazsAueWEggsW9kIcz7RaJ2
 9i38OY18/IkuWnCLXuafOjlj0JcbkPL8nhJ44qfVKN61G7Uu8xTh8hkfOmqD3MlW7K08ZB5lp9
 FtwUUY1hn5qIyXDKjB7oy4wMBaJOxFc33Q+iJpGN+YXQPR9M4m1tirGYmB3RLQb4xdN+owLUzM
 B2M=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="163393982"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 17:21:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlpB/VZvAdErtBO/TmSSrbMSp7gwu5bGT9WG56u0ntf4L45R9l+bQNq8QCHK+iGQ3XPNY5jfAk5dH/9ORFWT/waJS5X2JQEtDlszW7SCDXP2px/43NPYO/WI09oDeQhtlyB3TQmiH6wzt9l6yBrPellBR4YUVCQM7oRFtxoqcH3qjmUIXQ6y/seH9VnqPKCbjGP3D6Em6ktMB84TwbgqbBgnxOIR+wmG6ebvGQf43+ktQlGTOLYskB+NgmrK98WRZ78+jkhWXENe7hWgy3FUkNMNuAlGfaOY6ZLosU8vRADNGfKiQqhf7NDChOOO9FuIa6fBVJadgCmPAnWi1bNfwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL2wBEzNMtTSgBfv44VN6tlGd2Re6UI8m+/Tohf77RY=;
 b=MkhlSDfp2FzNIpo0lyZxETKnJu6tQTS8oLcdaVdZuwxBYBORUHP6FQeSGG7OoSVNC8lXp2cEXXv/BwZ9VxnWkq+pwWSdv3+KkwGTo3PP8IpNyX5tcS1tC5T7o6D28RQYJKJ4ORU05kzVuqX99m4PdX2RoyxOX2iqNhD6kHLv6SarkbEE3HDA5xyMkmidkksnmEqfT8jJkHkGKcXABccsla/eHXFeZamc4xaa7x61bDGwNQN97IDmE2bhvcS1Q4z9dvdNS4SY3QZdiW5b/MQY6muRxMuiNw5TIm2l5c5hcCMMtdhe8rFM2SJiEoKVFcsiv2k56xb216KLLdVgoScHLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gL2wBEzNMtTSgBfv44VN6tlGd2Re6UI8m+/Tohf77RY=;
 b=z5JMNwyF36ohaew2rIXCsg6q1q/nVoNjF4/l5gILAa2NosL6Q/wBPXeUlTBAVAIDXUkhjFNFW2CsrcnqFO0TlmH3vl6/3OHh13PLn598zeyRXRRZamBEs+KMt3osuqXi9qd6pC+mf6sJNYX4+dLvFExoVm2kxSTVfWrzHPogT2E=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5355.namprd04.prod.outlook.com (2603:10b6:5:101::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 09:21:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 09:21:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Thread-Topic: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Thread-Index: AQHXD2e3uMXza01lFEKVh8wFSC1kCqqE3okAgAGGSTA=
Date:   Tue, 16 Mar 2021 09:21:38 +0000
Message-ID: <DM6PR04MB65755EE82C8D19B27E8B576BFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-8-avri.altman@wdc.com>
 <be5c0c390d7c0cf13e67f51cdc7dd8c2@codeaurora.org>
In-Reply-To: <be5c0c390d7c0cf13e67f51cdc7dd8c2@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c680b77-5ac1-470e-f92f-08d8e85ce71f
x-ms-traffictypediagnostic: DM6PR04MB5355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5355C41A0F00F9186C485988FC6B9@DM6PR04MB5355.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dagBhFF8nOXyyOIA1l0kFwof323r2dDaGr8NzuBgHHRVF34gY5BRcIb7SUll/WkOmkMguhuEcExRnncPxG1xlXayFwEoH0OQ71MHW4cMuNhV0FW1f54vUmMbV00hGAItAkkJV1nymZUs6QMqtCoppgPLpBunPg+00eNjreQY7iRuO+5kTJF8mLzZ/uWKfdHULOZB4IUBgKHOP1mXdpgFvoEIxVR+L4T1L+8CQMmgEZFNarh8f+8age2iv0Rz2u6vfgl3R9NNAW1jrY0rK7LQ2971RK3+UxxjAaIY7K1jzYYmuMqk1Pkn2Wcwpph6rwj1+rhNVsngoJ65VzyBHBdQCT/NfKMjyOl10YyW5DGYfm01pNJt/3OjGabdj1tLzI/jMQ2ppZwYM+odxgoFBFYOYgViBJXjHiNXscVfp0Xu+6+6blUPAbXCg+y6jZmKu4lj1fD6NsR0/2Gg89zWPev5/W71gyi/IZs2qrIHfZ6IDwb/EM2z75i9Tzr7urqVU3lmfIcWr6uW8qZ6P0wPvPwzHwaQvtRzMdfmUyTkVjXjmlLKCbS1tOn0Pox/JGbW2hn4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(6506007)(8936002)(66476007)(66446008)(66556008)(7696005)(76116006)(83380400001)(9686003)(186003)(33656002)(478600001)(52536014)(4326008)(86362001)(7416002)(5660300002)(71200400001)(6916009)(64756008)(8676002)(26005)(54906003)(2906002)(55016002)(316002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L1RsTFJiV3VSWmtKVURXZC9Wb09ocFlwaUhmbFl3dlp2T204MDRndFVwWVZs?=
 =?utf-8?B?UUhFTlNiMGswMXByNzh0SVpPcnFaKzNxZ3MyZUorYThBazVWM2tXQmFtNSs4?=
 =?utf-8?B?ZkVQK2tNWHhBZkhHbXl0YXYwRUx2VEp0U1JobjJtQms3N1BZVTIyL2NLc1l0?=
 =?utf-8?B?MHZ3Z09NbXplc0gyOURSWWpiR2JUQkJOUlB3Q0ZBU2crTzFkOEVsS3lOV3Bn?=
 =?utf-8?B?RnlhVnpBclhBL2ZNVnhJWjg3ZXJ5TDQ2M2RQY2dGZzhEUEdYeThwY00vUURB?=
 =?utf-8?B?Vk5VcUZVTEE4aDloUXArVkQ2NlY5YlcyTklnZkJVbmVWektsdkZMeUViWUdj?=
 =?utf-8?B?cGN2QWJrUnRZQjcxWWJsZE4xQmZoaUJUMTNGRmN2M21qQjdEMWZ1THd3QS8x?=
 =?utf-8?B?NkpxV0ZZcWpsaWk3NFBRaTlCYzNtMFZNb0Fkd0I5d0VzQ0lkcWF5TjluNGpE?=
 =?utf-8?B?a3FPc01jY3V5Y0RBTWc4QmxZK21jb0hiUE5uNmN1d2hTNnovMkEvN2pKNU9q?=
 =?utf-8?B?anB4WWV4aVdlMVBmMlRXd2VjNHZydHFTNS92SGsrL3dUSGEra0JNUStQKzJx?=
 =?utf-8?B?UjRSVm82UVBsUDRQTEsvTzJSSWJKOVhoZTFjOTlkcmdLQW4xeDY2eXdib2dR?=
 =?utf-8?B?M05aVmpEcldaYWhuTGVJYXlXMVJza21PbXhrVDlPS0ZBVHIvR0JTR0dKUThK?=
 =?utf-8?B?Q2psMEFXeG12T3cyVllmVjlyNmZSNFN3MzFRUDBoR2xFZ3dYSm9vbitlZnE1?=
 =?utf-8?B?dCt0Rzl0QkRZNisxWmdrb1MzTGZWeWdhcVN6cTFNUFhzYkhuWmkzWWpkMVc2?=
 =?utf-8?B?Sktkd2pxdXUvZ2ZXd2JGTGJxYUN2TCtFSGorVXZyZUN5MklWUEpWamUvSnpV?=
 =?utf-8?B?MFlON3ZSZnBob3VhanZMZUkrdWpnQ1VSSUN4MTNhaTRnbmJISWZIWlMzcXQx?=
 =?utf-8?B?Skk3MTFFL1VJZlpjamp5eHJTanhseENiNFFJNmgzdXdDeDE1c2VROXBwbFV6?=
 =?utf-8?B?eFQxd0JobGUyMEpvcUk5M0ZBZjRnQjk0c1VXUFYvclBiWno4c04wc05YcEVq?=
 =?utf-8?B?cGNaN1dRU05tTWViTmM5ZVErM3Y4UnNDYklINVBiTnVHakY3Y2V1UHJJWmVN?=
 =?utf-8?B?OEp6MSthdGJjQmJpR05VUSsrMTNOR00xWjFHMVA1TGIycEdSRzZOZEJ2R0xm?=
 =?utf-8?B?WTFaMjFXREtDa2VjVFBvTHZBZ0h5Y2N3emV6c2R6eWNLYnppNGJWYWtNMVhu?=
 =?utf-8?B?RHdTS0V3eHUrNXdKSWFzYzRTd1NIcGdES2NKRDhYRklvQnI0NWttT29ITEl2?=
 =?utf-8?B?N3dFcnV6RGtSVlovYlFsOVMveTRaZjFQek56RTUvb0M3MElUdTVBakRwK0JU?=
 =?utf-8?B?dnhFRTEzTFZGZEdYand6b3lZNXZCNXhNdWhFRDAwNXRmMGJqdUE3QTZNbFQr?=
 =?utf-8?B?VDJmR2RERWlYZXlYeDNtVmM2RUtYZkp4NEtXOThqV3VRdDAxOWNYVGszMUN4?=
 =?utf-8?B?U2VBK1lOeVlYSzJOVlQ0NFNmTFh6aGJ6d2J4RmJBTDJjdGdUbXFBK21QNUhF?=
 =?utf-8?B?Y1ZXckhoWU5zUDdNS3Y3OUhYK2FOd3dQSFdPWW9RbFJ6T1NjUzRvMG5ESVJw?=
 =?utf-8?B?VEtmSXVueG1yR3N2TysvSUlWeUpCUk5VWHkxRnhwbGt6eERYZ2lycUl6a1Zl?=
 =?utf-8?B?RDZ2eG52R2FwdTF0NlhxRjhUVFFxMWlIZnREZHFYcUlLTHFydUNDZ3dKVjVj?=
 =?utf-8?Q?fbWJtoOqwYAxgoyY1HUAn152eAi4xUZrHW0Zxk2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c680b77-5ac1-470e-f92f-08d8e85ce71f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 09:21:38.3201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sThDHqgkgjORiaku2IYqssyBodk05Y6bW/eIv4KwH0+JEpTRN9eJYt8yYQ7l2ogNXQhIr+aOpDtTJcbdRuaDAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5355
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICtzdGF0aWMgdm9pZCB1ZnNocGJfcmVhZF90b19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBkZWxheWVkX3dvcmsgKmR3b3JrID0g
dG9fZGVsYXllZF93b3JrKHdvcmspOw0KPiA+ICsgICAgIHN0cnVjdCB1ZnNocGJfbHUgKmhwYjsN
Cj4gPiArICAgICBzdHJ1Y3QgdmljdGltX3NlbGVjdF9pbmZvICpscnVfaW5mbzsNCj4gPiArICAg
ICBzdHJ1Y3QgdWZzaHBiX3JlZ2lvbiAqcmduOw0KPiA+ICsgICAgIHVuc2lnbmVkIGxvbmcgZmxh
Z3M7DQo+ID4gKyAgICAgTElTVF9IRUFEKGV4cGlyZWRfbGlzdCk7DQo+ID4gKw0KPiA+ICsgICAg
IGhwYiA9IGNvbnRhaW5lcl9vZihkd29yaywgc3RydWN0IHVmc2hwYl9sdSwgdWZzaHBiX3JlYWRf
dG9fd29yayk7DQo+ID4gKw0KPiA+ICsgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZocGItPnJnbl9z
dGF0ZV9sb2NrLCBmbGFncyk7DQo+ID4gKw0KPiA+ICsgICAgIGxydV9pbmZvID0gJmhwYi0+bHJ1
X2luZm87DQo+ID4gKw0KPiA+ICsgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkocmduLCAmbHJ1X2lu
Zm8tPmxoX2xydV9yZ24sIGxpc3RfbHJ1X3Jnbikgew0KPiA+ICsgICAgICAgICAgICAgYm9vbCB0
aW1lZG91dCA9IGt0aW1lX2FmdGVyKGt0aW1lX2dldCgpLCByZ24tPnJlYWRfdGltZW91dCk7DQo+
ID4gKw0KPiA+ICsgICAgICAgICAgICAgaWYgKHRpbWVkb3V0KSB7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIHJnbi0+cmVhZF90aW1lb3V0X2V4cGlyaWVzLS07DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIGlmIChpc19yZ25fZGlydHkocmduKSB8fA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgcmduLT5yZWFkX3RpbWVvdXRfZXhwaXJpZXMgPT0gMCkNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBsaXN0X2FkZCgmcmduLT5saXN0X2V4cGlyZWRfcmduLCAmZXhw
aXJlZF9saXN0KTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgZWxzZQ0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHJnbi0+cmVhZF90aW1lb3V0ID0ga3RpbWVfYWRkX21zKGt0
aW1lX2dldCgpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBSRUFEX1RPX01TKTsNCj4gPiArICAgICAgICAgICAgIH0NCj4gPiArICAg
ICB9DQo+ID4gKw0KPiA+ICsgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhwYi0+cmduX3N0
YXRlX2xvY2ssIGZsYWdzKTsNCj4gPiArDQo+ID4gKyAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShy
Z24sICZleHBpcmVkX2xpc3QsIGxpc3RfZXhwaXJlZF9yZ24pIHsNCj4gDQo+IEhlcmUgY2FuIGJl
IHByb2JsZW1hdGljIC0gc2luY2UgeW91IGRvbid0IGhhdmUgdGhlIG5hdGl2ZSBleHBpcmVkX2xp
c3QNCj4gaW5pdGlhbGl6ZWQNCj4gYmVmb3JlIHVzZSwgaWYgYWJvdmUgbG9vcCBkaWQgbm90IGlu
c2VydCBhbnl0aGluZyB0byBleHBpcmVkX2xpc3QsIGl0DQo+IHNoYWxsIGJlY29tZQ0KPiBhIGRl
YWQgbG9vcCBoZXJlLg0KTm90IHN1cmUgd2hhdCB5b3UgbWVhbnQgYnkgbmF0aXZlIGluaXRpYWxp
emF0aW9uLg0KTElTVF9IRUFEIGlzIHN0YXRpY2FsbHkgaW5pdGlhbGl6aW5nIGFuIGVtcHR5IGxp
c3QsIHJlc3VsdGluZyB0aGUgc2FtZSBvdXRjb21lIGFzIElOSVRfTElTVF9IRUFELg0KDQo+IA0K
PiBBbmQsIHdoaWNoIGxvY2sgaXMgcHJvdGVjdGluZyByZ24tPmxpc3RfZXhwaXJlZF9yZ24/IElm
IHR3bw0KPiByZWFkX3RvX2hhbmRsZXIgd29ya3MNCj4gYXJlIHJ1bm5pbmcgaW4gcGFyYWxsZWws
IG9uZSBjYW4gYmUgaW5zZXJ0aW5nIGl0IHRvIGl0cyBleHBpcmVkX2xpc3QNCj4gd2hpbGUgYW5v
dGhlcg0KPiBjYW4gYmUgZGVsZXRpbmcgaXQuDQpUaGUgdGltZW91dCBoYW5kbGVyLCBiZWluZyBh
IGRlbGF5ZWQgd29yaywgaXMgbWVhbnQgdG8gcnVuIGV2ZXJ5IHBvbGxpbmcgcGVyaW9kLg0KT3Jp
Z2luYWxseSwgSSBoYWQgaXQgcHJvdGVjdGVkIGZyb20gMiBoYW5kbGVycyBydW5uaW5nIGNvbmN1
cnJlbnRseSwNCkJ1dCBJIHJlbW92ZWQgaXQgZm9sbG93aW5nIERhZWp1bidzIGNvbW1lbnQsIHdo
aWNoIEkgYWNjZXB0ZWQsDQpTaW5jZSBpdCBpcyBhbHdheXMgc2NoZWR1bGVkIHVzaW5nIHRoZSBz
YW1lIHBvbGxpbmcgcGVyaW9kLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IENhbiBHdW8uDQo+
IA0KPiA+ICsgICAgICAgICAgICAgbGlzdF9kZWxfaW5pdCgmcmduLT5saXN0X2V4cGlyZWRfcmdu
KTsNCj4gPiArICAgICAgICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZocGItPnJzcF9saXN0X2xv
Y2ssIGZsYWdzKTsNCj4gPiArICAgICAgICAgICAgIHVmc2hwYl91cGRhdGVfaW5hY3RpdmVfaW5m
byhocGIsIHJnbi0+cmduX2lkeCk7DQo+ID4gKyAgICAgICAgICAgICBocGItPnN0YXRzLnJiX2lu
YWN0aXZlX2NudCsrOw0KPiA+ICsgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
aHBiLT5yc3BfbGlzdF9sb2NrLCBmbGFncyk7DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAg
ICB1ZnNocGJfa2lja19tYXBfd29yayhocGIpOw0KPiA+ICsNCj4gPiArICAgICBzY2hlZHVsZV9k
ZWxheWVkX3dvcmsoJmhwYi0+dWZzaHBiX3JlYWRfdG9fd29yaywNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbXNlY3NfdG9famlmZmllcyhQT0xMSU5HX0lOVEVSVkFMX01TKSk7DQo+
ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyB2b2lkIHVmc2hwYl9hZGRfbHJ1X2luZm8oc3RydWN0
IHZpY3RpbV9zZWxlY3RfaW5mbyAqbHJ1X2luZm8sDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJnbikNCj4gPiAgew0KPiA+ICAgICAgIHJn
bi0+cmduX3N0YXRlID0gSFBCX1JHTl9BQ1RJVkU7DQo+ID4gICAgICAgbGlzdF9hZGRfdGFpbCgm
cmduLT5saXN0X2xydV9yZ24sICZscnVfaW5mby0+bGhfbHJ1X3Jnbik7DQo+ID4gICAgICAgYXRv
bWljX2luYygmbHJ1X2luZm8tPmFjdGl2ZV9jbnQpOw0KPiA+ICsgICAgIGlmIChyZ24tPmhwYi0+
aXNfaGNtKSB7DQo+ID4gKyAgICAgICAgICAgICByZ24tPnJlYWRfdGltZW91dCA9IGt0aW1lX2Fk
ZF9tcyhrdGltZV9nZXQoKSwgUkVBRF9UT19NUyk7DQo+ID4gKyAgICAgICAgICAgICByZ24tPnJl
YWRfdGltZW91dF9leHBpcmllcyA9IFJFQURfVE9fRVhQSVJJRVM7DQo+ID4gKyAgICAgfQ0KPiA+
ICB9DQo+ID4NCj4gPiAgc3RhdGljIHZvaWQgdWZzaHBiX2hpdF9scnVfaW5mbyhzdHJ1Y3Qgdmlj
dGltX3NlbGVjdF9pbmZvICpscnVfaW5mbywNCj4gPiBAQCAtMTgxMyw2ICsxODY1LDcgQEAgc3Rh
dGljIGludCB1ZnNocGJfYWxsb2NfcmVnaW9uX3RibChzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEs
IHN0cnVjdCB1ZnNocGJfbHUgKmhwYikNCj4gPg0KPiA+ICAgICAgICAgICAgICAgSU5JVF9MSVNU
X0hFQUQoJnJnbi0+bGlzdF9pbmFjdF9yZ24pOw0KPiA+ICAgICAgICAgICAgICAgSU5JVF9MSVNU
X0hFQUQoJnJnbi0+bGlzdF9scnVfcmduKTsNCj4gPiArICAgICAgICAgICAgIElOSVRfTElTVF9I
RUFEKCZyZ24tPmxpc3RfZXhwaXJlZF9yZ24pOw0KPiA+DQo+ID4gICAgICAgICAgICAgICBpZiAo
cmduX2lkeCA9PSBocGItPnJnbnNfcGVyX2x1IC0gMSkgew0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICBzcmduX2NudCA9ICgoaHBiLT5zcmduc19wZXJfbHUgLSAxKSAlDQo+ID4gQEAgLTE4MzQs
NiArMTg4Nyw3IEBAIHN0YXRpYyBpbnQgdWZzaHBiX2FsbG9jX3JlZ2lvbl90Ymwoc3RydWN0DQo+
ID4gdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpDQo+ID4gICAgICAgICAgICAg
ICB9DQo+ID4NCj4gPiAgICAgICAgICAgICAgIHJnbi0+cmduX2ZsYWdzID0gMDsNCj4gPiArICAg
ICAgICAgICAgIHJnbi0+aHBiID0gaHBiOw0KPiA+ICAgICAgIH0NCj4gPg0KPiA+ICAgICAgIHJl
dHVybiAwOw0KPiA+IEBAIC0yMDUzLDYgKzIxMDcsOCBAQCBzdGF0aWMgaW50IHVmc2hwYl9sdV9o
cGJfaW5pdChzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEsIHN0cnVjdCB1ZnNocGJfbHUgKmhwYikN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICB1ZnNocGJfbm9ybWFsaXphdGlvbl93b3JrX2hh
bmRsZXIpOw0KPiA+ICAgICAgICAgICAgICAgSU5JVF9XT1JLKCZocGItPnVmc2hwYl9sdW5fcmVz
ZXRfd29yaywNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICB1ZnNocGJfcmVzZXRfd29ya19o
YW5kbGVyKTsNCj4gPiArICAgICAgICAgICAgIElOSVRfREVMQVlFRF9XT1JLKCZocGItPnVmc2hw
Yl9yZWFkX3RvX3dvcmssDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1ZnNo
cGJfcmVhZF90b19oYW5kbGVyKTsNCj4gPiAgICAgICB9DQo+ID4NCj4gPiAgICAgICBocGItPm1h
cF9yZXFfY2FjaGUgPSBrbWVtX2NhY2hlX2NyZWF0ZSgidWZzaHBiX3JlcV9jYWNoZSIsDQo+ID4g
QEAgLTIwODcsNiArMjE0MywxMCBAQCBzdGF0aWMgaW50IHVmc2hwYl9sdV9ocGJfaW5pdChzdHJ1
Y3QgdWZzX2hiYQ0KPiA+ICpoYmEsIHN0cnVjdCB1ZnNocGJfbHUgKmhwYikNCj4gPiAgICAgICB1
ZnNocGJfc3RhdF9pbml0KGhwYik7DQo+ID4gICAgICAgdWZzaHBiX3BhcmFtX2luaXQoaHBiKTsN
Cj4gPg0KPiA+ICsgICAgIGlmIChocGItPmlzX2hjbSkNCj4gPiArICAgICAgICAgICAgIHNjaGVk
dWxlX2RlbGF5ZWRfd29yaygmaHBiLT51ZnNocGJfcmVhZF90b193b3JrLA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1zZWNzX3RvX2ppZmZpZXMoUE9MTElOR19JTlRF
UlZBTF9NUykpOw0KPiA+ICsNCj4gPiAgICAgICByZXR1cm4gMDsNCj4gPg0KPiA+ICByZWxlYXNl
X3ByZV9yZXFfbWVtcG9vbDoNCj4gPiBAQCAtMjE1NCw2ICsyMjE0LDcgQEAgc3RhdGljIHZvaWQg
dWZzaHBiX2Rpc2NhcmRfcnNwX2xpc3RzKHN0cnVjdA0KPiA+IHVmc2hwYl9sdSAqaHBiKQ0KPiA+
ICBzdGF0aWMgdm9pZCB1ZnNocGJfY2FuY2VsX2pvYnMoc3RydWN0IHVmc2hwYl9sdSAqaHBiKQ0K
PiA+ICB7DQo+ID4gICAgICAgaWYgKGhwYi0+aXNfaGNtKSB7DQo+ID4gKyAgICAgICAgICAgICBj
YW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmhwYi0+dWZzaHBiX3JlYWRfdG9fd29yayk7DQo+ID4g
ICAgICAgICAgICAgICBjYW5jZWxfd29ya19zeW5jKCZocGItPnVmc2hwYl9sdW5fcmVzZXRfd29y
ayk7DQo+ID4gICAgICAgICAgICAgICBjYW5jZWxfd29ya19zeW5jKCZocGItPnVmc2hwYl9ub3Jt
YWxpemF0aW9uX3dvcmspOw0KPiA+ICAgICAgIH0NCj4gPiBAQCAtMjI2NCw2ICsyMzI1LDEwIEBA
IHZvaWQgdWZzaHBiX3Jlc3VtZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICBjb250aW51ZTsNCj4gPiAgICAgICAgICAgICAgIHVmc2hwYl9zZXRfc3RhdGUo
aHBiLCBIUEJfUFJFU0VOVCk7DQo+ID4gICAgICAgICAgICAgICB1ZnNocGJfa2lja19tYXBfd29y
ayhocGIpOw0KPiA+ICsgICAgICAgICAgICAgaWYgKGhwYi0+aXNfaGNtKQ0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICBzY2hlZHVsZV9kZWxheWVkX3dvcmsoJmhwYi0+dWZzaHBiX3JlYWRfdG9f
d29yaywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtc2Vjc190b19qaWZmaWVz
KFBPTExJTkdfSU5URVJWQUxfTVMpKTsNCj4gPiArDQo+ID4gICAgICAgfQ0KPiA+ICB9DQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuaCBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaHBiLmgNCj4gPiBpbmRleCAzN2MxYjBlYTBjMGEuLmI0OWU5YTM0MjY3ZiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5oDQo+ID4gKysrIGIvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNocGIuaA0KPiA+IEBAIC0xMDksNiArMTA5LDcgQEAgc3RydWN0IHVmc2hw
Yl9zdWJyZWdpb24gew0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0cnVjdCB1ZnNocGJfcmVnaW9uIHsN
Cj4gPiArICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGI7DQo+ID4gICAgICAgc3RydWN0IHVmc2hw
Yl9zdWJyZWdpb24gKnNyZ25fdGJsOw0KPiA+ICAgICAgIGVudW0gSFBCX1JHTl9TVEFURSByZ25f
c3RhdGU7DQo+ID4gICAgICAgaW50IHJnbl9pZHg7DQo+ID4gQEAgLTEyNiw2ICsxMjcsMTAgQEAg
c3RydWN0IHVmc2hwYl9yZWdpb24gew0KPiA+ICAgICAgIC8qIHJlZ2lvbiByZWFkcyAtIGZvciBo
b3N0IG1vZGUgKi8NCj4gPiAgICAgICBzcGlubG9ja190IHJnbl9sb2NrOw0KPiA+ICAgICAgIHVu
c2lnbmVkIGludCByZWFkczsNCj4gPiArICAgICAvKiByZWdpb24gImNvbGQiIHRpbWVyIC0gZm9y
IGhvc3QgbW9kZSAqLw0KPiA+ICsgICAgIGt0aW1lX3QgcmVhZF90aW1lb3V0Ow0KPiA+ICsgICAg
IHVuc2lnbmVkIGludCByZWFkX3RpbWVvdXRfZXhwaXJpZXM7DQo+ID4gKyAgICAgc3RydWN0IGxp
c3RfaGVhZCBsaXN0X2V4cGlyZWRfcmduOw0KPiA+ICB9Ow0KPiA+DQo+ID4gICNkZWZpbmUgZm9y
X2VhY2hfc3ViX3JlZ2lvbihyZ24sIGksIHNyZ24pICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gPiBAQCAtMjE5LDYgKzIyNCw3IEBAIHN0cnVjdCB1ZnNocGJfbHUgew0KPiA+ICAgICAg
IHN0cnVjdCB2aWN0aW1fc2VsZWN0X2luZm8gbHJ1X2luZm87DQo+ID4gICAgICAgc3RydWN0IHdv
cmtfc3RydWN0IHVmc2hwYl9ub3JtYWxpemF0aW9uX3dvcms7DQo+ID4gICAgICAgc3RydWN0IHdv
cmtfc3RydWN0IHVmc2hwYl9sdW5fcmVzZXRfd29yazsNCj4gPiArICAgICBzdHJ1Y3QgZGVsYXll
ZF93b3JrIHVmc2hwYl9yZWFkX3RvX3dvcms7DQo+ID4NCj4gPiAgICAgICAvKiBwaW5uZWQgcmVn
aW9uIGluZm9ybWF0aW9uICovDQo+ID4gICAgICAgdTMyIGx1X3Bpbm5lZF9zdGFydDsNCg==
