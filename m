From: Clemens Fruhwirth <clemens@endorphin.org>
Subject: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Wed, 14 Oct 2009 23:13:42 +0200
Message-ID: <2f83750a0910141413s58df3658k5ed170541e637f1e@mail.gmail.com>
References: <2f83750a0910141408m44082639m13cb0bfdb5cbd5cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485e36bef35e2050475eba3d8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:62899 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156AbZJNVPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 17:15:34 -0400
Received: by fg-out-1718.google.com with SMTP id 16so141427fgg.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2009 14:13:44 -0700 (PDT)
In-Reply-To: <2f83750a0910141408m44082639m13cb0bfdb5cbd5cb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--001485e36bef35e2050475eba3d8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi everyone,

Short: Attached is an incomplete patch that allows user space to force
the capacity of an scsi device to a specific value. Any not over
my-dead-body objections with that?

Long: I was unfortunate and grabbed one of the cheaper USB SD card
readers that do not correctly detect >1GB capacity sd cards. This is a
known and common bug. See [1] or [2]. What's interesting is that this
card reader was sold to work with these cards explicitly, and I
figured it must have been tested only under Windows, which we all know
believes in the partition table more strongly than in what the device
reports. And indeed, my 2GB sd cards start to work if I simply ignore
the capacity reported by the device. I have been using this
successfully in the last half year with all my sd cards and now I'm
tired of patching the kernel for just that thing. Could you imagine to
merge that upstream? I doubt that any device will kill itself if this
interface is used incorrectly.

A simple user space program using the new interface is available at [3].

Please CC, me not on list.
[1]=C2=A0http://en.wikipedia.org/wiki/Secure_Digital#Standard-SD_cards_.28n=
on-SDHC.29_with_greater_than_1_GB_capacity
[2]=C2=A0http://www.hjreggel.net/cardspeed/special-sd.html
[3]=C2=A0http://blog.clemens.endorphin.org/2009/03/patching-for-broken-sd-c=
ard-readers.html
--
Fruhwirth Clemens http://clemens.endorphin.org

--001485e36bef35e2050475eba3d8
Content-Type: text/x-patch; charset=US-ASCII; name="scsi-capacity-setter.patch"
Content-Disposition: attachment; filename="scsi-capacity-setter.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0skmd8j0

ZGlmZiAtcnUgbGludXgtMi42LjI4L2RyaXZlcnMvc2NzaS9zZC5jIGxpbnV4LTIuNi4yOC9kcml2
ZXJzL3Njc2kvc2QuYwotLS0gbGludXgtMi42LjI4L2RyaXZlcnMvc2NzaS9zZC5jCTIwMDktMDMt
MjEgMTM6MzY6NDguMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYuMjgvZHJpdmVycy9zY3Np
L3NkLmMJMjAwOS0wMy0yMSAxMzowNzo0My4wMDAwMDAwMDAgKzAxMDAKQEAgLTcyNSw2ICs3MjUs
MTkgQEAKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGludCBzY3NpX2lvY3RsX3NldF9jYXBhY2l0
eShzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwLCB2b2lkIF9fdXNlciAqYXJnKQoreworICAgIGludCB2
YWwsIHJlc3VsdDsKKworICAgIHJlc3VsdCA9IGdldF91c2VyKHZhbCwgKGludCBfX3VzZXIgKilh
cmcpOworICAgIGlmIChyZXN1bHQpCisJcmV0dXJuIHJlc3VsdDsKKyAgICBzZGtwLT5jYXBhY2l0
eSA9IHZhbDsKKyAgICBzZXRfY2FwYWNpdHkoc2RrcC0+ZGlzaywgc2RrcC0+Y2FwYWNpdHkpOwor
CisgICAgcmV0dXJuIDA7Cit9CisKIC8qKgogICoJc2RfaW9jdGwgLSBwcm9jZXNzIGFuIGlvY3Rs
CiAgKglAaW5vZGU6IG9ubHkgaV9yZGV2L2lfYmRldiBtZW1iZXJzIG1heSBiZSB1c2VkCkBAIC03
NzAsNiArNzg2LDExIEBACiAJCWNhc2UgU0NTSV9JT0NUTF9HRVRfSURMVU46CiAJCWNhc2UgU0NT
SV9JT0NUTF9HRVRfQlVTX05VTUJFUjoKIAkJCXJldHVybiBzY3NpX2lvY3RsKHNkcCwgY21kLCBw
KTsKKwkJY2FzZSBTQ1NJX0lPQ1RMX1NFVF9DQVBBQ0lUWToKKwkJCXJldHVybiBzY3NpX2lvY3Rs
X3NldF9jYXBhY2l0eShzY3NpX2Rpc2soZGlzayksIChpbnQgX191c2VyICopYXJnKTsKKwkJY2Fz
ZSBTQ1NJX0lPQ1RMX0dFVF9DQVBBQ0lUWToKKwkJCXJldHVybiBwdXRfdXNlcihzY3NpX2Rpc2so
ZGlzayktPmNhcGFjaXR5LCAoaW50IF9fdXNlciAqKWFyZyk7CisKIAkJZGVmYXVsdDoKIAkJCWVy
cm9yID0gc2NzaV9jbWRfaW9jdGwoZGlzay0+cXVldWUsIGRpc2ssIG1vZGUsIGNtZCwgcCk7CiAJ
CQlpZiAoZXJyb3IgIT0gLUVOT1RUWSkKZGlmZiAtcnUgbGludXgtMi42LjI4L2luY2x1ZGUvc2Nz
aS9zY3NpX2lvY3RsLmggbGludXgtMi42LjI4L2luY2x1ZGUvc2NzaS9zY3NpX2lvY3RsLmgKLS0t
IGxpbnV4LTIuNi4yOC9pbmNsdWRlL3Njc2kvc2NzaV9pb2N0bC5oCTIwMDgtMTItMjUgMDA6MjY6
MzcuMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYuMjgvaW5jbHVkZS9zY3NpL3Njc2lfaW9j
dGwuaAkyMDA5LTAzLTIxIDEyOjQ4OjQ1LjAwMDAwMDAwMCArMDEwMApAQCAtMTEsNiArMTEsOCBA
QAogICAgdGhlIGNkcm9tICovCiAjZGVmaW5lIFNDU0lfSU9DVExfRE9PUkxPQ0sgMHg1MzgwCQkv
KiBsb2NrIHRoZSBlamVjdCBtZWNoYW5pc20gKi8KICNkZWZpbmUgU0NTSV9JT0NUTF9ET09SVU5M
T0NLIDB4NTM4MQkJLyogdW5sb2NrIHRoZSBtZWNoYW5pc20JICAqLworI2RlZmluZSBTQ1NJX0lP
Q1RMX1NFVF9DQVBBQ0lUWSAweDUzODgJCS8qIHNldCBjYXBhY2l0eSAqLworI2RlZmluZSBTQ1NJ
X0lPQ1RMX0dFVF9DQVBBQ0lUWSAweDUzODkJCS8qIGdldCBjYXBhY2l0eSAqLwogCiAjZGVmaW5l
CVNDU0lfUkVNT1ZBTF9QUkVWRU5UCTEKICNkZWZpbmUJU0NTSV9SRU1PVkFMX0FMTE9XCTAK
--001485e36bef35e2050475eba3d8--
