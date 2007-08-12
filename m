From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Re: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 07:58:06 +0100
Message-ID: <20070812065806.GC21089@ftp.linux.org.uk>
References: <200708120228.26234.jesper.juhl@gmail.com> <46BE60B5.7010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759198AbXHLG6W@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46BE60B5.7010708@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 12, 2007 at 03:21:57AM +0200, Rene Herman wrote:
> @@ -2609,13 +2609,13 @@ static void do_cciss_request(request_queue_t *q)
>  		} else {
>  			c->Request.CDBLen = 16;
>  			c->Request.CDB[1]= 0;
> -			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
> -			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
> -			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> -			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
> -			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
> -			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
> -			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
> +			c->Request.CDB[2]= ((u64)start_blk >> 56) & 0xff;	//MSB
> +			c->Request.CDB[3]= ((u64)start_blk >> 48) & 0xff;
> +			c->Request.CDB[4]= ((u64)start_blk >> 40) & 0xff;
> +			c->Request.CDB[5]= ((u64)start_blk >> 32) & 0xff;
> +			c->Request.CDB[6]= ((u64)start_blk >> 24) & 0xff;
> +			c->Request.CDB[7]= ((u64)start_blk >> 16) & 0xff;
> +			c->Request.CDB[8]= ((u64)start_blk >>  8) & 0xff;

	put_unaligned(cpu_to_be64(start_blk), &c->Request.CDB[2]);

which is what's happening here anyway.
