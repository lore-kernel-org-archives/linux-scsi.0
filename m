From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Fri, 11 Jan 2008 16:53:36 +0800
Message-ID: <a8e1da0801110053j70a1b117n46983d8c0b073fde@mail.gmail.com>
References: <478227D5.8050402@s5r6.in-berlin.de>
	<20080108224837.GA19623@suse.de>
	<a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	<20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	<a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	<a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	<20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	<20080110142341.71af4dc5@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801101833j6fd3bb56p6998e6e326858724@mail.gmail.com>
	<20080111092359.7443af68@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080111092359.7443af68@gondolin.boeblingen.de.ibm.com>
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

On Jan 11, 2008 4:23 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Fri, 11 Jan 2008 10:33:16 +0800,
> "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
>
> > > > +struct device *class_find_device(struct class *class, void *data,
> > > > +                                int (*match)(struct device *, void *))
> > > > +{
> > > > +     struct device *dev;
> > > > +
> > > > +     if (!class)
> > > > +             return NULL;
> > > > +
> > > > +     mutex_lock(&class->mutex);
> > > > +     list_for_each_entry(dev, &class->devices, node)
> > > > +             if (match(dev, data) && get_device(dev))
> > >
> > > First get the reference and then drop it if the match function returns
> > > 0 to make this analogous to the other _find_device() functions?
> >
> > It's just like other _find_device() functions. Are these more get/put
> > really needed?
>
> The other _find_device() functions operate on klists, which means that
> there is an implicit get while the element is handled. This function
> operates on a normal list, which means that getting/putting the
> reference looks a bit different if we want the same effect.
>

Hi, you are right. Will be fixed.

Thanks.

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
