From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Fri, 30 Dec 2005 21:27:29 -0600
Message-ID: <43B5FAA1.9000800@cs.wisc.edu>
References: <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu>	 <1134071290.3259.31.camel@mulgrave>	 <20051227085340L.fujita.tomonori@lab.ntt.co.jp> <1135787528.3854.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20713 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932081AbVLaD2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 22:28:03 -0500
In-Reply-To: <1135787528.3854.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, vst@vlnb.net, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

James Bottomley wrote:
> On Tue, 2005-12-27 at 08:53 +0900, FUJITA Tomonori wrote:
> 
>>Mike and I have worked on the tgt mmap version.
>>
>>o It does read/write commands like sg by using mmap in user space and
>>get_user_pages in kernel space.
>>
>>o It does non-read/write commands like direct I/O by allocating
>>aligned buffers in user space and using get_user_pages in kernel space.
>>
>>It works like the simple tap that you suggested. It does not allocate
>>buffers in kernel space at all and does zero copy on all sorts of
>>commands.
>>
>>Here are some performance results with open-iscsi (which are better
>>than the previous results that I got with sfnet).
>>
>>o IET
>>
>>| 2005/12/27-07:50:59 | STAT  | 6827 | v1.2.8 | /dev/sdc | Total write throughput: 53790310.4B/s (51.30MB/s), IOPS 6566.2/s.
>>
>>o current tgt (I/O in kernel space)
>>
>>| 2005/12/27-08:07:50 | STAT  | 7294 | v1.2.8 | /dev/sdc | Total write throughput: 49666457.6B/s (47.37MB/s), IOPS 6062.8/s.
>>
>>o tgt mmap
>>
>>| 2005/12/27-08:42:51 | STAT  | 5286 | v1.2.8 | /dev/sdc | Total write
>>throughput: 44701286.4B/s (42.63MB/s), IOPS 5456.7/s.
>>
>>We can get something like this if we avoid calling mmap/munmap per
>>command (by using some sorts of caching).
>>
>>o tgt mmap (mmap caching)
>>
>>| 2005/12/27-07:53:19 | STAT  | 6996 | v1.2.8 | /dev/sdc | Total write throughput: 48253337.6B/s (46.02MB/s), IOPS 5890.3/s.
>>
>>
>>James, can we get your approval of the this mmap design?
> 
> 
> Yes, that looks fine ... it runs in user space, which was really all I
> was looking for.
> 
> There is another half to this, which is that I'd like the tap to come
> via a SCSI API.  This isn't strictly necessary for iSCSI but it would
> allow us to integrate a generic target approach that could work for all
> SCSI HBA's as well as just iSCSI.
> 

The code we currently have is designed to work with software iscsi 
targets or software AoE and HW cards like qlogic or emulex's FC cards. 
There are a lot of places we could use scsi-ml or block layer structs 
like the request or scsi_cmnd.

To support HW like qlogic or emulex's FC target mode, are you thinking 
you might want us to add on to the scsi-ml's scsi_host_template or add a 
scsi_target_template? If we add on to the scsi_host_template and if that 
one PCI device would be in initiator and target mode at the same time 
would we have one scsi_host for that resource and just add our target 
related fields to the scsi_host? Is this what you mean?
