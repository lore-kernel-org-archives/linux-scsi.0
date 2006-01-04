From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] scsi_transport_sas.c - mapping the rphy channel equal to the port identifier
Date: Wed, 4 Jan 2006 14:58:40 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F15386F@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C6117A.0612B3A3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42909 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030257AbWADV6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 16:58:48 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6117A.0612B3A3
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

The sas transport current implementation is mapping
the channel number for each sas/sata device equal to
the phy number.  The problem with that is it will be difficult
to reserve a channel for RAID volumes when hot swap support
is eventually implemented in the sas transport layer.
Thus my suggested change is to map the channel to the port=20
identifier, which effectively maps each channel number to its own
unique sas domain.  Thus we can map the RAID volumes to a reserved
channel that
is one larger than the anticapated number of ports on the direct
attached host
adapter.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C6117A.0612B3A3
Content-Type: application/octet-stream;
	name="scsi_transport_sas.patch"
Content-Transfer-Encoding: base64
Content-Description: scsi_transport_sas.patch
Content-Disposition: attachment;
	filename="scsi_transport_sas.patch"

LS0tIGIvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X3Nhcy5jCTIwMDYtMDEtMDQgMTE6MTM6
NDYuMDAwMDAwMDAwIC0wNzAwCisrKyBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zYXMu
YwkyMDA2LTAxLTA0IDEyOjQxOjEyLjAwMDAwMDAwMCAtMDcwMApAQCAtNjM3LDcgKzYzNyw3IEBA
CiAJc3Bpbl91bmxvY2soJnNhc19ob3N0LT5sb2NrKTsKIAogCWlmIChycGh5LT5zY3NpX3Rhcmdl
dF9pZCAhPSAtMSkgewotCQlzY3NpX3NjYW5fdGFyZ2V0KCZycGh5LT5kZXYsIHBhcmVudC0+bnVt
YmVyLAorCQlzY3NpX3NjYW5fdGFyZ2V0KCZycGh5LT5kZXYsIHBhcmVudC0+cG9ydF9pZGVudGlm
aWVyLAogCQkJCXJwaHktPnNjc2lfdGFyZ2V0X2lkLCB+MCwgMCk7CiAJfQogCkBAIC03MzksNyAr
NzM5LDcgQEAKIAlzcGluX2xvY2soJnNhc19ob3N0LT5sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KHJwaHksICZzYXNfaG9zdC0+cnBoeV9saXN0LCBsaXN0KSB7CiAJCXN0cnVjdCBzYXNfcGh5
ICpwYXJlbnQgPSBkZXZfdG9fcGh5KHJwaHktPmRldi5wYXJlbnQpOwotCQlpZiAocGFyZW50LT5u
dW1iZXIgPT0gY2hhbm5lbCAmJgorCQlpZiAocGFyZW50LT5wb3J0X2lkZW50aWZpZXIgPT0gY2hh
bm5lbCAmJgogCQkgICAgcnBoeS0+c2NzaV90YXJnZXRfaWQgPT0gaWQpCiAJCQlkZXYgPSAmcnBo
eS0+ZGV2OwogCX0K

------_=_NextPart_001_01C6117A.0612B3A3--
