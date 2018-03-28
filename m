From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Wed, 28 Mar 2018 15:05:41 +0000
Message-ID: <c9f5df1e54bb2bd8f3f0aef86a55deb11888a6a4.camel@wdc.com>
References: <20180321153854.GB24312@kernel.org>
         <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
         <20180322093745.GC4229@kernel.org>
         <20180323155513.dwbgvblenlji33as@linutronix.de>
         <1521822325.2535.5.camel@wdc.com>
         <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
         <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
         <20180326111359.180f1604@gandalf.local.home>
         <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328101553.uduqsdbxwnxrhl7a@linutronix.de>
Content-Language: en-US
Content-ID: <3E7B0C089BD03A478E5E51BA9B5236BE@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTAzLTI4IGF0IDEyOjE1ICswMjAwLCBiaWdlYXN5QGxpbnV0cm9uaXguZGUg
d3JvdGU6DQo+IE9uIDIwMTgtMDMtMjYgMTE6MTM6NTkgWy0wNDAwXSwgU3RldmVuIFJvc3RlZHQg
d3JvdGU6DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdG1y
LmMgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYw0KPiA+ID4gaW5kZXggOWM3YmMx
Y2EzNDFhLi4zZDM1ZGFkMWRlMmMgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3RhcmdldC90
YXJnZXRfY29yZV90bXIuYw0KPiA+ID4gKysrIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVf
dG1yLmMNCj4gPiANCj4gPiBDYW4geW91IGFkZCBhIGNvbW1lbnQgYWJvdmUgdGhlIGZ1bmN0aW9u
cyB0aG91Z2g/DQo+ID4gDQo+ID4gLyogRXhwZWN0cyB0byBoYXZlIHNlX2NtZC0+c2Vfc2Vzcy0+
c2Vzc19jbWRfbG9jayBoZWxkICovDQo+IA0KPiBJIGNvdWxkLiBJIGhhdmVuJ3QgaGVhcmQgZnJv
bSBCYXJ0IC8gTmljaG9sYXMgYWJvdXQgdGhlaXIgb3Bpbmlvbi4gSQ0KPiBrbm93LCB3ZSBkbyB0
aGlzIG90aGVyIHBsYWNlcyBidXQgQmFydCB3YXMgYWdhaW5zdCB0aGlzIGtpbmQgb2YNCj4gYW5u
b3RhdGlvbiBpbiAyLzIgb2YgdGhpcyB0aHJlYWQuDQo+IFNvIEkgYW0gd2FpdGluZyB0byBoZWFy
IGZyb20gdGhlbSA6KQ0KDQpUaGUgbmFtZXMgb2YgdGhlIHR3byBmdW5jdGlvbnMgdG91Y2hlZCBi
eSBwYXRjaCAxLzIgc3RhcnQgd2l0aCBhIGRvdWJsZQ0KdW5kZXJzY29yZS4gVGhhdCBieSBpdHNl
bGYgaXMgYWxyZWFkeSBhIGhpbnQgdGhhdCB0aGVzZSBzaG91bGQgYmUgY2FsbGVkIHdpdGgNCmEg
bG9jayBoZWxkIChJIGtub3cgdGhhdCB0aGlzIGlzIG5vdCBhIHVuaXZlcnNhbCBjb252ZW50aW9u
IGluIHRoZSBMaW51eA0Ka2VybmVsKS4gSSdtIGZpbmUgZWl0aGVyIHdheSAtIGVpdGhlciB3aXRo
IHBhdGNoIDEvMiBhcyBwb3N0ZWQgb3IgcGF0Y2ggMS8yDQp3aXRoIHRoZSBhYm92ZSBjb21tZW50
IGFkZGVkLg0KDQpCYXJ0Lg0KDQoNCg0KDQo=
