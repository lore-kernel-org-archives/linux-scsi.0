Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D90C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 01:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D739361369
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 01:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhFRBSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 21:18:47 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:49113 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231310AbhFRBSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 21:18:47 -0400
X-UUID: f12b4df563d747778db672e4b5ab6f5d-20210618
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=KOzvCy7uxSkX1CX2/k53ocjUMWvU6GOJfwgH1rFZydI=;
        b=LwtPA6TdfL/56QH4cjL7+yNWaZO/cUxVKVby9TLecGiyoersJvCDBXLCkUOAV5imbcSVNdfEci5ch6+gfg/5XPDEmJolGQjXHO7CKi/JUIsvcvjgD4IAO7qCKEgtZgltTwYQtISWF3NnuiA/4CQEs0j7SRQtKQRic/h+4RSbftc=;
X-UUID: f12b4df563d747778db672e4b5ab6f5d-20210618
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 381214056; Fri, 18 Jun 2021 09:16:35 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 18 Jun 2021 09:16:33 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 18 Jun 2021 09:16:33 +0800
Message-ID: <1623978993.5433.1.camel@mtkswgap22>
Subject: Re: [PATCH -next] scsi: ufs-mediatek: Add missing of_node_put() in
 ufs_mtk_probe()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Zou Wei <zou_wei@huawei.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <matthias.bgg@gmail.com>, <linux-scsi@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peter.wang@mediatek.com>
Date:   Fri, 18 Jun 2021 09:16:33 +0800
In-Reply-To: <1623929522-4389-1-git-send-email-zou_wei@huawei.com>
References: <1623929522-4389-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgWm91LA0KDQpPbiBUaHUsIDIwMjEtMDYtMTcgYXQgMTk6MzIgKzA4MDAsIFpvdSBXZWkgd3Jv
dGU6DQo+IFRoZSBmdW5jdGlvbiBpcyBtaXNzaW5nIGEgb2Zfbm9kZV9wdXQgb24gbm9kZSwgZml4
IHRoaXMgYnkgYWRkaW5nIHRoZSBjYWxsDQo+IGJlZm9yZSByZXR1cm5pbmcuDQo+IA0KPiBSZXBv
cnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IFpvdSBXZWkgPHpvdV93ZWlAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiBpbmRleCAxYTUxN2M5Li5kMmMyNTE2IDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTExMjAsNiArMTEyMCw3IEBAIHN0
YXRpYyBpbnQgdWZzX210a19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAg
CWlmIChlcnIpDQo+ICAJCWRldl9pbmZvKGRldiwgInByb2JlIGZhaWxlZCAlZFxuIiwgZXJyKTsN
Cj4gIA0KPiArCW9mX25vZGVfcHV0KHJlc2V0X25vZGUpOw0KPiAgCXJldHVybiBlcnI7DQo+ICB9
DQo+ICANCg0KVGhhbmtzIGZvciB0aGlzIGZpeC4NCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1
IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg==

