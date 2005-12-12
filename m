From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: bug in scsi_setup_command_freelist:  kmem_cache_create: duplicate
 cache scsi_cmd_cache
Date: Mon, 12 Dec 2005 07:44:06 +0100
Message-ID: <439D1C36.7040108@s5r6.in-berlin.de>
References: <4399FFA1.3050000@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:2177 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751161AbVLLGoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 01:44:16 -0500
Received: from [192.168.0.41] ([83.221.230.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jBC6iBoM009922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2005 07:44:12 +0100
In-Reply-To: <4399FFA1.3050000@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wrote on 2005-12-09:
> I just saw the following under Linux 2.6.14.3. A web search turns up
> more reports of this kind, usually with USB devices.

These are mostly older reports though.

> [sbp2 throws transport errors during inquiry]
> Dec  9 22:09:56 shuttle kernel: scsi: Device offlined - not ready after 
> error recovery: host 0 channel 0 id 0 lun 0
> Dec  9 22:09:56 shuttle kernel: ieee1394: sbp2: scsi_add_device failed
> [I unloaded and reloaded sbp2]
> Dec  9 22:10:31 shuttle kernel: SCSI subsystem initialized
> Dec  9 22:10:31 shuttle kernel: ieee1394: sbp2: Driver forced to 
> serialize I/O (serialize_io=1)
> Dec  9 22:10:31 shuttle kernel: ieee1394: sbp2: Try serialize_io=0 for 
> better performance
> Dec  9 22:10:31 shuttle kernel: kmem_cache_create: duplicate cache 
> scsi_cmd_cache
> Dec  9 22:10:31 shuttle kernel: ------------[ cut here ]------------
> Dec  9 22:10:31 shuttle kernel: kernel BUG at mm/slab.c:1807!
> Dec  9 22:10:31 shuttle kernel: invalid operand: 0000 [#1]
...
> I had a look at how pool->users is refcounted but did not find
> any obvious mistake.

I found and fixed a bug in sbp2 in the meantime. If the inquiry did not 
succeed, sbp2 did not release its own data structures and did not remove 
the Scsi_Host. I don't know though if this was actually the cause for 
the subsequent failure in kmem_cache_create when the SBP-2 unit was 
added as a new host.
-- 
Stefan Richter
-=====-=-=-= ==-- -==--
http://arcgraph.de/sr/
