Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C015DC34031
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 07:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 991B620836
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 07:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hGs1vrG8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgBRHCs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 02:02:48 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:42207 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726104AbgBRHCr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 02:02:47 -0500
X-UUID: 08be96ec4594481da63ab274ea77ebbb-20200218
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SfQLOOesViht8zuhVZth6gVEBbimYGDRoLRh1mE3SdQ=;
        b=hGs1vrG84S+Pz2nTgA2P2nTRze0MIZaTGrFJUASFtwVira+GpWynxZrNlUhlyzdyX37T1sNlrykeNd83BAhFNIDWiBaoMaA4M91p+CZ402Oj3EKvMgJoLfqxKtKJVhpoNA6lWhW7M6QYf1SzhCOovGtJjlL4XfbgyytIJ7ssWVY=;
X-UUID: 08be96ec4594481da63ab274ea77ebbb-20200218
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 265033743; Tue, 18 Feb 2020 15:02:41 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 18 Feb 2020 15:00:11 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 18 Feb 2020 15:02:11 +0800
Message-ID: <1582009359.26304.29.camel@mtksdccf07>
Subject: Re: [PATCH v3 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Tue, 18 Feb 2020 15:02:39 +0800
In-Reply-To: <2a8fc44914b7ed8777a4a99ba6b8647a@codeaurora.org>
References: <1578726707-6596-1-git-send-email-stanley.chu@mediatek.com>
         <1578726707-6596-2-git-send-email-stanley.chu@mediatek.com>
         <2a8fc44914b7ed8777a4a99ba6b8647a@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 73E60B1B862E9A9A7A34435771FBADD9483B4202554A334657B8DC4403A419B82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQoNCj4gSGkgU3RhbmxleSwNCj4gDQo+IElzIHRoaXMgc2VyaWVzIG1lcmdlZD8g
SWYgbm8sIHdvdWxkIHlvdSBtaW5kIG1vdmluZw0KPiB1ZnNoY2Rfdm9wc19hcHBseV9kZXZfcXVp
cmtzKGhiYSwgY2FyZCk7IGEgbGl0dGxlIGJpdD8gTGlrZSBiZWxvdy4NCj4gDQo+IEBAIC02ODUy
LDE0ICs2ODUyLDE0IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF90dW5lX3VuaXByb19wYXJhbXMoc3Ry
dWN0IA0KPiB1ZnNfaGJhICpoYmEpDQo+ICAgICAgICAgICAgICAgICAgdWZzaGNkX3R1bmVfcGFf
aGliZXJuOHRpbWUoaGJhKTsNCj4gICAgICAgICAgfQ0KPiANCj4gKyAgICAgICB1ZnNoY2Rfdm9w
c19hcHBseV9kZXZfcXVpcmtzKGhiYSwgY2FyZCk7DQo+ICsNCj4gICAgICAgICAgaWYgKGhiYS0+
ZGV2X3F1aXJrcyAmIFVGU19ERVZJQ0VfUVVJUktfUEFfVEFDVElWQVRFKQ0KPiAgICAgICAgICAg
ICAgICAgIC8qIHNldCAxbXMgdGltZW91dCBmb3IgUEFfVEFDVElWQVRFICovDQo+ICAgICAgICAg
ICAgICAgICAgdWZzaGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01JQihQQV9UQUNUSVZBVEUpLCAx
MCk7DQo+IA0KPiBJbiB0aGlzIHdheSwgdmVuZG9yIGNvZGVzIGhhdmUgYSBjaGFuY2UgdG8gbW9k
aWZ5IHRoZSBkZXZfcXVpcmtzDQo+IGJlZm9yZSB1ZnNoY2RfdHVuZV91bmlwcm9fcGFyYW1zKCkg
ZG9lcyB0aGUgcmVzdCBvZiBpdHMgam9iLg0KPiANCg0KVGhpcyBwYXRjaCBoYXMgYmVlbiBtZXJn
ZWQgdG8gNS42LXJjMS4NCg0KQmFzaWNhbGx5IEkgYW0gZmluZSB3aXRoIHlvdXIgcHJvcG9zYWwu
IEJ1dCBpZiB5b3UgbmVlZCB0byBtb3ZlIGl0IHRvDQpuZXcgbWVudGlvbmVkIHBvc2l0aW9uLCBv
dXIgYXBwbHlfZGV2X3F1aXJrcyBjYWxsYmFjayBhbHNvIG5lZWQNCmNvcnJlc3BvbmRpbmcgY2hh
bmdlIHNvIGl0IG1pZ2h0IG5lZWQgb3VyIGNvLXdvcmtzIDogKQ0KDQpGb3IgZXhhbXBsZSwgeW91
IGNvdWxkIGp1c3QgcG9zdCB5b3VyIHByb3Bvc2VkIGNoYW5nZXMgYW5kIHRoZW4gd2Ugd291bGQN
CnByb3ZpZGUgY29ycmVzcG9uZGluZyBjaGFuZ2UgYXMgc29vbiBhcyBwb3NzaWJsZT8NCg0KQmVz
aWRlcywgSSB3b3VsZCBsaWtlIHRvIHJlbWluZCB0aGF0IGFsbG93aW5nIHZlbmRvciB0byAiZml4
IiBkZXZpY2UNCnF1aXJrcyBpbiBhZHZhbmNlIGltcGx5IHRoYXQgY3VycmVudCBjb21tb24gZGV2
aWNlIHF1aXJrcyBoYXZlIHNvbWUNCnByb2JsZW1zPyBJZiBzbywgd291bGQgeW91IGNvbnNpZGVy
IHRvIGZpeCBjb21tb24gZGV2aWNlIHF1aXJrcyBpbnN0ZWFkPw0KDQoNCj4gVGhhbmtzLA0KPiBD
YW4gR3VvLg0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0KDQoNCg==

