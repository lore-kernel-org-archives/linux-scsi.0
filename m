From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] ide-scsi changes for new mid level api and error handling
 in 2.5.52
Date: Sun, 22 Dec 2002 12:59:05 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E051C69.5000701@torque.net>
References: <20021221224604.GC7990@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com

Willem Riede wrote:
> Here is my proposal for bringing ide-scsi in line with the current kernel.
> 
> The attached patch does:
> 
> 1. Change from old style initialization to the new hotplug initialization model.
>    It involves declaring both a parent device and bus kernel object, which feels
>    a bit awkward, but hey, it works.
> 
> 2. Make ide-scsi request sense itself when CHECK_CONDITION is asserted. This 
>    change particularly makes ide-scsi run much smoother on my test box.
> 
> 3. Implement eh_abort_handler and eh_device_reset_handler. I have no real way
>    to thoroughly test these new routines, so for this part particularly I ask
>    for peer review.

Willem,
Good work.

I tried it out with an ATAPI cdrom and it worked fine.
Tried a few error conditions (e.g. purposely reading
past the end of the cdrom) and it reacted properly.

The introduction of a new sysfs bus type: "ide-scsi" to
add to scsi_debug's "pseudo" seems a bit messy. It will
do for now; hopefully Mike Anderson will come up with
some coherent sysfs naming scheme for drivers
that bridge to another protocol stack (e.g. ide-scsi,
usb-storage and ieee1394/sbp2).

BTW Willem's patch is against lk 2.5.52 .

Doug Gilbert

