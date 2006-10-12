From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Fri, 13 Oct 2006 07:48:01 +0900 (JST)
Message-ID: <20061013074411B.fujita.tomonori@lab.ntt.co.jp>
References: <452E0A5C.6020001@aboo.org>
	<452E7A9A.3000501@aboo.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:53454 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1751275AbWJLWsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 18:48:35 -0400
In-Reply-To: <452E7A9A.3000501@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aboo@aboo.org
Cc: linux-scsi@vger.kernel.org

From: Aboo Valappil <aboo@aboo.org>
Subject: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Fri, 13 Oct 2006 03:25:46 +1000

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

As James and Mike said, tgt provides SCSI command processing in user
space (target mode). I implemented the virtual HBA driver (initiator
mode) for Xen that works with tgt. I guess that it is similar to your
virtual HBA driver.

You can find the slides in Xen Summit site:

http://www.xensource.com/xen/xensummit.html

