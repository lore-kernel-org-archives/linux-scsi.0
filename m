From: "Augustine Ortiz, Jr." <aortizjr@lanl.gov>
Subject: RE: Getting HD Serial Numbers in RAID
Date: Wed, 01 Sep 2004 08:33:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094049224.31782.11.camel@afgar.lanl.gov>
References: <60807403EABEB443939A5A7AA8A7458B0B4445@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailwasher.lanl.gov ([192.65.95.54]:6692 "EHLO
	mailwasher-b.lanl.gov") by vger.kernel.org with ESMTP
	id S266756AbUIAOds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 10:33:48 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B0B4445@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

Hi...

Thank you for the very informative response. I was afraid that the
passthrough was just not supported.

Would it be possible for me to get the driver (OEM) that can report this
information (SRB Passthrough)? Or can I get the pieces to implement the
passthrough myself. 

If you know anything about getting that info in Win32 that would help
greatly also, since I am in the same boat in that OS as well.

Thanks!

Augustine

On Wed, 2004-09-01 at 06:18, Salyzyn, Mark wrote:
> The aacraid module only reports the logicals and none-DASD devices to
> the scsi layer. There is no direct communication to any DASD devices.
> 
> I have toyed with exporting the components of the arrays, but to please
> the (Security, RAID & OEM) gohds I need to ensure that R/W requests are
> not honored. I will look into producing a patch to MarkH for this once
> the current set (about a dozen patches pending) has finished bubbling
> through his hands ...
> 
> The current mechanism for exporting this component information is via
> the applications, there is an SRB passthrough command that is in our OEM
> variant of the driver used for such a purpose. The SRB passthrough was
> rejected by the community and is not in the kernels.org driver and will
> remain a legacy requirement by the OEMs.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Augustine Ortiz,
> Jr.
> Sent: Tuesday, August 31, 2004 5:11 PM
> To: linux-raid@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: RE: Getting HD Serial Numbers in RAID
> 
> Usually, most hardware RAID stuff does give software. However since this
> one (AACRAID/PERC) is such a common controller, this manufacturer didn't
> include it. We do have some for other systems, but they are in Windows,
> and I can't seem to figure out how to get the serial numbers through
> that either.
> 
> Interestingly, if you have the arrays broken, you can pull the serial
> numbers just fine.
> 
> Some RAID cards (ie. DAC90 chipset) will report all the disks when the
> kernel module is loaded. I figured I could just sorta re-work that stuff
> and see if I could probe it. 
> 
> I am having some trouble with the AACRAID module though. It looks like
> it grabs the info, but I can't tell if it does it when the drives are
> actually RAIDed. 
> 
> Thank you for the info, I will see if I can get it via the SMART stuff.
> I will post if I have any luck.
> 
> Thanks!
> 
> Augustine
> 
> 
> >                             From: 
> > Derek Vadala <derek@cynicism.com>
> > You could try smartctl, but I don't know what luck you'll have
> > accessing
> > the raw devices if they are behind a hardware controller.
> > 
> > http://smartmontools.sourceforge.net/
> > http://www.linuxjournal.com/article.php?sid=6983
> > 
> 
> 
> > hddtemp will get you more info on the disk ... not sure if it works
> > on aacraid/perc etc
> > 
> > c ya
> > alvin
> 
> 
> On Tue, 2004-08-31 at 14:36, Guy wrote:
> > When I have used hardware RAID, the vender supplies software that will
> do
> > what you want.  But it is tied to the vender's hardware, not general.
> > 
> > Guy
> > 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Augustine
> Ortiz, Jr.
> > Sent: Tuesday, August 31, 2004 3:45 PM
> > To: linux-raid@vger.kernel.org; linux-scsi@vger.kernel.org
> > Subject: Getting HD Serial Numbers in RAID
> > 
> > Hi...
> > 
> > I have been working on getting serial numbers electronically off of
> hard
> > drives for various reasons.
> > 
> > I have been successful with IDE and most SCSI drives (using hdparm and
> > scsiinfo). However I am running into trouble with ones that are on
> > AACRAID/PERC3 adaptors and actually in a RAID array.
> > 
> > The only serial number I can seem to grab is the one for the entire
> > volume which is just assigned.
> > 
> > Are there any tools available to get the serial number off the drives
> in
> > the array? Or can I get some pointers on writing such a tool?
> > 
> > Thank you.
> > 
> > Augustine
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

