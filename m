Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4D0C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7655A64E55
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhBELpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 06:45:39 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26299 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhBELnW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 06:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612525400; x=1644061400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nq+PbCJMpO11gC1K/g1Is3QyYk2YcqO9T5uSis6KY50=;
  b=UCljjPKe1jB2MRSb6fZIULnwaTCz2Ikwprl9jnDvBmYFnZecLXpCNlnQ
   xP9EIj3ElHm0OQya2aAac/J4LmvMGr5mFeqo3R1jZbH2zPmy7Nn8lZ/a2
   j7mIQC5t1Bk7rbvg0otDx3Ee+3WkizDQ7Z1BBpUiF9s8mRY5JSWX8ULQb
   wd1Yo1DTjjPmR49rvrEpSviqQTgHek65gk15mDVqdW0wFtBTsTN++imL1
   zoX8BMCdNb+eW1ZRe6vn3519diZs+2XXyMtSRdJioN/eyvcIzp1z+BSoj
   EJwTYtZ/OZB0yrNqo9w6qwessqnQFRjzM/tFo6feP5xWzHL/xIghuatOS
   Q==;
IronPort-SDR: rJAje8L79uUYNpE6RGh4KzWpUOU5eiw6SOn4SLPVolDo0uxwZaizKpcSRttCOmQCeqkP73u/QD
 4FBip324okwT5ROmVXG+lP4s+b+HVMXri3UfBG2oxSX7NIFwlC2TVCFZQedSwHezD0gVxvKIFB
 y1mVdAMXCZ8N7uJvgQXMJTebYaCrlU8hRjeDqimDaDErpFW3Ufon1Rox3Lx6MgUZne7svJQ5o+
 2vWCKDGY/q5Uan2xKEgkViK+ePe09RJEBp1+fx+gO55okXCqHtkvjBeigB40mIXWEtpou2PjjW
 /uI=
X-IronPort-AV: E=Sophos;i="5.81,154,1610380800"; 
   d="scan'208";a="269659960"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 19:42:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSUnwo05WIOH8ScB7SFWadEmKNVX6Ql+r4/0xbk7CAHyRGunKypAIKb8o6zHt0aIQf/KgttE2EJX0Cd0nu4xYgBPeTJyPQLW+bvlBiA/Oi7zt11O+5LXPwS1eoISkThdgqEDOedQPdXkXmEv9RB8FBHUbj3THslVvHc9uXafArV6+q2sqVeDVGxduyKDXxxxoPh7msPogBDja4iF00TKb3w0zIaizidmhD5XLEMpMXAcJQeBJ9ccAiOrwpy6mzTFpnkfobzsEKB34MKAGvg/92ZxHyV212sb1u9a35f4LqCCd6oPm4bFUd+hbzFa4UglT+t1nGPdhhlng302ivdX2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nq+PbCJMpO11gC1K/g1Is3QyYk2YcqO9T5uSis6KY50=;
 b=CKElNXWT9bBEjjywP+8KsHIMMraki+cm+aSvGDbU/tN5O9EheLYemZDvdrhVe4EUbOOCNhJo1UwcgaFvO7X+64xPJTQKd778d6w0TEW7td5T95BM+bU3HqV/IJOmf5x+Y2n+GIfVh2cI3Ae17tpKV+GqwHXtvyzJZh2s/X/IQqag667L5oPzgivo1jotf+wjr5JlF3o68CLN7cYu+MRVgY/JeXxKofzK31fW7HC9DtYeTow6lTE0VZtCYdSF9mysUWqQOl7ST4PAQIxYDp7rwcG07+GPS9i0SUW75wZxHBDUdYQ2bWlEybVT1PSP/gfF7JNR2MYy7fVjmwUhtHDp7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nq+PbCJMpO11gC1K/g1Is3QyYk2YcqO9T5uSis6KY50=;
 b=cMZ/ZnE1SGUlmAEQpiiefREk+akM1KjNi+SIZUSglEDE6KDNmIzkHMX9U8G/9T1KkkVoWybzAN+kd8LHEVgaBzTzjC2ibKBw42WO20oPvhWCjAhAkuGOKFWItbf8dKDuw+cz7b6LCG1hCEqa0Z9ccIxLN/4EGKsLIsUIYK08hxU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4555.namprd04.prod.outlook.com (2603:10b6:5:2c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.17; Fri, 5 Feb 2021 11:42:09 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Fri, 5 Feb 2021
 11:42:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: RE: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHW9f/TvOegnF+5cUGte/jMckF4fqpJdHeAgAAGfmA=
Date:   Fri, 5 Feb 2021 11:42:09 +0000
Message-ID: <DM6PR04MB65759D6418E8FCD4B0BD6236FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p3>
         <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
 <218be362c71a9cdb8312f6d8156a0935985aae04.camel@gmail.com>
In-Reply-To: <218be362c71a9cdb8312f6d8156a0935985aae04.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4f3f0261-311c-46bb-c7c2-08d8c9cb1246
x-ms-traffictypediagnostic: DM6PR04MB4555:
x-microsoft-antispam-prvs: <DM6PR04MB4555BEA28C180849AC4159B7FCB29@DM6PR04MB4555.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hir80bLwHk+UXccYYHZx6Xxtxw7u/BofzmXDUmLCcetw941KQcAml7IGDciuPryMxLDJtrRRijr1L1HM80lPRgzAojdveC310hhx9kvYEZLXa/TUR0Z6trwaGNAnYY+hnX2vcpA6XLutS1rZY/2bp9PEXqeYB+7T+ocgMzLK5OCfgOySfceM9d3OkfXCW+zVVHzHAZEmiizY3FNCdUrUzhF62IGLcvgifPc1n0zh+vaPuNxVGWgVpK5/n1rZxOupT78ifWpT4eb2mHDRcV+5EiTvL6ITtV6uUoQJfS2B9r0/4QLoKokjDQerd+BJmnb+pNnq5nld0ly5On/eNS+a7HYicz5NIhcOJ0v3nihT4pAwMWlJVcAFZZVOcz5jAMBuf/SDQWEZqBUBcRyp06F8ImamGXzgr6R65RlT/BJX0q+fCHi4tIBwq7F09D4QJyNrkRfgqVlQjqvMtn1R2U5Fpo+Atb5uca42pxJbeoNaJWXf8j2vQW+Tg3ZylOhOcvnG+c0Aoz/vNCVyU4YQwPBzSYhodbi4Ae/6Z1TAb/XpdZkVcGLbCnA0npcZAV9qgM0v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(5660300002)(4326008)(921005)(6506007)(52536014)(33656002)(4744005)(8936002)(7416002)(2906002)(54906003)(110136005)(316002)(83380400001)(186003)(86362001)(66446008)(66476007)(66556008)(64756008)(71200400001)(7696005)(66946007)(76116006)(478600001)(9686003)(55016002)(8676002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OWw1Nk4ydFJWdXlwYllSdW5SbTZqQ3RsK1NCM2UrQjJhdDJzN294akNDanJL?=
 =?utf-8?B?bVNsWkRHNzFsQWFueDJtRTN0L2pXUzBGNUNvTlkwWTAvOFJPMzZWSURmaktz?=
 =?utf-8?B?Z2tvdlF4SHF2ZldZQkx5Wmt5Y1U3UWsvUmRoUHFsUjhRL0xrSm5KUGhOWmFZ?=
 =?utf-8?B?RmNpbDliUENKeXVkK3VHalQ0UGdjZThLSFB2d3lnRjRELzgyZnJMWVhsODNQ?=
 =?utf-8?B?ZFRBZ1Z2bG8yT2t1UnMzZXN4bllFcVVJUlFhN1E1dzY2aGtRcGJvMS9IdHR4?=
 =?utf-8?B?eGY5VHgwYWFSV2V5KzdxV1Z3UTZyQmJYM2dKd0JzRjN1M2lGb0NFQ2tMZ3By?=
 =?utf-8?B?bEhGQlVGQUMyZTRlelVEb0UwSFpsZy8xbXBUU1VIOTNZdEw5aTJzSjFTZFJ0?=
 =?utf-8?B?ZXJDbEdJSUw1NUJ0dFl3TlcwRmxmd3hjV2Q2RHhnc1ZFK0JsbUNDSDVlZFVm?=
 =?utf-8?B?bFpFUjgxQmVCazhWL2dTcHJLMytseHZXZjFmMk9QTnJaVnU4U1g0Yndzell3?=
 =?utf-8?B?Yk5kQUl1YXd1WkZLdlMwS2RRd0o5VE9DT01NN2JyS05QTkVobDNMQTVQZ3Nl?=
 =?utf-8?B?VXZXaXB3SWZIYjZXbGtVWkVPR3lWb0xTTDFEVk8xam8xcWhTOGNqZUVCZFQv?=
 =?utf-8?B?dEZ2cGVrVFdxdldsdUlZazAxbFVMNTNMSncvYjV0RCtQVGhKQkV6RUxFZnBC?=
 =?utf-8?B?SlRlc1VDaFlUc014ZnZzU3FzbEdlUWllL1BlVW9CaVVBSk8xeHUvcGJJaE90?=
 =?utf-8?B?VDB0ZkhzUllGeXNkTUREdXFEU2tFQTJuU2tkQkxxTXdWcWZxQjJaKzk5ZkFu?=
 =?utf-8?B?MGI5MzlsTFBwQU9QT0xmZ3hSMVoxZXZCYndJNm1qZkNaanQ0UFdIZSsyTEZC?=
 =?utf-8?B?RHJEM3FPblpiekRMaklBdVNOcFhUSDJEOHNldDB4UFhuQ3BCM2ltWS9takh5?=
 =?utf-8?B?MzIrQ0JQczFLWFI5bk1EcFE5clRYd0R1d0FTVU5rZTZJUXhOZEJPdUdnUEtG?=
 =?utf-8?B?b2JzL0xFYkcxbHErUFZocTFoRnh6dFF2WHZRYzFYTzlCQlBHeXFYekhoQnNk?=
 =?utf-8?B?MnIvTmpUQVByMkI4bWNsS2VGZU9KSnpZSUdaYmZCMkExeGN4QW11UHRrdEVI?=
 =?utf-8?B?eU1VR3RsVTJPZlFlRUJQUVVFVnVwYWtvbjdKU3RWUUU3eWQycjRMNGpoWUp2?=
 =?utf-8?B?OEZnZndEaUJ2N2RGTEFEZi8vMmVJZElwbm91T2I5VkVyMThoUUp0MkdOOFVy?=
 =?utf-8?B?b2Q2TCt5bzBOMys5ZG5OekorUTRzT3F3R2JyRzRtbmpPcUFiUEtrL3RTQmFR?=
 =?utf-8?B?eFpEejdnMHdLZU5SSTNBTmhUTzJlWmhtTitpMHM2bEU5elRZWFRuNXMya2Zj?=
 =?utf-8?B?K2ovbXhUOFZnZWdjSDlmaWZQNjJZM0E0OVl4SC9RdXBhUDJraU5KejdmQ1hk?=
 =?utf-8?B?b2cwWjhZbGcwaXk2Tmp5aTQ2Uld1MGJRTXBXSmVlQS9FcVJOai9jMG56ZStp?=
 =?utf-8?B?aE1vNnllQkFXRFJsY0RPcmxrY2N3R2pTZEZtVTRWZHgwTlk2ckJyV0l1OTdJ?=
 =?utf-8?B?cFgvN01EaVhZWkIySENINzdLc1JqeGJWVnAzdlVYMEZGdk1Da3I0TnJMaTlK?=
 =?utf-8?B?bGtBWVdsVXJCTHByNTl4a2Z6RG96ZC84SmxCUy8xMmlsTmdtL3JCMFRHV0tw?=
 =?utf-8?B?QjJ4TFJJazZ2MTNlV0dyaTE2c3ZXcGlLY0YyWGErSWY3TW1SOUVsakUyODRz?=
 =?utf-8?Q?ze9SW3UdrBL3ttpl/0lFXt3/Vw9rzMaf9UkIuG2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3f0261-311c-46bb-c7c2-08d8c9cb1246
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 11:42:09.4679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cz6k7tLh4UJSim9jEg04ObugP0Q3FgTHrA5TZg0Uz9TkBkWb/xxyTsUVG3yXX2dbdHJffxmTozZZBfLvzaQA3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4555
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSBEYWVqdW4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBoYXJkLXdvcmtpbmcgb24gdGhlIEhQ
QiBkcml2ZXIuDQo+IA0KPiBJIGZvdW5kIHlvdSBkaWRuJ3QgdGFrZSBpbnRvIGFjY291bnQgb2Yg
YWxsb2NhdGlvbiBMZW5ndGggb2YgdGhlIGxhc3QNCj4gc3ViLXJlZ2lvbiBvZiB0aGUgbGFzdCBy
ZWdpb24uDQo+IA0KPiBVRlMgSFBCIHNwZWM6DQo+IA0KPiAiSWYgdGhlIHJlcXVlc3RlZCBmaWVs
ZCBvZiB0aGUgSFBCIFJlZ2lvbiBvciBIUEIgU3ViLVJlZ2lvbiBpcyBvdXQgb2YNCj4gcmFuZ2Us
IHRoZW4gdGhlIGRldmljZSBzaGFsbCB0ZXJtaW5hdGUgdGhlIGNvbW1hbmQgYnkgc2VuZGluZyBS
RVNQT05TRQ0KPiBVUElVIHdpdGggQ0hFQ0sgQ09ORElUSU9OIHN0YXR1cywgd2l0aCB0aGUgU0VO
U0UgS0VZIHNldCB0byBJTExFR0FMDQo+IFJFUVVFU1QsIGFuZCB0aGUgYWRkaXRpb25hbCBzZW5z
ZSBjb2RlIHNldCB0byBJTlZBTElEIEZJRUxEIElOIENEQiINCllvdSBkb24ndCBuZWVkIHRvIHdv
cnJ5IGFib3V0IHNldHRpbmcgaW52YWxpZCBwcG4gdG8gSFBCLVJFQUQgY29tbWFuZCAtIA0KeW91
J2xsIG5ldmVyIGdldCBhIHJlYWQgcmVxdWVzdCBmb3IgdGhvc2UgTEJBcy4NCg0KU2F5IGFsbCBz
dWJyZWdpb25zIGFyZSAxNk1CIGFuZCB0aGUgbGFzdCBzdWJyZWdpb24gb2YgdGhlIGxhc3QgcmVn
aW9uIGlzIDEwTUIuDQpLZWVwIGFsbCBzaXplcyB0aGUgc2FtZSAtIDE2TUIsIGFuZCB0aGUgcHBu
IG9mIHRoZSBsYXN0IHN1YnJlZ2lvbiBjb250YWluIHNvbWUgaW52YWxpZCBkYXRhLg0KQnV0IHlv
dSdsbCBuZXZlciBnZXQgYSByZWFkIHJlcXVlc3QgZm9yIHRob3NlIExCQXMgYW55d2F5IC0gdGhl
eSBkb24ndCBleGlzdCwNCnNvIHlvdSdsbCBuZXZlciBnZXQgdG8gdXNlIHRob3NlIGludmFsaWQg
cHBucy4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo=
