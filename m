From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 13:10:01 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119131001.A11902@infradead.org>
References: <20031027153932.A16679@infradead.org> <012101c3ae9d$b0a3d010$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:15111 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264055AbTKSNKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 08:10:02 -0500
Content-Disposition: inline
In-Reply-To: <012101c3ae9d$b0a3d010$8f074d0a@apac.cisco.com>; from smhatre@cisco.com on Wed, Nov 19, 2003 at 06:34:39PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wed, Nov 19, 2003 at 06:34:39PM +0530, Sachin Mhatre (smhatre) wrote:
> Hi Christopher,
> 	Could you please elaborate on this review comment? 
> 	- kill ctl_open/ctl_release and move add an owner to the fops
> structure for refcounting.
> 
> Especially, what do you mean by "move add an owner to the fops structure
> for refcounting" ? We already use the .owner field in the
> file_operations template. What else are you refering to?

I currently do not have the code in front of me, but IIRC ctl_open/ctl_release
was only doing MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT (or even a broken
equivalent).  These days all refcounting is done by higher levels if you
provide a owner (=THIS_MODULE) field in struct file_operations and these
methods could be removed.  If you already have the owner set that's even
easier..

