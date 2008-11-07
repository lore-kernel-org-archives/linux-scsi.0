From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 15:26:58 -0500
Message-ID: <4914A492.4080009@redhat.com>
References: <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <20081107201913.GI29717@mit.edu> <20081107202149.GJ15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081107202149.GJ15439@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Nov 07, 2008 at 03:19:13PM -0500, Theodore Tso wrote:
>   
>> Let's be just a *little* bit fair here.  Suppose we wanted to
>> implement thin-provisioned disks using devicemapper and LVM; consider
>> that LVM uses a default PE size of 4M for some very good reasons.
>> Asking filesystems to be a little smarter about allocation policies so
>> that we allocate in existing 4M chunks before going onto the next, and
>> asking the block layer to pool trim requests to 4M chunks is not
>> totally unreasonable.
>>
>> Array vendors use chunk sizes > than typical filesystem chunk sizes
>> for the same reason that LVM does.  So to say that this is due to
>> purely a "broken firmware architecture" is a little unfair.
>>     
>
> I think we would have a full-throated discussion about whether the
> right thing to do was to put the tracking in the block layer or in LVM.
> Rather similar to what we're doing now, in fact.
>   
You definitely could imagine having a device mapper target that could 
track the discards commands and subsequent writes which would invalidate 
the previous discards.

Actually, it would be kind of nice to move all of this away from the 
file systems entirely.

Ric

