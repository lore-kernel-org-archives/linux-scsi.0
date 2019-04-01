From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: scsi_set_medium_removal timeout issue
Date: Mon, 1 Apr 2019 16:27:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1904011627120.1506-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1812041135300.1537-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1812041135300.1537-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Dec 2018, Alan Stern wrote:

> On Thu, 29 Nov 2018, Zengtao (B) wrote:
> 
> > Ping?
> > 
> > >-----Original Message-----
> > >From: Alan Stern [mailto:stern@rowland.harvard.edu]
> > >Sent: Wednesday, November 14, 2018 11:35 PM
> > >To: Martin Petersen <martin.petersen@oracle.com>; Zengtao (B)
> > ><prime.zeng@hisilicon.com>
> > >Cc: jejb@linux.vnet.ibm.com; gregkh@linuxfoundation.org;
> > >linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> > >linux-usb@vger.kernel.org; usb-storage@lists.one-eyed-alien.net
> > >Subject: RE: scsi_set_medium_removal timeout issue
> > >
> > >On Wed, 14 Nov 2018, Zengtao (B) wrote:
> > >
> > >> I just enabled the scsi log in the middle of the umount operation,
> > >> otherwise I can't reproduce the issue when the scsi log is enabled.
> > >>
> > >> >from the beginning.  In any case, it wasn't what I wanted.  I asked
> > >> >you to post the dmesg log, not the SCSI log.
> > >>
> > >> Please refer to the new attachment for dmesg log.
> > >
> > >Heh, yes, I see now.
> > >
> > >Martin, shouldn't sd_release() call sd_sync_cache() in the same way that
> > >sd_shutdown() does, before it calls scsi_set_medium_removal()?
> > >
> > >Alan Stern
> 
> I don't know if this is the right thing to do, but you can try out the 
> following patch to see if it helps.
> 
> Alan Stern
> 
> 
> 
> Index: usb-4.x/drivers/scsi/sd.c
> ===================================================================
> --- usb-4.x.orig/drivers/scsi/sd.c
> +++ usb-4.x/drivers/scsi/sd.c
> @@ -113,6 +113,7 @@ static void sd_shutdown(struct device *)
>  static int sd_suspend_system(struct device *);
>  static int sd_suspend_runtime(struct device *);
>  static int sd_resume(struct device *);
> +static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr);
>  static void sd_rescan(struct device *);
>  static int sd_init_command(struct scsi_cmnd *SCpnt);
>  static void sd_uninit_command(struct scsi_cmnd *SCpnt);
> @@ -1393,8 +1394,14 @@ static void sd_release(struct gendisk *d
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
>  
>  	if (atomic_dec_return(&sdkp->openers) == 0 && sdev->removable) {
> -		if (scsi_block_when_processing_errors(sdev))
> +		if (scsi_block_when_processing_errors(sdev)) {
> +			if (sdkp->WCE && sdkp->media_present) {
> +				sd_printk(KERN_NOTICE, sdkp,
> +						"Synchronizing SCSI cache\n");
> +				sd_sync_cache(sdkp, NULL);
> +			}
>  			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
> +		}
>  	}
>  
>  	/*

Zengtao, did you ever try out this patch?  Did it fix your problem?

Alan Stern
