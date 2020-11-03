Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E849C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18ED6208B6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 07:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PUtkyKF0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKCHHr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 02:07:47 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:42291 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgKCHHr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 02:07:47 -0500
X-UUID: 0cd27029a24f41bca58df90019b241ea-20201103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=xgZxM4bZdBoYMDGnpcKBnJHgKjg4eO6nDZKJOGIeWdo=;
        b=PUtkyKF0b3dBSMtd3cT167RsJne4PCUmgNlL025Hyu28j28uMYl/OclqQ41hYONY4kq+3wA2lmY8+3x8wUTSnReKNs5F3a/nMvaxOe0Nm5iDiibf6qNZmuXhmxBCrO8bjfWI67gY1zU3Ip93FM4PoKC03BkETquvzoCe15viT3c=;
X-UUID: 0cd27029a24f41bca58df90019b241ea-20201103
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 957126120; Tue, 03 Nov 2020 15:07:44 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Nov 2020 15:07:42 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Nov 2020 15:07:42 +0800
Message-ID: <1604387262.13152.2.camel@mtkswgap22>
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
Date:   Tue, 3 Nov 2020 15:07:42 +0800
In-Reply-To: <1604384682-15837-2-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
         <1604384682-15837-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 295080CDDDD8E39A2ADF44384CB5E35A2D4E5055CC367A2FD534E280F511F3EC2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBNb24sIDIwMjAtMTEtMDIgYXQgMjI6MjQgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IFRoZSBzY3NpX2Jsb2NrX3JlcXNfY250IGluY3JlYXNlZCBpbiB1ZnNoY2RfaG9sZCgp
IGlzIHN1cHBvc2VkIHRvIGJlDQo+IGRlY3JlYXNlZCBiYWNrIGluIHVmc2hjZF91bmdhdGVfd29y
aygpIGluIGEgcGFpcmVkIHdheS4gSG93ZXZlciwgaWYNCj4gc3BlY2lmaWMgdWZzaGNkX2hvbGQv
cmVsZWFzZSBzZXF1ZW5jZXMgYXJlIG1ldCwgaXQgaXMgcG9zc2libGUgdGhhdA0KPiBzY3NpX2Js
b2NrX3JlcXNfY250IGlzIGluY3JlYXNlZCB0d2ljZSBidXQgb25seSBvbmUgdW5nYXRlIHdvcmsg
aXMNCj4gcXVldWVkLiBUbyBtYWtlIHN1cmUgc2NzaV9ibG9ja19yZXFzX2NudCBpcyBoYW5kbGVk
IGJ5IHVmc2hjZF9ob2xkKCkgYW5kDQoNCkp1c3QgY3VyaW91cyB0aGF0IGhvdyBjb3VsZCB0aGlz
IGJlIHBvc3NpYmxlPyBXb3VsZCB5b3UgaGF2ZSBzb21lIGZhaWxlZA0KZXhhbXBsZXM/DQoNCj4g
dWZzaGNkX3VuZ2F0ZV93b3JrKCkgaW4gYSBwYWlyZWQgd2F5LCBpbmNyZWFzZSBpdCBvbmx5IGlm
IHF1ZXVlX3dvcmsoKQ0KPiByZXR1cm5zIHRydWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4g
R3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KPiBSZXZpZXdlZC1ieTogSG9uZ3d1IFN1IDxob25n
d3VzQGNvZGVhdXJvcmEub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMg
fCA2ICsrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCA4NDdmMzU1Li5lZmE3ZDg2IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCj4gQEAgLTE2MzQsMTIgKzE2MzQsMTIgQEAgaW50IHVmc2hjZF9ob2xkKHN0
cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgYXN5bmMpDQo+ICAJCSAqLw0KPiAgCQkvKiBmYWxsdGhy
b3VnaCAqLw0KPiAgCWNhc2UgQ0xLU19PRkY6DQo+IC0JCXVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVl
c3RzKGhiYSk7DQo+ICAJCWhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IFJFUV9DTEtTX09OOw0KPiAg
CQl0cmFjZV91ZnNoY2RfY2xrX2dhdGluZyhkZXZfbmFtZShoYmEtPmRldiksDQo+ICAJCQkJCWhi
YS0+Y2xrX2dhdGluZy5zdGF0ZSk7DQo+IC0JCXF1ZXVlX3dvcmsoaGJhLT5jbGtfZ2F0aW5nLmNs
a19nYXRpbmdfd29ya3EsDQo+IC0JCQkgICAmaGJhLT5jbGtfZ2F0aW5nLnVuZ2F0ZV93b3JrKTsN
Cj4gKwkJaWYgKHF1ZXVlX3dvcmsoaGJhLT5jbGtfZ2F0aW5nLmNsa19nYXRpbmdfd29ya3EsDQo+
ICsJCQkgICAgICAgJmhiYS0+Y2xrX2dhdGluZy51bmdhdGVfd29yaykpDQo+ICsJCQl1ZnNoY2Rf
c2NzaV9ibG9ja19yZXF1ZXN0cyhoYmEpOw0KPiAgCQkvKg0KPiAgCQkgKiBmYWxsIHRocm91Z2gg
dG8gY2hlY2sgaWYgd2Ugc2hvdWxkIHdhaXQgZm9yIHRoaXMNCj4gIAkJICogd29yayB0byBiZSBk
b25lIG9yIG5vdC4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0K

