From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sun, 30 Mar 2003 19:26:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303301926.17166.oliver@neukum.org>
References: <20030325100704.GC3868@beaverton.ibm.com> <20030329141512.B10565@one-eyed-alien.net> <1049041398.21704.1451.camel@mulgrave>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1049041398.21704.1451.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-hotplug-devel@lists.sourceforge.net
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


> The way to think about this, I think, is "what would we do if the user
> asked nicely before removing the device" (i.e. requested device ejection
> rather than forced it).  Then the above makes perfect sense because we
> have to start at the top and move down.  Since requested ejection is the
> model for things like hotplug PCI busses, I'm hoping someone else is
> thinking about this.

No this is exactly the way not to ever think about this.
You are not asked to remove a device, you are informed it's gone.
This is the case in all but sometimes one type of bus system in the
kernel. And that is the way information has to flow. Strictly
from the driver closest to the hardware up. And there must be no
undue delay and neither failure. Failure to handle a removal is a
contradiction in terms. This means that any call to user space must not be
waited for in the kernel and failure must not be deadly. Filesystems
must already be ready to deal with incorrectible errors. They are not
your problem.

	Regards
		Oliver

