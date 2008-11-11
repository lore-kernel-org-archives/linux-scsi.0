From: "Kit Gerrits" <kitgerrits@gmail.com>
Subject: RE: Question about spun-down USB disk
Date: Tue, 11 Nov 2008 20:07:01 +0100
Message-ID: <4919d7d8.188d420a.4772.10b1@mx.google.com>
References: <4919CE9F.80304@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:63555 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYKKTHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 14:07:08 -0500
Received: by ug-out-1314.google.com with SMTP id 39so826687ugf.37
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2008 11:07:05 -0800 (PST)
In-Reply-To: <4919CE9F.80304@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Richter' <stefanr@s5r6.in-berlin.de>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org


OK, that is odd.
The timer on all my disks report 60 (I assume those are seconds).

I'll keep an eye out for that error and see if I can find out where it came
from.
If it is not the spin-up time, I must have accidentally pulled a (USB)
cable. 
(From what I can see in the logs, I just plugged in a different drive before
the drive failed)


I thank you very much for the hint, it was exactly what I was looking for,
  and I apologoze for my <rant> from earlier on.
  (I assumed it was set to 1 or 5 seconds).


Regards,

Kit Gerrits

-----Original Message-----
From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de] 
Sent: dinsdag 11 november 2008 19:28
To: Kit Gerrits
Cc: dgilbert@interlog.com; linux-scsi@vger.kernel.org
Subject: Re: Question about spun-down USB disk

Kit Gerrits wrote:
...
> If, for some reason, a program wants to write to a file on there 
> without spinning the drive up in advance, the error pops up.
> Mind you, I haven't had the error in days now.
> 
> All I'm looking for is a way to increase the time the O/S waits for 
> the disk to spin up.

Try the /sys/bus/scsi/devices/*:*:*:*/timeout attribute.

Of course increasing the timeout isn't a particularly sophisticated method
to solve the issue, but simple enough to try.  The default timeout is 30
seconds: linux/drivers/scsi/sd.h::SD_TIMEOUT.  Can an HDD really take longer
than that to receive a request when spun down, spin up, execute the request,
and return status?
--
Stefan Richter
-=====-==--- =-== -=-==
http://arcgraph.de/sr/

