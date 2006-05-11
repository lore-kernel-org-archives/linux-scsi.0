From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Asynchronous scsi scanning
Date: Thu, 11 May 2006 12:56:02 -0600
Message-ID: <20060511185602.GL12272@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org> <44637F4C.3070102@cs.wisc.edu> <20060511182119.GK12272@parisc-linux.org> <44638736.70708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37095 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750705AbWEKS4D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 14:56:03 -0400
Content-Disposition: inline
In-Reply-To: <44638736.70708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, May 11, 2006 at 01:49:26PM -0500, Mike Christie wrote:
> > 2) Unless it's serialised (in which case it still takes two hours to
> > boot), you lose drive numbering.
> 
> Drive numbering refers to the bus, target numbering right?

No, I mean sda, sdb, sdc, etc.

> Currently
> when you scan a host you are serialized at the host level because of the
> host->scan_mutex aren't we? So for each host addition hotplug event you
> can scan that host with the command above, and then you can scan all
> your hosts in parallel and the drive numbering is not affected is it? I
> thought, your patch is basically creating a kernel thread and running
> scan host selected, which grabs the scan_mutex, with all wild cards.
> What I suggested ends up calling scan host selected with all wild cards
> but from userspace.

The trick is to avoid adding the sdevs to sysfs until all prior sdevs
have been added.  I don't see a good way to do that from userspace.
