From: Andrew Morton <akpm@osdl.org>
Subject: Re: ips.c warnings
Date: Sun, 16 Oct 2005 15:57:15 -0700
Message-ID: <20051016155715.3edda40d.akpm@osdl.org>
References: <20051016140817.4de1cc19.akpm@osdl.org>
	<1129502688.9388.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:21414 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932081AbVJPW5t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 18:57:49 -0400
In-Reply-To: <1129502688.9388.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Sun, 2005-10-16 at 14:08 -0700, Andrew Morton wrote:
>  > drivers/scsi/ips.c: In function `ips_scmd_buf_write':
>  > drivers/scsi/ips.c:3665: warning: null argument where non-null required (arg 1)
>  > drivers/scsi/ips.c: In function `ips_scmd_buf_read':
>  > drivers/scsi/ips.c:3697: warning: null argument where non-null required (arg 2)
>  > drivers/scsi/ips.c: In function `ips_register_scsi':
>  > 
>  > Due to
>  > 
>  >                         memcpy(IPS_SG_ADDRESS(&sg[i]), &cdata[xfer_cnt],
>  >                                min_cnt);
>  > 
>  > I guess the compiler is saying that if IPS_SG_ADDRESS indeed evaluates to
>  > NULL (as it is designed to do), we have an oops.
> 
>  That's weird ... the compiler can't possibly be in a position to make
>  that judgement call.  We have lots of places where we return null if
>  something goes wrong and the kernel oopses.  The compiler certainly
>  isn't warning about all of them.

Well I guess the difference is that the compiler can _see_ that
IPS_SG_ADDRESS() might return NULL:

#define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \
                                  page_address((sg)->page)+(sg)->offset : NULL)

What's the point in this expression anyway?  Why not just assume that
page_address() returns non-NULL?


