From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC 02/22] configfs: Add struct
 configfs_item_operations->check_link() in configfs_unlink()
Date: Fri, 10 Sep 2010 08:28:02 -0700
Message-ID: <20100910152802.GG885@mail.oracle.com>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
 <20100902064814.GB27904@mail.oracle.com>
 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
 <201009071701.02847.konrad@darnok.org>
 <20100907224413.GC21935@mail.oracle.com>
 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
 <20100908192639.GD29545@mail.oracle.com>
 <1283979207.556.510.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0IJPaY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 11:30:24 -0400
Content-Disposition: inline
In-Reply-To: <1283979207.556.510.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Sep 08, 2010 at 01:53:27PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2010-09-08 at 12:26 -0700, Joel Becker wrote:
> So after re-running this again, I was a bit off about where the OOOPs is
> actually occuring.  So, the OOPs does not occur during in the simple
> example here with the first unlink(2):
> 
> 	unlink sub_child/group1/src_0/src_link
> 
> but rather after the second unlink(2) is called after the first for
> src_link occurs:
> 
> 	unlink sub_child/group2/dst_0/dst_link
> 
> So back to the OOPs with the current TCM code example, on v2.6.36-rc3
> this actually triggers a SLUB warning "Object already free" from inside
> of TCM code. This is attributed to the releasing a specific LUN ACLs
> from the second unlink(2)'s struct config_item_operations->drop_link(),
> that the first unlink had already released.  This is because the first
> unlink(2) will currently assume that the remaining LUN ACLs are safe to
> release because, it still assumes the disabled check_link call.

	The trivial solution is to refcount your ACLs.  You get both
allow_link() calls, so you should be able to increment a counter there,
and then drop them when the last drop_link() call is made.  That will
keep your consumer structures around until all links are exhausted.

Joel

-- 

"I'm so tired of being tired,
 Sure as night will follow day.
 Most things I worry about
 Never happen anyway."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
