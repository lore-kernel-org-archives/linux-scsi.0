From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: doubts about sg driver
Date: Thu, 14 Jun 2007 13:51:31 -0600
Message-ID: <1181850692.23655.117.camel@bluto.andrew>
References: <84219.67525.qm@web30104.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:48378 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXFNTwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 15:52:04 -0400
In-Reply-To: <84219.67525.qm@web30104.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Parav Pandit <paravpandit@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Hi Parav,

On Thu, 2007-06-14 at 10:47 -0700, Parav Pandit wrote:
> Hi,
> 
> Few basic questions on sg driver:
> 
> 1. Are there any hooks that low level HBA driver needs
> to implement - for providing support for SG (SCSI
> generic) driver?

No. This is all done in the sg/scsi-midlayer.

> Or SG always interacts with scsi_mod and it is
> transparent to the HBA drivers?

Yes.

> From the tldp How-to and sg.c it looks like it doesn't
> directly talk with Low level HBA driver, but want to
> confirm.

Correct.

> 
> 2. Can applications talk with SCSI RAID controller
> device (some targets exposes LUN-0 as controller) 
> through sg interface or it is only for storage
> devices?

Any SCSI device.

> 
> 3. How is the mapping between /dev/sda /dev/sdb etc to
> /dev/sg0 /dev/sg1 etc?
> Is this information is accessible via procfs or sysfs
> interface?
> 

In 2.6 kernels, you can looks at:

/sys/class/scsi_device/h:c:t:l/scsi_generic:sg# 

in 2.4 and 2.6 you can look at /proc/scsi/sg/devices.  Where the
contents is:

seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
                              scsidp->host->host_no, scsidp->channel,
                              scsidp->id, scsidp->lun, (int)          scsidp->type,
                              1,
                              (int) scsidp->queue_depth,
                              (int) scsidp->device_busy,
                              (int) scsi_device_online(scsidp));



> Regards,
> Parav Pandit
> 
> 
> 
>        
> ____________________________________________________________________________________
> Be a better Globetrotter. Get better travel answers from someone who knows. Yahoo! Answers - Check it out.
> http://answers.yahoo.com/dir/?link=list&sid=396545469
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Andrew Patterson
Hewlett-Packard Company

