From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Fri, 07 Mar 2008 09:03:05 -0600
Message-ID: <1204902185.2889.6.camel@localhost.localdomain>
References: <1204308113.4003.45.camel@localhost.localdomain>
	 <1204504945.3069.30.camel@localhost.localdomain>
	 <6b2481670803030017h43da68bcxd78a6142f8f5c6bb@mail.gmail.com>
	 <1204556371.3043.7.camel@localhost.localdomain>
	 <1204682849.3091.95.camel@localhost.localdomain>
	 <1204750960.3047.67.camel@localhost.localdomain>
	 <6b2481670803060646m54675625g729a82c4da33ce05@mail.gmail.com>
	 <1204818725.3062.14.camel@localhost.localdomain>
	 <1204825474.3062.25.camel@localhost.localdomain>
	 <47D03117.2020903@garzik.org>
	 <6b2481670803070250p7e6eab01i6660c53188914058@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35423 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbYCGPDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 10:03:08 -0500
In-Reply-To: <6b2481670803070250p7e6eab01i6660c53188914058@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2008-03-07 at 18:50 +0800, Ke Wei wrote:
> On a system with many SAS targets,  It appears possible that a
> scsi_cmnd can time out without ever making it to the SAS LLDD or at
> the same time that a completion is occurring.
> in file sas_scsi_host.c :
>                /* Queue up, Direct Mode or Task Collector Mode. */
>                if (sas_ha->lldd_max_execute_num < 2)
>                                res = i->dft->lldd_execute_task(task,
> 1, GFP_ATOMIC);
>                else
>                                res = sas_queue_up(task);
> If I set lldd_max_execute_num above 1, I find that libsas couldn't
> queue a task to the SAS LLDD sometimes.
> System will always report: not at initiator: EH_RESET_TIMER.
> Is queue_thread pending? I will keep investigating.

Oh, actually, that's the old task collector mode.  I keep meaning to
strip it out of libsas ... this provides a good excuse.  Basically the
only valid case is lldd_max_execute_num == 1 since, as you found,
anything above that doesn't work.

Are you still seeing timeouts in the lldd_max_execute_num == 1 case?
And if so, is that still with can_queue == 1?

James


