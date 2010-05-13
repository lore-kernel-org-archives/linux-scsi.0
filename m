From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 13 May 2010 14:42:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005131440110.1731-100000@iolanthe.rowland.org>
References: <4BEB6E2B.7060408@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BEB6E2B.7060408@pobox.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 12 May 2010, Mark Lord wrote:

> On 12/05/10 02:48 PM, Alan Stern wrote:
> ..
> > That's right.  Since the command in question did have CK_COND set, the
> > device should have returned CHECK CONDITION status instead of GOOD
> > status.
> >
> > Therefore this indicates a bug in the device, not in the kernel.
> > hdparm could work around it here by issuing an explicit REQUEST SENSE
> > command, but in general it will cause trouble.
> ..
> 
> I wonder if perhaps usb-storage could honour the flag
> when the device doesn't ?

It could, but I'm not sure it would end up working right.  That is, 
usb-storage could go ahead and ask for the sense data, but the data 
values returned by the device might not all be set correctly.

The easiest way to find out is to make a version of hdparm which does 
an explicit REQUEST SENSE, and then see if the end result is 
acceptable.

Alan Stern

