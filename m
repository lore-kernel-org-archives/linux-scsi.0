From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Mon, 8 Sep 2014 08:07:03 -0700
Message-ID: <20140908150703.GA30298@infradead.org>
References: <5403AB47.3040706@interlog.com>
 <20140905052402.GA27094@infradead.org>
 <5409C116.5060702@interlog.com>
 <5409D5D0.8060801@acm.org>
 <540B1CC6.8010800@interlog.com>
 <540D72BB.2020100@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <540D72BB.2020100@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 08, 2014 at 11:11:23AM +0200, Bart Van Assche wrote:
> Hello Doug,
> 
> In the scsi_debug driver scsi_remove_host() is called from inside the
> sdebug_driver_remove() callback function. Unless I have missed something it
> is not guaranteed that that callback function is invoked before unloading of
> the scsi_debug driver has finished. I think most of the code in
> sdebug_driver_remove() should be moved to sdebug_remove_adapter().

I'm not sure that's right.  scsi_debug uses the driver mode in a
slightly unusual way, and includes both the bus driver, device and
device driver.

sdebug_driver_remove is a bus method, but as we don't have driver methods
should act very much like all other _remove callbacks.

sdebug_remove_adapter is more a "bus-level" function that calls into
the driver model to unbind devices from the driver.

But we defintively shouldn't stop and free queued command before we
fully remove the hosts.  As far as I can tell the stop_all_queued
call can be entirely removed from the remove path, as the midlayer
will take care of waiting for all commands to return, and the
free_all_queued should be after all hosts are unregistered.

Something like the (untested) patch below would do the trick.
We'd still need Dougs patch for the EH case, though.

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d19c0e3..d022c2f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3983,14 +3983,13 @@ static void __exit scsi_debug_exit(void)
 {
 	int k = scsi_debug_add_host;
 
-	stop_all_queued();
-	free_all_queued();
 	for (; k; k--)
 		sdebug_remove_adapter();
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
 
+	free_all_queued();
 	if (dif_storep)
 		vfree(dif_storep);
 
