From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Netlink and user-space buffer pointers
Date: Thu, 20 Apr 2006 18:07:51 -0500
Message-ID: <44481447.3050303@cs.wisc.edu>
References: <1145306661.4151.0.camel@localhost.localdomain> <20060418160121.GA2707@us.ibm.com> <444633B5.5030208@emulex.com> <4446AC80.6040604@cs.wisc.edu> <44479BA8.1000405@emulex.com> <4447C8C2.30909@cs.wisc.edu> <4447E91E.7030603@emulex.com> <4448024D.3030800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58517 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751374AbWDTXH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 19:07:58 -0400
In-Reply-To: <4448024D.3030800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> snipped lkml and netdev. I do not think they care do they.
> 
> James Smart wrote:
>> Note: We've transitioned off topic. If what this means is "there isn't a
>> good
>> way except by ioctls (which still isn't easily portable) or system calls",
>> then that's ok. Then at least we know the limits and can look at other
>> implementation alternatives.
>>
> 
> So we have

Ok for those that emailed me off list. All these interfaces have a
similar problems in that the kernel cannot get enough pages to make a
scatterlist that is within the HBA's limits. block/scsi_ioctl.c handles
this by failing the request, sg.c handles this by preallocating buffers,
the target code handles this by calling the target transfer function
multiple times as James described, and using netlink as described for a
target or initiator and for sg io or target commands or transport
commands has similar issues if it just cannot get enough pages to make a
proper scatterlist, but currently it has the extra limitation in that we
are not supposed to pass pointers.

Sorry for the confusion.

> 
> 1. sysfs: prbably bad becuase to pass down every attr for the command we
> need a seperate file. This does not seem like it meets the binary sysfs
> file requirement.
> 
> 2. configfs: again bad becuase we have to pass down eveyr attr for the
> command in a speperate file.
> 
> 3. ioctl: Christoph has not allowed scsi drivers to add ioctls so I
> doubt he would let some other scsi code let it.
> 
> 4. syscall:
> 
> 5. netlink: netdev guys do not want use to pass pointers. So we either
> have a worst case double copy (copy from userspace to network and
> network to buffer that is within the LLDs queue limits (do like sg where
> it as a preallocated buffer)) or if we used the bio code like how the
> ll_rw_blk.c does just fail if the command is to large. In some cases the
> io may just be too large and have to fail though.
> 
> 	5A. modify netlink to copy data to a buffer that is within some sort of
> limits we can DMA from.
> 	5B. debate with netdev guys about passing poitners, in which case we
> could have some of the problem 5 has in that when we map data we do not
> have much control over the pages so we may have to drop down to a copy
> to some preallocate buffer or fail model.
> 
> 6. char device
> 
> 7. what else...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

