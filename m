From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Mon, 4 Jun 2018 07:02:15 +0000
Message-ID: <92633c987a900acf5e7defb481d347a9e5b1253d.camel@wdc.com>
References: <20180322093745.GC4229@kernel.org>
         <20180323155513.dwbgvblenlji33as@linutronix.de>
         <1521822325.2535.5.camel@wdc.com>
         <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
         <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
         <20180326111359.180f1604@gandalf.local.home>
         <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
         <c9f5df1e54bb2bd8f3f0aef86a55deb11888a6a4.camel@wdc.com>
         <20180328151433.elhw6kgxdxq6fn6b@linutronix.de>
         <86c1243e-8733-c94d-d8ff-5c299b8266a6@wdc.com>
         <20180528143518.f46hyhi5r5jd3oxe@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180528143518.f46hyhi5r5jd3oxe@linutronix.de>
Content-Language: en-US
Content-ID: <2B0C44F68D3CC04DBEBD1BC21910647A@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE4LTA1LTI4IGF0IDE2OjM1ICswMjAwLCBiaWdlYXN5QGxpbnV0cm9uaXguZGUg
d3JvdGU6DQo+IE9uIDIwMTgtMDMtMjggMDg6MzE6MzggWy0wNzAwXSwgQmFydCBWYW4gQXNzY2hl
IHdyb3RlOg0KPiA+IE9uIDAzLzI4LzE4IDA4OjE0LCBiaWdlYXN5QGxpbnV0cm9uaXguZGUgd3Jv
dGU6DQo+ID4gPiBPbiAyMDE4LTAzLTI4IDE1OjA1OjQxIFsrMDAwMF0sIEJhcnQgVmFuIEFzc2No
ZSB3cm90ZToNCj4gPiA+ID4gVGhlIG5hbWVzIG9mIHRoZSB0d28gZnVuY3Rpb25zIHRvdWNoZWQg
YnkgcGF0Y2ggMS8yIHN0YXJ0IHdpdGggYSBkb3VibGUNCj4gPiA+ID4gdW5kZXJzY29yZS4gVGhh
dCBieSBpdHNlbGYgaXMgYWxyZWFkeSBhIGhpbnQgdGhhdCB0aGVzZSBzaG91bGQgYmUgY2FsbGVk
IHdpdGgNCj4gPiA+ID4gYSBsb2NrIGhlbGQgKEkga25vdyB0aGF0IHRoaXMgaXMgbm90IGEgdW5p
dmVyc2FsIGNvbnZlbnRpb24gaW4gdGhlIExpbnV4DQo+ID4gPiA+IGtlcm5lbCkuIEknbSBmaW5l
IGVpdGhlciB3YXkgLSBlaXRoZXIgd2l0aCBwYXRjaCAxLzIgYXMgcG9zdGVkIG9yIHBhdGNoIDEv
Mg0KPiA+ID4gPiB3aXRoIHRoZSBhYm92ZSBjb21tZW50IGFkZGVkLg0KPiA+ID4gDQo+ID4gPiBP
a2F5LiBJbiB0aGF0IGNhc2UgbGV0IG1lIHVwZGF0ZSAxLzIuDQo+ID4gPiBCdXQgMi8yIHdpdGgg
dGhlIGNvbW1lbnQgYXMgU3RldmVuIHN1Z2dlc3RlZCBpcyBzdGlsbCBhIG5vIG5vIGZvciB5b3U/
DQo+ID4gDQo+ID4gQWx0aG91Z2ggSSdtIG5vdCBlbnRodXNpYXN0IGFib3V0IHBhdGNoIDIvMiwg
aWYgb3RoZXJzIGFncmVlIHdpdGggdGhhdCBwYXRjaA0KPiA+IEknbSBmaW5lIHdpdGggdGhhdCBw
YXRjaCBiZWluZyBzZW50IHVwc3RyZWFtLg0KPiANCj4gSSd2ZSBiZWVuIHdhaXRpbmcgZm9yIHNv
bWV0aGluZyB0byBoYXBwZW4gYnV0IG5vYm9keSByZXBsaWVkLg0KPiBCYXJ0LCB5b3Ugd2VyZSBm
aW5lIHdpdGggMS8yIGFzIHBvc3RlZCBidXQgbm90IHRvbyBoYXBweSBhYm91dCAyLzIuDQo+IEFz
c3VtaW5nIHdlIGtlZXAgMS8yIGFzIGlzIGFuZCBJIHJlbW92ZSBqdXN0IHRoZQ0KPiAiV0FSTl9P
Tl9PTkNFKCFpcnFzX2Rpc2FibGVkKCkpOyIgZnJvbSAyLzIgKGtlZXBpbmcgdGhlDQo+IGFzc2Vy
dF9zcGluX2xvY2tlZCgpKSwgd291bGQgdGhhdCBpbXByb3ZlIHlvdXIgbW9vZD8gTG9ja2RlcCB3
b3VsZCBzdGlsbA0KPiBwZXJmb3JtIGZ1bGwgdmFsaWRhdGlvbiwgeWVsbCBpZiBfX3RyYW5zcG9y
dF9jaGVja19hYm9ydGVkX3N0YXR1cygpIHdhcw0KPiBpbnZva2VkIHdpdGhvdXQgbG9ja2luZyBh
bmQgYWxzbyB5ZWxsIGFidXQgbWlzc2luZyBJUlEtc2F2ZSBhdCBsb2NraW5nDQo+IHRpbWUgb2Yg
LT50X3N0YXRlX2xvY2spLg0KDQpXb3VsZCBhZGRpbmcgV0FSTl9PTl9PTkNFKCFpcnFzX2Rpc2Fi
bGVkKCkpIHdvcmsgZmluZSB3aXRoIGFuIFJUIGtlcm5lbD8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0K
DQoNCg0KDQo=
