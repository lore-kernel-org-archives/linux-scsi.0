From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Tue, 31 Aug 2010 13:07:55 +0300
Message-ID: <4C7CD47B.1050409@panasas.com>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7CB936.8010509@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:11257 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566Ab0HaKIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 06:08:02 -0400
In-Reply-To: <4C7CB936.8010509@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>

On 08/31/2010 11:11 AM, Tejun Heo wrote:
> On 08/30/2010 10:20 PM, Jan Kara wrote:
>>   My setup is that I have a dedicated partition / drive for a filesystem
>> which is written to from a guest kernel running under KVM. I have set it up
>> using virtio driver with cache=writeback so that the host caches the writes
>> in a similar way disk caches them. At some point I just kill the qemu-kvm
>> process and at that point I'd like to also throw away data cached by the
>> host...
> 
> $ echo 1 > /sys/block/sdX/device/delete
> $ echo - - - > /sys/class/scsi_host/hostX/scan
> 

I don't know all the specifics of the virtio driver and the KVM backend but
don't the KVM target io is eventually directed to a local file or device?
If so the scsi device has disappeard but the bulk of the data is in host cache
at the backstore (file or bdev). Once all files are closed the data is synced
to disk.

Is it not the same as Ric's problem of disconnecting the sata cable but
not dropping power to the drive. The main of the cache is still intact.

> should do the trick.
> 
> Thanks.
> 

Thanks
Boaz
