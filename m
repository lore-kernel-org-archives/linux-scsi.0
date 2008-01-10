From: berthiaume_wayne@emc.com
Subject: RE: Number of devices that SCSI can support
Date: Thu, 10 Jan 2008 10:15:17 -0500
Message-ID: <D364D39DAD21D444BAE2C70919B6280908D87FC8@CORPUSMX40A.corp.emc.com>
References: <E5C8AFD1ADF9DF48AD935F49588E895507F11024@gamx.iccur.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:22514 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbYAJPPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 10:15:34 -0500
Content-class: urn:content-classes:message
In-Reply-To: <E5C8AFD1ADF9DF48AD935F49588E895507F11024@gamx.iccur.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bob.ellison@ccur.com, raghavanvinay@yahoo.com, andrew.vasquez@qlogic.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, matthew@wil.cx

The capi bug is fixed in RHEL 4.6. 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ellison, Bob
Sent: Thursday, January 10, 2008 9:19 AM
To: Vinay Venkataraghavan; Andrew Vasquez
Cc: James Bottomley; linux-scsi@vger.kernel.org; Matthew Wilcox
Subject: RE: Number of devices that SCSI can support

I ran into this under RHEL4 and it turned out to be udev and the capi20
declaration. I commented the declaration out in 50-udev.rules (as well
as the capi/%n) and started seeing my sd node appear (i.e. device 68:0).
--
Bob

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Vinay
Venkataraghavan
Sent: Wednesday, January 09, 2008 5:31 PM
To: Andrew Vasquez
Cc: James Bottomley; linux-scsi@vger.kernel.org; Matthew Wilcox
Subject: Re: Number of devices that SCSI can support

Thank you all for responding. While I agree that the scsi stack in linux
should be capable of supporting many targets, I still see this problem
all the time. 
It seemed to consistently happen on /dev/sdbm which corresponds to the
65th lun or target.

My SAN configuration consists of: 4 targets with 16 luns each = 4 * 16 =
64 total devices.

But I ran another test by changing my targets information and saw this
issue for /dev/sdbm 

As mentioned on this thread, I am attaching some more information. Looks
like SCSI inquiry is going through, and the inquiry succeeds. As you can
see from the attached message below the /sys/class/scsi_device file also
gets created:
at /sys/class/scsi_device/1\:0\:3\:15/device/

and below this we find all the related entries such as:

block/          dump            queue_depth     state
delete          generic/        rescan          timeout
detach_state    model           rev             type
device_blocked  power/          scsi_level      vendor

So from this information it looks like the scsi mid layer had detected
that particular lun. But the /dev/sdbm device has not been created. It
was also mentioned that it could be a udev problem. 

The other curious issue is that if take the major number and the minor
number from this entry and manually create the device file as such:

mknod /dev/sdbm 68 0 

it works after I rescan all the targets and luns and I am able to
perform I/O on this lun. 

Any other ideas. 

Thanks,
Vinay

----- Original Message ----
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>;
linux-scsi@vger.kernel.org; Matthew Wilcox <matthew@wil.cx>
Sent: Wednesday, January 9, 2008 7:49:33 AM
Subject: Re: Number of devices that SCSI can support


On Wed, 09 Jan 2008, Matthew Wilcox wrote:

> On Wed, Jan 09, 2008 at 09:05:52AM -0600, James Bottomley wrote:
> > On Tue, 2008-01-08 at 19:22 -0700, Matthew Wilcox wrote:
> > > On Tue, Jan 08, 2008 at 04:55:46PM -0800, Vinay Venkataraghavan
 wrote:
> > > > Is there a limit on the number of devices that SCSI supports.
 In other words, I have a QLogic HBA card, and I am connecting to a SAN
 which has 64 targets. 
> > > 
> > > I've personally had over five hundred LUNs.  You shouldn't be
 hitting a
> > > limit here.
> > 
> > I believe the largest test that's been run was the old OSDL CGL
> > workgroup ... they went up to 4096.
> > 
> > However, LUN support depends on the driver and HBA parameters as
 well
> > (some choose to have arbitrary limits).
> 
> I was using a qlogic HBA for my tests, so I don't think this is the
> problem -- although the original poster claims to have 64 targets,
 and I
> had only one target with 128 luns (attached 4 times).
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take
 such
> a retrograde step."

Not sure what's going on as well, perhaps some logs could help... But
the inbox qla2xxx driver in RHEL4 set's an HBA's scsi_host->max_id
count to 512 (also verified with several test rings), so there
shouldn't be a problem handling 64 distinct targets (FC ports).
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi"
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html





 
________________________________________________________________________
____________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

