Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234FBC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 10:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D322E61175
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 10:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhDHK1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 06:27:03 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:34270 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhDHK1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 06:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617877609; x=1649413609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XBFm5M/TJNQfV2MBScKOroGizszLFLS5QsKKmMD6k1Y=;
  b=hAeBEGGn+49o4It5D2AqzGxxBRTeC6/kJZgl/1remJpbpx1oDSXszSNW
   qCg1srx9LKNkrnfPoRLJjsTAFMq94iGDvAUxz33CJkXupeTG/3B3jEYKB
   ltxdX5zHK5p2PgiCWAldPnvPYrzejaWa7hbAYJLrwCZe1RGovqnaHlhF5
   P/Zok6PkuWqAwjscDojR+Oi4/P8yyU0X7DEOGP3LYFwaYxnE8563JpeJl
   F+C7hT5Ciu0Ds0uDxnPxRWHT3YIclL0k9JKRyk/7KJ4g91PabMR9yYAkx
   aeWwSPyYFpFm9f9+DFtH1c6L5qlTnplR5oXEw6nV0yOMz0SIO9b2BZZaY
   g==;
IronPort-SDR: SXoQgBhMvrfd/80cdRYsd1fY1XpQB2ZGGZ8ppphYOHFznQ1h0NyWp79fn+bpY4WLWK4b1IClRT
 p+gnGVmok3NhperDcFELyv03lBxE8/ON8jJMz7XSU7PfPUk2OzouMT7fhlVgCzNFco53HCUM59
 wCnL19xbHTRWEj9S7b6mMpWuXa+66vCtkhggvWjskF+Lk9Ij+6sSQi9/NMPPQZsAGhDcEXDyi6
 avxZd2W27FPRcHxq/lTC25FcVeLeeh83CK5d7ktMUywiD6R0i98PnVAPizZlFZ3cBi1m19mA38
 Lf0=
X-IronPort-AV: E=Sophos;i="5.82,206,1613404800"; 
   d="scan'208";a="163908798"
Received: from mail-bl2nam02lp2054.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.54])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2021 18:25:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEHnJevQ7/QACjlbQX/0mPqTupCbvQg+YFNyUgh+1IWI6/q7k+FHCfIhqdHD/x9T8T4PujRRQE+rlrXo6ItNA46vJrONkna77Z8ezVK2QpsOpibXUjSECbCzHr36LXPuWvzWD3A92BsOCzCgcTwjtLNJ+PzzKAnoKKuc0A8jlAZvZRgi9A3ucC7NM5mwZ6Y8u2CkVQASaO/JWbVy7E8ZqCFfPlHkx4nwaJqEPzPkpN/ar46AFgGcko4Fl8BreKhFUJ/ZgEjnWvgVrkjkeBmMEQnOu6JXxBllmk21qBYWmqJaPnP+Yely/zBmsXstu8zoPAZ0w/M/vEnk24kDOe0Cjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBFm5M/TJNQfV2MBScKOroGizszLFLS5QsKKmMD6k1Y=;
 b=UVMyMD4kCzhXsbHzvQchLD2arX0+t5MKbslOhUPZeYvTlo9LxUJFNVqjWb1dsVz84aTHr5C41CnLwLMc9mjJXPIo954VMv3gMjMacK+j6HJS1QaRn3nGEzlmlRkdDiq9NUbQxbeSFceQQ4vwTQB95RXbBAbIkDNRAJp/XHyKOvDa1iq+QpEmAxiBKiBzUen/2z9VsQW3k2uN5rCNTOrSuGnMKPJSDlTchzoiKCE5zHHPEb6wLmdNM56UixDtwuCcw7z3jSbKiaLFVcUrceVt+yS0C1fd3IGXdOX1en5mbd4nYCbVdoKlCMn6hM9xFSg1bjKLqGoFuI62bQEUI/AH8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBFm5M/TJNQfV2MBScKOroGizszLFLS5QsKKmMD6k1Y=;
 b=bX1W18mENEeBEXXA0CRXkf1g7wEu0AhAHEM21d6D20Wj+2v78rKWBLRGXnVXXTQArFWnFIRpf0f9COH30CLycosJP7E1mTtoUHdQiOkd9gQLnCCvUGh5RmNhOVneKJXRPiE1TT/5CxX33Fu2dEZdSu+3QbscQe0x2DB1OZ+pcsY=
Received: from BY5PR04MB6327.namprd04.prod.outlook.com (2603:10b6:a03:1e8::20)
 by BYAPR04MB5573.namprd04.prod.outlook.com (2603:10b6:a03:e2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 8 Apr
 2021 10:25:13 +0000
Received: from BY5PR04MB6327.namprd04.prod.outlook.com
 ([fe80::8187:86ea:b371:58f2]) by BY5PR04MB6327.namprd04.prod.outlook.com
 ([fe80::8187:86ea:b371:58f2%6]) with mapi id 15.20.4020.016; Thu, 8 Apr 2021
 10:25:13 +0000
From:   Arthur Simchaev <Arthur.Simchaev@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw data
Thread-Topic: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw
 data
Thread-Index: AQHXA8HGKUtY27DSkEKVXm/ukaBroqqHtGuAgCMF6qA=
Date:   Thu, 8 Apr 2021 10:25:13 +0000
Message-ID: <BY5PR04MB632750DA310BEBF92DB80908ED749@BY5PR04MB6327.namprd04.prod.outlook.com>
References: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
 <9ade874b-b69e-615d-b101-2ecc664ba64d@acm.org>
In-Reply-To: <9ade874b-b69e-615d-b101-2ecc664ba64d@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.11.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc03de7e-29d5-4944-5d80-08d8fa78986a
x-ms-traffictypediagnostic: BYAPR04MB5573:
x-microsoft-antispam-prvs: <BYAPR04MB5573640403546DD8B29AAF8DED749@BYAPR04MB5573.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pr/0JYuzsewmgNep1olbLsgFkLKxr1D6Fzqu1jXyg4oYhSzUxIpMf93U+N4qXIGEnGkrJkSOqNiPLVYZklOM99gCg0ZoPhAfbLekSzEkbNNZ3cwXcDOsKc9FckzHfkhe41q8XOMaQ/JX/ds6wqxOC08XgMQWYHKSrGvX+xmRsFnRi3SwqYNcEvU8WgClbMINyiqXem0RXmeos5iYKdu+QbugR1J+wzRQBK2RdmYXwCLWo6WDRzP4a9zZde159DRorJ1vy9q09lHtM0AdLSl22RxwbOIDiWgvE2ObptJafcyO/l0B9bD3F0jcG3DS5H7FYTHfpQbfWV1goSKFXk1sLgFSr5tVxW6Wt446TX0J/YOiULDzeCigj7aSAPibeQQz2p3YPHNeXuUdi7s+ft+FEUUpnB17x2tPm3my5OS3OSqf+X93T8wdqEanoGvfNV+LAK3+ZWLy5asHi05gefY+Igu+u73ilczqdfQEevrmmadNnA0COEZ9T1k54MIvrANaVtgqIcgpgutn/98JWay40qzQStZ7/DMs11lhpIfMZ2s4FjbfWsVFPffzaREaksH9gk9w4SSynfUsgvq+YL8MnUPLiWBI3FKNnxLcWsRo9nUyYdXdsixFu4DOXl9OwGFQl5JLOeWjiDG98eTgMsi/sBu+TKiUeqdxNv36mFAMbQ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6327.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(55016002)(33656002)(186003)(4326008)(83380400001)(8936002)(86362001)(110136005)(316002)(54906003)(7696005)(8676002)(5660300002)(53546011)(9686003)(52536014)(76116006)(478600001)(6506007)(71200400001)(64756008)(38100700001)(26005)(2906002)(66446008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SUNlMjNzUmg2WEpTcjFKdnJMWCtqMTBrNDFhUXh5VWZKYzJwVEJnOG44UWRW?=
 =?utf-8?B?Y2xvTnU2MnA4UXltbkZrcFJvd0djbE9iNTQyWk4xUmNibFRwZFFvQm81R3B1?=
 =?utf-8?B?ckpNZCtqUCsrdlI1RHU2Nk5mWEMxWWlqd2NMVEZhZUV0a05GMkViWHkyRVdz?=
 =?utf-8?B?TFIwekU0d2RXMXlXQTVuTFB4OFRxQm5xVnBkaEFtU0VnS252aG9SRmtDeXRF?=
 =?utf-8?B?dm5GOEVGT2VJVjFrY2FlcE1nNy85ZFIvQVRFK3c0NkUyVEo3b3ltNFg0MHFw?=
 =?utf-8?B?K3RoOGFDR2hvNUJYMjJQb2xMTUh1ZityQ3djVW9WOEJiYXcxNG96ckRNbG9p?=
 =?utf-8?B?azRobUhUamR3UysyNnFoYStnTGtoTEtGNkZ0OUhNMG5UWjR5R1IxOTZmUHlF?=
 =?utf-8?B?ZHQraWM0RklpbFFWK2hSdGE1TWg2bGU5MGcwWTdDaGhzUlRBc3I2Sy8xQm9k?=
 =?utf-8?B?aFBnUWMzcDhKd3J2aVlIN0hIRU5TYm1mZTlkYXpDc2tEdytiN0xyZkVYYWkx?=
 =?utf-8?B?RXZtSGNzN1A3V0dlZ3lha056MW1kT1FLczVsQXNTRDQxaGFscThHV0xya2di?=
 =?utf-8?B?a2RmN1N1OUNDU2lDS1Rkdjg0SU9zbDR5cTEwbjRJRGdEd1NKMFVaNi9ZL3ps?=
 =?utf-8?B?WU5acjU5RkRwQlNMN0owams3ajV0VVI4aDZGdVJJSGNNK3N1N1QzRmdONHZy?=
 =?utf-8?B?WXlQVFBKN0lBL3YraW9LUHBaMFd3ajh1S0JCNC9yK0xGQ3ZsN1V2QlNqeTRa?=
 =?utf-8?B?YmZZTDdLM3lMSG81ZytwZE1EL08yZlZqUmNuM1hlWEhZZnltNmhkODFhTURT?=
 =?utf-8?B?VmtjbjVIbmt3QTZxVTZxK0ZRU01Xc0JNV3Z1R2RoSVJtL3ZjVGZ1cDBWVGxX?=
 =?utf-8?B?SmRDSlN1c01BSCs4bS9rNWhxb0xBTUpBNVRnbS9SZlYwT05pR2FKWXZ0Lzd1?=
 =?utf-8?B?WENPK2ExcGVPbmY4QXA5UnRObWkrUXIxemJDLzNFMUlkcXphRGMxMXAvTGth?=
 =?utf-8?B?dFVkRHoyNEtrNG4wVDhsOFRMd05tc0xuMGRJMWtIeVBHQUkzc0F2aHV4T1J6?=
 =?utf-8?B?b1pYeGdJcjMzVDBaNVpVdldydFBsN0NZTHJVVmtxVWRuRFpkSE05ZnRCbVdJ?=
 =?utf-8?B?a2JnSXBBbmV2dmQ0RmRsNTlDUWJma3R4MUlnaFRqL1hyY2ZYemxBVkpkd2FG?=
 =?utf-8?B?WlNwNVJuQkpIVmtmb3RUSzNiTXRBeUFteURzb29XZWdLUGp1c0lMMzBPYVg1?=
 =?utf-8?B?VmY1UnkzWTFFNjNtbStJSnJwQ1M0M3R5QURCYjl1aXN3TjJYcXFhNGgrcmRh?=
 =?utf-8?B?Q0M3MGEzWmp1RlM0c1ZrNlNJdHZTTktBZmw5OHZlZ25rYnJwUjdIaUd1ZnR3?=
 =?utf-8?B?ZmFkQ01OVnhhTmFkYnFBVmhqTnJ3Nks2WXEybDBja21WYVkzSnpiUFRaQU41?=
 =?utf-8?B?S25JbU5jaVJudXdVd2wrVzlKY2xRMjZHbXB2L0V0Znp5SkUxQVhjNnUwQU5V?=
 =?utf-8?B?UlhNclB0YzZ3ZXEvc1hPMFF0ZGU2NXlQdGR5WWUzUm93aVE2aEx6MTRJVUps?=
 =?utf-8?B?SDNpOWZOR0hoaDNoUFZFcWd1T3d5RFo5cnYyQkhIR1RROSt6MTRXMUE3UE9X?=
 =?utf-8?B?K3lXT1Z0K0trWndZUVBWakU1dmZDUFg1aGd1UGRCbG9sVldqeWVFM2FOYXIw?=
 =?utf-8?B?d01YNFRWUjJSOG1mTDlHd2RxN25EZVNabTcrQUxNV05mUHNzbCs4S1hUQm1q?=
 =?utf-8?Q?W7oPkVyGcZH/BixxDEpEyBJjRKnSNyFYwNQ788u?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6327.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc03de7e-29d5-4944-5d80-08d8fa78986a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 10:25:13.1663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lM/8lZCybzb5+CXwYpvIaS4uDD0Oz+IjrZk0Bwh1xt+ihPcEH2hCObI8hldyik8nD/xzPdVRAC1LsHtaPu9wNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5573
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnQgVmFuIEFzc2NoZSA8
YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDE3LCAyMDIxIDU6
MzEgQU0NCj4gVG86IEFydGh1ciBTaW1jaGFldiA8QXJ0aHVyLlNpbWNoYWV2QHdkYy5jb20+OyBK
YW1lcyBFIC4gSiAuIEJvdHRvbWxleQ0KPiA8amVqYkBsaW51eC52bmV0LmlibS5jb20+OyBNYXJ0
aW4gSyAuIFBldGVyc2VuDQo+IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47IGxpbnV4LXNj
c2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBD
YzogYWxpbS5ha2h0YXJAc2Ftc3VuZy5jb207IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIHNjc2k6IHVmczogc3lzZnM6IFByaW50IHN0cmlu
ZyBkZXNjcmlwdG9ycyBhcyByYXcgZGF0YQ0KPiANCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmln
aW5hdGVkIGZyb20gb3V0c2lkZSBvZiBXZXN0ZXJuIERpZ2l0YWwuIERvIG5vdCBjbGljaw0KPiBv
biBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZSBzZW5k
ZXIgYW5kIGtub3cgdGhhdA0KPiB0aGUgY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IE9uIDIv
MTUvMjEgOTo0MCBBTSwgQXJ0aHVyIFNpbWNoYWV2IHdyb3RlOg0KPiA+IC0jZGVmaW5lIFVGU19T
VFJJTkdfREVTQ1JJUFRPUihfbmFtZSwgX3BuYW1lKSAgICAgICAgICAgICAgICAgICAgICAgICBc
DQo+ID4gKyNkZWZpbmUgVUZTX1NUUklOR19ERVNDUklQVE9SKF9uYW1lLCBfcG5hbWUsIF9pc19h
c2NpaSkgICAgICAgICAgICAgIFwNCj4gPiAgc3RhdGljIHNzaXplX3QgX25hbWUjI19zaG93KHN0
cnVjdCBkZXZpY2UgKmRldiwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gICAg
ICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikgICAgICAgICAgICAg
ICAgICAgICAgIFwNCj4gPiAgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+IEBAIC02OTAsMTAgKzY5MCwxOCBA
QCBzdGF0aWMgc3NpemVfdCBfbmFtZSMjX3Nob3coc3RydWN0IGRldmljZSAqZGV2LA0KPiBcDQo+
ID4gICAgICAga2ZyZWUoZGVzY19idWYpOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFwNCj4gPiAgICAgICBkZXNjX2J1ZiA9IE5VTEw7ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICAgICAgIHJldCA9IHVm
c2hjZF9yZWFkX3N0cmluZ19kZXNjKGhiYSwgaW5kZXgsICZkZXNjX2J1ZiwgICAgICAgICAgICBc
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU0RfQVNDSUlfU1REKTsg
ICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBfaXNfYXNjaWkpOyAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICAgICAgIGlmIChy
ZXQgPCAwKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQo+ID4gICAgICAgICAgICAgICBnb3RvIG91dDsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAtICAgICByZXQgPSBzeXNmc19lbWl0KGJ1Ziwg
IiVzXG4iLCBkZXNjX2J1Zik7ICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgIGlm
IChfaXNfYXNjaWkpIHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBcDQo+ID4gKyAgICAgICAgICAgICByZXQgPSBzeXNmc19lbWl0KGJ1ZiwgIiVzXG4iLCBk
ZXNjX2J1Zik7ICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICB9IGVsc2UgeyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAg
ICAgICAgICAgaW50IGk7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBcDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgICAgICAgIGZvciAoaSA9
IDA7IGkgPCBkZXNjX2J1ZlswXTsgaSsrKSAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICBoZXhfYnl0ZV9wYWNrKGJ1ZiArIGkgKiAyLCBkZXNjX2J1Zltp
XSk7ICAgICAgICBcDQo+ID4gKyAgICAgICAgICAgICByZXQgPSBzeXNmc19lbWl0KGJ1ZiwgIiVz
XG4iLCBidWYpOyAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICB9ICAgICAgICAgICAg
ICAgICAgICAgICBcDQo+ID4gIG91dDogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAgICAgICBwbV9ydW50aW1lX3B1
dF9zeW5jKGhiYS0+ZGV2KTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+
ICAgICAgIGtmcmVlKGRlc2NfYnVmKTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBcDQo+IA0KPiBIZXggZGF0YSBuZWVkcyB0byBiZSBwYXJzZWQgYmVmb3Jl
IGl0IGNhbiBiZSB1c2VkIGJ5IGFueSBzb2Z0d2FyZS4gSGFzDQo+IGl0IGJlZW4gY29uc2lkZXJl
ZCB0byBtYWtlIHRoZSAicmF3IiBhdHRyaWJ1dGVzIGJpbmFyeSBhdHRyaWJ1dGVzDQo+IGluc3Rl
YWQgb2YgaGV4LWVuY29kZWQgYmluYXJ5PyBTZWUgYWxzbyBzeXNmc19jcmVhdGVfYmluX2ZpbGUo
KS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQpUaGFuayB5b3UgZm9y
IHlvdXIgY29tbWVudHMuDQoNClRoZSB0eXBpY2FsIHVzZSBjYXNlIHRoYXQgb3JpZ2luYXRlIHRo
aXMgaXNzdWUsIGlzIG9mIHNvbWUgZmxhc2ggdmVuZG9yJ3MgZmllbGQgZW5naW5lZXIgcmVhZGlu
ZyB0aGUgc2VyaWFsIHBhcnQgbnVtYmVyLg0KQWxsIG90aGVyIHN0cmluZyBkZXNjcmlwdG9ycyBh
cmUgbGVzcyBvZiBhbiBpc3N1ZS4NCg0KVGhlIGN1cnJlbnQgSmVkZWMgc3BlYyBhbGxvd3MgdGhl
IHNlcmlhbCBudW1iZXIgbWF5IG5vdCBiZSBhc2NpaSBjb252ZXJ0aWJsZSAuIEZvciBleGFtcGxl
Og0KIC0gdWZzaGNkX3JlYWRfc3RyaW5nX2Rlc2MoYm9vbCBhc2NpID0gZmFsc2UpOiAgMDAgMWQg
MDAgMjAgMDAgOTUgMDAgMjAgMDAgZWMgMDAgODQgMDAgNWIgMDAgMTQNCiAtIHVmc2hjZF9yZWFk
X3N0cmluZ19kZXNjKGJvb2wgYXNjaSA9IHRydWUpOiAgIiAgXSAgIg0KDQpUaGVyZWZvcmUsIHVw
b24gcmVhZGluZyB0aGUgInJhdyIgc2VyaWFsIG51bWJlciwgdGhlIHVzZXIgY2FuIHZlcmlmeSB0
aGUgZGF0YSBpbnRlZ3JpdHkuDQoNCkhvdyBhYm91dCBqdXN0IGFwcGx5aW5nIHRoaXMgY2hhbmdl
IHRvIHRoZSBzZXJpYWwgbnVtYmVyIHN5c2ZzIGVudHJ5LCBhbmQgZHJvcCBhbGwgb3RoZXJzPw0K
DQpSZWdhcmRzDQpBcnRodXINCg==
