From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 2 Oct 2002 09:26:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D250@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxv040-1.fm.intel.com (fmsmsxvs040.fm.intel.com [132.233.42.124])
	by petasus.ch.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.46 2002/09/23 20:41:22 dmccart Exp $) with SMTP id g92GQsG06749
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 16:26:54 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James,

I had been trying to do that with a user-level daemon I've written
(sgraidmon at scsirastools.sf.net), but I can't rescan from user level
because the new devices aren't attached to any /dev, so the user-level can't
detect that a new device has been inserted, and it doesn't have any way to
detect which device it might be.  

Previous development has assumed that some administrator "knows" what the
new device is and that it has been inserted, in order to invoke a hotplug
function.  My use case is to make software RAID more like hardware RAID,
where a service tech inserts the disk and walks away, and the software raid
(OS & daemon) detects it and handles it automatically.

Andy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@steeleye.com] 
Sent: Wednesday, October 02, 2002 11:35 AM
To: Cress, Andrew R
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass) 

andrew.r.cress@intel.com said:
> Here is a 2nd pass at a patch to do a scsi rescan so that hot-inserted
> scsi disks can automatically be recognized.  It includes some
> recommended changes/cleanup from Patrick and Mike. 

Is there a really good reason we can't use the hotplug infrastructure for
this 
and scan from user level?  I know the 2.4 hotplug is less well developed
than 
2.5, but I believe it will work well enough for this.

If you go the hotplug route, all we need is a hook to trigger the SCSI
hotplug 
event.

James

