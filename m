From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: SG_GET_ACCESS_COUNT ioctl problem
Date: Tue, 10 Jan 2006 03:38:49 -0500
Message-ID: <43C37299.6050301@cfl.rr.com>
References: <43C119A0.8070304@cfl.rr.com> <43C36EFA.1040800@torque.net>
Reply-To: dmarkh@cfl.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-smtplb.tampabay.rr.com ([65.32.5.133]:24461 "EHLO
	ms-smtp-03.tampabay.rr.com") by vger.kernel.org with ESMTP
	id S932096AbWAJIiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 03:38:54 -0500
Received: from [10.10.10.100] (158.244.118.70.cfl.res.rr.com [70.118.244.158])
	by ms-smtp-03.tampabay.rr.com (8.12.10/8.12.7) with ESMTP id k0A8cnGK007383
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 03:38:49 -0500 (EST)
In-Reply-To: <43C36EFA.1040800@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Mark,
> I think you can consider that ioctl deprecated in the
> lk 2.6 series. The implementation of that ioctl in
> lk 2.6.15 is not very encouraging:
> 
>     case SG_GET_ACCESS_COUNT:
>         /* faked - we don't have a real access count anymore */
>         val = (sdp->device ? 1 : 0);
>         return put_user(val, ip);
> 
> which will yield 1 in almost all cases. In the lk 2.6 series
> sysfs ** is meant to take over those sort of functions from
> the sg driver. However struct scsi_device (one instance per
> scsi device (normally a logical unit)) no longer seems to
> maintain an access count.
> 
> 
> I have written about the SG_IO ioctl and its various
> implementations in the lk 2.6 series at:
> http://www.torque.net/sg/sg_io.html
> 
> However I haven't addressed the status of the lesser used
> sg ioctls (e.g. SG_GET_ACCESS_COUNT) in the lk 2.6 series.
> 
> 
> ** ..._GET_ACCESS_COUNT is more of a job for procfs than
>    sysfs.
> 

So how can one safely open an sg device that happens to be a disk? I can
find no combination of open flags that will cause an open to fail if the
disk happens to be mounted? You imply this ioctl is a "lesser used"
ioctl? What 'was' the prefered method of doing this? It's the only
method I found short of writing code to xlate the sg device into an sd
device and attempting an open of that first. That's not good???

Thanks
Mark

