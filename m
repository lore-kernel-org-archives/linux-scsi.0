From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [ PATCH 3/4 ] mpt fusion prevent DV deadlock
Date: Fri, 31 Oct 2008 19:53:52 +0100
Message-ID: <200810311953.53474.bs@q-leap.de>
References: <B73941C4DE6A3D4EA1AE128E9565E244238A270570@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:50436 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYJaSx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2008 14:53:59 -0400
In-Reply-To: <B73941C4DE6A3D4EA1AE128E9565E244238A270570@inbmail01.lsi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hello Sathya,

thanks for review. I have prepared an updated patch series, but can't test it 
properly, since someone has broken the error handler between 2.6.26 and 
2.6.28-rc. It activates the error handler, but then somewhere deadlocks (not 
allways, but in 4 of 5 testcases) :( 
I don't have time to figure out what is this now, all of that has to wait till 
next wednesday when I'm back to office.

Regarding the DV deadlock patch, this is something we also really need to fix 
upstream, since transtec (from whom I get my test hardware) mostly uses SLES 
or RHEL kernels and this patch is essential for them.


Thanks,
Bernd

On Thursday 30 October 2008 18:58:31 Prakash, Sathya wrote:
> Bernd,
> This looks OK for me, but I am not sure whether we should take this
> work-around to the upstream driver. As this is a workaround to avoid the
> deadlock and not the actual fix. I hope you can retain this with your
> in-house driver.
>
> May be James can comment whether we can take this into MPT driver or not?
>
> Thanks
> Sathya
>
> -----Original Message-----
> From: Bernd Schubert [mailto:bs@q-leap.de]
> Sent: Tuesday, September 23, 2008 6:58 PM
> To: Linux SCSI Mailing List
> Cc: Moore, Eric; Prakash, Sathya; James Bottomley; DL-MPT Fusion Linux
> Subject: [ PATCH 3/4 ] mpt fusion prevent DV deadlock
>
> The mpt fusion driver will do a domain revalidation on an ioc reset, but
> this DV might cause a live deadlock. The problem has been entirely analyzed
> in this thread http://marc.info/?t=118039577800004, but so far none of the
> suggested solutions has been implemented. This patch simply disables the
> domain revalidation, if it does know it will run into the deadlock.
>
> Signed-off-by: Bernd Schubert <bs@q-leap.de>
>
>  drivers/message/fusion/mptspi.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> Index: linux-2.6.26/drivers/message/fusion/mptspi.c
> ===================================================================
> --- linux-2.6.26.orig/drivers/message/fusion/mptspi.c
> +++ linux-2.6.26/drivers/message/fusion/mptspi.c
> @@ -672,12 +672,24 @@ static void mptspi_dv_device(struct _MPT  {
>         VirtTarget *vtarget = scsi_target(sdev)->hostdata;
>         MPT_ADAPTER *ioc = hd->ioc;
> +       unsigned long nr_requests = sdev->request_queue->nr_requests;
> +       struct request_list *rl = &sdev->request_queue->rq;
>
>         /* no DV on RAID devices */
>         if (sdev->channel == 0 &&
>             mptspi_is_raid(hd, sdev->id))
>                 return;
>
> +       if (rl->count[0] + 1 >= nr_requests
> +       ||  rl->count[1] + 1 >= nr_requests) {
> +               /* we must NOT do a DV after an error recovery, when we
> +                * don't have left a space in the request list, since
> +                * this will cause a live dead lock */
> +               starget_printk(KERN_INFO, scsi_target(sdev), MYIOC_s_FMT
> +                   "Skipping DV, to prevent dead lock!\n", ioc->name);
> +               return;
> +       }
> +
>         /* If this is a piece of a RAID, then quiesce first */
>         if (sdev->channel == 1 &&
>             mptscsih_quiesce_raid(hd, 1, vtarget->channel, vtarget->id) <
> 0) {
>
>
>
> --
> Bernd Schubert
> Q-Leap Networks GmbH



-- 
Bernd Schubert
Q-Leap Networks GmbH
