From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Sat, 17 Jan 2004 10:16:48 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <400951E0.9030509@tmr.com>
References: <20040112194829.A7078@infradead.org>	 <1073937102.3114.300.camel@compaq.xsintricity.com>	 <4006CB42.3040005@tmr.com> <1074345146.13198.29.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1074345146.13198.29.camel@compaq.xsintricity.com>
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan Van de Ven <arjanv@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Jens Axboe <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>, ihno@suse.de
List-Id: linux-scsi@vger.kernel.org

Doug Ledford wrote:
> On Thu, 2004-01-15 at 12:17, Bill Davidsen wrote:
> 
>>Doug Ledford wrote:
>>
>>
>>>More or less.  But part of it also is that a lot of the patches I've
>>>written are on top of other patches that people don't want (aka, the
>>>iorl patch).  I've got a mlqueue patch that actually *really* should go
>>>into mainline because it solves a slew of various problems in one go,
>>>but the current version of the patch depends on some semantic changes
>>>made by the iorl patch.  So, sorting things out can sometimes be
>>>difficult.  But, I've been told to go ahead and do what I can as far as
>>>getting the stuff out, so I'm taking some time to try and get a bk tree
>>>out there so people can see what I'm talking about.  Once I've got the
>>>full tree out there, then it might be possible to start picking and
>>>choosing which things to port against mainline so that they don't depend
>>>on patches like the iorl patch.
>>
>>If it leads to a more stable kernel, I don't see why iorl can't go in 
>>(user perspective) because RH is going to maintain it instead of trying 
>>to find a developer who is competent and willing to do the boring task 
>>of backfitting bugfixes to sub-optimal code.
> 
> 
> We actually intended to leave it out of RHEL3.  But, once we started
> doing performance testing of RHEL3 vs. AS2.1, it was obvious that if we
> didn't put the patch back in we could kiss all of our benchmark results
> goodbye.  Seriously, it makes that much difference on server systems.

I'm running 30+ usenet servers, currently on older RH versions. Better 
performance would certainly be a plus, although stability WRT lockups 
has been an issue, as has operation when the number of threads gets very 
high. First tests of RHEL looked very promising for stability, I'm 
hoping to get the okay to do serious production testing next week.

>>The only problem I see would be getting testing before calling it 
>>stable. Putting out a "giant SCSI patch" for test, then into a -test 
>>kernel should solve that. The fact that RH is stuck supporting this for 
>>at least five years is certainly both motivation and field test for any 
>>changes ;-)
> 
> 
> See me last email on the testing issue.
> 
> 
>>Clearly Marcello has the decision, but it looks from here as if 
>>stability would be improved by something like this. Assuming that no 
>>other vendor objects, of course.
> 
> 
> Stability, maybe.  Ease of writing drivers that work in both 2.4 and 2.6
> using the same locking logic, absolutely.
> 


-- 
bill davidsen <davidsen@tmr.com>
   CTO TMR Associates, Inc
   Doing interesting things with small computers since 1979
