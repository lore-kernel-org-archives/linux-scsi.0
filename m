Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CDCC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 08:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6722121771
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 08:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfK1IMq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:12:46 -0500
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:24205 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfK1IMq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 03:12:46 -0500
IronPort-SDR: gUB2kUt1+pRxXifoPt4vBV2HzPVvUbyzapN3PI1XX0tf6GBUfMaYKYwbEAHjvhz6r+fmN52iLT
 Ip8+lvIp45Vrw0S2/BCloSpI6eLTs8GD2EdEduuWQesnS66oq4dBDPwJdw393q082VBo25xVZr
 h6+UzRT79b0HtxoktCYqya9pmyrC56YFLM9xx3QPD9dgPzuf47zrMYDxqPH8SPXUlj8fNCneng
 JnXVfRoJrX5NDaGUkFdr7Ndb886EU4Aq4AA9spta13V3yzYKJnFn0BqaZAr/3Dk49VcLxXQZMs
 DAM=
X-IronPort-AV: E=Sophos;i="5.69,252,1571731200"; 
   d="scan'208";a="43594070"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 28 Nov 2019 00:12:45 -0800
IronPort-SDR: BC9926NUvcN8903q6aV7B+jT7cyDcgtEMEfhpPSOdKqIjmUDWFwal3A/It1NGkhUBk9+GoDqlt
 AEB1SQtVBgs+90iLSlSPkmzrcSuMviSDEPlpFUXkScbL5tUiH2++mKHXUfSP5Cmq2UPgibwHMx
 vbwgrXrdurVbVpsuU6cOq6DOeC5I1UUDBUOGg6jNzeOXqdiUVhNvqhjqe8l6ePXKSfEnlW2dyf
 Mqh+sIV2O7xwR/gqNM4r6GRwLL5rEUyKfS/YX6Xv1eoy8QvzPRpMGezRbRjj+W+pDJrYV2LxIp
 1GU=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Andrea Vai <andrea.vai@unipv.it>,
        Finn Thain <fthain@telegraphics.com.au>
CC:     Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: AW: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qcHF7jYFXqX02A+/ZaS0pzdqeAjBMAgANe+wCAFDitAIAAzHgAgACKv4CAAl41gIAAaSkAgAAFKQCAAEsvAIAABMGAgAA8WICAAIDlgIAAV4SAgAEWB4CAAIOAUIABi16AgAACn+A=
Date:   Thu, 28 Nov 2019 08:12:39 +0000
Message-ID: <fa9566db62474d7aa5473cf7a1f0da8d@SVR-IES-MBX-03.mgc.mentorg.com>
References: <20191109222828.GA30568@ming.t460p>
         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
         <20191123072726.GC25356@ming.t460p>
         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
         <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
         <20191125102928.GA20489@ming.t460p>
         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
         <20191125151535.GA8044@ming.t460p>
         <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
         <20191126023253.GA24501@ming.t460p>
         <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
         <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
         <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
 <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
In-Reply-To: <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gVGhlIHNoZWVyIHZvbHVtZSBvZiB0ZXN0aW5nIChwcm9iYWJseSBzb21lIHRlcmFieXRl
cyBieSBub3cpIHdvdWxkDQo+ID4gPiBleGVyY2lzZSB0aGUgd2VhciBsZXZlbGluZyBhbGdvcml0
aG0gaW4gdGhlIEZUTC4NCj4gPiA+DQo+ID4gQnV0IHdpdGggIm9sZCBrZXJuZWwiIHRoZSBjb3B5
IG9wZXJhdGlvbiBzdGlsbCBpcyAiZmFzdCIsIGFzIGZhciBhcw0KPiA+IGkgdW5kZXJzdG9vZC4N
Cj4gPiBJZiBGVEwgKGUuZy4gd2VhciBsZXZlbGluZykgd291bGQgc2xvdyBkb3duLCB3ZSB3b3Vs
ZCBzZWUgdGhhdCBhbHNvDQo+ID4gaW4NCj4gPiB0aGUgb2xkIGtlcm5lbCwgcmlnaHQ/DQo+ID4N
Cj4gPiBBbmRyZWEsIGNhbiB5b3UgY29uZmlybSB0aGF0IHRoZSBzYW1lIGRldmljZSB1c2VkIHdp
dGggdGhlIG9sZCBmYXN0DQo+ID4ga2VybmVsIGlzIHN0aWxsIGZhc3QgdG9kYXk/DQo+IA0KPiBZ
ZXMsIGl0IGlzIHN0aWxsIGZhc3QuIEp1c3QgcmFuIGEgMTAwIHRyaWFscyB0ZXN0IGFuZCBnb3Qg
YW4gYXZlcmFnZQ0KPiBvZiA3MCBzZWNvbmRzIHdpdGggc3RhbmRhcmQgZGV2aWF0aW9uID0gNiBz
ZWNvbmRzLCBhbGlnbmVkIHdpdGggdGhlDQo+IHBhc3QgdmFsdWVzIG9mIHRoZSBzYW1lIGtlcm5l
bC4NCj4gDQo+IFRoYW5rcywNCj4gQW5kcmVhDQpJIGhhdmUgYmVlbiBpbnZvbHZlZCBpbiBzZXZl
cmFsIGJlbmNobWFya2luZ3Mgb2YgZmxhc2ggZGV2aWNlcyBpbiB0aGUgcGFzdC4NClNvIHdoYXQg
d2Ugc2VlIGhlcmUgaXMgZGVmaW5pdGVseSBub3QgYSBkZXZpY2UgaXNzdWUgcmVnYXJkaW5nIHdl
YXIgbGV2ZWxpbmcuDQoNCkkgd2FudGVkIHRvIHByZXZlbnQgYWxsIG9mIHlvdSBnb2luZyBpbnRv
IHRoZSB3cm9uZyBkaXJlY3Rpb24sIHRoYXQncyB3aHkNCmkgd2FudGVkIEFuZHJlYSB0byBjb25m
aXJtIHRoYXQgaXQncyBub3QgYSBtYXR0ZXIgb2YgdGhlIGZsYXNoIGRldmljZS4NCg0KVGhlcmUg
YXJlIHNvIG11Y2ggaXRlbXMgaW52b2x2ZWQgaW50byBiZW5jaG1hcmtpbmcgZmxhc2ggZGV2aWNl
cy4NCkJ1dCBBbmRyZWEncyBvYnNlcnZhdGlvbnMgd2l0aCBmYWN0b3JzIG9mIDEwLTMwIHRpbWVz
IHNsb3cgZG93bg0KaSBoYXZlIG5ldmVyIHNlZW4gYmVmb3JlLg0KDQpJIGFzc3VtZSB0aGUgb25s
eSB0aGluZyB0aGF0IHlvdSBjaGFuZ2UgYmV0d2VlbiB0aGUgYmVuY2htYXJrcw0KaXMgdGhlIGtl
cm5lbCAoYW5kIHRoZSBtb2R1bGVzLCBvZiBjb3Vyc2UpLCByaWdodCwgQW5kcmVhPw0KVGhlbiB3
ZSBjYW4gcnVsZSBvdXQgY2FjaGUgc2V0dGluZ3Mgd2hpY2ggbWFzc2l2ZWx5IGNhbiBpbXBhY3QN
CmJlbmNobWFya3MuDQoNClRoZSBvbmx5IHRoaW5nIHRoYXQgbWFrZXMgc2Vuc2UgZnJvbSBteSBQ
T1YgaXM6DQotIGNvbGxlY3QgdHJhY2VzIHdpdGggdGhlIGtlcm5lbCBiZWZvcmUgbWVudGlvbmVk
IGNvbW1pdCAoZmFzdCkNCi0gYXBwbHkgcGF0Y2ggaW4gZG91YnQNCi0gYWdhaW4gY29sbGVjdCB0
cmFjZXMgKHNsb3cpDQotIGNvbXBhcmUgdGhlIHRyYWNlcw0KDQpUaGVuIHdlIHNob3VsZCBiZSBh
YmxlIHRvIHNlZSB0aGUgZGlmZmVyZW5jZShzKS4NClVuZm9ydHVuYXRlbHkgaSdtIG5vdCBhbiBl
eHBlcnQgb24gdGhlIFNDU0kgYW5kIFVTQiBrZXJuZWwgc3R1ZmYNCmludm9sdmVkIGhlcmUuIEVs
c2UgaSB3b3VsZCB0cnkgdG8gdW5kZXJzdGFuZCB3aGF0IGhhcHBlbnMgYW5kDQpnaXZlIHlvdSBz
b21lIGhpbnRzLg0KDQpCUg0KQ2Fyc3Rlbg0K
