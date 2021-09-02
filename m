Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72163C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41BEA610CD
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbhIBGZc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 02:25:32 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18021 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhIBGZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 02:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630563873; x=1662099873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tcxDLe8b0Mx7KKqYQGY89tpdyxQB93L5wBgIDwBMWCA=;
  b=OrcMZodmk3AjYGOcvo9u3cWi1a+Y1ybFc4oLNPzGhANMBw6x4Zt0dmNx
   qoDEaDth6cEyCOrvm1ACbEeRVqwZts+7XDk3ejqQJQO4QZV1qo6mdvGC8
   igZ5A3HmqTtv/IhIwOPRhhppB5+1w3ak0D9h3fvr9yX5GlJmKiYGmJlLx
   Wic3uoqgLHR/ckdGZVgWME7XlvJjZZHDsi9ekfAxYat0IMTG+f4mc4Yk1
   lP4AwxV3tcTT8PSohcGBAUFc2fhbp1ncQ/z5Tm82+Kl6dZzbOeaEN7U/U
   zob/iN/Lg02/GOQVD/NAL4hIZB+sTk0xP71IDClgKhYe3cp444+oEMX/T
   g==;
X-IronPort-AV: E=Sophos;i="5.84,371,1620662400"; 
   d="scan'208";a="179019430"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 02 Sep 2021 14:24:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhZHHndMsdDCWmV5fkicBHg8+iXN7SUrm5jT+2fVqV58V4ZGbZLClIJa7gByg9WKPDrcKKgTXxpOMRMwnYyAejwFfN+p2UcDeuNac3Xkat8hFWLFGcorRVvlJrrSoyFniQKzxIcbuS4qB3La5W19W1JO6kkgGaRdJ8IcyHweteZgZYqex52Ei4XJgl8bB6X+0eHYyQLZ1qQXhR7Md164+uLZIc4EpyXYNqqNDvQMU9DdAlecuPG0xSwLVVd3F1FbJQeGpmSfFC+hItOSfF/1iDd0KaWMdT3HGPKu3X6uM55GlEzxKXz0OsWt3ljfboPBCvqwIaZv37a7a4uVicl9GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcxDLe8b0Mx7KKqYQGY89tpdyxQB93L5wBgIDwBMWCA=;
 b=PhQwwVihwOfpACqaIDrue3+/i0PRi47B7eXv6SRHo4/o7wrMkAe2gwUOLwwRYcK8n9wCmGVViNJK1gSwOR4euTh3+gxEH5xaXUPo0vXlFSh8KTEPkfk595ar7JnfsD4kreOIJRT57nBRfPOJSY7RVdzwYPvaxK7BUoIACVF9LljbVp0FAUxgkrorzOu6Ox9oVfVXh6JePYvbnSKRGTLnHzK2JAZj15LpZmLcxlVbbCDYq4EC60XNTlRXx50DKCZtHsCJ4AhBAPs19sYFdY6gzxyBpKXqklDitAMBDsHpUTvz4Vk2HylLF0bule4j3Ze30XFqQGeAoMydWd76S0kSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcxDLe8b0Mx7KKqYQGY89tpdyxQB93L5wBgIDwBMWCA=;
 b=NKxWPa+Z4Oi0ctbAaV6ocfr74Ev21LkApHH3fQkvIhuHlvBVIItPlZoyzU+aeKdV03hkjCMUvDgrcHbTjO8Bgd6LAwM/GOcE6qgIU8+GgATVHIjJSaqCCzqU2hmBq4A3kmow8syCVPdU1VYbsWe7p18VQt1v5uufIqSRYC3gBhc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.24; Thu, 2 Sep 2021 06:24:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 06:24:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH 1/3] scsi: ufs: Probe for temperature notification support
Thread-Topic: [PATCH 1/3] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXny5AaGMM6U/4T0K5x2WLdIWlequPYFYAgADnj1A=
Date:   Thu, 2 Sep 2021 06:24:31 +0000
Message-ID: <DM6PR04MB6575AB717CEA9D2C126A64CAFCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-2-avri.altman@wdc.com>
 <035fad25-1b0d-c8ba-896f-eae2bd2144e3@acm.org>
In-Reply-To: <035fad25-1b0d-c8ba-896f-eae2bd2144e3@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b120419d-04a3-40c7-8ade-08d96dda536d
x-ms-traffictypediagnostic: DM6PR04MB6575:
x-microsoft-antispam-prvs: <DM6PR04MB6575CB1457BDA952FA3CABC5FCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bhMQpRDSMO/Peb//v1naDeqDgwZPZjAYGj/DWdW+C0aSXZKlh9LIXqxuFxRii4h8pz2bvPvL2yEBPDh2m3qSJmzEtVjIW+Xn2y1N2DcX28hEzN7qC6bkH5vYwhGcpBYsBet+0fKfGhqp6+Dwh66sQhPZlpOoLGiqT7nuEbDP521yYbYpB2BJMgJwvejDrxnhpFLuhsdrHGOBsJQ+IG7nnLVS8JEV8TjDg/ix58Rnau6ZH0rsxHYmKfe7GTw6VJbO0o9RHhvhHGNAo2eye48JXblHLl+wtkh4R9jDMlfkuGtDwsqB/KJxV3qk0w99OJcxD3qYBOZN0jrvab72xmdKpojP9J0sTruuJzBABjVOAGqrR+BWgugEbkhQ6W1JVPinwkJ5srHW/hgvosZtaUeqvHiQc+/Go5CfpGSB1xu2vxsAuooYTFwG3P5GXzd5xR8n+Het4iFFnKU8F/0THRj/y+X44LW0n5Q8fk1Zf5A5rvpJOGbJeSw2qzxYMIahNnX3IiHAmKqVW4dW/EYcKF33C8eVa6H/SPm5SpGmD+7izvB1sGGTnbDFv6GvmL2JPk1J1ISq9XGMU3opMvV9+VRf61lmzdFNVP2VwhPrLih+/gqzI+q7s0fMTliH30zbO977yyXv+9nT6/np7VVtVzanwyNhBWDyIl/u/Oz8ORvNznDQ2GFrnuwyfEClwwtbIoRko0asjR6t+8AtbtqIVxVPwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(8676002)(7696005)(33656002)(38100700002)(4744005)(9686003)(52536014)(8936002)(122000001)(38070700005)(86362001)(5660300002)(478600001)(66946007)(66476007)(55016002)(71200400001)(26005)(53546011)(54906003)(186003)(316002)(76116006)(6506007)(2906002)(4326008)(110136005)(64756008)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWozbE9PV3ZaOEd0MzFaUEZ6WmNRSXdjL3QwMzJSV2lzUnNmcVlaeE8zYU5H?=
 =?utf-8?B?U2NXME5vU3RvRnZab1NEV1F6SzJ2WWpNVkczNWw3OVVKcmxscU4raDY4ZkJE?=
 =?utf-8?B?eVpiZHJSUlhKbFd2RVY0YWFtME5iaVF3QnNtSnRTbUFYSzZ6ajFVTWRvZ2R1?=
 =?utf-8?B?ZXkvbGJNc3ROaW9mTFRJazlWclYrZ2d2Nkw2Vm9KbXMxNEMrN0xuTWxubzd2?=
 =?utf-8?B?T2thVUQzaGJ0dnFYd3pSbVlFZERhQjVxY2VuS05OaDlIT0lpbXUzQWxOTlNQ?=
 =?utf-8?B?YzRnalNOQVNjWnhrVERlWHFPQ1JsODlDYjRoaVpOYUhlcmJKQnI3Nis2MXhv?=
 =?utf-8?B?Z3dEZGMrcHo2OFROM2ZtcjcwTDJKeVpjTVFjSGVhNS9HYkhTakZoNHNyY00y?=
 =?utf-8?B?VDdoRTVoRGpnQWpTY1pJRXUwSm1lbHRuVHFIYkk4c0hhb0RIVHRLUW5EaHBD?=
 =?utf-8?B?RFdaandyWloxZ0NaR2pUbDFxL2MvREhnMnh3dTJNVDZmcWpqZ2paNUlsMUN5?=
 =?utf-8?B?RzVBZmVDOGZlcStPRWRXRGhtSm1lcHRGSlEyenFoUDdIN3VQbU5WSWd6NlZY?=
 =?utf-8?B?UGZaRVRoYUFPS0Z1R0Z3aEdZNGEwZXYwV2xUelp6YmVLaktPS0N1NXZjTlV0?=
 =?utf-8?B?R1NnU09ra3ZoNFM1eGZnRUtSeHBEc0pUTS9lc1FWWDNTUTRjY2NCbVZUTndM?=
 =?utf-8?B?SnhwUmhuaVA5dXRTRG0zNHlPMzhSamwvTVVzQkFMQ05RL1B0eXFacTd6UmFL?=
 =?utf-8?B?amgrNTVoTkg3NVVQRHJNSG1yVUlQVUk1SnM4UHd0a2VqWUxQQmJhOWdZRFNX?=
 =?utf-8?B?MWh4bVdKb2s4OS9iMkJ5WWtHM0lDNXR5enhkVWtub01lSkxxUmV0d1VRWmpl?=
 =?utf-8?B?dStINXlxNVNZblIzMms1MGU4TjdBcW83eHlIYlVFaGhheCt5NHkrS3VEOU9Q?=
 =?utf-8?B?dnpOK3dYTXlQZ09USXRmVzVGZXB0MC96TDNaMmxaYnc5b3lVb2JsK0RHV00y?=
 =?utf-8?B?MWFNd0xiWThvak9RcS9pZCtGK1hVRTlUTW5sTFNMazdhdThISTBGbHlvRFk2?=
 =?utf-8?B?VEtlVE5oTitONERDVW1JZTEyRHVmN1VLVkd3VWp6TTZrb0dvLzRlTGJ1a2R5?=
 =?utf-8?B?NFpURmVRTjBhUlV6MGdwWUptRWE0dWM2SGJycTJ2SUQ3WmRRa3FTVU5nY2Rh?=
 =?utf-8?B?MWdRY0Ftc3YyTE0xL0VSUmJnOTVwK2dIQXpLTEJUV2lyc0k1aXgyQ0g4ekdV?=
 =?utf-8?B?d0dybDlFZmVwOXo0WFhiNkN0eVh3MGRUQXpFUCtRNDl5SWs2by85am05TW5y?=
 =?utf-8?B?UWlhdHFzNEsxeHJiWm9FKzA5NHVraGZVSXJtdVZwWWtKd1FBRG9pU0pLTWlt?=
 =?utf-8?B?Ym9qcDhRejMvTkhEd3pMbEZReXZEbnAwUmZycGVvZjFFc2o2Ky9ER3djdUFY?=
 =?utf-8?B?UGxyemZVYUFwazM3MTVCWWdPa1YxcCtteDJSK3BVdm1jcUw0cHA4OHdaWGI2?=
 =?utf-8?B?bVVablZjN0NJWmV5bUhQOFc1R3h0MDJyV0c5WCtBd0dCQ2pNc1hhVk9DRU9i?=
 =?utf-8?B?a0xsOFdpRkJKVnNCKzFGK0xBeCtHa01DL0kzMWVxd1RaczVFclJJUmJRYkty?=
 =?utf-8?B?Tm1VYnhnam5QTlM1d2VpS3R3TFg1ZnJaa1RTZGoxeDhwaUUyWVl5SXEzeTRN?=
 =?utf-8?B?Q1d2Wi9LWmlZZDdrcUFkVUJYa0dTRm9SR3BER1VsZlJOdHh4bFEvL2pCTDRy?=
 =?utf-8?Q?zeYlp/bplFGh0niN7ZrunX7cyLQHavBP8NtEIvM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b120419d-04a3-40c7-8ade-08d96dda536d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 06:24:31.8397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lra8Xn58GNF5vAtWvnfk3IrmzYcXMrpBS7jn/cLnitXG9kHdOce9V8iN+MUsWDsQrFAbpRhBAJZeeF9U0is2CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6575
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gOS8xLzIxIDU6MzcgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ICtzdGF0aWMg
aW5saW5lIGJvb2wgdWZzaGNkX2lzX2hpZ2hfdGVtcF9ub3RpZl9hbGxvd2VkKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQo+ID4gK3sNCj4gPiArICAgICByZXR1cm4gaGJhLT5kZXZfaW5mby5oaWdoX3Rl
bXBfbm90aWY7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgYm9vbCB1ZnNoY2Rf
aXNfbG93X3RlbXBfbm90aWZfYWxsb3dlZChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICt7DQo+
ID4gKyAgICAgcmV0dXJuIGhiYS0+ZGV2X2luZm8ubG93X3RlbXBfbm90aWY7DQo+ID4gK30NCj4g
DQo+IFBsZWFzZSBkbyBub3QgaW50cm9kdWNlIHNpbmdsZSBsaW5lIGlubGluZSBmdW5jdGlvbnMu
DQpEb25lLg0KDQo+IA0KPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wgdWZzaGNkX2lzX3RlbXBfbm90
aWZfYWxsb3dlZChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICt7DQo+ID4gKyAgICAgcmV0dXJu
IHVmc2hjZF9pc19oaWdoX3RlbXBfbm90aWZfYWxsb3dlZChoYmEpIHx8DQo+ID4gKyAgICAgICAg
ICAgIHVmc2hjZF9pc19oaWdoX3RlbXBfbm90aWZfYWxsb3dlZChoYmEpOw0KPiA+ICt9DQo+IA0K
PiBTaW5jZSB0aGlzIGZ1bmN0aW9uIGlzIG5vdCBpbiBhbnkgaG90IHBhdGggKGNvbW1hbmQgcHJv
Y2Vzc2luZyksDQo+IHNob3VsZG4ndCBpdCBiZSBtb3ZlZCBpbnRvIHVmc2hjZC5jPw0KRG9uZS4N
Cg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
