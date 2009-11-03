From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 03 Nov 2009 08:40:42 -0600
Message-ID: <1257259243.2728.4.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8572@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZKCOkq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 09:40:46 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8572@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Tue, 2009-11-03 at 15:47 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> This is all spurious bracket addition; it doesn't really have any place
> in a code fix.
> 
> <Narasimha Reddy>: As we know that if we do not keep bracket
> appropriately, some times compilers will behave differently and it may
> use different instructions and evaluate differently. So to avoid those
> kinds of issues, we added those brackets. It is not a code fix, but it
> is compiler fix (compilers should not interpret differently). If
> compiler interprets differently then the logic may behave differently
> as against to your intentional behavior.  I hope you agree with me.

Not really ... in principle we try to fix the compilers rather than work
around their bugs.  Which compilers are exhibiting the problem? ...
because they'll affect more than just aacraid.

> > @@ -842,13 +842,22 @@ static int aac_get_pci_info(struct aac_d
> >  int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
> >  {
> >         int status;
> > +       unsigned long mflags;
> >
> >         /*
> >          *      HBA gets first crack
> >          */
> >
> > +       spin_lock_irqsave(&dev->manage_lock, mflags);
> > +       if (dev->management_fib_count > AAC_NUM_MGT_FIB) {
> > +               printk(KERN_INFO "No management Fibs Available:%d\n",
> > +                                               dev->management_fib_count);
> > +               spin_unlock_irqrestore(&dev->manage_lock, mflags);
> > +               return -EBUSY;
> > +       }
> > +       spin_unlock_irqrestore(&dev->manage_lock, mflags);
> >         status = aac_dev_ioctl(dev, cmd, arg);
> 
> I can see what you're trying to do: limit the number of ioctl created
> fibs to prevent starvation, but this mechanism is completely racy.  The
> check is too far away from the increment.  It looks fixable just by
> doing the increment within the lock here and decrementing if something
> fails.
> 
> 
> <Narasimha Reddy>: My intention is not to prevent starvation, but my
> intention is that management fibs should not cross more than
> "AAC_NUM_MGT_FIB". During our testing, we have seen any racy
> condition.

The race is pretty obvious.  You lock check and drop the lock.  Multiple
threads can go through that code at the same time, pass and then take
the count above AAC_NUM_MGT_FIB.

I think currently you may have a mediation on the BKL which will
mitigate this race, but that would go when the BKL is removed, so you
need to be ready for that.

James

> Even no end user has reported such kind of problem. We have given a
> private build to end customers two months back. So far nobody reported
> the issue.
> 
> James
> 
> 
> 
> 
> DISCLAIMER:
> -----------------------------------------------------------------------------------------------------------------------
> 
> The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
> It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
> this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
> Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
> this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
> received this email in error please delete it and notify the sender immediately. Before opening any mail and 
> attachments please check them for viruses and defect.
> 
> -----------------------------------------------------------------------------------------------------------------------


