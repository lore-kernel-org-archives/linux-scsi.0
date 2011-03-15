From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 21/21] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Tue, 15 Mar 2011 11:18:38 +0100
Message-ID: <20110315101838.GB23623@lst.de>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org> <1300100775-10012-22-git-send-email-nab@linux-iscsi.org> <20110314145808.GA28480@lst.de> <1300140175.28255.156.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51757 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1COKSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2011 06:18:39 -0400
Content-Disposition: inline
In-Reply-To: <1300140175.28255.156.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>

On Mon, Mar 14, 2011 at 03:02:55PM -0700, Nicholas A. Bellinger wrote:
> > Please descide on a naming scheme for the frontend modules.  You have
> > tcm_loop for thise one, and just iscsi for the iscsi frontend.
> 
> Ok, curently everything that appears under drivers/target/ beside
> iscsi_target_mod.ko is using a matching drivers/target/$FABRIC_MOD/ and
> $FABRIC_MOD.ko naming scheme.
> 
> I would prefer to keep iscsi_target_mod.ko for the software iSCSI case
> in order to prevent chaos with existing userspace tools and prevent
> breakage with existing other iSCSI target modules (IET is using
> iscsi_trgt.ko IIRC).
> 
> How about dropping the 'tcm_' prefix from the drivers/target/tcm_subdir/
> to follow how the fabric module actually appears once loaded under
> /sys/kernel/config/target/$FABRIC/..?  We will need to keep the common
> 'tcm_' prefix for the actual target fabric modules (or choose a
> different one) to handle those that interface with existing SCSI LLD
> code.

Dropping the tcm sounds fine to me.

> This makes it a bit easier to grok as a reference for newcomers by
> having seperate sections for configfs control plane, struct
> target_core_fabric_ops API callers, and Linux/SCSI LLD specific glue.

I don't think it's a very good reference, though.  E.g. currently the
fabric ops methods are implemented in tcm_loop_fabric.c, and all need
non-static scope because they are assigned in tcm_loop_configfs.c, which
creates a lot of global scope and pointless prototypes.  Either one
could clean all that up or just merge the files into one which would
be a lot easier.  Especiall as the way the target_fabric_configfs structure
and the fabric ops are structured will get a big overhaul from me soon.

