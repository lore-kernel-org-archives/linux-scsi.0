From: Doug Ledford <dledford@redhat.com>
Subject: Re: aic7xxx_biosparam
Date: Sun, 17 Nov 2002 21:46:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118024645.GB4608@redhat.com>
References: <dledford@redhat.com> <20021118002742.GO3280@redhat.com> <200211180036.gAI0aPY15894@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211180036.gAI0aPY15894@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 06:36:25PM -0600, J.E.J. Bottomley wrote:
> 
> Well, SCSI doesn't implement the BIG_GETGEO ioctl, so this isn't really much 
> use.  You can use sector_div to do the divisions.

Hmmm..should that be changed though?

> However, Andries Brower assures me that the geometry stuff is unused (at least 
> from the cylinders point of view), so all of this is unnecessary anyway.

I beg to differ.  At least on the Adaptec stuff, it gets pissy if the 
partition tables don't look sane (at least older BIOSes do, and those 
cards are still in use, so that means I try and make them work).  Besides, 
when I make changes in this code, the effects are instantly visible in 
fdisk (well, after a module reload), so it get's used somewhere.
  
> There's a large thread about it on linux-scsi (don't have the reference).  The 
> upshot was the code you can see in scsicam.c:scsicam_bios_param().
> 
> So the short answer is that this should be unnecessary.

No, it's needed.  If it isn't there, then when a disk is currently empty 
of any partitions, the generic geometry stuff picks out whatever it can 
find that fits the total capacity best without regard to the BIOS issues 
on the older Adaptec cards, resulting in funky crap that doesn't work.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
