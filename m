From: "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 07:28:21 -0400
Message-ID: <20071031112821.GB8309@jupiter.solarsys.private>
References: <1193671019.3383.13.camel@localhost.localdomain> <1193676852.2655.21.camel@lov.site> <1193677071.3383.56.camel@localhost.localdomain> <47261F50.3050901@s5r6.in-berlin.de> <1193768743.3321.91.camel@localhost.localdomain> <20071031004011.GA8309@jupiter.solarsys.private> <3ae72650710301901r5cda1fb7i5e31fd9b7f8855de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emerald.lightlink.com ([205.232.34.14]:24732 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbXJaL2q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 07:28:46 -0400
Content-Disposition: inline
In-Reply-To: <3ae72650710301901r5cda1fb7i5e31fd9b7f8855de@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi Kay:

* Kay Sievers <kay.sievers@vrfy.org> [2007-10-31 03:01:56 +0100]:
> On Oct 31, 2007 1:40 AM, Mark M. Hoffman <mhoffman@lightlink.com> wrote:
> > * James Bottomley <James.Bottomley@SteelEye.com> [2007-10-30 13:25:43 -0500]:
> > > On Mon, 2007-10-29 at 18:58 +0100, Stefan Richter wrote:
> > > > James Bottomley wrote:
> > > > >> >  struct attribute_group {
> > > > >> >        const char              *name;
> > > > >> > +      int                     (*filter_show)(struct kobject *, int);
> > > >
> > > > > Actually, it returns a true/false value indicating whether the given
> > > > > attribute should be displayed.
> > > >
> > > > How about this:
> > > >
> > > >     int (*is_visible)(...);
> > >
> > > OK, so is this latest revision acceptable to everyone?
> >
> > I've just been hacking around in this area a bit, for a completely different
> > reason: there are literally 1000's of attributes in drivers/hwmon/*.c that
> > really want to be const, but which cannot be due to the current API.  I was
> > about to propose some patches that move in a different direction...
> 
> That isn't related to "dynamic attributes", right?

Right, it's not.  That phrase was coined by the previous maintainer, Jean, to
describe a specific mechanism which makes for smaller code in drivers/hwmon.

> > IMHO the fundamental problem is struct attribute_group itself.  This structure
> > is nothing but a convenience for packaging the arguments to sysfs_create_group
> > and sysfs_remove_group.
> 
> That "problem" is actually a good thing. If you look at the change
> rate of the internal kernel API, it saves us so much trouble. Like in
> this case, James can just add a callback without caring about any
> (almost :)) of the current users.

Given my patch, he could also just add sysfs_create_attr_group_filtered(...).
This would affect current users even less than what you suggest because it
wouldn't bloat the struct that they all use.

> > Those functions should take the contents of that
> > struct as direct arguments.
> 
> I think we should move in the opposite direction. You are right, it
> isn't neccessarily pretty, but having encapsulations like this saves
> us a lot of trouble while interacting with so many other people and
> extending API's all the time. It's a trade, and it's a good one, if
> you need to maintain code that has so many callers, and  so many
> architectures, you can't even check that you don't break them.

Again, I don't see how it is better to bloat a struct with many users instead
of just adding a function for the few that need the extra functionality.  My
patch also requires 0 change for everyone else.

> > I haven't finished the patch series to implement
> > this, but since I noticed your patch I thought I'd better speak up now.  Here's
> > the first... the idea is to eventually deprecate sysfs_[create|remove]_group()
> > altogether.
> 
> Again, I don't think, that we want to get rid of the struct container
> housing all the parameters and beeing open for future extensions
> without changing all the callers.

BTW: I hope you're not resisting based on the prospect of deprecating those
two functions.  I don't really have time to push such a huge patch either.
It wouldn't hurt just to keep them.

> >     The current declaration of struct attribute_group prevents long lists of
> >     attributes from being marked const.  Ideally, the second argument to the
> >     sysfs_create_group() and sysfs_remove_group() functions would be marked "deep"
> >     const, but C has no such construct.  This patch provides a parallel set of
> >     functions with the desired decoration.
> 
> What do we get out of this constification compared to the current code?

Conceptual correctness, for one, but also it allows hwmon drivers to move as
much as 1K each out of the data section and into text.  This is useful for the
embedded XIP scenario.

And please don't underestimate conceptual correctness: at least hwmon (and
probably many other users) really *rely* on the core not to modify the contents
of struct attribute_group (specifically, the data to which its members point).

Without the proper const qualifiers, this is not externally guaranteed.

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

