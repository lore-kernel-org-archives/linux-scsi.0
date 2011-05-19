From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
	merge
Date: Thu, 19 May 2011 13:03:39 -0700
Message-ID: <1305835419.32066.20.camel@haakon2.linux-iscsi.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
	 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
	 <20110518170556.GB2595@obsidianresearch.com>
	 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
	 <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
	 <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
	 <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rmda <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-19 at 12:40 +0200, Bart Van Assche wrote:
> On Thu, May 19, 2011 at 6:18 AM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > The srpt_port->port_wwn patch in question does
> > current ensure that sport->enabled has been set via an configfs
> > attribute at:
> >
> >   /sys/kernel/config/target/srpt/$IB_PORT_GUID/tpgt_1/enable
> >
> > and will reject all SRP login attempts to an individual struct srpt_port
> > until the attribute has been explictly triggered.
> >
> > This allows ib_srpt to follow what is expected by rtsadmin-v2 +
> > lio-utils, and used to generate /etc/target/srpt_start.sh used to save
> > persistent fabric configuration.  Currently other fabrics like
> > iscsi-target and tcm_qla2xxx expect to be able to reject fabric login
> > requests before the full set of WWPN endpoints, LUNs, NodeACLs +
> > MappedLUNs have been recreated during an typical init.d/target start
> > operation.
> >
> > I think it makes sense to do the same for the SRPT control plane on an
> > individual HCA port GUID basis as long as there are no underlying fabric
> > issues, and that Roland is happy.  In terms of supporting more than one
> > type of /sys/kernel/config/target/srpt/$WWPN/$TPGT/ layout, I would
> > really like to avoid this for mainline code unless there is a really
> > good reason..
> 
> I'm still wondering whether it was a good idea to switch from ib<n>
> style names to port GIDs. Not only will that make it hard for users to
> match the ib<n> names already assigned to InfiniBand HCAs with target
> port names but this also deviates from the naming scheme used for any
> other Linux device. Ethernet devices e.g. appear as eth<n> in /dev
> instead of a MAC address like 00:1a:64:10:18:6f.
> 

So from the user perspective in rtsadmin/rtslib, the Port GUIDs are
automatically presented in long-form after being extracted and parsed
from /sys/class/infiniband/*/ports/*/gids/0 input via ib_srpt.spec here:

http://www.linux-iscsi.org/wiki/SCSI_RDMA_Protocol/RTSadmin#Specification_file

The available IB Port GUIs appear as <TAB> completable input
in /ib_srpt/ during a 'create wwn=' operation shown here:

http://www.linux-iscsi.org/wiki/SCSI_RDMA_Protocol/RTSadmin#Configuration

There is no reason why we can't present a more verbose informational
display based on individual available HW fabric WWPNs. Eg: things like
HW port status information, driver, firmware rev, etc..

So aside from the user side of things, I think using a IB Port GUID
makes more sense to ensure that /sys/kernel/config/target/srpt/
configuration does not depend upon the ordering of symbolic HCA names
in /sys/class/infiniband/, which AFAIK are not guarenteed to be
persistent as HCAs are added/removed from the system.

Ensuring that we can reference target fabric WWPNs using an underlying
HW reference instead of a symbolic name is important for this reason,
and is currently how other HW target mode drivers including
tcm_fc(openfcoe) currently function.

Thanks,

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
