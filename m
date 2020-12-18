Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFBFC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 02:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B95B23A3C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 02:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgLRCC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 21:02:28 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58169 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727184AbgLRCC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 21:02:28 -0500
X-UUID: 9e022bcc6ab540f7a5ecf67ac0df1af5-20201218
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=LF/Kt/HweHIQ47s30V3JDwJ7l/buKaTFjRuYL2ix2N4=;
        b=k0zgCUmYOWkcyR2W81/L2+j5WwDwskCDx1t1oiShd1WXfHmfPJPJRKl2GTNf8xYHTxVzlphHUZKgQ12/MEKGyl8C00kqYAUoh+zGoFj1keSvvHp0v3VbmyQnwUMx7RuUEpQqHiD8vafCVmpYODPwwF8dHwT7XqnJKbMmJ17bRUY=;
X-UUID: 9e022bcc6ab540f7a5ecf67ac0df1af5-20201218
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 154259598; Fri, 18 Dec 2020 10:01:45 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 18 Dec
 2020 10:01:43 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 18 Dec 2020 10:01:40 +0800
Message-ID: <1608256903.10163.39.camel@mtkswgap22>
Subject: Re: Subject: [PATCH v14 1/3] scsi: ufs: Introduce HPB feature
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Fri, 18 Dec 2020 10:01:43 +0800
In-Reply-To: <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
References: <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
         <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p2>
         <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgRGFlanVuLA0KDQpPbiBXZWQsIDIwMjAtMTItMTYgYXQgMTE6NDUgKzA5MDAsIERhZWp1biBQ
YXJrIHdyb3RlOg0KPiBUaGlzIGlzIGEgcGF0Y2ggZm9yIHRoZSBIUEIgaW5pdGlhbGl6YXRpb24g
YW5kIGFkZHMgSFBCIGZ1bmN0aW9uIGNhbGxzIHRvDQo+IFVGUyBjb3JlIGRyaXZlci4NCj4gDQo+
IE5BTkQgZmxhc2gtYmFzZWQgc3RvcmFnZSBkZXZpY2VzLCBpbmNsdWRpbmcgVUZTLCBoYXZlIG1l
Y2hhbmlzbXMgdG8NCj4gdHJhbnNsYXRlIGxvZ2ljYWwgYWRkcmVzc2VzIG9mIElPIHJlcXVlc3Rz
IHRvIHRoZSBjb3JyZXNwb25kaW5nIHBoeXNpY2FsDQo+IGFkZHJlc3NlcyBvZiB0aGUgZmxhc2gg
c3RvcmFnZS4NCj4gSW4gVUZTLCBMb2dpY2FsLWFkZHJlc3MtdG8tUGh5c2ljYWwtYWRkcmVzcyAo
TDJQKSBtYXAgZGF0YSwgd2hpY2ggaXMNCj4gcmVxdWlyZWQgdG8gaWRlbnRpZnkgdGhlIHBoeXNp
Y2FsIGFkZHJlc3MgZm9yIHRoZSByZXF1ZXN0ZWQgSU9zLCBjYW4gb25seQ0KPiBiZSBwYXJ0aWFs
bHkgc3RvcmVkIGluIFNSQU0gZnJvbSBOQU5EIGZsYXNoLiBEdWUgdG8gdGhpcyBwYXJ0aWFsIGxv
YWRpbmcsDQo+IGFjY2Vzc2luZyB0aGUgZmxhc2ggYWRkcmVzcyBhcmVhIHdoZXJlIHRoZSBMMlAg
aW5mb3JtYXRpb24gZm9yIHRoYXQgYWRkcmVzcw0KPiBpcyBub3QgbG9hZGVkIGluIHRoZSBTUkFN
IGNhbiByZXN1bHQgaW4gc2VyaW91cyBwZXJmb3JtYW5jZSBkZWdyYWRhdGlvbi4NCj4gDQo+IFRo
ZSBiYXNpYyBjb25jZXB0IG9mIEhQQiBpcyB0byBjYWNoZSBMMlAgbWFwcGluZyBlbnRyaWVzIGlu
IGhvc3Qgc3lzdGVtDQo+IG1lbW9yeSBzbyB0aGF0IGJvdGggcGh5c2ljYWwgYmxvY2sgYWRkcmVz
cyAoUEJBKSBhbmQgbG9naWNhbCBibG9jayBhZGRyZXNzDQo+IChMQkEpIGNhbiBiZSBkZWxpdmVy
ZWQgaW4gSFBCIHJlYWQgY29tbWFuZC4NCj4gVGhlIEhQQiBSRUFEIGNvbW1hbmQgYWxsb3dzIHRv
IHJlYWQgZGF0YSBmYXN0ZXIgdGhhbiBhIHJlYWQgY29tbWFuZCBpbiBVRlMNCj4gc2luY2UgaXQg
cHJvdmlkZXMgdGhlIHBoeXNpY2FsIGFkZHJlc3MgKEhQQiBFbnRyeSkgb2YgdGhlIGRlc2lyZWQg
bG9naWNhbA0KPiBibG9jayBpbiBhZGRpdGlvbiB0byBpdHMgbG9naWNhbCBhZGRyZXNzLiBUaGUg
VUZTIGRldmljZSBjYW4gYWNjZXNzIHRoZQ0KPiBwaHlzaWNhbCBibG9jayBpbiBOQU5EIGRpcmVj
dGx5IHdpdGhvdXQgc2VhcmNoaW5nIGFuZCB1cGxvYWRpbmcgTDJQIG1hcHBpbmcNCj4gdGFibGUu
IFRoaXMgaW1wcm92ZXMgcmVhZCBwZXJmb3JtYW5jZSBiZWNhdXNlIHRoZSBOQU5EIHJlYWQgb3Bl
cmF0aW9uIGZvcg0KPiB1cGxvYWRpbmcgTDJQIG1hcHBpbmcgdGFibGUgaXMgcmVtb3ZlZC4NCj4g
DQo+IEluIEhQQiBpbml0aWFsaXphdGlvbiwgdGhlIGhvc3QgY2hlY2tzIGlmIHRoZSBVRlMgZGV2
aWNlIHN1cHBvcnRzIEhQQg0KPiBmZWF0dXJlIGFuZCByZXRyaWV2ZXMgcmVsYXRlZCBkZXZpY2Ug
Y2FwYWJpbGl0aWVzLiBUaGVuLCBzb21lIEhQQg0KPiBwYXJhbWV0ZXJzIGFyZSBjb25maWd1cmVk
IGluIHRoZSBkZXZpY2UuDQo+IA0KPiBSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFu
YXNzY2hlQGFjbS5vcmc+DQo+IFJldmlld2VkLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEu
b3JnPg0KPiBBY2tlZC1ieTogQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdkYy5jb20+DQo+IFRl
c3RlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
RGFlanVuIFBhcmsgPGRhZWp1bjcucGFya0BzYW1zdW5nLmNvbT4NCj4gLS0tDQo+ICBEb2N1bWVu
dGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci11ZnMgfCAgODAgKysrDQo+ICBkcml2ZXJz
L3Njc2kvdWZzL0tjb25maWcgICAgICAgICAgICAgICAgICAgfCAgIDkgKw0KPiAgZHJpdmVycy9z
Y3NpL3Vmcy9NYWtlZmlsZSAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLXN5c2ZzLmMgICAgICAgICAgICAgICB8ICAxOCArDQo+ICBkcml2ZXJzL3Njc2kv
dWZzL3Vmcy5oICAgICAgICAgICAgICAgICAgICAgfCAgMTMgKw0KPiAgZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYyAgICAgICAgICAgICAgICAgIHwgIDQ4ICsrDQo+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oICAgICAgICAgICAgICAgICAgfCAgMjMgKy0NCj4gIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaHBiLmMgICAgICAgICAgICAgICAgICB8IDU2MiArKysrKysrKysrKysrKysrKysrKysNCj4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmggICAgICAgICAgICAgICAgICB8IDE2NyArKysrKysN
Cj4gIDkgZmlsZXMgY2hhbmdlZCwgOTIwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
IGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuaA0KPiANCj4gZGlmZiAtLWdpdCBh
L0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZHJpdmVyLXVmcyBiL0RvY3VtZW50YXRp
b24vQUJJL3Rlc3Rpbmcvc3lzZnMtZHJpdmVyLXVmcw0KPiBpbmRleCBkMWEzNTIxOTRkMmUuLjhi
MTZhMzUzMzkyYyAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNm
cy1kcml2ZXItdWZzDQo+ICsrKyBiL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZHJp
dmVyLXVmcw0KPiBAQCAtMTAxOSwzICsxMDE5LDgzIEBAIENvbnRhY3Q6CUFzdXRvc2ggRGFzIDxh
c3V0b3NoZEBjb2RlYXVyb3JhLm9yZz4NCj4gIERlc2NyaXB0aW9uOglUaGlzIGVudHJ5IHNob3dz
IHRoZSBjb25maWd1cmVkIHNpemUgb2YgV3JpdGVCb29zdGVyIGJ1ZmZlci4NCj4gIAkJMDQwMGgg
Y29ycmVzcG9uZHMgdG8gNEdCLg0KPiAgCQlUaGUgZmlsZSBpcyByZWFkIG9ubHkuDQo+ICsNCj4g
K1doYXQ6CQkvc3lzL2J1cy9wbGF0Zm9ybS9kcml2ZXJzL3Vmc2hjZC8qL2RldmljZV9kZXNjcmlw
dG9yL2hwYl92ZXJzaW9uDQo+ICtEYXRlOgkJRGVjZW1iZXIgMjAyMA0KPiArQ29udGFjdDoJRGFl
anVuIFBhcmsgPGRhZWp1bjcucGFya0BzYW1zdW5nLmNvbT4NCj4gK0Rlc2NyaXB0aW9uOglUaGlz
IGVudHJ5IHNob3dzIHRoZSBIUEIgc3BlY2lmaWNhdGlvbiB2ZXJzaW9uLg0KPiArCQlUaGUgZnVs
bCBpbmZvcm1hdGlvbiBhYm91dCB0aGUgZGVzY3JpcHRvciBjb3VsZCBiZSBmb3VuZCBhdCBVRlMN
Cj4gKwkJSFBCIChIb3N0IFBlcmZvcm1hbmNlIEJvb3N0ZXIpIEV4dGVuc2lvbiBzcGVjaWZpY2F0
aW9ucy4NCj4gKwkJRXhhbXBsZTogdmVyc2lvbiAxLjIuMyA9IDAxMjNoDQo+ICsJCVRoZSBmaWxl
IGlzIHJlYWQgb25seS4NCj4gKw0KPiArV2hhdDoJCS9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMv
dWZzaGNkLyovZGV2aWNlX2Rlc2NyaXB0b3IvaHBiX2NvbnRyb2wNCj4gK0RhdGU6CQlEZWNlbWJl
ciAyMDIwDQo+ICtDb250YWN0OglEYWVqdW4gUGFyayA8ZGFlanVuNy5wYXJrQHNhbXN1bmcuY29t
Pg0KPiArRGVzY3JpcHRpb246CVRoaXMgZW50cnkgc2hvd3MgYW4gaW5kaWNhdGlvbiBvZiB0aGUg
SFBCIGNvbnRyb2wgbW9kZS4NCj4gKwkJMDBoOiBIb3N0IGNvbnRyb2wgbW9kZQ0KPiArCQkwMWg6
IERldmljZSBjb250cm9sIG1vZGUNCj4gKwkJVGhlIGZpbGUgaXMgcmVhZCBvbmx5Lg0KPiArDQo+
ICtXaGF0OgkJL3N5cy9idXMvcGxhdGZvcm0vZHJpdmVycy91ZnNoY2QvKi9nZW9tZXRyeV9kZXNj
cmlwdG9yL2hwYl9yZWdpb25fc2l6ZQ0KPiArRGF0ZToJCURlY2VtYmVyIDIwMjANCj4gK0NvbnRh
Y3Q6CURhZWp1biBQYXJrIDxkYWVqdW43LnBhcmtAc2Ftc3VuZy5jb20+DQo+ICtEZXNjcmlwdGlv
bjoJVGhpcyBlbnRyeSBzaG93cyB0aGUgYkhQQlJlZ2lvblNpemUgd2hpY2ggY2FuIGJlIGNhbGN1
bGF0ZWQNCj4gKwkJYXMgaW4gdGhlIGZvbGxvd2luZyAoaW4gYnl0ZXMpOg0KPiArCQlIUEIgUmVn
aW9uIHNpemUgPSA1MTJCICogMl5iSFBCUmVnaW9uU2l6ZQ0KPiArCQlUaGUgZmlsZSBpcyByZWFk
IG9ubHkuDQo+ICsNCj4gK1doYXQ6CQkvc3lzL2J1cy9wbGF0Zm9ybS9kcml2ZXJzL3Vmc2hjZC8q
L2dlb21ldHJ5X2Rlc2NyaXB0b3IvaHBiX251bWJlcl9sdQ0KPiArRGF0ZToJCURlY2VtYmVyIDIw
MjANCj4gK0NvbnRhY3Q6CURhZWp1biBQYXJrIDxkYWVqdW43LnBhcmtAc2Ftc3VuZy5jb20+DQo+
ICtEZXNjcmlwdGlvbjoJVGhpcyBlbnRyeSBzaG93cyB0aGUgbWF4aW11bSBudW1iZXIgb2YgSFBC
IExVIHN1cHBvcnRlZAlieQ0KPiArCQl0aGUgZGV2aWNlLg0KPiArCQkwMGg6IEhQQiBpcyBub3Qg
c3VwcG9ydGVkIGJ5IHRoZSBkZXZpY2UuDQo+ICsJCTAxaCB+IDIwaDogTWF4aW11bSBudW1iZXIg
b2YgSFBCIExVIHN1cHBvcnRlZCBieSB0aGUgZGV2aWNlDQo+ICsJCVRoZSBmaWxlIGlzIHJlYWQg
b25seS4NCj4gKw0KPiArV2hhdDoJCS9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvdWZzaGNkLyov
Z2VvbWV0cnlfZGVzY3JpcHRvci9ocGJfbnVtYmVyX2x1DQo+ICtEYXRlOgkJRGVjZW1iZXIgMjAy
MA0KPiArQ29udGFjdDoJRGFlanVuIFBhcmsgPGRhZWp1bjcucGFya0BzYW1zdW5nLmNvbT4NCj4g
K0Rlc2NyaXB0aW9uOglUaGlzIGVudHJ5IHNob3dzIHRoZSBtYXhpbXVtIG51bWJlciBvZiBIUEIg
TFUgc3VwcG9ydGVkCWJ5DQo+ICsJCXRoZSBkZXZpY2UuDQo+ICsJCTAwaDogSFBCIGlzIG5vdCBz
dXBwb3J0ZWQgYnkgdGhlIGRldmljZS4NCj4gKwkJMDFoIH4gMjBoOiBNYXhpbXVtIG51bWJlciBv
ZiBIUEIgTFUgc3VwcG9ydGVkIGJ5IHRoZSBkZXZpY2UNCj4gKwkJVGhlIGZpbGUgaXMgcmVhZCBv
bmx5Lg0KDQpQbGVhc2UgcmVtb3ZlIGFib3ZlIGR1cGxpY2F0ZWQgaXRlbS4NCg0KVGhhbmtzLA0K
U3RhbmxleSBDaHUNCg0K

