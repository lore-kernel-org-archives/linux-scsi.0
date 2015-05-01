From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9] dm-mpath, scsi_dh: don't let dm detach device
	handlers
Date: Fri, 1 May 2015 11:20:53 +0200
Message-ID: <20150501092053.GA9341@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-3-git-send-email-hch@lst.de> <20150430182153.GB30542@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54564 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbbEAJUz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 05:20:55 -0400
Content-Disposition: inline
In-Reply-To: <20150430182153.GB30542@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, Apr 30, 2015 at 02:21:54PM -0400, Mike Snitzer wrote:
> > While allowing dm-mpath to attach device handlers is a functionality we need
> > for backwards compatibility reason there is no reason to reference count
> > them and detach them if dm-mpath stops using the device for some reason.
> > 
> > If the device handler works for the given device it can just stay attached.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good.  But, unless I'm missing something, these DM and scsi_dh
> changes can be made in separate patches so that I can carry the DM
> change without needing to touch scsi_dh (SCSI maintainer boundary).

Unfortunately they can't.  E.g. if we remove the detach in dm-mpath
but keep the refcounting in scsi_dh we'll leak references.  Of if we
remove the request_module in dm without adding it to scsi we stop
asking for the module.  So I'll need to collect ACKs from both sides
and find a suitable tree to get this in.
