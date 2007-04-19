From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bit  environment
Date: Thu, 19 Apr 2007 15:09:10 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:59233 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766786AbXDSPJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 11:09:29 -0400
Content-class: urn:content-classes:message
In-Reply-To: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Cameron, Steve" <steve.cameron@hp.com>

 

> -----Original Message-----
> From: Hisashi Hifumi [mailto:hifumi.hisashi@oss.ntt.co.jp] 
> Sent: Wednesday, April 18, 2007 2:03 AM
> To: Miller, Mike (OS Dev); akpm@linux-foundation.org
> Subject: [PATCH] cciss: Fix warnings during compilation under 
> 32bit environment
> 
> 
> Hi.
> 
> I fixed following warnings.
> 
> drivers/block/cciss.c: In function `do_cciss_request':
> drivers/block/cciss.c:2555: warning: right shift count >= 
> width of type
> drivers/block/cciss.c:2556: warning: right shift count >= 
> width of type
> drivers/block/cciss.c:2557: warning: right shift count >= 
> width of type
> drivers/block/cciss.c:2558: warning: right shift count >= 
> width of type
> 
> 
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

Nak. You still haven't told where you saw these warnings. What compiler
are you using? I do not see these in my 32-bit environment.

mikem

> 
> 
> --- linux-2.6.21-rc7.org/drivers/block/cciss.c	2007-04-17 
> 16:36:02.000000000 +0900
> +++ linux-2.6.21-rc7/drivers/block/cciss.c	2007-04-17 
> 16:25:53.000000000 +0900
> @@ -2552,10 +2552,10 @@ static void do_cciss_request(request_que
>   	} else {
>   		c->Request.CDBLen = 16;
>   		c->Request.CDB[1]= 0;
> -		c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
> -		c->Request.CDB[3]= (start_blk >> 48) & 0xff;
> -		c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> -		c->Request.CDB[5]= (start_blk >> 32) & 0xff;
> +		c->Request.CDB[2]= sizeof(start_blk) > 4 ? 
> (start_blk >> 56) & 0xff : 0;	//MSB
> +		c->Request.CDB[3]= sizeof(start_blk) > 4 ? 
> (start_blk >> 48) & 0xff : 0;
> +		c->Request.CDB[4]= sizeof(start_blk) > 4 ? 
> (start_blk >> 40) & 0xff : 0;
> +		c->Request.CDB[5]= sizeof(start_blk) > 4 ? 
> (start_blk >> 32) & 0xff : 
> +0;
>   		c->Request.CDB[6]= (start_blk >> 24) & 0xff;
>   		c->Request.CDB[7]= (start_blk >> 16) & 0xff;
>   		c->Request.CDB[8]= (start_blk >>  8) & 0xff;
> 
> 
> 
> Thanks,
> 
