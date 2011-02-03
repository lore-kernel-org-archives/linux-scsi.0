From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 20/28] libfcoe: add implementation to support fcoe
 transport
Date: Wed, 02 Feb 2011 18:13:52 -0800
Message-ID: <1296699232.1683.12.camel@fritz>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
	 <20110129000455.1784.95503.stgit@localhost6.localdomain6>
	 <4D48FD2E.1000307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1BCCNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 21:13:53 -0500
In-Reply-To: <4D48FD2E.1000307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, "Zou, Yi" <yi.zou@intel.com>

On Tue, 2011-02-01 at 22:43 -0800, Mike Christie wrote:
> On 01/28/2011 06:04 PM, Robert Love wrote:
> > +static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
> > +{
> > +	int rc = -ENODEV;
> > +	struct net_device *netdev = NULL;
> > +	struct fcoe_transport *ft = NULL;
> > +	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
> > +
> > +	if (!mutex_trylock(&ft_mutex))
> > +		return restart_syscall();
> 
> I was just wondering what is the reason for this. I see it in other 
> network related sysfs code but no where else. Is there some networky reason?

I think this may be unnecessary. We initially added a rtnl_trylock in
fcoe_create/destroy (fcoe.ko's sysfs entry-points) with change
34ce27bcf96f5f366e1fa8c4729ffc8a55de4cc3. I cannot think of a good
reason why this is a mutex_trylock/restart_syscall and not just a simple
mutex_lock.

> 
> > +
> > +#ifdef CONFIG_LIBFCOE_MODULE
> > +	/*
> > +	 * Make sure the module has been initialized, and is not about to be
> > +	 * removed.  Module parameter sysfs files are writable before the
> > +	 * module_init function is called and after module_exit.
> > +	 */
> > +	if (THIS_MODULE->state != MODULE_STATE_LIVE)
> > +		goto out_nodev;
> > +#endif
> 
> It seems that this would be a problem for every driver that uses module 
> params. Should the module code be getting a module refcount or doing 
> this test?

I think the problem is that the sysfs entries are created and are
writable before the module is truly initialized, so we could start using
uninitialized variables. It looks like a global solution would be to not
add sysfs files (or at least don't make them writable) until the module
initialization has completed. I have no idea how feasible this is.

//Rob

