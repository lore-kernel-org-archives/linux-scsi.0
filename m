From: Mark Lord <liml@rtr.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 21 Sep 2009 15:47:51 -0400
Message-ID: <4AB7D867.4080508@rtr.ca>
References: <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca> <4AB25736.1060601@suse.de> <4AB260CA.8040308@rtr.ca> <4AB2610F.8010904@rtr.ca> <20090918170517.GI2141@arachsys.com> <20090921102654.GD8789@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090921102654.GD8789@arachsys.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Chris Webb wrote:
> Chris Webb <chris@arachsys.com> writes:
> 
>> Mark Lord <liml@rtr.ca> writes:
>>
>>> Speaking of which..
>>>
>>> Chris:  I wonder if the errors will also vanish in your situation
>>> by disabling the onboard write-caches in the drives ?
>>>
>>> Eg.  hdparm -W0 /dev/sd?
>> Hi Mark. I've got a test machine on its way at the moment, so I'll make sure
>> I check this one out on it too.
> 
> Our test machine is still being built, but we had an opportunity to try this on
> a couple of the live machines when their RAID arrays failed over the weekend.
> We still got timeouts, but (predictably!) they're not on flushes any more:
> 
>   ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
>   ata2.00: cmd 35/00:08:98:c6:00/00:00:4e:00:00/e0 tag 0 dm
...
> all the way through the night.
> 
> I also have these in the log, but they are immediately after turning off the
> write caching in all drives, so may be a red herring with data still being
> written out.
> 
>   ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
>   ata2.00: cmd c8/00:08:00:20:80/00:00:00:00:00/e0 tag 0 dm
...
> On another machine, I saw this with write caching turned off:
> 
>   ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> ata2.00: cmd 61/08:00:28:1f:80/00:00:00:00:00/40 tag 0 ncq 4096 out
...

0x35 is a 48-bit DMA WRITE, 0xc8 is a 28-bit DMA READ,
and 0x61 is an NCQ WRITE.

Looks like some kind of hardware trouble to me.
And as Tejun suggested, it's difficult to guess at
a cause other than the PSU.

Cheers, and good luck.
