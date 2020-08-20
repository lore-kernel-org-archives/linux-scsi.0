Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5056C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 11:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A291E2078B
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 11:46:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PBlc/jss";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oAkqkeO4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbgHTLqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:46:40 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43905 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730563AbgHTLpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 07:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597923916; x=1629459916;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=5PPKoApYJYgE3XHkQNq7ECm+w+jlrBIU7rpNXHGwYZU=;
  b=PBlc/jssBjjqW61aBeIautK477Rek4Hr+yDkxqMM6ezhFQSPeVTTdE6p
   ZmHgXypXUG9MOQEewuzoMhKGDCzDyszXX8NQHq8G62Gl4ONwJQs5VyF+X
   wOh0F70W1F9PAftDmr2zS+Jqc5X3TN8of/6SuiEAyryVjOsBH+6ihCukc
   Uku8iHItdd+ZpfnfyZsjWyJSfD1ObeA5IGXMnUx9zrQyJOXCnigqnnYA8
   11B1Zwk/LjR+S2jXb+xasqD03B2wDvQdVaZmBIXTH4DkLj4Gwtkk1QeS+
   YZIXlmbNxHmsqEDMqJWATxurdPc75vmm8SfAN+etn58hWhhObojt/qCJi
   Q==;
IronPort-SDR: CHnx4iN7qhyEDCqdGUKwrOPNuNk1Tr1mi/dtTiTcmUOTLBHs4c9AAOGbPfLIsd02rxxbRpBCrJ
 9DuJXhg38/i1d/2UbBj35GWPSVmQjuedPS8QRWgl2mQ4TKyaLeF8wP4n+gbWZD8UDMBZMnVF5o
 4FLbs3c/kxJ7fngoC5Z1H1dkQatJxxuLa4OliOL974wUHIXkmH0CNga20T5TT4cDcF1OyXpORZ
 AuIckpfJz8klf88IOLMDrBD82t2z/9XTJp0J75s4K1CViTEdoQI5PA6c7FRY8vuARLevcGjnN5
 4sg=
X-IronPort-AV: E=Sophos;i="5.76,332,1592841600"; 
   d="scan'208";a="145361144"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2020 19:45:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gquCOoqdaX7oE7zoIFczk7IRcSfzDo/XKy272vXu1zpu0XETQxJLDrFMfOvUQ7djfNjky9oeXdH8phvI4O0zFlIgni1YinarSP2mRv49lSD+JAfKctKp4n9AN+HnkBmDkJaE1+DWn4adgS3F6xJ0EivcrL1d5x7QLtvpslwSkab8X4QSH5tU6OTvH6x8oTGioCkUGyxFPZHKQGVlrVINGT0ySWhAQxjsnCo/kKbOVWcN2OhpMWTy00niGTxOa91ees1wAa8LxIrIjNVbLz+RkK4Zo+JX01lUDZgbSlDrMPt7pjoQZ2vH2v/EPkFnmwAL2hNfXvCEBWrUEORKGbHNSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PPKoApYJYgE3XHkQNq7ECm+w+jlrBIU7rpNXHGwYZU=;
 b=gp46nHGmiDECYi7gauUkh32HFaFTp/bYdCpJo4SsKe6MmVa0n82x/LUOt02UDKJ2lifusVoPdhR7u+7d4lgyapx5OW4biga0ofgFwg/ZTs6658viWm7LjmUJvvWDFAH6uAgrr+Zy+MhFa4nikDuGYkXNqRbZEwB0To6UEYRsApY6jDkdECqMjeeZpO6q8Xpv1yKz0BbR9Oq24N+PllIg5IegRlFTQ4iT1p8y9sJG/iYWbEp/0m2y0Quj3Hbl9dl0GQlA2yv0fjmYwS0VIcMNuG/d3wgJXIqXyHry9lGB+aqk50AqOItFbD3+dgCnE2y7zTWBJUlP3SGKQDARXKdIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PPKoApYJYgE3XHkQNq7ECm+w+jlrBIU7rpNXHGwYZU=;
 b=oAkqkeO4IciUoSJS/w+B8WNc3kzZFsrKiHwy0JmM0f1bkM7UDRcdLDkwfxXdufQwSgF7mgXA+mYMDZyulSosV3TrID5+oZg/Gn6yXY4IC+lrwltTWeGt4guB3D1X4+qJDGpuSxbeKs8pblPn31Xlf40SuucqdGPjvzJjnQfzPSw=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB5799.namprd04.prod.outlook.com (2603:10b6:a03:10c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 11:45:11 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 11:45:11 +0000
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
Subject: RE: [PATCH v1] ufs: skip manual flush for write booster
Thread-Topic: [PATCH v1] ufs: skip manual flush for write booster
Thread-Index: AQHWdtUhkUZKvcgDqEurglw7PEh3e6lA3pUw
Date:   Thu, 20 Aug 2020 11:45:11 +0000
Message-ID: <BY5PR04MB6705B284C2BE24B53E6473C1FC5A0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <CGME20200820093430epcas2p1b78325cbc1ee6ff0f6ee1727e2a4de49@epcas2p1.samsung.com>
 <1597915550-167609-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1597915550-167609-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c6dffe6-12f4-42c0-b786-08d844fe7ecb
x-ms-traffictypediagnostic: BYAPR04MB5799:
x-microsoft-antispam-prvs: <BYAPR04MB5799B4637BF8BBC3F26D8030FC5A0@BYAPR04MB5799.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c5lqd4/qMMaN5EEUszwSQO3k0vuLrPdAhSP+9noy7ek+ZPSYVqLyHMjWgid0WFuhcVVejtfRKZdmFCfezNJh2qR1L35p2zgwIoKIIdvVRBiH5mwmLs+NMwoCKi9RiWwI9w7LuySIlLcoM59ucJwJPf6/DLstFG8rV/uvLMCQXjlFMBoYHpLE8yQtcNbOgMUWYrPCeeVk3CsxDQdp+6t1RyNCYOCrqBZoemi+17Gzvu2OjIrKJ5E4lBzs0f4GVOXkCAqR+05fTQME1dSq3PPP4g5BumWaNur7oriavOVfej6pvlfLj91WGgzCanSAHWgiH2c/k21Dwm5hoi0TxqFmLhdx3WiFFrEuBXWViRxGwirook04lpZgmY86+t4W9O1B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(186003)(110136005)(26005)(6506007)(7696005)(316002)(71200400001)(66446008)(8676002)(55016002)(4744005)(478600001)(9686003)(66556008)(33656002)(5660300002)(66476007)(66946007)(8936002)(52536014)(64756008)(86362001)(76116006)(7416002)(2906002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lDpzOl2l9ir2J3oSXbZgS3Xcu9aExfODmpx+8tglPytHrh1TV1K3vgqW8duBQt6jFzsIvTEsCFEN9zhgaHO8Lkk2E6JwMHeG7W4Foo3Y3Pq3vj+2XPLAiNKzfpzzIWHCVc3hSaJzApHwBDz83c0rtFF4DzX8qDHjE7p6vDUvZAF3rrK3WJoEl48ju//h7niRs3YYq0uWgZf8XChLJxQadI79+mxPhi5Lo3bhPdFffbu5mKboPjmQfH5hWeIOjd62o461nK7JHu2cGqH6ErpBsuHHRb/kmSXFQ+OP2vaYzQFh54wSwJTcAYhjHhUrgu1pZYclhhTI+bUPk+bBUcC8uhfWtyMgj9QpSNJYbpn0pKOunvAV6tUlNGnxx6dsI/O4AQwh1TDF2J9tkFv0Z860rc4zYlskkc3qDbiL934L9tdcazd004S1D6UZaeZifWItFQKHJVsc1H5t9lBevGRHVnQPgrCLXOm7BFaUZpsN3BpvKv08pgp/2kJLIEix1907EgmhgMQ5cuviR40zm6J5S9I9NYoaYZa8ZFA3tG/4Bcl7/gnL4qGG5YiyW2CEDoum+tcYezVEzVOh+g4a8oDcscKlUehkV2jj4q03DYzQxXezL8JHs1jPX9WArnNLYtQmW5rPSFsvQ51R2sRnPjeSWQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6dffe6-12f4-42c0-b786-08d844fe7ecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 11:45:11.1024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YEDzLI5FK2DoWExU+406ewQFM3YWq3k/4d2nNA1Oui20YDTmzbWpZfVui4PpRquI4oIiRJKYaifZb00Wmt0tPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5799
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gV2UgaGF2ZSB0d28ga25vYnMgdG8gZmx1c2ggZm9yIHdyaXRlIGJvb3N0ZXIsIGku
ZS4NCj4gZldyaXRlQm9vc3RlckVuLCBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hFbi4NCkkgZ3Vl
c3MgeW91IG1lYW50IGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSBhbmQg
ZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4gPw0KDQoNCj4gSG93ZXZlciwgbWFueSBwcm9kdWN0
IG1ha2VycyB1c2VzIG9ubHkgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4sDQpJIGd1ZXNzIHlv
dSBtZWFudCBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJlcm5hdGUgPw0KDQo+IGJl
Y2F1c2UgdGhpcyBjYW4gcmVwb3J0ZWRseSBjb3ZlciBtb3N0IHNjZW5hcmlvcyBhbmQNCj4gdGhl
cmUgaGF2ZSBiZWVuIHNvbWUgcmVwb3J0cyB0aGF0IGZsdXNoIGJ5IGZXcml0ZUJvb3N0ZXJFbiBj
b3VsZA0KPiBsZWFkIHJhaXNlIHBvd2VyIGNvbnN1bXB0aW9uIHRoYW5rcyB0byB1bmV4cGVjdGVk
IGludGVybmFsDQo+IG9wZXJhdGlvbnMuIFNvIHdlIG5lZWQgYSB3YXkgdG8gZW5hYmxlIG9yIGRp
c2FibGUgZldyaXRlQm9vc3RlckVuLg0KTWF5YmUgeW91IHdhbnQgdG8gcmV3b3JkIHRoaXMgY29t
bWl0IGxvZz8NCg0KWW91IGFsc28gbmVlZCB0byBzZXQgdGhpcyBxdWlyayBpbiB1ZnMtZXh5bm9z
Lg0KDQpUaGFua3MsDQpBdnJpDQo=
