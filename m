From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 13:05:23 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684DCF@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8887 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751126AbVHKRHf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 13:07:35 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Harald Seipp <SEIPP@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Thanks for your responses thus far, James; I appreciate the education I
am getting.

RAID management applications have no idea what other applications are
doing and can not exercise such control over them. From my (flawed?)
view, there is no way to ask the OS if the target happens to be unused
and quiesced at this instant of time.

Asking the (various) applications (of which one of them is the
filesystem mounts) this question is an exercise in anger management
currently. All attempts to add such 'busy' interrogation code to the
ioctl of the driver are rejected. This code resides in the 'Adaptec
Branch' of the aacraid driver as one of our OEM added values.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, August 11, 2005 12:53 PM
To: Salyzyn, Mark
Cc: Harald Seipp; SCSI Mailing List
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)

On Thu, 2005-08-11 at 12:37 -0400, Salyzyn, Mark wrote:
> Cool, must try that to see if the issues are mitigated, the issues are
> reported on Distributions in default configurations.

Well ... this was one of the nastiest features to get right; we didn't
get it fully sorted out until quite recently.  I'm not sure if the
distros backported all the fixes.  However, on a modern 2.6 based
distro, it works for me and my trusty USB stick with the latest kernel.

> Since it is a design goal to survive, then I better be putting up
traces
> and submitting fs patches, rather than b*&^ing eh? I'd still feel more
> comfortable having the RAID management GUIs put up a popup box warning
> the user that what he is about to do to a device currently in-use is
> dangerous. Reporting a refcount (which covers both filesystem and
direct
> i/o as used by database engines) would help.

Well ... look at it this way.  The system is designed to survive
surprise ejection (that's for USB, firewire et al.)  If you want to have
a GUI that does notified ejection then that's fine too, but it's not a
kernel issue: You clean up everything from userspace by asking nicely
and then eject the device, which we see as a surprise ejection where we
think that we fortuitously have no work to do.

James


