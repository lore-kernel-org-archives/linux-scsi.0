From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] cpnvert scsi_debug to use virtual host bus
Date: Tue, 15 Feb 2005 10:48:34 -0800
Message-ID: <42124402.1060300@cs.wisc.edu>
References: <420D5E03.2020409@cs.wisc.edu> <421184DC.8010900@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63400 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261815AbVBOSsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 13:48:51 -0500
In-Reply-To: <421184DC.8010900@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Mike Christie wrote:
> 
>> The attach patch converts scsi_debug to use the virtual scsi bus.
>> It was built against scsi-rc-fixes-2.6.
>>
>> The interface has changed a little. Here is an
>> example of adding and removing a single host:
>>
>> cd /sys/bus/scsi_host/drivers/scsi_debug
>> [root@mina scsi_debug]# ls
>> add_host  dev_size_mb  every_nth  module     num_parts  opts   scsi_level
>> delay     dsense       max_luns   num_hosts  num_tgts   ptype
>> [root@mina scsi_debug]# echo 1 > add_host
>> [root@mina scsi_debug]# ls
>> add_host  dev_size_mb  every_nth  module     num_parts  opts   scsi_level
>> delay     dsense       max_luns   num_hosts  num_tgts   ptype  virt_host4
>> [root@mina scsi_debug]# cd virt_host4/
>> [root@mina virt_host4]# ls
>> detach_state  driver  host4  power  remove_host
>> [root@mina virt_host4]# echo 1 > remove_host
> 
> 
> Mike,
> I have noticed a few differences in the scsi_debug
> driver with this patch applied.
> 
> Firstly, when loaded the scsi_debug driver has no hosts
> and thus no devices. Previously it defaulted to 1 host,
> 1 target and 1 lun (hence 1 device). Now a user needs
> to do something like:
> $ modprobe scsi_debug
> $ cd /sys/bus/scsi_host/drivers/scsi_debug
> $ echo 42 > add_host
> 

This is just a result of me trying to emulate
normal HW drivers. For example I did not see
any that would add the bus's device (the device
equivalent to a pci_dev for example), so this
is why I was always just doing the additions
from userspace.

I can break out part of scsi_host_driver_add_host
and export it so LLDs can call it and
add hosts from the kernel for scsi_debug.

> The next issue is the number passed to "add_host".
> It doesn't matter, one host is added. When add_host
> belonged to scsi_debug the number and sign of the
> value sent to add_host was significant (and a negative
> number tried to remove that number of hosts).
> Perhaps we could get that capability back by making
> "num_hosts" writeable.
> 

I can easily add both behaviors back to the "add_host"
attr.

> Otherwise it looks good and fixes the "pseudo" bus
> problem which prevented two or more drivers using
> the "pseudo" bus at the same time.
> 
> Doug Gilbert
> 

