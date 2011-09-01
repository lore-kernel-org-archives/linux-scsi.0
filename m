From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: [PATCH] [SCSI]: libsas failure to revalidate domain for anything but the first expander child.
Date: Thu, 1 Sep 2011 06:11:17 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CC68A8.A2E2691A"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:42054 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757191Ab1IANOC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2011 09:14:02 -0400
Content-class: urn:content-classes:message
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <ltuikov@yahoo.com>, Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC68A8.A2E2691A
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In an enclosure model where there are chaining expanders to a large body
of storage, it was discovered that libsas, responding to a broadcast
event change, would only revalidate the domain of first child expander
in the list.

The issue is that the pointer value to the discovered source device was
used to break out of the loop, rather than the content of the pointer.

This still remains non-compliant as the revalidate domain code is
supposed to loop through all child expanders, and not stop at the first
one it finds that reports a change count. However, the design of this
routine does not allow multiple device discoveries and that would be a
more complicated set of patches reserved for another day. We are fixing
the glaring bug rather than refactoring the code.

Please note, as I am *stuck* on Outlook as per company policy, the
following inline content will likely not patch clean even emailed as
'Plain Text', the enclosed attached file should do the job. I have Cc'd
all the folks that originated the files in libsas, as there was no
listed MAINTAINERs.

Checkpatch.pl reports clean. Patch applies cleanly to a WIDE variety of
kernels up to latest.

Sincerely -- Mark Salyzyn

Cc: Luben Tuikov <tuikov@yahoo.com>
Cc: Darrick J Wong <djwong@us.ibm.com>
Cc: James Bottomley <jbottomley@parallels.com>

Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>

 sas_expander.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
--- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c	2011-08-31
08:32:21.000000000 -0400
+++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
2011-09-01 08:57:55.000000000 -0400
@@ -1721,7 +1721,7 @@
 	list_for_each_entry(ch, &ex->children, siblings) {
 		if (ch->dev_type =3D=3D EDGE_DEV || ch->dev_type =3D=3D
FANOUT_DEV) {
 			res =3D sas_find_bcast_dev(ch, src_dev);
-			if (src_dev)
+			if (*src_dev)
 				return res;
 		}
 	}

______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D
------_=_NextPart_001_01CC68A8.A2E2691A
Content-Type: application/octet-stream;
	name="expander_bug.patch"
Content-Transfer-Encoding: base64
Content-Description: expander_bug.patch
Content-Disposition: attachment;
	filename="expander_bug.patch"

Q2M6IEx1YmVuIFR1aWtvdiA8dHVpa292QHlhaG9vLmNvbT4KQ2M6IERhcnJpY2sgSiBXb25nIDxk
andvbmdAdXMuaWJtLmNvbT4KQ2M6IEphbWVzIEJvdHRvbWxleSA8amJvdHRvbWxleUBwYXJhbGxl
bHMuY29tPgoKU2lnbmVkLW9mZi1ieTogTWFyayBTYWx5enluIDxtc2FseXp5bkB1cy54eXJhdGV4
LmNvbT4KCiBzYXNfZXhwYW5kZXIuYyB8ICAgIDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtcnUgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbGlic2FzL3Nhc19leHBhbmRlci5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9s
aWJzYXMvc2FzX2V4cGFuZGVyLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL2xpYnNh
cy9zYXNfZXhwYW5kZXIuYwkyMDExLTA4LTMxIDA4OjMyOjIxLjAwMDAwMDAwMCAtMDQwMAorKysg
c2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYwkyMDEx
LTA5LTAxIDA4OjU3OjU1LjAwMDAwMDAwMCAtMDQwMApAQCAtMTcyMSw3ICsxNzIxLDcgQEAKIAls
aXN0X2Zvcl9lYWNoX2VudHJ5KGNoLCAmZXgtPmNoaWxkcmVuLCBzaWJsaW5ncykgewogCQlpZiAo
Y2gtPmRldl90eXBlID09IEVER0VfREVWIHx8IGNoLT5kZXZfdHlwZSA9PSBGQU5PVVRfREVWKSB7
CiAJCQlyZXMgPSBzYXNfZmluZF9iY2FzdF9kZXYoY2gsIHNyY19kZXYpOwotCQkJaWYgKHNyY19k
ZXYpCisJCQlpZiAoKnNyY19kZXYpCiAJCQkJcmV0dXJuIHJlczsKIAkJfQogCX0K

------_=_NextPart_001_01CC68A8.A2E2691A--
