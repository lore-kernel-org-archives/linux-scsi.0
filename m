From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: question about drivers/scsi/scsi_transport_fc.c
Date: Thu, 2 Sep 2010 16:28:36 +0200
Message-ID: <20100902142835.GA4992@schmichrtp.mainz.de.ibm.com>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
 <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
 <4C7FA91B.60607@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35107 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0IBO2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 10:28:43 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id o82ESbix007083
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 14:28:37 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o82ESbxk3944654
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 16:28:37 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o82ESasq003023
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 16:28:36 +0200
Content-Disposition: inline
In-Reply-To: <4C7FA91B.60607@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Julia Lawall <julia@diku.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, joe@perches.com, James Smart <James.Smart@Emulex.Com>

On Thu, Sep 02, 2010 at 03:39:39PM +0200, Hannes Reinecke wrote:
> Christof Schmitt wrote:
> > On Sat, Aug 28, 2010 at 07:11:12PM +0200, Julia Lawall wrote:
> >> The function fc_bsg_goose_queue in the file drivers/scsi/scsi_transport_fc.c
> >> contains the following code:
> >>
> >>         flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
> >>                   !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> >>
> >> I have the impression that this is always 0.  QUEUE_FLAG_REENTER is 
> >> defined with quite a lot of other constants, so I don't really have a 
> >> guess as to what was intended.
> > 
> > I just came across the code in scsi_run_queue in
> > drivers/scsi/scsi_lib.c. It looks like the check of QUEUE_FLAG_REENTER
> > in fc_bsg_goose_queue is modeled after the check in scsi_run_queue.
> > 
> > The check in scsi_run_queue has been introduced with this commit,
> > maybe this helps understanding the code:
> > 
> > commit 04846f25920d4b05d6040c531cc601049260db52
> > Author: Andreas Herrmann <aherrman@de.ibm.com>
> > Date:   Wed Aug 9 17:31:16 2006 +0200
> > 
> >     [SCSI] limit recursion when flushing shost->starved_list
> > 
> Then it's still wrong. The above commit has:
> 
> +               if (test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
> +                   !test_and_set_bit(QUEUE_FLAG_REENTER,
> +                                     &sdev->request_queue->queue_flags)) {
> 
> Which is slightly different than the above. Looks like a copy and past error.

I missed one commit that changed the locking and the flag handling:

commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e
Author: Nick Piggin <npiggin@suse.de>
Date:   Tue Apr 29 14:48:33 2008 +0200

    block: make queue flags non-atomic

This one introduced
+               spin_lock(sdev->request_queue->queue_lock);
+               flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
+                               !test_bit(QUEUE_FLAG_REENTER,
+				&sdev->request_queue->queue_flags);
which does not make sense to me, maybe it would be enough to test the
bit?

> It probably should read
> 
>          flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
>                    !test_and_set_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> 
> This was introduced by
> 
> commit 9e4f5e29610162fd426366f3b29e3cc6e575b858
> Author: James Smart <James.Smart@Emulex.Com>
> Date:   Thu Mar 26 13:33:19 2009 -0400
> 
>     [SCSI] FC Pass Thru support
> 
> so we should be blaming^Wasking him.

Or could the whole handling of the QUEUE_FLAG_REENTER simply be
removed from the SCSI and FC code? The flag is set before calling
__blk_run_queue, but this function already sets the flag internally to
avoid recursion.

--
Christof
