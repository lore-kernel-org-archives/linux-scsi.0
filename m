From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: thread stop patch
Date: Wed, 31 Oct 2007 16:40:37 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F9584B@otce2k301.adaptec.com>
References: <bug-9133-10286@http.bugzilla.kernel.org/><20071008104741.5a0ecebf.akpm@linux-foundation.org><AE4F746F2AECFC4DA4AADD66A1DFEF01EE6699@otce2k301.adaptec.com> <20071008153027.10fd15df.akpm@linux-foundation.org>  <AE4F746F2AECFC4DA4AADD66A1DFEF01F95601@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C81BFE.4B3914F6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:39691 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbXJaUki (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 16:40:38 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 42EF5218246
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2007 13:40:38 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95601@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C81BFE.4B3914F6
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Got a panic in the threading code on an older kernel when the Adapter
failed to load properly and driver shut down apparently before any
threading had started, can not dupe. Expect that this may be relevant in
the latest kernel, but not sure. This patch does no harm, and should
alleviate the possibility of this panic.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments (inline gets damaged, use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2007-10-31 16:32:10.394394185
-0400
+++ b/drivers/scsi/aacraid/linit.c	2007-10-31 16:32:17.740458222
-0400
@@ -959,7 +959,8 @@
=20
 static void __aac_shutdown(struct aac_dev * aac)
 {
-	kthread_stop(aac->thread);
+	if (aac->aif_thread)
+		kthread_stop(aac->thread);
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
 	free_irq(aac->pdev->irq, aac);

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C81BFE.4B3914F6
Content-Type: application/octet-stream;
	name="aacraid_thread_stop.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_thread_stop.patch
Content-Disposition: attachment;
	filename="aacraid_thread_stop.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMTAt
MzEgMTY6MzI6MTAuMzk0Mzk0MTg1IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0xMC0zMSAxNjozMjoxNy43NDA0NTgyMjIgLTA0MDAKQEAgLTk1OSw3ICs5NTks
OCBAQAogCiBzdGF0aWMgdm9pZCBfX2FhY19zaHV0ZG93bihzdHJ1Y3QgYWFjX2RldiAqIGFhYykK
IHsKLQlrdGhyZWFkX3N0b3AoYWFjLT50aHJlYWQpOworCWlmIChhYWMtPmFpZl90aHJlYWQpCisJ
CWt0aHJlYWRfc3RvcChhYWMtPnRocmVhZCk7CiAJYWFjX3NlbmRfc2h1dGRvd24oYWFjKTsKIAlh
YWNfYWRhcHRlcl9kaXNhYmxlX2ludChhYWMpOwogCWZyZWVfaXJxKGFhYy0+cGRldi0+aXJxLCBh
YWMpOwo=

------_=_NextPart_001_01C81BFE.4B3914F6--
