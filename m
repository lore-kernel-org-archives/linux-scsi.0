From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Mon, 19 Jan 2004 09:38:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EDE9@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:10828 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265529AbUASRiC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:38:02 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On , linux-scsi-owner@vger.kernel.org wrote:
> Ok, I don't know if this was the 'right' fix, but I noticed
> that the Kconfig file in the qla2xxx directory was different
> in the -b9 resync patchset, so I tried copying the old one
> back from the plain 2.6.1-mm4 tree, and now I got the
> modules built and installed.

I'll take a look at this.

> After enabling debugging and
> rebooting -- we now have LUNs! Attached is the output from
> /var/log/messages showing the -b9 module loading and finding
> the Nexsan arrays and their associated disk volumes. There
> are supposed to be two LUNs per array as shown, and now I
> have disk devices /dev/sdb - /dev/sde as expected. The
> unknown partition table comments are correct also, since
> I'm using the raw devices without any partitioning as
> members of RAID1 mirror sets.
>

Good.
 
> A couple of minor points:
> 
> - It appears that the patched driver still reports itself
>   as v8.00.00b8-debug, rather than b9.
> 

Thanks, will address in next resync

> - Someone noted this on the list before I think, but I also
>   noticed it: when you unload and re-load the qla2300 module,
>   it appears to not be decrementing some counter. The first
>   time, you get /proc/scsi/qla2xxx/2 and /proc/scsi/qla2xxx/3,
>   and the second time you get /4 and /5, and so forth, each
>   time you re-load. The logical names of the scsi devices
>   are not affected, just the numbers in the /proc/scsi/qla2xxx  
> directory. 
> 

It's my understanding that this is the expected behaviour.  
Note the following code from scsi_host_alloc() in hosts.c:

	...
	init_MUTEX(&shost->scan_mutex);

	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */

	...

scsi_host_next_hn is never decremented.

Regards,
Andrew Vasquez
