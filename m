From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH] qla2xxx: Fix possible race that could hang
 kthread_stop()
Date: Thu, 27 Jan 2011 14:36:45 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87225EF8261@AVEXMB1.qlogic.org>
References: <20110127205922.GF31955@stratus.com>
 <1296162757.3050.69.camel@mulgrave.site> <20110127213255.GG31955@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3181 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1A0Wgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2011 17:36:48 -0500
In-Reply-To: <20110127213255.GG31955@stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bandan Das <bandan.das@stratus.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

We at QLogic are fine with James's fix. Here's my ack:

Acked-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Cheers,
Madhu

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Bandan Das
Sent: Thursday, January 27, 2011 1:33 PM
To: James Bottomley
Cc: Andrew Vasquez; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Fix possible race that could hang kthread_stop()


> That's not really the accepted way to fix these race conditions because
> of the double check of kthread_should_stop(); this is
> James
>
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c194c23..15ce69e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3282,10 +3282,10 @@ qla2x00_do_dpc(void *data)
>
>       set_user_nice(current, -20);
>
> +     set_current_state(TASK_INTERRUPTIBLE);
>       while (!kthread_should_stop()) {
>               DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
>
> -             set_current_state(TASK_INTERRUPTIBLE);
>               schedule();
>               __set_current_state(TASK_RUNNING);
>
> @@ -3454,7 +3454,9 @@ qla2x00_do_dpc(void *data)
>               qla2x00_do_dpc_all_vps(base_vha);
>
>               ha->dpc_active = 0;
> +             set_current_state(TASK_INTERRUPTIBLE);
>       } /* End of while(1) */
> +     __set_current_state(TASK_RUNNING);
>
>       DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
>
Yes, this looks more clean and will take care of the problem I am hitting.


Bandan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
