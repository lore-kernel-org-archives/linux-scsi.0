From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/17] scsi_dh_alua: Disable ALUA handling for non-disk
	devices
Date: Mon, 11 May 2015 13:34:51 +0200
Message-ID: <20150511113451.GA4803@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-3-git-send-email-hare@suse.de> <20150511064643.GB30516@lst.de> <555083AF.1000605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40023 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbbEKLex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 07:34:53 -0400
Content-Disposition: inline
In-Reply-To: <555083AF.1000605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, May 11, 2015 at 12:25:51PM +0200, Hannes Reinecke wrote:
> The spec wording doesn't explicitly disallowing you from doing so
> (unless you're using referrals).
> But in realiter we're using the ALUA device handler only when
> multipathing is used, which in turn runs on disk devices only.
> So we can limit ourselves to disk devices, too.
> 
> Everything else (like tapes or tape changers) will have to
> implement their own logic anyway; tape support in multipathing
> with or without ALUA is too horrible to contemplate ...

So what is the problem you're trying to solve here?  We were attaching
to other nodes and so far I haven't heard about that being a problem.

Basically we'll disallow I/O for offlines paths to non-disk devices
once the ALUA handler is attached, which actually seems useful
even without a multipath handler on top.

> >> +	if (sdev->type != TYPE_DISK &&
> >> +	    sdev->type != TYPE_RBC &&
> >> +	    sdev->type != TYPE_OSD) {
> > 
> > And does it really allow RBC (but not ZBC)?
> > 
> Thought so, but I'll have to cross-check.
> Maybe it's time to implement a 'scsi_is_disk_type()' macro...

If the reason to disallow anything that we can't use dm-mpath on
both OSD and ZBC in it's current form are excluded.  RBC would
be included, although I doubt there is a multi ported RBC
device available.
