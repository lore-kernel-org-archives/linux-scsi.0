From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: what does RECOVERED ERROR sense key mean?
Date: Thu, 16 Jan 2003 06:18:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D554@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from talaria.jf.intel.com (talaria.jf.intel.com [10.7.209.7])
	by caduceus.jf.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h0GECZq03128
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 14:12:35 GMT
Received: from orsmsxvs040.jf.intel.com (orsmsxvs040.jf.intel.com [192.168.65.206])
	by talaria.jf.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.28 2003/01/13 19:44:39 dmccart Exp $) with SMTP id h0GDvbF20689
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2003 13:57:37 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'devnetfs' <devnetfs@yahoo.com>, linux-scsi@vger.kernel.org

Yes, if you get the 01 sense key (recovered error), it has already
recovered, so you should not retry.  The mode pages of the device can be set
to report recovered errors or not, but usually it is desirable to report
them so that the information can be used to predict when you need to do
maintenance on the device, etc.

Andy Cress

-----Original Message-----
From: devnetfs [mailto:devnetfs@yahoo.com] 
Sent: Thursday, January 16, 2003 2:43 AM
To: linux-scsi@vger.kernel.org
Subject: what does RECOVERED ERROR sense key mean?


Hello,

I am trying to reserve a disk using SCSI_IOCTL_SEND_COMMAND ioctl.

Sometimes I get SCSI error code=0x2 (ioctl returns this value). From 
the "Linux SCSI Generic HOWTO", above code is a 4-byte compacted error 
code. Here for 0x2 it means: status_byte == CHECK_CONDITION. The Sense
Key I get is 0x1 i.e. "RECOVERED ERROR".

>From the "SCSI Programming HOWTO", "RECOVERED ERROR" means:
---
"Indicates that the last command completed successfully with some
recovery action performed by the target. Details may be determinable 
by examining the additional sense bytes and the information field.
When multiple recovered errors occur during one command, the choice of
which error to report (first, last, most severe, etc.) is device 
specific."
---

So my question is: can I ASSUME that when I get this error(0x2) and
sensekey (0x1) my RESERVER was successful? or should I again retry?

Thanks in Advance,
A.


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
