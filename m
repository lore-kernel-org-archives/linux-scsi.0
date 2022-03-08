Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354BDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 11:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346179AbiCHLZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 06:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346157AbiCHLZ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 06:25:56 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7834D443E6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 03:24:53 -0800 (PST)
X-UUID: e4cfb6cc7c324b68baf03c7dd4c69d78-20220308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=VCqyF3JTD6ZKCW7IlrDyc7gXNwJ8eZM/l7AflgbgOQU=;
        b=d8NtzYavAeYFRL7s+4JHVq/dCYDVm1py0uk9nBca7zzLsNuU5SGDFWdgyCE+RV98TDyc7rFTzbf4UUFfTf7WoBqVsKsfziitf6M6M6SRbVJGzezKduLoMd669KF+kZEuj7YqIeNWl87o6KCjO997aOwJMXRPuT5YI+uAW/hgxrM=;
X-UUID: e4cfb6cc7c324b68baf03c7dd4c69d78-20220308
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 593439344; Tue, 08 Mar 2022 19:24:47 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 8 Mar 2022 19:24:47 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Mar 2022 19:24:46 +0800
Subject: Re: [PATCH v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <mikebi@micron.com>, <beanhuo@micron.com>
References: <20220307111752.10465-1-peter.wang@mediatek.com>
 <19ad4174-0435-85b2-0762-1fae5e0b5f9e@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <27c3e5fa-33ca-ad03-2a2d-9e35c4644385@mediatek.com>
Date:   Tue, 8 Mar 2022 19:24:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <19ad4174-0435-85b2-0762-1fae5e0b5f9e@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KDQpXaGVuIHNjc2kgc2NhbiBpbiBzY3NpX3Byb2JlX2x1biBmdW5jdGlvbiwg
dGhlcmUgaGF2ZSBtdWNoIElOUVVJUlkoMHgxMikgDQpjb21tYW5kDQp3aXRoIHNlY3Rvcl9zaXpl
IGlzIDAuDQp1bnNpZ25lZCBpbnQgc2hpZnQgd2lsbCBnZXQgNDI5NDk2NzI4NiAoc2lnbmVkIC0x
MCkgYW5kIGFuIHNlY3Rvcl90IHR5cGUgDQppcyA2NCBiaXQuDQpTaGlmdCA2NGJpdCByaWdodCA0
Mjk0OTY3Mjg2IHdpbGwgaGF2ZSB1YnNhbiBlcnJvciBiZWNhdXNlIHVic2FuIHRoaW5rDQpzaGlm
dCBudW1iZXIgc2hvdWxkIGJlIHdyb25nIGFuZCByZXR1cm4gMCBhbHdheXMuDQpCVFcsIHdlIG9u
bHkgbmVlZCB0aGUgbGJhIGluZm9ybWF0aW9uIHdoZW4gcmVhZC93cml0ZS91bm1hcC4gT3RoZXIg
DQpjb21tYW5kIHN1Y2gNCmFzIElOUVVJUlkgaXMgdXNlbGVzcy4NCg0Kc3RhdGljIGlubGluZSBz
ZWN0b3JfdCBzY3NpX2dldF9sYmEoc3RydWN0IHNjc2lfY21uZCAqc2NtZCkNCnsNCiDCoMKgwqAg
dW5zaWduZWQgaW50IHNoaWZ0ID0gaWxvZzIoc2NtZC0+ZGV2aWNlLT5zZWN0b3Jfc2l6ZSkgLSAN
ClNFQ1RPUl9TSElGVDsgPD3CoCBzaGlmdCBpcyA0Mjk0OTY3Mjg2ICgtMS05PS0xMCkNCg0KIMKg
wqDCoCByZXR1cm4gYmxrX3JxX3BvcyhzY3NpX2NtZF90b19ycShzY21kKSkgPj4gc2hpZnQ7wqAg
PD0gc2VjdG9yX3QgdHlwZSANCiA+PiA0Mjk0OTY3Mjg2IHdpbGwgYWx3YXlzIGdldCAwLg0KfQ0K
DQoNCk9uIDMvOC8yMiAxOjUyIEFNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+DQo+IEhtbSAu
Li4gaG93IGNhbiBpdCBoYXBwZW4gdGhhdCBzZWN0b3Jfc2l6ZSBoYXMgbm90IGJlZW4gc2V0PyBJ
IHRoaW5rIA0KPiB0aGF0IGNhbiBvbmx5IGhhcHBlbiBmb3IgTFVOcyBvZiB0eXBlIFNDU0kgRElT
SyBpZiBzZF9yZWFkX2NhcGFjaXR5KCkgDQo+IGZhaWxzPyBJZiBzZF9yZWFkX2NhcGFjaXR5KCkg
ZmFpbHMgSSB0aGluayB0aGUgc2QgZHJpdmVyIGlzIGV4cGVjdGVkIA0KPiB0byBzZXQgdGhlIGNh
cGFjaXR5IHRvIHplcm8/DQo+DQo+IHJxLT5fX3NlY3RvciA9PSAtMSBmb3IgZmx1c2ggcmVxdWVz
dHMgYW5kIHRoZSB0eXBlIG9mIHRoYXQgbWVtYmVyIA0KPiAoc2VjdG9yX3QpIGlzIHVuc2lnbmVk
LiBJIHRoaW5rIHRoYXQgaXQgaXMgYWxsb3dlZCBmb3IgYSBzaGlmdCBsZWZ0IG9mIA0KPiBhbiB1
bnNpZ25lZCB0eXBlIHRvIG92ZXJmbG93LiBGcm9tIHRoZSBDIHN0YW5kYXJkOiAiVGhlIHJlc3Vs
dCBvZiBFMSANCj4gPDwgRTIgaXMgRTEgbGVmdC1zaGlmdGVkIEUyIGJpdCBwb3NpdGlvbnM7IHZh
Y2F0ZWQgYml0cyBhcmUgZmlsbGVkIHdpdGgNCj4gemVyb3MuIElmIEUxIGhhcyBhbiB1bnNpZ25l
ZCB0eXBlLCB0aGUgdmFsdWUgb2YgdGhlIHJlc3VsdCBpcyBFMSDDlyAyRTIgDQo+ICwgcmVkdWNl
ZCBtb2R1bG8gb25lIG1vcmUgdGhhbiB0aGUgbWF4aW11bSB2YWx1ZSByZXByZXNlbnRhYmxlIGlu
IHRoZSANCj4gcmVzdWx0IHR5cGUuIg0KPg0KPiBUaGFua3MsDQo+DQo+IEJhcnQuDQoNCg0KDQo=

