From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH ver3 3/4] qla4xxx: use dev_xxx on some pci/dma resource alloc warning and error printks
Date: Wed, 9 Aug 2006 16:36:01 -0700
Message-ID: <20060809233601.GG9156@ranandlinuxbox.qlogic.org>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org> <20060805225227.9557.30796.stgit@bebe.enoyolf.org> <20060809230550.480743@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:22322 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751439AbWHIXf1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2006 19:35:27 -0400
Content-Disposition: inline
In-Reply-To: <20060809230550.480743@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

>On Wed, 09 Aug 2006, Doug Maxey wrote:
> On Wed, 09 Aug 2006 13:52:07 EDT, Mike Christie wrote:
> ...
> > > @@ -836,9 +825,8 @@ static int qla4xxx_mem_alloc(struct scsi
> > >  	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
> > >  					 mempool_free_slab, srb_cachep);
> > >  	if (ha->srb_mempool == NULL) {
> > > -		ql4_printk(KERN_WARNING, ha,
> > > -			   "Memory Allocation failed - SRB Pool.\n");
> > > -
> > > +		dev_warn(&ha->pdev->dev,
> > > +			 "Memory Allocation failed - SRB Pool.\n");
> > >  		goto mem_alloc_error_exit;
> > 
> > Sorry for the late response on this one. As you know I was out for a
> > while and I was waiting to get internet access yesterday.
> > 
> > For these host messages, do we want something like the sdev_printk and
> > starget_printk or does it really make more sense to use the pci bus id
> > for the message prefix? What about other scsi host messages, will they
> > always go with the pci bus id or some scsi-ml id? And even if we want to
> > print out the pci bus id as the prefix instead of some scsi info, should
> > we still have some scsi wrapper?
> > 
>  
> I do agree that iscsi_transport sessions could use a new macro.
> 
> My intention in this instance was to go with the widely used idiom, and 
> to not have a driver specific one.  Was trying to replace
>  #define ql4_printk(level, ha, format, arg...)			\
>      dev_printk(level, &((ha)->pdev->dev), format, ## arg)
> 
> But to follow on from irc, one more pass at this to help me clarify and
> understand what is need here.
> 
> dev_xxx is a wrapper around dev_print(xxx ...).  
> 
> In the specific instance above, this should print
> scsiN arg...
> 
> Since qla4xxx_mem_alloc() is for the host, would an sdev_printk be
> the right thing?  I don't believe we have any context of a target.
> Of course that may be a misunderstanding on my part.
> 
> For this driver, I don't see any instances of a scsi_target.  

You are correct. Its during init time. So you dont have any instance of scsi_target.

Ravi
