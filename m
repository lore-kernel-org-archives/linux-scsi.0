From: Jeff Garzik <jgarzik@pobox.com>
Subject: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 02:30:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFE8784.4000101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48773 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265585AbTF2GQc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 02:16:32 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19WVi5-0005IN-UT
	for linux-scsi@vger.kernel.org; Sun, 29 Jun 2003 07:30:50 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was reading the specs just now, and I see that the inquiry page 
defines how ATAPI and USB devices indicate they are compliant with MMC-4.

And, MMC-4 does not define read/write/modesen/modesel 6-byte commands at 
all.

My conclusion is that we should notice up front when MMC-4 is supported, 
and simply adhere to the spec by always sending 10-byte commands for 
that device.  I do not think that translation of 6-to-10 byte commands 
is answer, which is what happens now.  Our SCSI layer (sr.c, etc.) 
should, IMO, be compliant with MMC-4 and simply send the right commands.

This also implies that use_10_for_ms simply need not exist -- "first try 
10 byte commands for this device" is false...  for some devices we 
should be unconditionally sending 10 byte commands, no ifs, ands, or buts :)

I'll see if I can work up a patch, if noone objects...

	Jeff, debugging atapi support in his ata-scsi driver



