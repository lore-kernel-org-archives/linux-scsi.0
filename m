From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [BUG] scsi / genhd badness
Date: Mon, 28 Oct 2002 20:19:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210281919.38509.christophe.varoqui@free.fr>
References: <1035818430.3dbd55be25447@imp.free.fr> <20021028180541.GB1234@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021028180541.GB1234@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

> > Badness in put_device at drivers/base/core.c:139
> > Call Trace:
> >  [<c01d12ae>] put_device+0xde/0xf0
> >  [<c022c1ff>] sg_detach+0x8f/0x1f0
> >  [<c02121d8>] proc_scsi_gen_write+0x338/0x4b0
> >  [<c014d6c6>] open_namei+0xa6/0x400
> >  [<c01658e0>] proc_file_write+0x40/0x50
> >  [<c014047c>] vfs_write+0xdc/0x150
> >  [<c014058e>] sys_write+0x3e/0x60
> >  [<c010772b>] syscall_call+0x7/0xb
>
> This problem is do to a put_device still left in sg.c. The patch below
> is against ac5 to replace put_device with device_unregister which should
> remove this Badness.
>
Thank for your prompt response
Will try tomorow.

>
> The 2.5.44 SCSI subsystem still has some gaps in driverfs support. We
> currently do not have a hotplug function defined for scsi_bus. The call
> is still suppose to happen even if a bus does not define one, but I do
> not believe I have seen this happen.
>
yes, I tried to follow the million fonctions called after disk addition and 
got lost :) I just can't understand why the disks get added to driverfs on 
modprobe my_scsi_driver and not on "add-single-device".

regards,
cvaroqui
