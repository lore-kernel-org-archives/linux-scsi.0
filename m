From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 09:39:04 -0500
Message-ID: <1305297544.2611.22.camel@mulgrave.site>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com>
	 <BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BB82@inbmail01.lsi.com>
	 <BANLkTinqCmZzc2E7G1-W0qB-p8domw4KYA@mail.gmail.com>
	 <alpine.DEB.2.00.1105131406320.20305@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43451 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293Ab1EMOjH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2011 10:39:07 -0400
In-Reply-To: <alpine.DEB.2.00.1105131406320.20305@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Caspar Smit <c.smit@truebit.nl>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Fri, 2011-05-13 at 14:09 +0200, Mikael Abrahamsson wrote:
> On Fri, 13 May 2011, Caspar Smit wrote:
> 
> > I am used to the fact that all disks in a chassis are ordered in linux 
> > according to the slot numbers on the chassis, this is to ensure a 
> > reliable RAID setup so that /dev/sdb for instance is always in a certain 
> > slot in the chassis. So far I only used lsi 3081e-r controllers and 
> > these always gave me solid and reliable disk numbering. If this goes 
> > random, how am i supposed to keep track which disk is where in the 
> > chassis?
> 
> This has been discussed extensively before. There is no way to do it the 
> way you want to.

Actually, there is, we just don't do it as a by-X rule in udev (although
nothing prevents you from adding a custom rule).  If you want to
identify disks by SAS slot, you're basically asking what phy they're
connected to (and if you have expanders and phys, the unique identifier
is expander:[expander ...]:phy.

when udev gets the path to a SAS disk, it looks something like this:

/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host1/port-1:0/expander-1:0/port-1:0:9/end_device-1:0:9/target1:0:1/1:0:1:0/scsi_device/1:0:1:0

So from this you can see I'm on expander 1:0 and port 1:0:9.  The port
number is still dynamic, but from the port you can get to the phys:

ls /sys/class/sas_port/port-1\:0\:9/device/
end_device-1:0:9  phy-1:0:9  power  sas_port  uevent

That tells me port 1:0:9 is indeed phy 1:0:9

so 9 is the phy number.  Expanders are also dynamically numbered, so if
you're behind an expander, you'll have to use something like the
expander serial number as the first part followed by the phy number.  Or
just use enclosure services; most expanders have them.


James


