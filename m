From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 14:28:40 +0200
Message-ID: <4FB39D78.9020300@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:44233 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758995Ab2EPM2p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 08:28:45 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q4GCSgDX025895
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 16 May 2012 14:28:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

while I actually want to benchmark FhGFS on a NetApp system, I'm somehow 
running from one kernel problem to another.
Yesterday we had to recable and while we are now still using multipath, 
each priority group now only has one underlying devices (we don't have 
sufficient IB srp ports on our test systems, but still want to benchmark 
a system as close as possible to a production system).
So after recabling actually all failover paths disappeared, which 
*shouldn't* have any influence on the performance. However, unexpectedly 
performance is now by less than 50% when I'm doing buffered IO. With 
direct IO it also still fine and reducing nr_requests of the multipath 
device to 8 also 'fixes' the problem. I then guessed it right and simply 
made multipath_busy() always to return 0, which also fixes the issue.


- problem:
	- iostat -x -m 1 shows that alternating one multipath devices starts to 
stall IO for several minutes
	- the other multipath device then does IO during that time with about 
600 to 700 MB/s, until it starts to stall IO
	- the active NetApp controller could server both multipath devices with 
about 600 to 700 MB/s

problem solutions:
	- add another passive sdX device to the multipath group
	- use direct IO
	- reduce /sys/block/dm-X/queue/nr_requests to 8
		- /sys/block/sdX does not need to be updated
	- disbable multipath_busy() by letting it return 0

Looking through the call chain, I see the underlying problem seems to be 
in scsi_host_is_busy().

> static inline int scsi_host_is_busy(struct Scsi_Host *shost)
> {
> 	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> 	    shost->host_blocked || shost->host_self_blocked)
> 		return 1;
>
> 	return 0;
> }
>

shost->can_queue -> 62 here
shost->host_busy -> 62 when one of the multipath groups does IO, further 
multipath groups then seem to get stalled.

I'm not sure yet why multipath_busy() does not stall IO when there is a 
passive path in the prio group.

Any idea how to properly address this problem?


Thanks,
Bernd

