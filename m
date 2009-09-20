From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: MD/RAID time out writing superblock
Date: Sun, 20 Sep 2009 12:36:39 -0600
Message-ID: <4AB67637.9060906@gmail.com>
References: <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca> <4AB25736.1060601@suse.de> <4AB260CA.8040308@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755497AbZITSgm@vger.kernel.org>
In-Reply-To: <4AB260CA.8040308@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <teheo@suse.de>, Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On 09/17/2009 10:16 AM, Mark Lord wrote:
> Tejun Heo wrote:
>> Hello,
>>
>> Mark Lord wrote:
>>> Tejun.. do we do a FLUSH CACHE before issuing a non-NCQ command ?
>>
>> Nope.
>>
>>> If not, then I think we may need to add code to do it.
>>
>> Hmm... can you explain a bit more? That seems rather extreme to me.
> ..
>
> You may recall that I first raised this issue about a year ago,
> when my own RAID0 array (MythTV box) started showing errors very
> similar to what Chris is reporting.
>
> These were easily triggered by running hddtemp once every few seconds
> to log drive temperatures during Myth recording sessions.
>
> hddtemp uses SMART commands.
>
> The actual errors in the logs were command timeouts,
> but at this point I no longer remember which opcode was
> actually timing out. Disabling the onboard write cache
> immediately "cured" the problem, at the expense of MUCH
> slower I/O times.
>
> My theory at the time, was that some non-NCQ commands might be triggering
> an internal FLUSH CACHE within the (Hitachi) drive firmware, which then
> caused the original command to timeout in libata (due to the large amounts
> of data present in the onboard write-caches).
>
> Now that more people are playing the game, we're seeing more and more
> reports of strange interactions with smartd running in the background.

Well, unless the SMART commands are using a non-standard timeout, it'll 
be the same as the timeout for the flush cache, so the flush cache would 
have timed out too..

>
> I suspect more and more now that this is an (avoidable) interaction
> between the write-cache and the SMART opcode, and it could perhaps be
> avoided by doing a FLUSH CACHE before any SMART (or non-data command)
> opcode.
>
> Cheers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
