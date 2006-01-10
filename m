From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_GET_ACCESS_COUNT ioctl problem
Date: Tue, 10 Jan 2006 18:23:22 +1000
Message-ID: <43C36EFA.1040800@torque.net>
References: <43C119A0.8070304@cfl.rr.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:59523 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932090AbWAJIXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 03:23:01 -0500
In-Reply-To: <43C119A0.8070304@cfl.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dmarkh@cfl.rr.com
Cc: linux-scsi@vger.kernel.org

Mark Hounschell wrote:
> In the 2.4 kernel (not using devfs) the SG_GET_ACCESS_COUNT ioctl to an
> sg device would report the correct/expected usage count when issued to a
> sd disc that was mounted, accounting for the mount by the system. The
> 2.6 kernel does not. Is this now the expected behavior or is this a bug?

Mark,
I think you can consider that ioctl deprecated in the
lk 2.6 series. The implementation of that ioctl in
lk 2.6.15 is not very encouraging:

    case SG_GET_ACCESS_COUNT:
        /* faked - we don't have a real access count anymore */
        val = (sdp->device ? 1 : 0);
        return put_user(val, ip);

which will yield 1 in almost all cases. In the lk 2.6 series
sysfs ** is meant to take over those sort of functions from
the sg driver. However struct scsi_device (one instance per
scsi device (normally a logical unit)) no longer seems to
maintain an access count.


I have written about the SG_IO ioctl and its various
implementations in the lk 2.6 series at:
http://www.torque.net/sg/sg_io.html

However I haven't addressed the status of the lesser used
sg ioctls (e.g. SG_GET_ACCESS_COUNT) in the lk 2.6 series.


** ..._GET_ACCESS_COUNT is more of a job for procfs than
   sysfs.

Doug Gilbert


