From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Fri, 8 Mar 2019 12:33:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1903081231260.1412-100000@iolanthe.rowland.org>
References: <1552063928.29776.2.camel@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552063928.29776.2.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: Kento.A.Kobayashi@sony.com, gregkh@linuxfoundation.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 8 Mar 2019, Oliver Neukum wrote:

> On Fr, 2019-03-08 at 09:13 +0000, Kento.A.Kobayashi@sony.com wrote:
> > The usb_reset_and_verify_device included in usb_reset_device fails
> > with -ENODEV after power off hub port, and the -ENODEV error will
> > be reported to uas_eh_bus_reset_handler and upper layer, so it
> > doesn't need to do rebind if -ENODEV happens.
> 
> Hi,
> 
> no I am sorry, that is an assumption you just cannot make.
> Anything can trigger a reset. That being SCSI is the common
> case certainly, but not the only case. And in those cases
> we cannot depend on upper layers doing the right thing, if
> we just ignore an error.
> 
> NACK
> 
> 	Sorry
> 		Oliver

Note that the reset routines in usb-storage do not make any exceptions
for -ENODEV.

Alan Stern
