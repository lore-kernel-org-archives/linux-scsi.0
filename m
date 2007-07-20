From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] buggered kmalloc()
Date: Fri, 20 Jul 2007 14:34:04 -0700
Message-ID: <1184967244.2692.0.camel@laptopd505.fenrus.org>
References: <20070720150340.GF21668@ftp.linux.org.uk>
	 <20070720200530.GA9978@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40574 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXGTVfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 17:35:32 -0400
In-Reply-To: <20070720200530.GA9978@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Whitcroft <apw@uk.ibm.com>

On Fri, 2007-07-20 at 16:05 -0400, Dave Jones wrote:
> On Fri, Jul 20, 2007 at 04:03:40PM +0100, Al Viro wrote:
>  > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>  > ---
>  > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>  > index aebcd5f..7829ab1 100644
>  > --- a/drivers/scsi/iscsi_tcp.c
>  > +++ b/drivers/scsi/iscsi_tcp.c
>  > @@ -1885,7 +1885,7 @@ static int iscsi_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
>  >  	struct sockaddr_in *sin;
>  >  	int rc = 0, len;
>  >  
>  > -	addr = kmalloc(GFP_KERNEL, sizeof(*addr));
>  > +	addr = kmalloc(sizeof(*addr), GFP_KERNEL);
>  >  	if (!addr)
>  >  		return -ENOMEM;
> 
> This seems like something that would be trivial to check for in checkpatch.

and at runtime if we make a __GFP_VALID flag we add to all GFP_'s (and
is just a few high bits in a specific pattern) and check that inside
kmalloc.. since kmalloc is inline just about always it's a constant and
thus compiled out check.. 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

