From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 15:18:47 -0700
Message-ID: <1206051527.19541.14.camel@alexis>
References: <47E2B044.70705@ipax.at>
	 <1206039714.3038.40.camel@localhost.localdomain> <47E2B7EF.1050203@ipax.at>
	 <1206043027.3038.48.camel@localhost.localdomain> <47E2D268.2070609@ipax.at>
	 <1206047850.3038.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37832 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbYCTWV4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 18:21:56 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2KMLfQP026399
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 18:21:41 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2KMLfhi238174
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 18:21:41 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2KMLft1030050
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 18:21:41 -0400
In-Reply-To: <1206047850.3038.52.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>, linux-scsi@vger.kernel.org


On Thu, 2008-03-20 at 16:17 -0500, James Bottomley wrote:
> On Thu, 2008-03-20 at 22:08 +0100, Raoul Bhatia [IPAX] wrote:
> > hi james,
> > 
> > James Bottomley wrote:
> >  > A work around might be to lower the queue depth to say 4 or 8 and up the
> >  > retries (this latter can only be done by altering the SD_MAX_RETRIES
> >  > parameter in include/scsi/sd.h and recompiling).
> > 
> > any suggestions for these parameters:
> > 
> > include/scsi/sd.h:
> >  > #define SD_TIMEOUT              (30 * HZ)
> >  > #define SD_MOD_TIMEOUT          (75 * HZ)
> >  >
> >  > #define SD_MAX_RETRIES          5
> >  > #define SD_PASSTHROUGH_RETRIES  1
> > 
> > shall i alter the timeouts?
> 
> The timeouts can be altered on the fly
> at /sys/class/scsi_device/<device>/device/timeout
> 
> but I'd leave them as is for now ... it wasn't the timeouts that fired.
> 
> > what is a good value for the retries? time it by 2? by 5? by 10?
> 
> I'd up the retries to say 15 and see if that works.
> 
> > moreover, where can i lower the queue?
> 
> echo <new depth> > /sys/class/scsi_device/<device>/device/queue_depth

We have played a lot with the queue depth on this controller.  So far
the best we have done is extended the time before an end device is
eventually dropped.  I am very curious to see what happens in Raoul's
test case.


> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

