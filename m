From: berthiaume_wayne@emc.com
Subject: RE: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 14:11:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BFA62@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: dledford@redhat.com
Cc: alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, rabeeh@galileo.co.il

	Excellent. I assume that reboot will still have its usual discovery
methodology so if you were to hot plug in a new device and its placed at the
end of the chain, it could very well end up somewhere else after the reboot?
In other words, you have two Adaptec adapters (A & B) with two drives each.
Adapter A has sda and sdb; and adapter B has sdc and sdd. You add a new
drive to adapter A and now adapter A has sda, sdb, and sde. However, on a
system reboot adapter A would now have sda, sdb, and sdc; and adapter B
would have sdd and sde. True? Therefore, the sysadmin needs to be wise to
this modality or he's hosed at the next boot.

Wayne.

-----Original Message-----
From: Doug Ledford [mailto:dledford@redhat.com]
Sent: Monday, May 20, 2002 1:58 PM
To: berthiaume_wayne@emc.com
Cc: alan@lxorguk.ukuu.org.uk; linux-scsi@vger.kernel.org;
rabeeh@galileo.co.il
Subject: Re: Hot plugging a disk in runtime


On Mon, May 20, 2002 at 12:34:46PM -0400, berthiaume_wayne@emc.com wrote:
> 	Will it, possibly, cause a reordering of other sd<xx> devices
> already on line when scsi_init is called?

No, it will not move any devices that already exist.  It will either 
insert into the chain in the first hole it finds, or append to the end of 
the chain.  This way, if you have drives sda through sdd and you remove 
sdb, then when you do an add, the new drive will take the now vacant sdb 
slot.  For the common case of wanting to replace a failed drive, this is 
the perfect behaviour.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
