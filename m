From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: prevent panic on adapter resource failure
Date: Thu, 2 Aug 2007 15:38:59 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB79D7@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B438@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7D53C.C5B5754D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52221 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088AbXHBTjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 15:39:04 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 41A3B1AA5AD
	for <linux-scsi@vger.kernel.org>; Thu,  2 Aug 2007 12:39:03 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B438@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7D53C.C5B5754D
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

If the driver fails to allocate the contiguous (DMAable) memory for
system reasons, we fail to load the instance, but then we try to free
the <nul> allocation in the cleanup code and we get a panic in
pci_free_consistent(). This is reported against an older kernel, hope
this is relevant for latest/greatest.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7D53C.C5B5754D
Content-Type: application/octet-stream;
	name="aacraid_fail_to_load_panic.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_fail_to_load_panic.patch
Content-Disposition: attachment;
	filename="aacraid_fail_to_load_panic.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMDgt
MDIgMTU6MzA6MzUuNDg5MjE1NjcxIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0wOC0wMiAxNTozMDo0MS41Njc0MTUzMTUgLTA0MDAKQEAgLTExMTAsNyArMTEx
MCw5IEBACiAJX19hYWNfc2h1dGRvd24oYWFjKTsKICBvdXRfdW5tYXA6CiAJYWFjX2ZpYl9tYXBf
ZnJlZShhYWMpOwotCXBjaV9mcmVlX2NvbnNpc3RlbnQoYWFjLT5wZGV2LCBhYWMtPmNvbW1fc2l6
ZSwgYWFjLT5jb21tX2FkZHIsIGFhYy0+Y29tbV9waHlzKTsKKwlpZiAoYWFjLT5jb21tX2FkZHIp
CisJCXBjaV9mcmVlX2NvbnNpc3RlbnQoYWFjLT5wZGV2LCBhYWMtPmNvbW1fc2l6ZSwgYWFjLT5j
b21tX2FkZHIsCisJCSAgYWFjLT5jb21tX3BoeXMpOwogCWtmcmVlKGFhYy0+cXVldWVzKTsKIAlh
YWNfYWRhcHRlcl9pb3JlbWFwKGFhYywgMCk7CiAJa2ZyZWUoYWFjLT5maWJzKTsK

------_=_NextPart_001_01C7D53C.C5B5754D--
