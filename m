From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Strange Scsi_Cmnd->request_buffer addresses
Date: Fri, 2 Aug 2002 11:50:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802185048.GC1161@beaverton.ibm.com>
References: <20020801170204.A1876@zuul.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020801170204.A1876@zuul.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: Stephen Cameron <steve.cameron@hp.com>
Cc: linux-scsi@vger.kernel.org

Stephen,
	No idea what is causing the problem just a few comments.

Stephen Cameron [steve.cameron@hp.com] wrote:
> Hi,
> 
> I'm seeing some strange Scsi_Cmnd->request_buffer addresses....
> 
> I'm trying to fix the passthru ioctl in cpqfc driver for 2.5.29.
> (The cpqfc patch from 2.5.28 -> 2.5.29 makes it compile but not
> more.  It will panic if you try to use the passthrough ioctl.)  
> 
> In my (heavily modified) code for the passthrough ioctl, 
> I kmalloc buf:
> 
> buf = cfe02800  <--- this is kmalloc'ed, and passed into scsi_wait_req(),
> and eventually comes back into the driver in the form of a Scsi_Cmnd
> via queuecommand entry point.  I would expect the Scsi_Cmnd->request_buffer
> to correspond to the buf (maybe it is/will be a copy?)
> 

No it should not be a copy if you follow the call graph the buffer
passed to scsi_wait_req is passed to scsi_do_req. In scsi_do_req buffer
is assigned to sr_buffer. In scsi_request_fn scsi_init_cmd_from_req is
called which will assign sr_buffer to the Scsi_Cmnd buffer.

In the queuecommand is any other part of the Scsi_Cmnd look odd? Did you
check the Scsi_Cmnd->request to see if the buffer is bad in the request
also?


> pd = c12e2400 pt request_buffer = bffff850 <--- This is the 
> 	Scsi_Cmnd->request_buffer that should correspond to buf, above.
> 	The address looks weird.  I would expect 0xCxxxxxxx, not 0xBxxxxxxx
> 	Scsi_Cmnd->use_sg is 0.  Or, does this kind of address look ok?
> 

> single request_buffer = bffff850
> request_bufflen = 00000200  <--- 512 bytes, this looks reasonable.
> ms fffff850 <----------- This is the result of pci_map_single() on
> 	the Scsi_Cmnd->request_buffer.   This physical address does
> 	not look valid to me.  (I have 128 Mbytes in my intel ia32 box)
> 
On ia32 systems the pci_map_single will translate to a __pa which will
subtract PAGE_OFFSET from the address that is passed in. So bffff850 -
0xC0000000 is fffff850. The problem happen before you got here.


-Mike
-- 
Michael Anderson
andmike@us.ibm.com

