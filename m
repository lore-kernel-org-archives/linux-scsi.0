From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx_biosparam
Date: Sun, 17 Nov 2002 18:36:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211180036.gAI0aPY15894@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA26746
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 16:36:28 -0800
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id QAA26655
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 16:36:26 -0800
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id gAI0aPY15894
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 18:36:25 -0600
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Sun, 17 Nov 2002 19:27:42 EST." <20021118002742.GO3280@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

dledford@redhat.com said:
> So, this is the change I made to update it so that it won't puke on
> large  devices.  It seems to be working OK for me, but I didn't check
> the gcc  assembly output to see if it's horrible.  Unless someone
> tells me I'm  smoking crack for making this change, I'll submit it
> pretty soon (I don't  consider myself a partition expert, I'm just
> trying to make sure that when  geometry does get defined on my driver
> that it at least is something the  Adaptec BIOS will accept, and the
> Adaptec BIOS *only* accepts the two  listed head/sector combos). 

Well, SCSI doesn't implement the BIG_GETGEO ioctl, so this isn't really much 
use.  You can use sector_div to do the divisions.

However, Andries Brower assures me that the geometry stuff is unused (at least 
from the cylinders point of view), so all of this is unnecessary anyway.  
There's a large thread about it on linux-scsi (don't have the reference).  The 
upshot was the code you can see in scsicam.c:scsicam_bios_param().

So the short answer is that this should be unnecessary.

James


