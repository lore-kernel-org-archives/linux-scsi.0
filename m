From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] driverfs scsi for 2.5.24
Date: Fri, 5 Jul 2002 11:31:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0207051126240.8496-100000@geena.pdx.osdl.net>
References: <200207031434.g63EYCv01985@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200207031434.g63EYCv01985@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Douglas Gilbert <dougg@torque.net>, sullivan <sullivan@austin.ibm.com>, Martin Dalecki <dalecki@evision-ventures.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


On Wed, 3 Jul 2002, James Bottomley wrote:

> Actually, the patch already went into Linus' BK tree and will be in 2.5.25.
> 
> dougg@torque.net said:
> > It will probably take a few iterations before we get close to an
> > "approved" naming model :-) 
> 
> That's part of the reason for putting it in early...
> 
> > I'll start with one suggestion: perhaps "kdev" could be replaced by
> > two files: "major" and "minor". 
> 
> I think kdev belongs in the (not yet implemented) class driver, doesn't it? 
> (Pat?), so we shouldn't be doing anything to expose it in SCSI.  If it's done 
> at the class level, the kdev policy will be set globally.

Yes. However, if you guys can use it now, go ahead and implement it where
you see fit. Once the infrasructure is in place, we can push it upwards to
the generic structure. 

> I think the partition `name' file should reflect the partition UUID if one 
> exists, and that the disc `name' file should be mutable by root so we can do 
> fixups (from hotplug) for the exceptional devices that don't have a proper 
> unique name.

Dave Brownell (USB guy) brought this up a few days ago. The 'name' field 
is intended to be a user-friendly ascii description of the device. I'm 
considering changing the name to 'descr' to end all confusion. 

I intend to create a field to represent the unique identifier (maybe 
'uuid'). Again, if you guys need something like that, go ahead and put it 
in the SCSI-specific structure, and let it pushed upwards when the time 
comes. 

	-pat

