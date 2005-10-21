From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 13:25:46 +1000
Message-ID: <43585FBA.20506@torque.net>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <4358497E.6070107@torque.net> <43584F8F.4070403@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:16016 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S964853AbVJUDYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 23:24:45 -0400
In-Reply-To: <43584F8F.4070403@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> Just a suggestion if you want to bring /dev/sg into
>> the picture for a SMP (and even a STP) passthrough.
> 
> 
> Yep.  That's another possibility, that falls into the 'block driver'
> category [see list of categories in my 'ioctl' email], since it is
> translated into a 'special' block request, and then sent to a normal
> request_queue.
> 
> Jens Axboe's bsg[1] has also been mentioned in the context of SMP.

Jeff,
Yes, I like the bsg model: one well known device (/dev/bsg),
get a file descriptor and then bind to a "target". It
reminded me of a network interface.

As presented, it only bound to a block (or char?) device
node (e.g. /dev/sda). I asked some questions about widening
the variety of things it could bind to but Peter Jones
suggested that binding was a necessary evil that should
not be encouraged.

So perhaps we could bind to a SAS host ... (and a SCSI device
for those pesky things like safte, ses and wluns).

Doug Gilbert
