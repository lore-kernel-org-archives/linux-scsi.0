From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
Date: Mon, 22 Sep 2014 13:58:52 -0700
Message-ID: <1411419532.24986.36.camel@haakon3.risingtidesystems.com>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com>
	 <1410822750-10717-5-git-send-email-agrover@redhat.com>
	 <1411161279.23258.26.camel@haakon3.risingtidesystems.com>
	 <lvi81j$ud8$2@ger.gmane.org>
	 <1411169965.23258.45.camel@haakon3.risingtidesystems.com>
	 <lvifie$emi$3@ger.gmane.org> <541CCBD1.8050606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <541CCBD1.8050606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Alex Elsayed <eternaleye@gmail.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-09-19 at 17:35 -0700, Andy Grover wrote:
> On 09/19/2014 04:51 PM, Alex Elsayed wrote:
> 
> >> Not sure I follow..  How does the proposed passthrough mode prevent
> >> someone from emulating OSDs, media changers, optical disks or anything
> >> else in userspace with TCMU..?
> >>
> >> The main thing that the above comments highlight is why attempting to
> >> combine the existing in-kernel emulation with a userspace backend
> >> providing it's own emulation can open up a number of problems with
> >> mismatched state between the two.
> >
> > It doesn't prevent it, but it _does_ put it in the exact same place as PSCSI
> > regarding the warnings on the wiki. It means that if someone wants to
> > implement (say) the optical disc or OSD CDBs, they then lose out on ALUA &co
> > unless they implement it themselves - which seems unnecessary and painful,
> > since those should really be disjoint. In particular, an OSD backed by RADOS
> > objects could be a very nice thing indeed, _and_ could really benefit from
> > ALUA.
> 
> Some possible solutions:
> 
> 1) The first time TCMU sees an opcode it passes it up and notes whether 
> it is handled or not. If it was handled then future cmds with that 
> opcode are passed up but not retried in the kernel. If it was not 
> handled then it and all future commands with that opcode are handled by 
> the kernel and not passed up.
> 

I'd rather avoid having to keep around a bunch of extra per-device
state, and having to send all opcodes out to user-space first is messy.

> 2) Same as #1 but TCMU operates on SCSI spec granularity - e.g. handling 
> any SSC opcode means userspace must handle all SSC commands.
> 

It's unclear how effective this will ultimately be, given that some
different standards include EVPD and/or mode pages specific to the
peripheral type.

> 3) Like #2 but define opcode groupings that must all be implemented 
> together, independent of the specifications.
> 

This is overly complex, and defining the groups of opcodes is
problematic to maintain.

> 4) Have passthrough mode set at creation, but with more than two modes, 
> either grouped by SCSI spec or our own groupings.
> 

Passthrough mode set at creation is the correct default, but grouping
things by SCSI spec and custom opcode groupings doesn't really make alot
of sense to me.

> 5) Never pass up certain opcodes, like the ALUA ones or whatever.
> 

This hurts flexibility, given that some folks might already have their
own ALUA implemented in a user-space driver, and would like to be able
to run in pure passthrough mode.

So I'd still like to start for an initial merge with the two different
modes mentioned earlier.  The pure-passthrough mode where everything is
handled by user-space, and an I/O passthrough mode where only
SCF_SCSI_DATA_CDB is passed along to userspace, but all other control
CDBs are handled by existing in-kernel emulation.

Andy, can you re-spin a series with these two approaches in mind..?

--nab
