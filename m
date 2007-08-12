From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Re: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 15:32:49 -0500
Message-ID: <1186950769.3400.34.camel@localhost.localdomain>
References: <200708120228.26234.jesper.juhl@gmail.com>
	 <46BE60B5.7010708@gmail.com>  <20070812065806.GC21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45871 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753662AbXHLUcv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 16:32:51 -0400
In-Reply-To: <20070812065806.GC21089@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Rene Herman <rene.herman@gmail.com>, Jesper Juhl <jesper.juhl@gmail.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike.miller@hp.com

On Sun, 2007-08-12 at 07:58 +0100, Al Viro wrote:
> On Sun, Aug 12, 2007 at 03:21:57AM +0200, Rene Herman wrote:
> > @@ -2609,13 +2609,13 @@ static void do_cciss_request(request_queue_t *q)
> >  		} else {
> >  			c->Request.CDBLen = 16;
> >  			c->Request.CDB[1]= 0;
> > -			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
> > -			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
> > -			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> > -			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
> > -			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
> > -			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
> > -			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
> > +			c->Request.CDB[2]= ((u64)start_blk >> 56) & 0xff;	//MSB
> > +			c->Request.CDB[3]= ((u64)start_blk >> 48) & 0xff;
> > +			c->Request.CDB[4]= ((u64)start_blk >> 40) & 0xff;
> > +			c->Request.CDB[5]= ((u64)start_blk >> 32) & 0xff;
> > +			c->Request.CDB[6]= ((u64)start_blk >> 24) & 0xff;
> > +			c->Request.CDB[7]= ((u64)start_blk >> 16) & 0xff;
> > +			c->Request.CDB[8]= ((u64)start_blk >>  8) & 0xff;
> 
> 	put_unaligned(cpu_to_be64(start_blk), &c->Request.CDB[2]);
> 
> which is what's happening here anyway.

Well ... this was debated a while ago ad nauseam:

http://marc.info/?t=117699555300010

The main objection to what you propose is that it forces the u64
coercion even in the 32 bit start_blk case.  The preferred solution as a
result of that debate was simply to us a macro Andrew introduced:

upper_32_bits()

Which will silently replace zero in the non LBD case.  I actually
thought this had already been done.

James


James


