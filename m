From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: RE: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
 use from fc_queuecommand
Date: Thu, 02 Sep 2010 10:24:22 -0700
Message-ID: <1283448262.30431.172.camel@vi2.jf.intel.com>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
	 <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
	 <4C7DD3E8.9050700@cs.wisc.edu>
	 <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
	 <1283371821.32007.636.camel@haakon2.linux-iscsi.org>
	 <1283375187.30431.71.camel@vi2.jf.intel.com>
	 <1283377121.5598.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0IBRYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2010 13:24:23 -0400
In-Reply-To: <1283377121.5598.23.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Zou, Yi" <yi.zou@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, Hannes Reinecke <hare@suse.de>

On Wed, 2010-09-01 at 14:38 -0700, Nicholas A. Bellinger wrote:
> > Maybe two additional checks here is not so neat but not too bad
> either
> > as just two additional checks here, I excluded this unlocked_qcmd
> checks
> > from scsi_error queuecommand calling to not clutter its code there
> with
> > these additional checks  w/o any good case for that code path.
> > 
> 
> Hmmmm, handing off the locking like this between ML and LLD gets ugly
> pretty quick, so I am not sure exactly sure if this is the right way
> to
> go about it..
> 
> Mabye in code terms we might need to consider converting some (or
> all..?) struct Scsi_Host->host_lock accesses to some form of
> Linux/SCSI
> Host specific lock and unlock wrapper that is aware of the current
> ->queuecommand() LLD lock status..?  Obviously this would only need to
> cover the queuecommand path here first, but perhaps would be useful in
> other areas as well..?
> 

This patch would add only two conditional locking and unlocking of host
lock in scsi_dispatch_cmd and these are not applicable to all other
several places host_lock use, therefore any wrapper for just these two
new places is not worthy as that would hide conditions inside wrapper,
or may be I'm missing something here.

  
> This would at least (I think) allow ML and LLD code to be a tad bit
> cleaner than something like the example above where
> host->unlocked_qcmds
> TRUE/FALSE conditionals exist directly within ML and LLD code.
> 

Yeah but direct use makes things more obvious at first look. However
neatness is worthy using wrapper(macros) if there are several such
places. Anycase this is very minor code style thing here and I'm fine
with wrapper if you want.

	Thanks
	Vasu

