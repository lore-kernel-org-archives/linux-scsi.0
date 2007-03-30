From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 21:31:01 +0200
Message-ID: <20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
	<460D0E78.3040200@gmail.com>
	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
	<460D178F.4000500@gmail.com>
	<20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>
	<460D27E3.2050602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <460D27E3.2050602@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 31 Mar 2007 00:08:19 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> (3) make sure all existing kobjects are released by module exit function.
> 
> For example, let's say there is a hypothetical disk device /dev/dk0
> driven by a hypothetical driver mydrv.  /dev/dk0 is represented like the
> following in the sysfs tree.
> 
> /sys/devices/pci0000:00/0000:00:1f.0/dk0/{myknob0,myknob1}
> 
> Owner of both attrs myknob0 and myknob1 is mydrv and opening either
> increases the reference counts of dk0 and mydrv and closing does the
> opposite.
> 
> * When there is no opener of either knob and the /dev/dk0 isn't used by
> anyone.  Reference count of dk0 is 1, mydrv 0.

Hm, but as long as dk0 is registered, it can be looked up and someone
could get a reference on it.

> 
> * User issues rmmod mydrv.  As mydrv's reference count is zero, unload
> proceeds and mydrv's exit function is called.
> 
> * mydrv's exit function looks like the following.
> 
>   mydrv_exit()
>   {
> 	sysfs_remove_file(dk0, myknob0);
> 	sysfs_remove_file(dk1, myknob1);
> 	device_del(dk0);
> 	deinit controller;
> 	release all resources;
>   }
> 
> The device_del(dk0) drops dk0's reference count to zero and its
> ->release is invoked immediately.

And here is the problem if someone else still has a reference. The
module will be unloaded, but ->release will not be called until the
"someone else" gives up the reference...
