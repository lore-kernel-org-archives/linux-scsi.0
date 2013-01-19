From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Date: Sat, 19 Jan 2013 14:24:56 +0800
Message-ID: <50FA3C38.5030308@intel.com>
References: <Pine.LNX.4.44L0.1301181024340.1988-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1301181024340.1988-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On 01/18/2013 11:26 PM, Alan Stern wrote:
> On Fri, 18 Jan 2013, Aaron Lu wrote:
>
>>> Either you have to make sure the q->nr_pending is always correct, even
>>> when runtime PM isn't being used, or else the caller has to make sure
>>> that no I/O takes place before blk_pm_runtime_init is called.
>>
>> I think we can say:
>> blk_pm_runtime_init can't be called after any requests have been
>> submitted but not finished.
>> Sounds more accurate?
>
> Okay.  I think you can add (in parentheses) that in most cases drivers
> should call the routine before any I/O has taken place.

The reason I put it that way is, in patch 4, the blk_pm_runtime_init is
called after a request is executed(scsi_probe_lun). I do not want people
get confused by the comments for blk_pm_runtime_init and the example
code in patch 4 where we didn't follow it :-)

Considering ODD's use case, I was thinking of moving the
blk_pm_runtime_init call to sd.c, as sr will not use request based auto
suspend. Probably right before we decrease usage count for the device in
sd_probe_async. What do you think?

Thanks,
Aaron
