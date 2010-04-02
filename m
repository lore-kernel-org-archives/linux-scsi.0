From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 02 Apr 2010 11:59:30 -0400
Message-ID: <1270223970.2899.80.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org>
	 <4BB61237.5030000@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BB61237.5030000@ru.mvista.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Mark Lord <liml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-04-02 at 19:50 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Alan Stern wrote:
> 
> >>> Best guess (and it's a guess only) would be that the USB bridge SAT
> >>> layer doesn't implement ATA_16 and so fails in interesting ways when it
> >>> comes in.  Does the ATA_12 version of IDENTIFY DEVICE succeed?
> >>>       
> >> It does.  And in between the two is an ATA_16 SET FEATURES command
> >> which also (apparently) succeeds.  That is, there is no error
> >> indication from the device -- but goodness knows if it actually carries
> >> out the command.
> >>     
> >
> > Incidentally, there's a discussion of this problem with input from an
> > engineer at the company that makes the bridge chip here:
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux-fsl-imx51/+bug/431963
> >
> > See comment #25 and later.  He claims that the ATA pass-through command
> > contains a SECTOR COUNT field of 0 even though it asks for 512 bytes of
> > IDENTIFY data.  This invalid parameter combination causes the bridge
> > chip to get confused, and instead of failing gracefully, it messes up
> > the USB protocol.
> >   
> 
>    IDENTIFY DEVICE command always returns 512 bytes of data, regardless 
> of any value in the sector count register.
> 
> > Does anybody know where to find out why hdparm is sending an IDENTIFY 
> > command with invalid parameters?
> >   
> 
>    IDENTIFY DEVICE command has *no* parameters.

Alan was talking about ATA_16, which has to contain payload data in SCSI
format for the encapsulation to work, so for a command that returns 512b
the ATA_16 has to contain this as the data length.

Sounds like a Mark Lord problem to me ... cc added.

James


