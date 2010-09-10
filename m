From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Date: Fri, 10 Sep 2010 12:44:04 -0700
Message-ID: <20100910194404.GJ885@mail.oracle.com>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
 <20100902064814.GB27904@mail.oracle.com>
 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
 <201009071701.02847.konrad@darnok.org>
 <20100907224413.GC21935@mail.oracle.com>
 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
 <20100908192639.GD29545@mail.oracle.com>
 <1283979207.556.510.camel@haakon2.linux-iscsi.org>
 <20100910152802.GG885@mail.oracle.com>
 <1284145606.19890.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31146 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0IJTr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 15:47:27 -0400
Content-Disposition: inline
In-Reply-To: <1284145606.19890.68.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 10, 2010 at 12:06:46PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2010-09-10 at 08:28 -0700, Joel Becker wrote:
> > 	The trivial solution is to refcount your ACLs.  You get both
> > allow_link() calls, so you should be able to increment a counter there,
> > and then drop them when the last drop_link() call is made.  That will
> > keep your consumer structures around until all links are exhausted.
> > 
> 
> So I am a bit confused wrt to this last response..  The ->check_link()
> patch and it's use in the fabric independent code within
> target_core_fabric_configfs.c does exactly this for the 'MappedLUN'
> symlink case, eg: requires the consumer to do the allow_link() +
> drop_link() refcounting, and add the
> API check into fs/configfs/symlink.c:configfs_unlink()

	You can refcount without check_link().
 
> Is there another form of configfs consumer refcounting that you had in
> mind beyond using an atomic_t for this with ->check_link() here..?

	I'm saying that you won't crash if you don't free the ACLs on
the first drop_link().  That is, the drop_link() goes through as
configfs wants it to, but you don't crash.

> So beyond a configfs consumer solution, what do you think about checking
> for the sub_child/group2/dst_0/dst_link style of symlink
> in fs/configfs/symlink.c:configfs_symlink() in order to add some form of
> internal refcount when the symlink source is within the same consumer
> LKM, but outside of the parent struct config_group..?
> 
> This would involve the conversion of fs/configfs/symlink.c:
> configfs_unlink() path to check for the existence of this internal
> refcount and returning -EPERM when any sub_child/group2/dst_0/dst_link
> exist when 'unlink sub_child/group1/src_0/src_link' is attempted.

	You're still fighting allowing the links to go away.  You
haven't explained why that is necessary.  You had a problem with a crash
because you expected one reference to your ACLs and actually have two,
but you can fix that without modifying configfs.

Joel

-- 

"I have never let my schooling interfere with my education."
        - Mark Twain

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
