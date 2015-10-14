From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Wed, 14 Oct 2015 17:36:28 +0000
Message-ID: <20151014173628.10131770g6w1x0nw@imap.suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
 <1444833036.2220.38.camel@HansenPartnership.com>
 <1444833547.19542.21.camel@suse.de>
 <1444837556.2220.43.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444837556.2220.43.camel@HansenPartnership.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Zitat von James Bottomley <James.Bottomley@HansenPartnership.com>:

> On Wed, 2015-10-14 at 16:39 +0200, Johannes Thumshirn wrote:
>> On Wed, 2015-10-14 at 07:30 -0700, James Bottomley wrote:
>> > On Wed, 2015-10-14 at 15:50 +0200, Johannes Thumshirn wrote:
>> > > Removing a SCSI target via scsi_remove_target() suspected to be
>> > > racy. When a
>> > > sibling get's removed from the list it can occassionly happen that
>> > > one CPU is
>> > > stuck endlessly looping around this code block
>> > >
>> > > list_for_each_entry(starget, &shost->__targets, siblings) {
>> > >         if (starget->state == STARGET_DEL)
>> > >                 continue;
>> >
>> > How long is the __targets list?  It seems a bit unlikely that this is
>> > the exact cause, because for a short list all in STARGET_DEL that
>> > loop
>> > should exit very quickly.  Where in the code does scsi_remove_target
>> > +0x68/0x240 actually point to?
>> >
>> > Is it not a bit more likely that we're following a removed list
>> > element?
>> > Since that points back to itself, the list_for_each_entry() would
>> > then
>> > circulate forever.  If that's the case the simple fix would be to use
>> > the safe version of the list traversal macro.
>>
>> Yes it is traversing a removed element and yes the patches 2/3 and 3/3
>> are introducing the safe version of list_for_each_entry(), but they
>> also decouple the search for elements to be removed from the actual
>> removal. This is what my initial proposal did as well. Christoph wanted
>> me to decouple the whole process from the host_lock though and this is
>> what this patches do as well now.
>
> OK, so I really need you to separate the problems.  Fixing the bug
> you're reporting does not require a complete rework of the locking
> infrastructure; it just requires replacing the traversal macro with the
> safe version, can you verify that and it can go into fixes?
>

Yes. I can sent a patch for it tomorrow.



> Then we can discuss the merits of doing a locking rework in this area
> separately from the idea that it's some sort of bug fix.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
