Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D4EC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 06:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25F1206B5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 06:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a1jdUnzj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Uc7/DAGz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgHXGrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 02:47:17 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39252 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgHXGrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 02:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598251635; x=1629787635;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=8gUH+aBRuehx/rjHsvGxWxuVt+l4gtyuQClbq2nhGbs=;
  b=a1jdUnzjShnCKu8z5D9Zx9aI/uDTjzl7lYZkGNgtuJspYTOXlVdvAO0U
   7+RioFcQrDHyeXeQn8nwU3rz7vO4jmuT1XzwgOWx6DeX59fkqKvoFS3et
   IRA3B6S7vkagFn85Fp1uJLLFXPvK0a1KwZuIXbJXKGLEri9JmoiD3gQxz
   euSZ/KedKJfWqlm5QvLaPi2RpA/gKRCQqR+KVxwQDDSSO+hB2BNh3cvjv
   YyzdXcL37V8bywQL6TwMVD2eULOkCZd+P7JANw8q7DNqeihLHwmS69kd2
   wRMf2FH5uiSz8bEZhyi9UtmdTbU9HZR2AIUqtdMxE5O34nd/qGAeUeqU3
   Q==;
IronPort-SDR: /luUt5K59KDtNbJNe4Bs3t9NozxIhFc0smpXFLamKKmZHtGm36QYfPjxNCoienvh9sOISzkYZx
 P4XXzKXwmX7+G6yClgn3MD9x1089BOsQmtc/As5OsgfmAN+mFcc7iZBVkee7KVb3cpiKqtxmd/
 FDejLbd5IdqwC4Ki9BcCAa8DkO2whKo51w074eBm9H8Zt69lO6kHiMLFuyTrtp+MDkDxoxLGiL
 FLu3GXO9gWkXM60YjBgLk247dPcwJS2Dl3DGWLZnicHpKqeX01AgA1SETKiOHSewQOxgX2gB7f
 HlU=
X-IronPort-AV: E=Sophos;i="5.76,347,1592841600"; 
   d="scan'208";a="255139214"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2020 14:47:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xwx3FaYsf47GyYb33bzRPvNOxjXq/edI7HvqfRzE+KpmcVK/dU4uTAgxAZ2cfAgGZCcnfuJ8AyZU3c6a++JQvaMndIiabQbXUYrcycbIjEOaYKH7l9w/++eF2Elr0ZE9ybbLlhI9GNCHLpRrmypuGpfT1irHPy4GV+K1aeuAMfs6tzURuU0QYFPNsftyNOA1T7ACN5tPd1iiLJg+hOWjsVmlbNas2xehdpNa4o7wKPJ+rsnH28bBYgTaUtTDTmp/tlB0ZEIOpJKniNX3FgKHJZ9+gmK9Txi+BCYI2PJx/3IQVe0wr7tAZD6m7eJiBcDC0eZdF0wFNy8lNLzvYZeBCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gUH+aBRuehx/rjHsvGxWxuVt+l4gtyuQClbq2nhGbs=;
 b=iCzqKl9sK7soayX91XbffPCGTAIiVCffbN3ROKYt4cJEGnWZbgxyNReLOxmdzQ6xFPAdX/oiA7IgKpqwgxnJrDMQjxiuVIGxUCqAnaAUZw6+x3UCFNlAKG++sZuV4LMZJpE9ML15jBmItMT3Ssr6ehkp2hIufoFZw7rgf94yy2hoADyRU5s5y4u8wKSgwrjIWmgPHy+PySqbnUQ+LpF/XMtRuaU1TvVdlQ6W4j/+TH0sgnTWBAdWWfnS9a1xw4/PYbAgZiP5xr3XJbusiqjxJ/y6scV/qQvplRMwWVZxCLpri9s8AbD016V5iDj0xqVAAHIF2/hpPqV3itzVV6rYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gUH+aBRuehx/rjHsvGxWxuVt+l4gtyuQClbq2nhGbs=;
 b=Uc7/DAGzWAWrQ11er93ZnvTAOTnr2nvXZfl1H7g2UYMrTj6CRi7qb3Pu8CfyR00uDIBs56KfKUoKYf6M9WZvhjJSNMtNG3va+msx87VtVvv22lBLwlwip9cgGRZFniUIMvOxO6XhmQz0zB4EXS5C2ccpBP4owJPXCcdX7JSADzo=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6453.namprd04.prod.outlook.com (2603:10b6:a03:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Mon, 24 Aug
 2020 06:46:59 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 06:46:59 +0000
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
Subject: RE: [PATCH v2 0/2] skipping manual flush for write booster
Thread-Topic: [PATCH v2 0/2] skipping manual flush for write booster
Thread-Index: AQHWeb+i032RMdHziEyrZS4W6oHhBKlGzyuQ
Date:   Mon, 24 Aug 2020 06:46:59 +0000
Message-ID: <BY5PR04MB6705C3DCE1EC1BE863D7406DFC560@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <CGME20200824023811epcas2p4915326d30728acff0a721043706e1f3b@epcas2p4.samsung.com>
 <cover.1598236010.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1598236010.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e98de7dc-1a08-449e-b0bb-08d847f9803f
x-ms-traffictypediagnostic: BY5PR04MB6453:
x-microsoft-antispam-prvs: <BY5PR04MB64533F0EE92516306140648DFC560@BY5PR04MB6453.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pXfJDEiUMxQ1iXqrSqxK2jn54a3RKbWgj7lLrUmA7GI9IJn+JrAoU99CrskEgOQ9/pOhB4izkbZtQEDSZWoPgqFYGegjhnCNr3fOGlQg+8AIPiDjztAxCnztDV/T0amwLmBgoe74Fk7CJ0kHc6R1fc5c9ZaRF4poF3cAuP5tc3YNNWb6j59SOdr5+d5Pmw4B3vMSAiotI1owZJt96lLyJr1uG6dQ26uNc6mQH+2EExXgKn9epBoRupj9BXpzLK2INV0cglFO59Qkmr9rOYHwq/wPY3Edj+KPXOWW+5hhFa4oXfSEC1lnh/5j7DJzfBixMvOX4/YAcjDSNP9HXIizDOH47f47n18e+mIF8rq0e+ye0UMC+Vvd73YINrA3kMdx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(7696005)(71200400001)(5660300002)(33656002)(7416002)(26005)(6506007)(8936002)(52536014)(186003)(8676002)(64756008)(66446008)(66556008)(66476007)(86362001)(55016002)(2906002)(478600001)(4744005)(66946007)(9686003)(76116006)(110136005)(316002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: K2qGmxFjp1wNTyYvuDr0bWr8xi8U1OsiXixtOnOTAOh8+IZvgWGjS7bnzG+JVVZn1YkSaoqt5G/ejHLggq60MPwXzlYS8u2ajYxEOUsSCYYcv18uVeO/++yqSb+HCuus2DKXYo2AEbHeQZzVcpMIaq/83wDIp03hxlNCv9cYjncvSBc3KBS2cCMn3JT9ovYQMoYzsU+CvF0nw5IVFYpR33ukJ7eQHRIEte0WqKE6fQZc7ZEBqO5E30UXZnyDw5hAmAl2stYPxm1pnihzTFVSj2yqXZ28jlU9BfE7e6YSpl/nhpz3jm7MjqIaP/dWmIysdvOB8bf+Uxcpf86n8xLUXVlJ9AIe9JGEalbPtmWimShOqnGzqY8n/naGvDuVsA2iYBHbbYBqyFTCbdL5jmCZA80y32Cq9RZaY86p7tcdYs5gjyqs/yirb0rr0wUVxvLj0j5xFKnbqpCmsLR3bvBwHltIm+caj9WPgg2TcslaSaw3aGxdziDd2MozvfylDB72MMOapJYCydO+TGVYU1mJcWus1OjdAw0rRR+euJSpyyUwTlqZbwjovyoBX/3o1R1sMwLbGQQihzhKY8fHNk6iOt7NKTYp3IBn+Hu9hDRlJDCkvXlOykho2FWVTPHSeKKcwhSz91ft69uI2TBbwzoyEA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98de7dc-1a08-449e-b0bb-08d847f9803f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 06:46:59.5050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AF/xJh0fyvaoY1HbEPIsR9J9UbvzJ8647nkD0/jz0ZqrcLVz8+uKyr+4j6/l+jqYugD+g+FIHlYIadhsbC6lsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6453
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gdjIgLT4gdjE6IGVuYWJsZSB0aGUgcXVpcmsgaW4gZXh5bm9zDQo+IA0KPiBXZSBo
YXZlIHR3byBrbm9icyB0byBmbHVzaCBmb3Igd3JpdGUgYm9vc3RlciwgaS5lLg0KPiBmV3JpdGVC
b29zdGVyRW4sIGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaEVuLg0KZldyaXRlQm9vc3RlckJ1ZmZl
ckZsdXNoRHVyaW5nSGliZXJuYXRlIGFuZCBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hFbi4NCg0K
PiBIb3dldmVyLCBtYW55IHByb2R1Y3QgbWFrZXJzIHVzZXMgb25seSBmV3JpdGVCb29zdGVyQnVm
ZmVyRmx1c2hFbiwNClVzZXMgb25seSBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJl
cm5hdGUNCj4gYmVjYXVzZSB0aGlzIGNhbiByZXBvcnRlZGx5IGNvdmVyIG1vc3Qgc2NlbmFyaW9z
IGFuZA0KPiB0aGVyZSBoYXZlIGJlZW4gc29tZSByZXBvcnRzIHRoYXQgZmx1c2ggYnkgZldyaXRl
Qm9vc3RlckVuIGNvdWxkDQpmbHVzaCBieSBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hFbiBjb3Vs
ZA0KDQo+IGxlYWQgcmFpc2UgcG93ZXIgY29uc3VtcHRpb24gdGhhbmtzIHRvIHVuZXhwZWN0ZWQg
aW50ZXJuYWwNCmxlYWQgdG8gYSByYWlzZQ0KDQo+IG9wZXJhdGlvbnMuIFNvIHdlIG5lZWQgYSB3
YXkgdG8gZW5hYmxlIG9yIGRpc2FibGUgZldyaXRlQm9vc3RlckVuLg0Kb3BlcmF0aW9ucy4gRm9y
IHRob3NlIGNhc2UsIHRoaXMgcXVpcmsgd2lsbCBhbGxvdyB0byBhdm9pZCBtYW51YWwgZmx1c2gu
DQo=
