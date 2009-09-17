From: Mark Lord <liml@rtr.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 09:29:44 -0400
Message-ID: <4AB239C8.2020203@rtr.ca>
References: <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756747AbZIQN3p@vger.kernel.org>
In-Reply-To: <20090916231921.GL1924@arachsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Chris Webb wrote:
> Mark Lord <liml@rtr.ca> writes:
> 
>> I suspect we're missing some info from this specific failure.
>> Looking back at Chris's earlier posting, the whole thing started
>> with a FLUSH_CACHE_EXT failure.  Once that happens, all bets are
>> off on anything that follows.
>>
>>> Everything will be running fine when suddenly:
>>>
>>>  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>>  ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>>>          res 40/00:00:80:17:91/00:00:37:00:00/40 Emask 0x4 (timeout)
>>>  ata1.00: status: { DRDY }
>>>  ata1: hard resetting link
>>>  ata1: softreset failed (device not ready)
>>>  ata1: hard resetting link
>>>  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>  ata1.00: configured for UDMA/133
>>>  ata1: EH complete
>>>  end_request: I/O error, dev sda, sector 1465147272
>>>  md: super_written gets error=-5, uptodate=0
>>>  raid10: Disk failure on sda3, disabling device.
>>>  raid10: Operation continuing on 5 devices.
> 
> Hi Mark. Yes, when the first timeout after a clean boot happens, it's with
> an 0xea flush command every time:
..

Yes.  Is this still happening from time to time now?
If so, disable the smartmontools daemon (smartd) and see if the problem goes away.
And especially disable hddtemp (which issues SMART commands) if that is also around.

It would be good to discover if those are the triggers for what's happening here.

Tejun.. do we do a FLUSH CACHE before issuing a non-NCQ command ?
If not, then I think we may need to add code to do it.


Cheers
