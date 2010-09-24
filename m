From: Jens Axboe <axboe@kernel.dk>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
  prevent?
Date: Fri, 24 Sep 2010 11:12:29 +0200
Message-ID: <4C9C6B7D.1060805@kernel.dk>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com> <4C9C129E.5050504@teksavvy.com> <4C9C2039.8050903@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C9C2039.8050903@teksavvy.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: dgilbert@interlog.com, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 2010-09-24 05:51, Mark Lord wrote:
> On 10-09-23 10:53 PM, Mark Lord wrote:
>> On 10-09-23 08:05 PM, Douglas Gilbert wrote:
>>> Mark,
>>> If you issued the SG_IO ioctl with a timeout of at
>>> least 66 minutes (expressed in milliseconds) then
>>> it looks like ata_scsi_queuecmd() has a problem.
>> ..
>>
>> Mmm.. more like blk_execute_rq() perhaps.
>> That's where the wait_for_completion(&wait) call is at.
>>
>> Perhaps I should change it to wait in smaller increments,
>> so that the lockup detection doesn't trigger on it..
> ..
> 
> This patch (below) seems to work.
> 
> Does this look kosher enough for me to roll it up
> as a proper patch submission?   Jens?  Joel?

Ideally it would be nice to just pass the info down that it should not
complain, since waiting > 120 seconds (or whatever the timeout is set
to) is expected by the caller in some cases.

But your patch is simple enough and it gets the job done. I will queue
it up for .37 if you send a properly formatted and signed-off-by
version.

-- 
Jens Axboe
