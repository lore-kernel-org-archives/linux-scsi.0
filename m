From: christophe.varoqui@free.fr
Subject: Re: [BUG] scsi / genhd badness
Date: Tue, 29 Oct 2002 09:23:50 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035879830.3dbe45963db43@imp.free.fr>
References: <1035818430.3dbd55be25447@imp.free.fr> <20021028180541.GB1234@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021028180541.GB1234@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

> > On a server with scsi disk behind an aic7xxx, kernel 2.5.44-ac4, each  
> time I   
> > remove a disk from the linux scsi subsystem (echo "scsi  
> remove-single-device a   
> > b c d">/proc/scsi/scsi) I get the following oops (server survive) :   
> >    
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
> >    
>   
> This problem is do to a put_device still left in sg.c. The patch below  
> is against ac5 to replace put_device with device_unregister which  
> should  
> remove this Badness.  
>   
>  sg.c |    2 +-  
>  1 files changed, 1 insertion(+), 1 deletion(-)  
> ------  
>   
> --- 1.30/drivers/scsi/sg.c	Fri Oct 18 11:27:30 2002  
> +++ edited/drivers/scsi/sg.c	Mon Oct 28 09:38:44 2002  
> @@ -1607,7 +1607,7 @@  
>  		sdp->de = NULL;  
>  		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_type);  
>  		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);  
> -		put_device(&sdp->sg_driverfs_dev);  
> +		device_unregister(&sdp->sg_driverfs_dev);  
>  		if (NULL == sdp->headfp)  
>  			vfree((char *) sdp);  
>  	}  
  
Follow-up,  
with this patch driverfs scsi and root reps get rightly de-populated / 
re-populated on scsi disk remove / add ... but the block rep still doesn't get 
re-populated and thus no block hotplug add-event gets passed to user-space.  
scsi hotplug events (add and remove) get passed now.  
  
regards,  
cvaroqui  
