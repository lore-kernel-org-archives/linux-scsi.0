From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 2 Oct 2002 09:40:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D251@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxv040-1.fm.intel.com (fmsmsxvs040.fm.intel.com [132.233.42.124])
	by petasus.ch.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.46 2002/09/23 20:41:22 dmccart Exp $) with SMTP id g92GeeW15789
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 16:40:40 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>, "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-scsi@vger.kernel.org

James,

A user-space hotplug event can't be guaranteed to have enough information in
all cases.
Possible cases:
  1) Administrator "knows" and manually issues a hot-plug command. 
  2) A daemon detects a SAF-TE or SES event by slot number.  
     Not sure if we can really determine what we need from just a slot
number?
  3) Other external disk enclosure (JBOD) that doesn't expose a 
     SAF-TE or SES interface.
     This case is out in the cold without the kernel-level rescan.

I'm disregarding case (1), since my target customer environment won't
tolerate the manual step.

Andy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@steeleye.com] 
Sent: Wednesday, October 02, 2002 12:29 PM
To: Cress, Andrew R
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass) 

andrew.r.cress@intel.com said:
> I had been trying to do that with a user-level daemon I've written
> (sgraidmon at scsirastools.sf.net), but I can't rescan from user level
> because the new devices aren't attached to any /dev, so the user-level
> can't detect that a new device has been inserted, and it doesn't have
> any way to detect which device it might be.   

Right, that's why the hotplug event has to carry enough information to allow

the script to identify what needs to be scanned (i.e. SCSI hostadapter
number 
and PUN if possible). the scsi add-single-device mechanism can then be used
to 
do the attachment (and scanning).

James



