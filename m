From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 20:40:28 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>
 <1126974325.10413.5.camel@max> <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
 <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:32713 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932133AbVIRRfG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 13:35:06 -0400
In-Reply-To: <432D8515.9010809@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sun, 18 Sep 2005, Mike Christie wrote:

> Mike Christie wrote:
> > > I tested this but it does not quite work: there are now two retries
> > > in the same test that previously gave six retries. Unfortunately I
> > > don't just now have time to study the problem further.
> > > 
> > 
> > ok I will try to look into it.
> > 
> 
> Oh I bet it is from the change that James B noticed. With scsi_do_req() we
> passed in the sr_done function, but with scsi_execute* we pass in the requests
> end_io function. So with scsi_do_req, when we complete a command in
> scsi_finish_command()  (where it calls cmd->done) we would call the done
> function passed into scsi_do_req(), but with scsi_execute* we call
> scsi_io_completion.
> 
Possible.

> Maybe it could be solved by having st implement a cmd->done function like sd.c
> that gets set in the init_command callout. Since all the commands will be
> coming down as REQ_BLOCK_PC commands, st can set the scsi_cmnd->done function
> and decide what to do there. Or maybe some of the scsi_io_completion logic
> needs to be fixed. What was the command that is causing the problems?

init_command() is _not_ called. I added a printk to it and it did not 
print anything. If you look at scsi_prep_fn(), init_command() is called 
only if req->rq_disk is set. scsi_execute_async() does not set it.

Setting command parameters through the separate init_command() function 
seems like a horrible idea. You have to do hacks to pass the information.

The command triggering these problems is a 6-byte read of 10240 bytes. It 
should not a this point return anything but finish with some sense data.

I am debugging the problem but it is going slowly because the system disk 
is a SCSI disk. I have to be careful with the debugging output and changes 
outside st.c require a reboot ;-) So far I have found out that 
scsi_check_sense() is called correctly and returns SUCCESS as it should. 
What happens after that is a mystery.

-- 
Kai
