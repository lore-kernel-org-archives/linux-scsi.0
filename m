From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Save command pool address of Scsi_Host
Date: Sat, 02 Aug 2014 00:24:34 +0400
Message-ID: <1406924674.2654.19.camel@jarvis>
References: <1406874425-3528-1-git-send-email-jgross@suse.com>
	 <20140801120301.GA27198@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59528 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273AbaHAUYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2014 16:24:45 -0400
In-Reply-To: <20140801120301.GA27198@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jgross@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 05:03 -0700, Christoph Hellwig wrote:
> On Fri, Aug 01, 2014 at 08:27:05AM +0200, jgross@suse.com wrote:
> > From: Juergen Gross <jgross@suse.com>
> > 
> > If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
> > private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
> > scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
> > 
> > This will result in an access error when the host is removed.
> > 
> > Avoid the problem by saving the address of a new allocated command pool where
> > it is expected.
> > 
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> 
> Looks good, but minor nitpick below:
> 
> > +	if (shost->hostt->cmd_size)
> > +		shost->hostt->cmd_pool = pool;
> > +
> 
> 
> We already have a local hostt variable for the host template in this
> function, please use it.

Wait, that's not right at all.  There looks to be a thinko in the
command pool handling code.  We have both a cmd_pool in the host
structure and in the host template structure, but there's confusion
about which one we're supposed to be using.

The origin of confusion seems to be the reference counting in the pool
itself ... you want the same pool for all hosts, since they can only
have one cmd_size, but you want it created on first host use and
destroyed again on the last one.

If you take this patch, a host that attached, detaches and then attaches
a host will panic because it will use a freed pool structure.

This whole mess is created by the attempt to refcount the pools.  What's
wrong with simply creating the pool at init time and deleting it again
at module removal ... that way no refcounting and no bogus problems like
this (and we can delete the cmd_pool from the host).  The restriction
this would give is that cmd_size can only be set in the template, but
that seems to be the only safe use anyway, since any driver trying to
vary this in its host add routines will get unexpected results.

James


