From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sun, 08 Feb 2009 18:58:22 -0500
Message-ID: <498F719E.6090709@redhat.com>
References: <20090123041558.GC24652@parisc-linux.org> <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org> <498DA052.6090605@redhat.com> <1234019372.4658.9.camel@localhost.localdomain> <20090207225025.GB31509@parisc-linux.org> <498F0C9D.3070601@redhat.com> <20090208205049.GG31509@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090208205049.GG31509@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Feb 08, 2009 at 11:47:25AM -0500, Ric Wheeler wrote:
>   
>> Matthew Wilcox wrote:
>>     
>>> I thought we had agreed on a plan which satisfied the SSD and insane
>>> array vendors.  That is that we would do no tracking of allocation units
>>> in the filesystem, but instead extend each trim out to cover the maximum
>>> possible size.  I've confirmed with Intel's SSD people that this would
>>> cause them no harm at all (trimming already trimmed sectors won't even
>>> cause a slowdown).  Whether the filesystem people have taken note of
>>> this, I have no idea.
>>>       
>> That should be helpful for the array people, but for some of them with 
>> really large delete chuck sizes, they will still miss a lot since their 
>> size is larger than the average file size :-)  I guess that we could do 
>> something to resync - Ted mentioned some ideas for ext4.
>>     
>
> I'm not sure I communicated the plan effectively.
>
> Let's consider deleting a 4k file.
>
> The DISCARD that the filesystem sends down does not just cover the 4k
> of data.  It covers all adjacent free space to that 4k of data, so it
> might end up sending a DISCARD of several megabytes or even gigabytes,
> assuming there's that much contiguous free space.
>
> Now, filesystems which fragment their free space will not do well on
> thin provisioned devices, but then they won't do well on any devices --
> keeping your free space compacted is an essential part of any filesystem's
> job, even on SSDs.
>
>   
Thanks - that does sound like it will in fact help clean up.  I suppose 
the worst case would be deleting lots of non-contiguous small files from 
a full file system (say every other 4KB or something obscure like that). 

I will see what the vendors I know have come up with, I think that this 
should give them something interesting to play with....

Ric


