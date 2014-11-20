From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 88591] New: SCSI_IOCTL_GET_IDLUN only returns 8 bits for
 the SCSI Target value
Date: Thu, 20 Nov 2014 16:01:15 -0500
Message-ID: <546E569B.60906@interlog.com>
References: <bug-88591-11613@https.bugzilla.kernel.org/>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51968 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbaKTVBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2014 16:01:31 -0500
In-Reply-To: <bug-88591-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 14-11-20 12:55 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=88591
>
>              Bug ID: 88591
>             Summary: SCSI_IOCTL_GET_IDLUN only returns 8 bits for the SCSI
>                      Target value
>             Product: SCSI Drivers
>             Version: 2.5
>      Kernel Version: 3.14.22
>            Hardware: All
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: Other
>            Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>            Reporter: kg6esx@gmail.com
>          Regression: No
>

If that ioctl has not been deprecated, it should be. Fixing
it would likely break existing apps so I doubt that will
happen. Introducing new ioctls is discouraged.

Also the 8 bit LUN "feature" with this ioctl was documented
over 10 years ago, about the time that a new ioctl was proposed
to address this issue.


The answer is to use sysfs. Now you would think sysfs would
have a pseudo file called "lun" in some obvious place that
would contain the 64 bit LUN value in binary, hex or decimal.
Even better would be a string of eight bytes to match T10's
LUN representation.
No, that would be too simple.

One way to find a file descriptor's LUN is to use stat() to
get its major and minor device numbers. For example if you had
opened /dev/sde that would usually be 8,64 . Then go searching in
sysfs for a "dev" file that contains "8,64" ***, then look at
the real path of the match (i.e. without any symlinks).
That real path might be:
   /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:4/block/sde/dev

Back up that real path until you find /<h>:<c>:<t>:<l>/ and
there is your LUN: <l>
That would be "4" for the path show above.


As you may have noticed sysfs is a pretty bad mechanism
for answering this type of question, compared to an ioctl.

Doug Gilbert


*** the details of the search differ depending on whether the
     driver is bsg, sg, sd, st, ses ....

BTW Thanks to udev, just because a disk is known as /dev/sde
     in the user space, doesn't mean that the kernel (and
     sysfs) will know it as "sde", it could be "sdg". That is
     the reason for searching with major,minor numbers rather
     than its name.
