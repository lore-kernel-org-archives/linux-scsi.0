Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2EBC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 06:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63AAD61054
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 06:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhG2Gsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 02:48:30 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26620 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhG2Gs3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 02:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627541307; x=1659077307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uvvpM1ka/CeGJnwf3+nn7IERDg1Ox5p1KNv+FQwIy6A=;
  b=V227hR6ZyMylzGHU0D7T1CBRlvWlYK2uK+i2ryMeSSMiU/BX3Czi3HY0
   8PuuPL7EEHreoPTdlQIrFAAseQDkkluVRnAYa4bTN9p8l7Wusn4yu2c6f
   j54RNG9W0/hrLiIZ/mtS9hVK4wf5cDGrwCwF/22ZfnjNcTw+eROEX1UbJ
   swSJSb8yqK0GF9hjZegtWY0cNAaYcqzeOEcMsSuNHfCPQ5YaoHaq2o72c
   bg4tmke9JwJmGNMJUaZnZQPzH98AMjhn8eR0FRWV0ra5uuf/iUzM+px2E
   XkuQiftoaHP1PndRTAaJeH5X0kLMz14Lz35Yvb08Sn9biZe8tYsELoBmY
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,278,1620662400"; 
   d="scan'208";a="287327913"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2021 14:48:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvAA3L8+wINKMZMCfhryHh8tzgaAtY4BhpE/8UnV1E/ASpOylzeEtY2Mi1UtkipMXPJBWfbAgoWs9OKBNCn/pRNf2lpSs4nA/6kAltY1pDAGxmDRhN/QLa6t36zqtrlvr9ll+L/m3F2+MiLQOi3sWowxtfF8trCT45sCYwlmOPn46Ex0TcKnVMjYkL5ArVapvmuCpcaVNdH/s4GqrDOatar6OkeZSzOfhBKxDkJ4gbiZvLL3m0K8EeZRFEOVYLHk5QkKRF4Nt7DkZmSwoFU4i+zJEbyLON1/KgAdhqEOT6iZfSGrS2hOsTYtxpcP0KleHV2ni5KX1WQjv5BvHQKkdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvvpM1ka/CeGJnwf3+nn7IERDg1Ox5p1KNv+FQwIy6A=;
 b=SeMXITXZgU6Jq33VsVXkcpMZ4VYUlY3YSQDYNQ/yk+pjFVEMob982HRoft91H5t4NT1/Bvnzfm6MB8IvWMbjiipl1Z+EK5JAI5PdgWtZ53oqqw/WTKVSzybROVXJAxPQDWz++KLnHFa8cW6yy3hpJntzOT3+F+Rpcvv0Sn5oI/PelRstV4c0q9Mr9yHHcujvKZRkSNmlyq14gJgAuyZeDvbmT3d7Ha9/Ngk24Ev8cSEsOt+ClV+OkZYUxPSyQyK+BPJ7mqI7hZmZeeXOYj+VFJzZq4fRc0s1IwMA2QA39tTPdP9KBtGPQ00WVnIEM9Dl8I/IZW8b3p7/6xRtpbkEkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvvpM1ka/CeGJnwf3+nn7IERDg1Ox5p1KNv+FQwIy6A=;
 b=zGU7VEdno0NZpBs67UmmIr5NLXSNR/xl5dmtsoIbv1zVcGK5EEP/HbST4FODnIEX0YJIN6IRMPZZwkLw9mFh0R/DXyNXcBIKgOhbudTysu5W2CZdAknvlk/8YCQX4wXk62lL2yOwx6ESe1tefuLdzp8VC/YxxOHkehOiM4iYLx0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5355.namprd04.prod.outlook.com (2603:10b6:5:101::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.29; Thu, 29 Jul 2021 06:48:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 06:48:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Vincent Palomares <paillon@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Bjorn Helgaas <bhelgaas@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: RE: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
Thread-Topic: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
Thread-Index: AQHXg0/zB35JV1w98kepLuUOEdMo5KtZg7bw
Date:   Thu, 29 Jul 2021 06:48:24 +0000
Message-ID: <DM6PR04MB6575579560F7CB1B71103F28FCEB9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210728012743.1063928-1-paillon@google.com>
In-Reply-To: <20210728012743.1063928-1-paillon@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 076c5cbc-c292-4e71-1264-08d9525cdcb0
x-ms-traffictypediagnostic: DM6PR04MB5355:
x-microsoft-antispam-prvs: <DM6PR04MB535582F5FA54708C182FA4ADFCEB9@DM6PR04MB5355.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /G06w3TvRTguOvaNKBUMldA2h5S8j8mANs6u8Z7WVKDqhBqhaKgLcQodxNqqokcvhNMfKBufDTwYOIUH0sI8TtMhkb34YSaiVt+7bNpxhLRlARE8KND9eowA+Pfbckg8y6kw38fNF34UoLVexHsCoHhF6ouz0P3hYVvvqGg4Ewl0GPyfs2e0I+K4BEm1DZAZAD/rsfDBSWhOqUgubuF5MILWuEP8NKwIoto6O+eDPU/nn4HztkzxwpX6nwI/52yKyH0aAQNKIN2tSVY+YPbab3Nt6iEwIA23hV5FctjFvj2WQhgoGma7Kfgat+YNiPTkyv5X0cimND86yMBg2sW7mt4m+VDkUF5gwxOLZyPxZFzs3PMkBdpVIu+BK0BTOZLu1WM5TXvQQdvul87Bp0gt9iNmvLdnVM4e+xfByg5JCeI00NzhC0BS2GxN6bVPoO/54xMsiR3Sbb6bgiAyem4rBAssewtgpppK1sVKuirK6AKp/wY2MVm+ZNa6XxwqCqiZ2kDrlszGf4Go6kNC7A7g4iIGhjkYI0q2raOwtMZaQduSh44dmbD0yVJogE5tPRiCNhKxFPnqkrNKbVU3/cETjmHTnzEycZSLcderf52FYYW6qcOGArIys2mIbhVRT0PLkEKSqp9rtPCmWZIpJAKaUPiw/ZQCmy4OO4sjqwbQUo6EUdryc0nricAZvjSoRjXbEJFJVwE8MQkyEbzQUrxV2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(7416002)(122000001)(38070700005)(83380400001)(71200400001)(7696005)(86362001)(26005)(38100700002)(9686003)(5660300002)(186003)(52536014)(33656002)(54906003)(55016002)(76116006)(66946007)(64756008)(66446008)(6506007)(66556008)(66476007)(2906002)(15650500001)(316002)(8936002)(8676002)(110136005)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzhjMFNreWh5TUFrNzFGV0ZNZG9vVWJvaFJ3d0FzTHpnczRUd2F1RVEzeEJX?=
 =?utf-8?B?K2VzdUVESWE0Y2JEZWVPbFRoNWgzUjI0aDFZOXJhSGs4RnhVZlo4TkZFc1Nm?=
 =?utf-8?B?ZGwyd1RwdmUzS2tmRnlybGxhbkVZdzVDb2hyNFBHU2VBbmVmUzNNNVJWSGFR?=
 =?utf-8?B?b0ZrTlVtRmVSaXVvZWY2VzIvT1ZJeWpGdE9OQ1lzREpneDQ4aGlRUmNpRFNS?=
 =?utf-8?B?bWx0cVkzaFc0VEdNUkRoSFQyVCtPbDE3Y2V3VFFmUXYwdDN5RmhGN1o5Rml6?=
 =?utf-8?B?UExZRXh5a05BQTI5WDlXdjEvUGo3dWV5aE85dklBRExWclhqWWJxZjRJa0xY?=
 =?utf-8?B?Wk1wQiswMlZudlRXQ1BrZndFNFNvaU1PbTNKNnAyclFLa2NxV1BjUTR5Q3h1?=
 =?utf-8?B?emhTUFlQSGI0WTUwWmpidXZnWW1CdDQ1RS9LNUgra1NCblJGL0xKa0Nra0Fx?=
 =?utf-8?B?Uy9zN2NEdlhYNWIwYWNBV1lxRzBaRGJFc25rMkt4RHBIbW9kcVFGeGhjWUJo?=
 =?utf-8?B?MCtoM3FCMk1DMHZRQTZBRHI4Z2RTa3B2U0xyeWtXcTVHbGcydGIvRXVuZVls?=
 =?utf-8?B?akVUUTlEbjBpakdzOVdyR2xPL0FDeG5HcXREaTJMTFFmWHZnQzc3WnNaQy9W?=
 =?utf-8?B?RmtoVTVpVm1RcHZrSVpzZVVmWkt1blN2azkwMkk3L2FJZzBkdXdnL2oxb1Fx?=
 =?utf-8?B?UjBGWDJuYUdreW8zc1M1RWlZK1Jxd3h6bnRxanBvbGk3WEhSOXpCc2hsaWhT?=
 =?utf-8?B?MENob2VZanFyRG1YeHhPZEpOSjgrVEF5bVpyTGhTQnJ1RWR4akpXN1kya2Ew?=
 =?utf-8?B?TWl2dlVqNjMzeVFwdnZISzVEWTVqMTZoVnByM0QyU0ZuNG8rTmVueVY4L3B3?=
 =?utf-8?B?QytOTkNMNEVMZU5yOE8rbEFIZzQ5Z0VGVUpkQU9hdE1wOUh4NERSVnNGTmtU?=
 =?utf-8?B?MGNhNFpqWDN6Z2QxMVoyeWtjV3BzUUtpNEtZUlhZWVlLeE9rYTVud2lvdWJk?=
 =?utf-8?B?d2JHdVErZEUyQk9PQjFaYkFiKzZkUjVUYjNKcG5xRS82Y3NvaFp4akJlbWdX?=
 =?utf-8?B?SGxkQjc4WGd5eUoyQ3ZpVEVxbk5sU3JHOU53c1llTU83Wmt1ZlN0M0VsbG1n?=
 =?utf-8?B?QXhiOEtXVTdwYlRkSUJHeklnVkVUNjZ2UUMvT2YydURWM25acUtUMEhuU1lY?=
 =?utf-8?B?VkxYZDlzSjg1bnI5NkZtd0pkRWo4bm9QYTBXMGduRWJvRGV1RzVsMmFTWXZ4?=
 =?utf-8?B?aFNPcFZmaUVPZEhrL1NUSXJlTFNoUW8ycHl4VzlkQnhLNGJ3aFRQTlpodW1G?=
 =?utf-8?B?aDNvRjF5THVvNmFZcFRhaVBkN3dlbFJISkVyMGhFVWxCVVNuR3JGV0ZFZi8r?=
 =?utf-8?B?ZThWUzZCU0Y4Vlk5VjlRMXE0WHpIVkJmRXhOMUhjOC9kOTQ3ODVYOVVVMEEx?=
 =?utf-8?B?Nng0V21nSXR6L3VnNkx4UEpYSzlYRjhRSG1PWnNRd1MxTlROdnMzVVlYL1VM?=
 =?utf-8?B?clFtV3pGdzBkV1ZxOWNYR2pvZWlRUCtPOGZ4bTdJeThtLzhWd21tWjA5VGk2?=
 =?utf-8?B?OXlyc05UdGd0dU1xL1pIYktVLzBNbEdUdUk3My9NOHBjZ0hOeUhqaEtkekVs?=
 =?utf-8?B?NUdnVXZ6a3pVRlNjSitqbmt3M2cvbml6SXp0LzRYTU0yamV3TGQvY05Nc1VJ?=
 =?utf-8?B?akNZclpYUkZVazNOR3UvM2JVMTgxZFYzeThUTEpsT2VBMGdoM203eEYwdTgw?=
 =?utf-8?Q?/WM8XsRWWHFfcY8t+NS3beqzuXdf+n+rEnEr0IR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076c5cbc-c292-4e71-1264-08d9525cdcb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2021 06:48:24.1356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WnLjXYvT2s4c0NYAlSJWftdxbCvdJ98XxmDgVnlxx3aH8iylvQZsNDCEYk8YUZT2ShVPcvqs0J2MCG90T3F04Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5355
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBBbGxvdyBVRlMgc3VzcGVuZC9yZXN1bWUgY2FsbGJhY2tzIHRvIHJ1biBpbiBwYXJhbGxl
bCB3aXRoIG90aGVyDQo+IHN1c3BlbmQvcmVzdW1lIGNhbGxiYWNrcy4gVGhpcyBjYW4gcmVjb3Vw
IGRvemVucyBvZiBtaWxsaXNlY29uZHMgb24gdGhlDQo+IHJlc3VtZSBwYXRoIGlmIFVGUyBoYXJk
d2FyZSBuZWVkcyB0byBiZSBwb3dlcmVkIGJhY2sgb24uDQo+IA0KPiBTdXNwZW5kaW5nIGFuZCBy
ZXN1bWluZyBhc3luY2hyb25vdXNseSBpcyBzYWZlIHRvIGRvIHNvIGxvbmcgYXMgdGhlIGRyaXZl
cg0KPiBjYWxsYmFja3Mgb25seSBkZXBlbmQgb24gcmVzb3VyY2VzIG1hZGUgYXZhaWxhYmxlIGJ5
IGVpdGhlciBhKSBwYXJlbnQNCj4gZGV2aWNlcyBvciBiKSBkZXZpY2VzIGV4cGxpY2l0bHkgbWFy
a2VkIGFzIHN1cHBsaWVycyB3aXRoIGRldmljZV9saW5rX2FkZC4NCj4gDQo+IENjOiBCam9ybiBI
ZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPg0KPiBDYzogSmFlZ2V1ayBLaW0gPGphZWdldWtA
a2VybmVsLm9yZz4NCj4gQ2M6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0K
PiBDYzogQWRyaWFuIEh1bnRlciA8YWRyaWFuLmh1bnRlckBpbnRlbC5jb20+DQo+IENjOiBTdGFu
bGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiBDYzogQ2FuIEd1byA8Y2FuZ0Bj
b2RlYXVyb3JhLm9yZz4NCj4gQ2M6IEFzdXRvc2ggRGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9y
Zz4NCj4gQ2M6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiBDYzogTWFydGlu
IEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogVmluY2VudCBQYWxvbWFyZXMgPHBhaWxsb25AZ29vZ2xlLmNvbT4NCj4gLS0tDQo+IA0KPiBB
cmUgdGhlcmUgYW55IHN1c3BlbmQvcmVzdW1lIGRlcGVuZGVuY2llcyBmb3IgVUZTIGRyaXZlcnMg
bm90IHRyYWNrZWQgYnkNCj4gdGhlIGRldmljZSBwYXJlbnQgcmVsYXRpb25zaGlwPw0KPiANCj4g
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gaW5kZXggYjg3ZmY2OGFhOWFhLi45ZWM1YzMw
OGEwZWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gKysrIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBAQCAtOTYyNSw2ICs5NjI1LDcgQEAgaW50IHVm
c2hjZF9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHZvaWQgX19pb21lbQ0KPiAqbW1pb19iYXNl
LCB1bnNpZ25lZCBpbnQgaXJxKQ0KPiAgICAgICAgIGFzeW5jX3NjaGVkdWxlKHVmc2hjZF9hc3lu
Y19zY2FuLCBoYmEpOw0KPiAgICAgICAgIHVmc19zeXNmc19hZGRfbm9kZXMoaGJhLT5kZXYpOw0K
PiANCj4gKyAgICAgICBkZXZpY2VfZW5hYmxlX2FzeW5jX3N1c3BlbmQoZGV2KTsNCj4gICAgICAg
ICByZXR1cm4gMDsNCklzbid0IGRldmljZV9lbmFibGVfYXN5bmNfc3VzcGVuZCBpcyBiZWluZyBj
YWxsZWQgZm9yIGVhY2ggbHVuIGluIHNjc2lfc3lzZnNfYWRkX3NkZXYgQW55d2F5Pw0KDQpUaGFu
a3MsDQpBdnJpDQo+IA0KPiAgZnJlZV90bWZfcXVldWU6DQo+IC0tDQo+IDIuMzIuMC40MzIuZ2Fi
YjIxYzcyNjMtZ29vZw0KDQo=
