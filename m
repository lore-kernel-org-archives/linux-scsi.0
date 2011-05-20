From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC v2 PATCH 1/2] bsg: Add infrastructure to send in kernel
 bsg commands.
Date: Sat, 21 May 2011 01:02:26 +0900
Message-ID: <20110521010226J.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LFD.2.02.1105181445490.7238@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44645 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558Ab1ETQCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 12:02:50 -0400
In-Reply-To: <alpine.LFD.2.02.1105181445490.7238@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chad.dupuis@qlogic.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

On Wed, 18 May 2011 14:47:13 -0400
Chad Dupuis <chad.dupuis@qlogic.com> wrote:

> From: Chad Dupuis <chad.dupuis@qlogic.com>
> 
> This patch adds a new exported function, bsg_private_command(), and a few
> supporting functions that allow a device driver or other kernel code to be
> able to send bsg commands from within the kernel using sg_io_v4.  The private
> command infrastructure mimics the ioctl interface except that the bsg request
> queue needs to be explicitly passed in.

I can't recall the discussion conclusion about sending bsg requests from
kernel space at lsf. The conclusion is that we need this feature?

> The helper functions are similar to the bsg_map_hdr() function except that
> no bsg_device is needed and kernel buffers are used instead of user buffers.
> This was done so that the current semantics of user space bsg calls would
> remain undisturbed, to avoid the complications of mixing user vs. kernel
> buffers and not having to create a dummy bsg device for each command submitted.
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>   block/bsg.c         |  207 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/bsg.h |    1 +
>   2 files changed, 208 insertions(+), 0 deletions(-)

Looks like the majority of the code is the copy of the exisiting code. Can we
avoid the duplication by creating some common helper functions?

Don't we need to take care of a race that sending a bsg request to a bsg
device in the process of removal?
