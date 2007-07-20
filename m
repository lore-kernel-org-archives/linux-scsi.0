From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] buggered kmalloc()
Date: Fri, 20 Jul 2007 22:00:46 +0100
Message-ID: <20070720210046.GK21668@ftp.linux.org.uk>
References: <20070720150340.GF21668@ftp.linux.org.uk> <20070720200530.GA9978@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:41961 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762831AbXGTVAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 17:00:50 -0400
Content-Disposition: inline
In-Reply-To: <20070720200530.GA9978@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Whitcroft <apw@uk.ibm.com>

On Fri, Jul 20, 2007 at 04:05:30PM -0400, Dave Jones wrote:
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

Or just run sparse before and after - all such places stand out immediately...
