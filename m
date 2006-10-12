From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Thu, 12 Oct 2006 15:39:14 -0500
Message-ID: <452EA7F2.7040506@cs.wisc.edu>
References: <452E0A5C.6020001@aboo.org> <452E7A9A.3000501@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:22196 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750845AbWJLUjX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 16:39:23 -0400
In-Reply-To: <452E7A9A.3000501@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> I am sending this again as the initial mail did not make it to the list.
> 
> Hi All,
> 
> I thought a lot about whether  I should write to mailing list about this
> or not. I have requested help from the list before to complete this. May
> be I am too crazy to develop something like this. When I think more and
> more about this, it will be really useful, mainly for educational
> purposes and it could be useful in other environments.
> 
> I like to know everyone's opinion on this. Please let me know your
> thoughts and suggestions and its inclusion in the main line Linux kernel.
> 
> I have developed a Virtual HBA (Around ~600 lines of code). It is a
> kernel module and works very well with 2.6.9 kernel. Basically it
> registers a HBA (LLD) to the SCSI Mid layer. It implements a linked list
> with all the SCSI commands queued from Mid layer. I registered  a
> character device driver. I ship out the SCSI commands off to user space
> via this character device. There is a user space application monitoring
> this character device looking for SCSI commands, process it and sends it
> back to the mid layer through this character interface.  At the moment,
> the interface to the Virtual HBA inside the kernel is through read/write
> and ioctls to the character device. I am trying to get rid of reading
> and writing of SCSI request_buffer through character device and use
> memmap/splice to avoid copying kernel buffer to user space(I am facing
> some challenges as the request_buffer is not a linear buffer, but a
> scatter gather buffer).

Is there any reason you went with the virtual scsi hba? There is a
dm-userspace module which would allow you to put any block layer driver
in userspace. You should ask Dan Smith <danms@us.ibm.com> and Tomo
<fujita.tomonori@lab.ntt.co.jp> to learn more.

I guess the downside would be that a lot of scsi-ml would be duplicated
in userspace. I am not sure how big a deal that is. If it is a problem,
you could at least look into what it takes to throw requests and buffers
between the kernel and userspace and what code can be shared between
your driver, dm-userspace, SG_IO, and the scsi target code.
