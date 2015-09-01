From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/23] scsi_dh_alua: Use separate alua_port_group
	structure
Date: Tue, 1 Sep 2015 15:44:39 +0200
Message-ID: <20150901134439.GA13566@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-14-git-send-email-hare@suse.de> <20150901102055.GC9838@lst.de> <55E5A1E5.8000701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35329 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbbIANol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 09:44:41 -0400
Content-Disposition: inline
In-Reply-To: <55E5A1E5.8000701@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Sep 01, 2015 at 03:02:29PM +0200, Hannes Reinecke wrote:
> >> +	rcu_read_lock();
> >> +	pg = rcu_dereference(h->pg);
> >> +	if (!pg) {
> >> +		rcu_read_unlock();
> >> +		return -ENXIO;
> >> +	}
> > 
> > What is this rcu_read_lock supposed to protect against given
> > that struct alua_port_group isn't RCU freed?  I think this needs
> > to be another kref_get_unless_zero.
> > 
> It's not freed now, but it'll be with one of the next patches (ie with
> the 'rescan' patch).
> I just kept it here for consistency, following the rule to always
> enclose 'rcu_dereference' with 'rcu_read_lock()/rcu_read_unlock()'
> pairs. Irrespective on whether it's being freed or not.

After this patch this is the only RCU call in the driver.  I don't
think adding it here make any sense.
