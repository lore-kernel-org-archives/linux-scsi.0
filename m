From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata error handling fixes (ATAPI)
Date: Wed, 16 Nov 2005 08:23:49 -0500
Message-ID: <437B32E5.5030707@pobox.com>
References: <20051114195717.GA24373@havoc.gtf.org> <20051115074148.GA17459@htj.dyndns.org> <4379AA5B.1060900@pobox.com> <4379B28E.9070708@gmail.com> <4379C062.3010302@pobox.com> <20051115120016.GD7787@suse.de> <437A2814.1060308@cs.wisc.edu> <20051115184131.GJ7787@suse.de> <20051116124035.GX7787@suse.de> <437B2C61.7080605@pobox.com> <20051116131333.GA7787@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051116131333.GA7787@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Nov 16 2005, Jeff Garzik wrote:
> 
>>Jens Axboe wrote:
>>
>>>I updated that patch, and converted IDE and SCSI to use it. See the
>>>results here:
>>>
>>>http://brick.kernel.dk/git/?p=linux-2.6-block.git;a=shortlog;h=blk-softirq
>>>
>>>The main change from the version posted last october is killing the
>>>'slightly' overdesigned completion queue hashing.
>>
>>Nifty, I like.  Comments:
>>
>>* use of spin_lock_irq() in all completion paths now makes me nervous.
> 
> 
> Should be fine from the paths originating from blk_done_softirq(), as we
> know interrupts are enabled in the first place. But generally I agree,
> whenever in doubt always always use the irq saving variants.
> 
> 
>>* certainly it's what SCSI does now, but is a softirq really necessary? 
>> Using a tasklet would kill all that per-cpu code, and notifier.
> 
> 
> It would work fine with a tasklet of course, but it's going to generate
> a _lot_ of traffic on io busy systems so I felt a dedicated softirq was
> the way to go.

fair enough.  ACK.

	Jeff



