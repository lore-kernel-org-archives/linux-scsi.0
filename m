From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: fix print of Firmware Build Date and add TSID
Date: Wed, 28 Mar 2007 13:44:54 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9B09@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9A05@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C77160.CB8057DF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:57819 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXC1Ro4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 13:44:56 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 68B641B789C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 10:44:55 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9A05@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C77160.CB8057DF
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The Adapter build date that is to be printed on instantiation was not
displayed as a result of the supplemental adapter information structure
not being in sync with the Firmware; the driver took an early test cycle
version that had a miss-sized padded region at the head and the
structure was not re-checked at the end of qualification. The Build Date
was not a priority and is merely a cosmetic enhancement, and the wrong
location for the start of the structure member would not induce any
side-effect problems. We updated the structure to match the actual
format, and added the TSID (Tech Support Identification) value print,
should it be present, to the adapter instantiation announcements during
driver load.

This later enhancement should improve the relationship between Service
folk & Tech Support if the printed value of the TSID found it's way into
the circular file labeled G...

Neither of these values show in sysfs (yet).

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patches.

This attached patch is against current scsi-misc-2.6
=20
Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

------_=_NextPart_001_01C77160.CB8057DF
Content-Type: application/octet-stream;
	name="aacraid_build_date_tsid.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_build_date_tsid.patch
Content-Disposition: attachment;
	filename="aacraid_build_date_tsid.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDMtMjggMDk6MjM6MzcuOTkwNzQ1NDM3IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDMtMjggMTM6MjY6MTAuMDM2Mzc3NTI4IC0wNDAwCkBAIC0xMTk0LDYg
KzExOTQsMTIgQEAKIAkJCXByaW50ayhLRVJOX0lORk8gIiVzJWQ6IHNlcmlhbCAleFxuIiwKIAkJ
CQlkZXYtPm5hbWUsIGRldi0+aWQsCiAJCQkJbGUzMl90b19jcHUoZGV2LT5hZGFwdGVyX2luZm8u
c2VyaWFsWzBdKSk7CisJCWlmIChkZXYtPnN1cHBsZW1lbnRfYWRhcHRlcl9pbmZvLlZwZEluZm8u
VHNpZFswXSkgeworCQkJcHJpbnRrKEtFUk5fSU5GTyAiJXMlZDogVFNJRCAlLipzXG4iLAorCQkJ
ICBkZXYtPm5hbWUsIGRldi0+aWQsCisJCQkgIChpbnQpc2l6ZW9mKGRldi0+c3VwcGxlbWVudF9h
ZGFwdGVyX2luZm8uVnBkSW5mby5Uc2lkKSwKKwkJCSAgZGV2LT5zdXBwbGVtZW50X2FkYXB0ZXJf
aW5mby5WcGRJbmZvLlRzaWQpOworCQl9CiAJfQogCiAJZGV2LT5ub25kYXNkX3N1cHBvcnQgPSAw
OwpkaWZmIC1ydSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaCBiL2RyaXZlcnMvc2Nz
aS9hYWNyYWlkL2FhY3JhaWQuaAotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmgJ
MjAwNy0wMy0yOCAwOToyMzozNy45OTE3NDUzMTAgLTA0MDAKKysrIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvYWFjcmFpZC5oCTIwMDctMDMtMjggMTM6MjY6MTAuMDYxMzc0Mzc0IC0wNDAwCkBAIC04
NDMsMTAgKzg0MywyNSBAQAogCV9fbGUzMglWZXJzaW9uOwogCV9fbGUzMglGZWF0dXJlQml0czsK
IAl1OAlTbG90TnVtYmVyOwotCXU4CVJlc2VydmVkUGFkMFswXTsKKwl1OAlSZXNlcnZlZFBhZDBb
M107CiAJdTgJQnVpbGREYXRlWzEyXTsKIAlfX2xlMzIJQ3VycmVudE51bWJlclBvcnRzOwotCV9f
bGUzMglSZXNlcnZlZEdyb3d0aFsyNF07CisJc3RydWN0IHsKKwkJdTgJQXNzZW1ibHlQbls4XTsK
KwkJdTgJRnJ1UG5bOF07CisJCXU4CUJhdHRlcnlGcnVQbls4XTsKKwkJdTgJRWNWZXJzaW9uU3Ry
aW5nWzhdOworCQl1OAlUc2lkWzEyXTsKKwl9CVZwZEluZm87CisJX19sZTMyCUZsYXNoRmlybXdh
cmVSZXZpc2lvbjsKKwlfX2xlMzIJRmxhc2hGaXJtd2FyZUJ1aWxkOworCV9fbGUzMglSYWlkVHlw
ZU1vcnBoT3B0aW9uczsKKwlfX2xlMzIJRmxhc2hGaXJtd2FyZUJvb3RSZXZpc2lvbjsKKwlfX2xl
MzIJRmxhc2hGaXJtd2FyZUJvb3RCdWlsZDsKKwl1OAlNZmdQY2JhU2VyaWFsTm9bMTJdOworCXU4
CU1mZ1dXTk5hbWVbOF07CisJX19sZTMyCU1vcmVGZWF0dXJlQml0czsKKwlfX2xlMzIJUmVzZXJ2
ZWRHcm93dGhbMV07CiB9OwogI2RlZmluZSBBQUNfRkVBVFVSRV9GQUxDT04JMHgwMDAwMDAxMAog
I2RlZmluZSBBQUNfU0lTX1ZFUlNJT05fVjMJMwo=

------_=_NextPart_001_01C77160.CB8057DF--
