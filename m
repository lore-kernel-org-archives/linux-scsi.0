From: Douglas Gilbert <dougg@torque.net>
Subject: Re: zero block writes
Date: Wed, 15 Oct 2003 08:34:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F8C79F0.6070105@torque.net>
References: <1066160907.3501.9.camel@patehci2>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:58022 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261239AbTJNWfj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 18:35:39 -0400
In-Reply-To: <1066160907.3501.9.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> $
> $ sg_dd of=/dev/sg0 if=/dev/null bs=2k count=1
> 0+0 records in
> 0+0 records out
> $
> 
> cdb trace tells me this sg utils idiom assaults the device with a zero
> block write, specifically:
> 
> ...
> usb-storage: Command WRITE_10 (10 bytes)
> usb-storage:  2a 00 00 00 00 00 00 00 00 00
> usb-storage: Bulk command S 0x43425355 T 0x1e Trg 0 LUN 0 L 0 F 0 CL 10
> ...
> 
> I wonder if any of you find this sg utils factoid ineffably interesting,
> as I do?

Pat,
I find some bugs "interesting". BTW if "if=/dev/zero"
is used the result is more sane :-)

Also when I tested this on scsi_debug, it complained
about getting a NULL data buffer pointer.

> I know I have a personal history of pain with the scsi folk who dispute
> the t10 claim that the cdb x 0A 00:00:00 00 00 means write out x100
> blocks rather than zero and/or while yet that the cdb x 2A 00
> 00:00:00:00 00 00:00 00 does mean write out zero blocks.
> 
> I know I explicitly wrote code into a revision, at a time beyond the
> original release of pldd, to discard writes of zero bytes quietly,
> rather than passing them thru to the device.
> 
> I know such pass thru's trip over such unit attentions as x 6 29 reset.

A new beta (1.05) should be out tomorrow that fixes this
(I just put one up about 1 hour ago).

Doug Gilbert


