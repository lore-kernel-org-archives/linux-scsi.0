From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 07:21:51 +0900
Message-ID: <4CA118FF.1080100@fusionio.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>	<4CA0CC38.5010804@fusionio.com> <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:35862 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab0I0WVz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 18:21:55 -0400
In-Reply-To: <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-28 02:20, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> 
> Jens> Fixing the overflow aside, I question the validity of setting the
> Jens> physical block size to something larger than PAGE_SIZE as there's
> Jens> no way that that could really work in the current kernel.
> 
> Jens> I would suggest doing something similar as we do with other
> Jens> 'invalid' settings that we cannot honor, print a warning and drop
> Jens> the queue limits to PAGE_SIZE.
> 
> Mike and I have been bouncing this back and forth on this the last
> couple of days.
> 
> I totally agree with enforcing hard limits like the logical blocks size
> inside the kernel. We have to. But the physical block size is just an
> I/O hint. And consequently I prefer mkfs to do sanity checking in this
> case and not the kernel. We report the topology truthfully and then
> userland can treat the data as it sees fit.

So it's just the hint, not the actual hardware sector size. The naming
is pretty bad on that, physical and logic... So that does look better,
but in that case I don't think that sd should dump a warning.

Does mkfs do the right thing?

-- 
Jens Axboe

