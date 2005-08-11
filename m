From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 12:52:26 -0500
Message-ID: <1123782746.5062.42.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684DCF@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22181 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932313AbVHKRwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 13:52:33 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684DCF@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Harald Seipp <SEIPP@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-08-11 at 13:05 -0400, Salyzyn, Mark wrote:
> RAID management applications have no idea what other applications are
> doing and can not exercise such control over them. From my (flawed?)
> view, there is no way to ask the OS if the target happens to be unused
> and quiesced at this instant of time.

But we have userspace tools, like fuser that can get the answers

> Asking the (various) applications (of which one of them is the
> filesystem mounts) this question is an exercise in anger management
> currently. All attempts to add such 'busy' interrogation code to the
> ioctl of the driver are rejected. This code resides in the 'Adaptec
> Branch' of the aacraid driver as one of our OEM added values.

That's because such questions are 1) racy and 2) flawed.

I could export the device ref count sure enough, but it's not useful.
It's internal bookkeeping only.  It could be 1 if there's a filesystem
mounted, in which case you don't want to force an ejection without
unmounting or it could be 1 because someone's sitting in the sysfs
directory, in which case an ejection is fine.

Regardless, userspace is supposed to clean up nicely, so you
use /proc/mounts and fuser to check to see if the thing is really in use
and by whom and the user takes action accordingly (either say wait for
me to clean up manually or go ahead and kill everything to clean this
up).

James


