From: Stephen Cameron <steve.cameron@hp.com>
Subject: Strange Scsi_Cmnd->request_buffer addresses
Date: Thu, 1 Aug 2002 17:02:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020801170204.A1876@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm seeing some strange Scsi_Cmnd->request_buffer addresses....

I'm trying to fix the passthru ioctl in cpqfc driver for 2.5.29.
(The cpqfc patch from 2.5.28 -> 2.5.29 makes it compile but not
more.  It will panic if you try to use the passthrough ioctl.)  

In my (heavily modified) code for the passthrough ioctl, 
I kmalloc buf:

buf = cfe02800  <--- this is kmalloc'ed, and passed into scsi_wait_req(),
and eventually comes back into the driver in the form of a Scsi_Cmnd
via queuecommand entry point.  I would expect the Scsi_Cmnd->request_buffer
to correspond to the buf (maybe it is/will be a copy?)

pd = c12e2400 pt request_buffer = bffff850 <--- This is the 
	Scsi_Cmnd->request_buffer that should correspond to buf, above.
	The address looks weird.  I would expect 0xCxxxxxxx, not 0xBxxxxxxx
	Scsi_Cmnd->use_sg is 0.  Or, does this kind of address look ok?

single request_buffer = bffff850
request_bufflen = 00000200  <--- 512 bytes, this looks reasonable.
ms fffff850 <----------- This is the result of pci_map_single() on
	the Scsi_Cmnd->request_buffer.   This physical address does
	not look valid to me.  (I have 128 Mbytes in my intel ia32 box)

Any ideas?

-- steve

