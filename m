From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 15:16:20 -0800
Message-ID: <1202166980.11265.665.camel@haakon2.linux-iscsi.org>
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
	 <1202166745.11265.662.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:46290 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755777AbYBDXQt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:16:49 -0500
In-Reply-To: <1202166745.11265.662.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Julian Satran <Julian_Satran@il.ibm.com>

On Mon, 2008-02-04 at 15:12 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2008-02-04 at 17:00 -0600, James Bottomley wrote:
> > On Mon, 2008-02-04 at 22:43 +0000, Alan Cox wrote:
> > > > better. So for example, I personally suspect that ATA-over-ethe=
rnet is way=20
> > > > better than some crazy SCSI-over-TCP crap, but I'm biased for s=
imple and=20
> > > > low-level, and against those crazy SCSI people to begin with.
> > >=20
> > > Current ATAoE isn't. It can't support NCQ. A variant that did NCQ=
 and IP
> > > would probably trash iSCSI for latency if nothing else.
> >=20
> > Actually, there's also FCoE now ... which is essentially SCSI
> > encapsulated in Fibre Channel Protocols (FCP) running over ethernet=
 with
> > Jumbo frames.  It does the standard SCSI TCQ, so should answer all =
the
> > latency pieces.  Intel even has an implementation:
> >=20
> > http://www.open-fcoe.org/
> >=20
> > I tend to prefer the low levels as well.  The whole disadvantage fo=
r IP
> > as regards iSCSI was the layers of protocols on top of it for
> > addressing, authenticating, encrypting and finding any iSCSI device
> > anywhere in the connected universe.
>=20
> Btw, while simple in-band discovery of iSCSI exists, the standards ba=
sed
> IP storage deployments (iSCSI and iFCP) use iSNS (RFC-4171) for
> discovery and network fabric management, for things like sending stat=
e
> change notifications when a particular network portal is going away s=
o
> that the initiator can bring up a different communication patch to a
> different network portal, etc.
>=20
> >=20
> > I tend to see loss of routing from operating at the MAC level to be=
 a
> > nicely justifiable tradeoff (most storage networks tend to be hubbe=
d or
> > switched anyway).  Plus an ethernet MAC with jumbo frames is a larg=
e
> > framed nearly lossless medium, which is practically what FCP is
> > expecting.  If you really have to connect large remote sites ... we=
ll
> > that's what tunnelling bridges are for.
> >=20
>=20
> Some of the points by Julo on the IPS TWG iSCSI vs. FCoE thread:
>=20
>       * the network is limited in physical span and logical span (num=
ber
>         of switches)
>       * flow-control/congestion control is achieved with a mechanism
>         adequate for a limited span network (credits). The packet los=
s
>         rate is almost nil and that allows FCP to avoid using a
>         transport (end-to-end) layer
>       * FCP she switches are simple (addresses are local and the memo=
ry
>         requirements cam be limited through the credit mechanism)
>       * The credit mechanisms is highly unstable for large networks
>         (check switch vendors planning docs for the network diameter
>         limits) =E2=80=93 the scaling argument
>       * Ethernet has no credit mechanism and any mechanism with a
>         similar effect increases the end point cost. Building a
>         transport layer in the protocol stack has always been the
>         preferred choice of the networking community =E2=80=93 the co=
mmunity
>         argument
>       * The "performance penalty" of a complete protocol stack has
>         always been overstated (and overrated). Advances in protocol
>         stack implementation and finer tuning of the congestion contr=
ol
>         mechanisms make conventional TCP/IP performing well even at 1=
0
>         Gb/s and over. Moreover the multicore processors that become
>         dominant on the computing scene have enough compute cycles
>         available to make any "offloading" possible as a mere code
>         restructuring exercise (see the stack reports from Intel, IBM
>         etc.)
>       * Building on a complete stack makes available a wealth of
>         operational and management mechanisms built over the years by
>         the networking community (routing, provisioning, security,
>         service location etc.) =E2=80=93 the community argument
>       * Higher level storage access over an IP network is widely
>         available and having both block and file served over the same
>         connection with the same support and management structure is
>         compelling=E2=80=93 the community argument
>       * Highly efficient networks are easy to build over IP with opti=
mal
>         (shortest path) routing while Layer 2 networks use bridging a=
nd
>         are limited by the logical tree structure that bridges must
>         follow. The effort to combine routers and bridges (rbridges) =
is
>         promising to change that but it will take some time to finali=
ze
>         (and we don't know exactly how it will operate). Untill then =
the
>         scale of Layer 2 network is going to seriously limited =E2=80=
=93 the
>         scaling argument
>=20

Another data point from the "The "performance penalty of a complete
protocol stack has always been overstated (and overrated)" bullet above=
:

"As a side argument =E2=80=93 a performance comparison made in 1998 sho=
wed SCSI
over TCP (a predecessor of the later iSCSI) to perform better than FCP
at 1Gbs for block sizes typical for OLTP (4-8KB). That was what
convinced us to take the path that lead to iSCSI =E2=80=93 and we used =
plain
vanilla x86 servers with plain-vanilla NICs and Linux (with similar
measurements conducted on Windows)."

--nab


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
