From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 6 Nov 2002 15:45:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106204542.GF22177@redhat.com>
References: <patmans@us.ibm.com> <200211061747.gA6HlS803188@localhost.localdomain> <20021106102444.A11790@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021106102444.A11790@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 10:24:44AM -0800, Patrick Mansfield wrote:
> On Wed, Nov 06, 2002 at 12:47:28PM -0500, J.E.J. Bottomley wrote:
> > This is what I think needs to be done to the patch, does this look OK?
> > 
> > James
> 
> The only problem is that scsi_build_commandblocks() sets sdev->new_queue_depth 
> to 1, so if the slave_attach() does not set queue depth, we will leave
> it at 1, and the post-slave_attach call to scsi_adjust_queue_depth
> can never be hit.
> 
> It looks like the code could be removed from scsi_build_commandblocks,
> since (in this code path) we will always call scsi_adjust_queue_depth
> before sending IO, and other code paths always set new_queue_depth
> prior to calling scsi_build_commandblocks.
> 
> It would be nice if scsi_request_fn would abort IO if current_queue_depth
> == 0 or new_queue_depth == 0.
> 
> And yes, I missed scsi_syms.c.

Actually, I've been planning a slight API change to the slave_attach() 
lldd stuff.  Basically, if a host implements slave_attach(), then it 
*must* call adjust_queue_depth() on all devices passed to it, whether they 
are going to use tagged queueing or not.  They should either call 
adjust_queue_depth() with a tag parameter of non-0 and the actual depth 
they want, or with a tag parameter of 0 and 1 if they don't support 
multiple untagged commands at a time (many drivers call this linked 
commands even though they don't use the scsi protocol version of linking, 
they just queue the commands up internally and send them one after the 
other) or whatever number they support at one time on untagged devices.  
The rational for this involves me not liking wishy-washy if statements 
like what's in the scsi_slave_attach() right now.  Instead of:

if(host->hostt->slave_attach)
  host->hostt->slave_attach(device);
if ((sdev->new_queue_depth == 0) &&
    (sdev->host->cmd_per_lun != 0))
  scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
scsi_build_commandblocks(sdev);

(which can be tricked BTW, since some slave_attach() routines don't touch 
untagged devices and we set the new_queue_depth to 1 to enable scanning, 
we won't even set untagged devices to cmd_per_lun like our intent is), I 
would rather we did this:

if(host->hostt->slave_attach)
  blah;
else
  scsi_adjust_queue_depth(sdev, 0, cmd_per_lun);

with the requirement that slave attach always do the correct 
scsi_adjust_queue_depth.  Anyway, that's my preference.

Now, the second reason I want this is in preparation for another change I 
have planned.  This one I would like some discussion on anyway, so I'm 
bringing it up now:

I want to make the queuecommand() interface optional, with the ability to 
replace it with a combo of prepare_command() and send_command() instead.  
A driver can only define queuecommand() or the prepare,send_command() 
pair.  The obvious benefit is that a prepare then send routine is needed 
to make sequential untagged commands fast without having to implement a 
driver internal queue, and this is necessary for streaming devices that 
can't tolerate long delays between commands without falling out of their 
current stream (tapes, early CD-Rs and current very cheap CD-Rs, etc).  
Obviously, this new interface would require that driver authors actually 
think about things like sendable commands vs. just prepped commands, etc.  
Making them always call adjust queue depth is one way of forcing them to 
think about these issues, hence why I like requiring it in all 
slave_attach calls.  Thoughts?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
