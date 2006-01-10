From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_GET_ACCESS_COUNT ioctl problem
Date: Tue, 10 Jan 2006 19:06:58 +1000
Message-ID: <43C37932.90006@torque.net>
References: <43C119A0.8070304@cfl.rr.com> <43C36EFA.1040800@torque.net> <43C37299.6050301@cfl.rr.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:24200 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751021AbWAJJGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 04:06:24 -0500
In-Reply-To: <43C37299.6050301@cfl.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dmarkh@cfl.rr.com
Cc: linux-scsi@vger.kernel.org

Mark Hounschell wrote:
>>Mark,
>>I think you can consider that ioctl deprecated in the
>>lk 2.6 series. The implementation of that ioctl in
>>lk 2.6.15 is not very encouraging:
>>
>>    case SG_GET_ACCESS_COUNT:
>>        /* faked - we don't have a real access count anymore */
>>        val = (sdp->device ? 1 : 0);
>>        return put_user(val, ip);
>>
>>which will yield 1 in almost all cases. In the lk 2.6 series
>>sysfs ** is meant to take over those sort of functions from
>>the sg driver. However struct scsi_device (one instance per
>>scsi device (normally a logical unit)) no longer seems to
>>maintain an access count.
>>
>>
>>I have written about the SG_IO ioctl and its various
>>implementations in the lk 2.6 series at:
>>http://www.torque.net/sg/sg_io.html
>>
>>However I haven't addressed the status of the lesser used
>>sg ioctls (e.g. SG_GET_ACCESS_COUNT) in the lk 2.6 series.
>>
>>
>>** ..._GET_ACCESS_COUNT is more of a job for procfs than
>>   sysfs.
>>
> 
> 
> So how can one safely open an sg device that happens to be a disk? I can
> find no combination of open flags that will cause an open to fail if the
> disk happens to be mounted? You imply this ioctl is a "lesser used"
> ioctl? What 'was' the prefered method of doing this? It's the only
> method I found short of writing code to xlate the sg device into an sd
> device and attempting an open of that first. That's not good???

Mark,
In the lk 2.6 series you can open a disk directly
(e.g. /dev/sda) and send it SCSI commands using the
SG_IO ioctl. The situation is the same if you open
the corresponding sg device and send SCSI commands.

What is important is which SCSI commands are sent. There
is some crude filtering based on file permissions and
the SCSI command opcode. Other than that, the onus is
on the person sending the SCSI commands. Mounted file
systems can be seen in /proc/mounts ** .

The sg driver is a pass through. The SG_GET_ACCESS_COUNT
ioctl was a window to a variable which someone else removed
around 18 months ago. There is little I can do other
than try to explain ...


** the root file system device appears as "/dev/root"
   in my /proc/mounts . "/dev/root" is a symlink to
   the real thing.

Doug Gilbert
