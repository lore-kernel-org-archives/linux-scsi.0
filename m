From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] st.c for GET_IDLUN 2.6.6-rc2
Date: Wed, 28 Apr 2004 13:42:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408F2820.4030605@torque.net>
References: <408B798B.50005@torque.net> <Pine.LNX.4.58.0404251153530.17534@kai.makisara.local> <408C5C72.4020301@torque.net> <Pine.LNX.4.58.0404261858140.24847@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:3845 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264638AbUD1DmU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 23:42:20 -0400
In-Reply-To: <Pine.LNX.4.58.0404261858140.24847@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: osst@riede.org, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Mon, 26 Apr 2004, Douglas Gilbert wrote:
> 
> 
>>Kai Makisara wrote:
> 
> ....
> 
>>>2. Reversing the order of calls in st so that scsi_ioctl is called first 
>>>and if it returns -ENOTTY, then scsi_cmd_ioctl is called. This would 
>>>require changing scsi_ioctl to return -ENOTTY for commands not being 
>>>handled but would be othewise a logical solution: first try SCSI specific 
>>>implementation of the ioctl, if it does not exist, then try the block 
>>>layer version (Linux block layer, not Unix block layer ;-).
>>
>>This solution looks cleaner.
>>
> 
> I looked at the necessary changes a little more carefully and I think
> your solution is better from the practical point of view. The problem in  
> my solution is to make sure that scsi_ioctl() returns -ENOTTY in case it 
> does not implement the ioctl. This is easy except for the default case:
> 
>                 if (sdev->host->hostt->ioctl)
>                         return sdev->host->hostt->ioctl(sdev, cmd, arg);
> 
> where any kind of code can be found ;-) It is safer to leave this as the
> last resort.

Kai,
Here is another take on this matter. A summary of the ioctls
defined in block/scsi_ioctl.c follows with my comments:

ioctls defined in
block/scsi_ioctl.c          Comment
==================          =======
SCSI_IOCTL_SEND_COMMAND     redirects to scsi mid level
SCSI_IOCTL_GET_IDLUN        yields 0 (wrong, trips up cdrecord??)
SCSI_IOCTL_GET_BUS_NUMBER   yields 0 (wrong)
SG_EMULATED_HOST            irrelevant to st (obsolete in sg)
SG_GET_RESERVED_SIZE        irrelevant to st (to trick cdrecord)
SG_GET_TIMEOUT              irrelevant to st (to trick cdrecord)
SG_GET_VERSION_NUM          irrelevant to st (to trick cdrecord)
SG_IO                       <<< only ioctl useful to st (+ osst) >>
SG_SET_RESERVED_SIZE        irrelevant to st (to trick cdrecord)
SG_SET_TIMEOUT              irrelevant to st (to trick cdrecord)
CDROM_SEND_PACKET           irrelevant
CDROMCLOSETRAY              irrelevant
CDROMEJECT                  irrelevant

So if st just redirects only the SG_IO ioctl to scsi_cmd_ioctl()
and lets the rest go to the scsi mid level (from where they can
dribble down to the LLD) that solves the problem.

Doug Gilbert




