From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI kobject unregistration ordering problem
Date: Fri, 17 Oct 2003 08:50:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017155008.GA1298@beaverton.ibm.com>
References: <20031013151254.521d882e.akpm@osdl.org> <20031017133429.C27349@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:65217 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263435AbTJQPr0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 11:47:26 -0400
Content-Disposition: inline
In-Reply-To: <20031017133429.C27349@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Andrey Borzenkov <arvidjaar@mail.ru>

Christoph Hellwig [hch@infradead.org] wrote:
> On Mon, Oct 13, 2003 at 03:12:54PM -0700, Andrew Morton wrote:
> > So it looks like SCSI needs fixing.  Could someone please take care of this?
> > Thanks.
> 
> This needs fixing deeper down in the block layer and Al is working on
> that.  Once the block layer has sane semantics for device_del vs partitions
> scsi can be fixed trivially.

While I have it working now without the block layer changes (i.e., no
delayed device_del call in SCSI). I also thought there was something
needed in the block layer, there may still need to be block layer
updates for other issues but I am currently not seeing them in my
testing. The issue scsi was having is related to sd_remove freeing the
scsi_disk structure to early in some cases. Since sd passed the
scsi_disk structure to the block layer subsystem in a gendisk private
data pointer sd needs to use a ref count / release function model to
know when to free scsi_disk. I am almost done with a few surprise
removal test cases and will post the patch for review today.

-andmike
--
Michael Anderson
andmike@us.ibm.com

