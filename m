Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FC8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 19:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3964661090
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 19:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhJNTFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 15:05:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25752 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJNTFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 15:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634238187; x=1665774187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3FWsmf8eHbtKRub79SM/+VulgVTWYKhAwPPR7MmjuHs=;
  b=qj/XgykbzrKq+RuLPZ2DnQNS8THv4A2wqrkhnWYq190q/t/oBK2V3OAa
   0WDzxAbbFD+2eL3oyv7MTUxwE+5Ain++NmwcTUIRkAOYz2UVHdJjx+GRa
   FM7XsB8XaZEz7/e2VRl4+okaDSm8E+F25zsyrApG1w8emzoJbTY+jRF3L
   wv3TAhc2jcq1RGHmzvAHa8dmiYu8s+7thd0OP+c7QldGLkFQ894BRSDVn
   JIazdjzNmYmT7QcUgRg9XHueR516UQwojyO9UaazAuIKnmAZBrxRqzjdU
   Iai8NN5Opwc7lNYezSlU266EnLhnbkBSWynTLutnR6/7ntK7C9tzZ649r
   g==;
X-IronPort-AV: E=Sophos;i="5.85,373,1624291200"; 
   d="scan'208";a="183814851"
Received: from mail-dm6nam08lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 15 Oct 2021 03:03:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITBig1BN75+Cx3D7VXzw5+t9uQD4ns/iu+S6Bps6ZZe8NFG457BISSwZNDpbBKV7wucZdhSTHT/fpJQRDDPuWXtsVSMTboOLZlRXo+m/K/J9E7RivE/uEd0snW9d9gNecVOswC2seIpvS4sKMMd+W4ey33xHlBfdIqdK7hM7fDUv/Q4K6vFHOfFphByP/t6/12GvtcQ5h7i3FyMUA0sqmK6mupblQaInuYmmyOdXsHauNpznxBffLbMR9snfzeoC95/G9M/1TYvYyxLGowk4AZ5wSxqRf62HL9CQ7NzVz47eBXeN4qW16hiV++l7gFYr/6iseIG4J1Uz2gmH2dP1pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FWsmf8eHbtKRub79SM/+VulgVTWYKhAwPPR7MmjuHs=;
 b=fAtBwZU2yQ62YGRbX8msU4qhKkJ6bpHp+ljBq5IX9wtQgUI0mtonPOMr1xttPYXCNeltOhB2yPxAnWjbkfb0t3pREUdV4Yxb7mpJ0YBpptmHWdWofhDwz2SzIFwJKXEBr+MiiCzyV1FgWOyTb9TcKz7cMJzOkVuhmDmtwmiPmpBauBONjCPNzMF9E6gJSJjDLJgup2eC8pCJscEqRi64OqIT7biwBNFRKFCuIh0F2qWSnSvUOumNNMZCHAWLlOtUGYUpq5fYW0ABmpaHywDUXG011YjSkXk5Xs9Yg4+eLFyHYbJYFeCpZ1EPjU4n4f9QndKTXMUTKavXmVp8jki36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FWsmf8eHbtKRub79SM/+VulgVTWYKhAwPPR7MmjuHs=;
 b=qJn1xjrBIlyrOQDQCloERFkeGY4PVyLT7+WpyGOynJi8NUw7f87m+opHYa4rklu1YrhDIEvmofLdWMpvDVOTpcXOIWoCjeiSZRmE5Yor9E35nw/IIuh+7oSex01I9/EhDh7HqD/5VCOrSHcEhdnMpZNc96Tl2Kz3VVcPsyBk0ws=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6138.namprd04.prod.outlook.com (2603:10b6:5:124::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Thu, 14 Oct 2021 19:03:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 19:03:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v4 15/16] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Thread-Topic: [PATCH v4 15/16] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Thread-Index: AQHXu1MP6iye0IuLVUK2+B5ZIluYb6vS45rQ
Date:   Thu, 14 Oct 2021 19:03:01 +0000
Message-ID: <DM6PR04MB6575717817EDD8C549F2D539FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c@epcas2p3.samsung.com>
 <20211007080934.108804-16-chanho61.park@samsung.com>
In-Reply-To: <20211007080934.108804-16-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9f72d39-d7c7-4427-b231-08d98f453e66
x-ms-traffictypediagnostic: DM6PR04MB6138:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB6138FD551126CBADEB43CBE9FCB89@DM6PR04MB6138.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:419;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fwXOxwlU+5C3G5wknNsKJ4YaJhpCK0QIGvffxBgvrOLYDa2BcqZYTKLnKF/iL+EQgZPQI7WVvmj5VXJv9oBT6Uay9XmdRNmrxAyUsvW6j/64/RfiQuLmKgeawCyXpIdA/wWt6jdTcx1BB0vLwCGYacUv4NGTb4jUCqpDYG8bOm5TlfaNPJ5IsXc4CFGT3wHJen4+DpC/q03zwrCSuUmIn74u4eW81/GwPyYn0frtfGIeGoR913BNmXdi3ppOPXm3DwSn6x+QaQZ5imAZybMCx/Ebklap2xg/Fr//3ubOMyhZsimzo9X3Ysc40yYUn+W9AKsuVaeokrs7IyXHK4wo6T0SMWyFrvBqmjw4fJ3sxl7LG/HvnfHgLbnU1TzjSgamfNRTnfEEqSpZxRfBw8n8U/ihO7wXbtDeARCAciR//9TwovEOo0do969Ii7bCUIw9Q1Ls5dVgs9b0y5scjOEasq9sTjZ5EPPSqZmkrnWokZMi5JbAqkdi/NoV9pyJXHHkH6H4hjuupS7woDYnyTkJPhU4Alt1Bx3XYCApXoSmGJyS/aIGGtE+L/z6vkAIjYs1L4s/mpJvV6ArvHXQ/NhmNfCPFR3vO7jOl9bf0D08rlfuZczw1cpU/3tvyVWbrSF9fa0r4L2RAqxP2onYIEVSqGuOTkUS6U49nAOy+ADo/UZQNivrOlLTt5I/jCX9K/EkmsRXUEXhlWlNWyOO8N9fgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38070700005)(5660300002)(7416002)(6506007)(66446008)(2906002)(66476007)(8936002)(52536014)(38100700002)(86362001)(8676002)(71200400001)(55016002)(64756008)(66556008)(110136005)(4326008)(186003)(508600001)(33656002)(26005)(54906003)(82960400001)(83380400001)(9686003)(316002)(122000001)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUZSdnI4Y3YrZ0RxVFVxZjlwZktEaFpxazc1aE54WisxQ0xJTHY2NUpQSGF5?=
 =?utf-8?B?OWRMSzF2S2J5Y09qY2ZlaEY4UEVCNUF3WkFwaTQzOG0zRHdaeXpHOTR6NVJL?=
 =?utf-8?B?bjJDZGdlQnlwcmdxZm95RThFdTU3eEtqdHdFM1dGelRPWWcxb2xGd3grUVJL?=
 =?utf-8?B?RVh3MTdPS2h2YzI4aUI5RmN6VThja0cySmh4NWlCU04rTFZHbE5zbkRML29W?=
 =?utf-8?B?bTRtK1VzWjNvSUd1RmlEZ3BBZ1dzdFRCUExRMW82UGhJWENMd1NId3g0czg4?=
 =?utf-8?B?THQzVk1tSzFuempZc0RMd2VNRjFOb2hmWFFLN1I5QmlDSFMrM2IxRnVIN2tu?=
 =?utf-8?B?TWRsL3RobFFrei9CSFpKVFQ3eUs5OGdxOVpPdHo4L3hJSVhhUjdyVHh2QVk4?=
 =?utf-8?B?QkJ6SjZEL0FsVjRQc2FteDJFcHFFZ0VqeE5PL0lsL3RsZ1VraS9BWk1uU2tk?=
 =?utf-8?B?eWlUa2s1RUNzRmdZVjNTejhPSldnbWxwL05MVk83QWZ4TUtKRklOODREcGw5?=
 =?utf-8?B?VHZVZ3JCdFViakJaYURKR3Vzeml1NWNLTW81SmxnZ2IvUno0SFpLUjRSK3RO?=
 =?utf-8?B?RGlQZFhTcFhNOEdWam1nUEtTcmNnQXhwVE51L0hkUDJaUlpvblhVcTNrck9K?=
 =?utf-8?B?WEhHS3lxWE4wYmF6bE5HY1lnMzUzUFVJcnNHTXBsa1Z2WUQ2d3pSY0NrcUpL?=
 =?utf-8?B?VHNEQ3ZDYzhhNUNKb0ZoRFozWGttR3A3YnNIVlRaZU5PYlZ2eG8zOGtocVRT?=
 =?utf-8?B?Y3NWUW5jWXExQ2tjUHdoendqTExrTnduU3gxcVF5QlJiVytNMER4andjNmlC?=
 =?utf-8?B?azQxQmJDckVPcTAvSkFqRzhTOFJodGFsTUZDUW13Z2t2QkhTM0tNK3VTNWxI?=
 =?utf-8?B?R1lDV1d2QjFqNnZuOVVodndFSnFZZHNpZHdkeFBmME41dy8rZm9Fb2hLay90?=
 =?utf-8?B?UUpmdzNNNmw0dTgxSkk1SDZDRGFFaGxoK2liWXIxbDl4R1Z5eVp1Wk1pL044?=
 =?utf-8?B?Q3hTdm9pMXJ1WmNrcVY0cWNqZHd2UE9lK2RyQko2WjM2elpPN3dERHB3THJI?=
 =?utf-8?B?QkZJM2tYZVA1YU1Fa0wyK1pqNFpldEM4d3ZOc2NFeWtyeCs5VkVFV2R6bFlO?=
 =?utf-8?B?azNwZThodS9OYVRidTRPT25mM05BdnRVVWxneHRDdllyMUdiQkxrMjRNcG5I?=
 =?utf-8?B?YWtMRGJhelV6UU13UnFjdTVMLzNIUzZGdEdCMkNWWTR4UmVBc3RRY1M5cjhM?=
 =?utf-8?B?cHdaR2R5SzRrdW0reExTY1B5aXczQ1lFcEZ3cWhzdWw2VTdBdnB5dVpkUUd0?=
 =?utf-8?B?UzRJMS9Jd1o3bExkRUxSZitGTHJsOWRSTEpneldhOXh5L25YSmdXckgxdk5r?=
 =?utf-8?B?NG45MEJKZHpUdjdnd05GY0NqQkJObHViMWtLOGllYVdwTXRCSTNTRk5TOTBx?=
 =?utf-8?B?bE1QWXdYanZXS29RWXpUV1RrUkdqdGpYY0JWREVMZjkrblYyZTdia2ZURDNL?=
 =?utf-8?B?OEgwM3pSVHgrNDkyWDA1dXpJaFcwdytJWlgyeGRCYW4rZmREZllYUGdDTk5H?=
 =?utf-8?B?M0tqRGdraHhMSE1GUDNZMFM5cGlVNUdOQldKV1hxWXBvRmVEUnp3SUVJNDVX?=
 =?utf-8?B?bnpSSkk5aGdpU0ZydUpHQnYxUG9vMnJ3aGJSSEdnRTdQd3dQekU1eEdGTENG?=
 =?utf-8?B?VW1ldW9ZYjBSVDN2V0tXbU85SitNQWc0clR4ajVtRWpCanJHbVJRZXl2Q0hj?=
 =?utf-8?Q?gNNkIeXZNwrPjGyh9vnn8jwFFi9xYq4KdR4ogZm?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f72d39-d7c7-4427-b231-08d98f453e66
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 19:03:01.1182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZpb+zcjRLOUW4YNF0/AjUr/L7xUnlJmpsXba5R8KJsVchkwe+p9LnMfPKpfWu4HISFjqKIaPtYXo2xJr/OuVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6138
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gVGhpcyBwYXRjaCBpbnRyb2R1Y2VzIHZpcnR1YWwgaG9zdCBkcml2ZXIgb2YgZXh5bm9z
YXV0byB2OSB1ZnMgbUhDSS4NCj4gVkgoVmlydHVhbCBIb3N0KSBvbmx5IHN1cHBvcnRzIGRhdGEg
dHJhbnNmZXIgZnVuY3Rpb25zLiBTbywgbW9zdCBvZiBwaHlzaWNhbA0KPiBmZWF0dXJlcyBhcmUg
YnJva2VuLiBTbywgd2UgbmVlZCB0byBzZXQgYmVsb3cgcXVpcmtzLg0KPiAtIFVGU0hDRF9RVUlS
S19CUk9LRU5fVUlDX0NNRA0KPiAtIFVGU0hDRF9RVUlSS19TS0lQX1BIX0NPTkZJR1VSQVRJT04N
Ck9oIC0geW91IHNldCBpdCBoZXJlLg0KTWF5YmUganVzdCBhZGQgYSBjb21tZW50IGluIHlvdXIg
Y29tbWl0IGxvZyBvZiBwYXRjaGVzIDEgJiAyIHRoYXQgeW91IGFyZSBkb2luZyBpdCBsYXRlci4N
Cg0KPiBCZWZvcmUgaW5pdGlhbGl6YXRpb24sIHRoZSBWSCBpcyBuZWNlc3NhcnkgdG8gd2FpdCB1
bnRpbCBQSCBpcyByZWFkeS4NCj4gSXQncyBpbXBsZW1lbnRlZCBhcyBwb2xsaW5nIGF0IHRoZSBt
b21lbnQuDQo+IA0KPiBDYzogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0K
PiBDYzogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4NCj4gQ2M6IEtyenlzenRv
ZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAY2Fub25pY2FsLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogQ2hhbmhvIFBhcmsgPGNoYW5obzYxLnBhcmtAc2Ftc3VuZy5jb20+DQo+IC0tLQ0K
PiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9zLmMgfCA4NCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDg0IGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MuYyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLWV4eW5vcy5jIGluZGV4DQo+IDMyZjczYzkwNjAxOC4uYzJiNjU0MDI3YjBm
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MuYw0KPiArKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MuYw0KPiBAQCAtMTIxLDYgKzEyMSw4IEBADQo+ICAj
ZGVmaW5lIEhDSV9NSF9BTExPV0FCTEVfVFJBTl9PRl9WSCAgICAgICAgICAgIDB4MzBDDQo+ICAj
ZGVmaW5lIEhDSV9NSF9JSURfSU5fVEFTS19UQUcgICAgICAgICAgICAgICAgIDBYMzA4DQo+IA0K
PiArI2RlZmluZSBQSF9SRUFEWV9USU1FT1VUX01TICAgICAgICAgICAgICAgICAgICAoNSAqIE1T
RUNfUEVSX1NFQykNCj4gKw0KPiAgZW51bSB7DQo+ICAgICAgICAgVU5JUFJPX0wxXzUgPSAwLC8q
IFBIWSBBZGFwdGVyICovDQo+ICAgICAgICAgVU5JUFJPX0wyLCAgICAgIC8qIERhdGEgTGluayAq
Lw0KPiBAQCAtMTQwMyw2ICsxNDA1LDY4IEBAIHN0YXRpYyBpbnQgZXh5bm9zX3Vmc19yZXN1bWUo
c3RydWN0IHVmc19oYmEgKmhiYSwNCj4gZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+ICAgICAgICAg
cmV0dXJuIDA7DQo+ICB9DQo+IA0KPiArc3RhdGljIGludCBleHlub3NhdXRvX3Vmc192aF9saW5r
X3N0YXJ0dXBfbm90aWZ5KHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbnVtDQo+ICt1ZnNfbm90aWZ5X2NoYW5n
ZV9zdGF0dXMgc3RhdHVzKSB7DQo+ICsgICAgICAgaWYgKHN0YXR1cyA9PSBQT1NUX0NIQU5HRSkg
ew0KPiArICAgICAgICAgICAgICAgdWZzaGNkX3NldF9saW5rX2FjdGl2ZShoYmEpOw0KPiArICAg
ICAgICAgICAgICAgdWZzaGNkX3NldF91ZnNfZGV2X2FjdGl2ZShoYmEpOw0KPiArICAgICAgICAg
ICAgICAgaGJhLT53bHVuX2Rldl9jbHJfdWEgPSB0cnVlOw0Kd2x1bl9kZXZfY2xyX3VhIG5vIGxv
bmdlciBleGlzdHMgLSBuZWVkcyByZWJhc2UNCg0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAg
IHJldHVybiAwOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IGV4eW5vc2F1dG9fdWZzX3ZoX3dh
aXRfcGhfcmVhZHkoc3RydWN0IHVmc19oYmEgKmhiYSkgew0KPiArICAgICAgIHUzMiBtYm94Ow0K
PiArICAgICAgIGt0aW1lX3Qgc3RhcnQsIHN0b3A7DQo+ICsNCj4gKyAgICAgICBzdGFydCA9IGt0
aW1lX2dldCgpOw0KPiArICAgICAgIHN0b3AgPSBrdGltZV9hZGQoc3RhcnQsIG1zX3RvX2t0aW1l
KFBIX1JFQURZX1RJTUVPVVRfTVMpKTsNCj4gKw0KPiArICAgICAgIGRvIHsNCj4gKyAgICAgICAg
ICAgICAgIG1ib3ggPSB1ZnNoY2RfcmVhZGwoaGJhLCBQSDJWSF9NQk9YKTsNCj4gKyAgICAgICAg
ICAgICAgIGlmICgobWJveCAmIE1IX01TR19NQVNLKSA9PSBNSF9NU0dfUEhfUkVBRFkpDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAwOw0KTWF5YmUgYWRkIGEgY29tbWVudCBoZXJl
IHRoYXQgdGhlIG1ib3ggcHJvdG9jb2wgd2lsbCBiZSBkZWZpbmVkIGxhdGVyLg0KDQpUaGFua3Ms
DQpBdnJpDQo+ICsNCj4gKyAgICAgICAgICAgICAgIHVzbGVlcF9yYW5nZSg0MCwgNTApOw0KPiAr
ICAgICAgIH0gd2hpbGUgKGt0aW1lX2JlZm9yZShrdGltZV9nZXQoKSwgc3RvcCkpOw0KPiArDQo+
ICsgICAgICAgcmV0dXJuIC1FVElNRTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBleHlub3Nh
dXRvX3Vmc192aF9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpIHsNCj4gKyAgICAgICBzdHJ1Y3Qg
ZGV2aWNlICpkZXYgPSBoYmEtPmRldjsNCj4gKyAgICAgICBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpwZGV2ID0gdG9fcGxhdGZvcm1fZGV2aWNlKGRldik7DQo+ICsgICAgICAgc3RydWN0IGV4eW5v
c191ZnMgKnVmczsNCj4gKyAgICAgICBpbnQgcmV0Ow0KPiArDQo+ICsgICAgICAgdWZzID0gZGV2
bV9remFsbG9jKGRldiwgc2l6ZW9mKCp1ZnMpLCBHRlBfS0VSTkVMKTsNCj4gKyAgICAgICBpZiAo
IXVmcykNCj4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsgICAgICAg
LyogZXh5bm9zLXNwZWNpZmljIGhjaSAqLw0KPiArICAgICAgIHVmcy0+cmVnX2hjaSA9IGRldm1f
cGxhdGZvcm1faW9yZW1hcF9yZXNvdXJjZV9ieW5hbWUocGRldiwNCj4gInZzX2hjaSIpOw0KPiAr
ICAgICAgIGlmIChJU19FUlIodWZzLT5yZWdfaGNpKSkgew0KPiArICAgICAgICAgICAgICAgZGV2
X2VycihkZXYsICJjYW5ub3QgaW9yZW1hcCBmb3IgaGNpIHZlbmRvciByZWdpc3RlclxuIik7DQo+
ICsgICAgICAgICAgICAgICByZXR1cm4gUFRSX0VSUih1ZnMtPnJlZ19oY2kpOw0KPiArICAgICAg
IH0NCj4gKw0KPiArICAgICAgIHJldCA9IGV4eW5vc2F1dG9fdWZzX3ZoX3dhaXRfcGhfcmVhZHko
aGJhKTsNCj4gKyAgICAgICBpZiAocmV0KQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIHJldDsN
Cj4gKw0KPiArICAgICAgIHVmcy0+ZHJ2X2RhdGEgPSBkZXZpY2VfZ2V0X21hdGNoX2RhdGEoZGV2
KTsNCj4gKyAgICAgICBpZiAoIXVmcy0+ZHJ2X2RhdGEpDQo+ICsgICAgICAgICAgICAgICByZXR1
cm4gLUVOT0RFVjsNCj4gKw0KPiArICAgICAgIGV4eW5vc191ZnNfcHJpdl9pbml0KGhiYSwgdWZz
KTsNCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgc3RydWN0
IHVmc19oYmFfdmFyaWFudF9vcHMgdWZzX2hiYV9leHlub3Nfb3BzID0gew0KPiAgICAgICAgIC5u
YW1lICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAiZXh5bm9zX3VmcyIsDQo+ICAgICAgICAg
LmluaXQgICAgICAgICAgICAgICAgICAgICAgICAgICA9IGV4eW5vc191ZnNfaW5pdCwNCj4gQEAg
LTE0MTcsNiArMTQ4MSwxMiBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMNCj4g
dWZzX2hiYV9leHlub3Nfb3BzID0gew0KPiAgICAgICAgIC5yZXN1bWUgICAgICAgICAgICAgICAg
ICAgICAgICAgPSBleHlub3NfdWZzX3Jlc3VtZSwNCj4gIH07DQo+IA0KPiArc3RhdGljIHN0cnVj
dCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVmc19oYmFfZXh5bm9zYXV0b192aF9vcHMgPSB7DQo+ICsg
ICAgICAgLm5hbWUgICAgICAgICAgICAgICAgICAgICAgICAgICA9ICJleHlub3NhdXRvX3Vmc192
aCIsDQo+ICsgICAgICAgLmluaXQgICAgICAgICAgICAgICAgICAgICAgICAgICA9IGV4eW5vc2F1
dG9fdWZzX3ZoX2luaXQsDQo+ICsgICAgICAgLmxpbmtfc3RhcnR1cF9ub3RpZnkgICAgICAgICAg
ICA9IGV4eW5vc2F1dG9fdWZzX3ZoX2xpbmtfc3RhcnR1cF9ub3RpZnksDQo+ICt9Ow0KPiArDQo+
ICBzdGF0aWMgaW50IGV4eW5vc191ZnNfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRl
dikgIHsNCj4gICAgICAgICBpbnQgZXJyOw0KPiBAQCAtMTQ4NSw2ICsxNTU1LDE4IEBAIHN0YXRp
YyBzdHJ1Y3QgZXh5bm9zX3Vmc19kcnZfZGF0YQ0KPiBleHlub3NhdXRvX3Vmc19kcnZzID0gew0K
PiAgICAgICAgIC5wb3N0X3B3cl9jaGFuZ2UgICAgICAgID0gZXh5bm9zYXV0b191ZnNfcG9zdF9w
d3JfY2hhbmdlLA0KPiAgfTsNCj4gDQo+ICtzdGF0aWMgc3RydWN0IGV4eW5vc191ZnNfZHJ2X2Rh
dGEgZXh5bm9zYXV0b191ZnNfdmhfZHJ2cyA9IHsNCj4gKyAgICAgICAudm9wcyAgICAgICAgICAg
ICAgICAgICA9ICZ1ZnNfaGJhX2V4eW5vc2F1dG9fdmhfb3BzLA0KPiArICAgICAgIC5xdWlya3Mg
ICAgICAgICAgICAgICAgID0gVUZTSENEX1FVSVJLX1BSRFRfQllURV9HUkFOIHwNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFVGU0hDSV9RVUlSS19TS0lQX1JFU0VUX0lOVFJf
QUdHUiB8DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBVRlNIQ0RfUVVJUktf
QlJPS0VOX09DU19GQVRBTF9FUlJPUiB8DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBVRlNIQ0lfUVVJUktfQlJPS0VOX0hDRSB8DQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBVRlNIQ0RfUVVJUktfQlJPS0VOX1VJQ19DTUQgfA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgVUZTSENEX1FVSVJLX1NLSVBfUEhfQ09ORklHVVJBVElPTiB8
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBVRlNIQ0RfUVVJUktfU0tJUF9E
RUZfVU5JUFJPX1RJTUVPVVRfU0VUVElORywNCj4gKyAgICAgICAub3B0cyAgICAgICAgICAgICAg
ICAgICA9IEVYWU5PU19VRlNfT1BUX0JST0tFTl9SWF9TRUxfSURYLA0KPiArfTsNCj4gKw0KPiAg
c3RhdGljIHN0cnVjdCBleHlub3NfdWZzX2Rydl9kYXRhIGV4eW5vc191ZnNfZHJ2cyA9IHsNCj4g
ICAgICAgICAudWljX2F0dHIgICAgICAgICAgICAgICA9ICZleHlub3M3X3VpY19hdHRyLA0KPiAg
ICAgICAgIC5xdWlya3MgICAgICAgICAgICAgICAgID0gVUZTSENEX1FVSVJLX1BSRFRfQllURV9H
UkFOIHwNCj4gQEAgLTE1MTIsNiArMTU5NCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2
aWNlX2lkDQo+IGV4eW5vc191ZnNfb2ZfbWF0Y2hbXSA9IHsNCj4gICAgICAgICAgIC5kYXRhICAg
ICAgID0gJmV4eW5vc191ZnNfZHJ2cyB9LA0KPiAgICAgICAgIHsgLmNvbXBhdGlibGUgPSAic2Ft
c3VuZyxleHlub3NhdXRvdjktdWZzIiwNCj4gICAgICAgICAgIC5kYXRhICAgICAgID0gJmV4eW5v
c2F1dG9fdWZzX2RydnMgfSwNCj4gKyAgICAgICB7IC5jb21wYXRpYmxlID0gInNhbXN1bmcsZXh5
bm9zYXV0b3Y5LXVmcy12aCIsDQo+ICsgICAgICAgICAuZGF0YSAgICAgICA9ICZleHlub3NhdXRv
X3Vmc192aF9kcnZzIH0sDQo+ICAgICAgICAge30sDQo+ICB9Ow0KPiANCj4gLS0NCj4gMi4zMy4w
DQoNCg==
