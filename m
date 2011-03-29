From: <Shyam_Iyer@Dell.com>
Subject: RE: Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 01:42:03 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D15702659D004B@BLRX7MCDC203.AMER.DELL.COM>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>
 <20110329173338.GD24485@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>
 <20110329184501.GG24485@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>
 <20110329195953.GD21671@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110329195953.GD21671@redhat.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: vgoyal@redhat.com, lsf@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Tuesday, March 29, 2011 4:00 PM
> To: Iyer, Shyam
> Cc: vgoyal@redhat.com; lsf@lists.linux-foundation.org; linux-
> scsi@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> rwheeler@redhat.com; device-mapper development
> Subject: Re: Preliminary Agenda and Activities for LSF
> 
> On Tue, Mar 29 2011 at  3:13pm -0400,
> Shyam_Iyer@dell.com <Shyam_Iyer@dell.com> wrote:
> 
> > > > > Above is pretty generic. Do you have specific
> needs/ideas/concerns?
> > > > >
> > > > > Thanks
> > > > > Vivek
> > > > Yes.. if I limited by Ethernet b/w to 40% I don't need to limit
> I/O
> > > b/w via cgroups. Such bandwidth manipulations are network switch
> driven
> > > and cgroups never take care of these events from the Ethernet
> driver.
> > >
> > > So if IO is going over network and actual bandwidth control is
> taking
> > > place by throttling ethernet traffic then one does not have to
> specify
> > > block cgroup throttling policy and hence no need for cgroups to be
> > > worried
> > > about ethernet driver events?
> > >
> > > I think I am missing something here.
> > >
> > > Vivek
> > Well.. here is the catch.. example scenario..
> >
> > - Two iSCSI I/O sessions emanating from Ethernet ports eth0, eth1
> multipathed together. Let us say round-robin policy.
> >
> > - The cgroup profile is to limit I/O bandwidth to 40% of the
> multipathed I/O bandwidth. But the switch may have limited the I/O
> bandwidth to 40% for the corresponding vlan associated with one of the
> eth interface say eth1
> >
> > The computation that the bandwidth configured is 40% of the available
> bandwidth is false in this case.  What we need to do is possibly push
> more I/O through eth0 as it is allowed to run at 100% of bandwidth by
> the switch.
> >
> > Now this is a dynamic decision and multipathing layer should take
> care of it.. but it would need a hint..
> 
> No hint should be needed.  Just use one of the newer multipath path
> selectors that are dynamic by design: "queue-length" or "service-time".
> 
> This scenario is exactly what those path selectors are meant to
> address.
> 
> Mike

Since iSCSI multipaths are essentially sessions one could configure more than one session through the same ethX interface. The sessions need not be going to the same LUN and hence not governed by the same multipath selector but the bandwidth policy group would be for a group of resources.

-Shyam




