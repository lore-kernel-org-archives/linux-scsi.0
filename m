From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/5] scsi host / scsi target state model update
Date: Wed, 22 Jun 2005 16:46:59 -0700
Message-ID: <20050622234659.GA572@us.ibm.com>
References: <Pine.LNX.4.44L0.0506221657200.5325-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44502 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261764AbVFVXqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 19:46:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5MNke93014981
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2005 19:46:40 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5MNkejx227394
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2005 19:46:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5MNkejn010585
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2005 19:46:40 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506221657200.5325-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> Mike:
> 
> In your first patch, you don't allow transitions from SHOST_RECOVERY to 
> SHOST_CANCEL nor the other way around.  So this section of the patch looks 
> suspicious:
> 

Yes the host state model may need to allow this transition. The rest of
the patch series removes scsi_host_cancel so I was not running this
function when the series was fully applied.

> @@ -60,12 +136,11 @@ static void scsi_host_cancel(struct Scsi
>  {
>         struct scsi_device *sdev;
>  
> -       set_bit(SHOST_CANCEL, &shost->shost_state);
> +       scsi_host_set_state(shost, SHOST_CANCEL);
>         shost_for_each_device(sdev, shost) {
>                 scsi_device_cancel(sdev, recovery);
>         }
> -       wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
> -                                               &shost->shost_state)));
> +       wait_event(shost->host_wait, (shost->shost_state != SHOST_RECOVERY));
>  }
> 
> 
> In fact there are lots of places in the patch where scsi_host_set_state 
> is called and the return value is not checked.  They may end up causing 
> trouble.
> 

Yes, I am not sure what checking a return value will do in all cases (like
in scsi_remove_host). I notice that most of scsi_device_set_state cases
are not checked or have void function wrappers. It would appear that these
functions (scsi_device_set_state and scsi_host_set_state) should be void
functions with WARN_ONs to go correct the state model or the calling
function.

> Also, is it a good idea to allow write access to the shost_state 
> attribute?  For debugging, yes, okay, but in general it doesn't seem like 
> a good thing.
> 

Yes, after debugging we should remove the write access. We allow write on
the device state (usually used to re-online a device that the error handler
marked offline), but there probably is no need to change the state of a
host from user space. In a future patch we could remove write access to
the scsi device state and possibly have an option to not offline the
devices in the error handler to cover the need I would assume most people
use the device state write access for.

-andmike
--
Michael Anderson
andmike@us.ibm.com

