From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Fri, 18 Mar 2011 11:56:35 -0400
Message-ID: <20110318155635.GA22514@infradead.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1CRP4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 11:56:37 -0400
Content-Disposition: inline
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Thu, Mar 10, 2011 at 02:54:19AM -0800, Dan Williams wrote:
> As first introduced in "[RFC PATCH 0/6] isci: initial driver release
> (part1: intro and lldd) " [1], the isci driver is split into an lldd
> layer that interfaces with libsas and a core layer that interfaces with
> the hardware.  Quoting from the original introduction:

I just looked at it and that architecture is a complete fucking mess.

You absolutely have to fix it before it can be merged.  Gems like
duplicating all wire level constants and structures for SCSI, SAS
and ATA in your own headers is simply not acceptable.  I'm not sure
where you got the idea this could be remotely acceptable.


Also the source layout is a real mess, almost comparably to the broacade
FC driver - there really is no point in having a header for barely more
than a structure or inline.

Also care to explain the design rationale for all these specific
semi-statemachines?  To my untrained eye they really looks like
pointless obsfucation, but maybe there's a good reason that should be
explained in long comments.

And please don't make the code like ACPICA, macro names like
SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT or
SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE
just need to go.

Also please get rid of ALL UPPERCASE SCREAMING NAMES for structures.

FYI:

         u32 connection_inactivity_timeout:16;

is a really dumb idea.  Please take the crackpipe away from whatever
idiot came up with junk like that and use the proper right sized integer
types.  Also for sub-byte field please absolutely avoid bitfields.
Their layout is unportable, and properly locking them is a nightmare.
Just define a flags field and use bit operations on them.

