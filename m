From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: zero block writes
Date: 20 Oct 2003 16:46:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066690005.2814.14.camel@patehci2>
References: <1066160907.3501.9.camel@patehci2> <3F8C79F0.6070105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:27034 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262583AbTJTWqx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 18:46:53 -0400
In-Reply-To: <3F8C79F0.6070105@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > $ sg_dd of=/dev/sg0 if=/dev/null bs=2k count=1
> > 0+0 records in
> > 0+0 records out
> > $
> > 
> > cdb trace tells me this sg utils idiom assaults the device with a zero
> > block write, specifically:
> > ...
> > usb-storage: Command WRITE_10 (10 bytes)
> > usb-storage:  2a 00 00 00 00 00 00 00 00 00
> > ...
>
> A new beta (1.05) should be out tomorrow that fixes this
> (I just put one up about 1 hour ago).

Looks good, thank you.  Again I tried contrasting:

sg_dd of=/dev/sg0 if=/dev/zero bs=2k count=1
sg_dd of=/dev/sg0 if=/dev/null bs=2k count=1

I'm pleased to report the sg3_utils-1.05.tar.gz I fetched today passes
cdb's thru drivers/usb/storage/usb.usb_stor_show_command only from
/dev/zero, not from /dev/null.

Pat LaVarre


