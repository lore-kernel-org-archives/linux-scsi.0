From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 02:56:39 +0200
Message-ID: <9a8748490708111756o63ddaeedja091fb2f0b4dbc40@mail.gmail.com>
References: <200708120228.26234.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:43599 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbXHLA4k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Aug 2007 20:56:40 -0400
Received: by wx-out-0506.google.com with SMTP id h31so888332wxd
        for <linux-scsi@vger.kernel.org>; Sat, 11 Aug 2007 17:56:39 -0700 (PDT)
In-Reply-To: <200708120228.26234.jesper.juhl@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>, Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com

(whoops, forgot to add maintainer to Cc - now added)

On 12/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> Hi,
>
> I've been building some randconfig kernels lately and I've noticed
> this in a few builds :
>
> drivers/block/cciss.c:2614: warning: right shift count >= width of type
> drivers/block/cciss.c:2615: warning: right shift count >= width of type
> drivers/block/cciss.c:2616: warning: right shift count >= width of type
>
> The code in question is this :
>
> static void do_cciss_request(struct request_queue *q)
> {
> ...
>         sector_t start_blk;
> ...
>                         c->Request.CDB[2]= (start_blk >> 56) & 0xff;    //MSB
>                         c->Request.CDB[3]= (start_blk >> 48) & 0xff;
>                         c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> ...
> }
>
>
> The problem stems from these lines in include/linux/types.h :
> ...
> #ifdef CONFIG_LBD
> typedef u64 sector_t;
> #else
> typedef unsigned long sector_t;
> #endif
> ...
>
> So on a 32bit arch without CONFIG_LBD, sector_t is going to be 32 bits wide.
> Thus it seems gcc is absolutely right in complaining about those
> 56, 48 & 40 bit shifts, since they are indeed wider than the type
> in the "!CONFIG_LBD on a 32bit arch" case.
>
>
> I must admit that I have no idear what the proper way to deal with
> that is, so I'll just report it so hopefully someone else can fix it.
>
> By the way; I'm building current Linus git tree, head at commit
> ac07860264bd2b18834d3fa3be47032115524cea
>
>
> Kind regards,
>   Jesper Juhl
>
>
>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
