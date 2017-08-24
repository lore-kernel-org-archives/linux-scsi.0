From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Improve requeuing behavior
Date: Thu, 24 Aug 2017 17:17:57 +0000
Message-ID: <1503595075.2702.21.camel@wdc.com>
References: <20170823210535.1072-1-bart.vanassche@wdc.com>
         <20170824120944.GB23186@lst.de> <1503591261.2702.9.camel@wdc.com>
         <20170824165704.GA28901@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53116 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753314AbdHXRSq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2017 13:18:46 -0400
In-Reply-To: <20170824165704.GA28901@lst.de>
Content-Language: en-US
Content-ID: <8EAC91F0895F3E48B9CE2654D5CC047E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

T24gVGh1LCAyMDE3LTA4LTI0IGF0IDE4OjU3ICswMjAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBUaHUsIEF1ZyAyNCwgMjAxNyBhdCAwNDoxNDoyMlBNICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUg
d3JvdGU6DQo+ID4gQ29tbWl0IGNhMThkNmY3NjlkMiAoImJsb2NrOiBNYWtlIG1vc3Qgc2NzaV9y
ZXFfaW5pdCgpIGNhbGxzIGltcGxpY2l0IikNCj4gPiBpbnRyb2R1Y2VkIHRoZSBzY3NpX2luaXRp
YWxpemVfcnEoKSBmdW5jdGlvbiBpbiBzdWNoIGEgd2F5IHRoYXQgaXQgaXMgbm90IG9ubHkNCj4g
PiBjYWxsZWQgZm9yIHBhc3MtdGhyb3VnaCByZXF1ZXN0cyBidXQgYWxzbyBmb3IgRlMgcmVxdWVz
dHMuIEJlY2F1c2UgdGhhdCBjb21taXQNCj4gPiBzZXRzIC5pbml0aWFsaXplX3JxX2ZuIGZvciBi
b3RoIGJsay1zcSBhbmQgYmxrLW1xIGJsa19nZXRfcmVxdWVzdCgpIG5vdyBjYWxscw0KPiA+IHNj
c2lfaW5pdGlhbGl6ZV9ycSgpIGZvciBhbGwgU0NTSSByZXF1ZXN0cy4gT3IgZGlkIEkgcGVyaGFw
cyBvdmVybG9vayBzb21ldGhpbmc/DQo+IA0KPiBpbml0aWFsaXplX3JxX2ZuIGlzIG9ubHkgY2Fs
bGVkIGZyb20gYmxrX2dldF9yZXF1ZXN0LCB3aGljaCBpcyBub3QNCj4gY2FsbGVkIGZvciBub3Jt
YWwgZmlsZSBzeXN0ZW0gcmVhZC93cml0ZS9mbHVzaC9kaXNjYXJkIHJlcXVlc3QuDQo+IA0KPiBB
bHNvIHVubGVzcyBteSBtZW1vcnkgZmFpbHMgbWUgdGhhdCdzIHNvbWV0aGluZyB0aGF0IEkgYW5k
IEplbnMgcmVxdWVzdGVkDQo+IHRvIGJlIGNoYW5nZWQgZnJvbSB5b3VyIG9yaWdpbmFsIHZlcnNp
b24uDQoNCkhlbGxvIENocmlzdG9waCwNCg0KSXMgb25lIG9mIHRoZSBmb2xsb3dpbmcgdHdvIGFw
cHJvYWNoZXMgcGVyaGFwcyB3aGF0IHlvdSBoYWQgaW4gbWluZD8NCiogQWRkaW5nIGFuIC5pbml0
aWFsaXplX3JxX2ZuKCkgY2FsbCB0byBtdWx0aXBsZSBibGtfcnFfaW5pdCgpIGFuZA0KICBibGtf
bXFfcnFfY3R4X2luaXQoKSBjYWxsZXJzLCBlLmcuIGJsa19tcV9tYWtlX3JlcXVlc3QoKSwgX19n
ZXRfcmVxdWVzdCgpLA0KICBibGtfa2lja19mbHVzaCgpIGFuZCBzY3NpX2lvY3RsX3Jlc2V0KCku
DQoqIE1vdmluZyB0aGUgLmluaXRpYWxpemVfcnFfZm4oKSBjYWxsIGZyb20gYmxrX2dldF9yZXF1
ZXN0KCkgaW50byBibGtfcnFfaW5pdCgpDQogIGFuZCBibGtfbXFfcnFfY3R4X2luaXQoKSAoc2Vl
IGFsc28NCiAgaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtc2NzaS9tc2cxMDg5
MzQuaHRtbCkuDQoNClRoYW5rcywNCg0KQmFydC4=
