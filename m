From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 06 Nov 2002 16:19:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211062119.gA6LJFN04461@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA27578
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 13:19:19 -0800
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 06 Nov 2002 15:45:42 EST." <20021106204542.GF22177@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Actually, I've been planning a slight API change to the slave_attach()
>  lldd stuff.  Basically, if a host implements slave_attach(), then it
> *must* call adjust_queue_depth() on all devices passed to it, whether
> they  are going to use tagged queueing or not.

I agree.

dledford@redhat.com said:
> I  would rather we did this:
> if(host->hostt->slave_attach)
>   blah; else
>   scsi_adjust_queue_depth(sdev, 0, cmd_per_lun); 

I agree.  (That's what patrick just put in the patch for me).

> I want to make the queuecommand() interface optional, with the ability
> to  replace it with a combo of prepare_command() and send_command()
> instead.   A driver can only define queuecommand() or the
> prepare,send_command()  pair.  The obvious benefit is that a prepare
> then send routine is needed  to make sequential untagged commands fast
> without having to implement a  driver internal queue, and this is
> necessary for streaming devices that  can't tolerate long delays
> between commands without falling out of their  current stream (tapes,
> early CD-Rs and current very cheap CD-Rs, etc).   Obviously, this new
> interface would require that driver authors actually  think about
> things like sendable commands vs. just prepped commands, etc.   Making
> them always call adjust queue depth is one way of forcing them to
> think about these issues, hence why I like requiring it in all
> slave_attach calls.  Thoughts? 

Quite like the idea.  It should be possible to make it complement the 
request_prep_fn I'm doing for SCSI (this will force the upper level drivers to 
do early prepares on commands, so we can have the whole thing just waiting to 
shoot off as the completed command returns).

James


