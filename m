From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v2 0/8] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Mon, 15 Apr 2013 10:13:02 -0400
Message-ID: <1366035182.30762.14.camel@localhost.localdomain>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
	 <516730A1.4090302@tributary.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3DOONK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 10:13:10 -0400
In-Reply-To: <516730A1.4090302@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2013-04-11 at 16:52 -0500, Jeremy Linton wrote:
> 	What happened to this patch? The trail of suggested fixes for the REPORT LUNS
> DATA HAS CHANGED check condition is getting pretty long. The number of devices
> (our product included) in the field that have the ability to on the fly modify
> the luns on an I_T nexus is not decreasing.

I haven't heard back about it.  If some people would ACK it I think that
would help.  I also submitted a separate patch for automatic LUN
removal.

> 
> 	Is it because these patches are trying to fix more than one thing?
> 
> 	What is the preferred way to fix this?
> 
> 	Why not simply add a couple sdev_evt_send_simple()'s and an event coalesce
> function to collapse this event when its received from multiple LUNs on the
> I_T? A couple extra uevents isn't going to kill udev right?

Well, the patch does that, among other things.  I think handling the
other UA codes is a good idea, because existing LUNs can be
reconfigured.  Coalescing events in the kernel is necessary because
udev couldn't handle a large number of events from a big storage
configuration.

>                                                             A really
> fancy
> patch could attempt to clear the check conditions from LUNs that share the I_T.

I think the mid-layer will handle that automatically.  If check
conditions are reported the commands will have to be reissued.

-Ewan
> 
> 	
> 
> 
> 
> 


