From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Help - how to identify the callers in aSCSIlower-leveldriver
Date: Fri, 16 Apr 2004 16:00:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFAB@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:22993 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S263811AbUDPVAH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 17:00:07 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <yanling.qi@lsil.com>
Cc: linux-scsi@vger.kernel.org

Thanks for the info.

When you say "check 'current->comm' in the ioctl() of scsi_host_template."  Did you mean let user application use "current->comm" as one of the args of the ioctl call, and pass it from user space -> upper-level -> mid-level -> ioctl() defined in low-level driver?

If "current->comm" is related to application's pid, it probably won't be the same every time we run the application, correct?

Thanks,


Lee


-----Original Message-----
From: Qi, Yanling [mailto:yanling.qi@lsil.com]
Sent: Tuesday, April 13, 2004 12:13 PM
To: Lee Xing; Qi, Yanling; arjanv@redhat.com
Cc: linux-scsi@vger.kernel.org
Subject: RE: Help - how to identify the callers in aSCSIlower-leveldriver


"current" is the current task (process) that calls your kernel function. For read/write IOs, most of time, it is not the user application process. It could be "kupdated", ksoftirqd,or dbflush". But for an pass-through ioctl command, "current" should be the user application that issues the ioctl.
Yanling 
-----Original Message----- 
From: Lee Xing [mailto:lxing@crossroads.com] 
Sent: Tuesday, April 13, 2004 11:23 AM 
To: Qi, Yanling; arjanv@redhat.com 
Cc: linux-scsi@vger.kernel.org 
Subject: RE: Help - how to identify the callers in a SCSIlower-leveldriver 


Thanks for the info. 
If I understand right, when an user-space application issues an command (such as read( ), write( ), etc.) or a SCSI passthrough ioctl call to an attached SCSI device, it doesn't pass its ID info with such command or ioctl call to SCSI upper-level driver.  If this is really right (please correct me if I'm wrong), how we can get the application's ID info from "current->comm" in the ioctl( ) of scsi_host_template?
Thanks, 


Lee 
-----Original Message----- 
From: Qi, Yanling [mailto:yanling.qi@lsil.com] 
Sent: Wednesday, April 07, 2004 4:04 PM 
To: Lee Xing; arjanv@redhat.com 
Cc: linux-scsi@vger.kernel.org 
Subject: RE: Help - how to identify the callers in a SCSIlower-leveldriver 


Can you check "current->comm" in your ioctl() of scsi_host_template? 
-----Original Message----- 
From: Lee Xing [mailto:lxing@Crossroads.com] 
Sent: Wednesday, April 07, 2004 3:43 PM 
To: arjanv@redhat.com 
Cc: linux-scsi@vger.kernel.org 
Subject: RE: Help - how to identify the callers in a SCSI 
lower-leveldriver 


Thanks for the response. 
The shim (a pseudo SCSI lower-level driver) we are working on sits in between Linux SCSI mid-level driver and our existing kernel driver which interfaces with a FC driver which interacts with the FC HBA.
To track SCSI initiators' tasks, it would be great if our existing kernel driver knows which application makes the (SCSI passthrough ioctl) call to /dev/sda.
Thanks, 


Lee 
-----Original Message----- 
From: Arjan van de Ven [mailto:arjanv@redhat.com] 
Sent: Wednesday, April 07, 2004 3:02 PM 
To: Lee Xing 
Cc: linux-scsi@vger.kernel.org 
Subject: Re: Help - how to identify the callers in a SCSI 
lower-leveldriver 


On Wed, 2004-04-07 at 21:52, Lee Xing wrote: 
> Hi, 
> 
> I'm writing a pseudo Linux lower-level SCSI driver, which interfaces with the standard mid-level driver and needs to identify different calling applications in Linux user space.  For example, there are 2 applications, app1 and app2, in user space, and they both use /dev/hda.  We don't need the SCSI lower-level driver to know the applications' names "app1" or "app2", but just need it to tell the (SCSI passthrough ioctl) calls are from the "this" application or from "that" application.


you'll find that most IO's will come from the VM subsystem and not 
directly from applications. Why do you think you need this functionality 
???? 
- 
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
