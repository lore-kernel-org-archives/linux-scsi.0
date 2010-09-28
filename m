From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 00:20:19 -0500
Message-ID: <4CA17B13.7080801@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com> <4CA0CC38.5010804@fusionio.com> <yq1pqvzcddq.fsf@sermon.lab.mkp.net> <4CA118FF.1080100@fusionio.com> <yq18w2mddav.fsf@sermon.lab.mkp.net> <20100927231551.GA15653@redhat.com> <4CA16F6A.1090904@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4CA16F6A.1090904@fusionio.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On 2010-09-28 08:15, Mike Snitzer wrote:
>> On Mon, Sep 27 2010 at  6:36pm -0400,
>> Martin K. Petersen <martin.petersen@oracle.com> wrote:
>>
>>>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
>>> Jens> Does mkfs do the right thing?
>>>
>>> Depends on which mkfs it is. Mike has tested things and can chip in
>>> here...
>> I haven't test all mkfs.* but...
>>
>> mkfs.xfs just works with 1M physical_block_size.
>>
>> mkfs.ext4 won't by default but -F "fixes" that:
>>
>> # mkfs.ext4 -b 4096 -F /dev/mapper/20017380023360006
>> mke2fs 1.41.12 (17-May-2010)
>> Warning: specified blocksize 4096 is less than device physical sectorsize 1048576, forced to continue
> 
> OK, so that's not exactly doing the right thing, but at least you can
> work around it with a parameter. So I'd say that is good enough.

Which part of it is the wrong thing...?

Today mkfs.ext4 refuses to create an fs blocksize which is smaller than logical
or physical by default, because one is suboptimal and the other is impossible.
-F (force) can override the suboptimal fs blocksize < logical blocksize case...

Should we change something?

Thanks,
-Eric

>> I'll check fdisk and parted tomorrow (I know lvm2 doesn't look at
>> physical_block_size).
> 
> Thanks!
> 

