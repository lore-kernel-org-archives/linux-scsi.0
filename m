From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Asynchronous scsi scanning
Date: Thu, 11 May 2006 12:21:19 -0600
Message-ID: <20060511182119.GK12272@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org> <44637F4C.3070102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49882 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750722AbWEKSVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 14:21:21 -0400
Content-Disposition: inline
In-Reply-To: <44637F4C.3070102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, May 11, 2006 at 01:15:40PM -0500, Mike Christie wrote:
> Instead of all the scanning from work queue and kthreads, what about
> just running something from the host addition hotplug event. When a host
> or target or rport or whatever we want is added, userspace gets a
> hotplug event today, I thought. From that event could you just do
> 
> echo - - - > path-to-object/scan

1) Assumes userspace exists.  People still use monolithic kernels and
there's no requirement for initramfs yet.
2) Unless it's serialised (in which case it still takes two hours to
boot), you lose drive numbering.

Now, arguably, we don't need to preserve drive numbering any more,
since we have alternatives like uuids.  But I can guarantee you we'll
be buried in bug reports and unhappy users if drive numbers start
changing arbitrarily.
