Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181E0C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 12:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D48EA2074B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 12:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nIWqLRIJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rXMAAESQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGIMG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:06:28 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44729 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgGIMG2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 08:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594296387; x=1625832387;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=hmCUAWIMsHmzHC7kh+qnKU0xkVCZ16s6V1PNCmVL/Q4=;
  b=nIWqLRIJqiXXRrF/jQ9LCrEyCgghw7V9BPwCb8gsM8ARcuZVKsJdu6Ac
   A+5NScc1TVZ+eomGv576nt5XgxD+h8b1UD5q7woHggnPaona62UUk4Ped
   ykELODS9g0Zug5dEbvom5cap0WvNR+BfgjT38idRlYhQn4BPpuMK16fl5
   am6e5NB94sHj7n4MfBxAfmEitXdCDGxJ2q6mO16RXA5ctmn2jRj9SC3Mt
   eh/xDWZds8sjv0jMESuulBu0oAHQvcVGxsvz1oL2npNpM7h/YKojXQfBu
   ADDW/TfJFP6N6QzVXf6H5uimxrIJLt1M5KwtdoVu7wXU7V+FXIQ4wAQ9w
   w==;
IronPort-SDR: DfYECDvBKncKfy/IWqrKegeCn4nWMCyqhTLbHtg2utpGQJhxP+Urw373ziHoQXudSZ38+SddKH
 d2vnrJceTDCxQLJikpSb77KJnul9rsMcDuZfgfyOHi/Qk2UhkHby/HoYK+RghUogsSElwD0H8x
 X5rYsGguJ797eeZRwXZ6nRJGvplci5r4Jo4+u0f/DyqM2/5ec5X/Ke+HPFZBFFq0QB3+DypoSi
 m7DL9Pm3WTdlSA7SZnvh99SBTuWm//OkeAJD+P8Ga/aj1jkADap0JyFps1Qe+r9cDAlgkINjxe
 3ik=
X-IronPort-AV: E=Sophos;i="5.75,331,1589212800"; 
   d="scan'208";a="143341768"
Received: from mail-sn1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.52])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 20:06:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TiI78nvoXL1eM0v0xaazjxsTW/XWPdwUh+CUNS1bIVRu6oULiyk+iwD0RJWaZW4N5wj9lh1XiMAAxwxGFA17nIPYD0RZNbojhGWllB2taMsVEq6XcwAanugaMp0Ffo0c5dJtsRAB0pCMzDb1mYXdNEu3LyLT0hzWrx7G81pygIPRndIdGt6/kWvB+fdQQ7buGgwoAwnbxyTI5fti/ADVgewDbBY1OfajPLsiC5aHUJBzpQJ/9wBFaGZSEMH+sot1tK8lBndDOz04sxiiOnaKOQdwih5VTo8SSn4ezwjcGlKWLKudZNL59lqaevlq71JJ8QM2vgg17bSfbZ840VC/rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmCUAWIMsHmzHC7kh+qnKU0xkVCZ16s6V1PNCmVL/Q4=;
 b=hCgFIp5dy6iym1XVzKqY0txI4IeyuC6WsF9gSomWhitmmKAXRs7D8IfARn+UnUNSi5CeizFnEQcOKbzi5XZMO0zX1DEu7TDBb+DdupWfsUrI02WsArW06pVApT9nzA0+a38DnO52XlD/Mn3nZDr18Xta2ehTieiZoJUy0vqm+y0f0TkpkvtCEqVVPLYbpwGBFRfW2W/nO6vrKvr4JU7398mEGkDi9wLXDU8qpJ8T4RpWgw8nSlEFn6920tO+ue6bBNFy4Y+uJr/yLMkGCodZr/x8ET6CZ5bVQU7VGwcspEK6LipLkY6e837NfcLzbO8521fgpiXuK/LMhOZcC2P28g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmCUAWIMsHmzHC7kh+qnKU0xkVCZ16s6V1PNCmVL/Q4=;
 b=rXMAAESQ2/9zSren58pcFFo0Xfy0NZQ1hUq1xhcHgPZ6INthxi50b9y4JObqzC9Xb/3WK3f8lm/SBo/w7b5qC3V91SyCxG81nwZ8A9iVL2z7Ccs72os5m+Hlq28eunpSJ+B9LwfBo8nvD9GWZN0eQtz+0qbEWpbKAWt3vLpmVLo=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BY5PR04MB6405.namprd04.prod.outlook.com (2603:10b6:a03:1ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 12:06:23 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 12:06:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [RESEND RFC PATCH v4 1/3] ufs: introduce a callback to get info
 of command completion
Thread-Topic: [RESEND RFC PATCH v4 1/3] ufs: introduce a callback to get info
 of command completion
Thread-Index: AQHWVM/3KerxIYQozkGFgwHyn0oHvqj/KCdg
Date:   Thu, 9 Jul 2020 12:06:23 +0000
Message-ID: <BYAPR04MB4629BA9BFCD4C40BCB9EB920FC640@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023155epcas2p3ac30e4b0c24855e0a3466126bba9c612@epcas2p3.samsung.com>
 <89b90646c310fb0048701f219eb23c4b35ef7dcf.1594174981.git.kwmad.kim@samsung.com>
In-Reply-To: <89b90646c310fb0048701f219eb23c4b35ef7dcf.1594174981.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7bd3c7db-019c-4655-edca-08d824007ff9
x-ms-traffictypediagnostic: BY5PR04MB6405:
x-microsoft-antispam-prvs: <BY5PR04MB6405B53AAE3197F26F96D957FC640@BY5PR04MB6405.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tEX/GelaUbRHQ/VBBQ0W3hun+dgw/mv+Ry7RHZmZeo9xFBZkgPazCom5BleLIMlNia0BfHWxSeqWGkijGSviSh2URWhaQewpWFSwSfYBlmb9k/d6m4nCRAIjFpbKPaeVhMOGffbBAMmhMslnQCfV0zob2anGWiMBvFjq54BEsAKh4T895vRCjMFJJoQkpcYi7Xh35LYmJ5tzUjB3ropVscg8u9zEHJhvUuC4VLsc7fIW1wpHkWjQwLHPkAPMKMRwUSHcaIXaKhVzg9kfbcHIXz+R1hLTSLkaoh45q5HPB9nweEFrDw4K5QK/9kKJp9vCUHkr27rYHCNFsQVMoy9vyxSxrkSa6eDJX4PIwgo84IZHSyrxb63p9vMrNOehwA9z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(110136005)(186003)(7416002)(6506007)(8936002)(33656002)(76116006)(86362001)(9686003)(83380400001)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(71200400001)(4744005)(52536014)(26005)(8676002)(2906002)(55016002)(7696005)(316002)(5660300002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: l6bxYoWNfam35HvV3LIVJCpYaisfV4n0COmtrohHlwpVikMfNd1Quut9vjBsmuv7ORFvwje0H6MBzZgg3eDnD0Cb3a11CL1axybNPjhb5CfpmhkvQDWgBoFL22XM6SK1lEd0mGJ9ZEgC5DsGyJl6CZB9PIuYxagP8L75Ca6aHBy3hnFrPpvJIpjeWfZibDix5XXTzN7sb8IUr0ALea32RO5y3wfTNMuF2eVaeB+bQwVGV3F/9KAH5KVmibcETKaLVooj4Dy8CF0tWbMRWaTwu34JLr8GCKeFCmOCIQVYr9MVeIJpAoFWJOKkzeoO8R0TiuQ5gxQj0DAEdEQz4pdjIoNUiywwovTb4Wb9N9G7BNaO42ARFcohHcj3Dw5Ca65YLziJkdOJci/qCgV76VRvjHc7RjiFrN4QsyKfiWUYSJq7fLHAeqst4qMCb1qX1JDg3WLqAk1aursyMoqi6q2WWdsE2PhGHkmDHQYzfwU5pyKeEBtlvEl+r3x9L+er7aFm
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4629.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd3c7db-019c-4655-edca-08d824007ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 12:06:23.7811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3RED3tRccIgNzliug+HTGVVAe9TVouilNphzkJVHXLUZi8GpDadDfO/OUngilZERHISuhATGgua5TnobVB2T4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6405
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gU29tZSBTb0Mgc3BlY2lmaWMgbWlnaHQgbmVlZCBjb21tYW5kIGhpc3RvcnkgZm9y
DQo+IHZhcmlvdXMgcmVhc29ucywgc3VjaCBhcyBzdGFja2luZyBjb21tYW5kIGNvbnRleHRzDQo+
IGluIHN5c3RlbSBtZW1vcnkgdG8gY2hlY2sgZm9yIGRlYnVnZ2luZyBpbiB0aGUgZnV0dXJlDQo+
IG9yIHNjYWxpbmcgc29tZSBEVkZTIGtub2JzIHRvIGJvb3N0IElPIHRocm91Z2hwdXQuDQo+IA0K
PiBXaGF0IHlvdSB3b3VsZCBkbyB3aXRoIHRoZSBpbmZvcm1hdGlvbiBjb3VsZCBiZQ0KPiB2YXJp
YW50IHBlciBTb0MgdmVuZG9yLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0gPGt3
bWFkLmtpbUBzYW1zdW5nLmNvbT4NCj4gQWNrZWQtQnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNo
dUBtZWRpYXRlay5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdk
Yy5jb20+DQoNCkl0IHdpbGwgcmVxdWlyZSBhbm90aGVyIHNwaW4gaG93ZXZlciwgYmVjYXVzZSB5
b3UnbGwgbmVlZCB0byByZWJhc2UgaXQNCkFmdGVyIFN0YW5sZXkncyAoc2NzaTogdWZzOiBGaXgg
YW5kIHNpbXBsaWZ5IHNldHVwX3hmZXJfcmVxIHZvcCBhbmQgcmVxdWVzdCdzIGNvbXBsZXRpb24g
dGltZXN0YW1wKQ0KSXMgYWNjZXB0ZWQuDQoNClRoYW5rcywNCkF2cmkNCg==
