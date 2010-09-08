From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 02/22] configfs: Add struct
	configfs_item_operations->check_link() in configfs_unlink()
Date: Tue, 07 Sep 2010 19:08:59 -0700
Message-ID: <1283911739.556.420.camel@haakon2.linux-iscsi.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
	 <20100902064814.GB27904@mail.oracle.com>
	 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
	 <201009071701.02847.konrad@darnok.org>
	 <20100907224413.GC21935@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100907224413.GC21935@mail.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-09-07 at 15:44 -0700, Joel Becker wrote:
> On Tue, Sep 07, 2010 at 05:01:01PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > 	I NAK'd this a while back.  I'm willing to be convinced, but so
> > > > far it remains that way.
> > >
> > > Hi Joel,
> > >
> > > Thanks for bringing this point up again.  So a brief refresh on why this
> > > is currently required in the fabric independent configfs handlers in
> > > drivers/target/target_core_fabric_configfs.c (patch #19).
> > 
> > Well, that is great that you mentioned your requirements. But I don't see a 
> > quote of Joel's concerns? Is there an LKML link for it perhaps?
> 
> 	It was a while back.  Essentially, the concern is that configfs
> is defined to be userspace-driven.  If the user asks you to remove
> something, the module should be handling safe teardown rather than
> rejecting the user's request.
> 	Now, the world isn't always clean-cut.  Code outside of the
> filesystem representation can lay a claim on a configfs item to say "I'm
> busy with this."  An example is ocfs2 pinning the configfs item
> describing its cluster heartbeat device.   But this is ocfs2 - a
> separate thing - claiming it.  There is a defined API to take and
> release these claims.
> 	This API doesn't cover symlinks, as symlinks are simply linkage
> between config items.  It may be, as Nick suggested at the bottom of his
> reply, that we want the API extended to cover that case.  But he hasn't
> yet convinced me that safe teardown is impossible or disasterous.
> That's what I'd like to see.  It's not obvious on the face of all the
> file trees in the email.
> 	Nick, can you provide some form of description, not long
> pathnames, that explains a) what breaks when the symlink is removed b)
> why that can't be allowed if the user is dumb enough to request it?
> 

Hi Joel,

So, the case where configfs will actually OOPs without the
->check_link() patch (or without some other internal solution) is on the
unlink(2) path is when the symlink is created to a destination outside
of the source struct config_group.  This may have not been exactly
apparent in my LIO-Target example, but here is another shot at an
example without the other complexities of target mode invovled.

Say we have two different struct config_subsystem in two different LKM
sub_parent and sub_child.  I will spare the actual mkdir(2) and ln(2)
calls here, but (I hope) these are obvious:

First, we start out with the parent source struct config_group from
sub_parent module:

	/sys/kernel/config/sub_parent/group1/parent/

Next, we have a symlink from sub_parent/group1/parent to a different LKM
in sub_child:

	/sys/kernel/config/sub_child/group1/src_0/src_link -> ../../../../sub_parent/group1/parent

And then a second symlink from sub_child/group1/src_0/src_link to a
sstuct config_group outside of group1, but still within sub_child:

	/sys/kernel/config/sub_child/group2/dst_0/dst_link -> ../../../group1/src_0/

So once the sub_child/group2/dest_0/dst_link has been created to back to
sub_child/group1/src_0/src_link, the oops will appear any time that
'unlink sub_child/group1/src_0/src_link' is called while the second
group2/dst_0/dst_link is still present.  I don't recall the actual
backtrace of the OOPs that occurs when the unlink(2) is called, but it
is easily reproducable .

I am really starting to think that fixing this properly below the struct
config_item_operations API is going to make the most sense, but I have
not realized this in a patch for fs/configfs/ just yet..  I am happy to
do this in the next days if you think this would be the cleanest
resolution for the above case.

Thanks Joel!

--nab
