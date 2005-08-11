From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 11:53:19 -0500
Message-ID: <1123779199.5062.33.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684D95@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50596 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751120AbVHKQxX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:53:23 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684D95@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Harald Seipp <SEIPP@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-08-11 at 12:37 -0400, Salyzyn, Mark wrote:
> Cool, must try that to see if the issues are mitigated, the issues are
> reported on Distributions in default configurations.

Well ... this was one of the nastiest features to get right; we didn't
get it fully sorted out until quite recently.  I'm not sure if the
distros backported all the fixes.  However, on a modern 2.6 based
distro, it works for me and my trusty USB stick with the latest kernel.

> Since it is a design goal to survive, then I better be putting up traces
> and submitting fs patches, rather than b*&^ing eh? I'd still feel more
> comfortable having the RAID management GUIs put up a popup box warning
> the user that what he is about to do to a device currently in-use is
> dangerous. Reporting a refcount (which covers both filesystem and direct
> i/o as used by database engines) would help.

Well ... look at it this way.  The system is designed to survive
surprise ejection (that's for USB, firewire et al.)  If you want to have
a GUI that does notified ejection then that's fine too, but it's not a
kernel issue: You clean up everything from userspace by asking nicely
and then eject the device, which we see as a surprise ejection where we
think that we fortuitously have no work to do.

James


