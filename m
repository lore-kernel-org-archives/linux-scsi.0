From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new
	version of iscsi target?
Date: Thu, 22 Dec 2005 08:53:16 +0900
Message-ID: <20051222085316J.fujita.tomonori@lab.ntt.co.jp>
References: <43987F75.2000301@vlnb.net>
	<4398850D.8070102@cs.wisc.edu>
	<1134071290.3259.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:54456 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965000AbVLUXxz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2005 18:53:55 -0500
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

The current version of tgt that performs READ/WRITE commands in kernel
space using the vfs interface and other commands in user space. I'd
implemented a prototype version of tgt with the mmap scheme.

With the mmap tgt, the kernel module asks a single user-space daemon
(tgtd) to map a file (logical unit) through netlink, then it call
get_user_pages().

I did some initial performance tests with both tgt versions and IET
(as you know, another iSCSI software implementation runs in kernel
space). All implementations run with write back policy so probably,
there should be little real disk I/O effect. I started disktest
benchmark software with cold cache state. The machine has 4 GB memory,
1.5K SCSI disk, 4 CPUs (x86_64).

(disktest -PT -T10 -h1 -K8 -B8192 -ID /dev/sdc -w)

o IET
| 2005/12/21-18:05:15 | STAT  | 7259 | v1.2.8 | /dev/sdc | Total write throughput: 48195993.6B/s (45.96MB/s), IOPS 5883.3/s.

o tgt (I/O in kernel space)
| 2005/12/21-18:03:23 | STAT  | 7013 | v1.2.8 | /dev/sdc | Total write throughput: 45829324.8B/s (43.71MB/s), IOPS 5594.4/s.

o mmap tgt
| 2005/12/21-18:22:28 | STAT  | 7990 | v1.2.8 | /dev/sdc | Total write throughput: 25373900.8B/s (24.20MB/s), IOPS 3097.4/s.


I guess that one of the reasons for the mmap tgt poor performance is
that it uses single user-space daemon so all commands are
serialized. I will implement multi-threaded user-space daemon version
if you like to see its performance.

One potential disadvantage of the mmap scheme is that it reads
unnecessarily from disk about WRITE commands. That is, when it updates
the whole page frame, the vfs interface can avoid reading cleverly,
however, the mmap scheme cannot (If I understand correctly).
