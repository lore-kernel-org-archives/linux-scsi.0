Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B395AC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7689E64F0C
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhBXJJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:09:24 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61946 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhBXJHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 04:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614157636; x=1645693636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zcbkz60hjSlra1EteY53QxsgFJXP2yctVKlpHsEWu+k=;
  b=JsbDjzIMtpVTxSeFw5UBBCH3x76VodrbbSbo+lHWAgvpQpW3Ze1zdVCA
   oXurELNDAB08nQgJDcb2zGV4YbDkhH22JJMuQVN4+IA+4tmY0YEOd/e3X
   kUs/fjgbqd0rhfc2uHD7BxzLYHkpT9nQfU8R8R/RSAwPTL6kJQY1a726Y
   kcYIZ33ujNUk81LSWtCO86VMnh47wM6rK4oevNNgtXzKuD7Rwgj0c9Uva
   1FIcXR0pUIq+R9OQcwJ/vKmJqOEaitLFAt8E8e9BwwRANK3HZnTD5FhKP
   HnTy72tIV+IR2aFn9R/BPPwNU1UO9+lQiQwo2DNsRdbE3tzamhoDHdeS6
   Q==;
IronPort-SDR: iA2HxeJ8hU6deKPhsluvnUocQfFEtlfH9J57whL/U9iUsIp1X/B/9shyb9cWPVE7Hl24+5ijiX
 aaF5NcqC49PZSuqT0lTi9io6oG37OGybseFUtABD8a0KxU6bSd21yxj4M20SQ5ZgHyMxKJRBhd
 mWfS+QV841CcFMlH9FPMrM5KOMHlCa9jzyAqfGp8Ndj2ASwUmsNOKwrUMrFqa9ILxOjSYy/HKl
 cLACxIrjB/MW+tqc9MtfzZERx0znmtViUhlUOKjq2soQ9OyqF1AYd/kZ5LFH6emQQf0BnsP6zb
 izY=
X-IronPort-AV: E=Sophos;i="5.81,202,1610380800"; 
   d="scan'208";a="165159864"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2021 17:06:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqPEJuNoR5go89zK0yoqzVewYPItQmUzZLP+VDCLFOt3ODDWvP9jvD7bbeYPn2hhSdhhSYjLZEMk6UhoReuAOWmPuTHLfEMuI1pIlDLzOVL9N1iuJwIan7IskEesxVpJrBELi90ORSP5caHQXUHJKQCIxDModEVdiUOaeX0z592Q8SKMSmhFgMSNntRBoUb2PgclAHm6u1ErSaO9feiRj5aYQAf9H9rffLJRFhsFeBhF5l6H4/OO0jfpvmFsIV51VoLPAuPnAr53U9fSDF7KwLLvbkmv93AyYeQXQIW/TABqPvLSGoracdaROEIDzDsX1/WQWogllFPUHYity86w1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcbkz60hjSlra1EteY53QxsgFJXP2yctVKlpHsEWu+k=;
 b=BdiN66BT/lUZa2tbVHCdhYfeXHPaiAo+Z60TG+Rce3QrEXwrWxKmLJsP8mxjMJ8uEwLz0OUFzsg34VNI4qIgDxbKJoN7cRWe2idk4eakav9eU+CGtJsJ8LPUCtNQ3mdqP92lWooByHrFlxVVyRvKT0Qg6zoe//N7+9mv2I0Admb9qpB962YTJCRvcBhVq3SR7REx0F3H7vQ73aYWBnr7DKf9mFfI2PmmPT/08P86Dk/AZNxR3ALB2+OQ/5iip0+c9/VbrklVy9Okm6QP7nrHkqYtzHwX7YrzVSZYuRfZlbj65F9ee12hwtTPI4kKojX1pF2F8K0U+5EqH4HviTrnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcbkz60hjSlra1EteY53QxsgFJXP2yctVKlpHsEWu+k=;
 b=mjtbFyX1RjFN/PW89eiynr35V/soXY9KND5PcT4AIu14NaoN1UfRtWLU1Tl8rnwSaG4Al45unu6TInvPcYN7sfxYl3GCXxQx5FkFf8XTWK5E04xHqfcY/5NoN/1lW6MXa/NzVbSyNkZ9mTOxE1uZtCS9k9hzKT/VHGeG2N5cgkA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0971.namprd04.prod.outlook.com (2603:10b6:4:43::35) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.42; Wed, 24 Feb 2021 09:06:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 09:06:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCP2Y/e9Fs0BGVk+8HmhkjtrqFaplnxOQgADNhgCAAIxTEIAADQXg
Date:   Wed, 24 Feb 2021 09:06:00 +0000
Message-ID: <DM6PR04MB65754EE70E1E61C46309AF9DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p6>
 <20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb@epcms2p6>
 <DM6PR04MB657573102C577230A3079DBBFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB657573102C577230A3079DBBFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 479fc4df-9f04-4070-11c3-08d8d8a367c2
x-ms-traffictypediagnostic: DM5PR04MB0971:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB09712B1CBC1A6BAB25F36C8FFC9F9@DM5PR04MB0971.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: psYHaq2/mQOS9XgkZrJkR7i6vDGIGmDXuQFbrvu6wj3FszYCMV72zSjVioI1YJqSYBzCuU87wAdAO3woiiK0PWIMrRCdxBecAWyfKZ2dL67XM47Xtb+4L6cs19SNzlY7kJsnSSCQkbQPt6+K0OR1tMzfmcqHiMdQw2ovUh295MYbH8x1pGIjc0na/41dRgRBmw42ATDqU3pOLCE0lpEsuU8ZeBNd14XKarnbYaz7d+7mF4phqYFS/fAQlI9eBgwKUkSbwRPpyeRB6Xw9tSbtbgFqb9u+SyaZrHVoif1oQdrXstvQa6v3Ktn6qA6WqqL6qyjpRl86sTRDV6rJFW9XAgdztWkmQx6gaNZf8ln3NZDSR+AFfFbyIEVcsrnb54c3NWcIZK0QoRq75tj4cpIQW3YNXfGfgyo7MMxqwpihWjmEr3WutNkc31vhrhE+mQqTL6ehYF8EHSRubbaeI1SmRaV6mSp6+vIc4uPQGwSZptYsZdux4wyI9NFzjzkDtRvXT7c8AdLYFyQuMWpA0RZsr7jO22Wpc5hST4g9aIOFEg9216ndFoUx3uF6pK4DLhFp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(186003)(66556008)(66476007)(5660300002)(478600001)(55016002)(66946007)(66446008)(83380400001)(8936002)(54906003)(76116006)(2906002)(110136005)(9686003)(64756008)(52536014)(2940100002)(316002)(921005)(26005)(71200400001)(4326008)(33656002)(86362001)(4744005)(8676002)(6506007)(7696005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cEs1RWRPTDhhSUwyWThIa3k3bGppNlFiMDh4ODZ4ZlV0ZHp3VmlEWFNHT1p6?=
 =?utf-8?B?NFRUbmQzZFdleGR6YWY3Y1NzOWlPTlBCSHhOdCtHenJlMC9MWmZyOU9IeWJN?=
 =?utf-8?B?ZUpaUGZDUUpvR3Q2Wmd5U3VuNllRLzZEVWgyYTQ0Kzg5TWZsam04dlBabi9s?=
 =?utf-8?B?b1Q3OUk2d0NoTUZjUUtiRFhlSUpzV09mOGhMaTB2L1NBclJHY0NYdXZsZEhI?=
 =?utf-8?B?ZG1oMGdSVThEdFRMc1p4eU81Y1VVWGxvY2s4WmlXanFWK1dnb3ovL2hKd2VL?=
 =?utf-8?B?V0l5M2ZsNHc3MndPTnVDb3hnY08wZ0QremN1ZmtKTm9hWmxpTno3VmlTSXNS?=
 =?utf-8?B?OU5YZG52dmFyTDJKT3pheE93OURjWXdmYm5jQld4MnlQemgvK3hUVUVWTXNH?=
 =?utf-8?B?NmM1QjMvamNlQmpCYVBQUi9VZmdiZzhBTnhiYVF3a2ZFdHZZSGRMbXE2bTJ6?=
 =?utf-8?B?ZWNhbGI3cDduQkJPbTdFZlQwYkxmZXpFRGIwWXFCQWJMQ1FFWktHMlJlTmZn?=
 =?utf-8?B?UGplanZKRWNjbWlacTF2NmRUMGNzcThDQmRjcW5FeEU4ZllYanlzRTdtci9Y?=
 =?utf-8?B?c2V6eTFMVVhxMnExZDg1U3hLUWMrYm5TVnVmMjJ1MmZIREc4MlE4QXpoTjlj?=
 =?utf-8?B?dk51aDViNHM3UWZKNzJKbHI3dWdocnlBY205UmxPa0xLK2dnQi9YTndKank2?=
 =?utf-8?B?dTYrbFBleEhDdWdGM011N3g4Z3BOOXlLanV0eUpEcmdJOUpSMGhSbTNXQ0g4?=
 =?utf-8?B?ZXYwTWdqeDE2dndBaS9JL1lSZ25IUG9vK0pzNjdaRFVVNGE4d0lDMWpYNFNa?=
 =?utf-8?B?YkZBbjE4TGxIVG5GMzl1MHc3UUh0ZDFOcHZCdnNZTy9zODg5cjdGNVlxTjFP?=
 =?utf-8?B?YU5HdWN2VkxEMVQvOC92a21GZk9xK29xV2FUbk1DRk9mVjQyamJQY2hOdzBt?=
 =?utf-8?B?d0dEM0w3eUFlZHpGSjlNbkpkemJodHJJa3d0ZXJNU1M0RjdxaHM2U0Q0MEZM?=
 =?utf-8?B?NFNxdndmVTBuajFUcmdCc1hPdEV1ZHV1RWovZTNycXlDRWtqcEYzY0w4VmJh?=
 =?utf-8?B?eXlBTDkva3pJeDgrSkhmT2RUak11cVlpeGt6aE54TWlpN3lueFM1cmRKMjU1?=
 =?utf-8?B?bXEwODhMWGNuQnFDdllJWXlpdzlTMzZRbFFTRlZHcm5vazR2NDlZZ1BjaytI?=
 =?utf-8?B?SWRKNjFQVkdvRGloTGkwMTN0byt6V2hsMk56Nlc1Zlc1dG9RWTlFRFoxaHFN?=
 =?utf-8?B?K3h2MWcwOTJYMHV6UDFVdXdxZ24vRHlLMUFQV0xMMHRYNDJwMjlGT3lMai9v?=
 =?utf-8?B?Z0k0WE1FSENHV1ZXaDhKQ3BqSU9ubnA1ckNLZjd4WFRCVWZ5dmxjU3ZMMmJr?=
 =?utf-8?B?dEwybkJwVG1zaXV1bGpQMG9jdWk3NGxPZUhDTkhSdlE5L3hrSXd0UUpkcnBU?=
 =?utf-8?B?eHRma0JOVHZTczJYSFNzbXBaeUR3NUJJSFBITEdQcHdWbitlQmNMWTNGejhw?=
 =?utf-8?B?bkFEdGkzRi9CZ2NEYWpiTU5SWWxLZWduOEszYjhEUEhMT1JDMTRTZ1VFREc4?=
 =?utf-8?B?UDQzcWp6WDMwU3J4cU1aZ0hwbVhrbFN4L1RCTXBKMFdJRlkxYWozQ3VBSUUv?=
 =?utf-8?B?NmJFZXMyMStSalFJTEdsMHdTaFhrZm55T1MrVkpOcTFqNFhRK1BOQmU0bkRT?=
 =?utf-8?B?WWQzeXY2eXVrZWlWZ3RPK2RIaUxtRmJ0TE5lK3dYcEo1V2Mxa3M0K2JwaHNp?=
 =?utf-8?Q?+T2/1I0s+8RhyLRp+Ba4HfSNxFo90yyn1iVmhzp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479fc4df-9f04-4070-11c3-08d8d8a367c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 09:06:00.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SclJOiVcaCfBpQF6n+YbzTHCzzJGhN3/QDiN7V9dxZz4wIloMdRT70Hu3BQG0TBwE94/GMv3sm9oTNPEOlPf5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0971
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gPiA+IEBAIC0yNjU2LDcgKzI2NTYsMTIgQEAgc3RhdGljIGludCB1ZnNoY2RfcXVl
dWVjb21tYW5kKHN0cnVjdA0KPiA+IFNjc2lfSG9zdA0KPiA+ID4gPiAqaG9zdCwgc3RydWN0IHNj
c2lfY21uZCAqY21kKQ0KPiA+ID4gPg0KPiA+ID4gPiAgICAgICAgIGxyYnAtPnJlcV9hYm9ydF9z
a2lwID0gZmFsc2U7DQo+ID4gPiA+DQo+ID4gPiA+IC0gICAgICAgdWZzaHBiX3ByZXAoaGJhLCBs
cmJwKTsNCj4gPiA+ID4gKyAgICAgICBlcnIgPSB1ZnNocGJfcHJlcChoYmEsIGxyYnApOw0KPiA+
ID4gPiArICAgICAgIGlmIChlcnIgPT0gLUVBR0FJTikgew0KPiA+ID4gPiArICAgICAgICAgICAg
ICAgbHJicC0+Y21kID0gTlVMTDsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHVmc2hjZF9yZWxl
YXNlKGhiYSk7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiA+ID4gKyAg
ICAgICB9DQo+ID4gPiBEaWQgSSBtaXNzLXJlYWQgaXQsIG9yIGFyZSB5b3UgYmFpbGluZyBvdXQg
b2Ygd2IgZmFpbGVkIGUuZy4gYmVjYXVzZSBubyB0YWcgaXMNCj4gPiBhdmFpbGFibGU/DQo+ID4g
PiBXaHkgbm90IGNvbnRpbnVlIHdpdGggcmVhZDEwPw0KPiA+DQo+ID4gV2UgdHJ5IHRvIHNlbmRp
bmcgSFBCIHJlYWQgc2V2ZXJhbCB0aW1lcyB3aXRoaW4gdGhlIHJlcXVldWVfdGltZW91dF9tcy4N
Cj4gPiBCZWNhdXNlIGl0IHN0cmF0ZWd5IGhhcyBtb3JlIGJlbmVmaXQgZm9yIG92ZXJhbGwgcGVy
Zm9ybWFuY2UgaW4gdGhpcw0KPiA+IHNpdHVhdGlvbiB0aGF0IG1hbnkgcmVxdWVzdHMgYXJlIHF1
ZXVlaW5nLg0KPiBUaGlzIGV4dHJhIGxvZ2ljLCBJTU8sIHNob3VsZCBiZSBvcHRpb25hbC4gIERl
ZmF1bHQgbm9uZS4NCj4gQW5kIHllcywgaW4gdGhpcyBjYXNlIHJlcXVldWVfdGltZW91dCBzaG91
bGQgYmUgYSBwYXJhbWV0ZXIgZm9yIGVhY2ggT0VNIHRvDQo+IHNjYWxlLg0KQW5kIGVpdGhlciB3
YXksIGhwYiBpbnRlcm5hbCBmbG93cyBzaG91bGQgbm90IGNhdXNlIGR1bXBpbmcgdGhlIGNvbW1h
bmQuDQpXb3JzZSBjYXNlIC0gY29udGludWUgYXMgUkVBRDEwDQo=
