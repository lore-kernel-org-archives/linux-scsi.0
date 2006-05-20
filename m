From: Amit Arora <aarora@in.ibm.com>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in
	scsi_scan_host_selected()
Date: Sat, 20 May 2006 12:41:04 -0700
Message-ID: <1148108792.13190.36.camel@amitarora.in.ibm.com>
References: <1148080489.23417.18.camel@amitarora.in.ibm.com>
	 <20060520042132.GC2826@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:487 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751475AbWETTl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 15:41:57 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4KJfr0C009618
	for <linux-scsi@vger.kernel.org>; Sat, 20 May 2006 15:41:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4KJfrBN093834
	for <linux-scsi@vger.kernel.org>; Sat, 20 May 2006 15:41:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4KJfrGQ006469
	for <linux-scsi@vger.kernel.org>; Sat, 20 May 2006 15:41:53 -0400
In-Reply-To: <20060520042132.GC2826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com

On Fri, 2006-05-19 at 21:21, Matthew Wilcox wrote:
> On Fri, May 19, 2006 at 04:14:50PM -0700, Amit Arora wrote:
> > The scsi_scan_host_selected() should return -EINVAL when the id is equal
> > to the max_id. Currently it uses ">" when comparing with max_id, and
> > hence leaves the border case when "id==max_id".
> > The channel and lun have values valid from 0 up to,
> > and including, max_channel or max_lun. But, the valid values for id
> > range from 0 to max_id-1. This patch fixes the problem.
> 
> You're right, but the patch is wrong.  It's not acceptable to have
> different meanings for variables with such similar names.  Either it
> needs to be renamed to id_count or we need to fix all the other users of
> max_id.

I agree that similar sounding variable names should not have different
meanings, but having this slight inconsistency for the time being (till
we have a new naming convention for these variables) is better than
having a bug in the code which brings down the whole system ! Obviously
the current code is wrong and is thus resulting in a system crash
(actually a BUG_ON) when following command is issued on a system with an
Adaptec SCSI controller (aic7xxx/aic79xx driver) :
"echo 0 16 0 > /sys/class/scsi_host/host0/scan"
It might behave similarly on other drivers as well.

Thus, I still think applying the patch might be a good idea in the
immediate future. Moreover, this patch doesn't change the current
definition of any of these variables and results in a behavior which is
currently expected. So, till the time we figure out what should be done
in the long run to remove any confusion over the definition of these
variables - why not apply the patch ?

Sorry, being a novice in this area, I did not understand what you meant
by "other users of max_id". I think all the drivers currently have it as
"maximum value of id possible" + 1. Please correct me if I am wrong.

> 
> BTW, I think we have another problem with max_lun:
> 
> 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
> 	...
> 	for (lun = 1; lun < max_dev_lun; ++lun)
> 
> surely that should be <= ?

Yes, looks wrong to me.


Thanks for your reply!
Regards,
Amit Arora

