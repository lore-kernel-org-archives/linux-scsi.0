From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 02/22] configfs: Add struct
	configfs_item_operations->check_link() in configfs_unlink()
Date: Wed, 08 Sep 2010 13:53:27 -0700
Message-ID: <1283979207.556.510.camel@haakon2.linux-iscsi.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
	 <20100902064814.GB27904@mail.oracle.com>
	 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
	 <201009071701.02847.konrad@darnok.org>
	 <20100907224413.GC21935@mail.oracle.com>
	 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
	 <20100908192639.GD29545@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:45389 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754290Ab0IHU5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 16:57:33 -0400
In-Reply-To: <20100908192639.GD29545@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@ORACLE.COM>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, 2010-09-08 at 12:26 -0700, Joel Becker wrote:
> On Tue, Sep 07, 2010 at 07:08:59PM -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2010-09-07 at 15:44 -0700, Joel Becker wrote:
> > > 	Nick, can you provide some form of description, not long
> > > pathnames, that explains a) what breaks when the symlink is removed b)
> > > why that can't be allowed if the user is dumb enough to request it?
> > > 
> > 
> > So, the case where configfs will actually OOPs without the
> > ->check_link() patch (or without some other internal solution) is on the
> > unlink(2) path is when the symlink is created to a destination outside
> > of the source struct config_group.  This may have not been exactly
> > apparent in my LIO-Target example, but here is another shot at an
> > example without the other complexities of target mode invovled.
> 
> 	I wish you'd mentioned the oops earlier.  We need to figure out
> who is oopsing.

Ok, I ran the code w/o ->check_link() again and have a few corrections
below.

> 
> > Say we have two different struct config_subsystem in two different LKM
> > sub_parent and sub_child.  I will spare the actual mkdir(2) and ln(2)
> > calls here, but (I hope) these are obvious:
> > 
> > First, we start out with the parent source struct config_group from
> > sub_parent module:
> > 
> > 	/sys/kernel/config/sub_parent/group1/parent/
> > 
> > Next, we have a symlink from sub_parent/group1/parent to a different LKM
> > in sub_child:
> > 
> > 	/sys/kernel/config/sub_child/group1/src_0/src_link -> ../../../../sub_parent/group1/parent
> > 
> > And then a second symlink from sub_child/group1/src_0/src_link to a
> > sstuct config_group outside of group1, but still within sub_child:
> > 
> > 	/sys/kernel/config/sub_child/group2/dst_0/dst_link -> ../../../group1/src_0/
> 
> 	I think you have too many ../ on your examples.  dst_link
> pointing to ../../../../group1/src_0 resolves to
> /sys/kernel/config/group1/src_0, which I don't think you want.  I think
> you have:
> 
>     sub_parent/group1/parent
>     sub_child/group1/src_0/src_link -> ../../../sub_parent/group1/parent
>     sub_child/group2/dst_0/dst_link -> ../../group1/src_0
> 
> 	If I'm reading this right, 'ls sub_child/group1/src_0/src_link'
> gives you the contents of sub_parent/group1/parent, 'ls
> sub_child/group2/dst_0/dst_link' gives you 'src_link', and 'ls
> sub_child/group2/dst_0/dst_link/src_link' brings you right back to the
> contents of sub_parent/group1/parent.  Am I right?

This is correct.

> 
> > So once the sub_child/group2/dest_0/dst_link has been created to back to
> > sub_child/group1/src_0/src_link, the oops will appear any time that
> > 'unlink sub_child/group1/src_0/src_link' is called while the second
> > group2/dst_0/dst_link is still present.  I don't recall the actual
> > backtrace of the OOPs that occurs when the unlink(2) is called, but it
> > is easily reproducable .
> 
> 	I'm confused.  Above it appears that
> sub_child/group2/dst_0/dst_link -> ../../group1/src_0, but this
> paragraph suggests that sub_child/group2/dst_0/dst_link ->
> ../../group1/src_0/src_link.  Which is it?

Sorry, the symlink should be from sub_child/group2/dst_0/dst_link
-> ../../group1/src_0/

> 
> > I am really starting to think that fixing this properly below the struct
> > config_item_operations API is going to make the most sense, but I have
> > not realized this in a patch for fs/configfs/ just yet..  I am happy to
> > do this in the next days if you think this would be the cleanest
> > resolution for the above case.
> 
> 	My big question is whether the oops comes from something
> configfs is doing wrong when symlinking symlinks, or if your module is
> just surprised when things change.  If the former, it needs to be fixed
> in configfs.  It shouldn't require a hook for your module to avoid
> configfs breakage.  If it is the latter, and your module needs to know
> not to break itself, then we discuss how to help it.
> 

So after re-running this again, I was a bit off about where the OOOPs is
actually occuring.  So, the OOPs does not occur during in the simple
example here with the first unlink(2):

	unlink sub_child/group1/src_0/src_link

but rather after the second unlink(2) is called after the first for
src_link occurs:

	unlink sub_child/group2/dst_0/dst_link

So back to the OOPs with the current TCM code example, on v2.6.36-rc3
this actually triggers a SLUB warning "Object already free" from inside
of TCM code. This is attributed to the releasing a specific LUN ACLs
from the second unlink(2)'s struct config_item_operations->drop_link(),
that the first unlink had already released.  This is because the first
unlink(2) will currently assume that the remaining LUN ACLs are safe to
release because, it still assumes the disabled check_link call.

I am still pretty certain that I had seen an OOPs in fs/configfs/ code
while doing this at some point (perhaps was w/o slub_debug=FZ..?), but
so far I have not been able to trigger an issue in fs/configfs/
directly.

So, I believe that the main issue here is still involving the unlinking
the first symlink (sub_child/group1/src_0/src_link), and then unlinking
the second symlink (sub_child/group2/dst_0/dst_link) which is still
depending upon the first configfs consumer data structures still being
present.

Does this make sense..?

--nab


