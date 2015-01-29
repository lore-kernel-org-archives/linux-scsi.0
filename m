From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] [PATCH REGRESSION] alua: fix bus detach oops
Date: Thu, 29 Jan 2015 00:56:26 -0800
Message-ID: <20150129085626.GA3715@infradead.org>
References: <1422438413-10273-1-git-send-email-michaelc@cs.wisc.edu>
 <54C9F324.1020102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbA2I4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 03:56:30 -0500
Content-Disposition: inline
In-Reply-To: <54C9F324.1020102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Thu, Jan 29, 2015 at 09:45:24AM +0100, Hannes Reinecke wrote:
> Errm.
> 
> We save the contents first:
> 
> >  	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
> 
> Then set the pointer to NULL:
> 
> >  	sdev->scsi_dh_data = NULL;
> 
> and then call 'detach':
> 
> > 	scsi_dh->detach(sdev);
> 
> So scsi_dh is _not_ NULL, hence it shouldn't oops.

The actual ->detach method can, and usually does access it.
