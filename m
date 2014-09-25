From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V5 02/17] scsi: sysfs: don't add scsi_device if its already added
Date: Wed, 24 Sep 2014 17:29:39 -0700
Message-ID: <001601cfd857$cb656d10$62304730$@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org> <1411571653-22729-3-git-send-email-draviv@codeaurora.org> <20140924160825.GB13541@infradead.org> <000f01cfd814$7a6be2b0$6f43a810$@codeaurora.org> <20140924163829.GA9474@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140924163829.GA9474@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com
List-Id: linux-scsi@vger.kernel.org

> Ok.  Can you move the is_visible check to scsi_sysfs_add_devices, should
be fine to place it just after the sdev_state check.

Sure, will move it in next patch.


-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org] 
Sent: Wednesday, September 24, 2014 9:38 AM
To: Subhash Jadavani
Cc: 'Christoph Hellwig'; 'Dolev Raviv';
James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org;
linux-scsi-owner@vger.kernel.org; linux-arm-msm@vger.kernel.org;
santoshsy@gmail.com
Subject: Re: [PATCH V5 02/17] scsi: sysfs: don't add scsi_device if its
already added

On Wed, Sep 24, 2014 at 09:27:47AM -0700, Subhash Jadavani wrote:
> No, It happens in this sequence of events:
> 1. LLD calls the __scsi_add_device() for well known logical units 
> before
> scsi_scan_host() (This is done as part of [PATCH V5 10/17] scsi: ufs:
> manually add well known logical units). __scsi_add_device() will also 
> add the scsi device to sysfs by calling scsi_sysfs_add_sdev() 2. Now 
> LDD calls the scsi_scan_host() (Note that CONFIG_SCSI_SCAN_ASYNC is
> enabled) which will schedule the async scan. Device reports only 
> normal LUs (no w-lus reported here) when REPORT LUNs in sent with 
> SELECT REPORT cleared. At the end of async scan, 
> scsi_finish_async_scan() calls scsi_sysfs_add_devices(). 
> scsi_sysfs_add_devices() iterates through all the scsi_device 
> instances attached to Scsi_Host hence end up calling
> scsi_sysfs_add_sdev() 2nd time for the scsi_device which were already 
> added explicitly by LDD.

Ok.  Can you move the is_visible check to scsi_sysfs_add_devices, should be
fine to place it just after the sdev_state check.
