From: yoma sophian <sophian.yoma@gmail.com>
Subject: Re: possible race condition for usb_stor_port_reset and usb_reset_and_verify_device
Date: Fri, 10 Jul 2015 22:15:46 +0800
Message-ID: <CADUS3onTG-TMW=U-rc1+ujHDbYVCgwAXwx-LJyY_Guir-8o-Ng@mail.gmail.com>
References: <CADUS3o=3R27qA3pYMWur0qugTuwTZLrrCpaaNd7CYgkXbB9S8w@mail.gmail.com>
	<Pine.LNX.4.44L0.1505271018310.1540-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37518 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbbGJOPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 10:15:47 -0400
In-Reply-To: <Pine.LNX.4.44L0.1505271018310.1540-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, USB list <linux-usb@vger.kernel.org>

hi Alan:

2015-05-27 22:40 GMT+08:00 Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 27 May 2015, yoma sophian wrote:
>
>> After reading the kernel power document, freezing-of-tasks.txt , can I
>> get the below conclusion:
>> if I put my thread in freezable, it will get frozen automatically
>> whenever the system goes in to suspend or hibernate.
>
> It's not entirely automatic.  Your thread has to call try_to_freeze()
> at appropriate spots.  Of course, if your thread is a work queue then
> the workqueue core will do that for you.
after tracing more kernel based your guide, may I get below conclusion:
if I try to create a thread that will do the IO
1. create the thread, with set_freezable, and call try_to_freeze() at
appropriate spots.
2. hook my thread on system_freezable_wq
     such as calling queue_delayed_work(system_freezable_wq, &mythread, intv)
     or mod_delayed_work((system_freezable_wq, &mythread, intv)

is hub_thread the 1st kind?
if Yes, where it try_to_freeze?
And why not make hub_thread as above #2 kind?

appreciate your kind help,
