From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Tue, 10 Jan 2006 13:11:00 -0500
Message-ID: <43C3F8B4.4090107@emulex.com>
References: <OFCC2A89CA.90DCC5D6-ON412570F1.008356CC-412570F1.0083D054@de.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:22238 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932327AbWAJSLN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 13:11:13 -0500
In-Reply-To: <OFCC2A89CA.90DCC5D6-ON412570F1.008356CC-412570F1.0083D054@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>



Andreas Herrmann wrote:
> Another general point of interest is fc_host_statistics for virtual
> and physical ports.
> 
> There are some stats (most or all non fc4 stats) that only make sense
> for the physical port. And there are the fc4 stats that might be
> determined for the virtual port.

Yep - good point.  Odds are, to make the mgmt apps happy, and as hbaapi
to date has no distinction about virtual ports - we probably want the
stats to reflect only the stats for the scsi_host. E.g Each virtual host
shows it's own. If the physical host shows no devices and can't be accessed
directly, then it could show aggregate stats. Otherwise, it should show
only the stats for the traffic it is initiating.

Looking at hbaapi, which the stats were tuned for, I would lean toward
replicating link state/type, etc of the physical link. We could introduce
a new type - npiv or nport_id_virt, so that you could tell at a glance it's
not a real link.

> 
> Having the (overkill) solution of a host for the physical port would
> help to sort things out. You could provide
> - complete fc_host_statistics for the physical port,
> - separate fc4 statistics for each virtual port.
> 
> Without a host for the physical port you have the choice between:
> 
> (a) providing same fc_host_statistics (of the physical port) for all
> virtual ports with the same permanent port name
> 
> (b) providing a combination of non fc4 stats of physical port and fc4
> stats of virtual port in fc_host_statistics for a virtual port
> 
> zfcp currently does (a) with one of the patches sent last week.

Yep. Getting frame-level counters out of hardware, sorted by context, is
difficult. So, what you are doing is not unreasonable. Hopefully we can
make this better in the future. In the meantime - the documentation for
each driver should spell out clearly what it's reporting.

> 
> Implementing (a) the per virtual port fc4 statistics are missing.
> Implementing (b) the overall fc4 statistics are missing which might
> help to determine the utilization of the physical link.
> 
> But I don't think this justifies the introduction of a dummy-host for
> the physical port in case the physical port is not represented by a
> normal host.

Agreed...

We're still in infancy here. I also think that XEN environments will throw 
interesting wrinkles into anything we do now.


-- james s

> 
> 
> Regards,
> 
> Andreas
> 
> 
