From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid changes for 2.4.24 kernel to ride through SCSI hang ?
Date: Fri, 13 Feb 2004 13:56:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F25528E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C3F263.1D771F2D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:43920 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267194AbUBMS4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 13:56:43 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i1DIugJ14978
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2004 10:56:42 -0800
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i1DIug809211
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2004 10:56:42 -0800
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C3F263.1D771F2D
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch allows the system to ride through an Adapter that is
temporarily reticent to commands.

The cause of this reticence is usually a combination of a Fast Host
Processors loading up the adapter full with commands and a less than
perfect SCSI cable or drive triggering an Adapter Cache Flush operation.
Some Adapters with large cache configuration have been clocked as being
unresponsive for more than 90 seconds.

When the SCSI subsystem times out and asks for the Adapter to be reset,
we wait a minute longer for the Adapter to complete all outstanding
commands before giving up and returning to the SCSI layers recovery
code. Without this delay, the first test unit ready issued to the device
times out and the device is taken offline; usually resulting in a panic
of the filesystem driver.

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C3F263.1D771F2D
Content-Type: application/octet-stream;
	name="aac_eh_reset.patch"
Content-Transfer-Encoding: base64
Content-Description: aac_eh_reset.patch
Content-Disposition: attachment;
	filename="aac_eh_reset.patch"

ZGlmZiAtdSAtUCAtLXJlY3Vyc2l2ZSBsaW51eC0yLjQuMjQuZ2VuZXJpYy9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9saW5pdC5jIGxpbnV4LTIuNC4yNC0yMzIyL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMKLS0tIGxpbnV4LTIuNC4yNC5nZW5lcmljL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0
LmMJTW9uIE9jdCAyMCAxMDo0MzoyNiAyMDAzCisrKyBsaW51eC0yLjQuMjQtMjMyMi9kcml2ZXJz
L3Njc2kvYWFjcmFpZC9saW5pdC5jCVdlZCBGZWIgIDQgMTI6NTQ6MDEgMjAwNApAQCAtNjEwLDgg
KzcyNSwzNSBAQAogCiBzdGF0aWMgaW50IGFhY19laF9yZXNldChTY3NpX0NtbmQqIGNtZCkKIHsK
KwlTY3NpX0RldmljZSAqIGRldiA9IGNtZC0+ZGV2aWNlOworCXN0cnVjdCBTY3NpX0hvc3QgKiBo
b3N0ID0gZGV2LT5ob3N0OworCVNjc2lfQ21uZCAqIGNvbW1hbmQ7CisJaW50IGNvdW50OworCiAJ
cHJpbnRrKEtFUk5fRVJSICIlczogSG9zdCBhZGFwdGVyIHJlc2V0IHJlcXVlc3QuIFNDU0kgaGFu
ZyA/XG4iLCBBQUNfRFJJVkVSX05BTUUpOwotCXJldHVybiBGQUlMRUQ7CisKKwkvKgorCSAqIFdh
aXQgZm9yIGFsbCBjb21tYW5kcyB0byBjb21wbGV0ZSB0byB0aGlzIHNwZWNpZmljCisJICogdGFy
Z2V0IChibG9jayBtYXhpbXVtIDYwIHNlY29uZHMpLgorCSAqLworCWZvciAoY291bnQgPSA2MDsg
Y291bnQ7IC0tY291bnQpIHsKKwkJaW50IGFjdGl2ZSA9IDA7CisJCWZvciAoZGV2ID0gaG9zdC0+
aG9zdF9xdWV1ZTsgZGV2ICE9IChTY3NpX0RldmljZSAqKU5VTEw7IGRldiA9IGRldi0+bmV4dCkg
eworCQkJZm9yKGNvbW1hbmQgPSBkZXYtPmRldmljZV9xdWV1ZTsgY29tbWFuZDsgY29tbWFuZCA9
IGNvbW1hbmQtPm5leHQpIHsKKwkJCQlpZiAoY29tbWFuZC0+c2VyaWFsX251bWJlcikgeworCQkJ
CQkrK2FjdGl2ZTsKKwkJCQkJYnJlYWs7CisJCQkJfQorCQkJfQorCQl9CisJCWlmIChhY3RpdmUg
PT0gMCkKKwkJCXJldHVybiBTVUNDRVNTOworCQlzcGluX3VubG9ja19pcnEoJmlvX3JlcXVlc3Rf
bG9jayk7CisJCXNjc2lfc2xlZXAoSFopOworCQlzcGluX2xvY2tfaXJxKCZpb19yZXF1ZXN0X2xv
Y2spOworCX0KKwlwcmludGsoS0VSTl9FUlIgIiVzOiBTQ1NJIGJ1cyBhcHBlYXJzIGh1bmdcbiIs
IEFBQ19EUklWRVJfTkFNRSk7CisJcmV0dXJuIC1FVElNRURPVVQ7CiB9CiAKIC8qKgo=

------_=_NextPart_001_01C3F263.1D771F2D--
