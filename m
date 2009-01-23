From: "Sudhakar Pannerselvam" <sudhakarp@inmage.net>
Subject: RE: [dm-devel] RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 22:22:48 -0800
Message-ID: <D4B83214B57CAC4499F1114D069E451A01A7D765@bunker.inside.abhaisystems.com>
References: <E463DF2B2E584B4A82673F53D62C2EF45CEAB8A3@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 64-60-250-125.static-ip.telepacific.net ([64.60.250.125]:33548
	"EHLO bunker.inside.abhaisystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763177AbZAWGWu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 01:22:50 -0500
Content-class: urn:content-classes:message
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45CEAB8A3@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>, device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org

As James mentioned earlier, this is a distribution issue. I had seen
this issue with redhat. If you observe redhat distro qlogic drivers,
they compile firmware files along with the driver and hence they
wouldn't observe this issue when they load through initrd as there is no
firmware loading procedure through hotplug interface, whereas if you
compile qlogic driver by hand without inbuilt firmware files and using
distro's like redhat, you would encounter this issue. This has to be
addressed in nash hotplug code. 

One workaround that I could think of, as I mentioned above this is an
issue with nash which is active only when you load qlogic through initrd
mechanism. Check if you really need to compile your qlogic driver as
part of initrd image and recreate initrd image without qlogic module.
Later you could load the qlogic module(again using hotplug mechanism)
when kernel comes alive.

Regards
Sudhakar

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Moger, Babu
> Sent: Friday, January 23, 2009 5:46 AM
> To: device-mapper development
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] RE: qla2xxx 0000:03:0c.0: Firmware 
> image unavailable
> 
> 
> Yes, firmware images are in the initrd. I have verified that. 
> 
> Thanks
> Babu Moger 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Dave Holland
> Sent: Thursday, January 22, 2009 10:46 AM
> To: device-mapper development
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [dm-devel] RE: qla2xxx 0000:03:0c.0: Firmware 
> image unavailable
> 
> On Thu, Jan 22, 2009 at 08:20:48AM -0700, Moger, Babu wrote:
> > You are right. Looks like qlogic driver loads even before 
> udev hotplug 
> > is functional.  Driver loads successfully when I re-load the driver 
> > after the system in up.  Is there any solution or 
> work-around for this 
> > problem?
> 
> So the problem only happens at boot time? Are you using an 
> initrd, and if so, have you got the firmware images in the 
> initrd image?
> (mkinitramfs, update-initramfs, etc)
> 
> Dave
> --
> ** Dave Holland ** Systems Support -- Infrastructure Management **
> ** 01223 496923 ** The Sanger Institute, Hinxton, Cambridge, 
> UK ** "Your bumper is my crumple zone."
> 
> 
> -- 
>  The Wellcome Trust Sanger Institute is operated by Genome Research 
>  Limited, a charity registered in England with number 1021457 and a 
>  company registered in England with number 2742969, whose registered 
>  office is 215 Euston Road, London, NW1 2BE. 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
