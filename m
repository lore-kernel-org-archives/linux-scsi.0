Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF706C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 02:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F0360F91
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 02:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbhIACaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 22:30:12 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:33778 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S241128AbhIACaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 22:30:11 -0400
X-UUID: 81a3f0d36dea4684965fbf65a1210d6e-20210901
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=FW9zAYggfX8dinlAz5bx5Xo0bXQQW3EZJdhhHJPgEpI=;
        b=M2CrBQxr1uW2I8sVBbvkXyJyxcayavmxaTVBinKaj2RNMQoRCKoADn09KmydNGDuruhEJ1UmVHeBZh96A+3bdRqmK5TO3sf/UrOWym3BN2AjyBIKkpbxINWPC3eSry1xRZwP+7sZXUOkEVPhGzvXl0uXL1rfbHsvBScePcjIoM8=;
X-UUID: 81a3f0d36dea4684965fbf65a1210d6e-20210901
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 155577115; Wed, 01 Sep 2021 10:29:11 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 1 Sep 2021 10:29:10 +0800
Received: from mtksdccf07 (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 10:29:10 +0800
Message-ID: <da0ebaf6bb6e556eeb2f6fe4037d891bafc79ecd.camel@mediatek.com>
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
Date:   Wed, 1 Sep 2021 10:29:09 +0800
In-Reply-To: <dda8eb67-fe56-8bc0-5ce8-a62bd4e6b995@acm.org>
References: <1630325486-11741-1-git-send-email-peter.wang@mediatek.com>
         <dda8eb67-fe56-8bc0-5ce8-a62bd4e6b995@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KUkVHX1VGU19NVEtfSFdfVkVSIGlzIGEgcmVhZCBvbmx5IG1lZGlhdGVrIGRl
ZGljYXRlZCByZWdpc3Rlci4NClNvLCBod192ZXIgd2lsbCBnZXQgYSBjb25zdCB2YWx1ZSBmb3Ig
bWVkaWF0ZWsgdG8gZGVjaWRlIGhvdyB0byB1c2UNCmRlYnVnIHNlbGVjdC4gSXQgb25seSBuZWVk
IHJlYWQgb25jZSwgbm8gbmVlZCBtdWx0aS10aHJlYWRzIHByb3RlY3RlZC4NCg0KVGhhbmtzDQpQ
ZXRlcg0KDQoNCk9uIE1vbiwgMjAyMS0wOC0zMCBhdCAxOTo0NyAtMDcwMCwgQmFydCBWYW4gQXNz
Y2hlIHdyb3RlOg0KPiBPbiA4LzMwLzIxIDA1OjExLCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3
cm90ZToNCj4gPiArc3RhdGljIHZvaWQgdWZzX210a19kYmdfc2VsKHN0cnVjdCB1ZnNfaGJhICpo
YmEpDQo+ID4gK3sNCj4gPiArCXN0YXRpYyB1MzIgaHdfdmVyOw0KPiA+ICsNCj4gPiArCWlmICgh
aHdfdmVyKQ0KPiA+ICsJCWh3X3ZlciA9IHVmc2hjZF9yZWFkbChoYmEsIFJFR19VRlNfTVRLX0hX
X1ZFUik7DQo+ID4gKw0KPiA+ICsJaWYgKCgoaHdfdmVyID4+IDE2KSAmIDB4RkYpID49IDB4MzYp
IHsNCj4gPiArCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMHg4MjA4MjAsIFJFR19VRlNfREVCVUdfU0VM
KTsNCj4gPiArCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMHgwLCBSRUdfVUZTX0RFQlVHX1NFTF9CMCk7
DQo+ID4gKwkJdWZzaGNkX3dyaXRlbChoYmEsIDB4NTU1NTU1NTUsIFJFR19VRlNfREVCVUdfU0VM
X0IxKTsNCj4gPiArCQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMHhhYWFhYWFhYSwgUkVHX1VGU19ERUJV
R19TRUxfQjIpOw0KPiA+ICsJCXVmc2hjZF93cml0ZWwoaGJhLCAweGZmZmZmZmZmLCBSRUdfVUZT
X0RFQlVHX1NFTF9CMyk7DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCXVmc2hjZF93cml0ZWwoaGJh
LCAweDIwLCBSRUdfVUZTX0RFQlVHX1NFTCk7DQo+ID4gKwl9DQo+ID4gK30NCj4gDQo+IENhbiB1
ZnNfbXRrX2RiZ19zZWwoKSBiZSBjYWxsZWQgZnJvbSBtdWx0aXBsZSB0aHJlYWRzIGF0IHRoZSBz
YW1lDQo+IHRpbWU/IA0KPiBEb2VzIHRoZSAnaHdfdmVyJyB2YXJpYWJsZSBuZWVkIHRvIGJlIHBy
b3RlY3RlZCBhZ2FpbnN0IGNvbmN1cnJlbnQNCj4gd3JpdGVzPw0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCg==

