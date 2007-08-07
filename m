From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: default timeout for arrays too short
Date: Tue, 7 Aug 2007 15:36:18 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB811F@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB79D7@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7D92A.39E7544F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:57892 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbXHGTg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 15:36:27 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 61DB818FBAE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Aug 2007 12:36:26 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB79D7@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7D92A.39E7544F
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The default SCSI timeout is 30 seconds for a logical device. The aacraid
based controllers currently have a 35 second timeout for the array. We
are bumping up the default SCSI timeout for array devices, which
typically manage many physical disks, to 45 seconds to provide a small
margin to permit the controller to do what it is designed for. We have
not observed any bad side-effects either way because no significant
actions are taken by the aacraid timeout handler except to take
advantage of the quiesced state to allow completion of all outstanding
commands in the controller to provide a poor-mans guaranty of delivery.
This is merely a preferential decision to reduce the number of timeout
reports in the system logs to only the more serious conditions.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |    6 ++++++
 1 file changed, 6 insertions(+)

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7D92A.39E7544F
Content-Type: application/octet-stream;
	name="aacraid_array_timeout_too_short.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_array_timeout_too_short.patch
Content-Disposition: attachment;
	filename="aacraid_array_timeout_too_short.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMDgt
MDcgMTQ6NTA6NDIuMDg3NDM5NzMyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0wOC0wNyAxNDo1NTo1NC45NzM1MzAzMDAgLTA0MDAKQEAgLTQyMCw2ICs0MjAs
MTIgQEAKIAkJdW5zaWduZWQgbnVtX29uZSA9IDA7CiAJCXVuc2lnbmVkIGRlcHRoOwogCisJCS8q
CisJCSAqIEZpcm13YXJlIGhhcyBhbiBpbmRpdmlkdWFsIGRldmljZSByZWNvdmVyeSB0aW1lIHR5
cGljYWxseQorCQkgKiBvZiAzNSBzZWNvbmRzLCBnaXZlIHVzIGEgbWFyZ2luLgorCQkgKi8KKwkJ
aWYgKHNkZXYtPnRpbWVvdXQgPCAoNDUgKiBIWikpCisJCQlzZGV2LT50aW1lb3V0ID0gNDUgKiBI
WjsKIAkJX19zaG9zdF9mb3JfZWFjaF9kZXZpY2UoZGV2LCBob3N0KSB7CiAJCQlpZiAoZGV2LT50
YWdnZWRfc3VwcG9ydGVkICYmIChkZXYtPnR5cGUgPT0gVFlQRV9ESVNLKSAmJgogCQkJCShzZGV2
X2NoYW5uZWwoZGV2KSA9PSBDT05UQUlORVJfQ0hBTk5FTCkpCg==

------_=_NextPart_001_01C7D92A.39E7544F--
