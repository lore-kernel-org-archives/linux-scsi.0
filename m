From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion (mpt_attach())
Date: Thu, 2 Aug 2007 10:20:47 +0200
Message-ID: <9a8748490708020120w4bbfe6d1n6f6986aec507316@mail.gmail.com>
References: <200708020155.33690.jesper.juhl@gmail.com>
	 <20070801172653.1fd44e99.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:38677 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXHBIUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 04:20:49 -0400
Received: by rv-out-0910.google.com with SMTP id k20so357730rvb
        for <linux-scsi@vger.kernel.org>; Thu, 02 Aug 2007 01:20:48 -0700 (PDT)
In-Reply-To: <20070801172653.1fd44e99.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, support@lsi.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 02/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 2 Aug 2007 01:55:33 +0200
> Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
[snip]
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -1393,18 +1393,18 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> >       struct proc_dir_entry *dent, *ent;
> >  #endif
> >
> > +     if (mpt_debug_level)
> > +             printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
> > +
> > +     if (pci_enable_device(pdev))
> > +             return r;
> > +
> >       ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
>
> Why on earth is that using GFP_ATOMIC?  This function later goes on to
> create procfs files and such things.
>
Dunno. But you are right, that does seem a bit odd, but I assumed
there was a reason for it.

>
> y'know, we could have a debug option which will spit warnings if someone
> does a !__GFP_WAIT allocation while !in_atomic() (only works if
> CONFIG_PREEMPT).
>
> But please, make it depend on !CONFIG_AKPM.  I shudder to think about all
> the stuff it would pick up.
>

I can try to cook up something like that tonight...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
