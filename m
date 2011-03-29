From: <Shyam_Iyer@Dell.com>
Subject: RE: Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 04:39:28 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D15702659D00AB@BLRX7MCDC203.AMER.DELL.COM>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110329202353.GG21671@redhat.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: linux-scsi@vger.kernel.org, lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com, vgoyal@redhat.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Tuesday, March 29, 2011 4:24 PM
> To: Iyer, Shyam
> Cc: linux-scsi@vger.kernel.org; lsf@lists.linux-foundation.org; linux-
> fsdevel@vger.kernel.org; rwheeler@redhat.com; vgoyal@redhat.com;
> device-mapper development
> Subject: Re: Preliminary Agenda and Activities for LSF
> 
> On Tue, Mar 29 2011 at  4:12pm -0400,
> Shyam_Iyer@dell.com <Shyam_Iyer@dell.com> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > > Sent: Tuesday, March 29, 2011 4:00 PM
> > > To: Iyer, Shyam
> > > Cc: vgoyal@redhat.com; lsf@lists.linux-foundation.org; linux-
> > > scsi@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > rwheeler@redhat.com; device-mapper development
> > > Subject: Re: Preliminary Agenda and Activities for LSF
> > >
> > > On Tue, Mar 29 2011 at  3:13pm -0400,
> > > Shyam_Iyer@dell.com <Shyam_Iyer@dell.com> wrote:
> > >
> > > > > > > Above is pretty generic. Do you have specific
> > > needs/ideas/concerns?
> > > > > > >
> > > > > > > Thanks
> > > > > > > Vivek
> > > > > > Yes.. if I limited by Ethernet b/w to 40% I don't need to
> limit
> > > I/O
> > > > > b/w via cgroups. Such bandwidth manipulations are network
> switch
> > > driven
> > > > > and cgroups never take care of these events from the Ethernet
> > > driver.
> > > > >
> > > > > So if IO is going over network and actual bandwidth control is
> > > taking
> > > > > place by throttling ethernet traffic then one does not have to
> > > specify
> > > > > block cgroup throttling policy and hence no need for cgroups to
> be
> > > > > worried
> > > > > about ethernet driver events?
> > > > >
> > > > > I think I am missing something here.
> > > > >
> > > > > Vivek
> > > > Well.. here is the catch.. example scenario..
> > > >
> > > > - Two iSCSI I/O sessions emanating from Ethernet ports eth0, eth1
> > > multipathed together. Let us say round-robin policy.
> > > >
> > > > - The cgroup profile is to limit I/O bandwidth to 40% of the
> > > multipathed I/O bandwidth. But the switch may have limited the I/O
> > > bandwidth to 40% for the corresponding vlan associated with one of
> the
> > > eth interface say eth1
> > > >
> > > > The computation that the bandwidth configured is 40% of the
> available
> > > bandwidth is false in this case.  What we need to do is possibly
> push
> > > more I/O through eth0 as it is allowed to run at 100% of bandwidth
> by
> > > the switch.
> > > >
> > > > Now this is a dynamic decision and multipathing layer should take
> > > care of it.. but it would need a hint..
> > >
> > > No hint should be needed.  Just use one of the newer multipath path
> > > selectors that are dynamic by design: "queue-length" or "service-
> time".
> > >
> > > This scenario is exactly what those path selectors are meant to
> > > address.
> > >
> > > Mike
> >
> > Since iSCSI multipaths are essentially sessions one could configure
> > more than one session through the same ethX interface. The sessions
> > need not be going to the same LUN and hence not governed by the same
> > multipath selector but the bandwidth policy group would be for a
> group
> > of resources.
> 
> Then the sessions don't correspond to the same backend LUN (and by
> definition aren't part of the same mpath device).  You're really all
> over the map with your talking points.
> 
> I'm having a hard time following you.
> 
> Mike

Let me back up here.. this has to be thought in not only the traditional Ethernet sense but also in a Data Centre Bridged environment. I shouldn't have wandered into the multipath constructs..

I think the statement on not going to the same LUN was a little erroneous. I meant different /dev/sdXs.. and hence different block I/O queues.

Each I/O queue could be thought of as a bandwidth queue class being serviced through a corresponding network adapter's queue(assuming a multiqueue capable adapter)

Let us say /dev/sda(Through eth0) and /dev/sdb(eth1) are a cgroup bandwidth group corresponding to a weightage of 20% of the I/O bandwidth the user has configured this weight thinking that this will correspond to say 200Mb of bandwidth.

Let us say the network bandwidth on the corresponding network queues corresponding was reduced by the DCB capable switch...
We still need an SLA of 200Mb of I/O bandwidth but the underlying dynamics have changed.

In such a scenario the option is to move I/O to a different bandwidth priority queue in the network adapter. This could be moving I/O to a new network queue in eth0 or another queue in eth1 .. 

This requires mapping the block queue to the new network queue.

One way of solving this is what is getting into the open-iscsi world i.e. creating a session tagged to the relevant DCB priority and thus the session gets mapped to the relevant tc queue which ultimately maps to one of the network adapters multiqueue..

But when multipath fails over to the different session path then the DCB bandwidth priority will not move with it..

Ok one could argue that is a user mistake to have configured bandwidth priorities differently but it may so happen that the bandwidth priority was just dynamically changed by the switch for the particular queue.

Although I gave an example of a DCB environment but we could definitely look at doing a 1:n map of block queues to network adapter queues for non-DCB environments too..


-Shyam

