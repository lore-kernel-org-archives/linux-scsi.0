Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEFAC388F9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E72822243
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M24ObXQ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgKCOEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:04:51 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:43857 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729432AbgKCOEB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 09:04:01 -0500
X-UUID: e74818044ead4c7fa295b06134707924-20201103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bhRnUTD1xu2itKmWSn3uPQ8AOD0EU3W6g5Vk2gTnsog=;
        b=M24ObXQ5CD6jDsnzqejx95O9k6+44puG5qPRrd7A4MkNX1SL/+hnArNJ04XAsJgxD0UEZoGO0u4QApOlct7z50bXKxDLNQ931wM8DmLdXu9zIa6Ll8i3NyLdHTxRF2oSEErvjrBDnaRWFdGwXo4llB2/L8LMUrSe9XolbhWLVlM=;
X-UUID: e74818044ead4c7fa295b06134707924-20201103
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1008270133; Tue, 03 Nov 2020 22:03:48 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Nov 2020 22:03:47 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Nov 2020 22:03:46 +0800
Message-ID: <1604412227.13152.11.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Fix unbalanced scsi_block_reqs_cnt
 caused by ufshcd_hold()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 3 Nov 2020 22:03:47 +0800
In-Reply-To: <09c5d4d31a0bd9bed99815cfbf51aaad@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
         <1604384682-15837-2-git-send-email-cang@codeaurora.org>
         <1604387262.13152.2.camel@mtkswgap22>
         <09c5d4d31a0bd9bed99815cfbf51aaad@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMjAtMTEtMDMgYXQgMTg6MDEgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IE9uIDIwMjAtMTEtMDMgMTU6MDcsIFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+IEhpIENh
biwNCj4gPiANCj4gPiBPbiBNb24sIDIwMjAtMTEtMDIgYXQgMjI6MjQgLTA4MDAsIENhbiBHdW8g
d3JvdGU6DQo+ID4+IFRoZSBzY3NpX2Jsb2NrX3JlcXNfY250IGluY3JlYXNlZCBpbiB1ZnNoY2Rf
aG9sZCgpIGlzIHN1cHBvc2VkIHRvIGJlDQo+ID4+IGRlY3JlYXNlZCBiYWNrIGluIHVmc2hjZF91
bmdhdGVfd29yaygpIGluIGEgcGFpcmVkIHdheS4gSG93ZXZlciwgaWYNCj4gPj4gc3BlY2lmaWMg
dWZzaGNkX2hvbGQvcmVsZWFzZSBzZXF1ZW5jZXMgYXJlIG1ldCwgaXQgaXMgcG9zc2libGUgdGhh
dA0KPiA+PiBzY3NpX2Jsb2NrX3JlcXNfY250IGlzIGluY3JlYXNlZCB0d2ljZSBidXQgb25seSBv
bmUgdW5nYXRlIHdvcmsgaXMNCj4gPj4gcXVldWVkLiBUbyBtYWtlIHN1cmUgc2NzaV9ibG9ja19y
ZXFzX2NudCBpcyBoYW5kbGVkIGJ5IHVmc2hjZF9ob2xkKCkgDQo+ID4+IGFuZA0KPiA+IA0KPiA+
IEp1c3QgY3VyaW91cyB0aGF0IGhvdyBjb3VsZCB0aGlzIGJlIHBvc3NpYmxlPyBXb3VsZCB5b3Ug
aGF2ZSBzb21lIA0KPiA+IGZhaWxlZA0KPiA+IGV4YW1wbGVzPw0KPiA+IA0KPiANCj4gWzFdIE9u
ZSBnYXRlX3dvcmsoKSBpcyBpbiB0aGUgd29ya3F1ZXVlLCBub3QgeWV0IGV4ZWN1dGVkLCBub3cg
Y2xrIHN0YXRlIA0KPiA9PSBSRVFfQ0xLU19PRkYuDQo+IFsyXSB1ZnNoY2RfcXVldWVjb21tYW5k
KCkgY2FsbHMgdWZzaGNkX2hvbGQoYXN5bmMgPT0gdHVyZSkgLT4gDQo+IGFjdGl2ZV9yZXErKyAt
PiBzY3NpX2Jsb2NrX3JlcXNfY250KysgLT4gUkVRX0NMS1NfT04gLT4gcXVldWUgdW5nYXRlIA0K
PiB3b3JrIC0+IGFjdGl2ZV9yZXEtLSAtPiByZXR1cm4gLUVBR0FJTi4NCj4gWzNdIE5vdyBnYXRl
X3dvcmsoKSBzdGFydHMgdG8gcnVuLCBidXQgc2luY2UgdGhlIGNsayBzdGF0ZSBpcyANCj4gUkVR
X0NMS1NfT04sIGdhdGVfd29yaygpIGp1c3Qgc2V0cyBjbGsgc3RhdGUgdG8gQ0xLU19PTiBhbmQg
YmFpbC4NCj4gWzNdIFNvbWVvbmUgY2FsbHMgdWZzaGNkX2hvbGQoYXN5bmMgPT0gZmFsc2UpIC0+
IGRvIHNvbWV0aGluZyAtPiANCj4gdWZzaGNkX3JlbGVhc2UoKSAtPiBjbGsgc3RhdGUgaXMgY2hh
bmdlZCB0byBSRVFfQ0xLU19PRkYuIE5vdGUgdGhhdCwgDQo+IHRpbGwgbm93LCB1bmdhdGVfd29y
aygpIGlzIHN0aWxsIGluIHRoZSB3b3JrIHF1ZXVlLCBub3QgZXhlY3V0ZWQgeWV0Lg0KPiBbNF0g
Tm93LCBpZiBzb21lb25lIGNhbGxzIHVmc2hjZF9ob2xkKCksIHdlIHdpbGwgaGl0IHRoZSBpc3N1
ZS4NCj4gDQo+IEFib3ZlIHNlcXVlbmNlIGlzIGEgdmVyeSBjb21tb24gY2xrIGdhdGUvdW5nYXRl
IHNlcXVlbmNlLiBUaGUgaXNzdWUNCj4gaXMgYmVjYXVzZSB1bmdhdGVfd29yayBpcyBxdWV1ZWQg
YnV0IGNhbm5vdCBiZSBleGVjdXRlZCBpbiB0aW1lLiBJbiBteQ0KPiBjYXNlLCBJIHNlZSB0aGUg
dW5nYXRlX3dvcmsgaXMgc29tZWhvdyBkZWxheWVkIGZvciBhYm91dCAxNTBtcy4gVGhpcw0KPiBj
aGFuZ2UgaGFzIGJlZW4gdGVzdGVkIGJ5IGN1c3RvbWVycyBvbiBtdWx0aXBsZSBwbGF0Zm9ybXMu
IEFuZCB5b3UNCj4gY2FuIHRlbGwgZnJvbSB0aGUgY29kZSB0aGF0IGl0IHdvbid0IGJyZWFrIGFu
eXRoaW5nLiA6KQ0KDQpUaGFua3Mgc28gbXVjaCBmb3IgdGhlIGRldGFpbHMuIExvb2tzIGdvb2Qg
dG8gbWUuDQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsu
Y29tPg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBDYW4gR3VvLg0KPiANCj4gPj4gdWZzaGNkX3Vu
Z2F0ZV93b3JrKCkgaW4gYSBwYWlyZWQgd2F5LCBpbmNyZWFzZSBpdCBvbmx5IGlmIHF1ZXVlX3dv
cmsoKQ0KPiA+PiByZXR1cm5zIHRydWUuDQo+ID4+IA0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBDYW4g
R3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KPiA+PiBSZXZpZXdlZC1ieTogSG9uZ3d1IFN1IDxo
b25nd3VzQGNvZGVhdXJvcmEub3JnPg0KPiA+PiAtLS0NCj4gPj4gIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgfCA2ICsrKy0tLQ0KPiA+PiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCj4gPj4gDQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+PiBpbmRleCA4NDdm
MzU1Li5lZmE3ZDg2IDEwMDY0NA0KPiA+PiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQo+ID4+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPj4gQEAgLTE2MzQsMTIg
KzE2MzQsMTIgQEAgaW50IHVmc2hjZF9ob2xkKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgDQo+
ID4+IGFzeW5jKQ0KPiA+PiAgCQkgKi8NCj4gPj4gIAkJLyogZmFsbHRocm91Z2ggKi8NCj4gPj4g
IAljYXNlIENMS1NfT0ZGOg0KPiA+PiAtCQl1ZnNoY2Rfc2NzaV9ibG9ja19yZXF1ZXN0cyhoYmEp
Ow0KPiA+PiAgCQloYmEtPmNsa19nYXRpbmcuc3RhdGUgPSBSRVFfQ0xLU19PTjsNCj4gPj4gIAkJ
dHJhY2VfdWZzaGNkX2Nsa19nYXRpbmcoZGV2X25hbWUoaGJhLT5kZXYpLA0KPiA+PiAgCQkJCQlo
YmEtPmNsa19nYXRpbmcuc3RhdGUpOw0KPiA+PiAtCQlxdWV1ZV93b3JrKGhiYS0+Y2xrX2dhdGlu
Zy5jbGtfZ2F0aW5nX3dvcmtxLA0KPiA+PiAtCQkJICAgJmhiYS0+Y2xrX2dhdGluZy51bmdhdGVf
d29yayk7DQo+ID4+ICsJCWlmIChxdWV1ZV93b3JrKGhiYS0+Y2xrX2dhdGluZy5jbGtfZ2F0aW5n
X3dvcmtxLA0KPiA+PiArCQkJICAgICAgICZoYmEtPmNsa19nYXRpbmcudW5nYXRlX3dvcmspKQ0K
PiA+PiArCQkJdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoaGJhKTsNCj4gPj4gIAkJLyoNCj4g
Pj4gIAkJICogZmFsbCB0aHJvdWdoIHRvIGNoZWNrIGlmIHdlIHNob3VsZCB3YWl0IGZvciB0aGlz
DQo+ID4+ICAJCSAqIHdvcmsgdG8gYmUgZG9uZSBvciBub3QuDQo+ID4gDQo+ID4gVGhhbmtzLA0K
PiA+IFN0YW5sZXkgQ2h1DQoNCg==

