From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_set_medium_removal timeout issue
Date: Tue, 30 Oct 2018 10:08:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1810301005200.1515-100000@iolanthe.rowland.org>
References: <678F3D1BB717D949B966B68EAEB446ED1F19F1CF@dggemm526-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED1F19F1CF@dggemm526-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 30 Oct 2018, Zengtao (B) wrote:

> Hi 
> 
> I have recently met a scsi_set_medium_removal timeout issue, and it's related
>  to both SCSI and USB MASS storage. 
> Since i am not an expert in either scsi or usb mass storage, i am writing to report
> the issue and ask for a solution from you guys.
> 
> My test scenario is as follow:
> 1.Linux HOST-----Linux mass storage gadget(the back store is a flash partition).
> 2.Host mount the device.
> 3.Host writes some data to the Mass storage device.
> 4.Host Unmount the device.
> Both Linux kernels(Host and Device) are Linux 4.9.  
> Some has reported the same issue a long time ago, but it remains there.
> https://www.spinics.net/lists/linux-usb/msg53739.html
> 
> For the issue itself, there is my observation:
> In the step 4, the Host will issue an PREVENT_ALLOW_MEDIUM_REMOVAL scsi command.
> and and timeout happens due to the device 's very slow fsg_lun_fsync_sub.

Something is wrong here.  Before sending PREVENT-ALLOW MEDIUM 
REMOVAL, the host should issue SYNCHRONIZE CACHE.  This will force 
fsg_lun_fsync_sub to run, and the host should allow a long timeout for 
this command.  Then when PREVENT-ALLOW MEDIUM REMOVAL is sent, nothing 
will need to be flushed.

Alan Stern

> I found there are two methods to workaround the issue: 
> 1. Change the timeout value of host scsi command PREVENT_ALLOW_MEDIUM_REMOVAL to
> to about 60 seconds from 10 seconds.
> 2. Remove the fsg_lun_fsync_sub in the device's Mass storage gadget driver.
> 
> Thanks
> 
> Regards
> zentao
