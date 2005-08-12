From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Fri, 12 Aug 2005 07:36:11 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684FE0@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51145 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750971AbVHLLiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 07:38:25 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>, Bryan Henderson <hbryan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I am of the same mind here regarding the busy check, better to have a
coarse or overly paranoid understanding of ref count. But we desire a
ref count on the disk (/dev/sda) overall, not on the partition
(/dev/sda2) as would typically be mounted.

As for using fuser as James had suggested, needing to check each
partition for a user count is just wrong and time consuming and flawed
when someone makes their own dev 'elsewhere' to access the disk. I want
to know if the disk is busy, not the partitions, and not have to check
the multitude of individual possible access points to the disk before
satiating my need.

Our folks freaked when I suggested they use 'popen()' to pick up the
response from fuser. They view that as a security hole. And I am sure to
be flamed for this, importing open source fuser code got the
'proprietary gohds' also equally messed up (GPL infects, BSD relieves
stomach ulcers).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Harald Seipp
Sent: Friday, August 12, 2005 4:59 AM
To: Bryan Henderson
Cc: James Bottomley; SCSI Mailing List
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)

> Don't use /etc/mtab.  Don't use it for anything if you can help it; it
was
> important technology in its day, but we can now go to the horse's
mouth
--
> the kernel -- for that information.
> /proc/mounts will tell you what is really mounted.
But:
1. /proc/mounts hides the most important information - the physical
device
of the root fs - it will always be /dev/root - so I don't see a way to
get
down to the physical device
2. In my understanding, long-term-strategically procfs will only be used
for process information and all other information should be covered by
sysfs. So I doubt that using /proc/mounts will be a long-term solution
>
> As you mentioned in another posting, this isn't really the information
you
> want either -- you want to know if the SCSI disk is in use.  Being the
> device backing a conventional filesystem image is only one way a SCSI
disk
> might be in use.
For our usage, the device ref count information would be enough - we
won't
care about the difference if the device is really mounted or if just one
process is sitting inside the sysfs tree of the device, we just would
not
issue the remove-single-device to that device.

Harald Seipp
IBM Systems and Technology Group

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
