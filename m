From: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Subject: Re: Number of devices that SCSI can support
Date: Wed, 9 Jan 2008 14:31:12 -0800 (PST)
Message-ID: <145723.94801.qm@web43138.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n23b.bullet.mail.sp1.yahoo.com ([69.147.64.243]:27042 "HELO
	n23b.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751695AbYAIWbO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 17:31:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Thank you all for responding. While I agree that the scsi stack in linux should be capable of supporting many targets, I still see this problem all the time. 
It seemed to consistently happen on /dev/sdbm which corresponds to the 65th lun or target.

My SAN configuration consists of: 4 targets with 16 luns each = 4 * 16 = 64 total devices.

But I ran another test by changing my targets information and saw this issue for /dev/sdbm 

As mentioned on this thread, I am attaching some more information. Looks like SCSI inquiry is going through, and the inquiry succeeds. As you can see from the attached message below the /sys/class/scsi_device file also gets created:
at /sys/class/scsi_device/1\:0\:3\:15/device/

and below this we find all the related entries such as:

block/          dump            queue_depth     state
delete          generic/        rescan          timeout
detach_state    model           rev             type
device_blocked  power/          scsi_level      vendor

So from this information it looks like the scsi mid layer had detected that particular lun. But the /dev/sdbm device has not been created. It was also mentioned that it could be a udev problem. 

The other curious issue is that if take the major number and the minor number from this entry and manually create the device file as such:

mknod /dev/sdbm 68 0 

it works after I rescan all the targets and luns and I am able to perform I/O on this lun. 

Any other ideas. 

Thanks,
Vinay

----- Original Message ----
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>; linux-scsi@vger.kernel.org; Matthew Wilcox <matthew@wil.cx>
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





      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

