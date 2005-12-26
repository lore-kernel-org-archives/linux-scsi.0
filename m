From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new
	version of iscsi target?
Date: Tue, 27 Dec 2005 08:53:40 +0900
Message-ID: <20051227085340L.fujita.tomonori@lab.ntt.co.jp>
References: <43987F75.2000301@vlnb.net>
	<4398850D.8070102@cs.wisc.edu>
	<1134071290.3259.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43652 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932166AbVLZXyU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Dec 2005 18:54:20 -0500
In-Reply-To: <1134071290.3259.31.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: michaelc@cs.wisc.edu, vst@vlnb.net, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version of iscsi target?
Date: Thu, 08 Dec 2005 14:48:10 -0500

> On Thu, 2005-12-08 at 13:10 -0600, Mike Christie wrote:
> > cleanup. In the end some of the scsi people liked the idea of throwing 
> > the non-read/write command to userspace and to do this we just decided 
> > to start over but I have been cutting and pasting your code and cleaning 
> > it up as I add more stuff.
> 
> To be honest, I'd like to see all command processing at user level
> (including read/write ... for block devices, it shouldn't be that
> inefficient, since you're merely going to say remap an area from one
> device to another; as long as no data transformation ever occurs, the
> user never touches the data and it all remains in the kernel page
> cache).
> 
> My ideal for the kernel based infrastructure is a simple tap for
> transporting commands addressed to devices upwards (and the responses
> downwards).  Then everyone can have their own user space processing
> implementation that I don't have to care about.

Mike and I have worked on the tgt mmap version.

o It does read/write commands like sg by using mmap in user space and
get_user_pages in kernel space.

o It does non-read/write commands like direct I/O by allocating
aligned buffers in user space and using get_user_pages in kernel space.

It works like the simple tap that you suggested. It does not allocate
buffers in kernel space at all and does zero copy on all sorts of
commands.

Here are some performance results with open-iscsi (which are better
than the previous results that I got with sfnet).

o IET

| 2005/12/27-07:50:59 | STAT  | 6827 | v1.2.8 | /dev/sdc | Total write throughput: 53790310.4B/s (51.30MB/s), IOPS 6566.2/s.

o current tgt (I/O in kernel space)

| 2005/12/27-08:07:50 | STAT  | 7294 | v1.2.8 | /dev/sdc | Total write throughput: 49666457.6B/s (47.37MB/s), IOPS 6062.8/s.

o tgt mmap

| 2005/12/27-08:42:51 | STAT  | 5286 | v1.2.8 | /dev/sdc | Total write
throughput: 44701286.4B/s (42.63MB/s), IOPS 5456.7/s.

We can get something like this if we avoid calling mmap/munmap per
command (by using some sorts of caching).

o tgt mmap (mmap caching)

| 2005/12/27-07:53:19 | STAT  | 6996 | v1.2.8 | /dev/sdc | Total write throughput: 48253337.6B/s (46.02MB/s), IOPS 5890.3/s.


James, can we get your approval of the this mmap design?
