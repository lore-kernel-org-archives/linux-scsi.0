From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Thu, 6 Nov 2014 13:14:18 -0600
Message-ID: <545BC88A.7060706@windriver.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com> <yq1fvdwb3lq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1fvdwb3lq.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/06/2014 12:12 PM, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com>
>>>>>> writes:
>
> Chris> That'd work, but is it the best way to go?  I mean, I found
> one Chris> report of a similar problem on an SSD (model number
> unknown).  In Chris> that case it was a near-UINT_MAX value as well.
>
> My concern is still the same. Namely that this particular drive
> happens to be returning UINT_MAX but it might as well be a value
> that's entirely random. Or even a value that is small and innocuous
> looking but completely wrong.
>
> Chris> The problem with the blacklist is that until someone patches
> it, Chris> the drive is broken.  And then it stays blacklisted even
> if the Chris> firmware gets fixed.
>
> Well, you can manually blacklist in /proc/scsi/device_info.
>
> Chris> I'm wondering if it might not be better to just ignore all
> values Chris> larger than X (where X is whatever we think is the
> largest Chris> conceivable reasonable value).
>
> The problem is that finding that is not easy and it too will be a
> moving target.


Do we need to be perfect, or just "good enough"?

For a RAID card I expect it would be related to chunk size or stripe
width or something...but even then I would expect to be able to cap it
at 100MB or so.  Or are there storage systems on really fast interfaces
that could legitimately want a hundred meg of data at a time?

On 11/06/2014 12:15 PM, Jens Axboe wrote:
> Didn't check, but assuming the value is the upper 24 bits of 32. If
> so, might not hurt to check for as 0xfffffe00 as an invalid value.

Yep, in all three wonky cases so far "optimal_io_size" ended up as 
4294966784, which is 0xfffffe00.  Does something mask out the lower bits?

Chris
