From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: fix Sunrise Lake reset handling
Date: Fri, 27 Jul 2007 10:29:26 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B438@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B28D@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7D05A.88F2AF67"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:54673 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760952AbXG0O36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:29:58 -0400
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B28D@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@in.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7D05A.88F2AF67
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The patch is *much* smaller than the description. I am attempting to
answer to those that want to understand an issue that was reported in
May this year.

If a Sunrise Lake based card that requires an alternate reset mechanism
is set up to ignore the commanded IOP_RESET it reports 0x00000010
(IOP_RESET ignored) instead of 0x3803000F (use alternate reset mechanism
to reset all cores), and thus the reset platform function decides to
switch to IOP_RESET_ALWAYS because the reset platform function
parameters indicate that we *need* to reset the card. IOP_RESET_ALWAYS
then responds with the 0x3803000F return code, but alas we treat this as
an error instead of using the alternate reset mechanism (put a 0x03 into
the register offset 0x38). The reset fails, but the fact that the
IOP_RESET_ALWAYS command was issued has put the card in a purposeful
shutdown state in preparation for the alternate hardware reset to be
applied. Yuck.

IOP_RESET is ignored in internal production cards, typically to ensure
that we catch all adapter lockup issues without the driver progressing
further, so this would not appear to be a field issue and thus this
patch was destined to be only in the internal Adaptec source tree.
IOP_RESET_ALWAYS is reserved for
kexec/kdump/FirmwareUpdate/AutomatedTestFrames so we did not function as
expected in any case. Also in the past we have had OEMs specifically
request that cards not be resetable after a BlinkLED/FirmwareAssert for
one reason or another and To head off the possibility that the Sunrise
Lake based cards would suffer a similar fate, we propose the enclosed
fix.

Yinghai Lu of SUN had a pre-production card with IOP_RESET disabled when
he reported an issue to the linux kernel list back in May regarding a
kexec problem resulting from this reset being ignore. His fix was to
update the Firmware to one that did not ignore the IOP_RESET. Previous
kernels did not attempt to reset the adapter and that is why it surfaced
as a regression in his hands.

The current list of aacraid based cards that use Sunrise Lake:

9005:0285:9005:02b5     Adaptec 5445
9005:0285:9005:02b6     Adaptec 5805
9005:0285:9005:02b7     Adaptec 5085
9005:0285:9005:02c3     Adaptec 51205
9005:0285:9005:02c4     Adaptec 51605
9005:0285:9005:02ce     Adaptec 51245
9005:0285:9005:02cf     Adaptec 51645
9005:0285:9005:02d0     Adaptec 52445
9005:0285:9005:02d1     Adaptec 5405
9005:0285:9005:02b8     ICP     ICP5445SL
9005:0285:9005:02b9     ICP     ICP5085SL
9005:0285:9005:02ba     ICP     ICP5805SL
9005:0285:9005:02c5     ICP     ICP5125SL
9005:0285:9005:02c6     ICP     ICP5165SL
9005:0285:108e:7aac     SUN     STK RAID REM
9005:0285:108e:0286     SUN     STK RAID INT
9005:0285:108e:0287     SUN     STK RAID EXT
9005:0285:108e:7aae     SUN     STK RAID EM

All of these are publicly released with IOP_RESET enabled. So there is
no immediate need for this patch.

This attached patch is against July 11 2007 scsi-misc-2.6, still applies
today.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 /drivers/scsi/aacraid/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Yinghai Lu [mailto:yhlu.kernel@gmail.com]=20
Sent: Tuesday, May 29, 2007 10:00 PM
To: Andrew Morton; Vivek Goyal; Eric W. Biederman; AACRAID
Cc: Linux Kernel Mailing List
Subject: kexec and aacraid broken

latest tree, can not use kexec to load 2.6.22-rc3 at least.

got:

AAC0: adapter kernel panic'd fffffffd
AAC0: adapter kernel failed to start, init status=3D0

but can load 2.6.21.3

YH

------_=_NextPart_001_01C7D05A.88F2AF67
Content-Type: application/octet-stream;
	name="aacraid_voodoo_reset.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_voodoo_reset.patch
Content-Disposition: attachment;
	filename="aacraid_voodoo_reset.patch"

ZGlmZiAtcnUgYS8vZHJpdmVycy9zY3NpL2FhY3JhaWQvcnguYyBiLy9kcml2ZXJzL3Njc2kvYWFj
cmFpZC9yeC5jCi0tLSBhLy9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDctMTEgMTE6
MjY6MjUuMDkxMDY2NzYxIC0wNDAwCisrKyBiLy9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIw
MDctMDctMTEgMTE6Mjg6MzEuOTYxODU5NDk2IC0wNDAwCkBAIC00NzIsNyArNDcyLDcgQEAKIAkJ
ZWxzZSB7CiAJCQlibGVkID0gYWFjX2FkYXB0ZXJfc3luY19jbWQoZGV2LCBJT1BfUkVTRVRfQUxX
QVlTLAogCQkJICAwLCAwLCAwLCAwLCAwLCAwLCAmdmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxM
KTsKLQkJCWlmICghYmxlZCAmJiAodmFyICE9IDB4MDAwMDAwMDEpKQorCQkJaWYgKCFibGVkICYm
ICh2YXIgIT0gMHgwMDAwMDAwMSkgJiYgKHZhciAhPSAweDM4MDMwMDBGKSkKIAkJCQlibGVkID0g
LUVJTlZBTDsKIAkJfQogCQlpZiAoYmxlZCAmJiAoYmxlZCAhPSAtRVRJTUVET1VUKSkK

------_=_NextPart_001_01C7D05A.88F2AF67--
