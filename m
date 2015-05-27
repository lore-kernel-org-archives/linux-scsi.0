From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: possible race condition for usb_stor_port_reset and
 usb_reset_and_verify_device
Date: Wed, 27 May 2015 10:40:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505271018310.1540-100000@iolanthe.rowland.org>
References: <CADUS3o=3R27qA3pYMWur0qugTuwTZLrrCpaaNd7CYgkXbB9S8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33138 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753047AbbE0Oko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2015 10:40:44 -0400
In-Reply-To: <CADUS3o=3R27qA3pYMWur0qugTuwTZLrrCpaaNd7CYgkXbB9S8w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yoma sophian <sophian.yoma@gmail.com>
Cc: linux-scsi@vger.kernel.org, USB list <linux-usb@vger.kernel.org>

On Wed, 27 May 2015, yoma sophian wrote:

> After reading the kernel power document, freezing-of-tasks.txt , can I
> get the below conclusion:
> if I put my thread in freezable, it will get frozen automatically
> whenever the system goes in to suspend or hibernate.

It's not entirely automatic.  Your thread has to call try_to_freeze() 
at appropriate spots.  Of course, if your thread is a work queue then 
the workqueue core will do that for you.

> And automatically be waked up when all other thread finish their job?

No, when the system wakes up.

> in my case, since I didn't put my own sd_check_events thread into
> freezable case.
> once the system resume, it will cause the race condition as I
> mentioned previously, right?

Yes.

> if my conclusion is correct, would you mind to let me know where the
> kernel sequencially wake up normal then freezable threads?

Threads get frozen and woken up in kernel/power/process.c.  The 
routines are called from suspend_freeze_processes() and 
suspend_thaw_processes() in kernel/power/suspend.c.

Alan Stern

