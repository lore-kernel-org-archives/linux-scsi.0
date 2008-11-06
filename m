From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 10:42:52 -0500
Message-ID: <4913107C.3040607@redhat.com>
References: <4913028B.6010405@redhat.com> <yq1d4h8nao5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq1d4h8nao5.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:
>>>>>>             
>
> Ric> After talking to some vendors, one issue that came up is that the
> Ric> arrays all have a different size that is used internally to track
> Ric> the SCSI equivalent of TRIM commands (POKE/unmap).
>
> I haven't had time to completely digest the latest (Nov. 4th) UNMAP
> proposal yet.  However, I don't recall seeing any notion of blocks
> bigger than the logical block length.  And the command clearly takes
> (a list of) <start LBA, number of blocks>.
>   

There is a proposal to expose this internal device size in a standard 
way, but it has not been finalized.

>
> Ric> What they would like is for us to coalesce these commands into
> Ric> aligned multiples of these chunks. 
>
> Ric> If not, the target device will most likely ignore the bits at the
> Ric> beginning and end (and all small requests).
>
> That really just sounds like a broken firmware implementation on their
> end.  If they can not UNMAP a single logical block then they are
> clearly not within the spirit of the proposed standard.  Their thin
> provisioning is going to suck and customers will hopefully
> complain/buy a competing product.
>
>   

I tend to agree with this point of view, but unfortunately, I think that 
all of the major arrays have this kind of limitation to one degree or 
another. I suspect that this will be a big deal with high end customers.

Just not sure that we have any way to handle this better than what is in 
already (best effort, maybe a post/defrag like user util that can be run 
offline to clean up?)

ric




