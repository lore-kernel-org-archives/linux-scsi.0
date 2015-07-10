From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: possible race condition for usb_stor_port_reset and
 usb_reset_and_verify_device
Date: Fri, 10 Jul 2015 12:04:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1507101153320.1586-100000@iolanthe.rowland.org>
References: <CADUS3onTG-TMW=U-rc1+ujHDbYVCgwAXwx-LJyY_Guir-8o-Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADUS3onTG-TMW=U-rc1+ujHDbYVCgwAXwx-LJyY_Guir-8o-Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yoma sophian <sophian.yoma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 10 Jul 2015, yoma sophian wrote:

> hi Alan:
> 
> 2015-05-27 22:40 GMT+08:00 Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>:
> > On Wed, 27 May 2015, yoma sophian wrote:
> >
> >> After reading the kernel power document, freezing-of-tasks.txt , can I
> >> get the below conclusion:
> >> if I put my thread in freezable, it will get frozen automatically
> >> whenever the system goes in to suspend or hibernate.
> >
> > It's not entirely automatic.  Your thread has to call try_to_freeze()
> > at appropriate spots.  Of course, if your thread is a work queue then
> > the workqueue core will do that for you.
> after tracing more kernel based your guide, may I get below conclusion:
> if I try to create a thread that will do the IO
> 1. create the thread, with set_freezable, and call try_to_freeze() at
> appropriate spots.
> 2. hook my thread on system_freezable_wq
>      such as calling queue_delayed_work(system_freezable_wq, &mythread, intv)
>      or mod_delayed_work((system_freezable_wq, &mythread, intv)
> 
> is hub_thread the 1st kind?

It depends on which kernel you're looking at.  Up until commit 
32a6958998c5, which was added in the 3.18 kernel, hub_thread was the 
1st kind.

In the 3.18 kernel, hub_thread was replaced by a freezable workqueue
different from system_freezable_wq.

> if Yes, where it try_to_freeze?

Before 3.18, try_to_freeze was checked inside wait_event_freezable(),
which was called in hub_thread().

> And why not make hub_thread as above #2 kind?

We probably could, but it works okay the way it is now.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
