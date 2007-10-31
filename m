From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 03:01:56 +0100
Message-ID: <3ae72650710301901r5cda1fb7i5e31fd9b7f8855de@mail.gmail.com>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <47261F50.3050901@s5r6.in-berlin.de>
	 <1193768743.3321.91.camel@localhost.localdomain>
	 <20071031004011.GA8309@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:21589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXJaCB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 22:01:57 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2730334wah
        for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2007 19:01:56 -0700 (PDT)
In-Reply-To: <20071031004011.GA8309@jupiter.solarsys.private>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Oct 31, 2007 1:40 AM, Mark M. Hoffman <mhoffman@lightlink.com> wrote:
> * James Bottomley <James.Bottomley@SteelEye.com> [2007-10-30 13:25:43 -0500]:
> > On Mon, 2007-10-29 at 18:58 +0100, Stefan Richter wrote:
> > > James Bottomley wrote:
> > > >> >  struct attribute_group {
> > > >> >        const char              *name;
> > > >> > +      int                     (*filter_show)(struct kobject *, int);
> > >
> > > > Actually, it returns a true/false value indicating whether the given
> > > > attribute should be displayed.
> > >
> > > How about this:
> > >
> > >     int (*is_visible)(...);
> >
> > OK, so is this latest revision acceptable to everyone?
>
> I've just been hacking around in this area a bit, for a completely different
> reason: there are literally 1000's of attributes in drivers/hwmon/*.c that
> really want to be const, but which cannot be due to the current API.  I was
> about to propose some patches that move in a different direction...

That isn't related to "dynamic attributes", right?

> IMHO the fundamental problem is struct attribute_group itself.  This structure
> is nothing but a convenience for packaging the arguments to sysfs_create_group
> and sysfs_remove_group.

That "problem" is actually a good thing. If you look at the change
rate of the internal kernel API, it saves us so much trouble. Like in
this case, James can just add a callback without caring about any
(almost :)) of the current users.

> Those functions should take the contents of that
> struct as direct arguments.

I think we should move in the opposite direction. You are right, it
isn't neccessarily pretty, but having encapsulations like this saves
us a lot of trouble while interacting with so many other people and
extending API's all the time. It's a trade, and it's a good one, if
you need to maintain code that has so many callers, and  so many
architectures, you can't even check that you don't break them.

> I haven't finished the patch series to implement
> this, but since I noticed your patch I thought I'd better speak up now.  Here's
> the first... the idea is to eventually deprecate sysfs_[create|remove]_group()
> altogether.

Again, I don't think, that we want to get rid of the struct container
housing all the parameters and beeing open for future extensions
without changing all the callers.

>     The current declaration of struct attribute_group prevents long lists of
>     attributes from being marked const.  Ideally, the second argument to the
>     sysfs_create_group() and sysfs_remove_group() functions would be marked "deep"
>     const, but C has no such construct.  This patch provides a parallel set of
>     functions with the desired decoration.

What do we get out of this constification compared to the current code?

Thanks,
Kay
