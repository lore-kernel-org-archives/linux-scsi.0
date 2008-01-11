From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Fri, 11 Jan 2008 10:33:16 +0800
Message-ID: <a8e1da0801101833j6fd3bb56p6998e6e326858724@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080110142341.71af4dc5@gondolin.boeblingen.de.ibm.com>
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
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: a.zummo@towertech.it, krh@redhat.com, rtc-linux@googlegroups.com, linux-scsi@vger.kernel.org, peterz@infradead.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, cbou@mail.ru, Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu, spi-devel-general@lists.sourceforge.net, David Brownell <david-b@pacbell.net>, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Jan 10, 2008 9:23 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Thu, 10 Jan 2008 17:48:43 +0800,
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
> Please add a kerneldoc comment for each of the new interfaces.
Will do.
>
> > +int class_for_each_device(struct class *class, void *data,
> > +                        int (*fn)(struct device *, void *))
> > +{
> > +     struct device *dev;
> > +     int error = 0;
> > +
> > +     if (!class)
> > +             return -EINVAL;
> > +     mutex_lock(&class->mutex);
> > +     list_for_each_entry(dev, &class->devices, node) {
> > +             error = fn(dev, data);
>
> Hm, the equivalent _for_each_device() functions all elevate the
> device's refcount while calling fn(). I wonder whether we want this
> here as well?

Thanks for comment.
Hm, I'm not sure about this. Greg, what's your opinion?

>
> > +             if (error)
> > +                     break;
> > +     }
> > +     mutex_unlock(&class->mutex);
> > +
> > +     return error;
> > +}
> > +EXPORT_SYMBOL_GPL(class_for_each_device);
> > +
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
>
> First get the reference and then drop it if the match function returns
> 0 to make this analogous to the other _find_device() functions?

It's just like other _find_device() functions. Are these more get/put
really needed?

>
> > +                     break;
> > +     mutex_unlock(&class->mutex);
> > +
> > +     return dev;
> > +}
> > +EXPORT_SYMBOL_GPL(class_find_device);
> > +
> > +int class_for_each_child(struct class *class, void *data,
> > +                        int (*fn)(struct class_device *, void *))
>
> Haven't looked at the callers, but isn't it better to convert them to
> use struct device instead so we don't need to introduce new
> class_device api?

The drivers/scsi/hosts.c need it.

>
> > +{
> > +     struct class_device *dev;
> > +     int error = 0;
> > +
> > +     if (!class)
> > +             return -EINVAL;
> > +     mutex_lock(&class->mutex);
> > +     list_for_each_entry(dev, &class->children, node) {
> > +             error = fn(dev, data);
>
> Same comment as above concerning reference counts.
>
> > +             if (error)
> > +                     break;
> > +     }
> > +     mutex_unlock(&class->mutex);
> > +
> > +     return error;
> > +}
> > +EXPORT_SYMBOL_GPL(class_for_each_child);
> > +
> > +struct class_device *class_find_child(struct class *class, void *data,
> > +                                int (*match)(struct class_device *, void *))
> > +{
> > +     struct class_device *dev;
> > +
> > +     if (!class)
> > +             return NULL;
> > +
> > +     mutex_lock(&class->mutex);
> > +     list_for_each_entry(dev, &class->children, node)
> > +             if (match(dev, data) && class_device_get(dev))
>
> And here.
>
>
> > +                     break;
> > +     mutex_unlock(&class->mutex);
> > +
> > +     return dev;
> > +}
> > +EXPORT_SYMBOL_GPL(class_find_child);
> > +
>

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
