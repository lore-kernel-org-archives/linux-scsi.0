From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 12:54:53 -0700
Message-ID: <20050808195453.GA22773@us.ibm.com>
References: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org> <1123451837.5020.22.camel@mulgrave> <42F7A344.8070905@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:42933 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932245AbVHHTzf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 15:55:35 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j78JtWkQ713472
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 15:55:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j78JtPWw186674
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 15:55:25 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j78JtPYm022141
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 15:55:25 -0400
Content-Disposition: inline
In-Reply-To: <42F7A344.8070905@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> On 08/07/05 17:57, James Bottomley wrote:
> > Alan Stern wrote:
> >>The only resource that matters for this discussion is associated with the
> >>LLD itself, not with any of its hosts: the host template.  Once the SCSI
> >>core has released all references to the template, it can't call the LLD
> >>any more.  The problem is that the LLD has no way to know when all the
> >>references have been dropped.  This suggests that the entire problem could
> >>be solved by adding a kref to struct scsi_host_template.
> >>
> >>Would you agree to a patch adding such a kref?
> > 
> > 
> > Well, not really.  The host template usually exists as a variable in the
> > module, so its lifetime is tied to the lifetime of the module.  Adding a
> > kref wouldn't help because it will still be freed when the module is
> > removed.  If there's a case where the template is being freed
> > prematurely because the module is being removed, then we have the module
> > refcounting wrong somewhere.  Have you run across such a case?
> 
> Hmm, I think Alan has a point.
> 
> >From object point of view, who is the parent and who is the child
> when talking about LLDD/module and the host template?
> 
> The reason is that the host template could be simulated on behalf
> of the underlying transport (as is the case for USB).
> 
> So, it could be the case that the host template _should_ be
> removed but the entity which removed it should stay, and that
> entity wants to know when the host template is to be removed.
> 
> (Actually it doesn't, but setting the release method in the
> kobj_ktype would do wonders. ;-) )
> 
> In which case, it does make sense to include a kset to the
> host template (since it has many children), and anyone
> using/manipulating it does kset_get().  When that entity
> is done with the host template it does a kset_put().
> 
> Such entities could be the managing layer above, error
> handling, etc.
> 
> Another solution, just as good, is to use the template
> _only_ for the registration call, as a _template_, and
> as soon as the registration call has returned, the
> caller (LLDD/module) can free the template.  After all,
> it is only a template.

While you could do this I believe this would not solve Alan's question as
if I read correctly it involved the functions called through the host
template (i.e., through shost->hostt).

> 
> Then the managing layer allocates the actual host struct
> and "gives" it to the LLDD.  The LLDD goes a kset_get()
> on it while it lives, and when it is to die, it does a
> kset_put().  And if it gets a method call, it would
> error it out, after the put...
> 

We already have kobject for the scsi_host object so it is unclear why
switch to a kset. In looking at the kernel tree I do not see any users of
ksets outside the driver model subsystems. I believe James suggestion of
adding to scsi_host_dev_release would allow the LLDD to get a better
indicator of release cleanup without changing the LLDD interface to use
ksets.



-andmike
--
Michael Anderson
andmike@us.ibm.com
