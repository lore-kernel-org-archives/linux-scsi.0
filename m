From: Shoemaker Christopher A NPRI <ShoemakerCA@Npt.NUWC.Navy.Mil>
Subject: RE: qla2xxx random device resets, eventual io errors, invalid con	text
Date: Fri, 26 Sep 2003 09:48:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3BEEE23D31CAD2118D920008C75D894604E1D5A8@NPRI54EXC21.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from NPRI54MAI02.Npt.NUWC.Navy.Mil ([164.223.1.101]:13580 "EHLO
	npri54mai02.npt.nuwc.navy.mil") by vger.kernel.org with ESMTP
	id S262202AbTIZNuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 09:50:12 -0400
Received: from npri54exc23.npt.nuwc.navy.mil
 (NPRI54EXC23.NPT.NUWC.NAVY.MIL [129.190.70.168])
 by npri54mai02.npt.nuwc.navy.mil (PMDF V6.2-X17 #30632)
 with ESMTP id <NDYS08OPST28UG01L4@npri54mai02.npt.nuwc.navy.mil> for
 linux-scsi@vger.kernel.org; Fri,
 26 Sep 2003 09:50:06 -0400 (Eastern Daylight Time)
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Vasquez' <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Andrew,
	Thanks for looking at my logs.  I guess I might have saved myself some time if I'd just concentrated on those initial LIP resets.  Oh well.

> I have a feeling the kernel is using bounce-buffers for the transfers.
> Unfortunately, not all kernels (vary by version and distribution) use
> a consistent nomenclature for scsi host template members, i.e.
> can_dma_32, highmem_io, vary_io, etc...  Earlier versions of the
> drivers would attempt to infer names/existence of members based on
> kernel CONFIG options and version -- the success rate was 
> rather poor.  
> Our next driver release will use a 'more' intelligent method of
> determining host members with the help of the compiler.  

By "next" do you mean ver 8 beta 6, or something more major?

> > Sep 22 12:42:47 fer kernel: scsi(5): LIP reset occurred.
> > Sep 22 12:42:47 fer kernel: scsi(5): LIP occurred.
> > Sep 22 12:42:47 fer kernel: scsi(5): Waiting for LIP to complete...
> > Sep 22 12:42:47 fer kernel: scsi(5): Topology - (Loop), Host 
> > Loop address 0x2
> 
> This is not good.  All your subsequent observations appear to be side
> effects of the RESETs occurring on the loop.  
> 

I see.  That's good to know.

> 
> No, this is the problem, or at least one of them.  You need to
> determine why LIP resets are occuring within the loop.  
> 

> 
> > **** THINGS I'VE TRIED:
> > 	-) I set both qla2300's to "Set Hard Loop ID", with 
> > different IDs.
> > 	-) I upgrade the firmware on the RAID device from 3.23j 
> > to ver. 3.23r from 
> ftp://ftp.infortrend.com/3200%265200/firmware/3.23/
> > 		Reboot, again, same behavior.
> > 	-) I switch the two devices to the opposite qla2300 
> > HBA, thinking maybe the new one is just bad.
> > 		Reboot, again, same behavior with the other HBA.
> >
> 
> Given this information, my best guess would be the target may be
> having some problems within the loop, since as you say, the problems
> followed the HBA.
> 
> As I stated earlier, we need to find and diagnose the LIP reset
> problem.
> 
> The quickest route, from a driver perspective, would be to get a FC
> trace between the HBA and target.  Would you happen to have a finisar
> available?
> 
> We could then tell immediately where the reset is occuring.  But,
> given that the problem seems to follow the HBA that the target in
> question is plugged into, once again, it's likely that this a target
> problem.
> 
> I may be able to provide a more defintive answer if a FC trace was
> provided.
> 
> Hope this helps,
> 
> Andrew Vasquez
> QLogic Corporation

Yes, I've pretty much convinced myself it's not a problem with the HBA.  I don't have a finisar immediately available, but if I find out more specifically what I need, there's a chance I could borrow one.  But OTOH, there's only one device on the HBA, and there's only the one copper cable (which I've tried replacing).  What detail could a FC trace give?  If it would help, what type of Finisar would I need?

Since there's only one device, is there any possibility other than to say that device is generating the "LIP reset primitive sequence"?  I mean, it's not possible that this fault is on the HBA/server/driver side of things, is it?

Are the LIP resets unique to loop mode?  Should I try some more tests with the card in point-to-point mode?

By the way, the device is a 2TB Infortrend SentinelRAID 2500.  I don't know much about the RAID controller, except that it's running a PPC750.

Thanks for your help.  Somehow it's comforting to hear an authoritative voice say, "No, it's not you - you have real problems!"

-Chris
