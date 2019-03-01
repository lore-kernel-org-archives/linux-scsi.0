From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: smartpqi_init: Reporting 'logical unit failure'
Date: Fri, 01 Mar 2019 07:56:37 -0800
Message-ID: <1551455797.3334.6.camel@linux.ibm.com>
References: <20190227163133.26283-1-e.velu@criteo.com>
         <20190301145832.12735-1-e.velu@criteo.com>
         <1551453987.3334.2.camel@linux.ibm.com>
         <c858605b-7283-7882-64a8-8d1584274b95@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c858605b-7283-7882-64a8-8d1584274b95@criteo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>, Erwan Velu <erwanaliasr1@gmail.com>, "elliott@hpe.com" <elliott@hpe.com>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <esc.storagedev@microsemi.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2019-03-01 at 15:43 +0000, Erwan Velu wrote:
> Le 01/03/2019 à 16:26, James Bottomley a écrit :
> > [...]
> > Shouldn't this be a variant of sdev/scmd_printk?  Otherwise it
> > tells
> > you what disk in the array terms is the problem but not what device
> > in
> > your actual system is affected.
> 
> Hey James,
> 
> My initial take on that was that pqi_take_device_offline(), which is 
> called just after, will print the "re-scanning " message with the
> same 
> format.
> 
> As they will be both printed in the same error context and one after
> the 
> other, I though that would make sense to represent the same
> information 
> to ease the reading like cause -> consequence.
> 
> As the message is about the LUN itself, which is reported faulty, I 
> though it would worth reporting the info that way.
> 
> Shall I consider printing also the disk name in addition ?

I was thinking just

if (printk_ratelimit())
	scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n", ...

That will give all the necessary information

James
