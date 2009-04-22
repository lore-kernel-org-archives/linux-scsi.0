From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] dm mpath: Try recover from I/O failure by
	re-initializing  the PG if device is running on one path
Date: Wed, 22 Apr 2009 12:29:49 -0700
Message-ID: <1240428589.19442.14.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
	 <da824cf30904221041h40b87096yb4cb2784f31c5270@mail.gmail.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56953 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbZDVT3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 15:29:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3MJNjtv027408
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 13:23:45 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3MJTB93084384
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 13:29:11 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3MJT9xw012132
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 13:29:11 -0600
In-Reply-To: <da824cf30904221041h40b87096yb4cb2784f31c5270@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>


On Wed, 2009-04-22 at 10:41 -0700, Grant Grundler wrote:
> On Mon, Apr 20, 2009 at 11:05 AM, Moger, Babu <Babu.Moger@lsi.com> wrote:
> > This patch introduces the mechanism to recover from I/O failures by re-initializing the path if the device is running on only one path.
> >
> > Problem: Device mapper fails the path for every I/O error.
> > It does not care about the type of error.
> 
> This is the fundamental problem.  Different layers of the block IO
> path have to agree on how to handle each possible type of error that
> can be returned. I don't know where to find such an agreement and
> think an implementation that does discriminate is needed.
> 
> > There are certain errors which can be recovered by re-initializing the path again. I have seen this problem during my testing on rdac device handler. I have observed I/O errors when there is a change in Lun ownership. When Lun ownership changes device will return back with check condition with sense 0x05/0x94/0x01(SK/ASC/ASCQ -meaning Lun ownership changed). Currently, device mapper fails the path for this error and eventually this will lead to I/O error. We don't want to see I/O error for this reason.
> 
> 1) This patch isn't discriminating between transport, media, or other
> device errors. Wouldn't it make sense to discriminate?

yes it is. But currently we do not have it.

> "LUN ownership changed" sounds like some of the events possible in
> multi-inititiator enviroment would want to be notified about and
> perhaps even take some action (renegotiate access to
> 
> 2) Will this result in resetting a SATA device?
> I ask because device reset may result in data loss due to WCE enabled.
> I just don't know the higher parts of the block SW stack and how
> errors flow up the stack.

The device is not hung, the I/O will come back after a while.

BTW, activate doesn't do a reset, it just sends a command (in lsi rdac
case, it just sends a mode select) to the controller.

> 
> thanks,
> grant
> 
> >
> > The patch will set the flag pg_init_required if the device is running on single path. The process_queued_ios will re-initialize path if required. I have tested this patch on LSI rdac handler.
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > ---
> >
> > --- linux-2.6.30-rc2/drivers/md/dm-mpath.c.orig 2009-04-17 16:49:33.000000000 -0500
> > +++ linux-2.6.30-rc2/drivers/md/dm-mpath.c      2009-04-17 17:09:51.000000000 -0500
> > @@ -1152,6 +1152,15 @@ static int do_end_io(struct multipath *m
> >                return error;
> >
> >        spin_lock_irqsave(&m->lock, flags);
> > +       /*
> > +        * If this is the only path left, then lets try to
> > +        * re-initialize the PG one last time..
> > +        */
> > +       if (m->nr_valid_paths == 1 && m->hw_handler_name) {
> > +               m->pg_init_required = 1;
> > +               spin_unlock_irqrestore(&m->lock, flags);
> > +               goto requeue;
> > +       }
> >        if (!m->nr_valid_paths) {
> >                if (__must_push_back(m)) {
> >                        spin_unlock_irqrestore(&m->lock, flags);
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

