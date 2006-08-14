From: "Robert Mueller" <robm@fastmail.fm>
Subject: mpt fusion retry status...
Date: Mon, 14 Aug 2006 11:55:56 +1000
Message-ID: <078801c6bf44$ccd39ee0$0e00cb0a@robm>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:21635 "EHLO
	out1.smtp.messagingengine.com") by vger.kernel.org with ESMTP
	id S1751796AbWHNBz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 21:55:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hubert Tonneau <hubert.tonneau@fullpliant.org>, "\"Eric Moore\"" <Eric.Moore@lsil.com>, Bron Gondwana <brong@fastmail.fm>

I'm just trying to find out what the current status of the mpt fusion driver 
in linux 2.6 is with regard to error conditions. We recently came across 
some errors in our logs that we think are responsible for corruption on one 
of our SCSI connected volumes (kernel 2.6.16.19)

Jul 30 19:25:25 lb1 kernel: mptscsih: ioc1: attempting task abort! 
(sc=c4f3c500)
Jul 30 19:25:25 lb1 kernel: sd 1:0:5:0:
Jul 30 19:25:25 lb1 kernel: mptscsih: ioc1: task abort: SUCCESS 
(sc=c4f3c500)
Jul 30 19:25:25 lb1 kernel: mptscsih: ioc1: attempting task abort! 
(sc=d125e980)
Jul 30 19:25:25 lb1 kernel: sd 1:0:5:0:
Jul 30 19:25:26 lb1 kernel: mptscsih: ioc1: task abort: SUCCESS 
(sc=d125e980)
Jul 30 19:25:26 lb1 kernel: mptscsih: ioc1: attempting task abort! 
(sc=c21b4380)
Jul 30 19:25:26 lb1 kernel: sd 1:0:5:1:
Jul 30 19:25:26 lb1 kernel: mptscsih: ioc1: task abort: SUCCESS 
(sc=c21b4380)
Jul 30 19:25:26 lb1 kernel: mptscsih: ioc1: attempting task abort! 
(sc=c7581380)
Jul 30 19:25:26 lb1 kernel: sd 1:0:5:0:
Jul 30 19:25:26 lb1 kernel: mptscsih: ioc1: task abort: SUCCESS 
(sc=c7581380)

Searching around, I found this post:

http://www.ussg.iu.edu/hypermail/linux/kernel/0510.1/0705.html

Well it seems that things didn't go into a loop, or cause the device to go 
offline, but sometime after the above event we found that doing a check on 
the filesystem found some corruption. I can't exactly pinpoint the problem 
to the above event, but it seems the most likely event in the logs to be 
related to this.

Searching around some more, other people reported the problem:

http://blog.linuri.de/?p=86

So I guess what I'm wondering is what state is the driver with regard to 
errors and retrying? With the events in the log above, could that have been 
what caused corruption on the filesystem somehow?

Rob

