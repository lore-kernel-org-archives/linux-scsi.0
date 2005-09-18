From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 22:03:13 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>
 <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>
 <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max>
 <432D97F2.5040508@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:17564 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932168AbVIRS5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 14:57:52 -0400
In-Reply-To: <432D97F2.5040508@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sun, 18 Sep 2005, Mike Christie wrote:

> Mike Christie wrote:
> > On Sun, 2005-09-18 at 20:40 +0300, Kai Makisara wrote:
> > 
> > > The command triggering these problems is a 6-byte read of 10240 bytes.
> > > It should not a this point return anything but finish with some sense
> > > data.
> > > 
> > > I am debugging the problem but it is going slowly because the system
> > > disk is a SCSI disk. I have to be careful with the debugging output
> > > and changes outside st.c require a reboot ;-) So far I have found out
> > > that scsi_check_sense() is called correctly and returns SUCCESS as it
> > > should. What happens after that is a mystery.
> > > 
> > 
> > 
> > I think something like this would give us something like the old
> > behavior back. This way we do not let scsi_io_completion further process
> > the error.
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1126,7 +1126,7 @@ static int scsi_issue_flush_fn(request_q
> > static void scsi_generic_done(struct scsi_cmnd *cmd)
> > {
> > 	BUG_ON(!blk_pc_request(cmd->request));
> > -	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
> > +	scsi_io_completion(cmd, cmd->bufflen, 0);
> > }
> > 
> > static int scsi_prep_fn(struct request_queue *q, struct request *req)
> > 
> 
> this is over 1-6 of my other patches.
> 
This solves the problem. All works properly and if I try some mt command 
after filemark detection, the residual is correctly zero.

This change solving problems also explains what I have seen today. Before 
your message I had found out that all three commands (the one that should 
have been executed and the two retries) were fetched from the queue in the 
normal way. Eh did not have anything to do with them. The command was 
using dio and 10240 bytes needs three pages => two retries.

Fixing passing the retries did not actually have anything to do with this 
exact problem. However, I think that the retries parameter should be 
obeyed if it is in the interface.

-- 
Kai
