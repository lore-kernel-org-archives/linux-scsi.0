From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] st.c for GET_IDLUN 2.6.6-rc2
Date: Mon, 26 Apr 2004 10:48:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408C5C72.4020301@torque.net>
References: <408B798B.50005@torque.net> <Pine.LNX.4.58.0404251153530.17534@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:39688 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261987AbUDZAss
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 20:48:48 -0400
In-Reply-To: <Pine.LNX.4.58.0404251153530.17534@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: osst@riede.org, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Sun, 25 Apr 2004, Douglas Gilbert wrote:
> 
> 
>>Kai,
>>A little more testing of st's SG_IO ioctl turned up a
>>small problem.
>>
>>This is the corresponding patch that was applied to the
>>sd driver when it received the block layer SG_IO ioctl.
>>
>>For least surprise of lk 2.4 utilities that use the
>>SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER
>>ioctls (e.g. sg_map) it is better to return the correct
>>values rather than 0.
>>
> 
> I definitely agree that those ioctl should not return 0 for SCSI devices. 
> However, I think this is a bug in drivers/block/scsi_ioctl.c. Making the 
> high-level SCSI drivers parse the ioctl covers up the bug but, IMHO, it is 
> not a clean solution. The following two solutions come into my mind:
> 
> 1. Fixing drivers/block/scsi_ioctl.c. The simple solution would be to 
> return -ENOTTY and then the call would be redirected to the SCSI ioctl 
> that does the proper thing. There probably is some reason why this has not 
> been done. Other fixes would require knowing if the transport type 
> implements the ioctl and this complicates things.

One (!@#$%) reason for putting SG_IO ioctl and friends in the
block layer was to trick cdrecord that it was talking to the
sg device :-) Older versions of cdrecord won't take kindly to
receiving -ENOTTY from the SCSI_IOCTL_GET_IDLUN ioctl.
However always returning 0 may trick cdrecord if there are
2 or more cd/dvd writers (hence my question at the end of my
last post on this thread).

> 2. Reversing the order of calls in st so that scsi_ioctl is called first 
> and if it returns -ENOTTY, then scsi_cmd_ioctl is called. This would 
> require changing scsi_ioctl to return -ENOTTY for commands not being 
> handled but would be othewise a logical solution: first try SCSI specific 
> implementation of the ioctl, if it does not exist, then try the block 
> layer version (Linux block layer, not Unix block layer ;-).

This solution looks cleaner.

Doug Gilbert


