From: Joel Becker <Joel.Becker@ORACLE.COM>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Date: Wed, 8 Sep 2010 12:26:39 -0700
Message-ID: <20100908192639.GD29545@mail.oracle.com>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
 <20100902064814.GB27904@mail.oracle.com>
 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
 <201009071701.02847.konrad@darnok.org>
 <20100907224413.GC21935@mail.oracle.com>
 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283911739.556.420.camel@haakon2.linux-iscsi.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 07, 2010 at 07:08:59PM -0700, Nicholas A. Bellinger wrote:
> On Tue, 2010-09-07 at 15:44 -0700, Joel Becker wrote:
> > 	Nick, can you provide some form of description, not long
> > pathnames, that explains a) what breaks when the symlink is removed b)
> > why that can't be allowed if the user is dumb enough to request it?
> > 
> 
> So, the case where configfs will actually OOPs without the
> ->check_link() patch (or without some other internal solution) is on the
> unlink(2) path is when the symlink is created to a destination outside
> of the source struct config_group.  This may have not been exactly
> apparent in my LIO-Target example, but here is another shot at an
> example without the other complexities of target mode invovled.

	I wish you'd mentioned the oops earlier.  We need to figure out
who is oopsing.

> Say we have two different struct config_subsystem in two different LKM
> sub_parent and sub_child.  I will spare the actual mkdir(2) and ln(2)
> calls here, but (I hope) these are obvious:
> 
> First, we start out with the parent source struct config_group from
> sub_parent module:
> 
> 	/sys/kernel/config/sub_parent/group1/parent/
> 
> Next, we have a symlink from sub_parent/group1/parent to a different LKM
> in sub_child:
> 
> 	/sys/kernel/config/sub_child/group1/src_0/src_link -> ../../../../sub_parent/group1/parent
> 
> And then a second symlink from sub_child/group1/src_0/src_link to a
> sstuct config_group outside of group1, but still within sub_child:
> 
> 	/sys/kernel/config/sub_child/group2/dst_0/dst_link -> ../../../group1/src_0/

	I think you have too many ../ on your examples.  dst_link
pointing to ../../../../group1/src_0 resolves to
/sys/kernel/config/group1/src_0, which I don't think you want.  I think
you have:

    sub_parent/group1/parent
    sub_child/group1/src_0/src_link -> ../../../sub_parent/group1/parent
    sub_child/group2/dst_0/dst_link -> ../../group1/src_0

	If I'm reading this right, 'ls sub_child/group1/src_0/src_link'
gives you the contents of sub_parent/group1/parent, 'ls
sub_child/group2/dst_0/dst_link' gives you 'src_link', and 'ls
sub_child/group2/dst_0/dst_link/src_link' brings you right back to the
contents of sub_parent/group1/parent.  Am I right?

> So once the sub_child/group2/dest_0/dst_link has been created to back to
> sub_child/group1/src_0/src_link, the oops will appear any time that
> 'unlink sub_child/group1/src_0/src_link' is called while the second
> group2/dst_0/dst_link is still present.  I don't recall the actual
> backtrace of the OOPs that occurs when the unlink(2) is called, but it
> is easily reproducable .

	I'm confused.  Above it appears that
sub_child/group2/dst_0/dst_link -> ../../group1/src_0, but this
paragraph suggests that sub_child/group2/dst_0/dst_link ->
../../group1/src_0/src_link.  Which is it?

> I am really starting to think that fixing this properly below the struct
> config_item_operations API is going to make the most sense, but I have
> not realized this in a patch for fs/configfs/ just yet..  I am happy to
> do this in the next days if you think this would be the cleanest
> resolution for the above case.

	My big question is whether the oops comes from something
configfs is doing wrong when symlinking symlinks, or if your module is
just surprised when things change.  If the former, it needs to be fixed
in configfs.  It shouldn't require a hook for your module to avoid
configfs breakage.  If it is the latter, and your module needs to know
not to break itself, then we discuss how to help it.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
