Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6C9C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82BEA207C3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 06:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AdNAo+Cu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gfx9nI63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgFKGna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 02:43:30 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34228 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgFKGn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 02:43:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591857825; x=1623393825;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1uMbxC17ptv9jb+cKwTpxj9uV4PB1CB8VQM/xqiI0zY=;
  b=AdNAo+Cuusum1xsY9YNk6aqERXCm7jggqSBYojkV59RFTsEMG4DwIKM5
   gRTFR/2JatEAWeq6h14Ks2DytijgdiKCrC2ff4/A21t9nrlfUmQrB2mJg
   X/gj5nIKsWoB0yTkuSu/VMI495xUhVvpLloX1eBlJ9EL3tYpMy1foqjn9
   am+JvHTiT22Tvx9tL1MWplH4tlzziMlkaZfBTyWSzkH1XqmdvcOwWjrtJ
   0fhiPYzmR5TXKuqtU5zC/ZDZGGtXn6u55cNdhzAyx7PjgvNDZOkeINr04
   B0OjC//CDCCX/AAwYslfDYD22earFZgNRvvJmcsJsO+JZFZMI5J9s7zDH
   w==;
IronPort-SDR: DqSMCSvzxo6LqjkeRedUsRncswcgOMVAJvVsKoNGBdy6Vzqpjzxa8AqlyyP9im8LC2DFMNGy3O
 PqnkY8EX20faUM5poKcWWfyf8ufkVTs2BPFgnRk8u6WqFUnA97SJKP+TQ1CbVty32uhdivI8t/
 e8TtybLTEGK/zu/CYE7SVgyVKzHVhJQrZLN1MQLLsN5DCNRpRgR4VSDHFeA2x3BvBusuAYqs0u
 9xU1PEr/GEtjxohhF2RpaGb9QAtIipfDAL7tCOnk90EAixTSsjFjpyc+SMknEWmabqcgCY15ky
 OsU=
X-IronPort-AV: E=Sophos;i="5.73,498,1583164800"; 
   d="scan'208";a="242628913"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jun 2020 14:43:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pscq4Izbm1Xap5f/wxAq0M1PQfxSTYru+J67jgMOil/j9S1YpDYFFkW4FzuLHigHUItljfaZGCe8KA2ezT5FxcFmL0vu/icCfpRo7/hUnvuX4Y4I1QSOe4vFavSTj5oP5PO0rn1Ki5hkWsUvM7yMQNezRD3dQ623B91xbYsdoivmMr6tIX9bUHgWBZ3P9xxROy7zqbJzB+l3/+D5X1vXTRvLKfdKbjT2UwLj2mD2V44Ff4nK0vPCAzMEFof7Gc1lovE5kTtRLgGsu2FguR8O4Bv2ZshT0PFb/VMZNpsmNbLk1d+/vtXc5SS5CPRD+It6W7GMpuz6soQIGN4qHfKMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uMbxC17ptv9jb+cKwTpxj9uV4PB1CB8VQM/xqiI0zY=;
 b=G+EQ1z/cqL7J5sW/hS9p0MfPOjXI3XEZ1N2Wb0rvfY7ztCraRDWqiFl4wFtJLoZQk+jZk7o5Dg5w2FbLYFsUpE6sruARbcXQDGYClCDIHx4vAQ4t2+bvsd8nw9v4IF2wn6Ls9ZWsVvBHTCrOA409I3cZlUld+U1Rk4mw4G4BJ4GuyeduBjyNTbPA203xe03XR/JNOR60wNtNMXkvMoVaGV1wbgn+tucjfRygqQH6w3Xpx0L4xTlVNcUz/Utn0CvXQhUkNSFuLxB31aGdzCezJPoP75FSqclVufokQIpUO6Q5xdd2uQ29CQn4TgIfwtbJtHgCER7YLmXTA4yXWDOvkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uMbxC17ptv9jb+cKwTpxj9uV4PB1CB8VQM/xqiI0zY=;
 b=gfx9nI63NLhmbUUzx2yeJRN8B9+M5RIYxTjWqG6rwYe2QCFjHaz5rcgDxRponVKZq7du/IvummNwNKQIMdAp5AmCL2Pv3zGUfhtfUfgZHw+eYlLAdPVWw5qm3WK5Lpzjya1LreDiR9ugWcF4tOj9AcfeBBv5/2OnRNXXapihIuc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3840.namprd04.prod.outlook.com (2603:10b6:805:4a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 06:43:25 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.018; Thu, 11 Jun 2020
 06:43:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHWOt/akL86ZTv+6kyNzf9RcBp44qjSq+8AgABUWqA=
Date:   Thu, 11 Jun 2020 06:43:24 +0000
Message-ID: <SN6PR04MB464097890CE39B34BACC9BE7FC800@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
 <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
 <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
 <bdc420e4-3f2e-cf52-eb42-f85e747b2fb1@acm.org>
In-Reply-To: <bdc420e4-3f2e-cf52-eb42-f85e747b2fb1@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 790e4a1d-5c6d-4356-5578-08d80dd2bdb5
x-ms-traffictypediagnostic: SN6PR04MB3840:
x-microsoft-antispam-prvs: <SN6PR04MB384016B0C5E04DD565E47870FC800@SN6PR04MB3840.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8VHYxgTdjIyZtXTMO9G6BgRNt/U6Nyhi0P+Hfq7YvLGQcPRe4CYcUX++FoS3mMryHXfipfNYReW/qBx9ozNOL0hRblZ45VvyhZns+g9e084T44g6KbxpV5ZiqfLRvdZGUYONktWC0m8etszbPRwrPxYTTKfjp3uZyAYOn6q0bKSYPLxzPWFY1YjmMcaE+XfUDr/65tjho7jQ/mDluWHL4lyKOqL1C3FmAkX8khoehciWVNq+/aXf3YOeXJJ6Qy8KTQdcJ+uMkLxvWQsfrfaItNYXTN9SEK++52sUs6oA3HFhxt4X4ZsOHtrGIbyB9TchAIBjAhNQDAzoOfb7wtjmkIdJcstn7RL/bz9kspRrsyXeNlYwSAflB0DuaSahRoI0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(8936002)(55016002)(66446008)(64756008)(66946007)(66556008)(66476007)(7416002)(478600001)(4744005)(76116006)(110136005)(71200400001)(316002)(2906002)(33656002)(26005)(4326008)(54906003)(6506007)(186003)(86362001)(8676002)(5660300002)(7696005)(9686003)(52536014)(83380400001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2ZoG+SRRh/9DRNFqppKXtYzjntpjO6uQ3rAssyRLUkzPYUR4Lx4/hnQCjDJECrvPYpl1B+PGIh6fvr3Cxgedh5p4Z49sfExzalPcc6PSgY9ML+bxyOq0RtIMIqxhr9o6zd3eCyr3dQTs+i4qBjIHkyZH3zLsv6nhTUOkc7bZ96Vysy+9LCmGFoR6MQaeO7xuLCqDFKuGH2tbyJrvDyWSKNTheTld1ho3MzDDlMgAvyZLx+FseUVT5vSCWq4gvJSw8B9VhcWzglbzhhkUl7F7/X8feLdUPOH4acz3JQJwFChSgxJSDbTDZS7rrQhvVFV6eXHlpKYpULgapXUkWiJ36HOnlWDNc2PN/fU7SYVq6BMrkzrM65hRhMMb4FCf/3IPdAHUMZr3QQcLqWfHPCN6V+hC3x40XMvrX8nHpQfAmOZANTkciiAKCTSWeavBB1ALUER5ArEEzIwzTDgD8bEQuXhwC6g8nxozUwNTMtEubrY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790e4a1d-5c6d-4356-5578-08d80dd2bdb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 06:43:24.8916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjkDjCmtNwezaHB2a82oPkCzziFh/u+ZSQpgTONxeExDDYdor9UNcZ/UusUZAKfkwLK/NENubmcrssQMGCiV4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3840
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gPiArc3RhdGljIGlubGluZSBib29sIHVmc2hwYl9pc19zdXBwb3J0X2NodW5rKGludCB0
cmFuc2Zlcl9sZW4pDQo+ID4gK3sNCj4gPiArICAgICByZXR1cm4gdHJhbnNmZXJfbGVuIDw9IEhQ
Ql9NVUxUSV9DSFVOS19ISUdIOw0KPiA+ICt9DQo+IA0KPiBUaGUgbmFtZXMgdXNlZCBpbiB0aGUg
YWJvdmUgZnVuY3Rpb24gYXJlIG15c3RlcmlvdXMuIFdoYXQgaXMgYSBzdXBwb3J0DQo+IGNodW5r
PyBXaGF0IGRvZXMgIm11bHRpIGNodW5rIGhpZ2giIG1lYW4/IFBsZWFzZSBhZGQgYSBjb21tZW50
Lg0KSFBCMS4wIGxpbWl0cyB0cmFuc2Zlcl9sZW4gdG8gYmUgYXQgbW9zdCAxLg0KSFBCMi4wLCB3
aGljaCBpcyBpbiBpdHMgZmluYWwgZHJhZnQsIGFsbG93cyB0cmFuc2Zlcl9sZW4gdG8gYmUgYXQg
bW9zdCAxMjgsDQpCdXQgaW50cm9kdWNlIHNvbWUgbmV3IGJlaGF2aW9yIGRlcGVuZHMgb24gdHJh
bnNmZXJfbGVuLg0KVGhpcyBpcyBqdXN0IHByZXBhcmluZyBmb3IgdGhhdC4NCg0KVGhhbmtzLA0K
QXZyaQ0K
