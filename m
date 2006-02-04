From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Sat, 4 Feb 2006 15:31:18 -0800
Message-ID: <20060204153118.4b0270b4.akpm@osdl.org>
References: <200602042315.k14NFwuS006966@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60824 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932582AbWBDXbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2006 18:31:51 -0500
In-Reply-To: <200602042315.k14NFwuS006966@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Greg KH <greg@kroah.com>

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6009
> 

ah-hah, a trace.

> 
> ------- Additional Comments From djekels@breakwater.com  2006-02-04 15:15 -------
> 3ware 9000 Storage Controller device driver for Linux v2.26.02.004.
> input: AT Translated Set 2 keyboard as /class/input/input0
> scsi0 : 3ware 9000 Storage Controller
> 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfeaff000, IRQ: 9.
> 3w-9xxx: scsi0: Firmware FE9X 3.02.00.016, BIOS BE9X 3.01.00.027, Ports: 8.
>   Vendor: AMCC      Model: 9550SX-8LP DISK   Rev: 3.02
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> SCSI device sda: 390602752 512-byte hdwr sectors (199989 MB)
> SCSI device sda: drive cache: write back, no read (daft)
> SCSI device sda: 390602752 512-byte hdwr sectors (199989 MB)
> SCSI device sda: drive cache: write back, no read (daft)
>  sda: sda1 sda2
> sd 0:0:0:0: Attached scsi disk sda
>   Vendor: AMCC      Model: 9550SX-8LP DISK   Rev: 3.02
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> SCSI device sdb: 781205504 512-byte hdwr sectors (399977 MB)
> SCSI device sdb: drive cache: write back, no read (daft)
> SCSI device sdb: 781205504 512-byte hdwr sectors (399977 MB)
> SCSI device sdb: drive cache: write back, no read (daft)
>  sdb: unknown partition table
> sd 0:0:1:0: Attached scsi disk sdb
> Debug: sleeping function called from invalid context at kernel/workqueue.c:266
> in_atomic():1, irqs_disabled():0
> 
> Call Trace: <IRQ> <ffffffff801299ae>{__might_sleep+190}
> <ffffffff80139482>{try_to_del_timer_sync+
> 75}
>        <ffffffff80140c74>{flush_workqueue+24} <ffffffff801ea956>{as_exit_queue+22}
>        <ffffffff801e1e03>{elevator_exit+18} <ffffffff801e5f4b>{blk_cleanup_queue+42}
>        <ffffffff8800abba>{:scsi_mod:scsi_device_dev_release+230}
>        <ffffffff801efcd7>{kobject_cleanup+84} <ffffffff801ea046>{as_queue_empty+0}
>        <ffffffff801efd04>{kobject_release+0} <ffffffff801f07e5>{kref_put+83}
>        <ffffffff880077d2>{:scsi_mod:scsi_end_request+186}
> <ffffffff88007c8d>{:scsi_mod:scsi_io_co
> mpletion+1063}
>        <ffffffff88002d4c>{:scsi_mod:scsi_softirq+360}
> <ffffffff80135de8>{__do_softirq+80}
>        <ffffffff8010ee1b>{call_softirq+31} <ffffffff8011030a>{do_softirq+47}
>        <ffffffff801102d4>{do_IRQ+50} <ffffffff8010de1a>{ret_from_intr+0}
>         <EOI> <ffffffff8010bc36>{default_idle+53} <ffffffff8010be37>{cpu_idle+93}
>        <ffffffff80501347>{start_secondary+1138}
> device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
> cdrom: open failed.
> 

OK, this is a) not related to tcpdump and b) not an oops.

It's a warning that we're doing illegal things from softirq context.  In
this case, we're doing the final kref_put() on an object from within
softirq context in the scsi code.

James, I don't recall whether we've fixed this or not?  It was non-trivial,
wasn't it?
