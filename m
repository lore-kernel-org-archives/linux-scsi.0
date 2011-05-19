From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
Date: Thu, 19 May 2011 12:40:02 +0200
Message-ID: <BANLkTi=Xb-ypQNa3=MmwiLeE4Q9FWHnZXg@mail.gmail.com>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
 <BANLkTi=e+v7PLcSc8GNov-TOXFF7rurXew@mail.gmail.com> <20110518170556.GB2595@obsidianresearch.com>
 <BANLkTimQXU0u5gtRzXsnsB=sCF-bvpY+Ag@mail.gmail.com> <BANLkTi==bZ0h3o5FNrg8PSJFp6F-zh5hTA@mail.gmail.com>
 <1305778694.2856.533.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305778694.2856.533.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rmda <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 19, 2011 at 6:18 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> The srpt_port->port_wwn patch in question does
> current ensure that sport->enabled has been set via an configfs
> attribute at:
>
> =A0 /sys/kernel/config/target/srpt/$IB_PORT_GUID/tpgt_1/enable
>
> and will reject all SRP login attempts to an individual struct srpt_p=
ort
> until the attribute has been explictly triggered.
>
> This allows ib_srpt to follow what is expected by rtsadmin-v2 +
> lio-utils, and used to generate /etc/target/srpt_start.sh used to sav=
e
> persistent fabric configuration. =A0Currently other fabrics like
> iscsi-target and tcm_qla2xxx expect to be able to reject fabric login
> requests before the full set of WWPN endpoints, LUNs, NodeACLs +
> MappedLUNs have been recreated during an typical init.d/target start
> operation.
>
> I think it makes sense to do the same for the SRPT control plane on a=
n
> individual HCA port GUID basis as long as there are no underlying fab=
ric
> issues, and that Roland is happy. =A0In terms of supporting more than=
 one
> type of /sys/kernel/config/target/srpt/$WWPN/$TPGT/ layout, I would
> really like to avoid this for mainline code unless there is a really
> good reason..

I'm still wondering whether it was a good idea to switch from ib<n>
style names to port GIDs. Not only will that make it hard for users to
match the ib<n> names already assigned to InfiniBand HCAs with target
port names but this also deviates from the naming scheme used for any
other Linux device. Ethernet devices e.g. appear as eth<n> in /dev
instead of a MAC address like 00:1a:64:10:18:6f.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
