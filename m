From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 04 Nov 2009 09:30:45 -0600
Message-ID: <1257348645.2697.39.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8817@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbZKDPar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 10:30:47 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8817@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Wed, 2009-11-04 at 12:51 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> > This is all spurious bracket addition; it doesn't really have any place
> > in a code fix.
> >
> > <Narasimha Reddy>: As we know that if we do not keep bracket
> > appropriately, some times compilers will behave differently and it may
> > use different instructions and evaluate differently. So to avoid those
> > kinds of issues, we added those brackets. It is not a code fix, but it
> > is compiler fix (compilers should not interpret differently). If
> > compiler interprets differently then the logic may behave differently
> > as against to your intentional behavior.  I hope you agree with me.
> 
> Not really ... in principle we try to fix the compilers rather than work
> around their bugs.  Which compilers are exhibiting the problem? ...
> because they'll affect more than just aacraid.
> 
> <Narasimha Reddy>
> 
> I hope you agree with Stefen's explanation.

Yes ... rechecked the code I'd missed the operator precedence problem
with :?

>  Generally, gnu compilers are buggy so the expression after the patch
> is more transparent and right one.

Well, generally gnu compilers aren't buggy ... plus this is a red
herring.  The operator precedence is defined by standard to be the same
for all compilers, so they would all interpret the expressions you're
changing in the same way.

> That is how a good c-programmer has to do to avoid such kind of
> issues. That is what we have done in the patch.

The issue, surely, is a simple operator precedence related bug ... it's
nothing to do with programmer practice or compilers.

> > > @@ -842,13 +842,22 @@ static int aac_get_pci_info(struct aac_d
> > >  int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
> > >  {
> > >         int status;
> > > +       unsigned long mflags;
> > >
> > >         /*
> > >          *      HBA gets first crack
> > >          */
> > >
> > > +       spin_lock_irqsave(&dev->manage_lock, mflags);
> > > +       if (dev->management_fib_count > AAC_NUM_MGT_FIB) {
> > > +               printk(KERN_INFO "No management Fibs Available:%d\n",
> > > +                                               dev->management_fib_count);
> > > +               spin_unlock_irqrestore(&dev->manage_lock, mflags);
> > > +               return -EBUSY;
> > > +       }
> > > +       spin_unlock_irqrestore(&dev->manage_lock, mflags);
> > >         status = aac_dev_ioctl(dev, cmd, arg);
> >
> > I can see what you're trying to do: limit the number of ioctl created
> > fibs to prevent starvation, but this mechanism is completely racy.  The
> > check is too far away from the increment.  It looks fixable just by
> > doing the increment within the lock here and decrementing if something
> > fails.
> >
> >
> > <Narasimha Reddy>: My intention is not to prevent starvation, but my
> > intention is that management fibs should not cross more than
> > "AAC_NUM_MGT_FIB". During our testing, we have seen any racy
> > condition.
> 
> The race is pretty obvious.  You lock check and drop the lock.  Multiple
> threads can go through that code at the same time, pass and then take
> the count above AAC_NUM_MGT_FIB.
> 
> I think currently you may have a mediation on the BKL which will
> mitigate this race, but that would go when the BKL is removed, so you
> need to be ready for that.
> 
> 
> <Narasimha Reddy> we will keep this in mind and we watch it during our
> testing. If we see such kind of issue then we will do appropriate
> changes and give you a separate small patch.

Why not just fix it now rather than wait for problems to appear due to
an unrelated change at a later time.  To make this cast iron, you do:

       spin_lock_irqsave(&dev->manage_lock, mflags);
       if (dev->management_fib_count > AAC_NUM_MGT_FIB) {
               printk(KERN_INFO "No management Fibs Available:%d\n",
                                           dev->management_fib_count);
               spin_unlock_irqrestore(&dev->manage_lock, mflags);
               return -EBUSY;
       }
       dev->management_fib_count++;
       spin_unlock_irqrestore(&dev->manage_lock, mflags);

and decrement under lock on every exit path (or even and more simply use
a counting semaphore).

James


