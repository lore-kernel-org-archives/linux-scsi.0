From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] mode sense blacklist how
Date: Thu, 20 Nov 2003 09:34:19 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FBBFDFB.9010406@torque.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>	 <1068767049.2851.166.camel@patrh9>	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>	 <1068775834.2851.321.camel@patrh9>	 <20031113181945.I30194@one-eyed-alien.net>	 <1068777510.2851.359.camel@patrh9>	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>	 <1068838908.2852.34.camel@patrh9>	 <1069246502.3fbb6826955dd@webmail.netregistry.net> <1069261377.2867.37.camel@patrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:3590 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264198AbTKSXeq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 18:34:46 -0500
In-Reply-To: <1069261377.2867.37.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Apologies in advance for each reboot these experiments force on you.
> 
> 
>> MODE SENSE (10): plscsi hangs and sits there in 
>> usb_stor_bulk_transfer_buf until the device is 
>> physically unplugged. kill -9 has no effect.
> 
> 
> Yes why `kill -9` has no effect on SG_IO in progress remains an open
> question here at linux-scsi.

The SG_IO ioctl is implemented in 2 places (in lk 2.6):
    a) block/scsi_ioctl.c [for block devices]
    b) sg.c [for sg devices]

In case b) the SG_IO ioctl is interruptible between the point
of command submission and the response arriving. [When testing
with lk 2.4 I found there were out-of-resource situations which
would block interminably prior to command submission, but I
doubt this is what you are seeing.] It is worth noting that
coping with orphaned SCSI responses from user killed processes
requires a lot of logic in the sg driver.

I suspect in case a) the user cannot interrupt the sg_io()'s
invocation of blk_do_rq(). Perhaps someone could enlighten me
(and I could document it).

Further it looks like the SCSI_IOCTL_SEND_COMMAND is not
interruptible either. See scsi_wait_req() in scsi_lib.c .

Doug Gilbert

