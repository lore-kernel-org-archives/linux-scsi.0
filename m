From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/4] scsi: use 64-bit LUNs
Date: Mon, 25 Feb 2013 12:08:49 -0500
Message-ID: <512B9AA1.40109@interlog.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <1361261883-41467-3-git-send-email-hare@suse.de> <512B8454.4050806@linux.vnet.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50845 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3BYRIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2013 12:08:50 -0500
In-Reply-To: <512B8454.4050806@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On 13-02-25 10:33 AM, Steffen Maier wrote:
> Hi Hannes,
>
> I like the idea and most of the patch set, so I only have a few questions left and some review comments below.
>
> Just curious: Do you also plan to adapt systemd/udev, especially path_id for fc transport with its open coded copy of int_to_scsilun()?
>
> Since I don't see zfcp touched in this patch set, assuming this set will get merged, I plan to adapt a few spots in zfcp that might not work with 64 bit luns out of the box although most of it already works with 64 bit luns inside.
>
> Speaking of opaque handling of scsi luns: Lately I noticed that some sg3_utils tools decode the lun format and only report parts of the entire 64 bit fcp lun, e.g. sg_scan or "sg_luns -d". I don't have enough historical scsi experience to know why that is, maybe because of some SPI background. By itself this is not a problem, however, rescan-scsi-bus.sh makes use of those scsi lun parts and then fails when matching those with the full scsi lun exposed by the midlayer to user space. E.g. with flat space addresses of IBM DS8000 this does not seem to work:
>
> # sg_luns -v -s2 -d /dev/sg2 | head
>      report luns cdb: a0 00 02 00 00 00 00 00 20 00 00 00
>      report luns: requested 8192 bytes but got 4112 bytes
> Lun list length = 4104 which imples 513 lun entries
> Report luns [select_report=2]:
>      c101000000000000
>        REPORT LUNS well known logical unit
>      4020400000000000
>        Flat space addressing: lun=32
>      4020400100000000
>        Flat space addressing: lun=32
>      4020400200000000
>        Flat space addressing: lun=32
>                                   ^^<=== 0x20 of the lun's 1st short

According to sam5r13.pdf ** section 4.7.7.3 you owe me
a beer :-) "Flat space" addressing is only 16 bits long.
"Extended Flat space" and "Long Extended Flat space"
addressing would have the top bit set in byte 0 (and no
part of the actual lun is in byte 0).

# sg_luns --test=4020400200000000 -H
Decoded LUN:
   Flat space addressing: lun=0x0020

A vendor specific LUN or am I misreading SAM-5?

sg_luns --test=d220400200000000 -H
Decoded LUN:
   Extended flat space addressing: lun=0x204002

<snip>

> I guess we cannot adapt sg_ioctl SG_GET_SCSI_ID that easily without breaking the user space interface. But how does a user of this interface know that there are 64 bit luns in the kernel but the ioctl cannot handle the new kernel functionality (and may be affected by aliasing)?

I think that would involve adding a new ioctl (e.g. SG_GET_SCSI_ID64)
and last time I proposed that L. Torvalds said something like: over
his dead body.

Doug Gilbert

** now we have conglomerate LUNs!

