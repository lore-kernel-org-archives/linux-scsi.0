From: Oliver Neukum <oneukum@suse.com>
Subject: Re: scsi_set_medium_removal timeout issue
Date: Tue, 30 Oct 2018 09:56:26 +0100
Message-ID: <1540889786.12349.9.camel@suse.com>
References: <678F3D1BB717D949B966B68EAEB446ED1F19F1CF@dggemm526-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED1F19F1CF@dggemm526-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zengtao (B)" <prime.zeng@hisilicon.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Cc: "usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Di, 2018-10-30 at 08:28 +0000,  Zengtao (B)  wrote:
> Hi 

> For the issue itself, there is my observation:
> In the step 4, the Host will issue an PREVENT_ALLOW_MEDIUM_REMOVAL scsi command.
> and and timeout happens due to the device 's very slow fsg_lun_fsync_sub.
> I found there are two methods to workaround the issue: 
> 1. Change the timeout value of host scsi command PREVENT_ALLOW_MEDIUM_REMOVAL to
> to about 60 seconds from 10 seconds.

That is near useless, because the gadget can be used with other
systems.

> 2. Remove the fsg_lun_fsync_sub in the device's Mass storage gadget driver.

It exists for a reason. The blocks have to be on the medium.
It seems to me that your gadget just allows too many dirty pages in the
cache.

	Regards
		Oliver
