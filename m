From: Douglas Gilbert <dougg@torque.net>
Subject: Re: A question on Linux SCSI low-level driver
Date: Wed, 19 May 2004 13:52:15 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40AAD9EF.4000903@torque.net>
References: <519672568F040C41B6FAC21ADF51B18FEFF8@mailnode1.commstor.crossroads.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:16141 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263646AbUESLE5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 07:04:57 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFF8@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

Lee Xing wrote:
> Thanks for the information.  scsi_debug is very helpful for me.
> 
> Two questions on scsi_debug/low-level driver:
> 
> - Has anyone ever created a patch for scsi_debug to support ioctl calls in lk 2.4?  

Yes, me and it is in the last 8 (at least) versions of the
lk 2.4 series. See scsi_debug_ioctl().

It doesn't do anything other than report it has been called
but a "template" it is.

The ioctl model is "trickle down". So if the block layer
(in the case of sd), the sd driver (or sg driver) and the
SCSI mid level do _not_ recognize the ioctl() 'request' [an
integer and the second argument given to the ioctl invocation
in the user space] _then_ the ioctl "tickles down" to the
corresponding LLD ioctl routine (if there is one).

If not, is it possible for some one to kindly create it or a 
template/part of it?
> 
> - Do SCSI passthrough ioctl calls sent to both sd and sg devices share/use the same ioctl routine defined in scsi_debug/low-level driver?  In other words, ioctl routine defined in scsi_debug/low-level drivers can not tell and do not care from which type of device (sd or sg) the SCSI passthrough call comes in, correct?

The SCSI subsystem does not convey SCSI commands between the
mid level and LLDs via ioctl calls. ioctl()s defined in LLDs
are for very special, typically hardware specific, reasons.
For example the LLD of a RAID controller might use ioctls
to do RAID specific management functions.

Doug Gilbert


