From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] cpnvert scsi_debug to use virtual host bus
Date: Tue, 15 Feb 2005 15:13:00 +1000
Message-ID: <421184DC.8010900@torque.net>
References: <420D5E03.2020409@cs.wisc.edu>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:42180 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261627AbVBOFMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 00:12:23 -0500
In-Reply-To: <420D5E03.2020409@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> The attach patch converts scsi_debug to use the virtual scsi bus.
> It was built against scsi-rc-fixes-2.6.
> 
> The interface has changed a little. Here is an
> example of adding and removing a single host:
> 
> cd /sys/bus/scsi_host/drivers/scsi_debug
> [root@mina scsi_debug]# ls
> add_host  dev_size_mb  every_nth  module     num_parts  opts   scsi_level
> delay     dsense       max_luns   num_hosts  num_tgts   ptype
> [root@mina scsi_debug]# echo 1 > add_host
> [root@mina scsi_debug]# ls
> add_host  dev_size_mb  every_nth  module     num_parts  opts   scsi_level
> delay     dsense       max_luns   num_hosts  num_tgts   ptype  virt_host4
> [root@mina scsi_debug]# cd virt_host4/
> [root@mina virt_host4]# ls
> detach_state  driver  host4  power  remove_host
> [root@mina virt_host4]# echo 1 > remove_host

Mike,
I have noticed a few differences in the scsi_debug
driver with this patch applied.

Firstly, when loaded the scsi_debug driver has no hosts
and thus no devices. Previously it defaulted to 1 host,
1 target and 1 lun (hence 1 device). Now a user needs
to do something like:
$ modprobe scsi_debug
$ cd /sys/bus/scsi_host/drivers/scsi_debug
$ echo 42 > add_host

The next issue is the number passed to "add_host".
It doesn't matter, one host is added. When add_host
belonged to scsi_debug the number and sign of the
value sent to add_host was significant (and a negative
number tried to remove that number of hosts).
Perhaps we could get that capability back by making
"num_hosts" writeable.

Otherwise it looks good and fixes the "pseudo" bus
problem which prevented two or more drivers using
the "pseudo" bus at the same time.

Doug Gilbert

