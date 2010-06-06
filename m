From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag
 on ext2 write)
Date: Sun, 06 Jun 2010 12:35:03 +0300
Message-ID: <4C0B6BC7.8070803@panasas.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <4C07D3D0.8010500@panasas.com> <20100604162332.GF3414@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100604162332.GF3414@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 06/04/2010 07:23 PM, Jan Kara wrote:
> On Thu 03-06-10 19:09:52, Boaz Harrosh wrote:
>> [Topic]
>> How to not let pages change while in IO
>>
>> [Abstract]
>> As seen in a long thread on the fsdvel scsi mailing lists. Lots of
>> people have headaches and sleep less nights because individual pages
>> can change while in IO and/or DMA. Though each one as slightly different
>> needs, the mechanics look to be the same.

>   Hmm, I don't think it's really about "how to not let pages change" - that
> is doable by using wait_on_page_writeback() in ->page_mkwrite and
> ->write_begin. I think the discussion is more about whether we should do it
> or whether we should rechecksum and resubmit IO in case of checksum failure
> as Nick proposed...
> 
> 								Honza

I have hijacked the DIF threads but, No, my proposal is for a general toolset
that could be used for all the above as well as DIF if needed.

Surly even with DIF the keep-constant vs retransmit is a matter of machine+link
speed multiply by faulting work loads. So there might be situations where an admin
wants to choose.

With other none checksum fixtures, like RAID5/MIRROR this is not always an option
and it becomes keep-constant vs copy. (That is complete workload copy). So for
these setups the option is clear. No?

I'm glad that you think it is easy/doable to implement. And I'll surly test your
above receipt. Do you think it would be acceptable as a generic per-sb tunable.
So for instance an ext3 over RAID5 could turn this on and eliminate the data copy?

Lets talk about this in LSF
Boaz

>> People that care:
>> - Mirror and RAID people that need on disk consistency.
>> - Network storage that wants data checksum.
>> - DIF/DIX people
>> - ...
>>
>> I for one know nothing of the subject but am a RAID person and would
>> like a solution that does not force me to copy the complete data load.
>>
>> Please lets get all the VM VFS and drivers people in one room and see
>> if we can have a Linux solution to this problem

