From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Date: Mon, 20 Sep 2010 15:06:33 -0700
Message-ID: <20100920220633.GC8405@mail.oracle.com>
References: <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
 <201009071701.02847.konrad@darnok.org>
 <20100907224413.GC21935@mail.oracle.com>
 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
 <20100908192639.GD29545@mail.oracle.com>
 <1283979207.556.510.camel@haakon2.linux-iscsi.org>
 <20100910152802.GG885@mail.oracle.com>
 <1284145606.19890.68.camel@haakon2.linux-iscsi.org>
 <20100910194404.GJ885@mail.oracle.com>
 <1284148323.19890.94.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1284148323.19890.94.camel@haakon2.linux-iscsi.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[Sorry on the delay, I was out of town]

On Fri, Sep 10, 2010 at 12:52:03PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2010-09-10 at 12:44 -0700, Joel Becker wrote:
> > 	You can refcount without check_link().
> 
> So what do you recommend here..?

	That your ACL object, or whatever it is that considers itself to
be refcounted by the number of links, keep track of that and only free
itself when all are gone rather than freeing itself when the first goes
away.

> The problem is that the 'unlink sub_child/group1/src_0/src_link' can't
> signal to the other struct config_group to also call an internal 'unlink
> sub_child/group2/dst_0/dst_link' to drop the child link outside of it's
> struct config_group.

	Nor should it.  I'm asking what is so wrong about a world where
sub_child/group1/src_0/src_link is gone but
sub_child/group2/dst_0/dst_link remains?  Maybe that target object can't
work anymore, but the user broke it by breaking the link.

> > 	You're still fighting allowing the links to go away.  You
> > haven't explained why that is necessary.  You had a problem with a crash
> > because you expected one reference to your ACLs and actually have two,
> > but you can fix that without modifying configfs.
> 
> If this is the case then I must be mis-understanding what you mean by
> configfs consumer refcounting from allow_link() and drop_link().  Can
> you give me a bit more detail where I should be looking..?

	Here's how I sort of understood things.  First, you create the
src_link pointing to $object.  This somehow allocates some sort of ACL
structure hanging off of $object.  Then you create dst_link pointing to
src_link, which really ends up pointing to the $object.  So now you have
src_link and dst_link pointing to $object.
	Finally, someone unlinks src_link.  This triggers $object to
free the ACL structure.  When the caller later removes dst_link, it
crashes because it was expecting ACL to still be there.  Do I have it
right?
	I'm saying that $object should count how many people are
pointing to it, so that when you remove src_link, ACL is *not* freed.
It will only be freed when both src_link and dst_link are removed.  This
way you do not crash.  Perhaps I'm not understanding the ACL object.
Perhaps I'm missing the mechanism entirely.  But I don't see why the ACL
object must necessarily be freed when one symlink is removed but not the
other.

Joel

-- 

"And yet I fight,
 And yet I fight this battle all alone.
 No one to cry to;
 No place to call home."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
