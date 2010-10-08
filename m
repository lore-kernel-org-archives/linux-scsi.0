From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS drive
Date: Fri, 08 Oct 2010 11:39:14 -0500
Message-ID: <1286555954.2985.110.camel@mulgrave.site>
References: <AANLkTin53S+C_+QzF-drs5BUAx=k7YeiHrTaQGTFSc_a@mail.gmail.com>
	 <4CAF3E04.1050304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CAF3E04.1050304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: bo yang <boyang1288@gmail.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, bo.yang@lsi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-10-08 at 17:51 +0200, Tomas Henzl wrote:
> On 09/23/2010 04:36 AM, bo yang wrote:
> > This patch is too big.  I am using attachment to submit.  Please
> > use attached file to apply.  Also let me know if it can't be accepted.
> >
> > To add the Online controller reset support, driver need to do:
> > a). reset the controller chips -- Xscale and Gen2 which will change
> > the function calls and add the reset function related to this two
> > chips.
> > b). during the reset, driver will store the pending cmds which not
> > returned by FW to driver's pending queue.  Driver will re-issue those
> > pending cmds again to FW after the OCR finished.
> > c). In driver's timeout routine, driver will report to OS as reset.
> > Also driver's queue routine will block the cmds until the OCR
> > finished.
> > d). in Driver's ISR routine, if driver get the FW state as state
> > change, FW in Failure status and FW support online controller
> > reset (OCR), driver will start to do the controller reset.
> > e). In driver's IOCTL routine, the application cmds will wait for the
> > OCR to finish, then issue the cmds to FW.
> >
> > Signed-off-by Bo Yang<bo.yang@lsi.com>
> >
> > ---
> >  drivers/scsi/megaraid/megaraid_sas.c |  756 ++++++++++++++++++++++++++++++++---
> >  drivers/scsi/megaraid/megaraid_sas.h |   88 +++-
> >  2 files changed, 787 insertions(+), 57 deletions(-)
> Hi Bo,
> in the workqueue function you sleep for 30s,
> it's scheduled here - schedule_work(&instance->work_init);
> 
> +process_fw_state_change_wq(struct work_struct *work)
> +{
> ...
> +		/*waitting for about 20 second before start the second init*/
> +		for (wait = 0; wait < 30; wait++) {
> +			msleep(1000);
> +		}

this lot should be ssleep(20) if you want a 20 sec sleep.

> 
> - this is not a good practice to sleep for a so long time I think
> - you should use in your exit function some synchronization 
>   for example 'cancel_work_sync', without that if someone rmmods your 
>   module, it could then lead to a memory corruption

Actually flush_scheduled_work() should be fine ... it will force the
module removal to wait for completion ... cancellation can be error
prone, so just forcing the wait sounds easier.

James
