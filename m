From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Mon, 19 Dec 2011 11:14:10 -0600
Message-ID: <1324314850.5123.12.camel@dabdike.int.hansenpartnership.com>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
	 <20111214225331.GA5508@xanatos> <4EE9B375.4020606@linutronix.de>
	 <20111215211201.GA6482@xanatos> <20111216144724.GC19563@linutronix.de>
	 <20111216201236.GE19563@linutronix.de>
	 <20111216203146.GN14291@linux.intel.com>
	 <20111216204241.GA30915@linutronix.de> <20111216213628.GA5509@xanatos>
	 <1324072059.10429.27.camel@dabdike>
	 <20111219161225.GO14291@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55089 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab1LSRON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 12:14:13 -0500
In-Reply-To: <20111219161225.GO14291@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Mon, 2011-12-19 at 11:12 -0500, Matthew Wilcox wrote:
> On Fri, Dec 16, 2011 at 10:47:39PM +0100, James Bottomley wrote:
> > Well, no, what you want to do is use a shared tag map at the block
> > level.  That will manage a joint tag space for N queues without your
> > having to partition it arbitrarily.  see scsi_host_find_tag() and
> > scsi_init_shared_tag_map().
> 
> By the way, the same verbiage about tags being shared across LUNs is also
> present in the SAS spec (and various other specs last time I looked,
> which wasn't recently).

I don't think so: The SAS spec still (as of 2.1) has the nexus being
I_T_L_Q.  That means a unique combination of initiator port, target
port, lun and tag identify a nexus.  To have the nexus be blind to the
Lun (i.e. tags shared across LUNs) it would have to be identified by
I_T_Q, which I haven't actually seen in any standard.

I'm not even sure a transport would be allowed to override this; SAM is
pretty clear (s 4.12 The Nexus Object) that a nexus is either I_T, I_T_L
or I_T_L_Q.  I_T_Q isn't listed as being allowable for a nexus.

James


>   We should probably make this the default in
> the SCSI core.
> 
> I suspect it hasn't bitten us because there are so few multi-LUN devices
> out there, and it's only a "May" check, not "Must" check.  But Linux is
> technically in violation of the SAS spec by sending two commands to the
> same target with the same tag.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


