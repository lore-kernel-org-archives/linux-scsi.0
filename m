Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AD3C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E85D22243
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZDpLsonn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgKCONE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:13:04 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47534 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729604AbgKCOND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 09:13:03 -0500
X-UUID: 005f085b7a9649e286f9af0a32138b86-20201103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ZMHZXZ4NGsO/rl9DS2yrcKyQLUW5/iHw/sqaFg1r0Ko=;
        b=ZDpLsonnCMbxPuY5rcwQESds9TnLiM9Pg8MrAqbDxOfp6NRU/C6MUbAtLinnkXcHtgghLb1k1n2lqCpUuwzL+bdDB6NaQFlaFcIWs7Whqe8liOBgcJDYRVXd8xN7Diid/JHz6G5ScEkmxHctIJqs6FYWZkOLiixJYBpJpfgK754=;
X-UUID: 005f085b7a9649e286f9af0a32138b86-20201103
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1933409407; Tue, 03 Nov 2020 22:12:56 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Nov 2020 22:12:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Nov 2020 22:12:54 +0800
Message-ID: <1604412774.13152.14.camel@mtkswgap22>
Subject: Re: [PATCH v1 2/2] scsi: ufs: Try to save power mode change and UIC
 cmd completion timeout
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
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 3 Nov 2020 22:12:54 +0800
In-Reply-To: <1a557cffd04632875f6d52d43a036ad9@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
         <1604384682-15837-3-git-send-email-cang@codeaurora.org>
         <1604388023.13152.4.camel@mtkswgap22>
         <1a557cffd04632875f6d52d43a036ad9@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 7768D647CF90C3A791EC2399E610061C08C737B202B6D7466AA7439A75E5AAB42000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMjAtMTEtMDMgYXQgMTY6MDEgKzA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEhpIFN0YW5sZXksDQo+IA0KPiBPbiAyMDIwLTExLTAzIDE1OjIwLCBTdGFubGV5IENo
dSB3cm90ZToNCj4gPiBIaSBDYW4sDQo+ID4gDQo+ID4gRXhjZXB0IGZvciBiZWxvdyBuaXQsIG90
aGVyd2lzZSBsb29rcyBnb29kIHRvIG1lLg0KPiA+IA0KPiA+IFJldmlld2VkLWJ5OiBTdGFubGV5
IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IA0KPiA+IE9uIE1vbiwgMjAyMC0x
MS0wMiBhdCAyMjoyNCAtMDgwMCwgQ2FuIEd1byB3cm90ZToNCj4gPj4gVXNlIHRoZSB1aWNfY21k
LT5jbWRfYWN0aXZlIGFzIGEgZmxhZyB0byB0cmFjayB0aGUgbGlmZWN5Y2xlIG9mIGFuIFVJQyAN
Cj4gPj4gY21kLg0KPiA+PiBUaGUgZmxhZyBpcyBzZXQgYmVmb3JlIHNlbmQgdGhlIFVJQyBjbWQg
YW5kIGNsZWFyZWQgaW4gSVJRIGhhbmRsZXIuIA0KPiA+PiBXaGVuIGENCj4gPj4gUE1DIG9yIFVJ
QyBjbWQgY29tcGxldGlvbiB0aW1lb3V0IGhhcHBlbnMsIGlmIHRoZSBmbGFnIGlzIG5vdCBzZXQs
IA0KPiA+PiBpbnN0ZWFkDQo+ID4+IG9mIHJldHVybmluZyB0aW1lb3V0IGVycm9yLCB3ZSBzdGls
bCB0cmVhdCBpdCBhcyBhIHN1Y2Nlc3NmdWwgDQo+ID4+IG9wZXJhdGlvbi4NCj4gPj4gVGhpcyBp
cyB0byBkZWFsIHdpdGggdGhlIHNjZW5hcmlvIGluIHdoaWNoIGNvbXBsZXRpb24gaGFzIGJlZW4g
cmFpc2VkIA0KPiA+PiBidXQNCj4gPj4gdGhlIG9uZSB3YWl0aW5nIGZvciB0aGUgY29tcGxldGlv
biBjYW5ub3QgYmUgYXdha2VuIGluIHRpbWUgZHVlIHRvIA0KPiA+PiBrZXJuZWwNCj4gPj4gc2No
ZWR1bGluZyBwcm9ibGVtLg0KPiA+PiANCj4gPj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2Fu
Z0Bjb2RlYXVyb3JhLm9yZz4NCj4gPj4gLS0tDQo+ID4+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5jIHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPj4gIGRyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmggfCAgMiArKw0KPiA+PiAgMiBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+PiANCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4+IGluZGV4IGVm
YTdkODYuLjdmMzMzMTAgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMNCj4gPj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+PiBAQCAtMjEyMiwx
MCArMjEyMiwyMCBAQCB1ZnNoY2Rfd2FpdF9mb3JfdWljX2NtZChzdHJ1Y3QgdWZzX2hiYSAqaGJh
LCANCj4gPj4gc3RydWN0IHVpY19jb21tYW5kICp1aWNfY21kKQ0KPiA+PiAgCXVuc2lnbmVkIGxv
bmcgZmxhZ3M7DQo+ID4+IA0KPiA+PiAgCWlmICh3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQo
JnVpY19jbWQtPmRvbmUsDQo+ID4+IC0JCQkJCW1zZWNzX3RvX2ppZmZpZXMoVUlDX0NNRF9USU1F
T1VUKSkpDQo+ID4+ICsJCQkJCW1zZWNzX3RvX2ppZmZpZXMoVUlDX0NNRF9USU1FT1VUKSkpIHsN
Cj4gPj4gIAkJcmV0ID0gdWljX2NtZC0+YXJndW1lbnQyICYgTUFTS19VSUNfQ09NTUFORF9SRVNV
TFQ7DQo+ID4+IC0JZWxzZQ0KPiA+PiArCX0gZWxzZSB7DQo+ID4+ICAJCXJldCA9IC1FVElNRURP
VVQ7DQo+ID4+ICsJCWRldl9lcnIoaGJhLT5kZXYsDQo+ID4+ICsJCQkidWljIGNtZCAweCV4IHdp
dGggYXJnMyAweCV4IGNvbXBsZXRpb24gdGltZW91dFxuIiwNCj4gPj4gKwkJCXVpY19jbWQtPmNv
bW1hbmQsIHVpY19jbWQtPmFyZ3VtZW50Myk7DQo+ID4+ICsNCj4gPj4gKwkJaWYgKCF1aWNfY21k
LT5jbWRfYWN0aXZlKSB7DQo+ID4+ICsJCQlkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IFVJQyBjbWQg
aGFzIGJlZW4gY29tcGxldGVkLCByZXR1cm4gdGhlIA0KPiA+PiByZXN1bHRcbiIsDQo+ID4+ICsJ
CQkJX19mdW5jX18pOw0KPiA+PiArCQkJcmV0ID0gdWljX2NtZC0+YXJndW1lbnQyICYgTUFTS19V
SUNfQ09NTUFORF9SRVNVTFQ7DQo+ID4+ICsJCX0NCj4gPj4gKwl9DQo+ID4+IA0KPiA+PiAgCXNw
aW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4+ICAJaGJh
LT5hY3RpdmVfdWljX2NtZCA9IE5VTEw7DQo+ID4+IEBAIC0yMTU3LDYgKzIxNjcsNyBAQCBfX3Vm
c2hjZF9zZW5kX3VpY19jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwgDQo+ID4+IHN0cnVjdCB1aWNf
Y29tbWFuZCAqdWljX2NtZCwNCj4gPj4gIAlpZiAoY29tcGxldGlvbikNCj4gPj4gIAkJaW5pdF9j
b21wbGV0aW9uKCZ1aWNfY21kLT5kb25lKTsNCj4gPj4gDQo+ID4+ICsJdWljX2NtZC0+Y21kX2Fj
dGl2ZSA9IDE7DQo+ID4+ICAJdWZzaGNkX2Rpc3BhdGNoX3VpY19jbWQoaGJhLCB1aWNfY21kKTsN
Cj4gPj4gDQo+ID4+ICAJcmV0dXJuIDA7DQo+ID4+IEBAIC0zODI4LDEwICszODM5LDE4IEBAIHN0
YXRpYyBpbnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZzX2hiYSANCj4gPj4gKmhiYSwg
c3RydWN0IHVpY19jb21tYW5kICpjbWQpDQo+ID4+ICAJCWRldl9lcnIoaGJhLT5kZXYsDQo+ID4+
ICAJCQkicHdyIGN0cmwgY21kIDB4JXggd2l0aCBtb2RlIDB4JXggY29tcGxldGlvbiB0aW1lb3V0
XG4iLA0KPiA+PiAgCQkJY21kLT5jb21tYW5kLCBjbWQtPmFyZ3VtZW50Myk7DQo+ID4+ICsNCj4g
Pj4gKwkJaWYgKCFjbWQtPmNtZF9hY3RpdmUpIHsNCj4gPj4gKwkJCWRldl9lcnIoaGJhLT5kZXYs
ICIlczogUG93ZXIgTW9kZSBDaGFuZ2Ugb3BlcmF0aW9uIGhhcyBiZWVuIA0KPiA+PiBjb21wbGV0
ZWQsIGdvIGNoZWNrIFVQTUNSU1xuIiwNCj4gPj4gKwkJCQlfX2Z1bmNfXyk7DQo+ID4+ICsJCQln
b3RvIGNoZWNrX3VwbWNyczsNCj4gPj4gKwkJfQ0KPiA+PiArDQo+ID4+ICAJCXJldCA9IC1FVElN
RURPVVQ7DQo+ID4+ICAJCWdvdG8gb3V0Ow0KPiA+PiAgCX0NCj4gPj4gDQo+ID4+ICtjaGVja191
cG1jcnM6DQo+ID4+ICAJc3RhdHVzID0gdWZzaGNkX2dldF91cG1jcnMoaGJhKTsNCj4gPj4gIAlp
ZiAoc3RhdHVzICE9IFBXUl9MT0NBTCkgew0KPiA+PiAgCQlkZXZfZXJyKGhiYS0+ZGV2LA0KPiA+
PiBAQCAtNDkyMywxMSArNDk0MiwxNCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX3VpY19j
bWRfY29tcGwoc3RydWN0IA0KPiA+PiB1ZnNfaGJhICpoYmEsIHUzMiBpbnRyX3N0YXR1cykNCj4g
Pj4gIAkJCXVmc2hjZF9nZXRfdWljX2NtZF9yZXN1bHQoaGJhKTsNCj4gPj4gIAkJaGJhLT5hY3Rp
dmVfdWljX2NtZC0+YXJndW1lbnQzID0NCj4gPj4gIAkJCXVmc2hjZF9nZXRfZG1lX2F0dHJfdmFs
KGhiYSk7DQo+ID4+ICsJCWlmICghaGJhLT51aWNfYXN5bmNfZG9uZSkNCj4gPiANCj4gPiBJcyB0
aGlzIGNoZWNrIG5lY2Vzc2FyeT8NCj4gPiANCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBxdWljayBy
ZXNwb25zZS4NCj4gDQo+IEluIHRoZSBjYXNlIG9mIFBNQywgVUlDIGNtZCBjb21wbGV0aW9uIElS
USBjb21lcyBmaXJzdCwgdGhlbiBwb3dlcg0KPiBzdGF0dXMgY2hhbmdlIElSUSBjb21lcyBuZXh0
LiBJbiB0aGlzIGNhc2UsIGFuIFVJQyBjbWQncyBsaWZlY3lsZQ0KPiBlbmRzIG9ubHkgYWZ0ZXIg
dGhlIHBvd2VyIHN0YXR1cyBjaGFuZ2UgSVJRIGNvbWVzIFsxXS4NCj4gDQo+IEkgZ3Vlc3MgeW91
IG1heSB3YW50IHRvIHNheSB0aGF0IGluIGN1cnJlbnQgY29kZSBzaW5jZSB3ZSBoYXZlDQo+IG1h
c2tlZCBVSUMgY21kIGNvbXBsZXRpb24gSVJRIGluIHRoZSBjYXNlIG9mIGEgUE1DIG9wZXJhdGlv
biwgc28NCj4gbm8gbmVlZCB0byBjaGVjayBpdCBoZXJlIHNpbmNlIHdlIHdvbid0IGJlIGhlcmUg
YW55d2F5cyBiZWZvcmUNCj4gcG93ZXIgc3RhdHVzIGNoYW5nZSBJUlEgY29tZXMuIFNvLCByZW1v
dmluZyB0aGUgY2hlY2sgaGVyZQ0KPiBkZWZpbml0ZWx5IHdvcmtzLCBhbmQgdGhlbiB3ZSB3b24n
dCBldmVuIG5lZWQgYmVsb3cgbGluZSBhcyB3ZWxsLg0KPiANCg0KWW91IHJlYWQgbXkgbWluZCA6
ICkNCg0KPiAJaWYgKChpbnRyX3N0YXR1cyAmIFVGU0hDRF9VSUNfUFdSX01BU0spICYmIGhiYS0+
dWljX2FzeW5jX2RvbmUpIHsNCj4gKwkJaGJhLT5hY3RpdmVfdWljX2NtZC0+Y21kX2FjdGl2ZSA9
IDA7DQo+IAkJY29tcGxldGUoaGJhLT51aWNfYXN5bmNfZG9uZSk7DQo+IAkJcmV0dmFsID0gSVJR
X0hBTkRMRUQ7DQo+IA0KPiBJZiBteSBndWVzcyBpcyByaWdodCwgbXkgb3BpbmlvbiBpcyB0aGF0
IHRoZSBjdXJyZW50IGNoYW5nZSBtYXkNCj4gYmUgbW9yZSByZWFkYWJsZSBhbmQgY29tcHJlaGVu
c2l2ZSBhcyBpdCBzdHJpY3RseSBmb2xsb3dzIG15DQo+IGRlc2NyaXB0aW9uIGluIFsxXS4gV2hh
dCBkbyB5b3UgdGhpbms/DQoNCkJvdGggbG9va3MgZmluZSB0byBtZS4NCg0KVGhhbmtzIGZvciB0
aGUgZGV0YWlsZWQgZGVzY3JpcHRpb24uDQoNClN0YW5sZXkgQ2h1DQoNCj4gDQo+IFRoYW5rcywN
Cj4gDQo+IENhbiBHdW8uDQo+IA0KPiA+PiArCQkJaGJhLT5hY3RpdmVfdWljX2NtZC0+Y21kX2Fj
dGl2ZSA9IDA7DQo+ID4+ICAJCWNvbXBsZXRlKCZoYmEtPmFjdGl2ZV91aWNfY21kLT5kb25lKTsN
Cj4gPj4gIAkJcmV0dmFsID0gSVJRX0hBTkRMRUQ7DQo+ID4+ICAJfQ0KPiA+PiANCj4gPj4gIAlp
ZiAoKGludHJfc3RhdHVzICYgVUZTSENEX1VJQ19QV1JfTUFTSykgJiYgaGJhLT51aWNfYXN5bmNf
ZG9uZSkgew0KPiA+PiArCQloYmEtPmFjdGl2ZV91aWNfY21kLT5jbWRfYWN0aXZlID0gMDsNCj4g
Pj4gIAkJY29tcGxldGUoaGJhLT51aWNfYXN5bmNfZG9uZSk7DQo+ID4+ICAJCXJldHZhbCA9IElS
UV9IQU5ETEVEOw0KPiA+PiAgCX0NCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+ID4+IGluZGV4IDY2ZTUzMzgu
LmJlOTgyZWQgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4g
Pj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiA+PiBAQCAtNjQsNiArNjQsNyBA
QCBlbnVtIGRldl9jbWRfdHlwZSB7DQo+ID4+ICAgKiBAYXJndW1lbnQxOiBVSUMgY29tbWFuZCBh
cmd1bWVudCAxDQo+ID4+ICAgKiBAYXJndW1lbnQyOiBVSUMgY29tbWFuZCBhcmd1bWVudCAyDQo+
ID4+ICAgKiBAYXJndW1lbnQzOiBVSUMgY29tbWFuZCBhcmd1bWVudCAzDQo+ID4+ICsgKiBAY21k
X2FjdGl2ZTogSW5kaWNhdGUgaWYgVUlDIGNvbW1hbmQgaXMgb3V0c3RhbmRpbmcNCj4gPj4gICAq
IEBkb25lOiBVSUMgY29tbWFuZCBjb21wbGV0aW9uDQo+ID4+ICAgKi8NCj4gPj4gIHN0cnVjdCB1
aWNfY29tbWFuZCB7DQo+ID4+IEBAIC03MSw2ICs3Miw3IEBAIHN0cnVjdCB1aWNfY29tbWFuZCB7
DQo+ID4+ICAJdTMyIGFyZ3VtZW50MTsNCj4gPj4gIAl1MzIgYXJndW1lbnQyOw0KPiA+PiAgCXUz
MiBhcmd1bWVudDM7DQo+ID4+ICsJaW50IGNtZF9hY3RpdmU7DQo+ID4+ICAJc3RydWN0IGNvbXBs
ZXRpb24gZG9uZTsNCj4gPj4gIH07DQo+ID4+IA0KPiA+IA0KPiA+IA0KPiA+IA0KPiA+IFRoYW5r
cywNCj4gPiBTdGFubGV5IENodQ0KDQo=

