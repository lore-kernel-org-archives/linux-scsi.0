Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48C8C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 10:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70FDC206D7
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 10:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mRHGFzuK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgGVKHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 06:07:44 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:53379 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726153AbgGVKHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 06:07:44 -0400
X-UUID: 173e8a484fba49b2a7d3d912af0f09fb-20200722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=hpw2HAjj+VZcqiXE9JCKu3K69kU6aLIL+g4N7qmAH6w=;
        b=mRHGFzuKX9VZw96ff4c5f+9dfqcbnhKnypVjEdvx0T5KV1k4oP6RFw4kVncj2pVoQda4IKsJ4OtFALdk1eJSyo3oHZuseqxJn9ceDA0E8IyOvEUUdbneUyiDDTuvxZkOJm8pOuqHExboSGjjCc+KLfEUz+uKS4Or1vsw62KCgvU=;
X-UUID: 173e8a484fba49b2a7d3d912af0f09fb-20200722
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 365314642; Wed, 22 Jul 2020 18:07:39 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 22 Jul 2020 18:07:36 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 18:07:36 +0800
Message-ID: <1595412457.27178.36.camel@mtkswgap22>
Subject: Re: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Avri Altman <Avri.Altman@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Date:   Wed, 22 Jul 2020 18:07:37 +0800
In-Reply-To: <912623e8-5915-8380-f39a-fac7b5868a6d@acm.org>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <3d509c4b-d66d-2a4a-5fbd-a50a0610ad31@acm.org>
         <1594607245.22878.8.camel@mtkswgap22>
         <SN6PR04MB46409838AE9D4BD63797E26DFC600@SN6PR04MB4640.namprd04.prod.outlook.com>
         <912623e8-5915-8380-f39a-fac7b5868a6d@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwgQXZyaSwNCg0KT24gVHVlLCAyMDIwLTA3LTE0IGF0IDIxOjAwIC0wNzAwLCBCYXJ0
IFZhbiBBc3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDctMTMgMDE6MTAsIEF2cmkgQWx0bWFuIHdy
b3RlOg0KPiA+IEFydGlmaWNpYWxseSBpbmplY3RpbmcgZXJyb3JzIGlzIGEgdmVyeSBjb21tb24g
dmFsaWRhdGlvbiBtZWNoYW5pc20sDQo+ID4gUHJvdmlkZWQgdGhhdCB5b3UgYXJlIG5vdCBicmVh
a2luZyBhbnl0aGluZyBvZiB0aGUgdXBwZXItbGF5ZXJzLA0KPiA+IFdoaWNoIEkgZG9uJ3QgdGhp
bmsgeW91IGFyZSBkb2luZy4NCj4gDQoNCkFzIHRoZSBjb25jZXJucyBvZiBiZWxvdyBxdWVzdGlv
bnMsDQoNCiJzY3NpIHRpbWVvdXQgaXMgMzBzZWMgLSBkbyB5b3UgZXhwZWN0IGFuIGludGVycnVw
dCB0byBhcnJpdmUgYWZ0ZXINCnRoYXQ/Ig0KDQpBY3R1YWxseSBpbiBteSB0ZXN0IHNjZW5hcmlv
LCB0aGUgZmxvdyB3b3JrcyB3ZWxsIHdpdGhvdXQgcmUtY2hlY2tpbmcNCiJvdXRzdGFuZGluZ19y
ZXFzIiBpbiAiY2xlYW51cCIgc2VjdGlvbiBpbiB1ZnNoY2RfYWJvcnQoKSwgc28gSSB3b3VsZA0K
cmVtb3ZlIHRoaXMgY2hlY2tpbmcgZmlyc3QgYW5kIHJlc2VuZCB0aGlzIGZpeCAod2l0aCByZWZp
bmVkIGNvbW1pdA0KbWVzc2FnZSBhY2NvcmRpbmcgdG8gYmxrLW1xLCBub3QgbGVnYWN5IGJsayku
IFBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3UNCmhhdmUgYW55IHN1Z2dlc3Rpb25zLg0KDQo+IEhp
IEF2cmksDQo+IA0KPiBNeSBjb25jZXJuIGlzIHRoYXQgdGhlIGNvZGUgdGhhdCBpcyBiZWluZyBh
ZGRlZCBpbiB0aGUgYWJvcnQgaGFuZGxlcg0KPiBzb29uZXIgb3IgbGF0ZXIgd2lsbCBldm9sdmUg
aW50byBhIGR1cGxpY2F0ZSBvZiB0aGUgcmVndWxhciBjb21wbGV0aW9uDQo+IHBhdGguIFdvdWxk
bid0IGl0IGJlIGJldHRlciB0byBwb2xsIGZvciBjb21wbGV0aW9ucyBmcm9tIHRoZSB0aW1lb3V0
DQo+IGhhbmRsZXIgYnkgY2FsbGluZyB1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkgaW5zdGVh
ZCBvZiBkdXBsaWNhdGluZw0KPiB0aGF0IGZ1bmN0aW9uPw0KPiANCg0KVGhlIGR1cGxpY2F0ZWQg
Y2FsbHMgb2YgY2xlYW51cCBqb2Igd291bGQgYmUgYXMgYmVsb3csDQoNCnNjc2lfZG1hX3VubWFw
KGNtZCk7DQpoYmEtPmxyYlt0YWddLmNtZCA9IE5VTEw7DQp1ZnNoY2Rfb3V0c3RhbmRpbmdfcmVx
X2NsZWFyKGhiYSwgdGFnKTsNCg0KQXMgeW91ciBzdWdnZXN0aW9ucywgYWJvdmUgY2FsbHMgY291
bGQgYmUgcmUtZmFjdG9yZWQgYnV0IHRoZSB0aGlyZCBjYWxsDQppbiBfX3Vmc2hjZF90cmFuc2Zl
cl9yZXFfY29tcGwoKSB3b3VsZCBiZSBtb3JlIGVmZmljaWVudCBieQ0KDQpoYmEtPm91dHN0YW5k
aW5nX3JlcXMgXj0gY29tcGxldGVkX3JlcXM7DQoNCmZvciBhbGwgaGFuZGxlZCByZXF1ZXN0cyBp
biBpbnRlcnJ1cHQgaGFuZGxlci4NCg0KDQpIZXJlIHdlIGNvdWxkIG5vdCBkaXJlY3RseSB1c2Ug
InVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSIgb3IgaXRzDQppbm5lciBmdW5jdGlvbiAiX191
ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkiIHNpbmNlIGF0IGxlYXN0DQpzY3NpX2RvbmUoKSBp
cyBub3QgcmVxdWlyZWQgaW4gdWZzaGNkX2Fib3J0KCkgYmVjYXVzZSB0aGUgY29tcGxldGlvbg0K
ZmxvdyB3aWxsIGJlIGhhbmRsZWQgYnkgU0NTSSBlcnJvciBoYW5kbGVyLCBub3QgdWZzaGNkX2Fi
b3J0KCkgaXRzZWxmLg0KDQo+ID4+PiBJbiBzZWN0aW9uIDcuMi4zIG9mIHRoZSBVRlMgc3BlY2lm
aWNhdGlvbiBJIGZvdW5kIHRoZSBmb2xsb3dpbmcgYWJvdXQgaG93DQo+ID4+PiB0byBwcm9jZXNz
IHJlcXVlc3QgY29tcGxldGlvbnM6ICJTb2Z0d2FyZSBkZXRlcm1pbmVzIGlmIG5ldyBUUnMgaGF2
ZQ0KPiA+Pj4gY29tcGxldGVkIHNpbmNlIHN0ZXAgIzIsIGJ5IHJlcGVhdGluZyBvbmUgb2YgdGhl
IHR3byBtZXRob2RzIGRlc2NyaWJlZCBpbg0KPiA+Pj4gc3RlcCAjMi4gSWYgbmV3IFRScyBoYXZl
IGNvbXBsZXRlZCwgc29mdHdhcmUgcmVwZWF0cyB0aGUgc2VxdWVuY2UgZnJvbQ0KPiA+Pj4gc3Rl
cCAjMy4iIElzIHN1Y2ggYSBsb29wIHBlcmhhcHMgbWlzc2luZyBmcm9tIHRoZSBMaW51eCBVRlMg
ZHJpdmVyPw0KPiA+DQo+ID4gQ291bGQgbm90IGZpbmQgdGhhdCBjaXRhdGlvbi4NCj4gPiBXaGF0
IHZlcnNpb24gb2YgdGhlIHNwZWMgYXJlIHlvdSB1c2luZz8NCj4gDQo+IFRoYXQgcXVvdGUgY29t
ZXMgZnJvbSB0aGUgZm9sbG93aW5nIGRvY3VtZW50OiAiVW5pdmVyc2FsIEZsYXNoIFN0b3JhZ2UN
Cj4gSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSAoVUZTSENJKTsgVmVyc2lvbiAyLjE7IEpFU0Qy
MjNDOyAoUmV2aXNpb24gb2YNCj4gSkVTRDIyM0IsIFNlcHRlbWJlciAyMDEzKTsgTUFSQ0ggMjAx
NiIuDQoNCkFib3ZlIGRlc2NyaXB0aW9uIGhhcyBhbHJlYWR5IGJlIGltcGxlbWVudGVkIGluIHVm
c2hjZF9pbnRyKCkgYW5kDQp1ZnNoY2RfdHJhbnNmZXJfcmVxX2NvbXBsKCkuIEJ1dCB0aGlzIGxv
b3AgY2Fubm90IHNhdmUgIm1pc3NpbmcNCmludGVycnVwdCIganVzdCBsaWtlIHRoaXMgaW5qZWN0
ZWQgZXJyb3IgY2FzZS4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K

