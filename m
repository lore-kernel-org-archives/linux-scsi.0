From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
	merge
Date: Wed, 18 May 2011 21:18:14 -0700
Message-ID: <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
	 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com>
	 <20110518170556.GB2595@obsidianresearch.com>
	 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com>
	 <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rmda <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-05-18 at 12:17 -0700, Roland Dreier wrote:
> On Wed, May 18, 2011 at 11:02 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> > Thanks for the feedback. I'm still wondering though about the
> > usefulness of disabling / enabling SRPT per HCA port. For the use
> > cases I know about SRP communication over all target ports will be
> > enabled as soon as target configuration has finished and more
> > fine-grained access configuration will occur by allowing/disallowing
> > certain initiators to log in.
> 
> I definitely think that allowing the flexibility to configure ports individually
> is required.  It's easy to imagine a case with a separate front-end and
> back-end networks on the two HCA ports (this would be a pretty normal
> ethernet config), where only one port should be a target port.
> 
> It may not be how people do things now but it should at least be possible.
> 

Hey guys,

Apologies for the slightly delay response here..  Just to clarify on
Bart's point above.  The srpt_port->port_wwn patch in question does
current ensure that sport->enabled has been set via an configfs
attribute at:

   /sys/kernel/config/target/srpt/$IB_PORT_GUID/tpgt_1/enable

and will reject all SRP login attempts to an individual struct srpt_port
until the attribute has been explictly triggered.

This allows ib_srpt to follow what is expected by rtsadmin-v2 +
lio-utils, and used to generate /etc/target/srpt_start.sh used to save
persistent fabric configuration.  Currently other fabrics like
iscsi-target and tcm_qla2xxx expect to be able to reject fabric login
requests before the full set of WWPN endpoints, LUNs, NodeACLs +
MappedLUNs have been recreated during an typical init.d/target start
operation.

I think it makes sense to do the same for the SRPT control plane on an
individual HCA port GUID basis as long as there are no underlying fabric
issues, and that Roland is happy.  In terms of supporting more than one
type of /sys/kernel/config/target/srpt/$WWPN/$TPGT/ layout, I would
really like to avoid this for mainline code unless there is a really
good reason..

Also, I think ib_srpt needs to properly support 'demo-mode' operation
in /var/target/fabric/ib_srpt.spec as this is very useful for testing
and development purposes.  I go ahead and get this added to upstream LIO
v4.1 in the next days and respin for mainline with Hch's review + Bart's
changes.

Thanks folks,

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
