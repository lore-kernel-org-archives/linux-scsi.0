From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Tue, 31 Aug 2010 12:13:36 +0200
Message-ID: <4C7CD5D0.40007@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7CB936.8010509@kernel.org> <4C7CD47B.1050409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C7CD47B.1050409@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/31/2010 12:07 PM, Boaz Harrosh wrote:
> I don't know all the specifics of the virtio driver and the KVM backend but
> don't the KVM target io is eventually directed to a local file or device?
> If so the scsi device has disappeard but the bulk of the data is in host cache
> at the backstore (file or bdev). Once all files are closed the data is synced
> to disk.
> 
> Is it not the same as Ric's problem of disconnecting the sata cable but
> not dropping power to the drive. The main of the cache is still intact.

There are two layers of caching there.

 drive cache - host page cache - guest

When guest issues FLUSH, qemu will translate it into fdatasync which
will flush the host page cache followed by FLUSH to the drive which
will flush the drive cache to the media.  If you delete the host disk
device, it will be detached w/o host page cache flushed.  So, although
it's not complete, it will lose good part of cache.  With out write
out timeout increased and/or with laptop mode enabled, it will
probably lose most of cache.

Thanks.

-- 
tejun
