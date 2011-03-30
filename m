From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 07:58:41 +0200
Message-ID: <4D92C691.9070607@suse.de>
References: <1301373398.2590.20.camel@mulgrave.site>	<4D91BF90.8070909@redhat.com>	<DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>	<20110329173338.GD24485@redhat.com>	<DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>	<20110329184501.GG24485@redhat.com>	<DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>	<20110329195953.GD21671@redhat.com>	<DBFB1B45AF80394ABD1C807E9F28D15702659D004B@BLRX7MCDC203.AMER.DELL.COM>	<20110329202353.GG21671@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D15702659D00AB@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1C3F66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 01:58:58 -0400
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D15702659D00AB@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@dell.com
Cc: snitzer@redhat.com, linux-scsi@vger.kernel.org, lsf@lists.linux-foundation.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com

On 03/30/2011 01:09 AM, Shyam_Iyer@dell.com wrote:
>
> Let me back up here.. this has to be thought in not only the traditio=
nal Ethernet
 > sense but also in a Data Centre Bridged environment. I shouldn't=20
have wandered
 > into the multipath constructs..
>
> I think the statement on not going to the same LUN was a little erron=
eous. I meant
 > different /dev/sdXs.. and hence different block I/O queues.
>
> Each I/O queue could be thought of as a bandwidth queue class being s=
erviced through
 > a corresponding network adapter's queue(assuming a multiqueue=20
capable adapter)
>
> Let us say /dev/sda(Through eth0) and /dev/sdb(eth1) are a cgroup ban=
dwidth group
 > corresponding to a weightage of 20% of the I/O bandwidth the user=20
has configured
 > this weight thinking that this will correspond to say 200Mb of=20
bandwidth.
>
> Let us say the network bandwidth on the corresponding network queues =
corresponding
 > was reduced by the DCB capable switch...
> We still need an SLA of 200Mb of I/O bandwidth but the underlying dyn=
amics have changed.
>
> In such a scenario the option is to move I/O to a different bandwidth=
 priority queue
 > in the network adapter. This could be moving I/O to a new network=20
queue in eth0 or
 > another queue in eth1 ..
>
> This requires mapping the block queue to the new network queue.
>
> One way of solving this is what is getting into the open-iscsi world =
i.e. creating
 > a session tagged to the relevant DCB priority and thus the=20
session gets mapped
 > to the relevant tc queue which ultimately maps to one of the=20
network adapters multiqueue..
>
> But when multipath fails over to the different session path then the =
DCB bandwidth
 > priority will not move with it..
>
> Ok one could argue that is a user mistake to have configured bandwidt=
h priorities
 > differently but it may so happen that the bandwidth priority was=20
just dynamically
 > changed by the switch for the particular queue.
>
> Although I gave an example of a DCB environment but we could definite=
ly look at
 > doing a 1:n map of block queues to network adapter queues for=20
non-DCB environments too..
>
That sounds quite convoluted enough to warrant it's own slot :-)

No, seriously. I think it would be good to have a separate slot=20
discussing DCB (be it FCoE or iSCSI) and cgroups.
And how to best align these things.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
