From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] target: remove spin_lock_assert() in
 __target_(attach|detach)_tg_pt_gp()
Date: Fri, 23 Mar 2018 17:55:54 +0000
Message-ID: <1521827753.2535.18.camel@wdc.com>
References: <20180321153854.GB24312@kernel.org>
         <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
         <20180322093745.GC4229@kernel.org>
         <20180323155513.dwbgvblenlji33as@linutronix.de>
         <1521822325.2535.5.camel@wdc.com>
         <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
         <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
         <20180323171959.7ac6klrqg4fdk3ey@linutronix.de>
         <1521827085.2535.12.camel@wdc.com>
         <20180323175013.6uucllg5ogyzfovt@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323175013.6uucllg5ogyzfovt@linutronix.de>
Content-Language: en-US
Content-ID: <10DDBCCF35C36246B75B0AB3D36CA660@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "acme@kernel.org" <acme@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAzLTIzIGF0IDE4OjUwICswMTAwLCBiaWdlYXN5QGxpbnV0cm9uaXguZGUg
d3JvdGU6DQo+IE9uIDIwMTgtMDMtMjMgMTc6NDQ6NDYgWyswMDAwXSwgQmFydCBWYW4gQXNzY2hl
IHdyb3RlOg0KPiA+IEluIG90aGVyIHdvcmRzLCBkbyB3ZSByZWFsbHkgbmVlZCB0byByZW1vdmUg
dGhlc2UgY2hlY2tzPyBJIHRoaW5rIHRoYXQgdGhlc2UNCj4gPiBjaGVja3MgYXJlIHVzZWZ1bCBh
cyBkb2N1bWVudGF0aW9uIHRvIHBlb3BsZSB3aG8gcmVhZCB0aGUgU0NTSSB0YXJnZXQgY29kZS4N
Cj4gPiBUaGUgdGFyZ2V0IGNvZGUgaXMgYWxyZWFkeSBoYXJkIHRvIGZvbGxvdyBzbyBJIHRoaW5r
IGFueSBkb2N1bWVudGF0aW9uLA0KPiA+IGVzcGVjaWFsbHkgZG9jdW1lbnRhdGlvbiBpbiB0aGUg
Zm9ybSBvZiBjb2RlIHRoYXQgaXMgY2hlY2tlZCBhdCBydW50aW1lLCBpcw0KPiA+IHdlbGNvbWUu
DQo+IA0KPiBzbyBpZiBJIHJlbW92ZSB0aG9zZSB0d28gYW5kIGFkZCBhIGtlcm5lbCBkb2MgY29t
bWVudCBpbnN0ZWFkLCBzYXlpbmcNCj4gdGhhdCB0aGUgY2FsbGVyIG5lZWRzIHRvIGVuc3VyZSB0
aGF0ICJsdW4tPmx1bl90Z19wdF9ncF9sb2NrIiBpcyBoZWxkDQo+IHRoZW4gd2Ugd291bGQgcmVt
b3ZlIHRoZSBvYnZpb3VzIHJ1bnRpbWUgY2hlY2sgYW5kIGFkZCBhIHBpZWNlIG9mDQo+IGRvY3Vt
ZW50YXRpb24uIFdvdWxkIHRoYXQgd29yaz8NCg0KQ29tbWVudHMgYXJlIG5vdCB2ZXJpZmllZCBh
dCBydW50aW1lIGFuZCBoZW5jZSBjYW4gYmVjb21lIG91dGRhdGVkIGlmIHRoZSBjb2RlDQppcyBt
b2RpZmllZC4gYXNzZXJ0X3NwaW5fbG9ja2VkKCkgYW5kIGxvY2tkZXBfYXNzZXJ0X2hlbGQoKSBh
c3NlcnRpb25zIGhvd2V2ZXINCmFyZSB2ZXJpZmllZCBhdCBydW50aW1lIHdpdGggdGhlIHByb3Bl
ciBrZXJuZWwgY29uZmlndXJhdGlvbiBvcHRpb25zIGVuYWJsZWQuDQpIZW5jZSBteSBwcmVmZXJl
bmNlIGZvciBhc3NlcnRfc3Bpbl9sb2NrZWQoKS9sb2NrZGVwX2Fzc2VydF9oZWxkKCkgb3ZlciBz
b3VyY2UNCmNvZGUgY29tbWVudHMuDQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQo=
