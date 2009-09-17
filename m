From: Mark Lord <liml@rtr.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 09:35:19 -0400
Message-ID: <4AB23B17.2040204@rtr.ca>
References: <20090916222842.GB16053@arachsys.com> <4AB17905.90606@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AB17905.90606@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Chris Webb <chris@arachsys.com>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Chris Webb wrote:
>> Hi Tejun. Thanks for following up to this. We've done some more
>> experimentation over the last couple of days based on your
>> suggestions and thoughts.
>>
>> Tejun Heo <tj@kernel.org> writes:
>>> Seriously, it's most likely a hardware malfunction although I can't tell
>>> where the problem is with the given data.  Get the hardware fixed.
>> We know this isn't caused by a single faulty piece of hardware,
>> because we have a cluster of identical machines and all have shown
>> this behaviour. This doesn't mean that there isn't a hardware
>> problem, but if there is one, it's a design problem or firmware bug
>> affecting all of our hosts.
> 
> If it's multiple machines, it's much less likely to be faulty drives,
> but if the machines are configured mostly identically, hardware
> problems can't be ruled out either.
> 
>> There have also been a few reports of problems which look very
>> similar in this thread from people with somewhat different hardware
>> and drives to ours.
> 
> I wouldn't connect the reported cases too eagerly at this point.  Too
> many different causes end up showing similar symptoms especially with
> timeouts.
> 
>>> The aboves are IDENTIFY.  Who's issuing IDENTIFY regularly?  It isn't
>>> from the regular IO paths or md.  It's probably being issued via SG_IO
>>> from userland.  These failures don't affect normal operation.
>> [...]
>>> Oooh, another possibility is the above continuous IDENTIFY tries.
>>> Doing things like that generally isn't a good idea because vendors
>>> don't expect IDENTIFY to be mixed regularly with normal IOs and
>>> firmwares aren't tested against that.  Even smart commands sometimes
>>> cause problems.  So, finding out the thing which is obsessed with the
>>> identity of the drive and stopping it might help.
>> We tracked this down to some (excessively frequent!) monitoring we
>> were doing using smartctl. Things were improved considerably by
>> stopping smartd and disabling all callers of smartctl, although it
>> doesn't appear to have been a cure. The frequency of these timeouts
>> during resync seems to have gone from about once every two hours to
>> about once a day, which means we've been able to complete some
>> resyncs whereas we were unable to before.
> 
> That's interesting.  One important side effect of issuing IDENTIFY is
> that they will serialize command streams as they are not NCQ commands
> and thus could change command patterns significantly.
..

SMART is the opcode that is most frequently implicated here, not IDENTIFY.
Note that even a barrier FLUSH CACHE is non NCQ and will serialize the stream.

Cheers

