From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Mon, 27 Sep 2010 13:20:01 -0400
Message-ID: <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
	<4CA0CC38.5010804@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:28636 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab0I0RVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 13:21:19 -0400
In-Reply-To: <4CA0CC38.5010804@fusionio.com> (Jens Axboe's message of "Tue, 28
	Sep 2010 01:54:16 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:

Jens> Fixing the overflow aside, I question the validity of setting the
Jens> physical block size to something larger than PAGE_SIZE as there's
Jens> no way that that could really work in the current kernel.

Jens> I would suggest doing something similar as we do with other
Jens> 'invalid' settings that we cannot honor, print a warning and drop
Jens> the queue limits to PAGE_SIZE.

Mike and I have been bouncing this back and forth on this the last
couple of days.

I totally agree with enforcing hard limits like the logical blocks size
inside the kernel. We have to. But the physical block size is just an
I/O hint. And consequently I prefer mkfs to do sanity checking in this
case and not the kernel. We report the topology truthfully and then
userland can treat the data as it sees fit.

-- 
Martin K. Petersen	Oracle Linux Engineering
