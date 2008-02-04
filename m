From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 15:12:25 -0800
Message-ID: <1202166745.11265.662.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core>
	 <1202166033.3096.141.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:30407 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755935AbYBDXMz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:12:55 -0500
In-Reply-To: <1202166033.3096.141.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Julian Satran <Julian_Satran@il.ibm.com>

On Mon, 2008-02-04 at 17:00 -0600, James Bottomley wrote:
> On Mon, 2008-02-04 at 22:43 +0000, Alan Cox wrote:
> > > better. So for example, I personally suspect that ATA-over-ethern=
et is way=20
> > > better than some crazy SCSI-over-TCP crap, but I'm biased for sim=
ple and=20
> > > low-level, and against those crazy SCSI people to begin with.
> >=20
> > Current ATAoE isn't. It can't support NCQ. A variant that did NCQ a=
nd IP
> > would probably trash iSCSI for latency if nothing else.
>=20
> Actually, there's also FCoE now ... which is essentially SCSI
> encapsulated in Fibre Channel Protocols (FCP) running over ethernet w=
ith
> Jumbo frames.  It does the standard SCSI TCQ, so should answer all th=
e
> latency pieces.  Intel even has an implementation:
>=20
> http://www.open-fcoe.org/
>=20
> I tend to prefer the low levels as well.  The whole disadvantage for =
IP
> as regards iSCSI was the layers of protocols on top of it for
> addressing, authenticating, encrypting and finding any iSCSI device
> anywhere in the connected universe.

Btw, while simple in-band discovery of iSCSI exists, the standards base=
d
IP storage deployments (iSCSI and iFCP) use iSNS (RFC-4171) for
discovery and network fabric management, for things like sending state
change notifications when a particular network portal is going away so
that the initiator can bring up a different communication patch to a
different network portal, etc.

>=20
> I tend to see loss of routing from operating at the MAC level to be a
> nicely justifiable tradeoff (most storage networks tend to be hubbed =
or
> switched anyway).  Plus an ethernet MAC with jumbo frames is a large
> framed nearly lossless medium, which is practically what FCP is
> expecting.  If you really have to connect large remote sites ... well
> that's what tunnelling bridges are for.
>=20

Some of the points by Julo on the IPS TWG iSCSI vs. FCoE thread:

      * the network is limited in physical span and logical span (numbe=
r
        of switches)
      * flow-control/congestion control is achieved with a mechanism
        adequate for a limited span network (credits). The packet loss
        rate is almost nil and that allows FCP to avoid using a
        transport (end-to-end) layer
      * FCP she switches are simple (addresses are local and the memory
        requirements cam be limited through the credit mechanism)
      * The credit mechanisms is highly unstable for large networks
        (check switch vendors planning docs for the network diameter
        limits) =E2=80=93 the scaling argument
      * Ethernet has no credit mechanism and any mechanism with a
        similar effect increases the end point cost. Building a
        transport layer in the protocol stack has always been the
        preferred choice of the networking community =E2=80=93 the comm=
unity
        argument
      * The "performance penalty" of a complete protocol stack has
        always been overstated (and overrated). Advances in protocol
        stack implementation and finer tuning of the congestion control
        mechanisms make conventional TCP/IP performing well even at 10
        Gb/s and over. Moreover the multicore processors that become
        dominant on the computing scene have enough compute cycles
        available to make any "offloading" possible as a mere code
        restructuring exercise (see the stack reports from Intel, IBM
        etc.)
      * Building on a complete stack makes available a wealth of
        operational and management mechanisms built over the years by
        the networking community (routing, provisioning, security,
        service location etc.) =E2=80=93 the community argument
      * Higher level storage access over an IP network is widely
        available and having both block and file served over the same
        connection with the same support and management structure is
        compelling=E2=80=93 the community argument
      * Highly efficient networks are easy to build over IP with optima=
l
        (shortest path) routing while Layer 2 networks use bridging and
        are limited by the logical tree structure that bridges must
        follow. The effort to combine routers and bridges (rbridges) is
        promising to change that but it will take some time to finalize
        (and we don't know exactly how it will operate). Untill then th=
e
        scale of Layer 2 network is going to seriously limited =E2=80=93=
 the
        scaling argument

Perhaps it would be of worth to get some more linux-net guys in on the
discussion.  :-)

--nab


> James
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
