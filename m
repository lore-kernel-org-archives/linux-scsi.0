From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] cciss: resubmit kernel scan thread for MSA2012
Date: Tue, 10 Mar 2009 10:50:41 -0500
Message-ID: <1236700241.14822.4.camel@localhost.localdomain>
References: <20090310151738.GA18243@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54385 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbZCJPur (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 11:50:47 -0400
In-Reply-To: <20090310151738.GA18243@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, LKML-SCSI <linux-scsi@vger.kernel.org>, coldwell@redhat.com, hare@novell.com

On Tue, 2009-03-10 at 10:17 -0500, Mike Miller (OS Dev) wrote:
> Patch 1 of 1
> 
> This is yet another go at the patch to detect changes on the MSA2012.
> I hope I've addressed all concerns. This patch rearranges some of the
> code
> so we also have coverage in the sg and the ioctl paths as well as the
> main
> data path.
> 
> The MSA2012 cannot inform the driver of configuration changes since
> all
> management is out of band. This is a departure from any storage we
> have
> supported in the past. We need some way to detect changes on the
> topology so
> we implement this kernel thread. In some instances there's nothing we
> can do
> from the driver (like LUN failure) so just print out a message. In the
> case
> where logical volumes are added or deleted we call rebuild_lun_table
> to
> refresh the driver's view of the world.
> 
> Changelog:
> 1. Do the completion(hba[i]->rescan_wait) before calling kthread_stop,
> this resolves the issue of waiting for the timeout on rmmod
> 2. Added a new function called check_ioctl_unit_attention to cover
> UA's
> from the ioctl patch
> 3. I preserved the wait_for_completion_timeout to avoid call traces
> caused by /proc/sys/kernel/hung_task_timeout_secs expiring
> 4. Moved the call to check_for_unit_attention to
> evaluate_target_status
> since it's already called from complete_command
> 5. Add retry_cmd as an argument to evaluate_target_status
> 6. Added *rescan_wait to the controller info struct
> 7. Changed wait_for_completion_timeout to
> wait_for_completion_interruptible.
> This will allow kthread_should_stop to stop the thread immediately
> with no race.
> 
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
[...]
> @@ -3834,6 +3917,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
>  		return;
>  	}
>  
> +	kthread_stop(hba[i]->cciss_scan_thread);
> +	complete(hba[i]->rescan_wait);

This complete is superfluous (the kthread_stop will wake the
wait_for_completion_interruptible() and if it doesn't, you won't get to
the complete() because kthread_stop() waits for the thread to die).

Otherwise, the rest of this looks fine to me.

James


