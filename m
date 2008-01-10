From: Mark Rustad <mrustad@gmail.com>
Subject: Re: [PATCH] bsg : Add support for io vectors in bsg
Date: Thu, 10 Jan 2008 16:33:07 -0600
Message-ID: <622A3567-4665-48DE-8C2C-B9297BBD9A83@gmail.com>
References: <Pine.LNX.4.64.0801042137350.7836@localhost> <200801050501.m0551LFB030667@mbox.iij4u.or.jp> <20080108220918.GA9484@osc.edu> <20080109091118N.fujita.tomonori@lab.ntt.co.jp> <20080110204325.GC1928@osc.edu> <1199998531.3141.96.camel@localhost.localdomain> <20080110214605.GD1928@osc.edu>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:24154 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbYAJWdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:33:11 -0500
Received: by py-out-1112.google.com with SMTP id u52so1267187pyb.10
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 14:33:10 -0800 (PST)
In-Reply-To: <20080110214605.GD1928@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, deepakrc@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Jan 10, 2008, at 3:46 PM, Pete Wyckoff wrote:

> I'm fine with read/write, except Tomo is against handling iovecs
> because of the compat complexity with struct iovec being different
> on 32- vs 64-bit.  There is a standard way to do "compat" ioctl that
> hides this handling in a different file (not bsg.c), which is the
> only reason I'm even considering these ioctls.  I don't care about
> compat setups per se.

That is what I was thinking. Is it really necessary to support  
something like bsg for 32 on 64 bit? Yes, it is a userspace interface,  
but it isn't the kind of thing that normal user programs would use. It  
is a new interface for newly-written programs and I would expect those  
to be native. At least it doesn't strike me as overly-restrictive for  
that to be the case for this kind of interface.

> Is there another async I/O mechanism?  Userspace builds the CDBs,
> just needs some way to drop them in SCSI ML.  BSG is almost perfect
> for this, but doesn't do iovec, leading to lots of memcpy.


Precisely.

-- 
Mark Rustad, MRustad@gmail.com


