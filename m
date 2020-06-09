Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D68C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B9C207C3
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ow/dOe14";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XjskoM44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgFIGjM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 02:39:12 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:44836 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgFIGjL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 02:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591684750; x=1623220750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tsUwep0WiI9Q8gCgypimsZhvTO5athUBRpUtA/ft41k=;
  b=Ow/dOe14fIxd2tP/AFOxZhmDf5TyvMj17GupN7ni4+VZwM4gkTMVlJFN
   htpamK5odIVQpV2U/RnWoXGp7SnpBIfXSpSZdJLRv5A6diw6m6SE0Lhgx
   2BCu1QF7zQ8Oq9QloQuRJXVEsPGQBRZb6mrLUr7O+mNeGNfa9BF5Gys6H
   pGPP4AuGe11/0/tdaLerQQ6fWBN+49rpb4XuHl4CMIfP5/VndJNkI59v4
   qIq6ZGfYAjKmCxR8eKmJ8wxsU55PCE8077Q6v98eWoOZ8kdHhHK8PD8g6
   EETo5tZxJjHHM+SbE6iIJB4qF99ZKZbi4hRPwMR3i5ZXjoIRIUuG6V51J
   Q==;
IronPort-SDR: KIsi6jqjK3ZzCzmM9h0LL5nZiPqoMCew0FK9kNkmNZxIoNFaaPIt8HpIv/hc3za+WDdQ0IyI+s
 pGnIjpZdhGVfkjHuJORIptNf6y167MNpKIh37m4qi71jdlbam5J5TgfWynv1iG1mzluGLRXD0R
 VSLm742WXry/rn1nG1UbSKySrl2WiWUo+gxq1nMXaZA+f32vjBAfPjBWwwM/dSXSPXjllkPvpa
 b0ayrhHoGzyVZCu71dT0Ot2WWE90VTxg51PdutWoQR0pO3PIFM7sIwb6a/H81xy3o+JqXIaMGb
 cV4=
X-IronPort-AV: E=Sophos;i="5.73,490,1583164800"; 
   d="scan'208";a="248646438"
Received: from mail-sn1nam04lp2058.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2020 14:39:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRNxel0jO+Ziz7CDE0WMCNIQtzqShSTsBuTARrwlmOrslTggWRV+Uq0kszIrwfqSEn2huquezJnagmwr9o+b64Iqc5fOb5DbG1xeFan9AIdoZargq53EmaNQBtJu4FcbAqAL+L6ot4QmJ/RTWpFn9Ard5NSrfH1qLBC/dEapJiMVOW2IuZc/sFSkvPMIMeK4mOTpyIoB1NN0Z1HVxtgdGWfq/F3/+aGrU/+LRFTOOR1GCwRlof0aWSAY0U5BYhFRXtAaOPUNS91DPF8zyQTHRfrmjfAsw1jz8QuNk6EPwARfFHD2hHIdOayWlb2mWCjRFCRjp7y3fbNw/5TSAsrD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsUwep0WiI9Q8gCgypimsZhvTO5athUBRpUtA/ft41k=;
 b=b+hIjL4XagXaeRykbTQdDPg+6XQg+ay/7Tljq5T8vA7TZT2hlPXgRAXwbFupRSf7XaMNLg/apHZ57HXQzz4ID4S0Yefl2aqCGOzNfOB6PEelUtCYNL2pe+edEFhe3Ga0o0s0OhLku3jg0Qnsw7sxjzn5TFi6vS8RVjkFRAEepu+pGVpUYTlk4R53lZ6rzgrSFlFGhOTURl+uKozogWM0VI/GfTb0jKBxC5ahKKWtDNEVVCnjptYdJkb8x8oBfbCdjFN/x30xZmndCrkA+2K+TctqNFob7z5J/+sL5QnNYDzPtgtMVWn9ui9BV11tYTlctfN4Xm3sz1HYn47TesSiZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsUwep0WiI9Q8gCgypimsZhvTO5athUBRpUtA/ft41k=;
 b=XjskoM44y1HcXXQmb/6EnukqXTegltJo1u7TRy0JzFqw6fA0feiLYiRCRxF+rveeDMb9ex8O0lovHP9TPy5Osdzl8Z/JdZNBD6ZUz/GQXbp5710uCbaQ4DdZ5VAWwnC4UTS+WkIkUCV/inADnQDuf1HVru9sP0fbQSBkcnirJnA=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (52.135.119.19) by
 SN6PR04MB4382.namprd04.prod.outlook.com (52.135.72.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3066.18; Tue, 9 Jun 2020 06:39:08 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 06:39:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWOt5z/DbVMmIRNkq+06TbmiHC8KjLsIjggAPKWwCAAF+xcA==
Date:   Tue, 9 Jun 2020 06:39:07 +0000
Message-ID: <SN6PR04MB46407A85C194D2D8F03A01B3FC820@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
 <1776409896.101591664283293.JavaMail.epsvc@epcpadp2>
In-Reply-To: <1776409896.101591664283293.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ba67aff5-b716-45cb-5ac2-08d80c3fcfae
x-ms-traffictypediagnostic: SN6PR04MB4382:
x-microsoft-antispam-prvs: <SN6PR04MB43821E36A308C74ED6EEB3A7FC820@SN6PR04MB4382.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YrRAVNf1a+LEzMWezhDJTyF0R2alusLpv9iBrO1pfyesry8c8ESPQrdzNinqdpfgdmwct4IsSBp2DFsEk45rmGZfknpV/9MP0OoSwIjKPy/WiE7nOkUg9pwwymCQ62SN2YOACLo6LDMTtQBuYEXBObkvvcLet7jkUCzEhFXWfhoK6RS9+Rg0cqr4QhFFBVxyMnjNl79t8hpshsk8oJtiorNYRmi4RPgQJY/8KdQ4qfH7q9pIE3CZk/urAmlUaCyNcqk/YekY9pp6XSGRhZYs2GOAViwyeGU9axA4CDEauAWvH/0QRNn4TmLTsj0iMWuk7drNdK0gRMbo5ADhDy+DL0ubV1JGe5h8QvNssoZiF5Ygw61Cg9mFmSBod8BkCtUs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(316002)(2906002)(186003)(6506007)(26005)(55016002)(5660300002)(110136005)(66446008)(54906003)(64756008)(76116006)(66946007)(52536014)(9686003)(66476007)(66556008)(33656002)(478600001)(8676002)(71200400001)(4326008)(4744005)(7696005)(7416002)(86362001)(83380400001)(8936002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Q4vsVRBUixx8x1wm6eGg377fbci+QZ7WXwzRhhzPYahsx8gy5WhAzq6npaHBUOlqYMthY/+YkgBrScCGevi0aPEJ6leh9Kxv6+FMwVOM3gFD3UPDcqZZlAl3EGsQrydIqwXj9Ux9KorK1vS1oj7u7rNY2LYtQhChDXs+p4NbHv7U7F7tQCHk3siNIXFuf36i0sN2eNzfJVPScielpkz28qqT+Is1dlLVCb/2FbMVwOKo0F+OqHcRE2gYs+hcDZFvQ7nYoDWAhgpZ49gdIlr6TtNTe37r8GOME/XGcEg/tt/5VQAM4fqjg1eDBtT+LLj0fIo43fGzIT9edgMIPX04meR2RIskI5Kf/w3jfHMmJnwyi0UKGKcJPf/uscAFWJOZ10XCqtLrK8+sX/GzNOK5ZQnlDpre8h3LJ9PoIQEbvBIy9U3rz84kfTyO8uBZgJN3f1RV718lJiOuzpGMB693fpw7P/s4xDpFr1okcID6ap0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba67aff5-b716-45cb-5ac2-08d80c3fcfae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 06:39:07.8259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AWcknOqthdwFIZZG93ooCjHrmOniFVYgoQnOURtGLUHLXDUSz3BbUzl5MtPU1u8R/XIuuQ8FRC28eYqZXnLLBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4382
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gKyAgICAgICBzd2l0Y2ggKHJzcF9maWVsZC0+aHBiX3R5cGUpIHsNCj4gPiA+ICsgICAg
ICAgY2FzZSBIUEJfUlNQX1JFUV9SRUdJT05fVVBEQVRFOg0KPiA+ID4gKyAgICAgICAgICAgICAg
IFdBUk5fT04oZGF0YV9zZWdfbGVuICE9IERFVl9EQVRBX1NFR19MRU4pOw0KPiA+ID4gKyAgICAg
ICAgICAgICAgIHVmc2hwYl9yc3BfcmVxX3JlZ2lvbl91cGRhdGUoaHBiLCByc3BfZmllbGQpOw0K
PiA+ID4gKyAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+IFdoYXQgYWJvdXQgaHBiIGRldiByZXNl
dCAtIG9wZXIgMHgyPw0KPiBZZXMsIEkgd2lsbCBjaGFuZ2UuDQpUaGUgc3BlYyBkb2VzIG5vdCBk
ZWZpbmUgd2hhdCB0aGUgaG9zdCBzaG91bGQgZG8gaW4gdGhpcyBjYXNlLA0KZS5nLiB3aGVuIHRo
ZSBkZXZpY2UgaW5mb3JtcyBpdCB0aGF0IHRoZSBlbnRpcmUgZGIgaXMgbm8gbG9uZ2VyIHZhbGlk
Lg0KV2hhdCBhcmUgeW91IHBsYW5uaW5nIHRvIGRvPw0KDQo=
