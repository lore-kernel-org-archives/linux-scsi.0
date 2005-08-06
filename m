From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH 1/2] cpqfc: fix for "Using too much stach" in 2.6 kernel
Date: Sat, 6 Aug 2005 03:13:09 +0200
Message-ID: <9a87484905080518133e0cdaf6@mail.gmail.com>
References: <4221C1B21C20854291E185D1243EA8F302623BCC@bgeexc04.asiapacific.cpqcorp.net>
	 <9a87484905080406533ad143f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.193]:17620 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261802AbVHFBNK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 21:13:10 -0400
Received: by zproxy.gmail.com with SMTP id i11so422856nzh
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2005 18:13:09 -0700 (PDT)
In-Reply-To: <9a87484905080406533ad143f9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saripalli, Venkata Ramanamurthy (STSD)" <saripalli@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, Rolf Eike Beer <eike-kernel@sf-tec.de>

On 8/4/05, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 8/4/05, Saripalli, Venkata Ramanamurthy (STSD) <saripalli@hp.com> wrote:
> > Patch 1 of 2
> >
> > This patch fixes the "#error this is too much stack" in 2.6 kernel.
> > Using kmalloc to allocate memory to ulFibreFrame.
> >
> [snip]
> >            if( fchs->pl[0] == ELS_LILP_FRAME)
> >           {
> > +           kfree(ulFibreFrame);
> >              return 1; // found the LILP frame!
> >           }
> >           else
> >           {
> > +           kfree(ulFibreFrame);
> >             // keep looking...
> >           }
> 
> The first thing you do in either branch is to call
> kfree(ulFibreFrame); , so instead of having the call in both branches
> you might as well just have one call before the if().  Ohh and this
> looks like it could do with a CodingStyle cleanup as well.
> 
> kfree(ulFibreFrame);
> if (fchs->pl[0] == ELS_LILP_FRAME)
>         return 1; /* found the LILP frame! */
> /* keep looking */

Whoops, as Rolf Eike Beer pointed out to me, I snipped one line too many. 
  fchs = (TachFCHDR_GCMND*)ulFibreFrame;
So, the kfree inside each branch is correct. Freeing it just before
the if would be wrong.
Sorry about that.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
