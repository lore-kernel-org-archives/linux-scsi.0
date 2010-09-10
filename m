From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 02/22] configfs: Add struct
	configfs_item_operations->check_link() in configfs_unlink()
Date: Fri, 10 Sep 2010 12:06:46 -0700
Message-ID: <1284145606.19890.68.camel@haakon2.linux-iscsi.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
	 <20100902064814.GB27904@mail.oracle.com>
	 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
	 <201009071701.02847.konrad@darnok.org>
	 <20100907224413.GC21935@mail.oracle.com>
	 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
	 <20100908192639.GD29545@mail.oracle.com>
	 <1283979207.556.510.camel@haakon2.linux-iscsi.org>
	 <20100910152802.GG885@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100910152802.GG885@mail.oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-09-10 at 08:28 -0700, Joel Becker wrote:
> On Wed, Sep 08, 2010 at 01:53:27PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2010-09-08 at 12:26 -0700, Joel Becker wrote:
> > So after re-running this again, I was a bit off about where the OOOPs is
> > actually occuring.  So, the OOPs does not occur during in the simple
> > example here with the first unlink(2):
> > 
> > 	unlink sub_child/group1/src_0/src_link
> > 
> > but rather after the second unlink(2) is called after the first for
> > src_link occurs:
> > 
> > 	unlink sub_child/group2/dst_0/dst_link
> > 
> > So back to the OOPs with the current TCM code example, on v2.6.36-rc3
> > this actually triggers a SLUB warning "Object already free" from inside
> > of TCM code. This is attributed to the releasing a specific LUN ACLs
> > from the second unlink(2)'s struct config_item_operations->drop_link(),
> > that the first unlink had already released.  This is because the first
> > unlink(2) will currently assume that the remaining LUN ACLs are safe to
> > release because, it still assumes the disabled check_link call.
> 
> 	The trivial solution is to refcount your ACLs.  You get both
> allow_link() calls, so you should be able to increment a counter there,
> and then drop them when the last drop_link() call is made.  That will
> keep your consumer structures around until all links are exhausted.
> 

Hi Joel,

So I am a bit confused wrt to this last response..  The ->check_link()
patch and it's use in the fabric independent code within
target_core_fabric_configfs.c does exactly this for the 'MappedLUN'
symlink case, eg: requires the consumer to do the allow_link() +
drop_link() refcounting, and add the
API check into fs/configfs/symlink.c:configfs_unlink()

Is there another form of configfs consumer refcounting that you had in
mind beyond using an atomic_t for this with ->check_link() here..?

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_fabric_configfs.c;hb=refs/heads/lio-4.0#l675

So beyond a configfs consumer solution, what do you think about checking
for the sub_child/group2/dst_0/dst_link style of symlink
in fs/configfs/symlink.c:configfs_symlink() in order to add some form of
internal refcount when the symlink source is within the same consumer
LKM, but outside of the parent struct config_group..?

This would involve the conversion of fs/configfs/symlink.c:
configfs_unlink() path to check for the existence of this internal
refcount and returning -EPERM when any sub_child/group2/dst_0/dst_link
exist when 'unlink sub_child/group1/src_0/src_link' is attempted.

What do you think..?

Thanks!

--nab

