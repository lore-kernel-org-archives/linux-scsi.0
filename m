Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F353AC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 09:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F4720729
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 09:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LCFJjpAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgGVJOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 05:14:20 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:29411 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728173AbgGVJOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 05:14:20 -0400
X-UUID: 7f02d7a8c336470a87bf5af2ae3b8f85-20200722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=2v60ka6tTKHrTmYtX4f8Rm7FOuVYTW2hvwiG+u0x8wQ=;
        b=LCFJjpAclwZmc5PktJvHINCoPnxnH04QOOGxijuIfP8zjUw55bV6lcDmwSJxlMDniKi+Bc1/EP7FMzitEeYmDOu/di0CNM0lROdMNbPw+sPm2YioI7HQKHREynVjYfekEqvQFGk9z74Rw5HLIsm0shPdwqqcj6O9aDsZ5MWcSuk=;
X-UUID: 7f02d7a8c336470a87bf5af2ae3b8f85-20200722
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1435178830; Wed, 22 Jul 2020 17:14:18 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 22 Jul 2020 17:14:14 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 17:14:15 +0800
Message-ID: <1595409255.27178.17.camel@mtkswgap22>
Subject: Re: [RESEND RFC PATCH v1] scsi: ufs: add retries for SSU
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Lee Sang Hyun <sh425.lee@samsung.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <kwmad.kim@samsung.com>
Date:   Wed, 22 Jul 2020 17:14:15 +0800
In-Reply-To: <6ac05df5-71ff-e71d-a4df-94118f67caf1@acm.org>
References: <CGME20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b@epcas2p2.samsung.com>
         <1594971576-40264-1-git-send-email-sh425.lee@samsung.com>
         <6ac05df5-71ff-e71d-a4df-94118f67caf1@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 0DACB1621FB87BE6B0743621F188702504DEEFE7B97F089E1E8F60C089218FAB2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gU2F0LCAyMDIwLTA3LTE4IGF0IDEzOjMwIC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IE9uIDIwMjAtMDctMTcgMDA6MzksIExlZSBTYW5nIEh5dW4gd3JvdGU6
DQo+ID4gLQlyZXQgPSBzY3NpX2V4ZWN1dGUoc2RwLCBjbWQsIERNQV9OT05FLCBOVUxMLCAwLCBO
VUxMLCAmc3NoZHIsDQo+ID4gLQkJCVNUQVJUX1NUT1BfVElNRU9VVCwgMCwgMCwgUlFGX1BNLCBO
VUxMKTsNCj4gPiAtCWlmIChyZXQpIHsNCj4gPiAtCQlzZGV2X3ByaW50ayhLRVJOX1dBUk5JTkcs
IHNkcCwNCj4gPiAtCQkJICAgICJTVEFSVF9TVE9QIGZhaWxlZCBmb3IgcG93ZXIgbW9kZTogJWQs
IHJlc3VsdCAleFxuIiwNCj4gPiAtCQkJICAgIHB3cl9tb2RlLCByZXQpOw0KPiA+IC0JCWlmIChk
cml2ZXJfYnl0ZShyZXQpID09IERSSVZFUl9TRU5TRSkNCj4gPiAtCQkJc2NzaV9wcmludF9zZW5z
ZV9oZHIoc2RwLCBOVUxMLCAmc3NoZHIpOw0KPiA+ICsJZm9yIChyZXRyaWVzID0gMDsgcmV0cmll
cyA8IFNTVV9SRVRSSUVTOyByZXRyaWVzKyspIHsNCj4gPiArCQlyZXQgPSBzY3NpX2V4ZWN1dGUo
c2RwLCBjbWQsIERNQV9OT05FLCBOVUxMLCAwLCBOVUxMLCAmc3NoZHIsDQo+ID4gKwkJCQlTVEFS
VF9TVE9QX1RJTUVPVVQsIDAsIDAsIFJRRl9QTSwgTlVMTCk7DQo+ID4gKwkJaWYgKHJldCkgew0K
PiA+ICsJCQlzZGV2X3ByaW50ayhLRVJOX1dBUk5JTkcsIHNkcCwNCj4gPiArCQkJCSAgICAiU1RB
UlRfU1RPUCBmYWlsZWQgZm9yIHBvd2VyIG1vZGU6ICVkLCByZXN1bHQgJXhcbiIsDQo+ID4gKwkJ
CQkgICAgcHdyX21vZGUsIHJldCk7DQo+ID4gKwkJCWlmIChkcml2ZXJfYnl0ZShyZXQpID09IERS
SVZFUl9TRU5TRSkNCj4gPiArCQkJCXNjc2lfcHJpbnRfc2Vuc2VfaGRyKHNkcCwgTlVMTCwgJnNz
aGRyKTsNCj4gPiArCQl9IGVsc2Ugew0KPiA+ICsJCQlicmVhazsNCj4gPiArCQl9DQo+IA0KPiBU
aGUgbmludGggYXJndW1lbnQgb2Ygc2NzaV9leGVjdXRlKCkgaXMgY2FsbGVkICdyZXRyaWVzJy4g
V291bGRuJ3QgaXQgYmUNCj4gYmV0dGVyIHRvIHBhc3MgYSBub256ZXJvIHZhbHVlIGFzIHRoZSAn
cmV0cmllcycgYXJndW1lbnQgb2YNCj4gc2NzaV9leGVjdXRlKCkgaW5zdGVhZCBvZiBhZGRpbmcg
YSBsb29wIGFyb3VuZCB0aGUgc2NzaV9leGVjdXRlKCkgY2FsbD8NCg0KSWYgYSBTQ1NJIGNvbW1h
bmQgaXNzdWVkIHZpYSBzY3NpX2V4ZWN1dGUoKSBlbmNvdW50ZXJzICJ0aW1lb3V0IiBvcg0KImNo
ZWNrIGNvbmRpdGlvbiIsIHNjc2lfbm9yZXRyeV9jbWQoKSB3aWxsIHJldHVybiAxICh0cnVlKSBi
ZWNhdXNlDQpibGtfcnFfaXNfcGFzc3Rocm91Z2goKSBpcyB0cnVlIGR1ZSB0byBSRVFfT1BfU0NT
SV9JTiBvciBSRVFfT1BfU0NTSV9PVVQNCmZsYWcgd2FzIHNldCB0byB0aGlzIFNDU0kgY29tbWFu
ZCBieSBzY3NpX2V4ZWN1dGUoKS4gVGhlcmVmb3JlIGV2ZW4gYQ0Kbm9uLXplcm8gJ3JldHJpZXMn
IHZhbHVlIGlzIGFzc2lnbmVkIHdoaWxlIGNhbGxpbmcgc2NzaV9leGVjdXRlKCksIHRoZQ0KZmFp
bGVkIGNvbW1hbmQgaGFzIG5vIGNoYW5jZSB0byBiZSByZXRyaWVkIHNpbmNlIHRoZSBkZWNpc2lv
biB3aWxsIGJlDQpuby1yZXRyeSBieSBzY3NpX25vcmV0cnlfY21kKCkuDQoNCihUYWtlIGNvbW1h
bmQgdGltZW91dCBhcyBleGFtcGxlKQ0Kc2NzaV90aW1lc19vdXQoKS0+c2NzaV9hYm9ydF9jb21t
YW5kKCktPnNjbWRfZWhfYWJvcnRfaGFuZGxlcigpLCBoZXJlDQpzY3NpX25vcmV0cnlfY21kKCkg
cmV0dXJucyAxLCBhbmQgdGhlbiBjb21tYW5kIHdpbGwgYmUgZmluaXNoZWQgKHdpdGgNCmVycm9y
IGNvZGUpIHdpdGhvdXQgcmV0cnkuDQoNCkluIHNjc2lfbm9yZXRyeV9jbWQoKSwgdGhlcmUgaXMg
YSBjb21tZW50IG1lc3NhZ2UgaW4gc2VjdGlvbg0KImNoZWNrX3R5cGUiIGFzIGJlbG93DQoNCgkv
Kg0KCSAqIGFzc3VtZSBjYWxsZXIgaGFzIGNoZWNrZWQgc2Vuc2UgYW5kIGRldGVybWluZWQNCgkg
KiB0aGUgY2hlY2sgY29uZGl0aW9uIHdhcyByZXRyeWFibGUuDQoJICovDQoNCkkgYW0gbm90IHN1
cmUgaWYgInRpbWVvdXQiIGFuZCAiY2hlY2sgY29uZGl0aW9uIiBjYXNlcyBpbiBzdWNoIFNDU0kN
CmNvbW1hbmRzIGlzc3VlZCB2aWEgc2NzaV9leGVjdXRlKCkgYXJlIHNwZWNpYWxseSBkZXNpZ25l
ZCB0byBiZSB1bmFibGUNCnRvIHJldHJ5Lg0KDQpXb3VsZCB5b3UgaGF2ZSBhbnkgc3VnZ2VzdGlv
bnMgaWYgTExEIGRyaXZlcnMgd291bGQgbGlrZSB0byByZXRyeSB0aGVzZQ0Ka2luZHMgb2YgU0NT
SSBjb21tYW5kcz8NCg0KVGhhbmtzIGEgbG90LA0KU3RhbmxleSBDaHUNCg0K

