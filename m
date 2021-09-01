Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AB0C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 05:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 025B061054
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 05:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbhIAFq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 01:46:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55588 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S242141AbhIAFq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 01:46:57 -0400
X-UUID: 61c7d47f2073475aae216e1fef057086-20210901
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AVKDGESxkUIqb5eW1b30pL9AL/33KNaxVIvLODxrvmc=;
        b=J2Ljz3KD6vmCZ9Ioi1tKBtPS/7HfGegkQdmDHJbbD76mPMMn7v4ocmSvdqCCEg6TSaRCsO4nR758vZjjXzNg+vIeDcPkqqAGqVA0BpahFxVjuJdJs7Ds0CY4A86ItQffqlFtsU56+1DHUaeJlLlSExHx4i+ifENkiSRoxrk9Blc=;
X-UUID: 61c7d47f2073475aae216e1fef057086-20210901
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 143574853; Wed, 01 Sep 2021 13:45:59 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 1 Sep 2021 13:45:57 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 13:45:57 +0800
Message-ID: <7ab5239c6d8c7fc2d883bec6ccc6268021afba76.camel@mediatek.com>
Subject: Re: [PATCH v1] scsi: ufs: ufs-mediatek: Change dbg select by check
 hw version
From:   Peter Wang <peter.wang@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Date:   Wed, 1 Sep 2021 13:45:57 +0800
In-Reply-To: <e3f14336-2cc6-3985-fd52-ead795737417@acm.org>
References: <1630325486-11741-1-git-send-email-peter.wang@mediatek.com>
         <dda8eb67-fe56-8bc0-5ce8-a62bd4e6b995@acm.org>
         <da0ebaf6bb6e556eeb2f6fe4037d891bafc79ecd.camel@mediatek.com>
         <e3f14336-2cc6-3985-fd52-ead795737417@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KUmVhbGx5IGFwcHJlY2lhdGUgeW91ciByZW1pbmRlci4NCldlIHdpbGwgdXBs
b2FkIG5ldyBwYXRjaCB0byBieXBzcyBLQ1NBTi4NClRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNClBl
dGVyIA0KDQoNCk9uIFR1ZSwgMjAyMS0wOC0zMSBhdCAxOTo1NSAtMDcwMCwgQmFydCBWYW4gQXNz
Y2hlIHdyb3RlOg0KPiBPbiA4LzMxLzIxIDE5OjI5LCBQZXRlciBXYW5nIHdyb3RlOg0KPiA+IFJF
R19VRlNfTVRLX0hXX1ZFUiBpcyBhIHJlYWQgb25seSBtZWRpYXRlayBkZWRpY2F0ZWQgcmVnaXN0
ZXIuDQo+ID4gU28sIGh3X3ZlciB3aWxsIGdldCBhIGNvbnN0IHZhbHVlIGZvciBtZWRpYXRlayB0
byBkZWNpZGUgaG93IHRvIHVzZQ0KPiA+IGRlYnVnIHNlbGVjdC4gSXQgb25seSBuZWVkIHJlYWQg
b25jZSwgbm8gbmVlZCBtdWx0aS10aHJlYWRzDQo+ID4gcHJvdGVjdGVkLg0KPiANCj4gSGkgUGV0
ZXIsDQo+IA0KPiBUaGUgYWJvdmUgY2FuIGJlIGNvbmNsdWRlZCBlYXNpbHkgYnkgYSBodW1hbiBi
dXQgbm90IGJ5IHNvZnR3YXJlLiBJZiANCj4gdGhpcyBjb2RlIGlzIGFuYWx5emVkIHdpdGggS0NT
QU4gdGhlbiBLQ1NBTiB3aWxsIHByb2JhYmx5IGNvbXBsYWluLg0KPiBTZWUgDQo+IGFsc28gRG9j
dW1lbnRhdGlvbi9kZXYtdG9vbHMva2NzYW4ucnN0Lg0KPiANCj4gQW55d2F5LCBJJ20gZmluZSB3
aXRoIHRoaXMgcGF0Y2guDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K

