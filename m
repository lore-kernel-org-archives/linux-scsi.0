From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Mon, 30 Aug 2010 17:24:53 -0300
Message-ID: <4C7C1395.5020000@redhat.com>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100830202034.GB12226@quack.quadriga.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

  On 08/30/2010 05:20 PM, Jan Kara wrote:
> On Mon 30-08-10 15:56:43, Jeff Moyer wrote:
>> Jan Kara<jack@suse.cz>  writes:
>>
>>>    An update: I've set up an ext4 barrier testing in KVM - run fsstress,
>>> kill KVM at some random moment and check that the filesystem is consistent
>>> (kvm is run in cache=writeback mode to simulate disk cache). About 70 runs
>> But doesn't your "disk cache" survive the "power cycle" of your guest?
>    Yes, you're right. Thinking about it now the test setup was wrong because
> it didn't refuse writes to the VM's data partition after the moment I
> killed KVM. Thanks for catching this. I will probably have to use the fault
> injection on the host to disallow writing the device at a certain moment.
> Or does somebody have a better option?
>    My setup is that I have a dedicated partition / drive for a filesystem
> which is written to from a guest kernel running under KVM. I have set it up
> using virtio driver with cache=writeback so that the host caches the writes
> in a similar way disk caches them. At some point I just kill the qemu-kvm
> process and at that point I'd like to also throw away data cached by the
> host...
>
> 									Honza

Hi Jan,

Not sure if this is relevant, but what we have been using for part of the 
testing is an external e-sata enclosure that you can stick pretty much any S-ATA 
disk into. Important to drop power to the external disk (do not pull the s-ata 
cable, the firmware will destage the write cache for some/many disks if it has 
power and sees link loss :)).

Once you turn the drive back on, the test was can you mount without error, 
unmount and do a fsck -f to verify no meta-data corruption,

Ric

