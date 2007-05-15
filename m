From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Correct sa platform support. (Was: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1)
Date: Tue, 15 May 2007 09:14:21 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0197D746@otce2k301.adaptec.com>
References: <20070514222958.a0587f8a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C796F2.F3F88598"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:49811 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbXEONOZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 09:14:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070514222958.a0587f8a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, Rainer Malitzke-Goes <malitzke@metronets.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C796F2.F3F88598
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

As discussed in the bugzilla outlined below, we have an sa based
(Mustang) RAID adapter on the system, a Dell PERC2/QC. Affected
controllers are HP NetRAID, Adaptec AAC-364, Dell PERC2/QC or Adaptec
5400S. This problem  coincides with the introduction of the adapter_comm
and adapter_deliver platform functions (Message [PATCH 1/4] aacraid:
rework communication support code, January 23 2007, which initially
migrated to 2.6.21)

The panic occurs with an uninitialized adapter_deliver platform function
pointer. The enclosed patch, unmodified as tested by Rainer, solves the
problem.

This attached patch is against current scsi-misc-2.6, applies cleanly to
2.6.21-git12. It may require manual intervention to be applied to 2.6.21
or 2.6.21.1, simple breakage when merely adding a single line to
aacraid.h:

. . .
+ int aac_rx_deliver_producer(struct fib * fib);
  extern int numacb;
. . .

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]=20
> Sent: Tuesday, May 15, 2007 1:30 AM
> To: Salyzyn, Mark
> Subject: Re: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1
>=20
> On Mon, 14 May 2007 22:10:20 -0700=20
> bugme-daemon@bugzilla.kernel.org wrote:
>=20
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D8469
>=20
> we appear to have a thumbs-up.  Please cc me on the final patch?
>=20
> Please also consider ccing stable@kernel.org, as this bug affects
2.6.21.x.
>=20
> Thanks.

------_=_NextPart_001_01C796F2.F3F88598
Content-Type: application/octet-stream;
	name="aacraid_sa_fix.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_sa_fix.patch
Content-Disposition: attachment;
	filename="aacraid_sa_fix.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmggYi9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9hYWNyYWlkLmgKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oCTIw
MDctMDUtMTQgMTE6NTY6MTQuNjQwMTY5OTQ5IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNy
YWlkL2FhY3JhaWQuaAkyMDA3LTA1LTE0IDExOjU5OjA0LjA4NTkwNTE0NyAtMDQwMApAQCAtMTgy
Myw2ICsxODIzLDcgQEAKIGludCBhYWNfcHJvYmVfY29udGFpbmVyKHN0cnVjdCBhYWNfZGV2ICpk
ZXYsIGludCBjaWQpOwogaW50IF9hYWNfcnhfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KTsKIGlu
dCBhYWNfcnhfc2VsZWN0X2NvbW0oc3RydWN0IGFhY19kZXYgKmRldiwgaW50IGNvbW0pOworaW50
IGFhY19yeF9kZWxpdmVyX3Byb2R1Y2VyKHN0cnVjdCBmaWIgKiBmaWIpOwogZXh0ZXJuIGludCBu
dW1hY2I7CiBleHRlcm4gaW50IGFjYnNpemU7CiBleHRlcm4gY2hhciBhYWNfZHJpdmVyX3ZlcnNp
b25bXTsKZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3Np
L2FhY3JhaWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDUtMTQg
MTE6NTY6MTQuNjQzMTY5NTM3IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJ
MjAwNy0wNS0xNCAxMTo1OTowNC4wODY5MDUwMTAgLTA0MDAKQEAgLTM3OCw3ICszNzgsNyBAQAog
ICoKICAqCVdpbGwgc2VuZCBhIGZpYiwgcmV0dXJuaW5nIDAgaWYgc3VjY2Vzc2Z1bC4KICAqLwot
c3RhdGljIGludCBhYWNfcnhfZGVsaXZlcl9wcm9kdWNlcihzdHJ1Y3QgZmliICogZmliKQoraW50
IGFhY19yeF9kZWxpdmVyX3Byb2R1Y2VyKHN0cnVjdCBmaWIgKiBmaWIpCiB7CiAJc3RydWN0IGFh
Y19kZXYgKmRldiA9IGZpYi0+ZGV2OwogCXN0cnVjdCBhYWNfcXVldWUgKnEgPSAmZGV2LT5xdWV1
ZXMtPnF1ZXVlW0FkYXBOb3JtQ21kUXVldWVdOwpkaWZmIC1ydSBhL2RyaXZlcnMvc2NzaS9hYWNy
YWlkL3NhLmMgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9zYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL3NhLmMJMjAwNy0wNS0xNCAxMTo1NjoxNC42NDMxNjk1MzcgLTA0MDAKKysrIGIvZHJp
dmVycy9zY3NpL2FhY3JhaWQvc2EuYwkyMDA3LTA1LTE0IDExOjU5OjA0LjA4NzkwNDg3MyAtMDQw
MApAQCAtNSw3ICs1LDcgQEAKICAqIGJhc2VkIG9uIHRoZSBvbGQgYWFjcmFpZCBkcml2ZXIgdGhh
dCBpcy4uCiAgKiBBZGFwdGVjIGFhY3JhaWQgZGV2aWNlIGRyaXZlciBmb3IgTGludXguCiAgKgot
ICogQ29weXJpZ2h0IChjKSAyMDAwIEFkYXB0ZWMsIEluYy4gKGFhY3JhaWRAYWRhcHRlYy5jb20p
CisgKiBDb3B5cmlnaHQgKGMpIDIwMDAtMjAwNyBBZGFwdGVjLCBJbmMuIChhYWNyYWlkQGFkYXB0
ZWMuY29tKQogICoKICAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJl
ZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgKiBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhl
IEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQpAQCAtMjU3LDYgKzI1
NywxMSBAQAogCQkJTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCk7CiB9CiAKK3N0YXRpYyBp
bnQgYWFjX3NhX3Jlc3RhcnRfYWRhcHRlcihzdHJ1Y3QgYWFjX2RldiAqZGV2LCBpbnQgYmxlZCkK
K3sKKwlyZXR1cm4gLUVJTlZBTDsKK30KKwogLyoqCiAgKglhYWNfc2FfY2hlY2tfaGVhbHRoCiAg
KglAZGV2OiBkZXZpY2UgdG8gY2hlY2sgaWYgaGVhbHRoeQpAQCAtMzY2LDcgKzM3MSw5IEBACiAJ
ZGV2LT5hX29wcy5hZGFwdGVyX25vdGlmeSA9IGFhY19zYV9ub3RpZnlfYWRhcHRlcjsKIAlkZXYt
PmFfb3BzLmFkYXB0ZXJfc3luY19jbWQgPSBzYV9zeW5jX2NtZDsKIAlkZXYtPmFfb3BzLmFkYXB0
ZXJfY2hlY2tfaGVhbHRoID0gYWFjX3NhX2NoZWNrX2hlYWx0aDsKKwlkZXYtPmFfb3BzLmFkYXB0
ZXJfcmVzdGFydCA9IGFhY19zYV9yZXN0YXJ0X2FkYXB0ZXI7CiAJZGV2LT5hX29wcy5hZGFwdGVy
X2ludHIgPSBhYWNfc2FfaW50cjsKKwlkZXYtPmFfb3BzLmFkYXB0ZXJfZGVsaXZlciA9IGFhY19y
eF9kZWxpdmVyX3Byb2R1Y2VyOwogCWRldi0+YV9vcHMuYWRhcHRlcl9pb3JlbWFwID0gYWFjX3Nh
X2lvcmVtYXA7CiAKIAkvKgo=

------_=_NextPart_001_01C796F2.F3F88598--
