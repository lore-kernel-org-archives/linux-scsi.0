From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Device not ready problem
Date: Fri, 08 Sep 2006 11:41:37 +0200
Message-ID: <45013AD1.4020403@s5r6.in-berlin.de>
References: <45012A84.5050109@dataforce.com.au> <45013574.5030606@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:36523 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1750753AbWIHJpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Sep 2006 05:45:51 -0400
In-Reply-To: <45013574.5030606@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kelvin Wood <kelvin@dataforce.com.au>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

I wrote:
> Kelvin Wood wrote to linux1394-user:
...
>> Sep  8 18:02:35 server kernel:   Vendor: Maxtor    Model: OneTouch III      Rev: 0338
>> Sep  8 18:02:35 server kernel:   Type:   Direct-Access                      ANSI SCSI revision: 06
>> Sep  8 18:02:35 server kernel: blk: queue c8897018, I/O limit 4095Mb (mask 0xffffffff)
>> Sep  8 18:02:35 server kernel: Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
>> Sep  8 18:02:35 server kernel: SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
>> Sep  8 18:02:35 server kernel:  sda:<6>Device 08:00 not ready.
>> Sep  8 18:02:35 server kernel:  I/O error: dev 08:00, sector 0
>> Sep  8 18:02:35 server kernel: Device 08:00 not ready.
>> Sep  8 18:02:35 server kernel:  I/O error: dev 08:00, sector 0
>> Sep  8 18:02:35 server kernel:  unable to read partition table
> 
> Was the disk already spinning before sbp2 logged in?
...
>> Kernel: kernel-smp-2.4.21-40.EL
...

I just browsed the 2.4.20 sources at lxr.linux.no and it appears that
2.4's sd driver does send Start Stop Unit (start = 1) to the device if a
Test Unit Ready failed with 'not ready' --- _before_ the capacity is
read. In your log, Read Capacity works fine, apparently without previous
Start Stop Unit. But the regular Read command after Read Capacity
failed. Hmm...
-- 
Stefan Richter
-=====-=-==- =--= -=---
http://arcgraph.de/sr/
