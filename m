From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Wed, 9 Jan 2008 14:39:23 +0800
Message-ID: <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
References: <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	<478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de>
	<47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de>
	<a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	<20080108224837.GA19623@suse.de>
	<a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	<20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	<a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
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
To: Greg KH <gregkh@suse.de>
Cc: a.zummo@towertech.it, krh@redhat.com, rtc-linux@googlegroups.com, linux-scsi@vger.kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, cbou@mail.ru, Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu, spi-devel-general@lists.sourceforge.net, David Brownell <david-b@pacbell.net>, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Jan 9, 2008 2:37 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Jan 9, 2008 2:13 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > On Wed, Jan 09, 2008 at 09:32:48AM +0800, Dave Young wrote:
> > > On Jan 9, 2008 6:48 AM, Greg KH <gregkh@suse.de> wrote:
> > > > On Tue, Jan 08, 2008 at 03:05:10PM +0800, Dave Young wrote:
> > > > > On Jan 8, 2008 1:20 AM, Greg KH <gregkh@suse.de> wrote:
> > > > > > On Mon, Jan 07, 2008 at 06:13:37PM +0100, Stefan Richter wrote:
> > > > > > > It's already in the driver core to the most part.  It remains to be seen
> > > > > > > what is less complicated in the end:  Transparent mutex-protected list
> > > > > > > accesses provided by driver core (requires the iterator), or all the
> > > > > > > necessary locking done by the drivers themselves (requires some more
> > > > > > > lock-taking but perhaps fewer lock instances overall in the drivers, and
> > > > > > > respective redefinitions and documentation of the driver core API).
> > > > > >
> > > > > > I favor changing the driver core api and doing this kind of thing there.
> > > > > > It keeps the drivers simpler and should hopefully make their lives
> > > > > > easier.
> > > > >
> > > > > What about this?
> > > > >
> > > > > #define class_for_each_dev(pos, head, member) \
> > > > >         for (mutex_lock(&(container_of(head, struct class, devices))->mutex), po
> > > > > s = list_entry((head)->next, typeof(*pos), member); \
> > > > >         prefetch(pos->member.next), &pos->member != (head) ? 1 : (mutex_unlock(&
> > > > > (container_of(head, struct class, devices))->mutex), 0); \
> > > > >         pos = list_entry(pos->member.next, typeof(*pos), member))
> > > >
> > > I'm wrong, it's same as before indeed.
> > >
> > > > Eeek, just make the thing a function please, where you pass the iterator
> > > > function in, like the driver core has (driver_for_each_device)
> > >
> > > Ok, so need a new member of knode_class, I will update the patch later.
> > > Thanks.
> >
> > Withdraw my post, sorry :)
> >
> > For now the mutex patch, I will only use the mutex to lock the devices list and write an iterater function.
> > Most of the iterating is for finding some device in the list, so maybe need a match function just like drivers do?
> >
>
> Drop one more mail address of David Brownell in cc list.
> Sorry for this, david
>
gmail web client make me crazy.

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
