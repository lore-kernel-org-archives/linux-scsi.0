From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Fri, 11 Jan 2008 10:18:24 +0800
Message-ID: <a8e1da0801101818v748f6481g79ebecaa0c0e7bfd@mail.gmail.com>
References: <478227D5.8050402@s5r6.in-berlin.de>
	<20080107172009.GA25943@suse.de>
	<a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	<20080108224837.GA19623@suse.de>
	<a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	<20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	<a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	<a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	<20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	<478610E8.4060602@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <478610E8.4060602@s5r6.in-berlin.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: a.zummo@towertech.it, krh@redhat.com, rtc-linux@googlegroups.com, linux-scsi@vger.kernel.org, peterz@infradead.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, cbou@mail.ru, David Brownell <david-b@pacbell.net>, stern@rowland.harvard.edu, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Jan 10, 2008 8:34 PM, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Dave Young wrote:
> > This is the first one of the series about driver core changes.
>
> Please always provide kerneldoc comments when you add new API elements;
> here: exported functions.
>
> It's unfortunate that the driver core's API isn't fully documented yet,
> and you shouldn't make it worse.
>
> That's only my personal opinion as one API user though.  But others
> might agree.  Among else, things worth documenting are return values
> after errors, side effects (!), constraints on the calling context if
> there are any special constraints.
>
> I assume you didn't write documentation yet because you need general
> feedback first.

Yes, I did not. Thanks for pointing out, I will do.
>
> ...
> > +struct device *class_find_device(struct class *class, void *data,
> > +                                int (*match)(struct device *, void *))
> > +{
> > +     struct device *dev;
> > +
> > +     if (!class)
> > +             return NULL;
> > +
> > +     mutex_lock(&class->mutex);
> > +     list_for_each_entry(dev, &class->devices, node)
> > +             if (match(dev, data) && get_device(dev))
> > +                     break;
> > +     mutex_unlock(&class->mutex);
> > +
> > +     return dev;
> > +}
>
> What is returned if there was no match?
> What if there was a match but get_ failed?

Will fix it.
>
> ...
> > +struct class_device *class_find_child(struct class *class, void *data,
> > +                                int (*match)(struct class_device *, void *))
> > +{
> ...
> > +     mutex_lock(&class->mutex);
> > +     list_for_each_entry(dev, &class->children, node)
> > +             if (match(dev, data) && class_device_get(dev))
> > +                     break;
> > +     mutex_unlock(&class->mutex);
> > +
> > +     return dev;
> > +}
>
> Here too?

Will fix it.
>
> --
> Stefan Richter
> -=====-==--- ---= -=-=-
> http://arcgraph.de/sr/
>

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
