From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core cmd allocation 3/3
Date: Mon, 13 Jan 2003 12:12:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E22F369.5080209@splentec.com>
References: <3E1A2140.3000408@splentec.com> <20030111180355.B2225@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags);
> 
> 
> We only have two callers of this, one is scsi_getset_command and the other
> is used for allocating the freelist.  For the latter most of the code in
> this function is superflous, it just needs the kmem_cache_alloc.

It will stay this way.  This abstractizes the allocator; we were discussing
this some time ago, and another allocator could be put in, without disruption
to SCSI Core.

There may be more callers. SCSI Core just shows two callers, but other
subsystems/LLDD/ULDD may call it too. (There's a reason for this capability
which I cannot discuss right now -- queuing model will improve considerably, etc.)

> I'd suggest just using the kmem_cache_alloc directly for the freelist and
> merging it into your current scsi_getset_command.  While at it the name
> scsi_get_command should be transfered to it also :)

scsi_get_command() was provided in the case when we don't know the device.
scsi_getset_command() was provided in the case when we know the device,
which is most of the time, for this reason it's inlined.

They will stay like so.

> I don't like the scsi_core_data concept.  We don't need a struct for it as
> all variables not exported from scsi_mod.ko are the SCSI core data per
> defintion.  Adding a struct container is just obsfucation.

No, it is NOT an obfuscation.

It's what object oriented paradigm (OOP) is all about.

struct scsi_core_data represents the SCSI Core subsystem. (Thing about this sentence
for a few seconds.)  The structure was NOT set up in order to be ``exported''.
1) This is the wrong implication.  2) structs do not exist with the only purpose
to make visible their contents to the outside.

There's plenty of books on the object oriented paradigm.

It is my belief that such a struct will make things cleaner and clearer.

 >
 > Hmm, you seem to include some parts of the previous patch?
 >

Justin didn't care to fix his stuff, even though I asked him politely,
so at the last moment I had to change this too.

> Your code wants some updates to match Documentation/CodingStyle.

All my inlines follow this style.  Any other code of mine, in .c files
follows K&R style as it ever did, since my age of 14.

>>-EXPORT_SYMBOL(scsi_allocate_device);
>>+/* Obsolete! Use scsi_get_command() or scsi_getset_command(). */
>>+/* EXPORT_SYMBOL(scsi_allocate_device); */
> 
> 
> Just remove it.  We have that comment and the code history in SCCS
> once it's applied.

Will do.

-- 
Luben



