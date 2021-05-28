Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2ADEC4707F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 03:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A076135C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 03:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhE1DzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 23:55:18 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:43020 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235307AbhE1DzS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 23:55:18 -0400
X-UUID: 00cb680f019e4d8d87827305bd5772e5-20210528
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=MOS/XzH11PYH0H5Hz+tYoIDZuiLrLEqWUGtSZ8dHXE0=;
        b=cyH09L9Mgn/1oqqlsGMpBSdRg4v8kf0bZ/kL+2KAqkQQjZxdMb2LZWFjULy5dVLXHjNzqRD3iJq1EImWFYvUKTgLjSWPawXFIEmMuJ+2CpcUsj+GNN5pH3uQ4lpBnfa9jTmyzqR6493V4P4XG1zXNZV6g9tUSCnoaNiUTiL1n+s=;
X-UUID: 00cb680f019e4d8d87827305bd5772e5-20210528
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1815726703; Fri, 28 May 2021 11:53:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 28 May 2021 11:53:38 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 May 2021 11:53:38 +0800
Message-ID: <1622174018.7096.1.camel@mtkswgap22>
Subject: Re: [PATCH v2 0/2] scsi: ufs-mediatek: Disable HCI before HW reset
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Alice <alice.chao@mediatek.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Date:   Fri, 28 May 2021 11:53:38 +0800
In-Reply-To: <20210528033624.12170-1-alice.chao@mediatek.com>
References: <20210528033624.12170-1-alice.chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQWxpY2UsDQoNCk9uIEZyaSwgMjAyMS0wNS0yOCBhdCAxMTozNiArMDgwMCwgQWxpY2Ugd3Jv
dGU6DQo+IEhpLA0KPiBUaGlzIHNlcmllcyBjaGFuZ2VzIHRoZSBodyByZXNldCB0aW1pbmcgdG8g
YXZvaWQgcG90ZW50aWFsIGlzc3VlcyBpbiBNZWRpYVRlayBwbGF0Zm9ybS4NCj4gDQo+IENoYW5n
ZSBzaW5jZSB2MToNCj4gLSBGaXggdGhlIGNvbW1pdCBtZXNzYWdlIG9mIHBhdGNoIDINCj4gDQo+
IEFsaWNlLkNoYW8gKDIpOg0KPiAgIHNjc2k6IHVmczogRXhwb3J0IHVmc2hjZF9oYmFfc3RvcA0K
PiAgIHNjc2k6IHVmcy1tZWRpYXRlazogRGlzYWJsZSBIQ0kgYmVmb3JlIEhXIHJlc2V0DQo+IA0K
PiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDMgKysrDQo+ICBkcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jICAgICAgIHwgMyArKy0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmggICAgICAgfCAxICsNCj4gIDMgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KDQpUaGFua3MgZm9yIHRoZXNlIHBhdGNoZXMhIEZvciB0aGlzIHNlcmll
cywNCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+
DQoNCg==

