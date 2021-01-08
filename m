Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A990C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 13:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D61B235FF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 13:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbhAHNMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 08:12:54 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40594 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726059AbhAHNMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2021 08:12:54 -0500
X-UUID: cecef018bc0d4f02950e23be2bc834bc-20210108
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=xvHCLfau5532o79KqB8nrVItQ9GKcRreL4jTT5niOnc=;
        b=Jz+i7ZV2mm2YgGDa0kJW9NN08IpryUnl57VegN2qPevH0ssTqmTmRsr5xyXfSZIm7x/APmIBVPSyVXlzazvFFNhIXyU/wbcDlFgk1AqrE5MS/A08sGwhVr9/hob4W+aXREAzNTlJdJK+Ufj95Iartd3c/aXCQHsw3xM+ZD1wnIQ=;
X-UUID: cecef018bc0d4f02950e23be2bc834bc-20210108
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 841503156; Fri, 08 Jan 2021 21:12:05 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 8 Jan 2021 21:11:43 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 Jan 2021 21:11:43 +0800
Message-ID: <1610111503.17820.1.camel@mtkswgap22>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     Can Guo <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <ziqichen@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>, <rjw@rjwysocki.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        "open list" <linux-kernel@vger.kernel.org>
Date:   Fri, 8 Jan 2021 21:11:43 +0800
In-Reply-To: <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
         <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
         <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
         <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
         <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
         <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gRnJpLCAyMDIxLTAxLTA4IGF0IDEyOjI5ICswMTAwLCBCZWFuIEh1byB3
cm90ZToNCj4gT24gV2VkLCAyMDIxLTAxLTA2IGF0IDA5OjIwICswODAwLCBDYW4gR3VvIHdyb3Rl
Og0KPiA+IEhpIEJlYW4sDQo+ID4gDQo+ID4gT24gMjAyMS0wMS0wNiAwMjozOCwgQmVhbiBIdW8g
d3JvdGU6DQo+ID4gPiBPbiBUdWUsIDIwMjEtMDEtMDUgYXQgMDk6MDcgKzA4MDAsIENhbiBHdW8g
d3JvdGU6DQo+ID4gPiA+IE9uIDIwMjEtMDEtMDUgMDQ6MDUsIEJlYW4gSHVvIHdyb3RlOg0KPiA+
ID4gPiA+IE9uIFNhdCwgMjAyMS0wMS0wMiBhdCAwNTo1OSAtMDgwMCwgQ2FuIEd1byB3cm90ZToN
Cj4gPiA+ID4gPiA+ICsgKiBAc2h1dHRpbmdfZG93bjogZmxhZyB0byBjaGVjayBpZiBzaHV0ZG93
biBoYXMgYmVlbg0KPiA+ID4gPiA+ID4gaW52b2tlZA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkg
YW0gbm90IG11Y2ggc3VyZSBpZiB0aGlzIGZsYWcgaXMgbmVlZCwgc2luY2Ugb25jZSBQTSBnb2lu
ZyBpbg0KPiA+ID4gPiA+IHNodXRkb3duIHBhdGgsIHdoYXQgd2lsbCBiZSByZXR1cm5kZWQgYnkg
cG1fcnVudGltZV9nZXRfc3luYygpPw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IElmIHBtX3J1bnRp
bWVfZ2V0X3N5bmMoKSB3aWxsIGZhaWwsIGp1c3QgY2hlY2sgaXRzIHJldHVybi4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gDQo+ID4gPiA+IFRoYXQgZGVwZW5kcy4gRHVyaW5nL2FmdGVyIHNodXRkb3du
LCBmb3IgVUZTJ3MgY2FzZSBvbmx5LA0KPiA+ID4gPiBwbV9ydW50aW1lX2dldF9zeW5jKGhiYS0+
ZGV2KSB3aWxsIG1vc3QgbGlrZWx5IHJldHVybiAwLA0KPiA+ID4gPiBiZWNhdXNlIGl0IGlzIGFs
cmVhZHkgUlVOVElNRV9BQ1RJVkUsIHBtX3J1bnRpbWVfZ2V0X3N5bmMoKQ0KPiA+ID4gPiB3aWxs
IGRpcmVjdGx5IHJldHVybiAwLi4uIG1lYW5pbmcgeW91IGNhbm5vdCBjb3VudCBvbiBpdC4NCj4g
PiA+ID4gDQo+ID4gPiA+IENoZWNrIFN0YW5sZXkncyBjaGFuZ2UgLQ0KPiA+ID4gPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTM0MTM4OS8NCj4gPiA+ID4gDQo+ID4g
PiA+IENhbiBHdW8uDQo+ID4gPiANCj4gPiA+IENhbiwNCj4gPiA+IA0KPiA+ID4gVGhhbmtzIGZv
ciBwb2ludGluZyBvdXQgdGhhdC4NCj4gPiA+IA0KPiA+ID4gQmFzZWQgb24gbXkgdW5kZXJzdGFu
ZGluZywgdGhhdCBwYXRjaCBpcyByZWR1bmRlbnQuIG1heWJlIEkNCj4gPiA+IG1pc3VuZGVzdG9v
ZCBMaW51eCBzaHV0ZG93biBzZXF1ZW5jZS4NCj4gPiANCj4gPiBTb3JyeSwgZG8geW91IG1lYW4g
U3RhbmxleSdzIGNoYW5nZSBpcyByZWR1bmRhbnQ/DQo+IA0KPiB5ZXMuDQo+IA0KPiA+IA0KPiA+
ID4gDQo+ID4gPiBJIGNoZWNrZWQgdGhlIHNodXRkb3duIGZsb3c6DQo+ID4gPiANCj4gPiA+IDEu
IFNldCB0aGUgInN5c3RlbV9zdGF0ZSIgdmFyaWFibGUNCj4gPiA+IDIuIERpc2FibGUgdXNlcm1v
ZCB0byBlbnN1cmUgdGhhdCBubyB1c2VyIGZyb20gdXNlcnNwYWNlIGNhbiBzdGFydA0KPiA+ID4g
YQ0KPiA+ID4gcmVxdWVzdA0KPiA+IA0KPiA+IEkgaG9wZSBpdCBpcyBsaWtlIHdoYXQgeW91IGlu
dGVycHJldGVkLCBidXQgc3RlcCAjMiBvbmx5IHN0b3BzDQo+ID4gVU1IKCMyNjUpDQo+ID4gYnV0
IG5vdCBhbGwgdXNlciBzcGFjZSBhY3Rpdml0aWVzLiBXaGVyZWFzLCBVTUggaXMgZm9yIGtlcm5l
bCBzcGFjZSANCj4gPiBjYWxsaW5nDQo+ID4gdXNlciBzcGFjZS4NCj4gDQo+IA0KPiBDYW4sDQo+
IA0KPiBJIGRpZCBmdXJ0aGVyIHN0dWR5IGFuZCBob21ld29yayBvbiB0aGUgTGludXggc2h1dGRv
d24gaW4gdGhlIGxhc3QgZmV3DQo+IGRheXMuIFllcywgeW91IGFyZSByaWdodCwgdXNlcm1vZGVo
ZWxwZXJfZGlzYWJsZSgpIGlzIHRvIHByZXZlbnQNCj4gZXhlY3V0aW5nIHRoZSBwcm9jZXNzIGZy
b20gdGhlIGtlcm5lbCBzcGFjZS4NCj4gDQo+IEJ1dCBJIGRpZG4ndCByZXByb2R1Y2UgdGhpcyAi
bWF5YmUiIHJhY2UgaXNzdWUgd2hpbGUgc2h1dGRvd24uIG5vDQo+IG1hdHRlciBob3cgSSB0b3Jt
ZW50IG15IHN5c3RlbSwgb25jZSBMaW51eCBzaHV0ZG93bi9oYWx0L3JlYm9vdCBzdGFydHMsDQo+
IG5vYm9keSBjYW4gYWNjZXNzIHRoZSBzeXNmcyBub2RlLiBJIGNyZWF0ZSAxMCBwcm9jZXNzZXMg
aW4gdGhlIHVzZXINCj4gc3BhY2UgYW5kIGNvbnN0YW50bHkgYWNjZXNzIFVGUyBzeXNmcyBub2Rl
LCBhbHNvLCBmaW8gaXMgcnVubmluZyBpbiB0aGUNCj4gYmFja2dyb3VuZCBmb3IgdGhlIG5vcm1h
bCBkYXRhIHJlYWQvd3JpdGUuIHRoZXJlIGlzIGEgc2h1dGRvd24gdGhyZWFkDQo+IHRoYXQgd2ls
bCByYW5kb21seSB0cmlnZ2VyIHNodXRkb3duL2hhbHQvcmVib290LiBidXQgbm8gcmFjZSBpc3N1
ZQ0KPiBhcHBlYXJzLg0KPiANCj4gSSBkb24ndCBrbm93IGlmIHRoaXMgaXMgYSBoeXBvdGhldGlj
YWwgaXNzdWUodGhlIHJhY2UgYmV0d2VlbiBzaHV0ZG93bg0KPiBmbG93IGFuZCBzeXNmcyBub2Rl
IGFjY2VzcyksIGl0IG1heSBub3QgcmVhbGx5IGV4aXN0IGluIHRoZSBMaW51eA0KPiBlbnZyaXJv
bWVudC4gZXZlcnl0aW1lLCB0aGUgc2h1dGRvbncgZmxvdyB3aWxsIGJlOg0KPiANCj4gZTEwX3N5
bmNfaGFuZGxlcigpLT5lMTBfc3ZjKCktPmRvX2UxMF9zdmMoKS0+X19kb19zeXNfcmVib290KCkt
DQo+ID5rZXJuZWxfcG93ZXJvZmYva2VybmVsX2hhbHQoKS0+ZGV2aWNlX3NodXRkb3duKCktPnBs
YXRmb3JtX3NodXRkb3duKCktDQo+ID51ZnNoY2RfcGxhdGZvcm1fc2h1dGRvd24oKS0+dWZzaGNk
X3NodXRkb3duKCkuDQo+IA0KPiBJIHRoaW5rIGJlZm9yZSBnb2luZyBpbnRvIHRoZSBrZXJuZWwg
c2h1dGRvd24sIHRoZSB1c2Vyc3BhY2UgY2Fubm90DQo+IGlzc3VlIG5ldyByZXF1ZXN0cyBhbnlt
b3JlLiBvdGhlcndpc2UsIHRoaXMgd291bGQgYmUgYSBiaWcgaXNzdWUuDQo+IA0KPiBwbV9ydW50
aW1lX2dldF9zeW5jKCkgd2lsbCByZXR1cm4gMCBvciBmYWlsdXJlIHdoaWxlIHNodXRkb3duPyB0
aGUNCj4gYW5zd2VyIGlzIG5vdCBpbXBvcnRhbnQgbm93LCBtYXliZSBhcyB5b3Ugc2FpZCwgaXQg
aXMgYWx3YXlzIDAuIEJ1dCBpbg0KPiBteSB0ZXN0aW5nLCBpdCBkaWRuJ3QgZ2V0IHRoZXJlIHRo
ZSBzeXN0ZW0gaGFzIGJlZW4gc2h1dGRvd24uIFdoaWNoDQo+IG1lYW5zIG9uY2Ugc2h1dGRvbncg
c3RhcnRzLCBzeXNmcyBub2RlIGFjY2VzcyBwYXRoIGNhbm5vdCByZWFjaA0KPiBwbV9ydW50aW1l
X2dldF9zeW5jKCkuIChub3RlLCBJIGRvbid0IGtub3cgaWYgc3lzZnMgbm9kZSBhY2Nlc3MgdGhy
ZWFkDQo+IGhhcyBiZWVuIGRpc2FibGVkIG9yIG5vdCkNCj4gDQo+IA0KPiBSZXNwb25zaWJseSBz
YXksIEkgZGlkbid0IHJlcHJvZHVjZSB0aGlzIGlzc3VlIG9uIG15IHN5c3RlbSAodWJ1bnR1KSwN
Cj4gbWF5YmUgeW91IGFyZSB1c2luZyBBbmRyb2lkLiBJIGFtIG5vdCBhbiBleHBlcnQgb24gdGhp
cyB0b3BpYywgaWYgeW91DQo+IGhhdmUgdGhlIGJlc3QgaWRlYSBvbiBob3cgdG8gcmVwcm9kdWNl
IHRoaXMgaXNzdWUuIHBsZWFzZSBwbGVhc2UgbGV0IG1lDQo+IHRyeS4gYXBwcmVjaWF0ZSBpdCEh
ISEhDQo+IA0KDQpPbmUgb2YgdGhlIHJhY2luZyBpbiBteSBwbGF0Zm9ybXMgaGFwcGVucyBkdWUg
dG8gSS9PIGFjY2VzcyB0cmlnZ2VyZWQNCmZyb20ga2VybmVsIHNwYWNlLCBub3QgdXNlciBzcGFj
ZS4NCg0KVGhhbmtzLA0KU3RhbmxleSBDaHUNCg0KPiANCj4gVGhhbmtzLA0KPiBCZWFuDQo+IA0K
PiANCj4gPiANCj4gPiAyNjQgICAgIHN5c3RlbV9zdGF0ZSA9IHN0YXRlOw0KPiA+IDI2NSAgICAg
dXNlcm1vZGVoZWxwZXJfZGlzYWJsZSgpOw0KPiA+IDI2NiAgICAgZGV2aWNlX3NodXRkb3duKCk7
DQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IENhbiBHdW8uDQo+IA0KDQo=

