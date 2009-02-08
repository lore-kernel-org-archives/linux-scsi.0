From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sun, 08 Feb 2009 11:47:25 -0500
Message-ID: <498F0C9D.3070601@redhat.com>
References: <20090123041558.GC24652@parisc-linux.org> <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org> <498DA052.6090605@redhat.com> <1234019372.4658.9.camel@localhost.localdomain> <20090207225025.GB31509@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090207225025.GB31509@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Feb 07, 2009 at 09:09:32AM -0600, James Bottomley wrote:
>   
>> On Sat, 2009-02-07 at 09:53 -0500, Ric Wheeler wrote:
>>     
>>> I have been poked at by some vendors about the status of our support for 
>>> the virtually/thinly provisioned luns since they are getting close to 
>>> being able to test with real devices.
>>>       
>> With my LSF hat on, a certain array vendor might be sponsoring to get
>> the opportunity to raise this issue more fully.  The impression (mostly
>> correct) is that we're thinking about trim/unmap purely from the SSD FTL
>> point of view and perhaps not being as useful as we might to virtually
>> provisioned LUNs ... so you could mention to the other vendors that they
>> might have an interest in coming (and even possibly sponsoring).
>>     
>
> I thought we had agreed on a plan which satisfied the SSD and insane
> array vendors.  That is that we would do no tracking of allocation units
> in the filesystem, but instead extend each trim out to cover the maximum
> possible size.  I've confirmed with Intel's SSD people that this would
> cause them no harm at all (trimming already trimmed sectors won't even
> cause a slowdown).  Whether the filesystem people have taken note of
> this, I have no idea.
>
>   
That should be helpful for the array people, but for some of them with 
really large delete chuck sizes, they will still miss a lot since their 
size is larger than the average file size :-)  I guess that we could do 
something to resync - Ted mentioned some ideas for ext4.

On another note, they are pondering either using write same with the 
discard bit set or the unmap command. It would seem that for thin 
provisioning alone, either would work.

ric

