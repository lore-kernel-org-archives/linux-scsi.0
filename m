From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 12:37:44 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684D95@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:24746 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751112AbVHKQj4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:39:56 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Harald Seipp <SEIPP@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Cool, must try that to see if the issues are mitigated, the issues are
reported on Distributions in default configurations.

The panics I have seen have been access violations due to bugs in the
filesystem layers dealing with some of the inconsistencies. No different
to mounting a corrupted filesystem. Sometimes the filesystem driver can
see the punch coming, I contend that sometimes it does not...

Since it is a design goal to survive, then I better be putting up traces
and submitting fs patches, rather than b*&^ing eh? I'd still feel more
comfortable having the RAID management GUIs put up a popup box warning
the user that what he is about to do to a device currently in-use is
dangerous. Reporting a refcount (which covers both filesystem and direct
i/o as used by database engines) would help.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, August 11, 2005 12:08 PM
To: Salyzyn, Mark
Cc: Harald Seipp; SCSI Mailing List
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)

On Thu, 2005-08-11 at 11:51 -0400, Salyzyn, Mark wrote:
> The problem with pushing this policy to the user is that software
> applications have no means to determine that a device is currently
> in-use. For instance, the net result of pulling a device on a mounted
> filesystem is an eventual kernel panic.

The kernel only panics if you told it to with the mount option
errors=panic (or if you have errors=panic set in the superblock flags).

For file systems on removable devices you shouldn't be telling it to
panic on error, you should be telling it to continue or remount-ro.  If
you do this then you can happily yank the undelying device on a mounted
fs, which was one of the design goals of the 2.6 SCSI state model and
refcounting reworks.

James


