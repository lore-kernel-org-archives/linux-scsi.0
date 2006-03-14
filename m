From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [SCSI] aic94xx: remove event thread
Date: Tue, 14 Mar 2006 10:00:00 -0800
Message-ID: <1142359200.8649.156.camel@localhost.localdomain>
References: <1142179567.3297.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56537 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752342AbWCNSA4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 13:00:56 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2EI0uxW021793
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 13:00:56 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2EI3oHd162194
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 11:03:50 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2EI0toa005117
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 11:00:55 -0700
In-Reply-To: <1142179567.3297.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2006-03-12 at 10:06 -0600, James Bottomley wrote:
> This patch moves the discovery and event processing entirely over to
> being workqueue based.  Additionally, it tries to ensure discovery gets
> time to proceed before finishing the module load.  There's still a
> non-determinism in there since it starts with a port interrupt for a
> connected phy after phys are enabled, so there's a ssleep(1) in there to
> capture this before the scsi_flush_work() waits for it to complete.

Just wanted to let you know that this patch has passed an overnight
reboot test on a x366.  The ssleep(1) seems to allow for enough time in
order to verify that sas_process_events has been called before waiting
on discovery.

> 
> James
> 

Regards,

Alexis

>  
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

