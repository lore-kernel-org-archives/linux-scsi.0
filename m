From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: fibre channel sync cache question
Date: Wed, 26 Jul 2006 22:22:57 +0200
Message-ID: <44C7CF21.2080204@s5r6.in-berlin.de>
References: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com> <1153867194.8932.66.camel@laptopd505.fenrus.org> <44C6E6C7.8090606@torque.net> <44C7B269.4070505@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1675 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751559AbWGZUZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 16:25:37 -0400
In-Reply-To: <44C7B269.4070505@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: dougg@torque.net, Arjan van de Ven <arjan@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org

Michael Reed wrote:
>>>>-- Tuesday, July 25, 2006 4:22 PM, Michael Reed wrote:
>>>>>Using fibre channel disks, I've noticed that when the system shuts down
>>>>>that the sd_driver issues a sync cache command to the device.  I've
>>>>>also
>>>>>noticed that when the lldd is removed via rmmod that this sync cache is
>>>>>not executed.  I would think that the sync cache would be desirable
>>>>>under this circumstance.
[...]
> I'm wondering about the policy of issuing a sync cache.  There
> are target removal paths which result in it not being issued.
> 
> So, the real question is: when a scsi target is removed, is it
> policy that sync cache will be issued?
> 
> In fibre channel, here are two code paths in which sync cache
> is not issued.
> 
> 	- removal of LLDD (rmmod)
> 	- removal of target via sysfs device/delete
[...]

This problem exists with all transports which use scsi_remove_device or 
scsi_remove_host for soft device removal, as noted by Mike Christie in 
"question about sd_sync_cache and shutdown" on 2006-07-12. He pointed 
out that devices are brought into SDEV_CANCEL state before sd_shutdown 
is entered. Therefore sd_shutdown does not sync the cache.

This behavior changed a few Linux releases ago. I cannot pinpoint the 
responsible changeset. So, to answer your question about policy, there 
is no fixed policy in the specification and implementation of the 
mid-low SCSI API. Generally, neither "soft shutdown" nor "hot unplug" 
can be explicitly signaled from LLD to the SCSI core.

Unless somebody comes up with a general solution for SCSI core, I am 
planning to look for a particular solution in the sbp2 transport driver. 
(When an sbp2 LU is to be taken down, check if it is still physically 
present and somehow trigger SCSI high-level shutdown methods before 
scsi_remove_device.)
-- 
Stefan Richter
-=====-=-==- -=== ==-=-
http://arcgraph.de/sr/
