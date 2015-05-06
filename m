From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: possible race condition for usb_stor_port_reset and
 usb_reset_and_verify_device
Date: Wed, 6 May 2015 14:16:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505061406230.1133-100000@iolanthe.rowland.org>
References: <CADUS3ok_63WuXBufTfnk1NeosmK7eT91k0vrAHZpWSjD5GqmHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADUS3ok_63WuXBufTfnk1NeosmK7eT91k0vrAHZpWSjD5GqmHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yoma sophian <sophian.yoma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 7 May 2015, yoma sophian wrote:

> > Besides, the kernel already contains a thread that calls
> > sd_check_events periodically.  Why do you need to write a new one?
> I create the thread since some buggy devices needs to periodically
> polling to let it not going to disconnection.
> Would you mind to let me know which kernel thread that calls
> sd_check_events periodically?

There is not a dedicated thread.  Each block device has a workqueue
item that runs on the system_freezable_power_efficient_wq work queue.  
For more information, see the "Disk events" section of block/genhd.c.  
In particular, look at the disk_check_events() routine.

For a typical USB storage device, the system will poll for media 
changes by calling sd_check_events.

> >> My questions are:
> >> a. is there any system flag such suspend/resume in scsi layer for
> >> checking before sending command to downlayer driver, such as usb.
> >
> > I don't know of any.  In general, the kernel is designed so that no
> > SCSI commands will be sent while the system is in suspend or
> > hibernation, so no checking is needed.
> which flag or callback function we used to determine the system is in
> suspend or hibernation?
> udev->state?

You don't use any flags or callbacks, and you don't determine when the 
system is in suspend or hibernation.  Instead you make your thread 
freezable, so that it will get frozen automatically whenever the system 
goes into suspend or hibernation.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
