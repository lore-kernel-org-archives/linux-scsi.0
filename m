From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Mon, 19 Jan 2004 08:55:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E3F@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C3DEAC.FE8204E2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:42382 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265376AbUASQyw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 11:54:52 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C3DEAC.FE8204E2
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday, January 19, 2004 12:25 AM, Michael W. Shaffer wrote:
> Well, I got through step 1 ok, enabling the debug options in
> the source files you mentioned in the plain 2.6.1-mm4 source
> and retesting.

I should have picked up on this from my work on Friday when I=20
noticed this ommision when creating the resync-b9 patch. =20

The problem is during the removal of the failover and IOCTL code
from the scsi-qla2xxx-2.6 tree, one critical piece of code
(a one-liner) was inadvertently removed that effectively disables
the drivers ability to bind fcports (devices found in the loop
or fabric) to the SCSI nexus (h/b/t/l).

Here's the patch inlined (I'll also attach just in case) against
a vanilla 2.6.1-mm4 tree:

--- linux-2.6.1-mm4/drivers/scsi/qla2xxx/qla_init.c.orig	2004-01-19 =
08:23:46.924323032 -0800
+++ linux-2.6.1-mm4/drivers/scsi/qla2xxx/qla_init.c	2004-01-19 =
08:24:48.860907240 -0800
@@ -1592,6 +1592,8 @@
 	if (!atomic_read(&ha->loop_down_timer) &&
 	    !(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))) {
=20
+		qla2x00_config_os(ha);
+
 		/* If we found all devices then go ready */
 		if (!(test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags))) {
 			atomic_set(&ha->loop_state, LOOP_READY);

This fix is already in the resync-b9 codes. =20

Regards,
Andrew Vasquez

------_=_NextPart_001_01C3DEAC.FE8204E2
Content-Type: application/octet-stream;
	name="bind_fcports-v8.00.00b8-mm4.diff"
Content-Transfer-Encoding: base64
Content-Description: bind_fcports-v8.00.00b8-mm4.diff
Content-Disposition: attachment;
	filename="bind_fcports-v8.00.00b8-mm4.diff"

LS0tIGxpbnV4LTIuNi4xLW1tNC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jLm9yaWcJ
MjAwNC0wMS0xOSAwODoyMzo0Ni45MjQzMjMwMzIgLTA4MDAKKysrIGxpbnV4LTIuNi4xLW1tNC9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jCTIwMDQtMDEtMTkgMDg6MjQ6NDguODYwOTA3
MjQwIC0wODAwCkBAIC0xNTkyLDYgKzE1OTIsOCBAQAogCWlmICghYXRvbWljX3JlYWQoJmhhLT5s
b29wX2Rvd25fdGltZXIpICYmCiAJICAgICEodGVzdF9iaXQoTE9PUF9SRVNZTkNfTkVFREVELCAm
aGEtPmRwY19mbGFncykpKSB7CiAKKwkJcWxhMngwMF9jb25maWdfb3MoaGEpOworCiAJCS8qIElm
IHdlIGZvdW5kIGFsbCBkZXZpY2VzIHRoZW4gZ28gcmVhZHkgKi8KIAkJaWYgKCEodGVzdF9iaXQo
TE9HSU5fUkVUUllfTkVFREVELCAmaGEtPmRwY19mbGFncykpKSB7CiAJCQlhdG9taWNfc2V0KCZo
YS0+bG9vcF9zdGF0ZSwgTE9PUF9SRUFEWSk7Cg==

------_=_NextPart_001_01C3DEAC.FE8204E2--
