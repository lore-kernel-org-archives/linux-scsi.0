From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: qla2xxx (2100) vs. qlogicfc [again]
Date: Mon, 10 May 2004 14:38:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD0145@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C436D7.1E064554"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:11580 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261918AbUEJVjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 17:39:32 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C436D7.1E064554
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


On Friday, May 07, 2004 4:55 PM, Ricky Beam wrote:

>=20

Ok, well there aren't too many folks using an QLA2100 in a fabric
topology, if there were, they wouldn't have gotten very far in the
driver load sequence.  I've been able to scrape-up a QLA2100, 1Gig
switch, and an JBOD.  Upon loading the 8.00.00b12k driver, the
firmware successfully logs into the switch, the driver receives a
LOOP_UP event, but, the kernel panics due to NULL pointer dereference
while trying to perform an RFT_ID  -- the attached patch against
current scsi-misc-2.6 fixes that problem.  Here's the relevant dmesg
output after load:

	QLogic Fibre Channel HBA Driver (f88d6000)
	qla2100 0000:02:04.0: Found an ISP2100, irq 52, iobase 0xf88a9000
	qla2100 0000:02:04.0: Configuring PCI space...
	qla2100 0000:02:04.0: Configure NVRAM parameters...
	qla2100 0000:02:04.0: Verifying loaded RISC code...
	qla2100 0000:02:04.0: LIP reset occured (f7f7).
	qla2100 0000:02:04.0: Waiting for LIP to complete...
	qla2100 0000:02:04.0: LIP occured (0).
	qla2100 0000:02:04.0: LOOP UP detected (1 Gbps).
	qla2100 0000:02:04.0: Topology - (FL_Port), Host Loop address 0x0
	scsi8 : qla2xxx
	qla2100 0000:02:04.0:=20
	 QLogic Fibre Channel HBA Driver: 8.00.00b12-k
	  QLogic QLA2100 -=20
	  ISP2100: PCI (33 MHz) @ 0000:02:04.0 hdma-, host#=3D8, fw=3D1.19.24 =
TP
	  Vendor: SEAGATE   Model: ST39173FC         Rev: 6615
	  Type:   Direct-Access                      ANSI SCSI revision: 02
	qla2100 0000:02:04.0: scsi(8:0:0:0): Enabled tagged queuing, queue =
depth 16.
	SCSI device sdb: 17783240 512-byte hdwr sectors (9105 MB)
	SCSI device sdb: drive cache: write back
	 sdb: unknown partition table
	Attached scsi disk sdb at scsi8, channel 0, id 0, lun 0
	Attached scsi generic sg1 at scsi8, channel 0, id 0, lun 0,  type 0
	  Vendor: SEAGATE   Model: ST39173FC         Rev: 6615
	  Type:   Direct-Access                      ANSI SCSI revision: 02
	qla2100 0000:02:04.0: scsi(8:0:1:0): Enabled tagged queuing, queue =
depth 16.
	SCSI device sdc: 17783240 512-byte hdwr sectors (9105 MB)
	SCSI device sdc: drive cache: write back
	 sdc:
	Attached scsi disk sdc at scsi8, channel 0, id 1, lun 0
	Attached scsi generic sg2 at scsi8, channel 0, id 1, lun 0,  type 0
	  Vendor: SEAGATE   Model: ST39173FC         Rev: 6615
	  Type:   Direct-Access                      ANSI SCSI revision: 02
	qla2100 0000:02:04.0: scsi(8:0:2:0): Enabled tagged queuing, queue =
depth 16.
	...

Unfortunately, the attached patch will not help with the problems you
are having=20

> May  7 18:27:32
> %%% card - switch - two shelves
> QLogic Fibre Channel HBA Driver (f8a0c000)
> qla2100 0000:06:03.0: Found an ISP2100, irq 24, iobase 0xf8930000
> qla2100 0000:06:03.0: Configuring PCI space...
> qla2100 0000:06:03.0: Configure NVRAM parameters...
> qla2100 0000:06:03.0: Verifying loaded RISC code...
> scsi(0): **** Load RISC code ****
> scsi(0): Verifying Checksum of loaded RISC code.
> scsi(0): Checksum OK, start firmware.
> scsi(0): Issue init firmware.
> scsi(0): Asynchronous LIP RESET (f8f7).
> qla2100 0000:06:03.0: LIP reset occured (f8f7).
> qla2100 0000:06:03.0: Waiting for LIP to complete...
> scsi(0): LIP occured (f8f7).
> qla2100 0000:06:03.0: LIP occured (f8f7).
> scsi(0): Asynchronous LIP RESET (f7f7).
> qla2100 0000:06:03.0: LIP reset occured (f7f7).
> scsi(0): LIP occured (f7f7).
> qla2100 0000:06:03.0: LIP occured (f7f7).
> --- (tired of waiting... physically disconnect cable @ 18:31:25)
> --- (note: switch reports zero frames on all ports during this delay)
> qla2100 0000:06:03.0: Cable is unplugged...

since it seems the driver is never receiving a LOOP_UP event from the
firmware indicating that we have successfully negotiated with the
fabric and may begin discovery.


> QLogic Fibre Channel HBA Driver: 8.00.00b12-k-debug
>  QLogic QLA2100 -
>  ISP2100: PCI (33 MHz) @ 0000:06:03.0 hdma-, host#=3D0, fw=3D0.00.00 =
(0)
                                                              ^
This looks suspicious ----------------------------------------|

The non-embedded (complete package containing extra-tools and
failover-support) driver available at:

	=
ftp://ftp.qlogic.com/outgoing/linux/beta/8.x/qla2xxx-src-v8.00.00b12.tar.=
bz2=20

contains a small utility (qla_nvr) which dumps the contents of a
board's NVRAM.  Can you run the program on your host i.e. :

	# cat /sys/class/scsi_host/host1/device/nvram | ./extras/qla_nvr -a=20

and forward me the output off-list.  Substitute 'host1' for the
applicable path on your system.

--
Andrew Vasquez

------_=_NextPart_001_01C436D7.1E064554
Content-Type: application/octet-stream;
	name="fix_2100_fabric-bk.diff"
Content-Transfer-Encoding: base64
Content-Description: fix_2100_fabric-bk.diff
Content-Disposition: attachment;
	filename="fix_2100_fabric-bk.diff"

PT09PT0gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oIDEuMTQgdnMgZWRpdGVkID09PT09
Ci0tLSAxLjE0L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaAlNb24gTWF5ICAzIDA4OjE1
OjM4IDIwMDQKKysrIGVkaXRlZC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGVmLmgJTW9uIE1h
eSAxMCAxNDowNzo1NCAyMDA0CkBAIC0xOTI2LDEwICsxOTI2LDYgQEAKICNkZWZpbmUJUkZUX0lE
X1NOU19DTURfU0laRQk2MAogI2RlZmluZQlSRlRfSURfU05TX0RBVEFfU0laRQkxNgogCi0jZGVm
aW5lCVJGRl9JRF9TTlNfU0NNRF9MRU4JOAotI2RlZmluZQlSRkZfSURfU05TX0NNRF9TSVpFCTMy
Ci0jZGVmaW5lCVJGRl9JRF9TTlNfREFUQV9TSVpFCTE2Ci0KICNkZWZpbmUJUk5OX0lEX1NOU19T
Q01EX0xFTgkxMAogI2RlZmluZQlSTk5fSURfU05TX0NNRF9TSVpFCTM2CiAjZGVmaW5lCVJOTl9J
RF9TTlNfREFUQV9TSVpFCTE2CkBAIC0xOTY1LDcgKzE5NjEsNiBAQAogCQl9IGNtZDsKIAogCQl1
aW50OF90IHJmdF9kYXRhW1JGVF9JRF9TTlNfREFUQV9TSVpFXTsKLQkJdWludDhfdCByZmZfZGF0
YVtSRkZfSURfU05TX0RBVEFfU0laRV07CiAJCXVpbnQ4X3Qgcm5uX2RhdGFbUk5OX0lEX1NOU19E
QVRBX1NJWkVdOwogCQl1aW50OF90IGdhbl9kYXRhW0dBX05YVF9TTlNfREFUQV9TSVpFXTsKIAkJ
dWludDhfdCBnaWRfZGF0YVtHSURfUFRfU05TX0RBVEFfU0laRV07Cj09PT09IGRyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9ncy5jIDEuNSB2cyBlZGl0ZWQgPT09PT0KLS0tIDEuNS9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfZ3MuYwlGcmkgTWFyIDEyIDA5OjA2OjEwIDIwMDQKKysrIGVkaXRlZC9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ3MuYwlNb24gTWF5IDEwIDE0OjA3OjU1IDIwMDQKQEAg
LTM0LDcgKzM0LDYgQEAKIHN0YXRpYyBpbnQgcWxhMngwMF9zbnNfZ3BuX2lkKHNjc2lfcWxhX2hv
c3RfdCAqLCBzd19pbmZvX3QgKik7CiBzdGF0aWMgaW50IHFsYTJ4MDBfc25zX2dubl9pZChzY3Np
X3FsYV9ob3N0X3QgKiwgc3dfaW5mb190ICopOwogc3RhdGljIGludCBxbGEyeDAwX3Nuc19yZnRf
aWQoc2NzaV9xbGFfaG9zdF90ICopOwotc3RhdGljIGludCBxbGEyeDAwX3Nuc19yZmZfaWQoc2Nz
aV9xbGFfaG9zdF90ICopOwogc3RhdGljIGludCBxbGEyeDAwX3Nuc19ybm5faWQoc2NzaV9xbGFf
aG9zdF90ICopOwogCiAvKioKQEAgLTExMyw3ICsxMTIsNyBAQAogCXN0cnVjdCBjdF9zbnNfcmVx
CSpjdF9yZXE7CiAJc3RydWN0IGN0X3Nuc19yc3AJKmN0X3JzcDsKIAotCWlmIChJU19RTEEyMjAw
KGhhKSkgeworCWlmIChJU19RTEEyMTAwKGhhKSB8fCBJU19RTEEyMjAwKGhhKSkgewogCQlyZXR1
cm4gKHFsYTJ4MDBfc25zX2dhX254dChoYSwgZmNwb3J0KSk7CiAJfQogCkBAIC0yMDEsNyArMjAw
LDcgQEAKIAogCXN0cnVjdCBjdF9zbnNfZ2lkX3B0X2RhdGEgKmdpZF9kYXRhOwogCi0JaWYgKElT
X1FMQTIyMDAoaGEpKSB7CisJaWYgKElTX1FMQTIxMDAoaGEpIHx8IElTX1FMQTIyMDAoaGEpKSB7
CiAJCXJldHVybiAocWxhMngwMF9zbnNfZ2lkX3B0KGhhLCBsaXN0KSk7CiAJfQogCkBAIC0yNzgs
NyArMjc3LDcgQEAKIAlzdHJ1Y3QgY3Rfc25zX3JlcQkqY3RfcmVxOwogCXN0cnVjdCBjdF9zbnNf
cnNwCSpjdF9yc3A7CiAKLQlpZiAoSVNfUUxBMjIwMChoYSkpIHsKKwlpZiAoSVNfUUxBMjEwMCho
YSkgfHwgSVNfUUxBMjIwMChoYSkpIHsKIAkJcmV0dXJuIChxbGEyeDAwX3Nuc19ncG5faWQoaGEs
IGxpc3QpKTsKIAl9CiAKQEAgLTM0Myw3ICszNDIsNyBAQAogCXN0cnVjdCBjdF9zbnNfcmVxCSpj
dF9yZXE7CiAJc3RydWN0IGN0X3Nuc19yc3AJKmN0X3JzcDsKIAotCWlmIChJU19RTEEyMjAwKGhh
KSkgeworCWlmIChJU19RTEEyMTAwKGhhKSB8fCBJU19RTEEyMjAwKGhhKSkgewogCQlyZXR1cm4g
KHFsYTJ4MDBfc25zX2dubl9pZChoYSwgbGlzdCkpOwogCX0KIApAQCAtNDIyLDcgKzQyMSw3IEBA
CiAJc3RydWN0IGN0X3Nuc19yZXEJKmN0X3JlcTsKIAlzdHJ1Y3QgY3Rfc25zX3JzcAkqY3RfcnNw
OwogCi0JaWYgKElTX1FMQTIyMDAoaGEpKSB7CisJaWYgKElTX1FMQTIxMDAoaGEpIHx8IElTX1FM
QTIyMDAoaGEpKSB7CiAJCXJldHVybiAocWxhMngwMF9zbnNfcmZ0X2lkKGhhKSk7CiAJfQogCkBA
IC00NzksOCArNDc4LDEwIEBACiAJc3RydWN0IGN0X3Nuc19yZXEJKmN0X3JlcTsKIAlzdHJ1Y3Qg
Y3Rfc25zX3JzcAkqY3RfcnNwOwogCi0JaWYgKElTX1FMQTIyMDAoaGEpKSB7Ci0JCXJldHVybiAo
cWxhMngwMF9zbnNfcmZmX2lkKGhhKSk7CisJaWYgKElTX1FMQTIxMDAoaGEpIHx8IElTX1FMQTIy
MDAoaGEpKSB7CisJCURFQlVHMihwcmludGsoInNjc2koJWxkKTogUkZGX0lEIGNhbGwgdW5zdXBw
b3J0ZWQgb24gIgorCQkgICAgIklTUDIxMDAvSVNQMjIwMC5cbiIsIGhhLT5ob3N0X25vKSk7CisJ
CXJldHVybiAoUUxBX1NVQ0NFU1MpOwogCX0KIAogCS8qIElzc3VlIFJGRl9JRCAqLwpAQCAtNTM2
LDcgKzUzNyw3IEBACiAJc3RydWN0IGN0X3Nuc19yZXEJKmN0X3JlcTsKIAlzdHJ1Y3QgY3Rfc25z
X3JzcAkqY3RfcnNwOwogCi0JaWYgKElTX1FMQTIyMDAoaGEpKSB7CisJaWYgKElTX1FMQTIxMDAo
aGEpIHx8IElTX1FMQTIyMDAoaGEpKSB7CiAJCXJldHVybiAocWxhMngwMF9zbnNfcm5uX2lkKGhh
KSk7CiAJfQogCkBAIC01OTUsOSArNTk2LDkgQEAKIAlzdHJ1Y3QgY3Rfc25zX3JlcQkqY3RfcmVx
OwogCXN0cnVjdCBjdF9zbnNfcnNwCSpjdF9yc3A7CiAKLQlpZiAoSVNfUUxBMjIwMChoYSkpIHsK
KwlpZiAoSVNfUUxBMjEwMChoYSkgfHwgSVNfUUxBMjIwMChoYSkpIHsKIAkJREVCVUcyKHByaW50
aygic2NzaSglbGQpOiBSU05OX0lEIGNhbGwgdW5zdXBwb3J0ZWQgb24gIgotCQkgICAgIklTUDIy
MDAuXG4iLCBoYS0+aG9zdF9ubykpOworCQkgICAgIklTUDIxMDAvSVNQMjIwMC5cbiIsIGhhLT5o
b3N0X25vKSk7CiAJCXJldHVybiAoUUxBX1NVQ0NFU1MpOwogCX0KIApAQCAtOTk3LDU1ICs5OTgs
NiBAQAogCQlydmFsID0gUUxBX0ZVTkNUSU9OX0ZBSUxFRDsKIAl9IGVsc2UgewogCQlERUJVRzIo
cHJpbnRrKCJzY3NpKCVsZCk6IFJGVF9JRCBleGl0aW5nIG5vcm1hbGx5LlxuIiwKLQkJICAgIGhh
LT5ob3N0X25vKSk7Ci0JfQotCi0JcmV0dXJuIChydmFsKTsKLX0KLQotLyoqCi0gKiBxbGEyeDAw
X3Nuc19yZmZfaWQoKSAtIFNOUyBSZWdpc3RlciBGQy00IEZlYXR1cmVzIChSRkZfSUQpIHN1cHBv
cnRlZCBieSB0aGUKLSAqIEhCQS4KLSAqIEBoYTogSEEgY29udGV4dAotICoKLSAqIFRoaXMgY29t
bWFuZCB1c2VzIHRoZSBvbGQgRXhlY3R1dGUgU05TIENvbW1hbmQgbWFpbGJveCByb3V0aW5lLgot
ICoKLSAqIFJldHVybnMgMCBvbiBzdWNjZXNzLgotICovCi1zdGF0aWMgaW50Ci1xbGEyeDAwX3Nu
c19yZmZfaWQoc2NzaV9xbGFfaG9zdF90ICpoYSkKLXsKLQlpbnQJCXJ2YWw7Ci0KLQlzdHJ1Y3Qg
c25zX2NtZF9wa3QJKnNuc19jbWQ7Ci0KLQkvKiBJc3N1ZSBSRkZfSUQuICovCi0JLyogUHJlcGFy
ZSBTTlMgY29tbWFuZCByZXF1ZXN0LiAqLwotCXNuc19jbWQgPSBxbGEyeDAwX3ByZXBfc25zX2Nt
ZChoYSwgUkZGX0lEX0NNRCwgUkZGX0lEX1NOU19TQ01EX0xFTiwKLQkgICAgUkZGX0lEX1NOU19E
QVRBX1NJWkUpOwotCi0JLyogUHJlcGFyZSBTTlMgY29tbWFuZCBhcmd1bWVudHMgLS0gcG9ydF9p
ZCwgRkMtNCBmZWF0dXJlLCBGQy00IHR5cGUgKi8KLQlzbnNfY21kLT5wLmNtZC5wYXJhbVswXSA9
IGhhLT5kX2lkLmIuYWxfcGE7Ci0Jc25zX2NtZC0+cC5jbWQucGFyYW1bMV0gPSBoYS0+ZF9pZC5i
LmFyZWE7Ci0Jc25zX2NtZC0+cC5jbWQucGFyYW1bMl0gPSBoYS0+ZF9pZC5iLmRvbWFpbjsKLQot
CXNuc19jbWQtPnAuY21kLnBhcmFtWzZdID0gMHgwODsJCQkvKiBTQ1NJIC0gRkNQICovCi0KLQkv
KiBFeGVjdXRlIFNOUyBjb21tYW5kLiAqLwotCXJ2YWwgPSBxbGEyeDAwX3NlbmRfc25zKGhhLCBo
YS0+c25zX2NtZF9kbWEsIFJGRl9JRF9TTlNfQ01EX1NJWkUgLyAyLAotCSAgICBzaXplb2Yoc3Ry
dWN0IHNuc19jbWRfcGt0KSk7Ci0JaWYgKHJ2YWwgIT0gUUxBX1NVQ0NFU1MpIHsKLQkJLypFTVBU
WSovCi0JCURFQlVHMl8zKHByaW50aygic2NzaSglbGQpOiBSRkZfSUQgU2VuZCBTTlMgZmFpbGVk
ICglZCkuXG4iLAotCQkgICAgaGEtPmhvc3Rfbm8sIHJ2YWwpKTsKLQl9IGVsc2UgaWYgKHNuc19j
bWQtPnAucmZmX2RhdGFbOF0gIT0gMHg4MCB8fAotCSAgICBzbnNfY21kLT5wLnJmZl9kYXRhWzld
ICE9IDB4MDIpIHsKLQkJREVCVUcyXzMocHJpbnRrKCJzY3NpKCVsZCk6IFJGRl9JRCBmYWlsZWQs
IHJlamVjdGVkIHJlcXVlc3QsICIKLQkJICAgICJyZmZfcnNwOlxuIiwgaGEtPmhvc3Rfbm8pKTsK
LQkJREVCVUcyXzMocWxhMngwMF9kdW1wX2J1ZmZlcihzbnNfY21kLT5wLnJmZl9kYXRhLCAxNikp
OwotCQlydmFsID0gUUxBX0ZVTkNUSU9OX0ZBSUxFRDsKLQl9IGVsc2UgewotCQlERUJVRzIocHJp
bnRrKCJzY3NpKCVsZCk6IFJGRl9JRCBleGl0aW5nIG5vcm1hbGx5LlxuIiwKIAkJICAgIGhhLT5o
b3N0X25vKSk7CiAJfQogCj09PT09IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgMS4x
OSB2cyBlZGl0ZWQgPT09PT0KLS0tIDEuMTkvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQu
YwlNb24gTWF5ICAzIDA4OjE2OjM0IDIwMDQKKysrIGVkaXRlZC9kcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfaW5pdC5jCU1vbiBNYXkgMTAgMTQ6MDc6NTUgMjAwNApAQCAtMTAyMiwxMCArMTAyMiw2
IEBACiAKIAloYS0+bG9vcF9pZCA9IGxvb3BfaWQ7CiAKLQkvKiBNYWtlIHN1cmUgMjEwMCBvbmx5
IGhhcyBsb29wLCBpbiBjYXNlIG9mIGFueSBmaXJtd2FyZSBidWcuICovCi0JaWYgKElTX1FMQTIx
MDAoaGEpKQotCQl0b3BvID0gMDsKLQogCS8qIGluaXRpYWxpemUgKi8KIAloYS0+bWluX2V4dGVy
bmFsX2xvb3BpZCA9IFNOU19GSVJTVF9MT09QX0lEOwogCWhhLT5vcGVyYXRpbmdfbW9kZSA9IExP
T1A7Cj09PT09IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jIDEuMjQgdnMgZWRpdGVkID09
PT09Ci0tLSAxLjI0L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jCU1vbiBNYXkgIDMgMDg6
MTY6MzQgMjAwNAorKysgZWRpdGVkL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jCU1vbiBN
YXkgMTAgMTQ6MDc6NTYgMjAwNApAQCAtMjkzMCw3ICsyOTMwLDcgQEAKIAkJfQogCiAJCS8qIEFs
bG9jYXRlIG1lbW9yeSBmb3IgU05TIGNvbW1hbmRzICovCi0JCWlmIChJU19RTEEyMjAwKGhhKSkg
eworCQlpZiAoSVNfUUxBMjEwMChoYSkgfHwgSVNfUUxBMjIwMChoYSkpIHsKIAkJCS8qIEdldCBj
b25zaXN0ZW50IG1lbW9yeSBhbGxvY2F0ZWQgZm9yIFNOUyBjb21tYW5kcyAqLwogCQkJaGEtPnNu
c19jbWQgPSBwY2lfYWxsb2NfY29uc2lzdGVudChoYS0+cGRldiwKIAkJCSAgICBzaXplb2Yoc3Ry
dWN0IHNuc19jbWRfcGt0KSwgJmhhLT5zbnNfY21kX2RtYSk7CkBAIC0yOTQ2LDcgKzI5NDYsNyBA
QAogCQkJCWNvbnRpbnVlOwogCQkJfQogCQkJbWVtc2V0KGhhLT5zbnNfY21kLCAwLCBzaXplb2Yo
c3RydWN0IHNuc19jbWRfcGt0KSk7Ci0JCX0gZWxzZSBpZiAoIUlTX1FMQTIxMDAoaGEpKSB7CisJ
CX0gZWxzZSB7CiAJCQkvKiBHZXQgY29uc2lzdGVudCBtZW1vcnkgYWxsb2NhdGVkIGZvciBNUyBJ
T0NCICovCiAJCQloYS0+bXNfaW9jYiA9IHBjaV9hbGxvY19jb25zaXN0ZW50KGhhLT5wZGV2LAog
CQkJICAgIHNpemVvZihtc19pb2NiX2VudHJ5X3QpLCAmaGEtPm1zX2lvY2JfZG1hKTsK

------_=_NextPart_001_01C436D7.1E064554--
