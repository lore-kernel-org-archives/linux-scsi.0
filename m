From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 09:02:01 -0500
Message-ID: <1301493722.2618.1.camel@mulgrave.site>
References: <1301373398.2590.20.camel@mulgrave.site>
	 <4D91BF90.8070909@redhat.com>
	 <DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>
	 <20110329173338.GD24485@redhat.com>
	 <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>
	 <20110329184501.GG24485@redhat.com>
	 <DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>
	 <20110329195953.GD21671@redhat.com>
	 <DBFB1B45AF80394ABD1C807E9F28D15702659D004B@BLRX7MCDC203.AMER.DELL.COM>
	 <20110329202353.GG21671@redhat.com>
	 <DBFB1B45AF80394ABD1C807E9F28D15702659D00AB@BLRX7MCDC203.AMER.DELL.COM>
	 <4D92C691.9070607@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51316 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838Ab1C3OCG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 10:02:06 -0400
In-Reply-To: <4D92C691.9070607@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Shyam_Iyer@dell.com, linux-scsi@vger.kernel.org, lsf@lists.linux-foundation.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com

On Wed, 2011-03-30 at 07:58 +0200, Hannes Reinecke wrote:
> On 03/30/2011 01:09 AM, Shyam_Iyer@dell.com wrote:
> >
> > Let me back up here.. this has to be thought in not only the traditional Ethernet
>  > sense but also in a Data Centre Bridged environment. I shouldn't 
> have wandered
>  > into the multipath constructs..
> >
> > I think the statement on not going to the same LUN was a little erroneous. I meant
>  > different /dev/sdXs.. and hence different block I/O queues.
> >
> > Each I/O queue could be thought of as a bandwidth queue class being serviced through
>  > a corresponding network adapter's queue(assuming a multiqueue 
> capable adapter)
> >
> > Let us say /dev/sda(Through eth0) and /dev/sdb(eth1) are a cgroup bandwidth group
>  > corresponding to a weightage of 20% of the I/O bandwidth the user 
> has configured
>  > this weight thinking that this will correspond to say 200Mb of 
> bandwidth.
> >
> > Let us say the network bandwidth on the corresponding network queues corresponding
>  > was reduced by the DCB capable switch...
> > We still need an SLA of 200Mb of I/O bandwidth but the underlying dynamics have changed.
> >
> > In such a scenario the option is to move I/O to a different bandwidth priority queue
>  > in the network adapter. This could be moving I/O to a new network 
> queue in eth0 or
>  > another queue in eth1 ..
> >
> > This requires mapping the block queue to the new network queue.
> >
> > One way of solving this is what is getting into the open-iscsi world i.e. creating
>  > a session tagged to the relevant DCB priority and thus the 
> session gets mapped
>  > to the relevant tc queue which ultimately maps to one of the 
> network adapters multiqueue..
> >
> > But when multipath fails over to the different session path then the DCB bandwidth
>  > priority will not move with it..
> >
> > Ok one could argue that is a user mistake to have configured bandwidth priorities
>  > differently but it may so happen that the bandwidth priority was 
> just dynamically
>  > changed by the switch for the particular queue.
> >
> > Although I gave an example of a DCB environment but we could definitely look at
>  > doing a 1:n map of block queues to network adapter queues for 
> non-DCB environments too..
> >
> That sounds quite convoluted enough to warrant it's own slot :-)
> 
> No, seriously. I think it would be good to have a separate slot 
> discussing DCB (be it FCoE or iSCSI) and cgroups.
> And how to best align these things.

OK, I'll go for that ... Data Centre Bridging; experiences, technologies
and needs ... something like that.  What about virtualisation and open
vSwitch?

James


