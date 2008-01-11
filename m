From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Fri, 11 Jan 2008 09:23:59 +0100
Message-ID: <20080111092359.7443af68@gondolin.boeblingen.de.ibm.com>
References: <478227D5.8050402@s5r6.in-berlin.de>
	<20080107172009.GA25943@suse.de>
	<a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	<20080108224837.GA19623@suse.de>
	<a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	<20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	<a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	<a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	<20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	<20080110142341.71af4dc5@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801101833j6fd3bb56p6998e6e326858724@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34107 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbYAKIYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 03:24:05 -0500
In-Reply-To: <a8e1da0801101833j6fd3bb56p6998e6e326858724@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com

On Fri, 11 Jan 2008 10:33:16 +0800,
"Dave Young" <hidave.darkstar@gmail.com> wrote:


> > > +struct device *class_find_device(struct class *class, void *data,
> > > +                                int (*match)(struct device *, void *))
> > > +{
> > > +     struct device *dev;
> > > +
> > > +     if (!class)
> > > +             return NULL;
> > > +
> > > +     mutex_lock(&class->mutex);
> > > +     list_for_each_entry(dev, &class->devices, node)
> > > +             if (match(dev, data) && get_device(dev))
> >
> > First get the reference and then drop it if the match function returns
> > 0 to make this analogous to the other _find_device() functions?
> 
> It's just like other _find_device() functions. Are these more get/put
> really needed?

The other _find_device() functions operate on klists, which means that
there is an implicit get while the element is handled. This function
operates on a normal list, which means that getting/putting the
reference looks a bit different if we want the same effect.
